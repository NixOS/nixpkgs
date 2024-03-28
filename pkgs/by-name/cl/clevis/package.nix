{ lib
, asciidoc
, bash
, coreutils
, cryptsetup
, curl
, fetchFromGitHub
, gnugrep
, gnused
, jansson
, jose
, jq
, libpwquality
, luksmeta
, makeWrapper
, meson
, ninja
, nixosTests
, pkg-config
, stdenv
, tpm2-tools
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clevis";
  version = "20";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "clevis";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-rBdZrnHPzRd9vbyl1h/Nb0cFAtIPUHSmxVoKrKuCrQ8=";
  };

  outputs = [ "out" "man" ];

  patches = [
    # Replaces the clevis-decrypt 300s timeout to a 10s timeout
    # https://github.com/latchset/clevis/issues/289
    ./001-tang-timeout.patch
  ];

  postPatch = ''
    for f in $(find src/ -type f); do
      grep -q "/bin/cat" "$f" && \
      substituteInPlace "$f" \
        --replace-fail '/bin/cat' '${coreutils}/bin/cat' || true
    done
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    asciidoc
    cryptsetup
    jq
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    bash
    curl
    jansson
    jose
    libpwquality
    luksmeta
    tpm2-tools
  ];

  strictDeps = true;

  postFixup = let
    binPath = lib.makeBinPath [
      coreutils
      cryptsetup
      gnugrep
      gnused
      jose
      libpwquality
      luksmeta
      tpm2-tools
    ];
    # We wrap the main clevis binary entrypoint - but not the sub-command
    # binaries
  in ''
    patchShebangs --host $out/bin/clevis
    wrapProgram $out/bin/clevis \
      --prefix PATH ':' "${binPath}:${placeholder "out"}/bin"
  '';

  passthru.tests = {
    inherit (nixosTests.installer)
      clevisBcachefs clevisBcachefsFallback clevisLuks clevisLuksFallback
      clevisZfs clevisZfsFallback;
    clevisLuksSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuks;
    clevisLuksFallbackSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuksFallback;
    clevisZfsSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfs;
    clevisZfsFallbackSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfsFallback;
  };

  meta = {
    description = "Automated Encryption Framework";
    homepage = "https://github.com/latchset/clevis";
    changelog = "https://github.com/latchset/clevis/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "clevis";
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
})

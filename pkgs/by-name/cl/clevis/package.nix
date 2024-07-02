{
  lib,
  asciidoc,
  bash,
  coreutils,
  cryptsetup,
  curl,
  fetchFromGitHub,
  gnugrep,
  gnused,
  jansson,
  jose,
  jq,
  libpwquality,
  luksmeta,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  pkg-config,
  stdenv,
  tpm2-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clevis";
  version = "19";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "clevis";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-3J3ti/jRiv+p3eVvJD7u0ko28rPd8Gte0mCJaVaqyOs=";
  };

  outputs = [
    "out"
    "man"
  ];

  patches = [
    # Replaces the clevis-decrypt 300s timeout to a 10s timeout
    # https://github.com/latchset/clevis/issues/289
    ./0001-tang-timeout.patch
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

  # somehow, by setting strictDeps as true the checks fail miserably
  strictDeps = false;

  postPatch = ''
    find src/ -type f -exec grep -q "/bin/cat" {} \; |\
    while read f; do
      echo $f
      substituteInPlace "$f" \
        --replace-fail '/bin/cat' '${coreutils}/bin/cat'
    done
  '';

  postFixup =
    let
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
    in
    # We wrap the main clevis binary entrypoint - but not the sub-command
    # binaries
    ''
      patchShebangs --host $out/bin/clevis
      wrapProgram $out/bin/clevis \
        --prefix PATH ':' "${binPath}:${placeholder "out"}/bin"
    '';

  passthru.tests = {
    inherit (nixosTests.installer)
      clevisBcachefs
      clevisBcachefsFallback
      clevisLuks
      clevisLuksFallback
      clevisZfs
      clevisZfsFallback
      ;
    clevisLuksFallbackSystemdStage1 =
      nixosTests.installer-systemd-stage-1.clevisLuksFallback;
    clevisLuksSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuks;
    clevisZfsFallbackSystemdStage1 =
      nixosTests.installer-systemd-stage-1.clevisZfsFallback;
    clevisZfsSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfs;
  };

  meta = {
    description = "Automated Encryption Framework";
    homepage = "https://github.com/latchset/clevis";
    changelog = "https://github.com/latchset/clevis/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "clevis";
    maintainers = with lib.maintainers; [ ];
  };
})

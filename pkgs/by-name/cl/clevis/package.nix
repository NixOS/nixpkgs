{
  lib,
  asciidoc,
  coreutils,
  cryptsetup,
  curl,
  fetchFromGitHub,
  gnugrep,
  gnused,
  jansson,
  jose,
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

  patches = [
    # Replaces the clevis-decrypt 300s timeout to a 10s timeout
    # https://github.com/latchset/clevis/issues/289
    ./0000-tang-timeout.patch
  ];

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cryptsetup
    curl
    jansson
    jose
    libpwquality
    luksmeta
    tpm2-tools
  ];

  outputs = [
    "out"
    "man"
  ];

  postPatch = ''
    for f in $(find src/ -type f); do
      grep -q "/bin/cat" "$f" && substituteInPlace "$f" \
        --replace-fail '/bin/cat' '${lib.getExe' coreutils "cat"}' || true
    done
  '';

  # We wrap the main clevis binary entrypoint but not the sub-binaries.
  postInstall =
    let
      includeIntoPath = [
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
    ''
      wrapProgram $out/bin/clevis \
        --prefix PATH ':' "${lib.makeBinPath includeIntoPath}:${placeholder "out"}/bin"
    '';

  passthru.tests = {
    inherit (nixosTests.installer) clevisBcachefs clevisBcachefsFallback clevisLuks clevisLuksFallback clevisZfs clevisZfsFallback;
    clevisLuksSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuks;
    clevisLuksFallbackSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisLuksFallback;
    clevisZfsSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfs;
    clevisZfsFallbackSystemdStage1 = nixosTests.installer-systemd-stage-1.clevisZfsFallback;
  };

  meta = {
    homepage = "https://github.com/latchset/clevis";
    description = "Automated Encryption Framework";
    longDescription = ''
      Clevis is a pluggable framework for automated decryption. It can be used
      to provide automated decryption of data or even automated unlocking of
      LUKS volumes.
    '';
    changelog = "https://github.com/latchset/clevis/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
})

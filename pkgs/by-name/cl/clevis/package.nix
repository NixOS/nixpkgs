{
  lib,
  asciidoc-full,
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
  version = "21";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "clevis";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-2vDQP+yvH4v46fLEWG/37r5cYP3OeDfJz71cDHEGiUg=";
  };

  patches = [
    # Replaces the clevis-decrypt 300s timeout to a 10s timeout
    # https://github.com/latchset/clevis/issues/289
    ./0000-tang-timeout.patch
  ];

  nativeBuildInputs = [
    asciidoc-full
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

  # TODO: investigate how to prepare the dependencies so that they can be found
  # while setting strictDeps as true. This will require studying the dark
  # corners of cross-compilation in Nixpkgs...
  strictDeps = false;

  # Since 2018-07-11, upstream relies on a hardcoded /bin/cat. See:
  # https://github.com/latchset/clevis/issues/61
  # https://github.com/latchset/clevis/pull/64
  #
  # So, we filter all src files that have the string "/bin/cat" and patch that
  # string to an absolute path for our coreutils location.
  # The xargs command is a little bit convoluted because a simpler version would
  # be vulnerable to code injection. This hint is a courtesy of Stack Exchange:
  # https://unix.stackexchange.com/a/267438
  postPatch = ''
    for f in $(find src/ -type f -print0 |\
                 xargs -0 -I@ sh -c 'grep -q "/bin/cat" "$1" && echo "$1"' sh @); do
      substituteInPlace "$f" --replace-fail '/bin/cat' '${lib.getExe' coreutils "cat"}'
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
    inherit (nixosTests.installer)
      clevisBcachefs
      clevisBcachefsFallback
      clevisLuks
      clevisLuksFallback
      clevisZfs
      clevisZfsFallback
      ;
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

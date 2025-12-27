{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libcxx,
  zlib,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "splitcode";
  version = "0.31.6";

  src = fetchFromGitHub {
    owner = "pachterlab";
    repo = "splitcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-80XrLr6gk398a/JVSpb8j0i2pMEDKn0EnTiSw7cWS2c=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcxx
    zlib
  ];

  doCheck = true;
  checkPhase = ''
    mkdir func_tests
    cp $src/func_tests/* ./func_tests/
    bash ./func_tests/runtests.sh
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for flexible, efficient parsing, interpreting, and editing of technical sequences in sequencing reads";
    homepage = "https://github.com/pachterlab/splitcode";
    license = lib.licenses.bsd2;
    # also compiles on macos, but since it seems to return invalid results.
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zimward ];
    mainProgram = "splitcode";
    badPlatforms = [
      # Test hangs indefinitely. See https://github.com/pachterlab/splitcode/issues/31
      "aarch64-linux"
    ];
  };
})

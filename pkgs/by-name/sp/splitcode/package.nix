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
  version = "0.31.5";

  src = fetchFromGitHub {
    owner = "pachterlab";
    repo = "splitcode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-x2N+IQHB6gbEKTEofsWy7SwVf1lvRxh5f93avtAs8fM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcxx
    zlib
  ];

  postPatch = ''
    # https://github.com/pachterlab/splitcode/pull/46
    substituteInPlace CMakeLists.txt \
      --replace-fail 2.8.12 3.10
  '';

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
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ zimward ];
    mainProgram = "splitcode";
    badPlatforms = [
      # Test hangs indefinitely. See https://github.com/pachterlab/splitcode/issues/31
      "aarch64-linux"
    ];
  };
})

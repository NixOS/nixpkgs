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
<<<<<<< HEAD
  version = "0.31.6";
=======
  version = "0.31.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pachterlab";
    repo = "splitcode";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-80XrLr6gk398a/JVSpb8j0i2pMEDKn0EnTiSw7cWS2c=";
=======
    hash = "sha256-jaZptrF5HSQSe2KQdBNPprhsVZ2FSudZFgWPn9zQq3A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libcxx
    zlib
  ];

<<<<<<< HEAD
=======
  postPatch = ''
    # https://github.com/pachterlab/splitcode/pull/46
    substituteInPlace CMakeLists.txt \
      --replace-fail 2.8.12 3.10
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    # also compiles on macos, but since it seems to return invalid results.
    platforms = lib.platforms.linux;
=======
    platforms = lib.platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ zimward ];
    mainProgram = "splitcode";
    badPlatforms = [
      # Test hangs indefinitely. See https://github.com/pachterlab/splitcode/issues/31
      "aarch64-linux"
    ];
  };
})

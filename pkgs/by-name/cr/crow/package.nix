{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2_3,
  asio,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow";
<<<<<<< HEAD
  version = "1.3.0.0";
=======
  version = "1.2.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "CrowCpp";
    repo = "Crow";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-QLYQ0RouqDDvhnBF79O/9M7IwlF0eQ3HTqR6bXWm574=";
=======
    hash = "sha256-iQ2owNry4LOmMxyO5L7O7XZB5vwUf+ZuZL76hZ6FThk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [
    ./cpm.patch
  ];

  propagatedBuildInputs = [ asio ];
  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "CROW_BUILD_EXAMPLES" false)
<<<<<<< HEAD
    # Requires more non-trivial patches to get around CPM
    (lib.cmakeBool "CROW_GENERATE_SBOM" false)
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  doCheck = true;
  nativeCheckInputs = [
    python3
  ];
  checkInputs = [
    catch2_3
  ];

  meta = {
    description = "Fast and Easy to use microframework for the web";
    homepage = "https://crowcpp.org/";
    maintainers = with lib.maintainers; [ l33tname ];
    platforms = lib.platforms.all;
    license = lib.licenses.bsd3;
  };
})

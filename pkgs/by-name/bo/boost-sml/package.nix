{
  stdenv,
  lib,
  cmake,
  fetchFromGitHub,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "boost-sml";
<<<<<<< HEAD
  version = "1.1.13";
=======
  version = "1.1.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "sml";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VgJl09kCRCXBF/IraVbAVowrrMJH0NFcblQAKVQwl6w=";
=======
    hash = "sha256-IvZwkhZe9pcyJhZdn4VkWMRUN6Ow8qs3zB6JtWb5pKk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  buildInputs = [ boost ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSML_BUILD_BENCHMARKS=OFF"
    "-DSML_BUILD_EXAMPLES=OFF"
    "-DSML_BUILD_TESTS=ON"
    "-DSML_USE_EXCEPTIONS=ON"
  ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Header only state machine library with no dependencies";
    homepage = "https://github.com/boost-ext/sml";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ prtzl ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Header only state machine library with no dependencies";
    homepage = "https://github.com/boost-ext/sml";
    license = licenses.boost;
    maintainers = with maintainers; [ prtzl ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

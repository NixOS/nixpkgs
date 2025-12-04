{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  catch2,
}:

stdenv.mkDerivation rec {
  pname = "jarowinkler-cpp";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "maxbachmann";
    repo = "jarowinkler-cpp";
    rev = "v${version}";
    hash = "sha256-GuwDSCYTfSwqTnzZSft3ufVSKL7255lVvbJhBxKxjJw=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = lib.optionals doCheck [
    "-DJARO_WINKLER_BUILD_TESTING=ON"
  ];

  nativeCheckInputs = [
    catch2
  ];

  doCheck = true;

  meta = {
    description = "Fast Jaro and Jaro-Winkler distance";
    homepage = "https://github.com/maxbachmann/jarowinkler-cpp";
    changelog = "https://github.com/maxbachmann/jarowinkler-cpp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
}

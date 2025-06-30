{
  cmake,
  eigen,
  fetchFromGitHub,
  gtest,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eigenrand";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "bab2min";
    repo = "EigenRand";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mrpkWIb6kfLvppmIfzhjF1/3m1zSd8XG1D07V6Zjlu0=";
  };

  # Avoid downloading googletest: we already have it.
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "FetchContent_MakeAvailable(googletest)" \
      "add_subdirectory(${gtest.src} googletest SYSTEM)"

    # broken by https://gitlab.com/libeigen/eigen/-/merge_requests/688
    # ref. https://github.com/NixOS/nixpkgs/pull/364362
    rm test/test_mv.cpp
  '';

  postInstall = ''
    # Remove installed tests and googletest stuff
    rm -rf $out/bin $out/include/gmock $out/include/gtest $out/lib
  '';

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ eigen ];
  checkInputs = [ gtest ];

  doCheck = true;

  cmakeFlags = [ "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;EigenRand-test" ];

  meta = {
    description = "Fastest Random Distribution Generator for Eigen";
    homepage = "https://github.com/bab2min/EigenRand";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})

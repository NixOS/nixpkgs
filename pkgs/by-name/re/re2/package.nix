{
  abseil-cpp,
  chromium,
  cmake,
  fetchFromGitHub,
  gbenchmark,
  grpc,
  gtest,
  haskellPackages,
  icu,
  lib,
  mercurial,
  ninja,
  python3Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "re2";
  version = "2024-07-02";

  src = fetchFromGitHub {
    owner = "google";
    repo = "re2";
    rev = finalAttrs.version;
    hash = "sha256-IeANwJlJl45yf8iu/AZNDoiyIvTCZIeK1b74sdCfAIc=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    gbenchmark
    gtest
  ];

  propagatedBuildInputs = [ abseil-cpp ] ++ lib.optionals (!stdenv.hostPlatform.isStatic) [ icu ];

  cmakeFlags =
    [ (lib.cmakeBool "RE2_BUILD_TESTING" true) ]
    ++ lib.optionals (!stdenv.hostPlatform.isStatic) [
      (lib.cmakeBool "RE2_USE_ICU" true)
      (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    ];

  doCheck = true;

  passthru.tests = {
    inherit chromium grpc mercurial;
    inherit (python3Packages) fb-re2 google-re2;
    haskell-re2 = haskellPackages.re2;
  };

  meta = with lib; {
    description = "Regular expression library";
    longDescription = ''
      RE2 is a fast, safe, thread-friendly alternative to backtracking regular
      expression engines like those used in PCRE, Perl, and Python. It is a C++
      library.
    '';
    license = licenses.bsd3;
    homepage = "https://github.com/google/re2";
    maintainers = with maintainers; [
      azahi
      networkexception
    ];
    platforms = platforms.all;
  };
})

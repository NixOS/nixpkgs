{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:
let
  testData = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json_test_data";
    rev = "v3.1.0";
    hash = "sha256-bG34W63ew7haLnC82A3lS7bviPDnApLipaBjJAjLcVk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nlohmann_json";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cECvDOLxgX7Q9R3IE86Hj9JJUxraDQvhoyPDF03B2CY=";
  };

  patches = [
    # Fix missing char8_t support
    # https://github.com/nlohmann/json/pull/4736
    (fetchpatch {
      name = "fix-char8_t.patch";
      url = "https://github.com/nlohmann/json/commit/756ca22ec5b0d89b5d107b4c30891d1293650c87.patch?full_index=1";
      hash = "sha256-OK8FIXClj5paZNiEvPwJWr5PxyVYtJ3zkRlcZoe8d20=";
    })
    # Musl does not support LC_NUMERIC, causing a test failure.
    # Turn the error into a warning to make the test succeed.
    # https://github.com/nlohmann/json/pull/4770
    (fetchpatch {
      url = "https://github.com/nlohmann/json/commit/0a8b48ac6a89131deaeb0d57047c9462a23b34a2.diff";
      hash = "sha256-gOZfRyDRI6USdUIY+sH7cygPrSIKGIo8AWcjqc/GQNI=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # .pc file uses INCLUDEDIR as a relative path
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DJSON_BuildTests=${if finalAttrs.finalPackage.doCheck then "ON" else "OFF"}"
    "-DJSON_FastTests=ON"
    "-DJSON_MultipleHeaders=ON"
  ]
  ++ lib.optional finalAttrs.finalPackage.doCheck "-DJSON_TestDataDirectory=${testData}";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # skip tests that require git or modify “installed files”
  preCheck = ''
    checkFlagsArray+=("ARGS=-LE 'not_reproducible|git_required'")
  '';

  postInstall = "rm -rf $out/lib64";

  meta = with lib; {
    description = "JSON for Modern C++";
    homepage = "https://json.nlohmann.me";
    changelog = "https://github.com/nlohmann/json/blob/develop/ChangeLog.md";
    license = licenses.mit;
    platforms = platforms.all;
  };
})

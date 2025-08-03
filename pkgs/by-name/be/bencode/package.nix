{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  catch2,
  expected-lite,
  fmt,
  gsl-lite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bencode";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "fbdtemme";
    repo = "bencode";
    tag = finalAttrs.version;
    hash = "sha256-zpxvADZfYTUdlNLMZJSCanPL40EGl9BBCxR7oDhvOTw=";
  };

  postPatch =
    # Disable a test that requires an internet connection.
    ''
      substituteInPlace tests/CMakeLists.txt \
        --replace-fail "add_subdirectory(cmake_fetch_content)" ""
    ''
    # Replace the modern gsl-lite header with the legacy compatibility header,
    # so that unqualified symbols like `Expects()` and `Ensures()` are available
    # in the global `gsl` namespace as expected by the bencode library
    + ''
      for f in include/bencode/detail/*.hpp; do
        substituteInPlace "$f" \
          --replace-quiet "#include <gsl-lite/gsl-lite.hpp>" "#include <gsl/gsl-lite.hpp>"
      done
    '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    catch2
    expected-lite
    fmt
    gsl-lite
  ];

  doCheck = true;

  postInstall = ''
    rm -rf $out/lib64
  '';

  meta = {
    # Broken because the default stdenv on these targets doesn't support C++20.
    broken =
      stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    changelog = "https://github.com/fbdtemme/bencode/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Header-only C++20 bencode serialization/deserialization library";
    homepage = "https://github.com/fbdtemme/bencode";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

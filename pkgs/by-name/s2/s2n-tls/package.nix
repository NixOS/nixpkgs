{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  openssl,
  ctestCheckHook,
  nix,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "s2n-tls";
  version = "1.7.12";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "s2n-tls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2DbRhS4TQCK8ttFLVlIL9QYa1LHMJSoZWF9q7qVqGaY=";
  };

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [ openssl ];

  propagatedBuildInputs = [ openssl ]; # s2n-config has find_dependency(LibCrypto).

  cmakeFlags = [ (lib.cmakeBool "BUILD_SHARED_LIBS" true) ];

  doCheck = true;
  dontUseNinjaCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];
  # attempt to access system cert store paths, which doesn't work in the sandbox
  disabledTests = [
    "s2n_config_test"
    "s2n_x509_validator_test"
  ];

  postInstall = ''
    moveToOutput lib/s2n/cmake "$dev"

    # Glob for 'shared' or 'static' subdir
    for f in $dev/lib/s2n/cmake/*/s2n-targets.cmake; do
      substituteInPlace "$f" \
        --replace-fail 'INTERFACE_INCLUDE_DIRECTORIES "''${_IMPORT_PREFIX}/include"' 'INTERFACE_INCLUDE_DIRECTORIES ""'
    done
  '';

  passthru.tests = {
    inherit nix;
  };

  __structuredAttrs = true;

  meta = {
    description = "C99 implementation of the TLS/SSL protocols";
    homepage = "https://github.com/aws/s2n-tls";
    changelog = "https://github.com/aws/s2n-tls/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})

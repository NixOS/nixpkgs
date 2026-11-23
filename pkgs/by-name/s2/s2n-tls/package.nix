{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  openssl,
  nix,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "s2n-tls";
  version = "1.7.14";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "s2n-tls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GkRkhfOZsUn35A7S0EExxNcsVN5nudhdgKuEhfJto+w=";
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
  preCheck = "unset NIX_SSL_CERT_FILE";

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

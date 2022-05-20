{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tilt";
  /* Do not use "dev" as a version. If you do, Tilt will consider itself
    running in development environment and try to serve assets from the
    source tree, which is not there once build completes.  */
  version = "0.30.0";

  src = fetchFromGitHub {
    owner  = "tilt-dev";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "sha256-bZYm9T3NRNNtT8RDGwnXcXC7Rb/GuIxI/U06By4gR/w=";
  };
  vendorSha256 = null;

  subPackages = [ "cmd/tilt" ];

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    description = "Local development tool to manage your developer instance when your team deploys to Kubernetes in production";
    homepage = "https://tilt.dev/";
    license = licenses.asl20;
    maintainers = with maintainers; [ anton-dessiatov ];

    # TODO: Remove once nixpkgs uses macOS SDK 10.14+ for x86_64-darwin
    # Undefined symbols for architecture x86_64:
    # "_SecTrustEvaluateWithError", referenced from:
    #     _crypto/x509/internal/macos.x509_SecTrustEvaluateWithError_trampoline.abi0 in go.o
    # "_utimensat", referenced from:
    #     _syscall.libc_utimensat_trampoline.abi0 in go.o
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}

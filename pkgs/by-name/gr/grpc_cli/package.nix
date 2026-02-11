{
  lib,
  stdenv,
  fetchFromGitHub,
  automake,
  cmake,
  autoconf,
  curl,
  numactl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "grpc_cli";
  version = "1.78.0";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hupso9w++lYtAMoLS/qVmUYqZyQAX3rH0I8zCLyBo40=";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    automake
    cmake
    autoconf
  ];
  buildInputs = [
    curl
    numactl
  ];
  cmakeFlags = [ "-DgRPC_BUILD_TESTS=ON" ];
  makeFlags = [ "grpc_cli" ];
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isAarch64 "-Wno-error=format-security";
  installPhase = ''
    runHook preInstall

    install -Dm555 grpc_cli "$out/bin/grpc_cli"

    runHook postInstall
  '';
  meta = {
    description = "Command line tool for interacting with grpc services";
    homepage = "https://github.com/grpc/grpc";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "grpc_cli";
  };
})

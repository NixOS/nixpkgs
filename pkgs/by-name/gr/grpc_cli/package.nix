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

stdenv.mkDerivation rec {
  pname = "grpc_cli";
  version = "1.67.1";
  src = fetchFromGitHub {
    owner = "grpc";
    repo = "grpc";
    rev = "v${version}";
    hash = "sha256-x49mh7gLliAiFjOZM5U/CnMQqs7fAhoipo18OBoeD0w=";
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
  meta = with lib; {
    description = "Command line tool for interacting with grpc services";
    homepage = "https://github.com/grpc/grpc";
    license = licenses.asl20;
    maintainers = with maintainers; [ doriath ];
    platforms = platforms.linux;
    mainProgram = "grpc_cli";
  };
}

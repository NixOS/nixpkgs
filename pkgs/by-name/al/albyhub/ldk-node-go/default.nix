{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "ldk-node-go";
  version = "unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "ldk-node-go";
    rev = "8911834564db720e9b22950441df706d69622d81";
    hash = "sha256-vjXpvjPZlxOiTrcEbQW8YTnpQx7XbmPqYda+8UYyUvE=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  installPhase = ''
    mkdir -p $out/lib
    case ${stdenv.hostPlatform.parsed.cpu.name} in
      x86_64|aarch64)
        cp -v "${src}/ldk_node/${stdenv.hostPlatform.parsed.cpu.name}-unknown-linux-gnu/libldk_node.so" $out/lib/
        ;;
      *)
        echo "Unsupported architecture: ${stdenv.hostPlatform.parsed.cpu.name}"
        exit 1
        ;;
    esac
  '';

  meta = {
    description = "Experimental Go bindings for LDK-node";
    homepage = "https://github.com/getAlby/ldk-node-go";
    license = lib.licenses.asl20; # https://github.com/getAlby/ldk-node-go/issues/27
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "glalby-go";
  version = "unstable-2024-06-21";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "glalby-go";
    rev = "95673c864d5954a6f78a24600876784b81af799f";
    hash = "sha256-DwYOJkk0VzCMzHMUM+C31Kq8e6jIsBZNBQLgpylOe4E=";
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
        cp -v "${src}/glalby/${stdenv.hostPlatform.parsed.cpu.name}-unknown-linux-gnu/libglalby_bindings.so" $out/lib/
        ;;
      *)
        echo "Unsupported architecture: ${stdenv.hostPlatform.parsed.cpu.name}"
        exit 1
        ;;
    esac
  '';

  meta = {
    description = "Go bindings for https://github.com/getalby/glalby";
    homepage = "https://github.com/getAlby/glalby-go";
    license = lib.licenses.asl20; # https://github.com/getAlby/ldk-node-go/issues/27
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}

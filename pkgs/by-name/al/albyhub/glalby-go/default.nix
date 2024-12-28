{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "glalby-go";
  version = "95673c864d5954a6f78a24600876784b81af799f";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = pname;
    rev = version;
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
    description = "Prebuilt Go bindings for Alby's Greenlight wrapper library";
    homepage = "https://github.com/getAlby/glalby-go";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}

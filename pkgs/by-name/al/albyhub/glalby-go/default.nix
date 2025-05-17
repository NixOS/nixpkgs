{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "glalby-go";
  version = "v0.0.0-20240621192717-95673c864d59";

  src = fetchFromGitHub {
    owner = "getAlby";
    repo = "glalby-go";
    rev = version;
    hash = "sha256-DwYOJkk0VzCMzHMUM+C31Kq8e6jIsBZNBQLgpylOe4E=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  installPhase = ''
    runHook preInstall
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
    runHook postInstall
  '';

  meta = {
    description = "Prebuilt Go bindings for Alby's Greenlight wrapper library";
    homepage = "https://github.com/getAlby/glalby-go";
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ bleetube ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  go,
}:

buildGoModule rec {
  pname = "breez-sdk-go";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "breez";
    repo = "breez-sdk-go";
    rev = "v${version}";
    hash = "sha256-zE8GIMi/YopprNVT3rAGqykosCtuKKnVHBSObdp/ONo=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  installPhase = ''
    mkdir -p $out/lib
    case ${go.GOARCH} in
      amd64|aarch64)
        cp -v "${src}/breez_sdk/lib/linux-${go.GOARCH}/libbreez_sdk_bindings.so" $out/lib/
        ;;
      *)
        echo "Unsupported architecture: ${go.GOARCH}"
        exit 1
        ;;
    esac
  '';

  meta = {
    description = "Embeds the BreezSDK runtime compiled as shared library objects";
    homepage = "https://github.com/breez/breez-sdk-go/";
    license = lib.licenses.mit;
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ bleetube ];
  };
}

{
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amnezia-xray";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-xray-bindings";
    tag = "v${version}";
    hash = "sha256-kGtRw5Ic/++1ehwLToZ96WfC3ULp+DIsPYArqjL06ck=";
  };

  vendorHash = "sha256-JAHpQUMQT6tJKwGld0QCobDxgLVujA4KHkhOLXHS65w=";

  env.CGO_ENABLED = 1;

  buildPhase = ''
    runHook preBuild

    mkdir -p build
    go build -buildmode=c-archive -trimpath -ldflags="-w -s" -o build/amnezia_xray.a .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/amnezia_xray.a $out/lib/libamnezia_xray.a
    install -Dm444 build/amnezia_xray.h -t $out/include/

    runHook postInstall
  '';
}

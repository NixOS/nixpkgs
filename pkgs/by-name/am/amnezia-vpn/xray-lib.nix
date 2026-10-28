{
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "amnezia-xray";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-xray-bindings";
    tag = "v${version}";
    hash = "sha256-lvU3bDzd5kgYl5DjdglnQzgjPwhtczxWu6LyxeVvVXE=";
  };

  vendorHash = "sha256-L05GHzj9lyFAm9JgR8ZDQf+2auumug6PcoD1F4ozk3E=";

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

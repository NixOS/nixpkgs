{
  fetchFromGitHub,
  buildGo126Module,
}:

buildGo126Module rec {
  pname = "amnezia-xray";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "amnezia-xray-bindings";
    tag = "v${version}";
    hash = "sha256-HZ6qHHDMev8FoOIplWAaPOlCSfikpgKClvbxl+877S0=";
  };

  vendorHash = "sha256-ac+wJrwdTtLFJG+Ka1Ksb1P+3lI7sFwCh4Nr5+fPgq0=";

  env.CGO_ENABLED = 1;

  buildPhase = ''
    runHook preBuild

    mkdir -p build
    go build -buildmode=c-archive -trimpath -ldflags="-w -s" -o build/amnezia_xray.a .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 build/amnezia_xray.a -t $out/lib/
    install -Dm444 build/amnezia_xray.h -t $out/include/

    runHook postInstall
  '';
}

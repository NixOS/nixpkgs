{
  lib,
  buildGoModule,
  fetchFromGitHub,
  replaceVars,
  v2ray-domain-list-community,
}:

let
  patch = replaceVars ./main.go {
    geosite_data = "${v2ray-domain-list-community}/share/v2ray/geosite.dat";
  };
in
buildGoModule {
  pname = "sing-geosite";
  inherit (v2ray-domain-list-community) version;

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-geosite";
    rev = "bbd9f11bb9245463bf9d5614b74014fe5803b989";
    hash = "sha256-UQChYKgN5JZk+KZ2c5Ffh/rQi6/TVeFQkbH6mpLx4x8=";
  };

  vendorHash = "sha256-C6idJDUp6AFe50tQ+4mmZsxuOKH8JSeC1p7XVRZ224E=";

  patchPhase = ''
    sed -i -e '/func main()/,/^}/d' -e '/"io"/a "io/ioutil"' main.go
    cat ${patch} >> main.go
  '';

  buildPhase = ''
    runHook preBuild
    go run -v .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 geosite.db $out/share/sing-box/geosite.db
    install -Dm644 rule-set/* -t $out/share/sing-box/rule-set
    runHook postInstall
  '';

  meta = with lib; {
    description = "community managed domain list";
    homepage = "https://github.com/SagerNet/sing-geosite";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ linsui ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  v2ray-domain-list-community,
}:
buildGoModule (finalAttrs: {
  pname = "sing-geosite";
  inherit (v2ray-domain-list-community) version;

  src = fetchFromGitHub {
    owner = "SagerNet";
    repo = "sing-geosite";
    tag = "20250326132209";
    hash = "sha256-l9YjoxKxsEbWjhMuZC0NDsDjEQySdjdr34ix1NWNMlM=";
  };

  vendorHash = "sha256-35sCpEfelXcx8jQaOx7TO+X39NPuhStFmbLyLFooQcc=";

  patchPhase = ''
    sed -i main.go \
      -e '/"io"/a "io/ioutil"' \
      -e '/func main(/,/^}/d'

    substituteInPlace main.go --replace-fail \
      'vData, err := download(release)' \
      'vData, err := ioutil.ReadFile("${v2ray-domain-list-community}/share/v2ray/geosite.dat")'

    cat << EOF >> main.go
    func main() {
      generate(nil, "geosite.db", "geosite-cn.db", "rule-set", "rule-set-unstable")
    }
    EOF
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

  meta = {
    description = "Community managed domain list";
    homepage = "https://github.com/SagerNet/sing-geosite";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ linsui ];
  };
})

{
  lib,
  stdenvNoCC,
  buildGoModule,
  fetchFromGitHub,
  dbip-country-lite,
}:

let
  generator = buildGoModule rec {
    pname = "sing-geoip";
    version = "20240312";

    src = fetchFromGitHub {
      owner = "SagerNet";
      repo = "sing-geoip";
      rev = "refs/tags/${version}";
      hash = "sha256-nIrbiECK25GyuPEFqMvPdZUShC2JC1NI60Y10SsoWyY=";
    };

    vendorHash = "sha256-WH0eMg06qCiVcy4H+vBtYrmLMA2KJRCPGXiEnatW+LU=";

    postPatch = ''
      sed -i -e '/func main()/,/^}/d' main.go
      cat ${./main.go} >> main.go
    '';

    meta = with lib; {
      description = "GeoIP data for sing-box";
      homepage = "https://github.com/SagerNet/sing-geoip";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [ linsui ];
      mainProgram = "sing-geoip";
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit (generator) pname;
  inherit (dbip-country-lite) version;

  dontUnpack = true;

  nativeBuildInputs = [ generator ];

  buildPhase = ''
    runHook preBuild

    sing-geoip ${dbip-country-lite.mmdb}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 geoip.db $out/share/sing-box/geoip.db
    install -Dm644 geoip-cn.db $out/share/sing-box/geoip-cn.db
    install -Dm644 rule-set/* -t $out/share/sing-box/rule-set

    runHook postInstall
  '';

  passthru = { inherit generator; };

  meta = generator.meta // {
    inherit (dbip-country-lite.meta) license;
  };
}

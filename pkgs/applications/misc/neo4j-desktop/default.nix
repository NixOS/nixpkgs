{ appimageTools, lib, fetchurl }:
let
  pname = "neo4j-desktop";
  version = "1.5.6";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/dist.neo4j.org/${pname}/linux-offline/${name}-x86_64.AppImage";
    hash = "sha256-0/jS1LaaIam6w7RbLXSKXiXlpocZMTMuTZvFRU4qypg=";
  };

  appimageContents = appimageTools.extract { inherit name src; };
in appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: with pkgs; [ libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A GUI front-end for Neo4j";
    homepage = "https://neo4j.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.bobvanderlinden ];
    platforms = [ "x86_64-linux" ];
  };
}

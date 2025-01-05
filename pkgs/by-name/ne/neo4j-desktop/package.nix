{ appimageTools, lib, fetchurl }:
let
  pname = "neo4j-desktop";
  version = "1.6.0";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/dist.neo4j.org/${pname}/linux-offline/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-/ptMEU4BM5mPK4KWWRdor6N8gw3oaNgyzD0c4jI+3fI=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "GUI front-end for Neo4j";
    homepage = "https://neo4j.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.bobvanderlinden ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "neo4j-desktop";
  };
}

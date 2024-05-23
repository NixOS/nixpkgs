{ appimageTools, lib, fetchurl }:
let
  pname = "neo4j-desktop";
  version = "1.5.8";

  src = fetchurl {
    url = "https://s3-eu-west-1.amazonaws.com/dist.neo4j.org/${pname}/linux-offline/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-RqzR4TuvDasbkj/wKvOOS7r46sXDxvw3B5ydFGZeHX8=";
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
    description = "A GUI front-end for Neo4j";
    homepage = "https://neo4j.com/";
    license = licenses.unfree;
    maintainers = [ maintainers.bobvanderlinden ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "neo4j-desktop";
  };
}

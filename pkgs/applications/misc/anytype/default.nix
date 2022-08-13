{ lib, fetchurl, appimageTools }:

let
  pname = "anytype";
  version = "0.27.0";
  name = "Anytype-${version}";
  nameExecutable = pname;
  src = fetchurl {
    url = "https://at9412003.fra1.digitaloceanspaces.com/Anytype-${version}.AppImage";
    name = "Anytype-${version}.AppImage";
    sha256 = "sha256-AcnXhilnr5ay45S30eNSDuN+Ed1TDv/Rh523LsUf3iM=";
  };
  appimageContents = appimageTools.extractType2 { inherit name src; };
in
appimageTools.wrapType2 {
  inherit name src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs)
    ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/anytype2.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/anytype2.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/0x0/apps/anytype2.png \
      $out/share/icons/hicolor/512x512/apps/anytype2.png
  '';

  meta = with lib; {
    description = "P2P note-taking tool";
    homepage = "https://anytype.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ bbigras ];
    platforms = [ "x86_64-linux" ];
  };
}

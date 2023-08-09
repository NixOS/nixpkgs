{ lib, fetchurl, appimageTools, pkgs, pname, version, meta, ... }:

let
  inherit pname version meta;
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    sha512 = "7NQmH42yzItReQ5WPdcbNPr/xed74H4UyDNlX5PGmoJRBpV1RdeuW1KRweIWfYNhw0KeqULVTjr/aCggoWp4WA==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name pname version src;
  };
in
appimageTools.wrapType2 {
  inherit name pname version src meta;

  multiArch = false; # no 32bit needed
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${appimageContents}/plexamp.png \
      $out/share/icons/hicolor/512x512/apps/plexamp.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  passthru.updateScript = ./update-plexamp.sh;
}

{ lib, fetchurl, appimageTools, wrapGAppsHook, gsettings-desktop-schemas, gtk3 }:

let
  pname = "lens";
  version = "5.3.4";
  build = "${version}-latest.20220120.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://api.k8slens.dev/binaries/Lens-${build}.x86_64.AppImage";
    sha256 = "sha256-9vRLQFSocVkHAfgwdKSPhSAO4G/v/ANd0WQmilcZiVw=";
    name = "${pname}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };

in
appimageTools.wrapType2 {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraInstallCommands =
    ''
      mv $out/bin/${name} $out/bin/${pname}

      install -m 444 -D ${appimageContents}/lens.desktop $out/share/applications/${pname}.desktop
      install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/lens.png \
         $out/share/icons/hicolor/512x512/apps/${pname}.png

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Icon=lens' 'Icon=${pname}' \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  meta = with lib; {
    description = "The Kubernetes IDE";
    homepage = "https://k8slens.dev/";
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
    platforms = [ "x86_64-linux" ];
  };
}

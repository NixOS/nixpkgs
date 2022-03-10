{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "marktext";
  version = "v0.17.1";
  name = "${pname}-${version}-binary";

  src = fetchurl {
    url = "https://github.com/marktext/marktext/releases/download/${version}/marktext-x86_64.AppImage";
    sha256 = "2e2555113e37df830ba3958efcccce7020907b12fd4162368cfd906aeda630b7";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export LC_ALL=C.UTF-8
  ''
  # Fixes file open dialog error
  #     GLib-GIO-ERROR **: 20:36:48.243: No GSettings schemas are installed on the system
  # See https://github.com/NixOS/nixpkgs/pull/83701#issuecomment-608034097
  + ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  multiPkgs = null; # no 32bit needed
  extraPkgs = p: (appimageTools.defaultFhsEnvArgs.multiPkgs p) ++ [
    p.libsecret
    p.xorg.libxkbfile
  ];

  extraInstallCommands = ''
    # Strip version from binary name.
    mv $out/bin/${name} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/marktext.desktop $out/share/applications/marktext.desktop
    substituteInPlace $out/share/applications/marktext.desktop \
      --replace "Exec=AppRun" "Exec=${pname} --"

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "A simple and elegant markdown editor, available for Linux, macOS and Windows";
    homepage = "https://marktext.app";
    license = licenses.mit;
    maintainers = with maintainers; [ nh2 eduarrrd ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "marktext";
  };
}

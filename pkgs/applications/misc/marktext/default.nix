{ appimageTools, fetchurl, lib, gsettings-desktop-schemas, gtk3 }:

let
  pname = "marktext";
  version = "v0.16.2";
in
appimageTools.wrapType2 rec {
  name = "${pname}-${version}-binary";

  src = fetchurl {
    url = "https://github.com/marktext/marktext/releases/download/${version}/marktext-x86_64.AppImage";
    sha256 = "0ivf9lvv2jk7dvxmqprzcsxgya3617xmx5bppjvik44z14b5x8r7";
  };

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

  # Strip version from binary name.
  extraInstallCommands = "mv $out/bin/${name} $out/bin/${pname}";

  meta = with lib; {
    description = "A simple and elegant markdown editor, available for Linux, macOS and Windows";
    homepage = "https://marktext.app";
    license = licenses.mit;
    maintainers = with maintainers; [ nh2 ];
    platforms = [ "x86_64-linux" ];
  };
}

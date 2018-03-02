{ stdenv, fetchurl,
  python36,
  gtk3, gobjectIntrospection, wrapGAppsHook }:

let
  version = "0.4.14";
  name = "lutris-${version}";

  inherit (python36.pkgs) buildPythonApplication pygobject3 pyxdg pyyaml evdev;

in buildPythonApplication rec {
  inherit version name;

  nativeBuildInputs = [ wrapGAppsHook ];

  propagatedBuildInputs = [ gtk3 gobjectIntrospection pygobject3 pyxdg pyyaml evdev ];

  # Fails otherwise, as it tries to write to $HOME.
  doCheck = false;
  
  src = fetchurl {
    url = "https://github.com/lutris/lutris/archive/v${version}.zip";
    sha256 = "1yjd2nppv7m0sz8p0dpb731g6p7xvmya4zz0qpry82md1fljvwjg";
  };

  makeWrapperArgs = [
    "--set GI_TYPELIB_PATH $GI_TYPELIB_PATH"
    "--prefix XDG_DATA_DIRS : $out/share"
    "--suffix XDG_DATA_DIRS : $XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  ];

  meta = {
    description = "An open gaming platform for Linux.";
    homepage = "https://lutris.net/";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.othercriteria ];
  };
}

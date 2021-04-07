{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, gnome3, gmime3, webkitgtk, ronn
, libsass, notmuch, boost, wrapGAppsHook, glib-networking, protobuf, vim_configurable
, gtkmm3, libpeas, gsettings-desktop-schemas, gobject-introspection, python3

# vim to be used, should support the GUI mode.
, vim ? vim_configurable.override { features = "normal"; gui = "auto"; }

# additional python3 packages to be available within plugins
, extraPythonPackages ? []
}:

stdenv.mkDerivation rec {
  pname = "astroid";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "11cxbva9ni98gii59xmbxh4c6idcg3mg0pgdsp1c3j0yg7ix0lj3";
  };

  nativeBuildInputs = [
    cmake ronn pkg-config wrapGAppsHook gobject-introspection
    python3 python3.pkgs.wrapPython
  ];

  buildInputs = [
    gtkmm3 gmime3 webkitgtk libsass libpeas
    python3
    notmuch boost gsettings-desktop-schemas gnome3.adwaita-icon-theme
    glib-networking protobuf
    vim
  ];

  postPatch = ''
    sed -i "s~gvim ~${vim}/bin/vim -g ~g" src/config.cc
    sed -i "s~ -geom 10x10~~g" src/config.cc
  '';

  pythonPath = with python3.pkgs; requiredPythonModules [ pygobject3 ] ++ extraPythonPackages;
  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )
  '';

  meta = with lib; {
    homepage = "https://astroidmail.github.io/";
    description = "GTK frontend to the notmuch mail system";
    maintainers = with maintainers; [ bdimcheff SuprDewd ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

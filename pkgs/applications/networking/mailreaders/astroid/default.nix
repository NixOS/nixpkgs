{ stdenv, fetchFromGitHub, cmake, pkgconfig, gnome3, gmime3, webkitgtk
, libsass, notmuch, boost, wrapGAppsHook, glib-networking, protobuf, vim_configurable
, gtkmm3, libpeas, gsettings-desktop-schemas
, python3, python3Packages
, vim ? vim_configurable.override {
                    features = "normal";
                    gui = "auto";
                  }
, ronn
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

  nativeBuildInputs = [ cmake ronn pkgconfig wrapGAppsHook ];

  buildInputs = [
    gtkmm3 gmime3 webkitgtk libsass libpeas
    python3 python3Packages.pygobject3
    notmuch boost gsettings-desktop-schemas gnome3.adwaita-icon-theme
    glib-networking protobuf
   ] ++ (if vim == null then [] else [ vim ]);

  postPatch = ''
    sed -i "s~gvim ~${vim}/bin/vim -g ~g" src/config.cc
    sed -i "s~ -geom 10x10~~g" src/config.cc
  '';

  postInstall = ''
    wrapProgram "$out/bin/astroid" --set CHARSET=en_us.UTF-8
  '';

  meta = with stdenv.lib; {
    homepage = https://astroidmail.github.io/;
    description = "GTK+ frontend to the notmuch mail system";
    maintainers = with maintainers; [ bdimcheff SuprDewd ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, cmake, pkgconfig, gnome3, gmime3, webkitgtk
, libsass, notmuch, boost, wrapGAppsHook, glib-networking, protobuf, vim_configurable
, makeWrapper, python3, python3Packages
, vim ? vim_configurable.override {
                    features = "normal";
                    gui = "auto";
                  }
, ronn
}:

stdenv.mkDerivation rec {
  name = "astroid-${version}";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    rev = "v${version}";
    sha256 = "1wkv1icsx3g3gq485dnvcdhr9srrjgz4ws1i1krcw9n61bj7gxh8";
  };

  nativeBuildInputs = [ cmake ronn pkgconfig wrapGAppsHook ];

  buildInputs = [ gnome3.gtkmm gmime3 webkitgtk libsass gnome3.libpeas
                  python3 python3Packages.pygobject3
                  notmuch boost gnome3.gsettings-desktop-schemas gnome3.defaultIconTheme
                  glib-networking protobuf ] ++ (if vim == null then [] else [ vim ]);

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

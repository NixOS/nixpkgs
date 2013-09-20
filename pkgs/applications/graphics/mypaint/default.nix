{ stdenv, fetchurl, fetchgit, gettext, glib, gtk, gtk3, json_c, lcms2, libpng
, makeWrapper, pkgconfig, pygtk, python, scons, swig

, pythonPackages, protobuf, gobjectIntrospection, cairo
, version ? "1.1.0"
}:

let
  gtk_libs_old = [ glib gtk pygtk ];
  gtk_libs_new = [ glib gtk3 pythonPackages.pygobject3 gobjectIntrospection ];
in

stdenv.mkDerivation (stdenv.lib.mergeAttrsByVersion "mypaint" version
{
  "1.1.0" = rec {
    name = "mypaint-${version}";
    version = "1.1.0";

    src = fetchurl {
      url = "http://download.gna.org/mypaint/${name}.tar.bz2";
      sha256 = "0f7848hr65h909c0jkcx616flc0r4qh53g3kd1cgs2nr1pjmf3bq";
    };
    buildInputs = gtk_libs_old;
  };

  "git" = {
    # REGION AUTO UPDATE: { name="my-paint-git"; type="git"; url="git://gitorious.org/mypaint/mypaint.git"; groups = "mypaint"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/my-paint-git-git-6993d.tar.bz2"; sha256 = "958eb83efbf2b18d5b26b850f416657d081d76008c80ef811352c94c991ca05d"; });
    name = "my-paint-git-git-6993d";
    # END

    buildInputs = gtk_libs_new ++ [ pythonPackages.pycairo ];

    postInstall = ''
    '';
  };
  "git-animation" = {
    # while it works its based on a very old mypaint version ..

    # REGION AUTO UPDATE: { name="my-paint-git-animation"; type="git"; url="git://gitorious.org/~charbelinho/mypaint/charbelinho-mypaint.git"; branch = "animation"; groups = "mypaint"; }
    src = (fetchurl { url = "http://mawercer.de/~nix/repos/my-paint-git-animation-git-29a88.tar.bz2"; sha256 = "e36a5f843b7391a3a5f149a89b6f516f3c678d69eb855f59ad8fb612fc0efd01"; });
    name = "my-paint-git-animation-git-29a88";
    # END

    buildInputs = gtk_libs_old ++ [ protobuf pythonPackages.pygobject pythonPackages.protobuf pythonPackages.setuptools ];

    preConfigure = "sed -e 's/-WAll//' -e 's/-Wstrict-prototypes//' -i SConstruct";
  };

} {

  buildInputs = [
    gettext json_c lcms2 libpng makeWrapper pkgconfig
    python scons swig
  ];

  propagatedBuildInputs = [ pythonPackages.numpy ];

  buildPhase = "scons prefix=$out";

  # 1.1.0 does not require XDG_DATA_DIRS, does not hurt either
  installPhase = ''
    scons prefix=$out install
    wrapProgram $out/bin/mypaint \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --prefix XDG_DATA_DIRS : "$XDG_DATA_DIRS" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"
  '';

  meta = with stdenv.lib; {
    description = "A graphics application for digital painters";
    homepage = http://mypaint.intilinux.com;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
})

args: with args;

stdenv.mkDerivation rec {
  name = "inkscape-0.46";

  src = fetchurl {
    url = "mirror://sf/inkscape/${name}.tar.gz";
    sha256 = "0flrjqa68vnnn8lrhj86xpa6h2cyzrvjy6873v9id092f86ix1li";
  };

  patches = [ ./configure-python-libs.patch ./libpng-setjmp.patch ./gtk-clist.patch ]; 

  propagatedBuildInputs = [
    # Python is used at run-time to execute scripts, e.g., those from
    # the "Effects" menu.
    python pyxml lxml
  ];

  buildInputs = [
    pkgconfig perl perlXMLParser gtk libXft fontconfig libpng zlib popt boehmgc
    libxml2 libxslt glib gtkmm glibmm libsigcxx lcms boost gettext
    makeWrapper
  ];

  configureFlags = "--with-python";

  # Fix compilation on glibc 2.9 by adding missing string header
  preConfigure = ''
    echo "#include <string.h>" > tmp.cpp
    cat tmp.cpp src/dom/io/uristream.cpp > src/dom/io/uristream.cpp.new
    rm tmp.cpp
    mv src/dom/io/uristream.cpp.new src/dom/io/uristream.cpp
  '';

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I./extension/script"
  '';

  postInstall = ''
    # Make sure PyXML modules can be found at run-time.
    for i in "$out/bin/"*
    do
      wrapProgram "$i" --prefix PYTHONPATH :      \
       "$(toPythonPath ${pyxml}):$(toPythonPath ${lxml})" ||  \
        exit 2
    done
  '';

  meta = {
    license = "GPL";
    homepage = http://www.inkscape.org;
    longDescription = ''
      Inkscape is a feature-rich vector graphics editor that edits
      files in the W3C SVG (Scalable Vector Graphics) file format.

      If you want to import .eps files install ps2edit
    '';

  };
}

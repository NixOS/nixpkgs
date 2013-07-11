{ stdenv, fetchgit, perl, makeWrapper, makeDesktopItem
# Perl modules:
, EncodeLocale, MathClipper, ExtUtilsXSpp, BoostGeometryUtils
, MathConvexHullMonotoneChain, MathGeometryVoronoi, MathPlanePath, Moo
, IOStringy, ClassXSAccessor, Wx, GrowlGNTP, NetDBus }:

stdenv.mkDerivation rec {
  version = "0.9.10b";
  name = "slic3r-${version}";

  # Slic3r doesn't put out tarballs, only a git repository is available
  src = fetchgit {
    url = "git://github.com/alexrj/Slic3r";
    rev = "refs/tags/${version}";
    sha256 = "0j06h0z65qn4kyb2b7pnq6bcn4al60q227iz9jlrin0ffx3l0ra7";
  };

  buildInputs = [ perl makeWrapper
    EncodeLocale MathClipper ExtUtilsXSpp BoostGeometryUtils
    MathConvexHullMonotoneChain MathGeometryVoronoi MathPlanePath Moo
    IOStringy ClassXSAccessor Wx GrowlGNTP NetDBus
  ];

  desktopItem = makeDesktopItem {
    name = "slic3r";
    exec = "slic3r";
    icon = "slic3r";
    comment = "G-code generator for 3D printers";
    desktopName = "Slic3r";
    genericName = "3D printer tool";
    categories = "Application;Development;";
  };

  # Nothing to do here
  buildPhase = "true";

  installPhase = ''
    mkdir -p "$out/share/slic3r/"
    cp -r * "$out/share/slic3r/"
    wrapProgram "$out/share/slic3r/slic3r.pl" --prefix PERL5LIB : $PERL5LIB
    mkdir -p "$out/bin"
    ln -s "$out/share/slic3r/slic3r.pl" "$out/bin/slic3r"
    mkdir -p "$out/share/pixmaps/"
    ln -s "$out/share/slic3r/var/Slic3r.png" "$out/share/pixmaps/slic3r.png"
    mkdir -p "$out/share/applications"
    cp "$desktopItem"/share/applications/* "$out/share/applications/"
  '';

  meta = with stdenv.lib; {
    description = "G-code generator for 3D printers";
    longDescription = ''
      Slic3r is the tool you need to convert a digital 3D model into printing
      instructions for your 3D printer. It cuts the model into horizontal
      slices (layers), generates toolpaths to fill them and calculates the
      amount of material to be extruded.'';
    homepage = http://slic3r.org/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}

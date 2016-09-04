{ stdenv, fetchgit, perl, makeWrapper, makeDesktopItem
, which, perlPackages
}:

stdenv.mkDerivation rec {
  version = "1.2.9";
  name = "slic3r-${version}";

  src = fetchgit {
    url = "git://github.com/alexrj/Slic3r";
    rev = "refs/tags/${version}";
    sha256 = "1z8h11k29b7z49z5k8ikyfiijyycy1q3krlzi8hfd0vdybvymw21";
  };

  buildInputs = with perlPackages; [ perl makeWrapper which
    EncodeLocale MathClipper ExtUtilsXSpp threads
    MathConvexHullMonotoneChain MathGeometryVoronoi MathPlanePath Moo
    IOStringy ClassXSAccessor Wx GrowlGNTP NetDBus ImportInto XMLSAX
    ExtUtilsMakeMaker OpenGL WxGLCanvas ModuleBuild LWP
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

  buildPhase = ''
    export SLIC3R_NO_AUTO=true
    export PERL5LIB="./xs/blib/arch/:./xs/blib/lib:$PERL5LIB"

    substituteInPlace Build.PL \
      --replace "0.9918" "0.9923" \
      --replace "eval" ""

    pushd xs
      perl Build.PL
      perl Build
    popd

    perl Build.PL --gui
  '';

  installPhase = ''
    mkdir -p "$out/share/slic3r/"
    cp -r * "$out/share/slic3r/"
    wrapProgram "$out/share/slic3r/slic3r.pl" \
      --prefix PERL5LIB : "$out/share/slic3r/xs/blib/arch:$out/share/slic3r/xs/blib/lib:$PERL5LIB"
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
    maintainers = with maintainers; [ bjornfor the-kenny ];
  };
}

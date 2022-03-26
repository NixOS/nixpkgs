{ lib, stdenv, fetchgit, perl, makeWrapper
, makeDesktopItem, which, perlPackages, boost
}:

stdenv.mkDerivation rec {
  version = "1.3.0";
  pname = "slic3r";

  src = fetchgit {
    url = "git://github.com/alexrj/Slic3r";
    rev = version;
    sha256 = "1pg4jxzb7f58ls5s8mygza8kqdap2c50kwlsdkf28bz1xi611zbi";
  };

  buildInputs =
  [boost] ++
  (with perlPackages; [ perl makeWrapper which
    EncodeLocale MathClipper ExtUtilsXSpp
    MathConvexHullMonotoneChain MathGeometryVoronoi MathPlanePath Moo
    IOStringy ClassXSAccessor Wx GrowlGNTP NetDBus ImportInto XMLSAX
    ExtUtilsMakeMaker OpenGL WxGLCanvas ModuleBuild LWP
    ExtUtilsCppGuess ModuleBuildWithXSpp ExtUtilsTypemapsDefault
    DevelChecklib locallib
  ]);

  desktopItem = makeDesktopItem {
    name = "slic3r";
    exec = "slic3r";
    icon = "slic3r";
    comment = "G-code generator for 3D printers";
    desktopName = "Slic3r";
    genericName = "3D printer tool";
    categories = [ "Development" ];
  };

  prePatch = ''
    # In nix ioctls.h isn't available from the standard kernel-headers package
    # on other distributions. As the copy in glibc seems to be identical to the
    # one in the kernel, we use that one instead.
    sed -i 's|"/usr/include/asm-generic/ioctls.h"|<asm-generic/ioctls.h>|g' xs/src/libslic3r/GCodeSender.cpp
  '';

  # note the boost-compile-error is fixed in
  # https://github.com/slic3r/Slic3r/commit/90f108ae8e7a4315f82e317f2141733418d86a68
  # this patch can be probably be removed in the next version after 1.3.0
  patches = lib.optional (lib.versionAtLeast boost.version "1.56.0") ./boost-compile-error.patch;

  buildPhase = ''
    export SLIC3R_NO_AUTO=true
    export LD=$CXX
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

  meta = with lib; {
    description = "G-code generator for 3D printers";
    longDescription = ''
      Slic3r is the tool you need to convert a digital 3D model into printing
      instructions for your 3D printer. It cuts the model into horizontal
      slices (layers), generates toolpaths to fill them and calculates the
      amount of material to be extruded.'';
    homepage = "https://slic3r.org/";
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}

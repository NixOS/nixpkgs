{ lib, stdenv, fetchFromGitHub, fetchpatch, perl, makeWrapper
, makeDesktopItem, which, perlPackages, boost, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  version = "1.3.0";
  pname = "slic3r";

  src = fetchFromGitHub {
    owner = "alexrj";
    repo = "Slic3r";
    rev = version;
    sha256 = "sha256-cf0QTOzhLyTcbJryCQoTVzU8kfrPV6SLpqi4s36X5N0=";
  };

  nativeBuildInputs = [ makeWrapper which wrapGAppsHook ];
  buildInputs =
  [boost] ++
  (with perlPackages; [ perl
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

  patches = [
    (fetchpatch {
      url = "https://web.archive.org/web/20230606220657if_/https://sources.debian.org/data/main/s/slic3r/1.3.0%2Bdfsg1-5/debian/patches/Drop-error-admesh-works-correctly-on-little-endian-machin.patch";
      hash = "sha256-+F94jzMFBdI++SKgyEZTBaHFVbjxWwgJa8YVbpK0euI=";
    })
    (fetchpatch {
      url = "https://web.archive.org/web/20230606220036if_/https://sources.debian.org/data/main/s/slic3r/1.3.0+dfsg1-5/debian/patches/0006-Fix-FTBFS-with-Boost-1.71.patch";
      hash = "sha256-4jvNccttig5YI1hXSANAWxVz6C4+kowlacMXVCpFgOo=";
    })
    (fetchpatch {
      url = "https://web.archive.org/web/20230606220054if_/https://sources.debian.org/data/main/s/slic3r/1.3.0+dfsg1-5/debian/patches/fix_boost_174.patch";
      hash = "sha256-aSmxc2htmrla9l/DIRWeKdBW0LTV96wMUZSLLNjgbzY=";
    })
  ];

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

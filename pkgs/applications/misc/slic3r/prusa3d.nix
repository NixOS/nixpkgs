{ stdenv, lib, fetchFromGitHub, makeWrapper, which, cmake, perl, perlPackages,
  boost, tbb, wxGTK30, pkgconfig, gtk3, fetchurl, gtk2, libGLU,
  glew, eigen, curl, gtest, nlopt, pcre, xorg, makeDesktopItem }:
let
  AlienWxWidgets = perlPackages.buildPerlPackage rec {
    name = "Alien-wxWidgets-0.69";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MD/MDOOTSON/${name}.tar.gz";
      sha256 = "075m880klf66pbcfk0la2nl60vd37jljizqndrklh5y4zvzdy1nr";
    };
    propagatedBuildInputs = [
      pkgconfig perlPackages.ModulePluggable perlPackages.ModuleBuild
      gtk2 gtk3 wxGTK30
    ];
  };

  Wx = perlPackages.Wx.overrideAttrs (oldAttrs: {
    propagatedBuildInputs = [
      perlPackages.ExtUtilsXSpp
      AlienWxWidgets
    ];
  });

  WxGLCanvas = perlPackages.buildPerlPackage rec {
    name = "Wx-GLCanvas-0.09";
    src = fetchurl {
      url = "mirror://cpan/authors/id/M/MB/MBARBON/${name}.tar.gz";
      sha256 = "1q4gvj4gdx4l8k4mkgiix24p9mdfy1miv7abidf0my3gy2gw5lka";
    };
    propagatedBuildInputs = [ Wx perlPackages.OpenGL libGLU ];
    doCheck = false;
  };
in
stdenv.mkDerivation rec {
  name = "slic3r-prusa-edition-${version}";
  version = "1.41.2";

  enableParallelBuilding = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    curl
    eigen
    glew
    pcre
    perl
    tbb
    which
    Wx
    WxGLCanvas
    xorg.libXdmcp
    xorg.libpthreadstubs
  ] ++ checkInputs ++ (with perlPackages; [
    boost
    ClassXSAccessor
    EncodeLocale
    ExtUtilsMakeMaker
    ExtUtilsTypemapsDefault
    ExtUtilsXSpp
    GrowlGNTP
    ImportInto
    IOStringy
    locallib
    LWP
    MathClipper
    MathConvexHullMonotoneChain
    MathGeometryVoronoi
    MathPlanePath
    ModuleBuildWithXSpp
    Moo
    NetDBus
    OpenGL
    XMLSAX
  ]);

  checkInputs = [ gtest ];

  # The build system uses custom logic - defined in
  # xs/src/libnest2d/cmake_modules/FindNLopt.cmake in the package source -
  # for finding the nlopt library, which doesn't pick up the package in the nix store.
  # We need to set the path via the NLOPT environment variable instead.
  NLOPT = "${nlopt}";

  prePatch = ''
    # In nix ioctls.h isn't available from the standard kernel-headers package
    # on other distributions. As the copy in glibc seems to be identical to the
    # one in the kernel, we use that one instead.
    sed -i 's|"/usr/include/asm-generic/ioctls.h"|<asm-generic/ioctls.h>|g' xs/src/libslic3r/GCodeSender.cpp

    # PERL_VENDORARCH and PERL_VENDORLIB aren't set correctly by the build
    # system, so we have to override them. Setting them as environment variables
    # doesn't work though, so substituting the paths directly in CMakeLists.txt
    # seems to be the easiest way.
    sed -i "s|\''${PERL_VENDORARCH}|$out/lib/slic3r-prusa3d|g" xs/CMakeLists.txt
    sed -i "s|\''${PERL_VENDORLIB}|$out/lib/slic3r-prusa3d|g" xs/CMakeLists.txt
  '' + lib.optionalString (lib.versionOlder "2.5" nlopt.version) ''
    # Since version 2.5.0 of nlopt we need to link to libnlopt, as libnlopt_cxx
    # now seems to be integrated into the main lib.
    sed -i 's|nlopt_cxx|nlopt|g' xs/src/libnest2d/cmake_modules/FindNLopt.cmake
  '';

  postInstall = ''
    echo 'postInstall'
    wrapProgram "$out/bin/slic3r-prusa3d" \
    --prefix PERL5LIB : "$out/lib/slic3r-prusa3d:$PERL5LIB"

    # it seems we need to copy the icons...
    mkdir -p $out/bin/var
    cp -r ../resources/icons/* $out/bin/var/
    cp -r ../resources $out/bin/


    mkdir -p "$out/share/pixmaps/"
    ln -s "$out/bin/var/Slic3r.png" "$out/share/pixmaps/slic3r-prusa.png"
    mkdir -p "$out/share/applications"
    cp "$desktopItem"/share/applications/* "$out/share/applications/"
  '';

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "Slic3r";
    sha256 = "046ircwc0wr586v7106ys557ypslmyq9p4qgi34ads1d6bgxhlyy";
    rev = "version_${version}";
  };

  desktopItem = makeDesktopItem {
    name = "slic3r-Prusa-Edition";
    exec = "slic3r-prusa3d";
    icon = "slic3r-prusa";
    comment = "G-code generator for 3D printers";
    desktopName = "Slic3r Prusa Edition";
    genericName = "3D printer tool";
    categories = "Application;Development;";
  };

  meta = with stdenv.lib; {
    description = "G-code generator for 3D printer";
    homepage = https://github.com/prusa3d/Slic3r;
    license = licenses.agpl3;
    maintainers = with maintainers; [ tweber ];
    broken = stdenv.hostPlatform.isAarch64;
  };
}

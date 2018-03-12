{ stdenv, fetchFromGitHub, makeWrapper, which, cmake, perl, perlPackages,
  boost, tbb, wxGTK30, pkgconfig, gtk3, fetchurl, gtk2, bash, libGLU,
  glew, eigen }:
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
  version = "1.38.7";

  enableParallelBuilding = true;

  buildInputs = [
    cmake
    perl
    makeWrapper
    eigen
    glew
    tbb
    which
    Wx
    WxGLCanvas
  ] ++ (with perlPackages; [
    boost
    ClassXSAccessor
    EncodeLocale
    ExtUtilsMakeMaker
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
    ModuleBuild
    Moo
    NetDBus
    OpenGL
    threads
    XMLSAX
  ]);

  postInstall = ''
    echo 'postInstall'
    wrapProgram "$out/bin/slic3r-prusa3d" \
    --prefix PERL5LIB : "$out/lib/slic3r-prusa3d:$PERL5LIB"

    # it seems we need to copy the icons...
    mkdir -p $out/bin/var
    cp ../resources/icons/* $out/bin/var/
    cp -r ../resources $out/bin/
  '';

  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "Slic3r";
    sha256 = "1nrryd2bxmk4y59bq5fp7n2alyvc5a9xvnbx5j4fg4mqr91ccs5c";
    rev = "version_${version}";
  };

  meta = with stdenv.lib; {
    description = "G-code generator for 3D printer";
    homepage = https://github.com/prusa3d/Slic3r;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ tweber ];
  };
}

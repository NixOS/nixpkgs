{ wxGTK, lib, stdenv, fetchurl, fetchFromGitHub, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp
, wrapGAppsHook
, oceSupport ? true, opencascade
, ngspiceSupport ? true, libngspice
, swig, python, pythonPackages
, lndir
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let
  mkLib = version: name: sha256: attrs: stdenv.mkDerivation ({
    name = "kicad-${name}-${version}";
    src = fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-${name}";
      rev = "${version}";
      inherit sha256 name;
    };
    nativeBuildInputs = [
      cmake
    ];
  } // attrs);

in stdenv.mkDerivation rec {
  name = "kicad-${version}";
  series = "5.0";
  version = "5.1.2";

  src = fetchurl {
    url = "https://launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
    sha256 = "12kp82ms2dwqkhilmh3mbhg5rsj5ykk99pnkhp4sx89nni86qdw4";
  };

  postPatch = ''
    substituteInPlace CMakeModules/KiCadVersion.cmake \
      --replace no-vcs-found ${version}
  '';

  cmakeFlags = [
    "-DKICAD_SCRIPTING=ON"
    "-DKICAD_SCRIPTING_MODULES=ON"
    "-DKICAD_SCRIPTING_WXPYTHON=ON"
    # nix installs wxPython headers in wxPython package, not in wxwidget
    # as assumed. We explicitely set the header location.
    "-DCMAKE_CXX_FLAGS=-I${pythonPackages.wxPython}/include/wx-3.0"
    "-DwxPYTHON_INCLUDE_DIRS=${pythonPackages.wxPython}/include/wx-3.0"
  ] ++ optionals (oceSupport) [ "-DKICAD_USE_OCE=ON" "-DOCE_DIR=${opencascade}" ]
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON";

  nativeBuildInputs = [
    cmake
    doxygen
    pkgconfig
    wrapGAppsHook
    pythonPackages.wrapPython
    lndir
  ];
  pythonPath = [ pythonPackages.wxPython ];
  propagatedBuildInputs = [ pythonPackages.wxPython ];

  buildInputs = [
    libGLU_combined zlib libX11 wxGTK pcre libXdmcp glew glm libpthreadstubs
    cairo curl openssl boost
    swig python
  ] ++ optional (oceSupport) opencascade
    ++ optional (ngspiceSupport) libngspice;

  # this breaks other applications in kicad
  dontWrapGApps = true;

  passthru = {
    i18n = mkLib version "i18n" "08a8lpz2j7bhwn155s0ii538qlynnnvq6fmdw1dxjfgmfy7y3r66" {
      buildInputs = [
        gettext
      ];
      meta.license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
    };
    symbols = mkLib version "symbols" "0l5r53wcv0518x2kl0fh1zi0d50cckc7z1739fp9z3k5a4ddk824" {
      meta.license = licenses.cc-by-sa-40;
    };
    footprints = mkLib version "footprints" "0q7y7m10pav6917ri37pzjvyh71c8lf4lh9ch258pdpl3w481zk6" {
      meta.license = licenses.cc-by-sa-40;
    };
    templates = mkLib version "templates" "1nva4ckq0l2lrah0l05355cawlwd7qfxcagcv32m8hcrn781455q" {
      meta.license = licenses.cc-by-sa-40;
    };
    packages3d = mkLib version "packages3d" "0xla9k1rnrs00fink90y9qz766iks5lyqwnf1h2i508djqhqm5zi" {
      hydraPlatforms = []; # this is a ~1 GiB download, occupies ~5 GiB in store
      meta.license = licenses.cc-by-sa-40;
    };
  };

  modules = with passthru; [ i18n symbols footprints templates ];

  postInstall = ''
    mkdir -p $out/share
    for module in $modules; do
      lndir $module/share $out/share
    done
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--set PYTHONPATH "$program_PYTHONPATH")

    wrapProgram "$out/bin/kicad" "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://www.kicad-pcb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
  };
}

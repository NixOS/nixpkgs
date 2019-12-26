{ wxGTK, lib, stdenv, fetchurl, fetchFromGitHub, cmake, libGLU, libGL, zlib
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
      rev = version;
      inherit sha256 name;
    };
    nativeBuildInputs = [
      cmake
    ];
  } // attrs);

in stdenv.mkDerivation rec {
  pname = "kicad";
  series = "5.0";
  version = "5.1.4";

  src = fetchurl {
    url = "https://launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
    sha256 = "1r60dgh6aalbpq1wsmpyxkz0nn4ck8ydfdjcrblpl69k5rks5k2j";
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
    libGLU libGL zlib libX11 wxGTK pcre libXdmcp glew glm libpthreadstubs
    cairo curl openssl boost
    swig (python.withPackages (ps: with ps; [ wxPython ]))
  ] ++ optional (oceSupport) opencascade
    ++ optional (ngspiceSupport) libngspice;

  # this breaks other applications in kicad
  dontWrapGApps = true;

  passthru = {
    i18n = mkLib version "i18n" "1dk7wis4cncmihl8fnic3jyhqcdzpifchzsp7hmf214h0vp199zr" {
      buildInputs = [
        gettext
      ];
      meta.license = licenses.gpl2; # https://github.com/KiCad/kicad-i18n/issues/3
    };
    symbols = mkLib version "symbols" "1lna4xlvzrxif3569pkp6mrg7fj62z3a3ri5j97lnmnnzhiddnh3" {
      meta.license = licenses.cc-by-sa-40;
    };
    footprints = mkLib version "footprints" "0c0kcywxlaihzzwp9bi0dsr2v9j46zcdr85xmfpivmrk19apss6a" {
      meta.license = licenses.cc-by-sa-40;
    };
    templates = mkLib version "templates" "1bagb0b94cjh7zp9z0h23b60j45kwxbsbb7b2bdk98dmph8lmzbb" {
      meta.license = licenses.cc-by-sa-40;
    };
    packages3d = mkLib version "packages3d" "0h2qjj8vf33jz6jhqdz90c80h5i1ydgfqnns7rn0fqphlnscb45g" {
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

    wrapGApp "$out/bin/kicad" --prefix LD_LIBRARY_PATH : "${libngspice}/lib"
  '';

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://www.kicad-pcb.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
    broken = stdenv.isAarch64;
  };
}

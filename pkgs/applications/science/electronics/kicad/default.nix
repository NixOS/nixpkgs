{ wxGTK, lib, stdenv, fetchurl, fetchFromGitHub, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp
, wrapGAppsHook
, oceSupport ? true, opencascade
, ngspiceSupport ? true, libngspice
, swig, python, pythonPackages
, lndir, withLibraries ? true, with3DPackages ? false
}:

assert ngspiceSupport -> libngspice != null;

with lib;
let
  mkLib = version: name: sha256: stdenv.mkDerivation {
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
  };

in stdenv.mkDerivation rec {
  name = "kicad-${version}";
  series = "5.0";
  version = "5.0.2";

  src = fetchurl {
    url = "https://launchpad.net/kicad/${series}/${version}/+download/kicad-${version}.tar.xz";
    sha256 = "10605rr10x0353n6yk2z095ydnkd1i6j1ncbq64pfxdn5vkhcd1g";
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

  i18n = (mkLib version "i18n" "1hkc240gymhmyv6r858mq5d2slz0vjqc47ah8wn82vvmb83fpnjy").overrideAttrs (_: {
    buildInputs = [
      gettext
    ];
  });

  symbols = mkLib version "symbols" "1rjh2pjcrc3bhcgyyskj5pssm7vffrjk0ymwr70fb7sjpmk96yjk";

  footprints = mkLib version "footprints" "19khqyrbrqsdzxvm1b1vxfscxhss705fqky0ilrbvnbvf27fnx8w";

  templates = mkLib version "templates" "0rlzq1n09n0sf2kj5c9bvbnkvs6cpycjxmxwcswql0fbpcp0sql7";

  packages3d = (mkLib version "packages3d" "135jyrljgknnv2y35skhnwcxg16yxxkfbcx07nad3vr4r76zk3am").overrideAttrs (_: {
    hydraPlatforms = []; # Disable big package3d library
    preferLocalBuild = true;
  });

  postInstall = ''
    lndir -silent $i18n/share $out/share
  '' + optionalString withLibraries ''
    lndir -silent $symbols/share $out/share
    lndir -silent $footprints/share $out/share
    lndir -silent $templates/share $out/share
  '' + optionalString with3DPackages ''
    lndir -silent $packages3d/share $out/share
  '';

  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(--set PYTHONPATH "$program_PYTHONPATH")

    wrapProgram "$out/bin/kicad" "''${gappsWrapperArgs[@]}"
  '';

  meta = {
    description = "Free Software EDA Suite";
    homepage = http://www.kicad-pcb.org/;
    license = [ licenses.gpl2 ] ++ optional (withLibraries || with3DPackages) licenses.cc-by-sa-40;
    maintainers = with maintainers; [ berce ];
    platforms = with platforms; linux;
  };
}

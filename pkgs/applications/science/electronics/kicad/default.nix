{ lib, stdenv, fetchurl, fetchFromGitHub, cmake, libGLU_combined, zlib
, libX11, gettext, glew, glm, cairo, curl, openssl, boost, pkgconfig
, doxygen, pcre, libpthreadstubs, libXdmcp
, makeWrapper, hicolor-icon-theme, gsettings-desktop-schemas
, swig, lndir
, oceSupport ? true, opencascade
, ngspiceSupport ? true, libngspice
, wxGTK, python, pythonPackages, wxPython # defined in all-packages.nix
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

  cmakeFlags = [
    "-DKICAD_SCRIPTING=ON"
    "-DKICAD_SCRIPTING_PYTHON3=ON"
    "-DKICAD_SCRIPTING_MODULES=ON"
    "-DKICAD_SCRIPTING_WXPYTHON_PHOENIX=ON"
  ] ++ optionals (oceSupport) [ "-DKICAD_USE_OCE=ON" "-DOCE_DIR=${opencascade}" ]
    ++ optional (ngspiceSupport) "-DKICAD_SPICE=ON";

  nativeBuildInputs = [
    cmake
    doxygen
    pkgconfig
    pythonPackages.wrapPython
    lndir
  ];

  pythonPath = [ wxPython pythonPackages.six ];
  propagatedBuildInputs = [
    wxPython
    pythonPackages.six
  ];

  buildInputs = [
    libGLU_combined zlib libX11 pcre libXdmcp glew glm libpthreadstubs
    cairo curl openssl boost wxGTK swig
  ] ++ optional (oceSupport) opencascade
    ++ optional (ngspiceSupport) libngspice;

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

# GSETTINGS_SCHEMAS_PATH includes gtk twice, so wrapProgram with ${wxGTK.gtk} is used instead of wrapGApp
# since wrapGApp needs most of these set explicitly anyway (with dontWrapGApps = true;), lets not depend on it
  preFixup = ''
    buildPythonPath "$out $pythonPath"
    wrapProgram "$out/bin/kicad" \
      --prefix LD_LIBRARY_PATH : "${libngspice}/lib" \
      --prefix XDG_DATA_DIRS : "${wxGTK.gtk}/share/gsettings-schemas/${wxGTK.gtk.name}" \
      --prefix XDG_DATA_DIRS : ""${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
      --prefix XDG_DATA_DIRS : "$out/share" \
      --set PYTHONPATH "$program_PYTHONPATH"
    wrapProgram "$out/bin/pcbnew" \
      --set PYTHONPATH "$program_PYTHONPATH"
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

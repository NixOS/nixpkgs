{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  freetype,
  libemf2svg,
  librevenge,
  libvisio,
  libwmf,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "libvisio2svg";
  version = "0.5.6";

  src = fetchFromGitHub {
    owner = "kakwa";
    repo = "libvisio2svg";
    rev = version;
    sha256 = "sha256-MklZ/pY04kw8BJxoGcBQAWdXytAPkrDz0N0W1t9I5Is=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libxml2
    freetype
    librevenge
    libvisio
    libwmf
    libemf2svg
  ];

  cmakeFlags = [
    # file RPATH_CHANGE could not write new RPATH
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    description = "Library and tools to convert Microsoft Visio documents (VSS and VSD) to SVG";
    homepage = "https://github.com/kakwa/libvisio2svg";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}

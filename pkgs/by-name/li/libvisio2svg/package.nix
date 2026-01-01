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
<<<<<<< HEAD
  version = "0.5.6";
=======
  version = "0.5.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kakwa";
    repo = "libvisio2svg";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-MklZ/pY04kw8BJxoGcBQAWdXytAPkrDz0N0W1t9I5Is=";
=======
    sha256 = "14m37mmib1596c76j9w178jqhwxyih2sy5w5q9xglh8cmlfn1hfx";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Library and tools to convert Microsoft Visio documents (VSS and VSD) to SVG";
    homepage = "https://github.com/kakwa/libvisio2svg";
    maintainers = with lib.maintainers; [ erdnaxe ];
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    description = "Library and tools to convert Microsoft Visio documents (VSS and VSD) to SVG";
    homepage = "https://github.com/kakwa/libvisio2svg";
    maintainers = with maintainers; [ erdnaxe ];
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = [ "x86_64-linux" ];
  };
}

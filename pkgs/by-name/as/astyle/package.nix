{
  stdenv,
  lib,
  fetchurl,
  cmake,
  asLibrary ? false,
}:

stdenv.mkDerivation rec {
  pname = "astyle";
  version = "3.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    hash = "sha256-EO18j5dOzONcF3jxYW8EypPD07/BoBeqJROWBBtnDvw=";
  };

  nativeBuildInputs = [ cmake ];

  # upstream repo includes a build/ directory
  cmakeBuildDir = "_build";

  cmakeFlags = lib.optional asLibrary [
    "-DBUILD_SHARED_LIBS=ON"
  ];

  postInstall = lib.optionalString asLibrary ''
    install -Dm444 ../src/astyle.h $out/include/astyle.h
  '';

  meta = with lib; {
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    mainProgram = "astyle";
    homepage = "https://astyle.sourceforge.net/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ carlossless ];
    platforms = platforms.unix;
  };
}

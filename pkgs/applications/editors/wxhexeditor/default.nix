{ lib, stdenv, fetchFromGitHub, fetchpatch, wxGTK, autoconf, automake, libtool, python2, gettext }:

stdenv.mkDerivation rec {
  pname = "wxHexEditor";
  version = "0.24";

  src = fetchFromGitHub {
    repo = "wxHexEditor";
    owner = "EUA";
    rev = "v${version}";
    sha256 = "08xnhaif8syv1fa0k6lc3jm7yg2k50b02lyds8w0jyzh4xi5crqj";
  };

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ wxGTK libtool python2 gettext ];

  preConfigure = "patchShebangs .";

  prePatch = ''
    substituteInPlace Makefile --replace "/usr" "$out"
    substituteInPlace Makefile --replace "mhash; ./configure" "mhash; ./configure --prefix=$out"
  '';

  patches = [
    # https://github.com/EUA/wxHexEditor/issues/90
    (fetchpatch {
      url = "https://github.com/EUA/wxHexEditor/commit/d0fa3ddc3e9dc9b05f90b650991ef134f74eed01.patch";
      sha256 = "1wcb70hrnhq72frj89prcqylpqs74xrfz3kdfdkq84p5qfz9svyj";
    })
    ./missing-semicolon.patch
  ];

  makeFlags = [ "OPTFLAGS=-fopenmp" ];

  meta = {
    description = "Hex Editor / Disk Editor for Huge Files or Devices";
    longDescription = ''
      This is not an ordinary hex editor, but could work as low level disk editor too.
      If you have problems with your HDD or partition, you can recover your data from HDD or
      from partition via editing sectors in raw hex.
      You can edit your partition tables or you could recover files from File System by hand
      with help of wxHexEditor.
      Or you might want to analyze your big binary files, partitions, devices... If you need
      a good reverse engineer tool like a good hex editor, you welcome.
      wxHexEditor could edit HDD/SDD disk devices or partitions in raw up to exabyte sizes.
    '';
    homepage = "http://www.wxhexeditor.org/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}

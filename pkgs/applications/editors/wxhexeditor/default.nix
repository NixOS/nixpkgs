{ stdenv, fetchFromGitHub, wxGTK, autoconf, automake, libtool, python, gettext, bash }:

stdenv.mkDerivation rec {
  name = "wxHexEditor-${version}";
  version = "v0.24";

  src = fetchFromGitHub {
    repo = "wxHexEditor";
    owner = "EUA";
    rev = version;
    sha256 = "08xnhaif8syv1fa0k6lc3jm7yg2k50b02lyds8w0jyzh4xi5crqj";
  };

  buildInputs = [ wxGTK autoconf automake libtool python gettext ];

  preConfigure = "patchShebangs .";

  prePatch = ''
    substituteInPlace Makefile --replace "/usr" "$out"
    substituteInPlace Makefile --replace "mhash; ./configure" "mhash; ./configure --prefix=$out"
  '';

  buildPhase = ''
    make OPTFLAGS="-fopenmp"
  '';

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
    homepage = http://www.wxhexeditor.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}

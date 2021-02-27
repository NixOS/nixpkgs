{ lib
, stdenv
, fetchurl
, pkg-config
, boehmgc
, indent
, json_c
, libiconv
, libintl
, readline
, enable-gui ? true
, tcl
, tk
}:

stdenv.mkDerivation rec {
  pname = "poke";
  version = "1.0";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "3pMLhwDAdys8LNDQyjX1D9PXe9+CxiUetRa0noyiWwo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    boehmgc
    indent
    json_c
    libiconv
    libintl
    readline
  ];

  configureFlags = [
    "--enable-mi"
  ];

  meta = with lib; {
    homepage = "http://www.jemarch.net/poke";
    description = "Extensible editor for structured binary data";
    longDescription = ''
      GNU poke is a new interactive editor for binary data. Not limited to
      editing basic entities such as bits and bytes, it provides a full-fledged
      procedural, interactive programming language designed to describe data
      structures and to operate on them. Once a user has defined a structure for
      binary data (usually matching some file format) she can search, inspect,
      create, shuffle and modify abstract entities such as ELF relocations, MP3
      tags, DWARF expressions, partition table entries, and so on, with
      primitives resembling simple editing of bits and bytes. The program comes
      with a library of already written descriptions (or "pickles" in poke
      parlance) for many binary formats.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
# TODO [ AndersonTorres ]: libnbd support (the lib is not in Nixpkgs yet)
# TODO [ AndersonTorres ]: libtextstyle support (the lib is not in Nixpkgs yet)
# TODO [ AndersonTorres ]: GUI support (tcl and tk were not found)

{ stdenv, fetchFromGitHub, fetchpatch, cmake, lua, pkgconfig, rsync,
  asciidoc, libxml2, docbook_xml_dtd_45, docbook_xsl, libxslt }:

stdenv.mkDerivation rec {
  name = "lsyncd-${version}";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "axkibe";
    repo = "lsyncd";
    rev = "release-${version}";
    sha256 = "1hbsih5hfq9lhgnxm0wb5mrj6xmlk2l0i9a79wzd5f6cnjil9l3x";
  };

  patches = [
    (fetchpatch {
      sha256 = "0b0h2qxh73l502p7phf6qgl8576nf6fvqqp2x5wy3nz7sc9qb1z8";
      name = "fix-non-versioned-lua-not-search-in-cmake.patch";
      url = "https://github.com/axkibe/lsyncd/pull/500/commits/0af99d8d5ba35118e8799684a2d4a8ea4b0c6957.patch";
    })
  ];

  postPatch = ''
    substituteInPlace default-rsync.lua \
      --replace "/usr/bin/rsync" "${rsync}/bin/rsync"
  '';

  dontUseCmakeBuildDir = true;

  buildInputs = [
    rsync
    cmake lua pkgconfig
    asciidoc libxml2 docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/axkibe/lsyncd;
    description = "A utility that synchronizes local directories with remote targets";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}

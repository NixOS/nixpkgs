{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, lua, pkg-config, rsync,
  asciidoc, libxml2, docbook_xml_dtd_45, docbook_xsl, libxslt, xnu }:

stdenv.mkDerivation rec {
  pname = "lsyncd";
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

  # Special flags needed on Darwin:
  # https://github.com/axkibe/lsyncd/blob/42413cabbedca429d55a5378f6e830f191f3cc86/INSTALL#L51
  cmakeFlags = lib.optionals stdenv.isDarwin [ "-DWITH_INOTIFY=OFF" "-DWITH_FSEVENTS=ON" "-DXNU_DIR=${xnu}/include" ];

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    rsync
    lua
    asciidoc libxml2 docbook_xml_dtd_45 docbook_xsl libxslt
  ];

  meta = with lib; {
    homepage = "https://github.com/axkibe/lsyncd";
    description = "A utility that synchronizes local directories with remote targets";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}

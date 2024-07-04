{ lib, stdenv, fetchFromGitHub, cmake, lua, pkg-config, rsync,
  asciidoc, libxml2, docbook_xml_dtd_45, docbook_xsl, libxslt, xnu }:

stdenv.mkDerivation rec {
  pname = "lsyncd";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "axkibe";
    repo = "lsyncd";
    rev = "release-${version}";
    hash = "sha256-QBmvS1HGF3VWS+5aLgDr9AmUfEsuSz+DTFIeql2XHH4=";
  };

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
    description = "Utility that synchronizes local directories with remote targets";
    mainProgram = "lsyncd";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ bobvanderlinden ];
  };
}

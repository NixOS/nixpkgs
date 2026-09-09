{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  rsync,
  lua5_2_compat,
  asciidoc,
  libxml2,
  docbook_xml_dtd_45,
  docbook_xsl,
  libxslt,
  darwin,
}:

let
  xnu = darwin.sourceRelease "xnu";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lsyncd";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "lsyncd";
    repo = "lsyncd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QBmvS1HGF3VWS+5aLgDr9AmUfEsuSz+DTFIeql2XHH4=";
  };

  postPatch = ''
    substituteInPlace default-rsync.lua \
      --replace "/usr/bin/rsync" "${rsync}/bin/rsync"
  '';

  # Special flags needed on Darwin:
  # https://github.com/lsyncd/lsyncd/blob/42413cabbedca429d55a5378f6e830f191f3cc86/INSTALL#L51
  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DWITH_INOTIFY=OFF"
    "-DWITH_FSEVENTS=ON"
    "-DXNU_DIR=${xnu}"
  ];

  dontUseCmakeBuildDir = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    rsync
    lua5_2_compat
    asciidoc
    libxml2
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
  ];

  meta = {
    homepage = "https://github.com/lsyncd/lsyncd";
    description = "Utility that synchronizes local directories with remote targets";
    mainProgram = "lsyncd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
  };
})

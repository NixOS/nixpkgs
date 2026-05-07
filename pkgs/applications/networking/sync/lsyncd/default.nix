{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lua,
  pkg-config,
  rsync,
  asciidoc,
  libxml2,
  docbook_xml_dtd_45,
  docbook_xsl,
  libxslt,
  pkgs,
}:

let
  f =
    pkgs: prev:
    if
      !pkgs.stdenv.hostPlatform.isDarwin
      || pkgs.stdenv.name == "bootstrap-stage0-stdenv-darwin"
      || !(pkgs.stdenv ? __bootPackages)
    then
      prev.darwin.sourceRelease
    else
      f pkgs.stdenv.__bootPackages pkgs;
  bootstrapSourceRelease = f pkgs pkgs;
  # TODO(reckenrode): Use `sourceRelease` after migration has been merged and all releases updated to the same version.
  xnu = bootstrapSourceRelease "xnu";
in
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
    lua
    asciidoc
    libxml2
    docbook_xml_dtd_45
    docbook_xsl
    libxslt
  ];

  meta = {
    homepage = "https://github.com/axkibe/lsyncd";
    description = "Utility that synchronizes local directories with remote targets";
    mainProgram = "lsyncd";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bobvanderlinden ];
  };
}

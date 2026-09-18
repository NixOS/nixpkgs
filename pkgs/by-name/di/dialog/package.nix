{
  lib,
  stdenv,
  fetchurl,
  libtool,
  ncurses,
  enableShared ? !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isStatic,
  unicodeSupport ? true,
  withLibrary ? true,
}:

assert unicodeSupport -> ncurses.unicodeSupport;
stdenv.mkDerivation (finalAttrs: {
  pname = "dialog";
  version = "1.3-20260107";

  src = fetchurl {
    url = "https://invisible-island.net/archives/dialog/dialog-${finalAttrs.version}.tgz";
    hash = "sha256-eLPdGNleUPC+j5ucHnz/4oyb8c3yDVs+8XJ5xNo1xbU=";
  };

  nativeBuildInputs = lib.optionals withLibrary [
    libtool
  ];

  buildInputs = [
    ncurses
  ];

  strictDeps = true;

  configureFlags = [
    "--disable-rpath-hacks"
    "--${if withLibrary then "with" else "without"}-libtool"
    "--with-libtool-opts=${lib.optionalString enableShared "-shared"}"
    "--with-ncurses${lib.optionalString unicodeSupport "w"}"
  ];

  installTargets = [
    "install${lib.optionalString withLibrary "-full"}"
  ];

  meta = {
    homepage = "https://invisible-island.net/dialog/dialog.html";
    description = "Display dialog boxes from shell";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "dialog";
    maintainers = with lib.maintainers; [
      spacefrogg
    ];
    inherit (ncurses.meta) platforms;
  };
})

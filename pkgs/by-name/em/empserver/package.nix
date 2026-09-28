{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  groff,
  ncurses,
  perl,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "empserver";
  version = "4.4.1";

  src = fetchFromGitHub {
    owner = "gefla";
    repo = "empserver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FhU3pkv6v1sqEaFje/lrO4hikH2gfW55e21HlOyl7WA=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    groff
    perl
  ];

  buildInputs = [
    ncurses
    readline
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # The git snapshot lacks generated files that upstream's distribution
  # tarballs carry and the build requires: sources.mk (list of source
  # files), .tarball-version (version without the leading "v" of the
  # tag) and its stamp file .dirty-stamp.  Create them before running
  # ./bootstrap, so its own generated files don't end up in sources.mk.
  # .tarball-version must be in place when autoconf runs, sources.mk
  # before configure and make.
  postUnpack = ''
    echo "src := $(find "$sourceRoot" -type f \
      ! -name sources.mk ! -name .tarball-version ! -name .dirty-stamp \
      -printf '%P\n' | sort | tr '\n' ' ')" > "$sourceRoot/sources.mk"
    echo "${finalAttrs.version}" > "$sourceRoot/.tarball-version"
    touch "$sourceRoot/.dirty-stamp"
  '';

  preConfigure = ''
    ./bootstrap
  '';

  doCheck = true;

  meta = {
    description = "Multi-player, client/server Internet based war game";
    homepage = "https://www.wolfpackempire.com/";
    license = lib.licenses.gpl3Plus;
    mainProgram = "empire";
    maintainers = with lib.maintainers; [ gefla ];
    platforms = lib.platforms.unix;
  };
})

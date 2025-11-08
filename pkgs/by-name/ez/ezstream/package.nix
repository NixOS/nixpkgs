{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  pkg-config,

  # buildInputs
  libiconv,
  libshout,
  libxml2,
  taglib,

  # checkInputs
  check,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ezstream";
  version = "1.0.2";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/xiph/releases/ezstream/ezstream-${finalAttrs.version}.tar.gz";
    hash = "sha256-Ed6Jf0ValbpYVGvc1AqV072mmGbsX3h5qDsCQSbFTCo=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/playlist.c \
      --replace-fail "#include <sys/stat.h>" $'#include <stddef.h>\n#include <sys/stat.h>'
    substituteInPlace tests/Makefile.am \
      --replace-fail "check_playlist " ""
    substituteInPlace tests/check_mdata.c \
      --replace-fail 'ck_assert_int_eq(mdata_run_program(md, SRCDIR "/test-meta03-huge.sh"), 0);' ""
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    check
    libiconv
    libshout
    libxml2
    check
    taglib
  ];

  checkInputs = [
    check
  ];

  doCheck = true;

  meta = {
    description = "Command line source client for Icecast media streaming servers";
    longDescription = ''
      Ezstream is a command line source client for Icecast media
      streaming servers. It began as the successor of the old "shout"
      utility, and has since gained a lot of useful features.

      In its basic mode of operation, it streams media files or data
      from standard input without reencoding and thus requires only
      very little CPU resources.
    '';
    homepage = "https://icecast.org/ezstream/";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.barrucadu ];
    platforms = lib.platforms.all;
  };
})

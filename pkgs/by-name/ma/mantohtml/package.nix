{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mantohtml";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = "mantohtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1hNKNCAYTYAAHIdodr5b8tqd8RFB2a5Ug78XeNj08Xc=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'prefix	=	$(DESTDIR)/usr/local' 'prefix=$(DESTDIR)'
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "Man page to HTML converter";
    homepage = "https://github.com/michaelrsweet/mantohtml";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
})

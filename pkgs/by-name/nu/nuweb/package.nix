{
  lib,
  stdenv,
  fetchurl,
  texliveMedium,
}:

stdenv.mkDerivation rec {

  pname = "nuweb";
  version = "1.62";

  src = fetchurl {
    url = "mirror://sourceforge/project/nuweb/${pname}-${version}.tar.gz";
    sha256 = "sha256-JVqPYkYPXBT0xLNWuW4DV6N6ZlKuBYQGT46frhnpU64=";
  };

  buildInputs = [ texliveMedium ];

  patchPhase = ''
    sed -i -e 's|nuweb -r|./nuweb -r|' Makefile
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: global.o:/build/nuweb-1.62/global.h:91: multiple definition of
  #     `current_sector'; main.o:/build/nuweb-1.62/global.h:91: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildPhase = ''
    make nuweb
    make nuweb.pdf nuwebdoc.pdf all
  '';
  installPhase = ''
    install -d $out/bin $out/share/man/man1 $out/share/doc/${pname}-${version} $out/share/emacs/site-lisp
    cp nuweb $out/bin
    cp nuweb.el $out/share/emacs/site-lisp
    gzip -c nuweb.1 > $out/share/man/man1/nuweb.1.gz
    cp htdocs/index.html nuweb.w nuweb.pdf nuwebdoc.pdf README $out/share/doc/${pname}-${version}
  '';

  meta = with lib; {
    description = "Simple literate programming tool";
    mainProgram = "nuweb";
    homepage = "https://nuweb.sourceforge.net";
    license = licenses.free;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: nuweb.el Emacs integration

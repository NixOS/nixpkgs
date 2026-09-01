{
  lib,
  stdenv,
  fetchurl,
  texliveMedium,
}:

stdenv.mkDerivation rec {
  pname = "nuweb";
  version = "1.64";

  src = fetchurl {
    url = "mirror://sourceforge/project/nuweb/nuweb-${version}.tar.gz";
    hash = "sha256-DEi0cbcyO8qUDXbIRS3JtYixezaPX/vxDddbF7hbGeA=";
  };

  buildInputs = [ texliveMedium ];

  postPatch = ''
    sed -i -e 's|nuweb -r|./nuweb -r|' Makefile
  '';

  # GCC 15 uses C23, which fails with the following error
  # main.c:4:5: warning: old-style function definition [-Wold-style-definition]
  #     4 | int main(argc, argv)
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  buildPhase = ''
    runHook preBuild

    make nuweb
    make nuweb.pdf nuwebdoc.pdf all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/bin $out/share/man/man1 $out/share/doc/nuweb-${version} $out/share/emacs/site-lisp
    cp nuweb $out/bin
    cp nuweb.el $out/share/emacs/site-lisp
    gzip -c nuweb.1 > $out/share/man/man1/nuweb.1.gz
    cp htdocs/index.html nuweb.w nuweb.pdf nuwebdoc.pdf README $out/share/doc/nuweb-${version}

    runHook postInstall
  '';

  meta = {
    description = "Simple literate programming tool";
    mainProgram = "nuweb";
    homepage = "https://nuweb.sourceforge.net";
    license = lib.licenses.free;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
# TODO: nuweb.el Emacs integration

{
  lib,
  stdenv,
  fetchurl,
  gmp,
  withEmacsSupport ? true,
  withContrib ? true,
}:

let
  versionPkg = "0.4.2";

  contrib = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-contrib-${versionPkg}.tgz";
    hash = "sha256-m0hfBLsaNiLaIktcioK+ZtWUsWht3IDSJ6CzgJmS06c=";
  };

  postInstallContrib = lib.optionalString withContrib ''
    local contribDir=$out/lib/ats2-postiats-*/ ;
    mkdir -p $contribDir ;
    tar -xzf "${contrib}" --strip-components 1 -C $contribDir ;
  '';

  postInstallEmacs = lib.optionalString withEmacsSupport ''
    local siteLispDir=$out/share/emacs/site-lisp/ats2 ;
    mkdir -p $siteLispDir ;
    install -m 0644 -v ./utils/emacs/*.el $siteLispDir ;
  '';
in

stdenv.mkDerivation rec {
  pname = "ats2";
  version = versionPkg;

  src = fetchurl {
    url = "mirror://sourceforge/ats2-lang/ATS2-Postiats-gmp-${version}.tgz";
    hash = "sha256-UWgDjFojPBYgykrCrJyYvVWY+Gc5d4aRGjTWjc528AM=";
  };

  postPatch = ''
    for i in cstream intinf libgmp libjson-c libpcre; do
      ln -sf ../../../../../share/Makefile.gen contrib/atscntrb/atscntrb-hx-$i/SATS/DOCUGEN/Makefile.gen
    done
    for i in libcairo libsdl2; do
      ln -sf ../../../../../../share/Makefile.gen npm-utils/contrib/atscntrb/atscntrb-hx-$i/SATS/DOCUGEN/Makefile.gen
    done
  ''
  + lib.optionalString stdenv.cc.isClang ''
    sed -i 's/gcc/clang/g' utils/*/DATS/atscc_util.dats
  '';

  buildInputs = [ gmp ];

  # Disable parallel build, errors:
  #  *** No rule to make target 'patscc.dats', needed by 'patscc_dats.c'.  Stop.
  enableParallelBuilding = false;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CCOMP=${stdenv.cc.targetPrefix}cc"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";

  setupHook =
    let
      hookFiles = [ ./setup-hook.sh ] ++ lib.optional withContrib ./setup-contrib-hook.sh;
    in
    builtins.toFile "setupHook.sh" (lib.concatMapStringsSep "\n" builtins.readFile hookFiles);

  postInstall = postInstallContrib + postInstallEmacs;

  meta = with lib; {
    description = "Functional programming language with dependent types";
    homepage = "http://www.ats-lang.org";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      thoughtpolice
      ttuegel
      bbarker
    ];
  };
}

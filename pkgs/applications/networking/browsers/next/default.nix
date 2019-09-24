{ pkgs, stdenv, fetchFromGitHub
, gcc7, pkg-config, makeWrapper
, glib-networking
, next-gtk-webkit
, lispPackages
, sbcl
}:

stdenv.mkDerivation rec {
    pname = "next";
    version = "1.3.1";

    src = fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "next";
      rev = version;
      sha256 = "01fn1f080ydk0wj1bwkyakqz93bdq9xb5x8qz820jpl9id17bqgj";
    };

    # Stripping destroys the generated SBCL image
    dontStrip = true;

    prePatch = ''
      substituteInPlace source/ports/gtk-webkit.lisp \
        --replace "next-gtk-webkit" "${next-gtk-webkit}/bin/next-gtk-webkit"
    '';

    nativeBuildInputs = [ sbcl makeWrapper ];
    buildInputs = with lispPackages; [
      trivial-features
      trivial-garbage
      alexandria
      bordeaux-threads
      cl-json
      cl-markup
      cl-ppcre
      cl-ppcre-unicode
      closer-mop
      dexador
      ironclad
      lparallel
      parenscript
      quri
      cl-css
      log4cl
      mk-string-metrics
      sqlite
      str
      swank
      trivia
      trivial-clipboard
      unix-opts
      dbus
    ];
    propagatedBuildInputs = [ next-gtk-webkit ];

    buildPhase = ''
      common-lisp.sh --eval "(require :asdf)" \
                     --eval "(asdf:load-asd (truename \"next.asd\") :name \"next\")" \
                     --eval '(asdf:make :next)' \
                     --quit
    '';

    installPhase = ''
      install -D -m0755 next $out/bin/next
    '';

    preFixup = ''
      wrapProgram $out/bin/next \
        --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules"
    '';

    meta = with stdenv.lib; {
      description = "Infinitely extensible web-browser (with Lisp development files)";
      homepage = https://next.atlas.engineer;
      license = licenses.bsd3;
      maintainers = [ maintainers.lewo ];
      platforms = [ "x86_64-linux" ];
    };
  }

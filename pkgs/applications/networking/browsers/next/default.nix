{ pkgs, stdenv, fetchFromGitHub
, gcc7, pkg-config, makeWrapper
, glib-networking
, next-gtk-webkit
, lispPackages
, sbcl
}:

stdenv.mkDerivation rec {
    pname = "next";
    version = "1.3.4";

    src = fetchFromGitHub {
      owner = "atlas-engineer";
      repo = "next";
      rev = version;
      sha256 = "00iqv4xarabl98gdl1rzqkc5v0vfljx1nawsxqsx9x3a9mnxmgxi";
    };

    # Stripping destroys the generated SBCL image
    dontStrip = true;

    prePatch = ''
      substituteInPlace source/ports/gtk-webkit.lisp \
        --replace "next-gtk-webkit" "${next-gtk-webkit}/bin/next-gtk-webkit"
    '';

    nativeBuildInputs =
      [ sbcl makeWrapper ] ++ (with lispPackages;
      [ prove-asdf trivial-features ]);

    buildInputs = with lispPackages; [
      alexandria
      bordeaux-threads
      cl-annot
      cl-ansi-text
      cl-css
      cl-hooks
      cl-json
      cl-markup
      cl-ppcre
      cl-ppcre-unicode
      cl-prevalence
      closer-mop
      dbus
      dexador
      ironclad
      local-time
      log4cl
      lparallel
      mk-string-metrics
      parenscript
      quri
      sqlite
      str
      swank
      trivia
      trivial-clipboard
      unix-opts
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

{ stdenv
, fetchFromGitHub
, lispPackages
, sbcl
, callPackage
}:

let

  # This is the wrapped webkitgtk platform port that we hardcode into the Lisp Core.
  # See https://github.com/atlas-engineer/next/tree/master/ports#next-platform-ports
  next-gtk-webkit = callPackage ./next-gtk-webkit.nix {};

in

stdenv.mkDerivation rec {
  pname = "next";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "atlas-engineer";
    repo = "next";
    rev = version;
    sha256 = "00iqv4xarabl98gdl1rzqkc5v0vfljx1nawsxqsx9x3a9mnxmgxi";
  };

  nativeBuildInputs = [
    sbcl
  ] ++ (with lispPackages; [
    prove-asdf
    trivial-features
  ]);

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

  # This reference is unfortunately not detected by Nix
  propagatedBuildInputs = [ next-gtk-webkit ];

  prePatch = ''
    substituteInPlace source/ports/gtk-webkit.lisp \
      --replace "next-gtk-webkit" "${next-gtk-webkit}/bin/next-gtk-webkit"
  '';

  buildPhase = ''
    common-lisp.sh --eval "(require :asdf)" \
                   --eval "(asdf:load-asd (truename \"next.asd\") :name \"next\")" \
                   --eval '(asdf:make :next)' \
                   --quit
  '';

  installPhase = ''
    install -D -m0755 next $out/bin/next
  '';

  # Stripping destroys the generated SBCL image
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Infinitely extensible web-browser (with Lisp development files using WebKitGTK platform port)";
    homepage = https://next.atlas.engineer;
    license = licenses.bsd3;
    maintainers = [ maintainers.lewo ];
    platforms = [ "x86_64-linux" ];
  };
}

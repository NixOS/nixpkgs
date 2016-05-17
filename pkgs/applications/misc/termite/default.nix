{ stdenv, fetchgit, pkgconfig, vte, gtk3, ncurses, makeWrapper
, configFile ? null
}:

let 
  version = "11";
  termite = stdenv.mkDerivation {
    name = "termite-${version}";

    src = fetchgit {
      url = "https://github.com/thestinger/termite";
      rev = "refs/tags/v${version}";
      sha256 = "1k91nw19c0p5ghqhs00mn9npa91idfkyiwik3ng6hb4jbnblp5ph";
    };

    makeFlags = [ "VERSION=v${version}" "PREFIX=" "DESTDIR=$(out)" ];

    buildInputs = [ pkgconfig vte gtk3 ncurses ];

    outputs = [ "out" "terminfo" ];

    postInstall = ''
      mkdir -p $terminfo/share
      mv $out/share/terminfo $terminfo/share/terminfo

      mkdir -p $out/nix-support
      echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    '';

    meta = with stdenv.lib; {
      description = "A simple VTE-based terminal";
      license = licenses.lgpl2Plus;
      homepage = https://github.com/thestinger/termite/;
      maintainers = with maintainers; [ koral garbas ];
      platforms = platforms.all;
    };
  };
in if configFile == null then termite else stdenv.mkDerivation {
  name = "termite-with-config-${version}";
  nativeBuildInputs = [ makeWrapper ];
  buildCommand = ''
    mkdir -p $out/etc/xdg/termite/ $out/bin
    ln -s ${termite}/bin/termite $out/bin/termite
    wrapProgram $out/bin/termite --add-flags "--config ${configFile}"
  '';
  passthru.terminfo = termite.terminfo;
}

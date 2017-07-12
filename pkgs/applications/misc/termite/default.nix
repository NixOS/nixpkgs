{ stdenv, fetchFromGitHub, pkgconfig, vte, gtk3, ncurses, makeWrapper, symlinkJoin
, configFile ? null
}:

let
  version = "12";
  termite = stdenv.mkDerivation {
    name = "termite-${version}";

    src = fetchFromGitHub {
      owner = "thestinger";
      repo = "termite";
      rev = "refs/tags/v${version}";
      sha256 = "08piid6j9ixcdh6b77hmyxr56maa67q4l0fz8wk3j1f7cp98942m";
    };

    postPatch = "sed '1i#include <math.h>' -i termite.cc";

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
in if configFile == null then termite else symlinkJoin {
  name = "termite-with-config-${version}";
  paths = [ termite ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/termite \
      --add-flags "--config ${configFile}"
  '';
  passthru.terminfo = termite.terminfo;
}

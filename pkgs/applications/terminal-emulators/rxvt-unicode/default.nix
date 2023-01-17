{ lib, stdenv, fetchurl, fetchpatch, makeDesktopItem
, libX11, libXt, libXft, libXrender
, ncurses, fontconfig, freetype
, pkg-config, gdk-pixbuf, perl
, libptytty
, perlSupport      ? true
, gdkPixbufSupport ? true
, unicode3Support  ? true
, emojiSupport     ? false
, nixosTests
}:

let
  pname = "rxvt-unicode";
  version = "9.30";
  description = "A clone of the well-known terminal emulator rxvt";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "urxvt";
    icon = "utilities-terminal";
    comment = description;
    desktopName = "URxvt";
    genericName = pname;
    categories = [ "System" "TerminalEmulator" ];
  };

  fetchPatchFromAUR = { package, name, rev, sha256 }:
    fetchpatch rec {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=${package}&id=${rev}";
      extraPrefix = "";
      inherit name sha256;
    };
in

stdenv.mkDerivation {
  name = "${pname}-unwrapped-${version}";
  inherit pname version;

  src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${version}.tar.bz2";
    sha256 = "0badnkjsn3zps24r5iggj8k5v4f00npc77wqg92pcn1q5z8r677y";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ libX11 libXt libXft ncurses  # required to build the terminfo file
      fontconfig freetype libXrender
      libptytty
    ] ++ lib.optional perlSupport perl
      ++ lib.optional gdkPixbufSupport gdk-pixbuf;

  outputs = [ "out" "terminfo" ];

  patches = (if emojiSupport then [
    # the required patches to libXft are in nixpkgs by default, see
    # ../../../servers/x11/xorg/overrides.nix
    (fetchPatchFromAUR {
      name = "enable-wide-glyphs.patch";
      package = "rxvt-unicode-truecolor-wide-glyphs";
      rev = "69701a09c2c206233952b84bc966407f6774f1dc";
      sha256 = "0jfcj0ahky4dxdfrhqvh1v83mblhf5nak56dk1vq3bhyifdg7ffq";
    })
    (fetchPatchFromAUR {
      name = "improve-font-rendering.patch";
      package = "rxvt-unicode-truecolor-wide-glyphs";
      rev = "69701a09c2c206233952b84bc966407f6774f1dc";
      sha256 = "1jj5ai2182nq912279adihi4zph1w4dvbdqa1pwacy4na6y0fz9y";
    })
  ] else [
    ./patches/9.06-font-width.patch
  ]) ++ [
    ./patches/256-color-resources.patch
  ]++ lib.optional stdenv.isDarwin ./patches/makefile-phony.patch;

  configureFlags = [
    "--with-terminfo=${placeholder "terminfo"}/share/terminfo"
    "--enable-256-color"
    (lib.enableFeature perlSupport "perl")
    (lib.enableFeature unicode3Support "unicode3")
  ] ++ lib.optional emojiSupport "--enable-wide-glyphs";

  LDFLAGS = [ "-lfontconfig" "-lXrender" "-lpthread" ];
  CFLAGS = [ "-I${freetype.dev}/include/freetype2" ];

  preConfigure =
    ''
      # without this the terminfo won't be compiled by tic, see man tic
      mkdir -p $terminfo/share/terminfo
      export TERMINFO=$terminfo/share/terminfo
    ''
    + lib.optionalString perlSupport ''
      # make urxvt find its perl file lib/perl5/site_perl
      # is added to PERL5LIB automatically
      mkdir -p $out/$(dirname ${perl.libPrefix})
      ln -s $out/lib/urxvt $out/${perl.libPrefix}
    '';

  postInstall = ''
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
    cp -r ${desktopItem}/share/applications/ $out/share/
  '';

  passthru.tests.test = nixosTests.terminal-emulators.urxvt;

  meta = with lib; {
    inherit description;
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
    downloadPage = "http://dist.schmorp.de/rxvt-unicode/Attic/";
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
    license = licenses.gpl3;
  };
}

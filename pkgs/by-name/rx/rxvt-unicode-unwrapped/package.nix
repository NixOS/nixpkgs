{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  makeDesktopItem,
  libx11,
  libxt,
  libxft,
  libxrender,
  libxext,
  ncurses,
  fontconfig,
  freetype,
  pkg-config,
  gdk-pixbuf,
  perl,
  libptytty,
  perlSupport ? true,
  gdkPixbufSupport ? true,
  unicode3Support ? true,
  emojiSupport ? false,
  nixosTests,
}:

let
  pname = "rxvt-unicode";
  version = "9.31";
  description = "Clone of the well-known terminal emulator rxvt";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = "urxvt";
    icon = "utilities-terminal";
    comment = description;
    desktopName = "URxvt";
    genericName = pname;
    categories = [
      "System"
      "TerminalEmulator"
    ];
  };

in
stdenv.mkDerivation {
  name = "${pname}-unwrapped-${version}";
  inherit pname version;

  src = fetchurl {
    url = "https://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${version}.tar.bz2";
    sha256 = "qqE/y8FJ/g8/OR+TMnlYD3Spb9MS1u0GuP8DwtRmcug=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libx11
    libxt
    libxft
    ncurses # required to build the terminfo file
    fontconfig
    freetype
    libxrender
    libptytty
  ]
  ++ lib.optionals perlSupport [
    perl
    libxext
  ]
  ++ lib.optional gdkPixbufSupport gdk-pixbuf;

  outputs = [
    "out"
    "terminfo"
  ];

  patches =
    (
      if emojiSupport then
        [
          # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/enable-wide-glyphs.patch?h=rxvt-unicode-truecolor-wide-glyphs&id=69701a09c2c206233952b84bc966407f6774f1dc
          ./patches/enable-wide-glyphs.patch
          # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/improve-font-rendering.patch?h=rxvt-unicode-truecolor-wide-glyphs&id=69701a09c2c206233952b84bc966407f6774f1dc
          ./patches/improve-font-rendering.patch
        ]
      else
        [
          ./patches/9.06-font-width.patch
        ]
    )
    ++ [
      ./patches/256-color-resources.patch
      # Vendored from https://aur.archlinux.org/cgit/aur.git/plain/7-bit-queries.patch?h=rxvt-unicode-truecolor-wide-glyphs&id=61ed186890a2bf37585e4704a095be61e6504ac6
      ./patches/7-bit-queries.patch
    ]
    ++ lib.optional (perlSupport && lib.versionAtLeast perl.version "5.38") (fetchpatch {
      name = "perl538-locale-c.patch";
      url = "https://github.com/exg/rxvt-unicode/commit/16634bc8dd5fc4af62faf899687dfa8f27768d15.patch";
      excludes = [ "Changes" ];
      sha256 = "sha256-JVqzYi3tcWIN2j5JByZSztImKqbbbB3lnfAwUXrumHM=";
    })
    ++ lib.optional stdenv.hostPlatform.isDarwin ./patches/makefile-phony.patch;

  configureFlags = [
    "--with-terminfo=${placeholder "terminfo"}/share/terminfo"
    "--enable-256-color"
    (lib.enableFeature perlSupport "perl")
    (lib.enableFeature unicode3Support "unicode3")
  ]
  ++ lib.optional emojiSupport "--enable-wide-glyphs";

  env = {
    LDFLAGS = toString [
      "-lfontconfig"
      "-lXrender"
      "-lpthread"
    ];
    CFLAGS = toString [
      "-I${freetype.dev}/include/freetype2"
    ];
  };

  preConfigure = ''
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

  meta = {
    inherit description;
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
    downloadPage = "http://dist.schmorp.de/rxvt-unicode/Attic/";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
    mainProgram = "urxvt";
  };
}

{ stdenv, fetchurl, makeWrapper, symlinkJoin, writeShellScriptBin, callPackage, defaultCrateOverrides
, wayland, wlc, cairo, libxkbcommon, pam, python3Packages, lemonbar, gdk_pixbuf
}:

let
  # refer to
  # https://github.com/way-cooler/way-cooler.github.io/blob/master/way-cooler-release-i3-default.sh
  # for version numbers
  cratesIO = callPackage ./crates-io.nix {};

  fakegit = writeShellScriptBin "git" ''
    echo ""
  '';
  # https://nest.pijul.com/pmeunier/carnix/discussions/22
  version = "0.8.1";
  deps = (callPackage ./way-cooler.nix {}).deps;
  way_cooler_ = f: cratesIO.crates.way_cooler."${version}" deps {
    features = cratesIO.features_.way_cooler."${version}" deps {
      "way_cooler"."${version}" = f;
    };
  };
  way-cooler = ((way_cooler_ { builtin-lua = true; }).override {
    crateOverrides = defaultCrateOverrides // {

    way-cooler = attrs: { buildInputs = [ wlc cairo libxkbcommon fakegit gdk_pixbuf wayland ]; };
  };}).overrideAttrs (oldAttrs: rec {
    postBuild = ''
      mkdir -p $out/etc
      cp -r config $out/etc/way-cooler
    '';
  });

  wc-bg = ((callPackage ./wc-bg.nix {}).wc_bg {}).overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = [ makeWrapper ];

    postFixup = ''
      makeWrapper $out/bin/wc-bg $out/bin/wc-bg \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ wayland ]}"
    '';
  });

  wc-grab = (callPackage ./wc-grab.nix {}).wc_grab {};

  wc-lock = (((callPackage ./wc-lock.nix {}).wc_lock {}).override {
    crateOverrides = defaultCrateOverrides // {

    wc-lock = attrs: { buildInputs = [ pam ]; };
  };}).overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = [ makeWrapper ];

    postFixup = ''
      makeWrapper $out/bin/wc-lock $out/bin/wc-lock \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libxkbcommon wayland ]}"
    '';
  });

  # https://github.com/way-cooler/way-cooler/issues/446
  wc-bar-bare = stdenv.mkDerivation {
    name = "wc-bar-bare-2017-12-05";

    src = fetchurl {
      url = "https://github.com/way-cooler/way-cooler/files/1529701/bar.py.txt";
      sha256 = "1n1rf1k02i6vimr9n0iksf65phhyy96i5wh5d0rrx7yqki3dh6ka";
    };

    unpackPhase = "cat $src > bar.py.txt";

    # https://github.com/way-cooler/way-cooler/issues/446#issuecomment-350567833
    patches = [ ./bar.diff ];

    pythonPath = with python3Packages; [ pydbus ];
    nativeBuildInputs = with python3Packages; [ python wrapPython ];

    installPhase = ''
      install -Dm755 bar.py.txt $out/bin/bar.py
      patchShebangs $out/bin/bar.py
      wrapPythonPrograms
    '';
  };
  wc-bar = writeShellScriptBin "lemonbar" ''
    SELECTED="#000000"
    SELECTED_OTHER_WORKSPACE="#555555"
    BACKGROUND="#4E2878"
    # https://github.com/way-cooler/way-cooler/issues/446#issuecomment-349471439
    sleep 5
    ${wc-bar-bare}/bin/bar.py $SELECTED $BACKGROUND $SELECTED_OTHER_WORKSPACE 2> /tmp/bar_debug.txt | ${lemonbar}/bin/lemonbar -B $BACKGROUND -F "#FFF" -n "lemonbar" -p -d
  '';
in symlinkJoin rec {
  inherit version;
  name = "way-cooler-with-extensions-${version}";
  paths = [ way-cooler wc-bg wc-grab wc-lock wc-bar ];

  meta = with stdenv.lib; {
    description = "Customizable Wayland compositor (window manager)";
    longDescription = ''
      Way Cooler is a customizable tiling window manager written in Rust
      for Wayland and configurable using Lua. It is heavily inspired by
      the tiling and extensibility of both i3 and awesome. While Lua is
      used for the configuration, like awesome, extensions for Way Cooler
      are implemented as totally separate client programs using D-Bus.
      This means that you can use virtually any language to extend the
      window manager, with much better guarantees about interoperability
      between extensions.
    '';
    homepage = http://way-cooler.org/;
    license = with licenses; [ mit ];
    maintainers = [ maintainers.miltador ];
    broken = stdenv.hostPlatform.isAarch64; # fails to build wc-bg (on aarch64)
    platforms = platforms.all;
  };
}

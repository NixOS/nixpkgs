{ stdenv, fetchFromGitHub, fetchurl, pkgconfig, makeWrapper, symlinkJoin, writeShellScriptBin, callPackage, defaultCrateOverrides
, wayland, wlc, dbus_libs, dbus_glib, cairo, libxkbcommon, pam, python3Packages, lemonbar
}:

let
  # refer to
  # https://github.com/way-cooler/way-cooler.github.io/blob/master/way-cooler-release-i3-default.sh
  # for version numbers
  fakegit = writeShellScriptBin "git" ''
    echo ""
  '';
  way-cooler = ((callPackage ./way-cooler.nix {}).way_cooler_0_6_2.override {
    crateOverrides = defaultCrateOverrides // {

    way-cooler = attrs: { buildInputs = [ wlc cairo libxkbcommon fakegit ]; };
    dbus = attrs: { buildInputs = [ pkgconfig dbus_libs ]; };
    gobject-sys = attrs: { buildInputs = [ dbus_glib ]; };
    cairo-rs = attrs: { buildInputs = [ cairo ]; };
  };}).overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = [ makeWrapper ];

    postBuild = ''
      mkdir -p $out/etc
      cp -r config $out/etc/way-cooler
    '';
    # prior v0.7 https://github.com/way-cooler/way-cooler/issues/395
    postFixup = ''
      makeWrapper $out/bin/way_cooler $out/bin/way-cooler \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ wayland ]}"
    '';
  });
  wc-bg = ((callPackage ./wc-bg.nix {}).way_cooler_bg_0_2_1.override {
    crateOverrides = defaultCrateOverrides // {

    dbus = attrs: { buildInputs = [ pkgconfig dbus_libs ]; };
  };}).overrideAttrs (oldAttrs: rec {
    postFixup = ''
      cd $out/bin
      mv way_cooler_bg way-cooler-bg
    '';
  });
  wc-grab = ((callPackage ./wc-grab.nix {}).wc_grab_0_2_0.override {
    crateOverrides = defaultCrateOverrides // {

    wc-grab = attrs: {
      src = fetchFromGitHub {
        owner = "way-cooler";
        repo = "way-cooler-grab";
        rev = "v0.2.0";
        sha256 = "1pc8rhvzdi6bi8g5w03i0ygbcpks9051c3d3yc290rgmmmmkmnwq";
      };
    };

    dbus = attrs: { buildInputs = [ pkgconfig dbus_libs ]; };
  };}).overrideAttrs (oldAttrs: rec {
    postFixup = ''
      cd $out/bin
      mv wc_grab wc-grab
    '';
  });
  wc-lock = ((callPackage ./wc-lock.nix {}).wc_lock_0_1_0.override {
    crateOverrides = defaultCrateOverrides // { wc-lock = attrs: {

    buildInputs = [ pam ];
  };};}).overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = [ makeWrapper ];

    postFixup = ''
      makeWrapper $out/bin/wc_lock $out/bin/wc-lock \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libxkbcommon ]}"
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
  version = "0.6.2";
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
    platforms = platforms.all;
  };
}

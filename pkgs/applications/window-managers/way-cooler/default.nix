{ stdenv, fetchFromGitHub, fetchurl, rustPlatform, pkgconfig, makeWrapper, symlinkJoin, writeShellScriptBin
, wayland, wlc, dbus_libs, dbus_glib, cairo, libxkbcommon, pam, python3Packages, lemonbar
}:

with rustPlatform;

let
  # refer to
  # https://github.com/way-cooler/way-cooler.github.io/blob/master/way-cooler-release-i3-default.sh
  # for version numbers
  version = "0.6.2";
  way-cooler = buildRustPackage rec {
    name = "way-cooler-${version}";

    src = fetchFromGitHub {
      owner = "way-cooler";
      repo = "way-cooler";
      rev = "v${version}";
      sha256 = "16zswn17c11piby899ciq386m7h7vjvr96f75l35qiswkmwb83kj";
    };

    cargoSha256 = "1b1mzjicgz1s0gvxq0d54l7r8jnyl0yzmv801n78yl4hwmmf7clv";

    buildInputs = [ wlc dbus_libs dbus_glib cairo libxkbcommon ];

    nativeBuildInputs = [ pkgconfig makeWrapper ];

    postBuild = ''
      mkdir -p $out/etc
      cp -r config $out/etc/way-cooler
    '';
    # prior v0.7 https://github.com/way-cooler/way-cooler/issues/395
    postFixup = ''
      wrapProgram $out/bin/way-cooler \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ wayland ]}"
    '';
  };
  wc-bg = buildRustPackage rec {
    name = "wc-bg-${version}";
    version = "0.2.1";

    src = fetchFromGitHub {
      owner = "way-cooler";
      repo = "way-cooler-bg";
      rev = "v${version}";
      sha256 = "0xg19vz6r054dvhlwgj9pq36pv7xyc4canb8cm4bxgil4rar47bc";
    };

    cargoSha256 = "1dc4paazcd149arrhp7xx0arxmqasxr2c95iywpifwljq1qnfkl7";

    buildInputs = [ dbus_libs ];

    nativeBuildInputs = [ pkgconfig ];
  };
  wc-grab = buildRustPackage rec {
    name = "wc-grab-${version}";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "way-cooler";
      repo = "way-cooler-grab";
      rev = "v${version}";
      sha256 = "1pc8rhvzdi6bi8g5w03i0ygbcpks9051c3d3yc290rgmmmmkmnwq";
    };

    cargoSha256 = "06h5bq68ypwd74fwj06fxflfjjqd1gvpdf55jkan5l5jx6n1xjhs";

    buildInputs = [ dbus_libs ];

    nativeBuildInputs = [ pkgconfig ];
  };
  wc-lock = buildRustPackage rec {
    name = "wc-lock-${version}";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "way-cooler";
      repo = "way-cooler-lock";
      rev = "v${version}";
      sha256 = "1dimxypmba6i7ziglhy3577j05q0s4k8l4khs2p8bgkrc8i0g0lh";
    };

    cargoSha256 = "1sbp86vk8fbq90kcw3hn9lxidnls9dr2pgxknvfpp5cidlqxdbfw";

    buildInputs = [ pam ];

    nativeBuildInputs = [ makeWrapper ];

    postFixup = ''
      wrapProgram $out/bin/wc-lock \
        --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ libxkbcommon ]}"
    '';
  };
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
in symlinkJoin {
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

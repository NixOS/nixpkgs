{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

# aho-corasick-0.5.3

  crates.aho_corasick."0.5.3" = deps: { features?(features_.aho_corasick."0.5.3" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.5.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1igab46mvgknga3sxkqc917yfff0wsjxjzabdigmh240p5qxqlnn";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.5.3"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.5.3" = deps: f: updateFeatures f (rec {
    aho_corasick."0.5.3".default = (f.aho_corasick."0.5.3".default or true);
    memchr."${deps.aho_corasick."0.5.3".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.5.3"."memchr"}" deps)
  ];


# end
# bitflags-0.4.0

  crates.bitflags."0.4.0" = deps: { features?(features_.bitflags."0.4.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.4.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0an03kibhfcc0mcxf6a0mvbab0s7cggnvflw8jn0b15i351h828c";
    features = mkFeatures (features."bitflags"."0.4.0" or {});
  };
  features_.bitflags."0.4.0" = deps: f: updateFeatures f (rec {
    bitflags."0.4.0".default = (f.bitflags."0.4.0".default or true);
  }) [];


# end
# bitflags-0.6.0

  crates.bitflags."0.6.0" = deps: { features?(features_.bitflags."0.6.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.6.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1znq4b770mdp3kdj9yz199ylc2pmf8l5j2f281jjrcfhg1mm22h6";
  };
  features_.bitflags."0.6.0" = deps: f: updateFeatures f (rec {
    bitflags."0.6.0".default = (f.bitflags."0.6.0".default or true);
  }) [];


# end
# bitflags-0.7.0

  crates.bitflags."0.7.0" = deps: { features?(features_.bitflags."0.7.0" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.7.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1hr72xg5slm0z4pxs2hiy4wcyx3jva70h58b7mid8l0a4c8f7gn5";
  };
  features_.bitflags."0.7.0" = deps: f: updateFeatures f (rec {
    bitflags."0.7.0".default = (f.bitflags."0.7.0".default or true);
  }) [];


# end
# bitflags-0.9.1

  crates.bitflags."0.9.1" = deps: { features?(features_.bitflags."0.9.1" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "0.9.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "18h073l5jd88rx4qdr95fjddr9rk79pb1aqnshzdnw16cfmb9rws";
    features = mkFeatures (features."bitflags"."0.9.1" or {});
  };
  features_.bitflags."0.9.1" = deps: f: updateFeatures f (rec {
    bitflags = fold recursiveUpdate {} [
      { "0.9.1".default = (f.bitflags."0.9.1".default or true); }
      { "0.9.1".example_generated =
        (f.bitflags."0.9.1".example_generated or false) ||
        (f.bitflags."0.9.1".default or false) ||
        (bitflags."0.9.1"."default" or false); }
    ];
  }) [];


# end
# bitflags-1.0.4

  crates.bitflags."1.0.4" = deps: { features?(features_.bitflags."1.0.4" deps {}) }: buildRustCrate {
    crateName = "bitflags";
    version = "1.0.4";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1g1wmz2001qmfrd37dnd5qiss5njrw26aywmg6yhkmkbyrhjxb08";
    features = mkFeatures (features."bitflags"."1.0.4" or {});
  };
  features_.bitflags."1.0.4" = deps: f: updateFeatures f (rec {
    bitflags."1.0.4".default = (f.bitflags."1.0.4".default or true);
  }) [];


# end
# c_vec-1.2.1

  crates.c_vec."1.2.1" = deps: { features?(features_.c_vec."1.2.1" deps {}) }: buildRustCrate {
    crateName = "c_vec";
    version = "1.2.1";
    authors = [ "Guillaume Gomez <guillaume1.gomez@gmail.com>" ];
    sha256 = "15gm72wx9kd0n51454i58rmpkmig8swghrj2440frxxi9kqg97xd";
  };
  features_.c_vec."1.2.1" = deps: f: updateFeatures f (rec {
    c_vec."1.2.1".default = (f.c_vec."1.2.1".default or true);
  }) [];


# end
# cairo-rs-0.2.0

  crates.cairo_rs."0.2.0" = deps: { features?(features_.cairo_rs."0.2.0" deps {}) }: buildRustCrate {
    crateName = "cairo-rs";
    version = "0.2.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "0bcbhbyips15b7la4r43p4x57jv1w2ll8iwg9lxwvzz5k6c7iwvd";
    libName = "cairo";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."c_vec"."${deps."cairo_rs"."0.2.0"."c_vec"}" deps)
      (crates."cairo_sys_rs"."${deps."cairo_rs"."0.2.0"."cairo_sys_rs"}" deps)
      (crates."libc"."${deps."cairo_rs"."0.2.0"."libc"}" deps)
    ]
      ++ (if features.cairo_rs."0.2.0".glib or false then [ (crates.glib."${deps."cairo_rs"."0.2.0".glib}" deps) ] else [])
      ++ (if features.cairo_rs."0.2.0".glib-sys or false then [ (crates.glib_sys."${deps."cairo_rs"."0.2.0".glib_sys}" deps) ] else []))
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."cairo_rs"."0.2.0"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cairo_rs"."0.2.0" or {});
  };
  features_.cairo_rs."0.2.0" = deps: f: updateFeatures f (rec {
    c_vec."${deps.cairo_rs."0.2.0".c_vec}".default = true;
    cairo_rs = fold recursiveUpdate {} [
      { "0.2.0".default = (f.cairo_rs."0.2.0".default or true); }
      { "0.2.0".glib =
        (f.cairo_rs."0.2.0".glib or false) ||
        (f.cairo_rs."0.2.0".use_glib or false) ||
        (cairo_rs."0.2.0"."use_glib" or false); }
      { "0.2.0".glib-sys =
        (f.cairo_rs."0.2.0".glib-sys or false) ||
        (f.cairo_rs."0.2.0".use_glib or false) ||
        (cairo_rs."0.2.0"."use_glib" or false); }
      { "0.2.0".gtk-rs-lgpl-docs =
        (f.cairo_rs."0.2.0".gtk-rs-lgpl-docs or false) ||
        (f.cairo_rs."0.2.0".embed-lgpl-docs or false) ||
        (cairo_rs."0.2.0"."embed-lgpl-docs" or false) ||
        (f.cairo_rs."0.2.0".purge-lgpl-docs or false) ||
        (cairo_rs."0.2.0"."purge-lgpl-docs" or false); }
      { "0.2.0".use_glib =
        (f.cairo_rs."0.2.0".use_glib or false) ||
        (f.cairo_rs."0.2.0".default or false) ||
        (cairo_rs."0.2.0"."default" or false); }
    ];
    cairo_sys_rs = fold recursiveUpdate {} [
      { "${deps.cairo_rs."0.2.0".cairo_sys_rs}"."png" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.2.0".cairo_sys_rs}"."png" or false) ||
        (cairo_rs."0.2.0"."png" or false) ||
        (f."cairo_rs"."0.2.0"."png" or false); }
      { "${deps.cairo_rs."0.2.0".cairo_sys_rs}"."v1_12" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.2.0".cairo_sys_rs}"."v1_12" or false) ||
        (cairo_rs."0.2.0"."v1_12" or false) ||
        (f."cairo_rs"."0.2.0"."v1_12" or false); }
      { "${deps.cairo_rs."0.2.0".cairo_sys_rs}"."xcb" =
        (f.cairo_sys_rs."${deps.cairo_rs."0.2.0".cairo_sys_rs}"."xcb" or false) ||
        (cairo_rs."0.2.0"."xcb" or false) ||
        (f."cairo_rs"."0.2.0"."xcb" or false); }
      { "${deps.cairo_rs."0.2.0".cairo_sys_rs}".default = true; }
    ];
    glib."${deps.cairo_rs."0.2.0".glib}".default = true;
    glib_sys."${deps.cairo_rs."0.2.0".glib_sys}".default = true;
    libc."${deps.cairo_rs."0.2.0".libc}".default = true;
    winapi."${deps.cairo_rs."0.2.0".winapi}".default = true;
  }) [
    (features_.c_vec."${deps."cairo_rs"."0.2.0"."c_vec"}" deps)
    (features_.cairo_sys_rs."${deps."cairo_rs"."0.2.0"."cairo_sys_rs"}" deps)
    (features_.glib."${deps."cairo_rs"."0.2.0"."glib"}" deps)
    (features_.glib_sys."${deps."cairo_rs"."0.2.0"."glib_sys"}" deps)
    (features_.libc."${deps."cairo_rs"."0.2.0"."libc"}" deps)
    (features_.winapi."${deps."cairo_rs"."0.2.0"."winapi"}" deps)
  ];


# end
# cairo-sys-rs-0.4.0

  crates.cairo_sys_rs."0.4.0" = deps: { features?(features_.cairo_sys_rs."0.4.0" deps {}) }: buildRustCrate {
    crateName = "cairo-sys-rs";
    version = "0.4.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "062nxihlydci65pyy2ldn7djkc9sm7a5xvkl8pxrsxfxvfapm5br";
    libName = "cairo_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."cairo_sys_rs"."0.4.0"."libc"}" deps)
    ])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."cairo_sys_rs"."0.4.0"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."cairo_sys_rs"."0.4.0"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."cairo_sys_rs"."0.4.0" or {});
  };
  features_.cairo_sys_rs."0.4.0" = deps: f: updateFeatures f (rec {
    cairo_sys_rs = fold recursiveUpdate {} [
      { "0.4.0".default = (f.cairo_sys_rs."0.4.0".default or true); }
      { "0.4.0".v1_12 =
        (f.cairo_sys_rs."0.4.0".v1_12 or false) ||
        (f.cairo_sys_rs."0.4.0".v1_14 or false) ||
        (cairo_sys_rs."0.4.0"."v1_14" or false); }
      { "0.4.0".x11 =
        (f.cairo_sys_rs."0.4.0".x11 or false) ||
        (f.cairo_sys_rs."0.4.0".xlib or false) ||
        (cairo_sys_rs."0.4.0"."xlib" or false); }
    ];
    libc."${deps.cairo_sys_rs."0.4.0".libc}".default = true;
    pkg_config."${deps.cairo_sys_rs."0.4.0".pkg_config}".default = true;
    winapi."${deps.cairo_sys_rs."0.4.0".winapi}".default = true;
  }) [
    (features_.libc."${deps."cairo_sys_rs"."0.4.0"."libc"}" deps)
    (features_.pkg_config."${deps."cairo_sys_rs"."0.4.0"."pkg_config"}" deps)
    (features_.winapi."${deps."cairo_sys_rs"."0.4.0"."winapi"}" deps)
  ];


# end
# cc-1.0.25

  crates.cc."1.0.25" = deps: { features?(features_.cc."1.0.25" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.25";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0pd8fhjlpr5qan984frkf1c8nxrqp6827wmmfzhm2840229z2hq0";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.25" or {});
  };
  features_.cc."1.0.25" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.25".default = (f.cc."1.0.25".default or true); }
      { "1.0.25".rayon =
        (f.cc."1.0.25".rayon or false) ||
        (f.cc."1.0.25".parallel or false) ||
        (cc."1.0.25"."parallel" or false); }
    ];
  }) [];


# end
# cfg-if-0.1.6

  crates.cfg_if."0.1.6" = deps: { features?(features_.cfg_if."0.1.6" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.6";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "11qrix06wagkplyk908i3423ps9m9np6c4vbcq81s9fyl244xv3n";
  };
  features_.cfg_if."0.1.6" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.6".default = (f.cfg_if."0.1.6".default or true);
  }) [];


# end
# cloudabi-0.0.3

  crates.cloudabi."0.0.3" = deps: { features?(features_.cloudabi."0.0.3" deps {}) }: buildRustCrate {
    crateName = "cloudabi";
    version = "0.0.3";
    authors = [ "Nuxi (https://nuxi.nl/) and contributors" ];
    sha256 = "1z9lby5sr6vslfd14d6igk03s7awf91mxpsfmsp3prxbxlk0x7h5";
    libPath = "cloudabi.rs";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.cloudabi."0.0.3".bitflags or false then [ (crates.bitflags."${deps."cloudabi"."0.0.3".bitflags}" deps) ] else []));
    features = mkFeatures (features."cloudabi"."0.0.3" or {});
  };
  features_.cloudabi."0.0.3" = deps: f: updateFeatures f (rec {
    bitflags."${deps.cloudabi."0.0.3".bitflags}".default = true;
    cloudabi = fold recursiveUpdate {} [
      { "0.0.3".bitflags =
        (f.cloudabi."0.0.3".bitflags or false) ||
        (f.cloudabi."0.0.3".default or false) ||
        (cloudabi."0.0.3"."default" or false); }
      { "0.0.3".default = (f.cloudabi."0.0.3".default or true); }
    ];
  }) [
    (features_.bitflags."${deps."cloudabi"."0.0.3"."bitflags"}" deps)
  ];


# end
# dbus-0.4.1

  crates.dbus."0.4.1" = deps: { features?(features_.dbus."0.4.1" deps {}) }: buildRustCrate {
    crateName = "dbus";
    version = "0.4.1";
    authors = [ "David Henningsson <diwic@ubuntu.com>" ];
    sha256 = "0qw32qj2rys318h780klxlznkwg93dfimbn8mc34m4940l8v00g9";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."dbus"."0.4.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."dbus"."0.4.1"."pkg_config"}" deps)
    ]);
  };
  features_.dbus."0.4.1" = deps: f: updateFeatures f (rec {
    dbus."0.4.1".default = (f.dbus."0.4.1".default or true);
    libc."${deps.dbus."0.4.1".libc}".default = true;
    pkg_config."${deps.dbus."0.4.1".pkg_config}".default = true;
  }) [
    (features_.libc."${deps."dbus"."0.4.1"."libc"}" deps)
    (features_.pkg_config."${deps."dbus"."0.4.1"."pkg_config"}" deps)
  ];


# end
# dbus-macros-0.0.6

  crates.dbus_macros."0.0.6" = deps: { features?(features_.dbus_macros."0.0.6" deps {}) }: buildRustCrate {
    crateName = "dbus-macros";
    version = "0.0.6";
    authors = [ "Antoni Boucher <bouanto@zoho.com>" ];
    sha256 = "1nymk2hzzgyafyr5nfa4r4frx4hml3wlwgzfr9b69vmcvn3d2jyd";
    dependencies = mapFeatures features ([
      (crates."dbus"."${deps."dbus_macros"."0.0.6"."dbus"}" deps)
    ]);
  };
  features_.dbus_macros."0.0.6" = deps: f: updateFeatures f (rec {
    dbus."${deps.dbus_macros."0.0.6".dbus}".default = true;
    dbus_macros."0.0.6".default = (f.dbus_macros."0.0.6".default or true);
  }) [
    (features_.dbus."${deps."dbus_macros"."0.0.6"."dbus"}" deps)
  ];


# end
# dlib-0.3.1

  crates.dlib."0.3.1" = deps: { features?(features_.dlib."0.3.1" deps {}) }: buildRustCrate {
    crateName = "dlib";
    version = "0.3.1";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "11mhh6g9vszp2ay3r46x4capnnmvvhx5hcp74bapxjhiixqjfvkr";
    dependencies = mapFeatures features ([
      (crates."libloading"."${deps."dlib"."0.3.1"."libloading"}" deps)
    ]);
    features = mkFeatures (features."dlib"."0.3.1" or {});
  };
  features_.dlib."0.3.1" = deps: f: updateFeatures f (rec {
    dlib."0.3.1".default = (f.dlib."0.3.1".default or true);
    libloading."${deps.dlib."0.3.1".libloading}".default = true;
  }) [
    (features_.libloading."${deps."dlib"."0.3.1"."libloading"}" deps)
  ];


# end
# dlib-0.4.1

  crates.dlib."0.4.1" = deps: { features?(features_.dlib."0.4.1" deps {}) }: buildRustCrate {
    crateName = "dlib";
    version = "0.4.1";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "0h5xm6lanbl6v9y16g592bia33g7xb0n0fg98pvz6nsvg0layxlk";
    dependencies = mapFeatures features ([
      (crates."libloading"."${deps."dlib"."0.4.1"."libloading"}" deps)
    ]);
    features = mkFeatures (features."dlib"."0.4.1" or {});
  };
  features_.dlib."0.4.1" = deps: f: updateFeatures f (rec {
    dlib."0.4.1".default = (f.dlib."0.4.1".default or true);
    libloading."${deps.dlib."0.4.1".libloading}".default = true;
  }) [
    (features_.libloading."${deps."dlib"."0.4.1"."libloading"}" deps)
  ];


# end
# dtoa-0.4.3

  crates.dtoa."0.4.3" = deps: { features?(features_.dtoa."0.4.3" deps {}) }: buildRustCrate {
    crateName = "dtoa";
    version = "0.4.3";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1xysdxdm24sk5ysim7lps4r2qaxfnj0sbakhmps4d42yssx30cw8";
  };
  features_.dtoa."0.4.3" = deps: f: updateFeatures f (rec {
    dtoa."0.4.3".default = (f.dtoa."0.4.3".default or true);
  }) [];


# end
# dummy-rustwlc-0.7.1

  crates.dummy_rustwlc."0.7.1" = deps: { features?(features_.dummy_rustwlc."0.7.1" deps {}) }: buildRustCrate {
    crateName = "dummy-rustwlc";
    version = "0.7.1";
    authors = [ "Snirk Immington <snirk.immington@gmail.com>" "Preston Carpenter <APragmaticPlace@gmail.com>" ];
    sha256 = "13priwnxpjvmym6yh9v9x1230ca04cba7bzbnn21pbvqngis1y88";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."dummy_rustwlc"."0.7.1"."bitflags"}" deps)
      (crates."libc"."${deps."dummy_rustwlc"."0.7.1"."libc"}" deps)
      (crates."wayland_sys"."${deps."dummy_rustwlc"."0.7.1"."wayland_sys"}" deps)
    ]);
  };
  features_.dummy_rustwlc."0.7.1" = deps: f: updateFeatures f (rec {
    bitflags."${deps.dummy_rustwlc."0.7.1".bitflags}".default = true;
    dummy_rustwlc."0.7.1".default = (f.dummy_rustwlc."0.7.1".default or true);
    libc."${deps.dummy_rustwlc."0.7.1".libc}".default = true;
    wayland_sys = fold recursiveUpdate {} [
      { "${deps.dummy_rustwlc."0.7.1".wayland_sys}"."dlopen" = true; }
      { "${deps.dummy_rustwlc."0.7.1".wayland_sys}"."server" = true; }
      { "${deps.dummy_rustwlc."0.7.1".wayland_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."dummy_rustwlc"."0.7.1"."bitflags"}" deps)
    (features_.libc."${deps."dummy_rustwlc"."0.7.1"."libc"}" deps)
    (features_.wayland_sys."${deps."dummy_rustwlc"."0.7.1"."wayland_sys"}" deps)
  ];


# end
# env_logger-0.3.5

  crates.env_logger."0.3.5" = deps: { features?(features_.env_logger."0.3.5" deps {}) }: buildRustCrate {
    crateName = "env_logger";
    version = "0.3.5";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1mvxiaaqsyjliv1mm1qaagjqiccw11mdyi3n9h9rf8y6wj15zycw";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."env_logger"."0.3.5"."log"}" deps)
    ]
      ++ (if features.env_logger."0.3.5".regex or false then [ (crates.regex."${deps."env_logger"."0.3.5".regex}" deps) ] else []));
    features = mkFeatures (features."env_logger"."0.3.5" or {});
  };
  features_.env_logger."0.3.5" = deps: f: updateFeatures f (rec {
    env_logger = fold recursiveUpdate {} [
      { "0.3.5".default = (f.env_logger."0.3.5".default or true); }
      { "0.3.5".regex =
        (f.env_logger."0.3.5".regex or false) ||
        (f.env_logger."0.3.5".default or false) ||
        (env_logger."0.3.5"."default" or false); }
    ];
    log."${deps.env_logger."0.3.5".log}".default = true;
    regex."${deps.env_logger."0.3.5".regex}".default = true;
  }) [
    (features_.log."${deps."env_logger"."0.3.5"."log"}" deps)
    (features_.regex."${deps."env_logger"."0.3.5"."regex"}" deps)
  ];


# end
# fixedbitset-0.1.9

  crates.fixedbitset."0.1.9" = deps: { features?(features_.fixedbitset."0.1.9" deps {}) }: buildRustCrate {
    crateName = "fixedbitset";
    version = "0.1.9";
    authors = [ "bluss" ];
    sha256 = "1bkb5aq7h9p4rzlgxagnda1f0dd11q0qz41bmdy11z18q1p8igy1";
  };
  features_.fixedbitset."0.1.9" = deps: f: updateFeatures f (rec {
    fixedbitset."0.1.9".default = (f.fixedbitset."0.1.9".default or true);
  }) [];


# end
# fuchsia-zircon-0.3.3

  crates.fuchsia_zircon."0.3.3" = deps: { features?(features_.fuchsia_zircon."0.3.3" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon";
    version = "0.3.3";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "0jrf4shb1699r4la8z358vri8318w4mdi6qzfqy30p2ymjlca4gk";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
    ]);
  };
  features_.fuchsia_zircon."0.3.3" = deps: f: updateFeatures f (rec {
    bitflags."${deps.fuchsia_zircon."0.3.3".bitflags}".default = true;
    fuchsia_zircon."0.3.3".default = (f.fuchsia_zircon."0.3.3".default or true);
    fuchsia_zircon_sys."${deps.fuchsia_zircon."0.3.3".fuchsia_zircon_sys}".default = true;
  }) [
    (features_.bitflags."${deps."fuchsia_zircon"."0.3.3"."bitflags"}" deps)
    (features_.fuchsia_zircon_sys."${deps."fuchsia_zircon"."0.3.3"."fuchsia_zircon_sys"}" deps)
  ];


# end
# fuchsia-zircon-sys-0.3.3

  crates.fuchsia_zircon_sys."0.3.3" = deps: { features?(features_.fuchsia_zircon_sys."0.3.3" deps {}) }: buildRustCrate {
    crateName = "fuchsia-zircon-sys";
    version = "0.3.3";
    authors = [ "Raph Levien <raph@google.com>" ];
    sha256 = "08jp1zxrm9jbrr6l26bjal4dbm8bxfy57ickdgibsqxr1n9j3hf5";
  };
  features_.fuchsia_zircon_sys."0.3.3" = deps: f: updateFeatures f (rec {
    fuchsia_zircon_sys."0.3.3".default = (f.fuchsia_zircon_sys."0.3.3".default or true);
  }) [];


# end
# gcc-0.3.55

  crates.gcc."0.3.55" = deps: { features?(features_.gcc."0.3.55" deps {}) }: buildRustCrate {
    crateName = "gcc";
    version = "0.3.55";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "18qxv3hjdhp7pfcvbm2hvyicpgmk7xw8aii1l7fla8cxxbcrg2nz";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gcc"."0.3.55" or {});
  };
  features_.gcc."0.3.55" = deps: f: updateFeatures f (rec {
    gcc = fold recursiveUpdate {} [
      { "0.3.55".default = (f.gcc."0.3.55".default or true); }
      { "0.3.55".rayon =
        (f.gcc."0.3.55".rayon or false) ||
        (f.gcc."0.3.55".parallel or false) ||
        (gcc."0.3.55"."parallel" or false); }
    ];
  }) [];


# end
# gdk-pixbuf-0.2.0

  crates.gdk_pixbuf."0.2.0" = deps: { features?(features_.gdk_pixbuf."0.2.0" deps {}) }: buildRustCrate {
    crateName = "gdk-pixbuf";
    version = "0.2.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "082z1s30haa59ax35wsv06mj8z8bhhq0fac36g01qa77kpiphj5y";
    libName = "gdk_pixbuf";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."gdk_pixbuf_sys"."${deps."gdk_pixbuf"."0.2.0"."gdk_pixbuf_sys"}" deps)
      (crates."glib"."${deps."gdk_pixbuf"."0.2.0"."glib"}" deps)
      (crates."glib_sys"."${deps."gdk_pixbuf"."0.2.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gdk_pixbuf"."0.2.0"."gobject_sys"}" deps)
      (crates."libc"."${deps."gdk_pixbuf"."0.2.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
]);
    features = mkFeatures (features."gdk_pixbuf"."0.2.0" or {});
  };
  features_.gdk_pixbuf."0.2.0" = deps: f: updateFeatures f (rec {
    gdk_pixbuf = fold recursiveUpdate {} [
      { "0.2.0".default = (f.gdk_pixbuf."0.2.0".default or true); }
      { "0.2.0".gtk-rs-lgpl-docs =
        (f.gdk_pixbuf."0.2.0".gtk-rs-lgpl-docs or false) ||
        (f.gdk_pixbuf."0.2.0".embed-lgpl-docs or false) ||
        (gdk_pixbuf."0.2.0"."embed-lgpl-docs" or false) ||
        (f.gdk_pixbuf."0.2.0".purge-lgpl-docs or false) ||
        (gdk_pixbuf."0.2.0"."purge-lgpl-docs" or false); }
      { "0.2.0".v2_28 =
        (f.gdk_pixbuf."0.2.0".v2_28 or false) ||
        (f.gdk_pixbuf."0.2.0".v2_30 or false) ||
        (gdk_pixbuf."0.2.0"."v2_30" or false); }
      { "0.2.0".v2_30 =
        (f.gdk_pixbuf."0.2.0".v2_30 or false) ||
        (f.gdk_pixbuf."0.2.0".v2_32 or false) ||
        (gdk_pixbuf."0.2.0"."v2_32" or false); }
      { "0.2.0".v2_32 =
        (f.gdk_pixbuf."0.2.0".v2_32 or false) ||
        (f.gdk_pixbuf."0.2.0".v2_36 or false) ||
        (gdk_pixbuf."0.2.0"."v2_36" or false); }
    ];
    gdk_pixbuf_sys = fold recursiveUpdate {} [
      { "${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_28" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_28" or false) ||
        (gdk_pixbuf."0.2.0"."v2_28" or false) ||
        (f."gdk_pixbuf"."0.2.0"."v2_28" or false); }
      { "${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_30" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_30" or false) ||
        (gdk_pixbuf."0.2.0"."v2_30" or false) ||
        (f."gdk_pixbuf"."0.2.0"."v2_30" or false); }
      { "${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_32" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_32" or false) ||
        (gdk_pixbuf."0.2.0"."v2_32" or false) ||
        (f."gdk_pixbuf"."0.2.0"."v2_32" or false); }
      { "${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_36" =
        (f.gdk_pixbuf_sys."${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}"."v2_36" or false) ||
        (gdk_pixbuf."0.2.0"."v2_36" or false) ||
        (f."gdk_pixbuf"."0.2.0"."v2_36" or false); }
      { "${deps.gdk_pixbuf."0.2.0".gdk_pixbuf_sys}".default = true; }
    ];
    glib."${deps.gdk_pixbuf."0.2.0".glib}".default = true;
    glib_sys."${deps.gdk_pixbuf."0.2.0".glib_sys}".default = true;
    gobject_sys."${deps.gdk_pixbuf."0.2.0".gobject_sys}".default = true;
    libc."${deps.gdk_pixbuf."0.2.0".libc}".default = true;
  }) [
    (features_.gdk_pixbuf_sys."${deps."gdk_pixbuf"."0.2.0"."gdk_pixbuf_sys"}" deps)
    (features_.glib."${deps."gdk_pixbuf"."0.2.0"."glib"}" deps)
    (features_.glib_sys."${deps."gdk_pixbuf"."0.2.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gdk_pixbuf"."0.2.0"."gobject_sys"}" deps)
    (features_.libc."${deps."gdk_pixbuf"."0.2.0"."libc"}" deps)
  ];


# end
# gdk-pixbuf-sys-0.4.0

  crates.gdk_pixbuf_sys."0.4.0" = deps: { features?(features_.gdk_pixbuf_sys."0.4.0" deps {}) }: buildRustCrate {
    crateName = "gdk-pixbuf-sys";
    version = "0.4.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "1r98zdqqik3hh1l10jmhhcjx59yk4m0bs9pc7hnkwp2p6gm968vp";
    libName = "gdk_pixbuf_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."gdk_pixbuf_sys"."0.4.0"."bitflags"}" deps)
      (crates."gio_sys"."${deps."gdk_pixbuf_sys"."0.4.0"."gio_sys"}" deps)
      (crates."glib_sys"."${deps."gdk_pixbuf_sys"."0.4.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gdk_pixbuf_sys"."0.4.0"."gobject_sys"}" deps)
      (crates."libc"."${deps."gdk_pixbuf_sys"."0.4.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gdk_pixbuf_sys"."0.4.0"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gdk_pixbuf_sys"."0.4.0" or {});
  };
  features_.gdk_pixbuf_sys."0.4.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.gdk_pixbuf_sys."0.4.0".bitflags}".default = true;
    gdk_pixbuf_sys = fold recursiveUpdate {} [
      { "0.4.0".default = (f.gdk_pixbuf_sys."0.4.0".default or true); }
      { "0.4.0".v2_28 =
        (f.gdk_pixbuf_sys."0.4.0".v2_28 or false) ||
        (f.gdk_pixbuf_sys."0.4.0".v2_30 or false) ||
        (gdk_pixbuf_sys."0.4.0"."v2_30" or false); }
      { "0.4.0".v2_30 =
        (f.gdk_pixbuf_sys."0.4.0".v2_30 or false) ||
        (f.gdk_pixbuf_sys."0.4.0".v2_32 or false) ||
        (gdk_pixbuf_sys."0.4.0"."v2_32" or false); }
      { "0.4.0".v2_32 =
        (f.gdk_pixbuf_sys."0.4.0".v2_32 or false) ||
        (f.gdk_pixbuf_sys."0.4.0".v2_36 or false) ||
        (gdk_pixbuf_sys."0.4.0"."v2_36" or false); }
    ];
    gio_sys."${deps.gdk_pixbuf_sys."0.4.0".gio_sys}".default = true;
    glib_sys."${deps.gdk_pixbuf_sys."0.4.0".glib_sys}".default = true;
    gobject_sys."${deps.gdk_pixbuf_sys."0.4.0".gobject_sys}".default = true;
    libc."${deps.gdk_pixbuf_sys."0.4.0".libc}".default = true;
    pkg_config."${deps.gdk_pixbuf_sys."0.4.0".pkg_config}".default = true;
  }) [
    (features_.bitflags."${deps."gdk_pixbuf_sys"."0.4.0"."bitflags"}" deps)
    (features_.gio_sys."${deps."gdk_pixbuf_sys"."0.4.0"."gio_sys"}" deps)
    (features_.glib_sys."${deps."gdk_pixbuf_sys"."0.4.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gdk_pixbuf_sys"."0.4.0"."gobject_sys"}" deps)
    (features_.libc."${deps."gdk_pixbuf_sys"."0.4.0"."libc"}" deps)
    (features_.pkg_config."${deps."gdk_pixbuf_sys"."0.4.0"."pkg_config"}" deps)
  ];


# end
# getopts-0.2.18

  crates.getopts."0.2.18" = deps: { features?(features_.getopts."0.2.18" deps {}) }: buildRustCrate {
    crateName = "getopts";
    version = "0.2.18";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0c1m95wg8pkvdq4mwcd2v78r1lb6a5s3ljm7158dsl56mvzcwd5y";
    dependencies = mapFeatures features ([
      (crates."unicode_width"."${deps."getopts"."0.2.18"."unicode_width"}" deps)
    ]);
  };
  features_.getopts."0.2.18" = deps: f: updateFeatures f (rec {
    getopts."0.2.18".default = (f.getopts."0.2.18".default or true);
    unicode_width."${deps.getopts."0.2.18".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."getopts"."0.2.18"."unicode_width"}" deps)
  ];


# end
# gio-sys-0.4.0

  crates.gio_sys."0.4.0" = deps: { features?(features_.gio_sys."0.4.0" deps {}) }: buildRustCrate {
    crateName = "gio-sys";
    version = "0.4.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "064lv6h3qfgjzc6pbbxgln24b2fq9gxzh78z6d7fwfa97azllv2l";
    libName = "gio_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."gio_sys"."0.4.0"."bitflags"}" deps)
      (crates."glib_sys"."${deps."gio_sys"."0.4.0"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."gio_sys"."0.4.0"."gobject_sys"}" deps)
      (crates."libc"."${deps."gio_sys"."0.4.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gio_sys"."0.4.0"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gio_sys"."0.4.0" or {});
  };
  features_.gio_sys."0.4.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.gio_sys."0.4.0".bitflags}".default = true;
    gio_sys = fold recursiveUpdate {} [
      { "0.4.0".default = (f.gio_sys."0.4.0".default or true); }
      { "0.4.0".v2_34 =
        (f.gio_sys."0.4.0".v2_34 or false) ||
        (f.gio_sys."0.4.0".v2_36 or false) ||
        (gio_sys."0.4.0"."v2_36" or false); }
      { "0.4.0".v2_36 =
        (f.gio_sys."0.4.0".v2_36 or false) ||
        (f.gio_sys."0.4.0".v2_38 or false) ||
        (gio_sys."0.4.0"."v2_38" or false); }
      { "0.4.0".v2_38 =
        (f.gio_sys."0.4.0".v2_38 or false) ||
        (f.gio_sys."0.4.0".v2_40 or false) ||
        (gio_sys."0.4.0"."v2_40" or false); }
      { "0.4.0".v2_40 =
        (f.gio_sys."0.4.0".v2_40 or false) ||
        (f.gio_sys."0.4.0".v2_42 or false) ||
        (gio_sys."0.4.0"."v2_42" or false); }
      { "0.4.0".v2_42 =
        (f.gio_sys."0.4.0".v2_42 or false) ||
        (f.gio_sys."0.4.0".v2_44 or false) ||
        (gio_sys."0.4.0"."v2_44" or false); }
      { "0.4.0".v2_44 =
        (f.gio_sys."0.4.0".v2_44 or false) ||
        (f.gio_sys."0.4.0".v2_46 or false) ||
        (gio_sys."0.4.0"."v2_46" or false); }
      { "0.4.0".v2_46 =
        (f.gio_sys."0.4.0".v2_46 or false) ||
        (f.gio_sys."0.4.0".v2_48 or false) ||
        (gio_sys."0.4.0"."v2_48" or false); }
      { "0.4.0".v2_48 =
        (f.gio_sys."0.4.0".v2_48 or false) ||
        (f.gio_sys."0.4.0".v2_50 or false) ||
        (gio_sys."0.4.0"."v2_50" or false); }
    ];
    glib_sys."${deps.gio_sys."0.4.0".glib_sys}".default = true;
    gobject_sys."${deps.gio_sys."0.4.0".gobject_sys}".default = true;
    libc."${deps.gio_sys."0.4.0".libc}".default = true;
    pkg_config."${deps.gio_sys."0.4.0".pkg_config}".default = true;
  }) [
    (features_.bitflags."${deps."gio_sys"."0.4.0"."bitflags"}" deps)
    (features_.glib_sys."${deps."gio_sys"."0.4.0"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."gio_sys"."0.4.0"."gobject_sys"}" deps)
    (features_.libc."${deps."gio_sys"."0.4.0"."libc"}" deps)
    (features_.pkg_config."${deps."gio_sys"."0.4.0"."pkg_config"}" deps)
  ];


# end
# glib-0.3.1

  crates.glib."0.3.1" = deps: { features?(features_.glib."0.3.1" deps {}) }: buildRustCrate {
    crateName = "glib";
    version = "0.3.1";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "00s3n0pd8by1fk2l01mxmbnqq4ff6wadnkcf9jbjvr1l9bzgyqbl";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."glib"."0.3.1"."bitflags"}" deps)
      (crates."glib_sys"."${deps."glib"."0.3.1"."glib_sys"}" deps)
      (crates."gobject_sys"."${deps."glib"."0.3.1"."gobject_sys"}" deps)
      (crates."lazy_static"."${deps."glib"."0.3.1"."lazy_static"}" deps)
      (crates."libc"."${deps."glib"."0.3.1"."libc"}" deps)
    ]);
    features = mkFeatures (features."glib"."0.3.1" or {});
  };
  features_.glib."0.3.1" = deps: f: updateFeatures f (rec {
    bitflags."${deps.glib."0.3.1".bitflags}".default = true;
    glib = fold recursiveUpdate {} [
      { "0.3.1".default = (f.glib."0.3.1".default or true); }
      { "0.3.1".v2_34 =
        (f.glib."0.3.1".v2_34 or false) ||
        (f.glib."0.3.1".v2_38 or false) ||
        (glib."0.3.1"."v2_38" or false); }
      { "0.3.1".v2_38 =
        (f.glib."0.3.1".v2_38 or false) ||
        (f.glib."0.3.1".v2_40 or false) ||
        (glib."0.3.1"."v2_40" or false); }
      { "0.3.1".v2_40 =
        (f.glib."0.3.1".v2_40 or false) ||
        (f.glib."0.3.1".v2_44 or false) ||
        (glib."0.3.1"."v2_44" or false); }
      { "0.3.1".v2_44 =
        (f.glib."0.3.1".v2_44 or false) ||
        (f.glib."0.3.1".v2_46 or false) ||
        (glib."0.3.1"."v2_46" or false); }
      { "0.3.1".v2_46 =
        (f.glib."0.3.1".v2_46 or false) ||
        (f.glib."0.3.1".v2_48 or false) ||
        (glib."0.3.1"."v2_48" or false); }
      { "0.3.1".v2_48 =
        (f.glib."0.3.1".v2_48 or false) ||
        (f.glib."0.3.1".v2_50 or false) ||
        (glib."0.3.1"."v2_50" or false); }
    ];
    glib_sys = fold recursiveUpdate {} [
      { "${deps.glib."0.3.1".glib_sys}"."v2_34" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_34" or false) ||
        (glib."0.3.1"."v2_34" or false) ||
        (f."glib"."0.3.1"."v2_34" or false); }
      { "${deps.glib."0.3.1".glib_sys}"."v2_38" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_38" or false) ||
        (glib."0.3.1"."v2_38" or false) ||
        (f."glib"."0.3.1"."v2_38" or false); }
      { "${deps.glib."0.3.1".glib_sys}"."v2_40" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_40" or false) ||
        (glib."0.3.1"."v2_40" or false) ||
        (f."glib"."0.3.1"."v2_40" or false); }
      { "${deps.glib."0.3.1".glib_sys}"."v2_44" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_44" or false) ||
        (glib."0.3.1"."v2_44" or false) ||
        (f."glib"."0.3.1"."v2_44" or false); }
      { "${deps.glib."0.3.1".glib_sys}"."v2_46" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_46" or false) ||
        (glib."0.3.1"."v2_46" or false) ||
        (f."glib"."0.3.1"."v2_46" or false); }
      { "${deps.glib."0.3.1".glib_sys}"."v2_48" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_48" or false) ||
        (glib."0.3.1"."v2_48" or false) ||
        (f."glib"."0.3.1"."v2_48" or false); }
      { "${deps.glib."0.3.1".glib_sys}"."v2_50" =
        (f.glib_sys."${deps.glib."0.3.1".glib_sys}"."v2_50" or false) ||
        (glib."0.3.1"."v2_50" or false) ||
        (f."glib"."0.3.1"."v2_50" or false); }
      { "${deps.glib."0.3.1".glib_sys}".default = true; }
    ];
    gobject_sys = fold recursiveUpdate {} [
      { "${deps.glib."0.3.1".gobject_sys}"."v2_34" =
        (f.gobject_sys."${deps.glib."0.3.1".gobject_sys}"."v2_34" or false) ||
        (glib."0.3.1"."v2_34" or false) ||
        (f."glib"."0.3.1"."v2_34" or false); }
      { "${deps.glib."0.3.1".gobject_sys}"."v2_38" =
        (f.gobject_sys."${deps.glib."0.3.1".gobject_sys}"."v2_38" or false) ||
        (glib."0.3.1"."v2_38" or false) ||
        (f."glib"."0.3.1"."v2_38" or false); }
      { "${deps.glib."0.3.1".gobject_sys}"."v2_44" =
        (f.gobject_sys."${deps.glib."0.3.1".gobject_sys}"."v2_44" or false) ||
        (glib."0.3.1"."v2_44" or false) ||
        (f."glib"."0.3.1"."v2_44" or false); }
      { "${deps.glib."0.3.1".gobject_sys}"."v2_46" =
        (f.gobject_sys."${deps.glib."0.3.1".gobject_sys}"."v2_46" or false) ||
        (glib."0.3.1"."v2_46" or false) ||
        (f."glib"."0.3.1"."v2_46" or false); }
      { "${deps.glib."0.3.1".gobject_sys}".default = true; }
    ];
    lazy_static."${deps.glib."0.3.1".lazy_static}".default = true;
    libc."${deps.glib."0.3.1".libc}".default = true;
  }) [
    (features_.bitflags."${deps."glib"."0.3.1"."bitflags"}" deps)
    (features_.glib_sys."${deps."glib"."0.3.1"."glib_sys"}" deps)
    (features_.gobject_sys."${deps."glib"."0.3.1"."gobject_sys"}" deps)
    (features_.lazy_static."${deps."glib"."0.3.1"."lazy_static"}" deps)
    (features_.libc."${deps."glib"."0.3.1"."libc"}" deps)
  ];


# end
# glib-sys-0.4.0

  crates.glib_sys."0.4.0" = deps: { features?(features_.glib_sys."0.4.0" deps {}) }: buildRustCrate {
    crateName = "glib-sys";
    version = "0.4.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "153i1zmk824hdf8agkaqcgddlwpvgng71n7bdpaav5f4zzlfyp2w";
    libName = "glib_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."glib_sys"."0.4.0"."bitflags"}" deps)
      (crates."libc"."${deps."glib_sys"."0.4.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."glib_sys"."0.4.0"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."glib_sys"."0.4.0" or {});
  };
  features_.glib_sys."0.4.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.glib_sys."0.4.0".bitflags}".default = true;
    glib_sys = fold recursiveUpdate {} [
      { "0.4.0".default = (f.glib_sys."0.4.0".default or true); }
      { "0.4.0".v2_34 =
        (f.glib_sys."0.4.0".v2_34 or false) ||
        (f.glib_sys."0.4.0".v2_36 or false) ||
        (glib_sys."0.4.0"."v2_36" or false); }
      { "0.4.0".v2_36 =
        (f.glib_sys."0.4.0".v2_36 or false) ||
        (f.glib_sys."0.4.0".v2_38 or false) ||
        (glib_sys."0.4.0"."v2_38" or false); }
      { "0.4.0".v2_38 =
        (f.glib_sys."0.4.0".v2_38 or false) ||
        (f.glib_sys."0.4.0".v2_40 or false) ||
        (glib_sys."0.4.0"."v2_40" or false); }
      { "0.4.0".v2_40 =
        (f.glib_sys."0.4.0".v2_40 or false) ||
        (f.glib_sys."0.4.0".v2_44 or false) ||
        (glib_sys."0.4.0"."v2_44" or false); }
      { "0.4.0".v2_44 =
        (f.glib_sys."0.4.0".v2_44 or false) ||
        (f.glib_sys."0.4.0".v2_46 or false) ||
        (glib_sys."0.4.0"."v2_46" or false); }
      { "0.4.0".v2_46 =
        (f.glib_sys."0.4.0".v2_46 or false) ||
        (f.glib_sys."0.4.0".v2_48 or false) ||
        (glib_sys."0.4.0"."v2_48" or false); }
      { "0.4.0".v2_48 =
        (f.glib_sys."0.4.0".v2_48 or false) ||
        (f.glib_sys."0.4.0".v2_50 or false) ||
        (glib_sys."0.4.0"."v2_50" or false); }
    ];
    libc."${deps.glib_sys."0.4.0".libc}".default = true;
    pkg_config."${deps.glib_sys."0.4.0".pkg_config}".default = true;
  }) [
    (features_.bitflags."${deps."glib_sys"."0.4.0"."bitflags"}" deps)
    (features_.libc."${deps."glib_sys"."0.4.0"."libc"}" deps)
    (features_.pkg_config."${deps."glib_sys"."0.4.0"."pkg_config"}" deps)
  ];


# end
# gobject-sys-0.4.0

  crates.gobject_sys."0.4.0" = deps: { features?(features_.gobject_sys."0.4.0" deps {}) }: buildRustCrate {
    crateName = "gobject-sys";
    version = "0.4.0";
    authors = [ "The Gtk-rs Project Developers" ];
    sha256 = "00zmcbzqfhn9w01cphhf3hbq8ldd9ajba7x07z59vv1gdq6wjzli";
    libName = "gobject_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."gobject_sys"."0.4.0"."bitflags"}" deps)
      (crates."glib_sys"."${deps."gobject_sys"."0.4.0"."glib_sys"}" deps)
      (crates."libc"."${deps."gobject_sys"."0.4.0"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."gobject_sys"."0.4.0"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."gobject_sys"."0.4.0" or {});
  };
  features_.gobject_sys."0.4.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.gobject_sys."0.4.0".bitflags}".default = true;
    glib_sys."${deps.gobject_sys."0.4.0".glib_sys}".default = true;
    gobject_sys = fold recursiveUpdate {} [
      { "0.4.0".default = (f.gobject_sys."0.4.0".default or true); }
      { "0.4.0".v2_34 =
        (f.gobject_sys."0.4.0".v2_34 or false) ||
        (f.gobject_sys."0.4.0".v2_36 or false) ||
        (gobject_sys."0.4.0"."v2_36" or false); }
      { "0.4.0".v2_36 =
        (f.gobject_sys."0.4.0".v2_36 or false) ||
        (f.gobject_sys."0.4.0".v2_38 or false) ||
        (gobject_sys."0.4.0"."v2_38" or false); }
      { "0.4.0".v2_38 =
        (f.gobject_sys."0.4.0".v2_38 or false) ||
        (f.gobject_sys."0.4.0".v2_42 or false) ||
        (gobject_sys."0.4.0"."v2_42" or false); }
      { "0.4.0".v2_42 =
        (f.gobject_sys."0.4.0".v2_42 or false) ||
        (f.gobject_sys."0.4.0".v2_44 or false) ||
        (gobject_sys."0.4.0"."v2_44" or false); }
      { "0.4.0".v2_44 =
        (f.gobject_sys."0.4.0".v2_44 or false) ||
        (f.gobject_sys."0.4.0".v2_46 or false) ||
        (gobject_sys."0.4.0"."v2_46" or false); }
    ];
    libc."${deps.gobject_sys."0.4.0".libc}".default = true;
    pkg_config."${deps.gobject_sys."0.4.0".pkg_config}".default = true;
  }) [
    (features_.bitflags."${deps."gobject_sys"."0.4.0"."bitflags"}" deps)
    (features_.glib_sys."${deps."gobject_sys"."0.4.0"."glib_sys"}" deps)
    (features_.libc."${deps."gobject_sys"."0.4.0"."libc"}" deps)
    (features_.pkg_config."${deps."gobject_sys"."0.4.0"."pkg_config"}" deps)
  ];


# end
# itoa-0.3.4

  crates.itoa."0.3.4" = deps: { features?(features_.itoa."0.3.4" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.3.4";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1nfkzz6vrgj0d9l3yzjkkkqzdgs68y294fjdbl7jq118qi8xc9d9";
    features = mkFeatures (features."itoa"."0.3.4" or {});
  };
  features_.itoa."0.3.4" = deps: f: updateFeatures f (rec {
    itoa."0.3.4".default = (f.itoa."0.3.4".default or true);
  }) [];


# end
# json_macro-0.1.1

  crates.json_macro."0.1.1" = deps: { features?(features_.json_macro."0.1.1" deps {}) }: buildRustCrate {
    crateName = "json_macro";
    version = "0.1.1";
    authors = [ "Denis Kolodin <deniskolodin@gmail.com>" ];
    sha256 = "0hl2934shpwqbszrq035valbdz9y8p7dza183brygy5dbvivcyqy";
    dependencies = mapFeatures features ([
      (crates."rustc_serialize"."${deps."json_macro"."0.1.1"."rustc_serialize"}" deps)
    ]);
  };
  features_.json_macro."0.1.1" = deps: f: updateFeatures f (rec {
    json_macro."0.1.1".default = (f.json_macro."0.1.1".default or true);
    rustc_serialize."${deps.json_macro."0.1.1".rustc_serialize}".default = true;
  }) [
    (features_.rustc_serialize."${deps."json_macro"."0.1.1"."rustc_serialize"}" deps)
  ];


# end
# kernel32-sys-0.2.2

  crates.kernel32_sys."0.2.2" = deps: { features?(features_.kernel32_sys."0.2.2" deps {}) }: buildRustCrate {
    crateName = "kernel32-sys";
    version = "0.2.2";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
    libName = "kernel32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
    ]);
  };
  features_.kernel32_sys."0.2.2" = deps: f: updateFeatures f (rec {
    kernel32_sys."0.2.2".default = (f.kernel32_sys."0.2.2".default or true);
    winapi."${deps.kernel32_sys."0.2.2".winapi}".default = true;
    winapi_build."${deps.kernel32_sys."0.2.2".winapi_build}".default = true;
  }) [
    (features_.winapi."${deps."kernel32_sys"."0.2.2"."winapi"}" deps)
    (features_.winapi_build."${deps."kernel32_sys"."0.2.2"."winapi_build"}" deps)
  ];


# end
# lazy_static-0.2.11

  crates.lazy_static."0.2.11" = deps: { features?(features_.lazy_static."0.2.11" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "0.2.11";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1x6871cvpy5b96yv4c7jvpq316fp5d4609s9py7qk6cd6x9k34vm";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."0.2.11" or {});
  };
  features_.lazy_static."0.2.11" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "0.2.11".compiletest_rs =
        (f.lazy_static."0.2.11".compiletest_rs or false) ||
        (f.lazy_static."0.2.11".compiletest or false) ||
        (lazy_static."0.2.11"."compiletest" or false); }
      { "0.2.11".default = (f.lazy_static."0.2.11".default or true); }
      { "0.2.11".nightly =
        (f.lazy_static."0.2.11".nightly or false) ||
        (f.lazy_static."0.2.11".spin_no_std or false) ||
        (lazy_static."0.2.11"."spin_no_std" or false); }
      { "0.2.11".spin =
        (f.lazy_static."0.2.11".spin or false) ||
        (f.lazy_static."0.2.11".spin_no_std or false) ||
        (lazy_static."0.2.11"."spin_no_std" or false); }
    ];
  }) [];


# end
# lazy_static-1.2.0

  crates.lazy_static."1.2.0" = deps: { features?(features_.lazy_static."1.2.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.2.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "07p3b30k2akyr6xw08ggd5qiz5nw3vd3agggj360fcc1njz7d0ss";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.2.0" or {});
  };
  features_.lazy_static."1.2.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.2.0".default = (f.lazy_static."1.2.0".default or true); }
      { "1.2.0".spin =
        (f.lazy_static."1.2.0".spin or false) ||
        (f.lazy_static."1.2.0".spin_no_std or false) ||
        (lazy_static."1.2.0"."spin_no_std" or false); }
    ];
  }) [];


# end
# libc-0.2.44

  crates.libc."0.2.44" = deps: { features?(features_.libc."0.2.44" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.44";
    authors = [ "The Rust Project Developers" ];
    sha256 = "17a7p0lcf3qwl1pcxffdflgnx8zr2659mgzzg4zi5fnv1mlj3q6z";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.44" or {});
  };
  features_.libc."0.2.44" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.44".align =
        (f.libc."0.2.44".align or false) ||
        (f.libc."0.2.44".rustc-dep-of-std or false) ||
        (libc."0.2.44"."rustc-dep-of-std" or false); }
      { "0.2.44".default = (f.libc."0.2.44".default or true); }
      { "0.2.44".rustc-std-workspace-core =
        (f.libc."0.2.44".rustc-std-workspace-core or false) ||
        (f.libc."0.2.44".rustc-dep-of-std or false) ||
        (libc."0.2.44"."rustc-dep-of-std" or false); }
      { "0.2.44".use_std =
        (f.libc."0.2.44".use_std or false) ||
        (f.libc."0.2.44".default or false) ||
        (libc."0.2.44"."default" or false); }
    ];
  }) [];


# end
# libloading-0.3.4

  crates.libloading."0.3.4" = deps: { features?(features_.libloading."0.3.4" deps {}) }: buildRustCrate {
    crateName = "libloading";
    version = "0.3.4";
    authors = [ "Simonas Kazlauskas <libloading@kazlauskas.me>" ];
    sha256 = "1f2vy32cr434n638nv8sdf05iwa53q9q5ahlcpw1l9ywh1bcbhf1";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."libloading"."0.3.4"."lazy_static"}" deps)
    ])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."libloading"."0.3.4"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."libloading"."0.3.4"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."target_build_utils"."${deps."libloading"."0.3.4"."target_build_utils"}" deps)
    ]);
  };
  features_.libloading."0.3.4" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.libloading."0.3.4".kernel32_sys}".default = true;
    lazy_static."${deps.libloading."0.3.4".lazy_static}".default = true;
    libloading."0.3.4".default = (f.libloading."0.3.4".default or true);
    target_build_utils."${deps.libloading."0.3.4".target_build_utils}".default = true;
    winapi."${deps.libloading."0.3.4".winapi}".default = true;
  }) [
    (features_.lazy_static."${deps."libloading"."0.3.4"."lazy_static"}" deps)
    (features_.target_build_utils."${deps."libloading"."0.3.4"."target_build_utils"}" deps)
    (features_.kernel32_sys."${deps."libloading"."0.3.4"."kernel32_sys"}" deps)
    (features_.winapi."${deps."libloading"."0.3.4"."winapi"}" deps)
  ];


# end
# libloading-0.5.0

  crates.libloading."0.5.0" = deps: { features?(features_.libloading."0.5.0" deps {}) }: buildRustCrate {
    crateName = "libloading";
    version = "0.5.0";
    authors = [ "Simonas Kazlauskas <libloading@kazlauskas.me>" ];
    sha256 = "11vzjaka1y979aril4ggwp33p35yz2isvx9m5w88r5sdcmq6iscn";
    build = "build.rs";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."libloading"."0.5.0"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."libloading"."0.5.0"."cc"}" deps)
    ]);
  };
  features_.libloading."0.5.0" = deps: f: updateFeatures f (rec {
    cc."${deps.libloading."0.5.0".cc}".default = true;
    libloading."0.5.0".default = (f.libloading."0.5.0".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.libloading."0.5.0".winapi}"."errhandlingapi" = true; }
      { "${deps.libloading."0.5.0".winapi}"."libloaderapi" = true; }
      { "${deps.libloading."0.5.0".winapi}"."winerror" = true; }
      { "${deps.libloading."0.5.0".winapi}".default = true; }
    ];
  }) [
    (features_.cc."${deps."libloading"."0.5.0"."cc"}" deps)
    (features_.winapi."${deps."libloading"."0.5.0"."winapi"}" deps)
  ];


# end
# log-0.3.9

  crates.log."0.3.9" = deps: { features?(features_.log."0.3.9" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.3.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "19i9pwp7lhaqgzangcpw00kc3zsgcqcx84crv07xgz3v7d3kvfa2";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."log"."0.3.9"."log"}" deps)
    ]);
    features = mkFeatures (features."log"."0.3.9" or {});
  };
  features_.log."0.3.9" = deps: f: updateFeatures f (rec {
    log = fold recursiveUpdate {} [
      { "${deps.log."0.3.9".log}"."max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."max_level_debug" or false) ||
        (log."0.3.9"."max_level_debug" or false) ||
        (f."log"."0.3.9"."max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."max_level_error" or false) ||
        (log."0.3.9"."max_level_error" or false) ||
        (f."log"."0.3.9"."max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."max_level_info" or false) ||
        (log."0.3.9"."max_level_info" or false) ||
        (f."log"."0.3.9"."max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."max_level_off" or false) ||
        (log."0.3.9"."max_level_off" or false) ||
        (f."log"."0.3.9"."max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."max_level_trace" or false) ||
        (log."0.3.9"."max_level_trace" or false) ||
        (f."log"."0.3.9"."max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."max_level_warn" or false) ||
        (log."0.3.9"."max_level_warn" or false) ||
        (f."log"."0.3.9"."max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_debug" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_debug" or false) ||
        (log."0.3.9"."release_max_level_debug" or false) ||
        (f."log"."0.3.9"."release_max_level_debug" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_error" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_error" or false) ||
        (log."0.3.9"."release_max_level_error" or false) ||
        (f."log"."0.3.9"."release_max_level_error" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_info" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_info" or false) ||
        (log."0.3.9"."release_max_level_info" or false) ||
        (f."log"."0.3.9"."release_max_level_info" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_off" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_off" or false) ||
        (log."0.3.9"."release_max_level_off" or false) ||
        (f."log"."0.3.9"."release_max_level_off" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_trace" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_trace" or false) ||
        (log."0.3.9"."release_max_level_trace" or false) ||
        (f."log"."0.3.9"."release_max_level_trace" or false); }
      { "${deps.log."0.3.9".log}"."release_max_level_warn" =
        (f.log."${deps.log."0.3.9".log}"."release_max_level_warn" or false) ||
        (log."0.3.9"."release_max_level_warn" or false) ||
        (f."log"."0.3.9"."release_max_level_warn" or false); }
      { "${deps.log."0.3.9".log}"."std" =
        (f.log."${deps.log."0.3.9".log}"."std" or false) ||
        (log."0.3.9"."use_std" or false) ||
        (f."log"."0.3.9"."use_std" or false); }
      { "${deps.log."0.3.9".log}".default = true; }
      { "0.3.9".default = (f.log."0.3.9".default or true); }
      { "0.3.9".use_std =
        (f.log."0.3.9".use_std or false) ||
        (f.log."0.3.9".default or false) ||
        (log."0.3.9"."default" or false); }
    ];
  }) [
    (features_.log."${deps."log"."0.3.9"."log"}" deps)
  ];


# end
# log-0.4.6

  crates.log."0.4.6" = deps: { features?(features_.log."0.4.6" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1nd8dl9mvc9vd6fks5d4gsxaz990xi6rzlb8ymllshmwi153vngr";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.6"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.6" or {});
  };
  features_.log."0.4.6" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.log."0.4.6".cfg_if}".default = true;
    log."0.4.6".default = (f.log."0.4.6".default or true);
  }) [
    (features_.cfg_if."${deps."log"."0.4.6"."cfg_if"}" deps)
  ];


# end
# memchr-0.1.11

  crates.memchr."0.1.11" = deps: { features?(features_.memchr."0.1.11" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "0.1.11";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0x73jghamvxxq5fsw9wb0shk5m6qp3q6fsf0nibn0i6bbqkw91s8";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."memchr"."0.1.11"."libc"}" deps)
    ]);
  };
  features_.memchr."0.1.11" = deps: f: updateFeatures f (rec {
    libc."${deps.memchr."0.1.11".libc}".default = true;
    memchr."0.1.11".default = (f.memchr."0.1.11".default or true);
  }) [
    (features_.libc."${deps."memchr"."0.1.11"."libc"}" deps)
  ];


# end
# nix-0.6.0

  crates.nix."0.6.0" = deps: { features?(features_.nix."0.6.0" deps {}) }: buildRustCrate {
    crateName = "nix";
    version = "0.6.0";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1bgh75y897isnxbw3vd79vns9h6q4d59p1cgv9c4laysyw6fkqwf";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."nix"."0.6.0"."bitflags"}" deps)
      (crates."cfg_if"."${deps."nix"."0.6.0"."cfg_if"}" deps)
      (crates."libc"."${deps."nix"."0.6.0"."libc"}" deps)
      (crates."void"."${deps."nix"."0.6.0"."void"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."nix"."0.6.0"."rustc_version"}" deps)
      (crates."semver"."${deps."nix"."0.6.0"."semver"}" deps)
    ]);
    features = mkFeatures (features."nix"."0.6.0" or {});
  };
  features_.nix."0.6.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.nix."0.6.0".bitflags}".default = true;
    cfg_if."${deps.nix."0.6.0".cfg_if}".default = true;
    libc."${deps.nix."0.6.0".libc}".default = true;
    nix."0.6.0".default = (f.nix."0.6.0".default or true);
    rustc_version."${deps.nix."0.6.0".rustc_version}".default = true;
    semver."${deps.nix."0.6.0".semver}".default = true;
    void."${deps.nix."0.6.0".void}".default = true;
  }) [
    (features_.bitflags."${deps."nix"."0.6.0"."bitflags"}" deps)
    (features_.cfg_if."${deps."nix"."0.6.0"."cfg_if"}" deps)
    (features_.libc."${deps."nix"."0.6.0"."libc"}" deps)
    (features_.void."${deps."nix"."0.6.0"."void"}" deps)
    (features_.rustc_version."${deps."nix"."0.6.0"."rustc_version"}" deps)
    (features_.semver."${deps."nix"."0.6.0"."semver"}" deps)
  ];


# end
# nix-0.9.0

  crates.nix."0.9.0" = deps: { features?(features_.nix."0.9.0" deps {}) }: buildRustCrate {
    crateName = "nix";
    version = "0.9.0";
    authors = [ "The nix-rust Project Developers" ];
    sha256 = "00p63bphzwwn460rja5l2wcpgmv7ljf7illf6n95cppx63d180q0";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."nix"."0.9.0"."bitflags"}" deps)
      (crates."cfg_if"."${deps."nix"."0.9.0"."cfg_if"}" deps)
      (crates."libc"."${deps."nix"."0.9.0"."libc"}" deps)
      (crates."void"."${deps."nix"."0.9.0"."void"}" deps)
    ]);
  };
  features_.nix."0.9.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.nix."0.9.0".bitflags}".default = true;
    cfg_if."${deps.nix."0.9.0".cfg_if}".default = true;
    libc."${deps.nix."0.9.0".libc}".default = true;
    nix."0.9.0".default = (f.nix."0.9.0".default or true);
    void."${deps.nix."0.9.0".void}".default = true;
  }) [
    (features_.bitflags."${deps."nix"."0.9.0"."bitflags"}" deps)
    (features_.cfg_if."${deps."nix"."0.9.0"."cfg_if"}" deps)
    (features_.libc."${deps."nix"."0.9.0"."libc"}" deps)
    (features_.void."${deps."nix"."0.9.0"."void"}" deps)
  ];


# end
# num-traits-0.1.43

  crates.num_traits."0.1.43" = deps: { features?(features_.num_traits."0.1.43" deps {}) }: buildRustCrate {
    crateName = "num-traits";
    version = "0.1.43";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1zdzx78vrcg3f39w94pqjs1mwxl1phyv7843hwgwkzggwcxhhf6s";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_traits"."0.1.43"."num_traits"}" deps)
    ]);
  };
  features_.num_traits."0.1.43" = deps: f: updateFeatures f (rec {
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_traits."0.1.43".num_traits}".default = true; }
      { "0.1.43".default = (f.num_traits."0.1.43".default or true); }
    ];
  }) [
    (features_.num_traits."${deps."num_traits"."0.1.43"."num_traits"}" deps)
  ];


# end
# num-traits-0.2.6

  crates.num_traits."0.2.6" = deps: { features?(features_.num_traits."0.2.6" deps {}) }: buildRustCrate {
    crateName = "num-traits";
    version = "0.2.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1d20sil9n0wgznd1nycm3yjfj1mzyl41ambb7by1apxlyiil1azk";
    build = "build.rs";
    features = mkFeatures (features."num_traits"."0.2.6" or {});
  };
  features_.num_traits."0.2.6" = deps: f: updateFeatures f (rec {
    num_traits = fold recursiveUpdate {} [
      { "0.2.6".default = (f.num_traits."0.2.6".default or true); }
      { "0.2.6".std =
        (f.num_traits."0.2.6".std or false) ||
        (f.num_traits."0.2.6".default or false) ||
        (num_traits."0.2.6"."default" or false); }
    ];
  }) [];


# end
# ordermap-0.3.5

  crates.ordermap."0.3.5" = deps: { features?(features_.ordermap."0.3.5" deps {}) }: buildRustCrate {
    crateName = "ordermap";
    version = "0.3.5";
    authors = [ "bluss" ];
    sha256 = "0b6vxfyh627yqm6war3392g1hhi4dbn49ibx2qv6mv490jdhv7d3";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ordermap"."0.3.5" or {});
  };
  features_.ordermap."0.3.5" = deps: f: updateFeatures f (rec {
    ordermap = fold recursiveUpdate {} [
      { "0.3.5".default = (f.ordermap."0.3.5".default or true); }
      { "0.3.5".serde =
        (f.ordermap."0.3.5".serde or false) ||
        (f.ordermap."0.3.5".serde-1 or false) ||
        (ordermap."0.3.5"."serde-1" or false); }
    ];
  }) [];


# end
# petgraph-0.4.13

  crates.petgraph."0.4.13" = deps: { features?(features_.petgraph."0.4.13" deps {}) }: buildRustCrate {
    crateName = "petgraph";
    version = "0.4.13";
    authors = [ "bluss" "mitchmindtree" ];
    sha256 = "0a8k12b9vd0bndwqhafa853w186axdw05bv4kqjimyaz67428g1i";
    dependencies = mapFeatures features ([
      (crates."fixedbitset"."${deps."petgraph"."0.4.13"."fixedbitset"}" deps)
    ]
      ++ (if features.petgraph."0.4.13".ordermap or false then [ (crates.ordermap."${deps."petgraph"."0.4.13".ordermap}" deps) ] else []));
    features = mkFeatures (features."petgraph"."0.4.13" or {});
  };
  features_.petgraph."0.4.13" = deps: f: updateFeatures f (rec {
    fixedbitset."${deps.petgraph."0.4.13".fixedbitset}".default = true;
    ordermap."${deps.petgraph."0.4.13".ordermap}".default = true;
    petgraph = fold recursiveUpdate {} [
      { "0.4.13".default = (f.petgraph."0.4.13".default or true); }
      { "0.4.13".generate =
        (f.petgraph."0.4.13".generate or false) ||
        (f.petgraph."0.4.13".unstable or false) ||
        (petgraph."0.4.13"."unstable" or false); }
      { "0.4.13".graphmap =
        (f.petgraph."0.4.13".graphmap or false) ||
        (f.petgraph."0.4.13".all or false) ||
        (petgraph."0.4.13"."all" or false) ||
        (f.petgraph."0.4.13".default or false) ||
        (petgraph."0.4.13"."default" or false); }
      { "0.4.13".ordermap =
        (f.petgraph."0.4.13".ordermap or false) ||
        (f.petgraph."0.4.13".graphmap or false) ||
        (petgraph."0.4.13"."graphmap" or false); }
      { "0.4.13".quickcheck =
        (f.petgraph."0.4.13".quickcheck or false) ||
        (f.petgraph."0.4.13".all or false) ||
        (petgraph."0.4.13"."all" or false); }
      { "0.4.13".serde =
        (f.petgraph."0.4.13".serde or false) ||
        (f.petgraph."0.4.13".serde-1 or false) ||
        (petgraph."0.4.13"."serde-1" or false); }
      { "0.4.13".serde_derive =
        (f.petgraph."0.4.13".serde_derive or false) ||
        (f.petgraph."0.4.13".serde-1 or false) ||
        (petgraph."0.4.13"."serde-1" or false); }
      { "0.4.13".stable_graph =
        (f.petgraph."0.4.13".stable_graph or false) ||
        (f.petgraph."0.4.13".all or false) ||
        (petgraph."0.4.13"."all" or false) ||
        (f.petgraph."0.4.13".default or false) ||
        (petgraph."0.4.13"."default" or false); }
      { "0.4.13".unstable =
        (f.petgraph."0.4.13".unstable or false) ||
        (f.petgraph."0.4.13".all or false) ||
        (petgraph."0.4.13"."all" or false); }
    ];
  }) [
    (features_.fixedbitset."${deps."petgraph"."0.4.13"."fixedbitset"}" deps)
    (features_.ordermap."${deps."petgraph"."0.4.13"."ordermap"}" deps)
  ];


# end
# phf-0.7.23

  crates.phf."0.7.23" = deps: { features?(features_.phf."0.7.23" deps {}) }: buildRustCrate {
    crateName = "phf";
    version = "0.7.23";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0annmaf9mmm12g2cdwpip32p674pmsf6xpiwa27mz3glmz73y8aq";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf"."0.7.23"."phf_shared"}" deps)
    ]);
    features = mkFeatures (features."phf"."0.7.23" or {});
  };
  features_.phf."0.7.23" = deps: f: updateFeatures f (rec {
    phf."0.7.23".default = (f.phf."0.7.23".default or true);
    phf_shared = fold recursiveUpdate {} [
      { "${deps.phf."0.7.23".phf_shared}"."core" =
        (f.phf_shared."${deps.phf."0.7.23".phf_shared}"."core" or false) ||
        (phf."0.7.23"."core" or false) ||
        (f."phf"."0.7.23"."core" or false); }
      { "${deps.phf."0.7.23".phf_shared}"."unicase" =
        (f.phf_shared."${deps.phf."0.7.23".phf_shared}"."unicase" or false) ||
        (phf."0.7.23"."unicase" or false) ||
        (f."phf"."0.7.23"."unicase" or false); }
      { "${deps.phf."0.7.23".phf_shared}".default = true; }
    ];
  }) [
    (features_.phf_shared."${deps."phf"."0.7.23"."phf_shared"}" deps)
  ];


# end
# phf_codegen-0.7.23

  crates.phf_codegen."0.7.23" = deps: { features?(features_.phf_codegen."0.7.23" deps {}) }: buildRustCrate {
    crateName = "phf_codegen";
    version = "0.7.23";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0k5ly0qykw56fxd19iy236wzghqdxq9zxnzcg8nm22cfzw4a35n0";
    dependencies = mapFeatures features ([
      (crates."phf_generator"."${deps."phf_codegen"."0.7.23"."phf_generator"}" deps)
      (crates."phf_shared"."${deps."phf_codegen"."0.7.23"."phf_shared"}" deps)
    ]);
  };
  features_.phf_codegen."0.7.23" = deps: f: updateFeatures f (rec {
    phf_codegen."0.7.23".default = (f.phf_codegen."0.7.23".default or true);
    phf_generator."${deps.phf_codegen."0.7.23".phf_generator}".default = true;
    phf_shared."${deps.phf_codegen."0.7.23".phf_shared}".default = true;
  }) [
    (features_.phf_generator."${deps."phf_codegen"."0.7.23"."phf_generator"}" deps)
    (features_.phf_shared."${deps."phf_codegen"."0.7.23"."phf_shared"}" deps)
  ];


# end
# phf_generator-0.7.23

  crates.phf_generator."0.7.23" = deps: { features?(features_.phf_generator."0.7.23" deps {}) }: buildRustCrate {
    crateName = "phf_generator";
    version = "0.7.23";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "106cd0bx3jf7mf2gaa8nx62c1las1w95c5gwsd4yqm5lj2rj4mza";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf_generator"."0.7.23"."phf_shared"}" deps)
      (crates."rand"."${deps."phf_generator"."0.7.23"."rand"}" deps)
    ]);
  };
  features_.phf_generator."0.7.23" = deps: f: updateFeatures f (rec {
    phf_generator."0.7.23".default = (f.phf_generator."0.7.23".default or true);
    phf_shared."${deps.phf_generator."0.7.23".phf_shared}".default = true;
    rand."${deps.phf_generator."0.7.23".rand}".default = true;
  }) [
    (features_.phf_shared."${deps."phf_generator"."0.7.23"."phf_shared"}" deps)
    (features_.rand."${deps."phf_generator"."0.7.23"."rand"}" deps)
  ];


# end
# phf_shared-0.7.23

  crates.phf_shared."0.7.23" = deps: { features?(features_.phf_shared."0.7.23" deps {}) }: buildRustCrate {
    crateName = "phf_shared";
    version = "0.7.23";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "04gzsq9vg9j8cr39hpkddxb0yqjdknvcpnylw112rqamy7ml4fy1";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."siphasher"."${deps."phf_shared"."0.7.23"."siphasher"}" deps)
    ]);
    features = mkFeatures (features."phf_shared"."0.7.23" or {});
  };
  features_.phf_shared."0.7.23" = deps: f: updateFeatures f (rec {
    phf_shared."0.7.23".default = (f.phf_shared."0.7.23".default or true);
    siphasher."${deps.phf_shared."0.7.23".siphasher}".default = true;
  }) [
    (features_.siphasher."${deps."phf_shared"."0.7.23"."siphasher"}" deps)
  ];


# end
# pkg-config-0.3.14

  crates.pkg_config."0.3.14" = deps: { features?(features_.pkg_config."0.3.14" deps {}) }: buildRustCrate {
    crateName = "pkg-config";
    version = "0.3.14";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0207fsarrm412j0dh87lfcas72n8mxar7q3mgflsbsrqnb140sv6";
  };
  features_.pkg_config."0.3.14" = deps: f: updateFeatures f (rec {
    pkg_config."0.3.14".default = (f.pkg_config."0.3.14".default or true);
  }) [];


# end
# rand-0.3.22

  crates.rand."0.3.22" = deps: { features?(features_.rand."0.3.22" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.3.22";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0wrj12acx7l4hr7ag3nz8b50yhp8ancyq988bzmnnsxln67rsys0";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."rand"."0.3.22"."libc"}" deps)
      (crates."rand"."${deps."rand"."0.3.22"."rand"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."rand"."0.3.22"."fuchsia_zircon"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.3.22" or {});
  };
  features_.rand."0.3.22" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.rand."0.3.22".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.3.22".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "${deps.rand."0.3.22".rand}".default = true; }
      { "0.3.22".default = (f.rand."0.3.22".default or true); }
      { "0.3.22".i128_support =
        (f.rand."0.3.22".i128_support or false) ||
        (f.rand."0.3.22".nightly or false) ||
        (rand."0.3.22"."nightly" or false); }
    ];
  }) [
    (features_.libc."${deps."rand"."0.3.22"."libc"}" deps)
    (features_.rand."${deps."rand"."0.3.22"."rand"}" deps)
    (features_.fuchsia_zircon."${deps."rand"."0.3.22"."fuchsia_zircon"}" deps)
  ];


# end
# rand-0.4.3

  crates.rand."0.4.3" = deps: { features?(features_.rand."0.4.3" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.4.3";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1644wri45l147822xy7dgdm4k7myxzs66cb795ga0x7dan11ci4f";
    dependencies = (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."rand"."0.4.3"."fuchsia_zircon"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.4.3".libc or false then [ (crates.libc."${deps."rand"."0.4.3".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand"."0.4.3"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.4.3" or {});
  };
  features_.rand."0.4.3" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.rand."0.4.3".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.4.3".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.4.3".default = (f.rand."0.4.3".default or true); }
      { "0.4.3".i128_support =
        (f.rand."0.4.3".i128_support or false) ||
        (f.rand."0.4.3".nightly or false) ||
        (rand."0.4.3"."nightly" or false); }
      { "0.4.3".libc =
        (f.rand."0.4.3".libc or false) ||
        (f.rand."0.4.3".std or false) ||
        (rand."0.4.3"."std" or false); }
      { "0.4.3".std =
        (f.rand."0.4.3".std or false) ||
        (f.rand."0.4.3".default or false) ||
        (rand."0.4.3"."default" or false); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.4.3".winapi}"."minwindef" = true; }
      { "${deps.rand."0.4.3".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.4.3".winapi}"."profileapi" = true; }
      { "${deps.rand."0.4.3".winapi}"."winnt" = true; }
      { "${deps.rand."0.4.3".winapi}".default = true; }
    ];
  }) [
    (features_.fuchsia_zircon."${deps."rand"."0.4.3"."fuchsia_zircon"}" deps)
    (features_.libc."${deps."rand"."0.4.3"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.4.3"."winapi"}" deps)
  ];


# end
# rand-0.5.5

  crates.rand."0.5.5" = deps: { features?(features_.rand."0.5.5" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.5.5";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0d7pnsh57qxhz1ghrzk113ddkn13kf2g758ffnbxq4nhwjfzhlc9";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand"."0.5.5"."rand_core"}" deps)
    ])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".cloudabi or false then [ (crates.cloudabi."${deps."rand"."0.5.5".cloudabi}" deps) ] else [])) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".fuchsia-zircon or false then [ (crates.fuchsia_zircon."${deps."rand"."0.5.5".fuchsia_zircon}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".libc or false then [ (crates.libc."${deps."rand"."0.5.5".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.5".winapi or false then [ (crates.winapi."${deps."rand"."0.5.5".winapi}" deps) ] else [])) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
    features = mkFeatures (features."rand"."0.5.5" or {});
  };
  features_.rand."0.5.5" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand."0.5.5".cloudabi}".default = true;
    fuchsia_zircon."${deps.rand."0.5.5".fuchsia_zircon}".default = true;
    libc."${deps.rand."0.5.5".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.5.5".alloc =
        (f.rand."0.5.5".alloc or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5".cloudabi =
        (f.rand."0.5.5".cloudabi or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5".default = (f.rand."0.5.5".default or true); }
      { "0.5.5".fuchsia-zircon =
        (f.rand."0.5.5".fuchsia-zircon or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5".i128_support =
        (f.rand."0.5.5".i128_support or false) ||
        (f.rand."0.5.5".nightly or false) ||
        (rand."0.5.5"."nightly" or false); }
      { "0.5.5".libc =
        (f.rand."0.5.5".libc or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
      { "0.5.5".serde =
        (f.rand."0.5.5".serde or false) ||
        (f.rand."0.5.5".serde1 or false) ||
        (rand."0.5.5"."serde1" or false); }
      { "0.5.5".serde_derive =
        (f.rand."0.5.5".serde_derive or false) ||
        (f.rand."0.5.5".serde1 or false) ||
        (rand."0.5.5"."serde1" or false); }
      { "0.5.5".std =
        (f.rand."0.5.5".std or false) ||
        (f.rand."0.5.5".default or false) ||
        (rand."0.5.5"."default" or false); }
      { "0.5.5".winapi =
        (f.rand."0.5.5".winapi or false) ||
        (f.rand."0.5.5".std or false) ||
        (rand."0.5.5"."std" or false); }
    ];
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.5.5".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.5.5".rand_core}"."alloc" or false) ||
        (rand."0.5.5"."alloc" or false) ||
        (f."rand"."0.5.5"."alloc" or false); }
      { "${deps.rand."0.5.5".rand_core}"."serde1" =
        (f.rand_core."${deps.rand."0.5.5".rand_core}"."serde1" or false) ||
        (rand."0.5.5"."serde1" or false) ||
        (f."rand"."0.5.5"."serde1" or false); }
      { "${deps.rand."0.5.5".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.5.5".rand_core}"."std" or false) ||
        (rand."0.5.5"."std" or false) ||
        (f."rand"."0.5.5"."std" or false); }
      { "${deps.rand."0.5.5".rand_core}".default = (f.rand_core."${deps.rand."0.5.5".rand_core}".default or false); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.5.5".winapi}"."minwindef" = true; }
      { "${deps.rand."0.5.5".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.5.5".winapi}"."profileapi" = true; }
      { "${deps.rand."0.5.5".winapi}"."winnt" = true; }
      { "${deps.rand."0.5.5".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand"."0.5.5"."rand_core"}" deps)
    (features_.cloudabi."${deps."rand"."0.5.5"."cloudabi"}" deps)
    (features_.fuchsia_zircon."${deps."rand"."0.5.5"."fuchsia_zircon"}" deps)
    (features_.libc."${deps."rand"."0.5.5"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.5.5"."winapi"}" deps)
  ];


# end
# rand_core-0.2.2

  crates.rand_core."0.2.2" = deps: { features?(features_.rand_core."0.2.2" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.2.2";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1cxnaxmsirz2wxsajsjkd1wk6lqfqbcprqkha4bq3didznrl22sc";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_core"."0.2.2"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_core"."0.2.2" or {});
  };
  features_.rand_core."0.2.2" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_core."0.2.2".rand_core}"."alloc" =
        (f.rand_core."${deps.rand_core."0.2.2".rand_core}"."alloc" or false) ||
        (rand_core."0.2.2"."alloc" or false) ||
        (f."rand_core"."0.2.2"."alloc" or false); }
      { "${deps.rand_core."0.2.2".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_core."0.2.2".rand_core}"."serde1" or false) ||
        (rand_core."0.2.2"."serde1" or false) ||
        (f."rand_core"."0.2.2"."serde1" or false); }
      { "${deps.rand_core."0.2.2".rand_core}"."std" =
        (f.rand_core."${deps.rand_core."0.2.2".rand_core}"."std" or false) ||
        (rand_core."0.2.2"."std" or false) ||
        (f."rand_core"."0.2.2"."std" or false); }
      { "${deps.rand_core."0.2.2".rand_core}".default = (f.rand_core."${deps.rand_core."0.2.2".rand_core}".default or false); }
      { "0.2.2".default = (f.rand_core."0.2.2".default or true); }
    ];
  }) [
    (features_.rand_core."${deps."rand_core"."0.2.2"."rand_core"}" deps)
  ];


# end
# rand_core-0.3.0

  crates.rand_core."0.3.0" = deps: { features?(features_.rand_core."0.3.0" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.3.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1vafw316apjys9va3j987s02djhqp7y21v671v3ix0p5j9bjq339";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rand_core"."0.3.0" or {});
  };
  features_.rand_core."0.3.0" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "0.3.0".alloc =
        (f.rand_core."0.3.0".alloc or false) ||
        (f.rand_core."0.3.0".std or false) ||
        (rand_core."0.3.0"."std" or false); }
      { "0.3.0".default = (f.rand_core."0.3.0".default or true); }
      { "0.3.0".serde =
        (f.rand_core."0.3.0".serde or false) ||
        (f.rand_core."0.3.0".serde1 or false) ||
        (rand_core."0.3.0"."serde1" or false); }
      { "0.3.0".serde_derive =
        (f.rand_core."0.3.0".serde_derive or false) ||
        (f.rand_core."0.3.0".serde1 or false) ||
        (rand_core."0.3.0"."serde1" or false); }
      { "0.3.0".std =
        (f.rand_core."0.3.0".std or false) ||
        (f.rand_core."0.3.0".default or false) ||
        (rand_core."0.3.0"."default" or false); }
    ];
  }) [];


# end
# regex-0.1.80

  crates.regex."0.1.80" = deps: { features?(features_.regex."0.1.80" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.1.80";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0y4s8ghhx6sgzb35irwivm3w0l2hhqhmdcd2px9hirqnkagal9l6";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.1.80"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.1.80"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.1.80"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.1.80"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.1.80"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.1.80" or {});
  };
  features_.regex."0.1.80" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.1.80".aho_corasick}".default = true;
    memchr."${deps.regex."0.1.80".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.1.80".default = (f.regex."0.1.80".default or true); }
      { "0.1.80".simd =
        (f.regex."0.1.80".simd or false) ||
        (f.regex."0.1.80".simd-accel or false) ||
        (regex."0.1.80"."simd-accel" or false); }
    ];
    regex_syntax."${deps.regex."0.1.80".regex_syntax}".default = true;
    thread_local."${deps.regex."0.1.80".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.1.80".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.1.80"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.1.80"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.1.80"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.1.80"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.1.80"."utf8_ranges"}" deps)
  ];


# end
# regex-syntax-0.3.9

  crates.regex_syntax."0.3.9" = deps: { features?(features_.regex_syntax."0.3.9" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.3.9";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1mzhphkbwppwd1zam2jkgjk550cqgf6506i87bw2yzrvcsraiw7m";
  };
  features_.regex_syntax."0.3.9" = deps: f: updateFeatures f (rec {
    regex_syntax."0.3.9".default = (f.regex_syntax."0.3.9".default or true);
  }) [];


# end
# rlua-0.9.7

  crates.rlua."0.9.7" = deps: { features?(features_.rlua."0.9.7" deps {}) }: buildRustCrate {
    crateName = "rlua";
    version = "0.9.7";
    authors = [ "kyren <catherine@chucklefish.org>" ];
    sha256 = "1671b5ga54aq49sqx69hvnjr732hf9jpqwswwxgpcqq8q05mfzgp";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."rlua"."0.9.7"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
    ]
      ++ (if features.rlua."0.9.7".gcc or false then [ (crates.gcc."${deps."rlua"."0.9.7".gcc}" deps) ] else []));
    features = mkFeatures (features."rlua"."0.9.7" or {});
  };
  features_.rlua."0.9.7" = deps: f: updateFeatures f (rec {
    gcc."${deps.rlua."0.9.7".gcc}".default = true;
    libc."${deps.rlua."0.9.7".libc}".default = true;
    rlua = fold recursiveUpdate {} [
      { "0.9.7".builtin-lua =
        (f.rlua."0.9.7".builtin-lua or false) ||
        (f.rlua."0.9.7".default or false) ||
        (rlua."0.9.7"."default" or false); }
      { "0.9.7".default = (f.rlua."0.9.7".default or true); }
      { "0.9.7".gcc =
        (f.rlua."0.9.7".gcc or false) ||
        (f.rlua."0.9.7".builtin-lua or false) ||
        (rlua."0.9.7"."builtin-lua" or false); }
    ];
  }) [
    (features_.libc."${deps."rlua"."0.9.7"."libc"}" deps)
    (features_.gcc."${deps."rlua"."0.9.7"."gcc"}" deps)
  ];


# end
# rustc-serialize-0.3.24

  crates.rustc_serialize."0.3.24" = deps: { features?(features_.rustc_serialize."0.3.24" deps {}) }: buildRustCrate {
    crateName = "rustc-serialize";
    version = "0.3.24";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0rfk6p66mqkd3g36l0ddlv2rvnp1mp3lrq5frq9zz5cbnz5pmmxn";
  };
  features_.rustc_serialize."0.3.24" = deps: f: updateFeatures f (rec {
    rustc_serialize."0.3.24".default = (f.rustc_serialize."0.3.24".default or true);
  }) [];


# end
# rustc_version-0.1.7

  crates.rustc_version."0.1.7" = deps: { features?(features_.rustc_version."0.1.7" deps {}) }: buildRustCrate {
    crateName = "rustc_version";
    version = "0.1.7";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "0plm9pbyvcwfibd0kbhzil9xmr1bvqi8fgwlfw0x4vali8s6s99p";
    dependencies = mapFeatures features ([
      (crates."semver"."${deps."rustc_version"."0.1.7"."semver"}" deps)
    ]);
  };
  features_.rustc_version."0.1.7" = deps: f: updateFeatures f (rec {
    rustc_version."0.1.7".default = (f.rustc_version."0.1.7".default or true);
    semver."${deps.rustc_version."0.1.7".semver}".default = true;
  }) [
    (features_.semver."${deps."rustc_version"."0.1.7"."semver"}" deps)
  ];


# end
# rustwlc-0.7.0

  crates.rustwlc."0.7.0" = deps: { features?(features_.rustwlc."0.7.0" deps {}) }: buildRustCrate {
    crateName = "rustwlc";
    version = "0.7.0";
    authors = [ "Snirk Immington <snirk.immington@gmail.com>" "Timidger <apragmaticplace@gmail.com>" ];
    sha256 = "0gqi9pdw74al33ja25h33q68vnfklj3gpjgkiqqbr3gflgli5h1i";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."rustwlc"."0.7.0"."bitflags"}" deps)
      (crates."libc"."${deps."rustwlc"."0.7.0"."libc"}" deps)
    ]
      ++ (if features.rustwlc."0.7.0".wayland-sys or false then [ (crates.wayland_sys."${deps."rustwlc"."0.7.0".wayland_sys}" deps) ] else []));
    features = mkFeatures (features."rustwlc"."0.7.0" or {});
  };
  features_.rustwlc."0.7.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.rustwlc."0.7.0".bitflags}".default = true;
    libc."${deps.rustwlc."0.7.0".libc}".default = true;
    rustwlc = fold recursiveUpdate {} [
      { "0.7.0".default = (f.rustwlc."0.7.0".default or true); }
      { "0.7.0".wayland-sys =
        (f.rustwlc."0.7.0".wayland-sys or false) ||
        (f.rustwlc."0.7.0".wlc-wayland or false) ||
        (rustwlc."0.7.0"."wlc-wayland" or false); }
    ];
    wayland_sys = fold recursiveUpdate {} [
      { "${deps.rustwlc."0.7.0".wayland_sys}"."server" = true; }
      { "${deps.rustwlc."0.7.0".wayland_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."rustwlc"."0.7.0"."bitflags"}" deps)
    (features_.libc."${deps."rustwlc"."0.7.0"."libc"}" deps)
    (features_.wayland_sys."${deps."rustwlc"."0.7.0"."wayland_sys"}" deps)
  ];


# end
# semver-0.1.20

  crates.semver."0.1.20" = deps: { features?(features_.semver."0.1.20" deps {}) }: buildRustCrate {
    crateName = "semver";
    version = "0.1.20";
    authors = [ "The Rust Project Developers" ];
    sha256 = "05cdig0071hls2k8lxbqmyqpl0zjmc53i2d43mwzps033b8njh4n";
  };
  features_.semver."0.1.20" = deps: f: updateFeatures f (rec {
    semver."0.1.20".default = (f.semver."0.1.20".default or true);
  }) [];


# end
# serde-0.9.15

  crates.serde."0.9.15" = deps: { features?(features_.serde."0.9.15" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "0.9.15";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" ];
    sha256 = "0rlflkc57kvy69hnhj4arfsj7ic4hpihxsb00zg5lkdxfj5qjx9b";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."0.9.15" or {});
  };
  features_.serde."0.9.15" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "0.9.15".alloc =
        (f.serde."0.9.15".alloc or false) ||
        (f.serde."0.9.15".collections or false) ||
        (serde."0.9.15"."collections" or false); }
      { "0.9.15".default = (f.serde."0.9.15".default or true); }
      { "0.9.15".serde_derive =
        (f.serde."0.9.15".serde_derive or false) ||
        (f.serde."0.9.15".derive or false) ||
        (serde."0.9.15"."derive" or false) ||
        (f.serde."0.9.15".playground or false) ||
        (serde."0.9.15"."playground" or false); }
      { "0.9.15".std =
        (f.serde."0.9.15".std or false) ||
        (f.serde."0.9.15".default or false) ||
        (serde."0.9.15"."default" or false) ||
        (f.serde."0.9.15".unstable-testing or false) ||
        (serde."0.9.15"."unstable-testing" or false); }
      { "0.9.15".unstable =
        (f.serde."0.9.15".unstable or false) ||
        (f.serde."0.9.15".alloc or false) ||
        (serde."0.9.15"."alloc" or false) ||
        (f.serde."0.9.15".unstable-testing or false) ||
        (serde."0.9.15"."unstable-testing" or false); }
    ];
  }) [];


# end
# serde_json-0.9.10

  crates.serde_json."0.9.10" = deps: { features?(features_.serde_json."0.9.10" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "0.9.10";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" ];
    sha256 = "0g6bxlfnvf2miicnsizyrxm686rfval6gbss1i2qcna8msfwc005";
    dependencies = mapFeatures features ([
      (crates."dtoa"."${deps."serde_json"."0.9.10"."dtoa"}" deps)
      (crates."itoa"."${deps."serde_json"."0.9.10"."itoa"}" deps)
      (crates."num_traits"."${deps."serde_json"."0.9.10"."num_traits"}" deps)
      (crates."serde"."${deps."serde_json"."0.9.10"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."0.9.10" or {});
  };
  features_.serde_json."0.9.10" = deps: f: updateFeatures f (rec {
    dtoa."${deps.serde_json."0.9.10".dtoa}".default = true;
    itoa."${deps.serde_json."0.9.10".itoa}".default = true;
    num_traits."${deps.serde_json."0.9.10".num_traits}".default = true;
    serde."${deps.serde_json."0.9.10".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "0.9.10".default = (f.serde_json."0.9.10".default or true); }
      { "0.9.10".linked-hash-map =
        (f.serde_json."0.9.10".linked-hash-map or false) ||
        (f.serde_json."0.9.10".preserve_order or false) ||
        (serde_json."0.9.10"."preserve_order" or false); }
    ];
  }) [
    (features_.dtoa."${deps."serde_json"."0.9.10"."dtoa"}" deps)
    (features_.itoa."${deps."serde_json"."0.9.10"."itoa"}" deps)
    (features_.num_traits."${deps."serde_json"."0.9.10"."num_traits"}" deps)
    (features_.serde."${deps."serde_json"."0.9.10"."serde"}" deps)
  ];


# end
# siphasher-0.2.3

  crates.siphasher."0.2.3" = deps: { features?(features_.siphasher."0.2.3" deps {}) }: buildRustCrate {
    crateName = "siphasher";
    version = "0.2.3";
    authors = [ "Frank Denis <github@pureftpd.org>" ];
    sha256 = "1ganj1grxqnkvv4ds3vby039bm999jrr58nfq2x3kjhzkw2bnqkw";
  };
  features_.siphasher."0.2.3" = deps: f: updateFeatures f (rec {
    siphasher."0.2.3".default = (f.siphasher."0.2.3".default or true);
  }) [];


# end
# target_build_utils-0.3.1

  crates.target_build_utils."0.3.1" = deps: { features?(features_.target_build_utils."0.3.1" deps {}) }: buildRustCrate {
    crateName = "target_build_utils";
    version = "0.3.1";
    authors = [ "Simonas Kazlauskas <target_build_utils@kazlauskas.me>" ];
    sha256 = "1b450nyxlbgicp2p45mhxiv6yv0z7s4iw01lsaqh3v7b4bm53flj";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."phf"."${deps."target_build_utils"."0.3.1"."phf"}" deps)
    ]
      ++ (if features.target_build_utils."0.3.1".serde_json or false then [ (crates.serde_json."${deps."target_build_utils"."0.3.1".serde_json}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."phf_codegen"."${deps."target_build_utils"."0.3.1"."phf_codegen"}" deps)
    ]);
    features = mkFeatures (features."target_build_utils"."0.3.1" or {});
  };
  features_.target_build_utils."0.3.1" = deps: f: updateFeatures f (rec {
    phf."${deps.target_build_utils."0.3.1".phf}".default = true;
    phf_codegen."${deps.target_build_utils."0.3.1".phf_codegen}".default = true;
    serde_json."${deps.target_build_utils."0.3.1".serde_json}".default = true;
    target_build_utils = fold recursiveUpdate {} [
      { "0.3.1".default = (f.target_build_utils."0.3.1".default or true); }
      { "0.3.1".serde_json =
        (f.target_build_utils."0.3.1".serde_json or false) ||
        (f.target_build_utils."0.3.1".default or false) ||
        (target_build_utils."0.3.1"."default" or false); }
    ];
  }) [
    (features_.phf."${deps."target_build_utils"."0.3.1"."phf"}" deps)
    (features_.serde_json."${deps."target_build_utils"."0.3.1"."serde_json"}" deps)
    (features_.phf_codegen."${deps."target_build_utils"."0.3.1"."phf_codegen"}" deps)
  ];


# end
# thread-id-2.0.0

  crates.thread_id."2.0.0" = deps: { features?(features_.thread_id."2.0.0" deps {}) }: buildRustCrate {
    crateName = "thread-id";
    version = "2.0.0";
    authors = [ "Ruud van Asseldonk <dev@veniogames.com>" ];
    sha256 = "06i3c8ckn97i5rp16civ2vpqbknlkx66dkrl070iw60nawi0kjc3";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."thread_id"."2.0.0"."kernel32_sys"}" deps)
      (crates."libc"."${deps."thread_id"."2.0.0"."libc"}" deps)
    ]);
  };
  features_.thread_id."2.0.0" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.thread_id."2.0.0".kernel32_sys}".default = true;
    libc."${deps.thread_id."2.0.0".libc}".default = true;
    thread_id."2.0.0".default = (f.thread_id."2.0.0".default or true);
  }) [
    (features_.kernel32_sys."${deps."thread_id"."2.0.0"."kernel32_sys"}" deps)
    (features_.libc."${deps."thread_id"."2.0.0"."libc"}" deps)
  ];


# end
# thread_local-0.2.7

  crates.thread_local."0.2.7" = deps: { features?(features_.thread_local."0.2.7" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.2.7";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "19p0zrs24rdwjvpi10jig5ms3sxj00pv8shkr9cpddri8cdghqp7";
    dependencies = mapFeatures features ([
      (crates."thread_id"."${deps."thread_local"."0.2.7"."thread_id"}" deps)
    ]);
  };
  features_.thread_local."0.2.7" = deps: f: updateFeatures f (rec {
    thread_id."${deps.thread_local."0.2.7".thread_id}".default = true;
    thread_local."0.2.7".default = (f.thread_local."0.2.7".default or true);
  }) [
    (features_.thread_id."${deps."thread_local"."0.2.7"."thread_id"}" deps)
  ];


# end
# token_store-0.1.2

  crates.token_store."0.1.2" = deps: { features?(features_.token_store."0.1.2" deps {}) }: buildRustCrate {
    crateName = "token_store";
    version = "0.1.2";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "1v7acraqyh6iibg87pwkxm41v783sminxm5k9f4ndra7r0vq4zvq";
  };
  features_.token_store."0.1.2" = deps: f: updateFeatures f (rec {
    token_store."0.1.2".default = (f.token_store."0.1.2".default or true);
  }) [];


# end
# unicode-width-0.1.5

  crates.unicode_width."0.1.5" = deps: { features?(features_.unicode_width."0.1.5" deps {}) }: buildRustCrate {
    crateName = "unicode-width";
    version = "0.1.5";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "0886lc2aymwgy0lhavwn6s48ik3c61ykzzd3za6prgnw51j7bi4w";
    features = mkFeatures (features."unicode_width"."0.1.5" or {});
  };
  features_.unicode_width."0.1.5" = deps: f: updateFeatures f (rec {
    unicode_width."0.1.5".default = (f.unicode_width."0.1.5".default or true);
  }) [];


# end
# utf8-ranges-0.1.3

  crates.utf8_ranges."0.1.3" = deps: { features?(features_.utf8_ranges."0.1.3" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "0.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1cj548a91a93j8375p78qikaiam548xh84cb0ck8y119adbmsvbp";
  };
  features_.utf8_ranges."0.1.3" = deps: f: updateFeatures f (rec {
    utf8_ranges."0.1.3".default = (f.utf8_ranges."0.1.3".default or true);
  }) [];


# end
# uuid-0.3.1

  crates.uuid."0.3.1" = deps: { features?(features_.uuid."0.3.1" deps {}) }: buildRustCrate {
    crateName = "uuid";
    version = "0.3.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "16ak1c84dfkd8h33cvkxrkvc30k7b0bhrnza8ni2c0jsx85fpbip";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.uuid."0.3.1".rand or false then [ (crates.rand."${deps."uuid"."0.3.1".rand}" deps) ] else [])
      ++ (if features.uuid."0.3.1".rustc-serialize or false then [ (crates.rustc_serialize."${deps."uuid"."0.3.1".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."uuid"."0.3.1" or {});
  };
  features_.uuid."0.3.1" = deps: f: updateFeatures f (rec {
    rand."${deps.uuid."0.3.1".rand}".default = true;
    rustc_serialize."${deps.uuid."0.3.1".rustc_serialize}".default = true;
    uuid = fold recursiveUpdate {} [
      { "0.3.1".default = (f.uuid."0.3.1".default or true); }
      { "0.3.1".rand =
        (f.uuid."0.3.1".rand or false) ||
        (f.uuid."0.3.1".v4 or false) ||
        (uuid."0.3.1"."v4" or false); }
      { "0.3.1".sha1 =
        (f.uuid."0.3.1".sha1 or false) ||
        (f.uuid."0.3.1".v5 or false) ||
        (uuid."0.3.1"."v5" or false); }
    ];
  }) [
    (features_.rand."${deps."uuid"."0.3.1"."rand"}" deps)
    (features_.rustc_serialize."${deps."uuid"."0.3.1"."rustc_serialize"}" deps)
  ];


# end
# void-1.0.2

  crates.void."1.0.2" = deps: { features?(features_.void."1.0.2" deps {}) }: buildRustCrate {
    crateName = "void";
    version = "1.0.2";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "0h1dm0dx8dhf56a83k68mijyxigqhizpskwxfdrs1drwv2cdclv3";
    features = mkFeatures (features."void"."1.0.2" or {});
  };
  features_.void."1.0.2" = deps: f: updateFeatures f (rec {
    void = fold recursiveUpdate {} [
      { "1.0.2".default = (f.void."1.0.2".default or true); }
      { "1.0.2".std =
        (f.void."1.0.2".std or false) ||
        (f.void."1.0.2".default or false) ||
        (void."1.0.2"."default" or false); }
    ];
  }) [];


# end
# way-cooler-0.8.1

  crates.way_cooler."0.8.1" = deps: { features?(features_.way_cooler."0.8.1" deps {}) }: buildRustCrate {
    crateName = "way-cooler";
    version = "0.8.1";
    authors = [ "Snirk Immington <snirk.immington@gmail.com>" "Timidger <apragmaticplace@gmail.com>" ];
    sha256 = "01cp5z0qf522d7cvsr9gfp7f4hkphmp38hv70dsf9lvcnp6p1qkc";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."way_cooler"."0.8.1"."bitflags"}" deps)
      (crates."cairo_rs"."${deps."way_cooler"."0.8.1"."cairo_rs"}" deps)
      (crates."cairo_sys_rs"."${deps."way_cooler"."0.8.1"."cairo_sys_rs"}" deps)
      (crates."dbus"."${deps."way_cooler"."0.8.1"."dbus"}" deps)
      (crates."dbus_macros"."${deps."way_cooler"."0.8.1"."dbus_macros"}" deps)
      (crates."env_logger"."${deps."way_cooler"."0.8.1"."env_logger"}" deps)
      (crates."gdk_pixbuf"."${deps."way_cooler"."0.8.1"."gdk_pixbuf"}" deps)
      (crates."getopts"."${deps."way_cooler"."0.8.1"."getopts"}" deps)
      (crates."glib"."${deps."way_cooler"."0.8.1"."glib"}" deps)
      (crates."json_macro"."${deps."way_cooler"."0.8.1"."json_macro"}" deps)
      (crates."lazy_static"."${deps."way_cooler"."0.8.1"."lazy_static"}" deps)
      (crates."log"."${deps."way_cooler"."0.8.1"."log"}" deps)
      (crates."nix"."${deps."way_cooler"."0.8.1"."nix"}" deps)
      (crates."petgraph"."${deps."way_cooler"."0.8.1"."petgraph"}" deps)
      (crates."rlua"."${deps."way_cooler"."0.8.1"."rlua"}" deps)
      (crates."rustc_serialize"."${deps."way_cooler"."0.8.1"."rustc_serialize"}" deps)
      (crates."rustwlc"."${deps."way_cooler"."0.8.1"."rustwlc"}" deps)
      (crates."uuid"."${deps."way_cooler"."0.8.1"."uuid"}" deps)
      (crates."wayland_server"."${deps."way_cooler"."0.8.1"."wayland_server"}" deps)
      (crates."wayland_sys"."${deps."way_cooler"."0.8.1"."wayland_sys"}" deps)
      (crates."xcb"."${deps."way_cooler"."0.8.1"."xcb"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."wayland_scanner"."${deps."way_cooler"."0.8.1"."wayland_scanner"}" deps)
    ]);
    features = mkFeatures (features."way_cooler"."0.8.1" or {});
  };
  features_.way_cooler."0.8.1" = deps: f: updateFeatures f (rec {
    bitflags."${deps.way_cooler."0.8.1".bitflags}".default = true;
    cairo_rs."${deps.way_cooler."0.8.1".cairo_rs}".default = true;
    cairo_sys_rs."${deps.way_cooler."0.8.1".cairo_sys_rs}".default = true;
    dbus."${deps.way_cooler."0.8.1".dbus}".default = true;
    dbus_macros."${deps.way_cooler."0.8.1".dbus_macros}".default = true;
    env_logger."${deps.way_cooler."0.8.1".env_logger}".default = true;
    gdk_pixbuf."${deps.way_cooler."0.8.1".gdk_pixbuf}".default = true;
    getopts."${deps.way_cooler."0.8.1".getopts}".default = true;
    glib."${deps.way_cooler."0.8.1".glib}".default = true;
    json_macro."${deps.way_cooler."0.8.1".json_macro}".default = true;
    lazy_static."${deps.way_cooler."0.8.1".lazy_static}".default = true;
    log."${deps.way_cooler."0.8.1".log}".default = true;
    nix."${deps.way_cooler."0.8.1".nix}".default = true;
    petgraph."${deps.way_cooler."0.8.1".petgraph}".default = true;
    rlua = fold recursiveUpdate {} [
      { "${deps.way_cooler."0.8.1".rlua}"."builtin-lua" =
        (f.rlua."${deps.way_cooler."0.8.1".rlua}"."builtin-lua" or false) ||
        (way_cooler."0.8.1"."builtin-lua" or false) ||
        (f."way_cooler"."0.8.1"."builtin-lua" or false); }
      { "${deps.way_cooler."0.8.1".rlua}".default = (f.rlua."${deps.way_cooler."0.8.1".rlua}".default or false); }
    ];
    rustc_serialize."${deps.way_cooler."0.8.1".rustc_serialize}".default = true;
    rustwlc = fold recursiveUpdate {} [
      { "${deps.way_cooler."0.8.1".rustwlc}"."static-wlc" =
        (f.rustwlc."${deps.way_cooler."0.8.1".rustwlc}"."static-wlc" or false) ||
        (way_cooler."0.8.1"."static-wlc" or false) ||
        (f."way_cooler"."0.8.1"."static-wlc" or false); }
      { "${deps.way_cooler."0.8.1".rustwlc}"."wlc-wayland" = true; }
      { "${deps.way_cooler."0.8.1".rustwlc}".default = true; }
    ];
    uuid = fold recursiveUpdate {} [
      { "${deps.way_cooler."0.8.1".uuid}"."rustc-serialize" = true; }
      { "${deps.way_cooler."0.8.1".uuid}"."v4" = true; }
      { "${deps.way_cooler."0.8.1".uuid}".default = true; }
    ];
    way_cooler."0.8.1".default = (f.way_cooler."0.8.1".default or true);
    wayland_scanner."${deps.way_cooler."0.8.1".wayland_scanner}".default = true;
    wayland_server."${deps.way_cooler."0.8.1".wayland_server}".default = true;
    wayland_sys = fold recursiveUpdate {} [
      { "${deps.way_cooler."0.8.1".wayland_sys}"."client" = true; }
      { "${deps.way_cooler."0.8.1".wayland_sys}"."dlopen" = true; }
      { "${deps.way_cooler."0.8.1".wayland_sys}".default = true; }
    ];
    xcb = fold recursiveUpdate {} [
      { "${deps.way_cooler."0.8.1".xcb}"."xkb" = true; }
      { "${deps.way_cooler."0.8.1".xcb}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."way_cooler"."0.8.1"."bitflags"}" deps)
    (features_.cairo_rs."${deps."way_cooler"."0.8.1"."cairo_rs"}" deps)
    (features_.cairo_sys_rs."${deps."way_cooler"."0.8.1"."cairo_sys_rs"}" deps)
    (features_.dbus."${deps."way_cooler"."0.8.1"."dbus"}" deps)
    (features_.dbus_macros."${deps."way_cooler"."0.8.1"."dbus_macros"}" deps)
    (features_.env_logger."${deps."way_cooler"."0.8.1"."env_logger"}" deps)
    (features_.gdk_pixbuf."${deps."way_cooler"."0.8.1"."gdk_pixbuf"}" deps)
    (features_.getopts."${deps."way_cooler"."0.8.1"."getopts"}" deps)
    (features_.glib."${deps."way_cooler"."0.8.1"."glib"}" deps)
    (features_.json_macro."${deps."way_cooler"."0.8.1"."json_macro"}" deps)
    (features_.lazy_static."${deps."way_cooler"."0.8.1"."lazy_static"}" deps)
    (features_.log."${deps."way_cooler"."0.8.1"."log"}" deps)
    (features_.nix."${deps."way_cooler"."0.8.1"."nix"}" deps)
    (features_.petgraph."${deps."way_cooler"."0.8.1"."petgraph"}" deps)
    (features_.rlua."${deps."way_cooler"."0.8.1"."rlua"}" deps)
    (features_.rustc_serialize."${deps."way_cooler"."0.8.1"."rustc_serialize"}" deps)
    (features_.rustwlc."${deps."way_cooler"."0.8.1"."rustwlc"}" deps)
    (features_.uuid."${deps."way_cooler"."0.8.1"."uuid"}" deps)
    (features_.wayland_server."${deps."way_cooler"."0.8.1"."wayland_server"}" deps)
    (features_.wayland_sys."${deps."way_cooler"."0.8.1"."wayland_sys"}" deps)
    (features_.xcb."${deps."way_cooler"."0.8.1"."xcb"}" deps)
    (features_.wayland_scanner."${deps."way_cooler"."0.8.1"."wayland_scanner"}" deps)
  ];


# end
# wayland-scanner-0.12.5

  crates.wayland_scanner."0.12.5" = deps: { features?(features_.wayland_scanner."0.12.5" deps {}) }: buildRustCrate {
    crateName = "wayland-scanner";
    version = "0.12.5";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "1s0fsc3pff0fxvzqsy8n018smwacih9ix8ww0yf969aa0vak15dz";
    dependencies = mapFeatures features ([
      (crates."xml_rs"."${deps."wayland_scanner"."0.12.5"."xml_rs"}" deps)
    ]);
  };
  features_.wayland_scanner."0.12.5" = deps: f: updateFeatures f (rec {
    wayland_scanner."0.12.5".default = (f.wayland_scanner."0.12.5".default or true);
    xml_rs."${deps.wayland_scanner."0.12.5".xml_rs}".default = true;
  }) [
    (features_.xml_rs."${deps."wayland_scanner"."0.12.5"."xml_rs"}" deps)
  ];


# end
# wayland-server-0.12.5

  crates.wayland_server."0.12.5" = deps: { features?(features_.wayland_server."0.12.5" deps {}) }: buildRustCrate {
    crateName = "wayland-server";
    version = "0.12.5";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "17g0m9afcmi24ylirw4l8i70s5849x7m4b5nxk9k13s5pkza68ag";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."wayland_server"."0.12.5"."bitflags"}" deps)
      (crates."libc"."${deps."wayland_server"."0.12.5"."libc"}" deps)
      (crates."nix"."${deps."wayland_server"."0.12.5"."nix"}" deps)
      (crates."token_store"."${deps."wayland_server"."0.12.5"."token_store"}" deps)
      (crates."wayland_sys"."${deps."wayland_server"."0.12.5"."wayland_sys"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."wayland_scanner"."${deps."wayland_server"."0.12.5"."wayland_scanner"}" deps)
    ]);
    features = mkFeatures (features."wayland_server"."0.12.5" or {});
  };
  features_.wayland_server."0.12.5" = deps: f: updateFeatures f (rec {
    bitflags."${deps.wayland_server."0.12.5".bitflags}".default = true;
    libc."${deps.wayland_server."0.12.5".libc}".default = true;
    nix."${deps.wayland_server."0.12.5".nix}".default = true;
    token_store."${deps.wayland_server."0.12.5".token_store}".default = true;
    wayland_scanner."${deps.wayland_server."0.12.5".wayland_scanner}".default = true;
    wayland_server."0.12.5".default = (f.wayland_server."0.12.5".default or true);
    wayland_sys = fold recursiveUpdate {} [
      { "${deps.wayland_server."0.12.5".wayland_sys}"."dlopen" =
        (f.wayland_sys."${deps.wayland_server."0.12.5".wayland_sys}"."dlopen" or false) ||
        (wayland_server."0.12.5"."dlopen" or false) ||
        (f."wayland_server"."0.12.5"."dlopen" or false); }
      { "${deps.wayland_server."0.12.5".wayland_sys}"."server" = true; }
      { "${deps.wayland_server."0.12.5".wayland_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."wayland_server"."0.12.5"."bitflags"}" deps)
    (features_.libc."${deps."wayland_server"."0.12.5"."libc"}" deps)
    (features_.nix."${deps."wayland_server"."0.12.5"."nix"}" deps)
    (features_.token_store."${deps."wayland_server"."0.12.5"."token_store"}" deps)
    (features_.wayland_sys."${deps."wayland_server"."0.12.5"."wayland_sys"}" deps)
    (features_.wayland_scanner."${deps."wayland_server"."0.12.5"."wayland_scanner"}" deps)
  ];


# end
# wayland-sys-0.6.0

  crates.wayland_sys."0.6.0" = deps: { features?(features_.wayland_sys."0.6.0" deps {}) }: buildRustCrate {
    crateName = "wayland-sys";
    version = "0.6.0";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "0m6db0kld2d4xv4ai9kxlqrh362hwi0030b4zbss0sfha1hx5mfl";
    dependencies = mapFeatures features ([
      (crates."dlib"."${deps."wayland_sys"."0.6.0"."dlib"}" deps)
    ]
      ++ (if features.wayland_sys."0.6.0".libc or false then [ (crates.libc."${deps."wayland_sys"."0.6.0".libc}" deps) ] else []));
    features = mkFeatures (features."wayland_sys"."0.6.0" or {});
  };
  features_.wayland_sys."0.6.0" = deps: f: updateFeatures f (rec {
    dlib = fold recursiveUpdate {} [
      { "${deps.wayland_sys."0.6.0".dlib}"."dlopen" =
        (f.dlib."${deps.wayland_sys."0.6.0".dlib}"."dlopen" or false) ||
        (wayland_sys."0.6.0"."dlopen" or false) ||
        (f."wayland_sys"."0.6.0"."dlopen" or false); }
      { "${deps.wayland_sys."0.6.0".dlib}".default = true; }
    ];
    libc."${deps.wayland_sys."0.6.0".libc}".default = true;
    wayland_sys = fold recursiveUpdate {} [
      { "0.6.0".default = (f.wayland_sys."0.6.0".default or true); }
      { "0.6.0".lazy_static =
        (f.wayland_sys."0.6.0".lazy_static or false) ||
        (f.wayland_sys."0.6.0".dlopen or false) ||
        (wayland_sys."0.6.0"."dlopen" or false); }
      { "0.6.0".libc =
        (f.wayland_sys."0.6.0".libc or false) ||
        (f.wayland_sys."0.6.0".server or false) ||
        (wayland_sys."0.6.0"."server" or false); }
    ];
  }) [
    (features_.dlib."${deps."wayland_sys"."0.6.0"."dlib"}" deps)
    (features_.libc."${deps."wayland_sys"."0.6.0"."libc"}" deps)
  ];


# end
# wayland-sys-0.9.10

  crates.wayland_sys."0.9.10" = deps: { features?(features_.wayland_sys."0.9.10" deps {}) }: buildRustCrate {
    crateName = "wayland-sys";
    version = "0.9.10";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "011q7lfii222whvif39asvryl1sf3rc1fxp8qs8gh84kr4mna0k8";
    dependencies = mapFeatures features ([
      (crates."dlib"."${deps."wayland_sys"."0.9.10"."dlib"}" deps)
    ]
      ++ (if features.wayland_sys."0.9.10".lazy_static or false then [ (crates.lazy_static."${deps."wayland_sys"."0.9.10".lazy_static}" deps) ] else [])
      ++ (if features.wayland_sys."0.9.10".libc or false then [ (crates.libc."${deps."wayland_sys"."0.9.10".libc}" deps) ] else []));
    features = mkFeatures (features."wayland_sys"."0.9.10" or {});
  };
  features_.wayland_sys."0.9.10" = deps: f: updateFeatures f (rec {
    dlib = fold recursiveUpdate {} [
      { "${deps.wayland_sys."0.9.10".dlib}"."dlopen" =
        (f.dlib."${deps.wayland_sys."0.9.10".dlib}"."dlopen" or false) ||
        (wayland_sys."0.9.10"."dlopen" or false) ||
        (f."wayland_sys"."0.9.10"."dlopen" or false); }
      { "${deps.wayland_sys."0.9.10".dlib}".default = true; }
    ];
    lazy_static."${deps.wayland_sys."0.9.10".lazy_static}".default = true;
    libc."${deps.wayland_sys."0.9.10".libc}".default = true;
    wayland_sys = fold recursiveUpdate {} [
      { "0.9.10".default = (f.wayland_sys."0.9.10".default or true); }
      { "0.9.10".lazy_static =
        (f.wayland_sys."0.9.10".lazy_static or false) ||
        (f.wayland_sys."0.9.10".dlopen or false) ||
        (wayland_sys."0.9.10"."dlopen" or false); }
      { "0.9.10".libc =
        (f.wayland_sys."0.9.10".libc or false) ||
        (f.wayland_sys."0.9.10".server or false) ||
        (wayland_sys."0.9.10"."server" or false); }
    ];
  }) [
    (features_.dlib."${deps."wayland_sys"."0.9.10"."dlib"}" deps)
    (features_.lazy_static."${deps."wayland_sys"."0.9.10"."lazy_static"}" deps)
    (features_.libc."${deps."wayland_sys"."0.9.10"."libc"}" deps)
  ];


# end
# wayland-sys-0.12.5

  crates.wayland_sys."0.12.5" = deps: { features?(features_.wayland_sys."0.12.5" deps {}) }: buildRustCrate {
    crateName = "wayland-sys";
    version = "0.12.5";
    authors = [ "Victor Berger <victor.berger@m4x.org>" ];
    sha256 = "0mwk5vc7mibxka5w66vy2qj32b72d1srqvp36nr15xfl9lwf3dc4";
    dependencies = mapFeatures features ([
      (crates."dlib"."${deps."wayland_sys"."0.12.5"."dlib"}" deps)
    ]
      ++ (if features.wayland_sys."0.12.5".lazy_static or false then [ (crates.lazy_static."${deps."wayland_sys"."0.12.5".lazy_static}" deps) ] else [])
      ++ (if features.wayland_sys."0.12.5".libc or false then [ (crates.libc."${deps."wayland_sys"."0.12.5".libc}" deps) ] else []));
    features = mkFeatures (features."wayland_sys"."0.12.5" or {});
  };
  features_.wayland_sys."0.12.5" = deps: f: updateFeatures f (rec {
    dlib = fold recursiveUpdate {} [
      { "${deps.wayland_sys."0.12.5".dlib}"."dlopen" =
        (f.dlib."${deps.wayland_sys."0.12.5".dlib}"."dlopen" or false) ||
        (wayland_sys."0.12.5"."dlopen" or false) ||
        (f."wayland_sys"."0.12.5"."dlopen" or false); }
      { "${deps.wayland_sys."0.12.5".dlib}".default = true; }
    ];
    lazy_static."${deps.wayland_sys."0.12.5".lazy_static}".default = true;
    libc."${deps.wayland_sys."0.12.5".libc}".default = true;
    wayland_sys = fold recursiveUpdate {} [
      { "0.12.5".default = (f.wayland_sys."0.12.5".default or true); }
      { "0.12.5".lazy_static =
        (f.wayland_sys."0.12.5".lazy_static or false) ||
        (f.wayland_sys."0.12.5".dlopen or false) ||
        (wayland_sys."0.12.5"."dlopen" or false); }
      { "0.12.5".libc =
        (f.wayland_sys."0.12.5".libc or false) ||
        (f.wayland_sys."0.12.5".server or false) ||
        (wayland_sys."0.12.5"."server" or false); }
    ];
  }) [
    (features_.dlib."${deps."wayland_sys"."0.12.5"."dlib"}" deps)
    (features_.lazy_static."${deps."wayland_sys"."0.12.5"."lazy_static"}" deps)
    (features_.libc."${deps."wayland_sys"."0.12.5"."libc"}" deps)
  ];


# end
# winapi-0.2.8

  crates.winapi."0.2.8" = deps: { features?(features_.winapi."0.2.8" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.2.8";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
  };
  features_.winapi."0.2.8" = deps: f: updateFeatures f (rec {
    winapi."0.2.8".default = (f.winapi."0.2.8".default or true);
  }) [];


# end
# winapi-0.3.6

  crates.winapi."0.3.6" = deps: { features?(features_.winapi."0.3.6" deps {}) }: buildRustCrate {
    crateName = "winapi";
    version = "0.3.6";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1d9jfp4cjd82sr1q4dgdlrkvm33zhhav9d7ihr0nivqbncr059m4";
    build = "build.rs";
    dependencies = (if kernel == "i686-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_i686_pc_windows_gnu"."${deps."winapi"."0.3.6"."winapi_i686_pc_windows_gnu"}" deps)
    ]) else [])
      ++ (if kernel == "x86_64-pc-windows-gnu" then mapFeatures features ([
      (crates."winapi_x86_64_pc_windows_gnu"."${deps."winapi"."0.3.6"."winapi_x86_64_pc_windows_gnu"}" deps)
    ]) else []);
    features = mkFeatures (features."winapi"."0.3.6" or {});
  };
  features_.winapi."0.3.6" = deps: f: updateFeatures f (rec {
    winapi."0.3.6".default = (f.winapi."0.3.6".default or true);
    winapi_i686_pc_windows_gnu."${deps.winapi."0.3.6".winapi_i686_pc_windows_gnu}".default = true;
    winapi_x86_64_pc_windows_gnu."${deps.winapi."0.3.6".winapi_x86_64_pc_windows_gnu}".default = true;
  }) [
    (features_.winapi_i686_pc_windows_gnu."${deps."winapi"."0.3.6"."winapi_i686_pc_windows_gnu"}" deps)
    (features_.winapi_x86_64_pc_windows_gnu."${deps."winapi"."0.3.6"."winapi_x86_64_pc_windows_gnu"}" deps)
  ];


# end
# winapi-build-0.1.1

  crates.winapi_build."0.1.1" = deps: { features?(features_.winapi_build."0.1.1" deps {}) }: buildRustCrate {
    crateName = "winapi-build";
    version = "0.1.1";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
    libName = "build";
  };
  features_.winapi_build."0.1.1" = deps: f: updateFeatures f (rec {
    winapi_build."0.1.1".default = (f.winapi_build."0.1.1".default or true);
  }) [];


# end
# winapi-i686-pc-windows-gnu-0.4.0

  crates.winapi_i686_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_i686_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-i686-pc-windows-gnu";
    version = "0.4.0";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "05ihkij18r4gamjpxj4gra24514can762imjzlmak5wlzidplzrp";
    build = "build.rs";
  };
  features_.winapi_i686_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_i686_pc_windows_gnu."0.4.0".default = (f.winapi_i686_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# winapi-x86_64-pc-windows-gnu-0.4.0

  crates.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: { features?(features_.winapi_x86_64_pc_windows_gnu."0.4.0" deps {}) }: buildRustCrate {
    crateName = "winapi-x86_64-pc-windows-gnu";
    version = "0.4.0";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "0n1ylmlsb8yg1v583i4xy0qmqg42275flvbc51hdqjjfjcl9vlbj";
    build = "build.rs";
  };
  features_.winapi_x86_64_pc_windows_gnu."0.4.0" = deps: f: updateFeatures f (rec {
    winapi_x86_64_pc_windows_gnu."0.4.0".default = (f.winapi_x86_64_pc_windows_gnu."0.4.0".default or true);
  }) [];


# end
# xcb-0.8.2

  crates.xcb."0.8.2" = deps: { features?(features_.xcb."0.8.2" deps {}) }: buildRustCrate {
    crateName = "xcb";
    version = "0.8.2";
    authors = [ "Remi Thebault <remi.thebault@gmail.com>" ];
    sha256 = "06l8jms57wvz01vx82a3cwak9b9qwdkadvpmkk1zimy2qg7i7dkl";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."xcb"."0.8.2"."libc"}" deps)
      (crates."log"."${deps."xcb"."0.8.2"."log"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."libc"."${deps."xcb"."0.8.2"."libc"}" deps)
    ]);
    features = mkFeatures (features."xcb"."0.8.2" or {});
  };
  features_.xcb."0.8.2" = deps: f: updateFeatures f (rec {
    libc."${deps.xcb."0.8.2".libc}".default = true;
    log."${deps.xcb."0.8.2".log}".default = true;
    xcb = fold recursiveUpdate {} [
      { "0.8.2".composite =
        (f.xcb."0.8.2".composite or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".damage =
        (f.xcb."0.8.2".damage or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".default = (f.xcb."0.8.2".default or true); }
      { "0.8.2".dpms =
        (f.xcb."0.8.2".dpms or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".dri2 =
        (f.xcb."0.8.2".dri2 or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".dri3 =
        (f.xcb."0.8.2".dri3 or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".glx =
        (f.xcb."0.8.2".glx or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".randr =
        (f.xcb."0.8.2".randr or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".record =
        (f.xcb."0.8.2".record or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".render =
        (f.xcb."0.8.2".render or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false) ||
        (f.xcb."0.8.2".present or false) ||
        (xcb."0.8.2"."present" or false) ||
        (f.xcb."0.8.2".randr or false) ||
        (xcb."0.8.2"."randr" or false) ||
        (f.xcb."0.8.2".xfixes or false) ||
        (xcb."0.8.2"."xfixes" or false); }
      { "0.8.2".res =
        (f.xcb."0.8.2".res or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".screensaver =
        (f.xcb."0.8.2".screensaver or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".shape =
        (f.xcb."0.8.2".shape or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false) ||
        (f.xcb."0.8.2".xfixes or false) ||
        (xcb."0.8.2"."xfixes" or false); }
      { "0.8.2".shm =
        (f.xcb."0.8.2".shm or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false) ||
        (f.xcb."0.8.2".xv or false) ||
        (xcb."0.8.2"."xv" or false); }
      { "0.8.2".sync =
        (f.xcb."0.8.2".sync or false) ||
        (f.xcb."0.8.2".present or false) ||
        (xcb."0.8.2"."present" or false); }
      { "0.8.2".thread =
        (f.xcb."0.8.2".thread or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xevie =
        (f.xcb."0.8.2".xevie or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xf86dri =
        (f.xcb."0.8.2".xf86dri or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xfixes =
        (f.xcb."0.8.2".xfixes or false) ||
        (f.xcb."0.8.2".composite or false) ||
        (xcb."0.8.2"."composite" or false) ||
        (f.xcb."0.8.2".damage or false) ||
        (xcb."0.8.2"."damage" or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false) ||
        (f.xcb."0.8.2".present or false) ||
        (xcb."0.8.2"."present" or false) ||
        (f.xcb."0.8.2".xinput or false) ||
        (xcb."0.8.2"."xinput" or false); }
      { "0.8.2".xinerama =
        (f.xcb."0.8.2".xinerama or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xkb =
        (f.xcb."0.8.2".xkb or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xlib_xcb =
        (f.xcb."0.8.2".xlib_xcb or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xprint =
        (f.xcb."0.8.2".xprint or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xselinux =
        (f.xcb."0.8.2".xselinux or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xtest =
        (f.xcb."0.8.2".xtest or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
      { "0.8.2".xv =
        (f.xcb."0.8.2".xv or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false) ||
        (f.xcb."0.8.2".xvmc or false) ||
        (xcb."0.8.2"."xvmc" or false); }
      { "0.8.2".xvmc =
        (f.xcb."0.8.2".xvmc or false) ||
        (f.xcb."0.8.2".debug_all or false) ||
        (xcb."0.8.2"."debug_all" or false); }
    ];
  }) [
    (features_.libc."${deps."xcb"."0.8.2"."libc"}" deps)
    (features_.log."${deps."xcb"."0.8.2"."log"}" deps)
    (features_.libc."${deps."xcb"."0.8.2"."libc"}" deps)
  ];


# end
# xml-rs-0.7.0

  crates.xml_rs."0.7.0" = deps: { features?(features_.xml_rs."0.7.0" deps {}) }: buildRustCrate {
    crateName = "xml-rs";
    version = "0.7.0";
    authors = [ "Vladimir Matveev <vladimir.matweev@gmail.com>" ];
    sha256 = "12rynhqjgkg2hzy9x1d1232p9d9jm40bc3by5yzjv8gx089mflyb";
    libPath = "src/lib.rs";
    libName = "xml";
    crateBin =
      [{  name = "xml-analyze";  path = "src/analyze.rs"; }];
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."xml_rs"."0.7.0"."bitflags"}" deps)
    ]);
  };
  features_.xml_rs."0.7.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.xml_rs."0.7.0".bitflags}".default = true;
    xml_rs."0.7.0".default = (f.xml_rs."0.7.0".default or true);
  }) [
    (features_.bitflags."${deps."xml_rs"."0.7.0"."bitflags"}" deps)
  ];


# end
}

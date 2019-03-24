{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {
# MacTypes-sys-2.1.0

  crates.MacTypes_sys."2.1.0" = deps: { features?(features_.MacTypes_sys."2.1.0" deps {}) }: buildRustCrate {
    crateName = "MacTypes-sys";
    version = "2.1.0";
    authors = [ "George Burton <burtonageo@gmail.com>" ];
    sha256 = "03d1dkb1978pk5qqa5yrp5dr6vbnicmvpyw40rv0b8rva1bqnip8";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."MacTypes_sys"."2.1.0"."libc"}" deps)
    ]);
    features = mkFeatures (features."MacTypes_sys"."2.1.0" or {});
  };
  features_.MacTypes_sys."2.1.0" = deps: f: updateFeatures f (rec {
    MacTypes_sys = fold recursiveUpdate {} [
      { "2.1.0".default = (f.MacTypes_sys."2.1.0".default or true); }
      { "2.1.0".use_std =
        (f.MacTypes_sys."2.1.0".use_std or false) ||
        (f.MacTypes_sys."2.1.0".default or false) ||
        (MacTypes_sys."2.1.0"."default" or false); }
    ];
    libc = fold recursiveUpdate {} [
      { "${deps.MacTypes_sys."2.1.0".libc}"."use_std" =
        (f.libc."${deps.MacTypes_sys."2.1.0".libc}"."use_std" or false) ||
        (MacTypes_sys."2.1.0"."use_std" or false) ||
        (f."MacTypes_sys"."2.1.0"."use_std" or false); }
      { "${deps.MacTypes_sys."2.1.0".libc}".default = (f.libc."${deps.MacTypes_sys."2.1.0".libc}".default or false); }
    ];
  }) [
    (features_.libc."${deps."MacTypes_sys"."2.1.0"."libc"}" deps)
  ];


# end
# adler32-1.0.3

  crates.adler32."1.0.3" = deps: { features?(features_.adler32."1.0.3" deps {}) }: buildRustCrate {
    crateName = "adler32";
    version = "1.0.3";
    authors = [ "Remi Rampin <remirampin@gmail.com>" ];
    sha256 = "1z3mvjgw02mbqk98kizzibrca01d5wfkpazsrp3vkkv3i56pn6fb";
  };
  features_.adler32."1.0.3" = deps: f: updateFeatures f (rec {
    adler32."1.0.3".default = (f.adler32."1.0.3".default or true);
  }) [];


# end
# aho-corasick-0.6.10

  crates.aho_corasick."0.6.10" = deps: { features?(features_.aho_corasick."0.6.10" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.10";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0bhasxfpmfmz1460chwsx59vdld05axvmk1nbp3sd48xav3d108p";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.6.10"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.6.10" = deps: f: updateFeatures f (rec {
    aho_corasick."0.6.10".default = (f.aho_corasick."0.6.10".default or true);
    memchr."${deps.aho_corasick."0.6.10".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.6.10"."memchr"}" deps)
  ];


# end
# aho-corasick-0.6.8

  crates.aho_corasick."0.6.8" = deps: { features?(features_.aho_corasick."0.6.8" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.8";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "04bz5m32ykyn946iwxgbrl8nwca7ssxsqma140hgmkchaay80nfr";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.6.8"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.6.8" = deps: f: updateFeatures f (rec {
    aho_corasick."0.6.8".default = (f.aho_corasick."0.6.8".default or true);
    memchr."${deps.aho_corasick."0.6.8".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.6.8"."memchr"}" deps)
  ];


# end
# ammonia-2.0.0

  crates.ammonia."2.0.0" = deps: { features?(features_.ammonia."2.0.0" deps {}) }: buildRustCrate {
    crateName = "ammonia";
    version = "2.0.0";
    authors = [ "Michael Howell <michael@notriddle.com>" ];
    sha256 = "1hbcqrwv7ccf9bfiidv3i58z1mfrf6qzh2c7fn1fhvvmfq8w492a";
    dependencies = mapFeatures features ([
      (crates."html5ever"."${deps."ammonia"."2.0.0"."html5ever"}" deps)
      (crates."lazy_static"."${deps."ammonia"."2.0.0"."lazy_static"}" deps)
      (crates."maplit"."${deps."ammonia"."2.0.0"."maplit"}" deps)
      (crates."matches"."${deps."ammonia"."2.0.0"."matches"}" deps)
      (crates."tendril"."${deps."ammonia"."2.0.0"."tendril"}" deps)
      (crates."url"."${deps."ammonia"."2.0.0"."url"}" deps)
    ]);
  };
  features_.ammonia."2.0.0" = deps: f: updateFeatures f (rec {
    ammonia."2.0.0".default = (f.ammonia."2.0.0".default or true);
    html5ever."${deps.ammonia."2.0.0".html5ever}".default = true;
    lazy_static."${deps.ammonia."2.0.0".lazy_static}".default = true;
    maplit."${deps.ammonia."2.0.0".maplit}".default = true;
    matches."${deps.ammonia."2.0.0".matches}".default = true;
    tendril."${deps.ammonia."2.0.0".tendril}".default = true;
    url."${deps.ammonia."2.0.0".url}".default = true;
  }) [
    (features_.html5ever."${deps."ammonia"."2.0.0"."html5ever"}" deps)
    (features_.lazy_static."${deps."ammonia"."2.0.0"."lazy_static"}" deps)
    (features_.maplit."${deps."ammonia"."2.0.0"."maplit"}" deps)
    (features_.matches."${deps."ammonia"."2.0.0"."matches"}" deps)
    (features_.tendril."${deps."ammonia"."2.0.0"."tendril"}" deps)
    (features_.url."${deps."ammonia"."2.0.0"."url"}" deps)
  ];


# end
# ansi_term-0.11.0

  crates.ansi_term."0.11.0" = deps: { features?(features_.ansi_term."0.11.0" deps {}) }: buildRustCrate {
    crateName = "ansi_term";
    version = "0.11.0";
    authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" "Josh Triplett <josh@joshtriplett.org>" ];
    sha256 = "08fk0p2xvkqpmz3zlrwnf6l8sj2vngw464rvzspzp31sbgxbwm4v";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."ansi_term"."0.11.0"."winapi"}" deps)
    ]) else []);
  };
  features_.ansi_term."0.11.0" = deps: f: updateFeatures f (rec {
    ansi_term."0.11.0".default = (f.ansi_term."0.11.0".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.ansi_term."0.11.0".winapi}"."consoleapi" = true; }
      { "${deps.ansi_term."0.11.0".winapi}"."errhandlingapi" = true; }
      { "${deps.ansi_term."0.11.0".winapi}"."processenv" = true; }
      { "${deps.ansi_term."0.11.0".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."ansi_term"."0.11.0"."winapi"}" deps)
  ];


# end
# antidote-1.0.0

  crates.antidote."1.0.0" = deps: { features?(features_.antidote."1.0.0" deps {}) }: buildRustCrate {
    crateName = "antidote";
    version = "1.0.0";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1x2wgaw603jcjwsfvc8s2rpaqjv0aqj8mvws2ahhkvfnwkdf7icw";
  };
  features_.antidote."1.0.0" = deps: f: updateFeatures f (rec {
    antidote."1.0.0".default = (f.antidote."1.0.0".default or true);
  }) [];


# end
# argon2rs-0.2.5

  crates.argon2rs."0.2.5" = deps: { features?(features_.argon2rs."0.2.5" deps {}) }: buildRustCrate {
    crateName = "argon2rs";
    version = "0.2.5";
    authors = [ "bryant <bryant@defrag.in>" ];
    sha256 = "1byl9b3wwyrarn8qack21v5fi2qsnn3y5clvikk2apskhmnih1rw";
    dependencies = mapFeatures features ([
      (crates."blake2_rfc"."${deps."argon2rs"."0.2.5"."blake2_rfc"}" deps)
      (crates."scoped_threadpool"."${deps."argon2rs"."0.2.5"."scoped_threadpool"}" deps)
    ]);
    features = mkFeatures (features."argon2rs"."0.2.5" or {});
  };
  features_.argon2rs."0.2.5" = deps: f: updateFeatures f (rec {
    argon2rs."0.2.5".default = (f.argon2rs."0.2.5".default or true);
    blake2_rfc = fold recursiveUpdate {} [
      { "${deps.argon2rs."0.2.5".blake2_rfc}"."simd_asm" =
        (f.blake2_rfc."${deps.argon2rs."0.2.5".blake2_rfc}"."simd_asm" or false) ||
        (argon2rs."0.2.5"."simd" or false) ||
        (f."argon2rs"."0.2.5"."simd" or false); }
      { "${deps.argon2rs."0.2.5".blake2_rfc}".default = true; }
    ];
    scoped_threadpool."${deps.argon2rs."0.2.5".scoped_threadpool}".default = true;
  }) [
    (features_.blake2_rfc."${deps."argon2rs"."0.2.5"."blake2_rfc"}" deps)
    (features_.scoped_threadpool."${deps."argon2rs"."0.2.5"."scoped_threadpool"}" deps)
  ];


# end
# arrayref-0.3.5

  crates.arrayref."0.3.5" = deps: { features?(features_.arrayref."0.3.5" deps {}) }: buildRustCrate {
    crateName = "arrayref";
    version = "0.3.5";
    authors = [ "David Roundy <roundyd@physics.oregonstate.edu>" ];
    sha256 = "00dfn9lbr4pc524imc25v3rbmswiqk3jldsgmx4rdngcpxb8ssjf";
  };
  features_.arrayref."0.3.5" = deps: f: updateFeatures f (rec {
    arrayref."0.3.5".default = (f.arrayref."0.3.5".default or true);
  }) [];


# end
# arrayvec-0.4.10

  crates.arrayvec."0.4.10" = deps: { features?(features_.arrayvec."0.4.10" deps {}) }: buildRustCrate {
    crateName = "arrayvec";
    version = "0.4.10";
    authors = [ "bluss" ];
    sha256 = "0qbh825i59w5wfdysqdkiwbwkrsy7lgbd4pwbyb8pxx8wc36iny8";
    dependencies = mapFeatures features ([
      (crates."nodrop"."${deps."arrayvec"."0.4.10"."nodrop"}" deps)
    ]);
    features = mkFeatures (features."arrayvec"."0.4.10" or {});
  };
  features_.arrayvec."0.4.10" = deps: f: updateFeatures f (rec {
    arrayvec = fold recursiveUpdate {} [
      { "0.4.10".default = (f.arrayvec."0.4.10".default or true); }
      { "0.4.10".serde =
        (f.arrayvec."0.4.10".serde or false) ||
        (f.arrayvec."0.4.10".serde-1 or false) ||
        (arrayvec."0.4.10"."serde-1" or false); }
      { "0.4.10".std =
        (f.arrayvec."0.4.10".std or false) ||
        (f.arrayvec."0.4.10".default or false) ||
        (arrayvec."0.4.10"."default" or false); }
    ];
    nodrop."${deps.arrayvec."0.4.10".nodrop}".default = (f.nodrop."${deps.arrayvec."0.4.10".nodrop}".default or false);
  }) [
    (features_.nodrop."${deps."arrayvec"."0.4.10"."nodrop"}" deps)
  ];


# end
# arrayvec-0.4.7

  crates.arrayvec."0.4.7" = deps: { features?(features_.arrayvec."0.4.7" deps {}) }: buildRustCrate {
    crateName = "arrayvec";
    version = "0.4.7";
    authors = [ "bluss" ];
    sha256 = "0fzgv7z1x1qnyd7j32vdcadk4k9wfx897y06mr3bw1yi52iqf4z4";
    dependencies = mapFeatures features ([
      (crates."nodrop"."${deps."arrayvec"."0.4.7"."nodrop"}" deps)
    ]);
    features = mkFeatures (features."arrayvec"."0.4.7" or {});
  };
  features_.arrayvec."0.4.7" = deps: f: updateFeatures f (rec {
    arrayvec = fold recursiveUpdate {} [
      { "0.4.7".default = (f.arrayvec."0.4.7".default or true); }
      { "0.4.7".serde =
        (f.arrayvec."0.4.7".serde or false) ||
        (f.arrayvec."0.4.7".serde-1 or false) ||
        (arrayvec."0.4.7"."serde-1" or false); }
      { "0.4.7".std =
        (f.arrayvec."0.4.7".std or false) ||
        (f.arrayvec."0.4.7".default or false) ||
        (arrayvec."0.4.7"."default" or false); }
    ];
    nodrop."${deps.arrayvec."0.4.7".nodrop}".default = (f.nodrop."${deps.arrayvec."0.4.7".nodrop}".default or false);
  }) [
    (features_.nodrop."${deps."arrayvec"."0.4.7"."nodrop"}" deps)
  ];


# end
# ascii-canvas-1.0.0

  crates.ascii_canvas."1.0.0" = deps: { features?(features_.ascii_canvas."1.0.0" deps {}) }: buildRustCrate {
    crateName = "ascii-canvas";
    version = "1.0.0";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" ];
    sha256 = "0i87cilgivyk2f75hj16mgfl5ndm58sccfjmiics9r62a6q01wlg";
    dependencies = mapFeatures features ([
      (crates."term"."${deps."ascii_canvas"."1.0.0"."term"}" deps)
    ]);
  };
  features_.ascii_canvas."1.0.0" = deps: f: updateFeatures f (rec {
    ascii_canvas."1.0.0".default = (f.ascii_canvas."1.0.0".default or true);
    term."${deps.ascii_canvas."1.0.0".term}".default = true;
  }) [
    (features_.term."${deps."ascii_canvas"."1.0.0"."term"}" deps)
  ];


# end
# atty-0.2.11

  crates.atty."0.2.11" = deps: { features?(features_.atty."0.2.11" deps {}) }: buildRustCrate {
    crateName = "atty";
    version = "0.2.11";
    authors = [ "softprops <d.tangren@gmail.com>" ];
    sha256 = "0by1bj2km9jxi4i4g76zzi76fc2rcm9934jpnyrqd95zw344pb20";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."termion"."${deps."atty"."0.2.11"."termion"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."atty"."0.2.11"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."atty"."0.2.11"."winapi"}" deps)
    ]) else []);
  };
  features_.atty."0.2.11" = deps: f: updateFeatures f (rec {
    atty."0.2.11".default = (f.atty."0.2.11".default or true);
    libc."${deps.atty."0.2.11".libc}".default = (f.libc."${deps.atty."0.2.11".libc}".default or false);
    termion."${deps.atty."0.2.11".termion}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.atty."0.2.11".winapi}"."consoleapi" = true; }
      { "${deps.atty."0.2.11".winapi}"."minwinbase" = true; }
      { "${deps.atty."0.2.11".winapi}"."minwindef" = true; }
      { "${deps.atty."0.2.11".winapi}"."processenv" = true; }
      { "${deps.atty."0.2.11".winapi}"."winbase" = true; }
      { "${deps.atty."0.2.11".winapi}".default = true; }
    ];
  }) [
    (features_.termion."${deps."atty"."0.2.11"."termion"}" deps)
    (features_.libc."${deps."atty"."0.2.11"."libc"}" deps)
    (features_.winapi."${deps."atty"."0.2.11"."winapi"}" deps)
  ];


# end
# autocfg-0.1.2

  crates.autocfg."0.1.2" = deps: { features?(features_.autocfg."0.1.2" deps {}) }: buildRustCrate {
    crateName = "autocfg";
    version = "0.1.2";
    authors = [ "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "0dv81dwnp1al3j4ffz007yrjv4w1c7hw09gnf0xs3icxiw6qqfs3";
  };
  features_.autocfg."0.1.2" = deps: f: updateFeatures f (rec {
    autocfg."0.1.2".default = (f.autocfg."0.1.2".default or true);
  }) [];


# end
# backtrace-0.3.14

  crates.backtrace."0.3.14" = deps: { features?(features_.backtrace."0.3.14" deps {}) }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.14";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "0sp0ib8r5w9sv1g2nkm9yclp16j46yjglw0yhkmh0snf355633mz";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."backtrace"."0.3.14"."cfg_if"}" deps)
      (crates."rustc_demangle"."${deps."backtrace"."0.3.14"."rustc_demangle"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.14".backtrace-sys or false then [ (crates.backtrace_sys."${deps."backtrace"."0.3.14".backtrace_sys}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") || abi == "sgx" then mapFeatures features ([
      (crates."libc"."${deps."backtrace"."0.3.14"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."backtrace"."0.3.14"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."backtrace"."0.3.14"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."backtrace"."0.3.14" or {});
  };
  features_.backtrace."0.3.14" = deps: f: updateFeatures f (rec {
    autocfg."${deps.backtrace."0.3.14".autocfg}".default = true;
    backtrace = fold recursiveUpdate {} [
      { "0.3.14".addr2line =
        (f.backtrace."0.3.14".addr2line or false) ||
        (f.backtrace."0.3.14".gimli-symbolize or false) ||
        (backtrace."0.3.14"."gimli-symbolize" or false); }
      { "0.3.14".backtrace-sys =
        (f.backtrace."0.3.14".backtrace-sys or false) ||
        (f.backtrace."0.3.14".libbacktrace or false) ||
        (backtrace."0.3.14"."libbacktrace" or false); }
      { "0.3.14".coresymbolication =
        (f.backtrace."0.3.14".coresymbolication or false) ||
        (f.backtrace."0.3.14".default or false) ||
        (backtrace."0.3.14"."default" or false); }
      { "0.3.14".dbghelp =
        (f.backtrace."0.3.14".dbghelp or false) ||
        (f.backtrace."0.3.14".default or false) ||
        (backtrace."0.3.14"."default" or false); }
      { "0.3.14".default = (f.backtrace."0.3.14".default or true); }
      { "0.3.14".dladdr =
        (f.backtrace."0.3.14".dladdr or false) ||
        (f.backtrace."0.3.14".default or false) ||
        (backtrace."0.3.14"."default" or false); }
      { "0.3.14".findshlibs =
        (f.backtrace."0.3.14".findshlibs or false) ||
        (f.backtrace."0.3.14".gimli-symbolize or false) ||
        (backtrace."0.3.14"."gimli-symbolize" or false); }
      { "0.3.14".gimli =
        (f.backtrace."0.3.14".gimli or false) ||
        (f.backtrace."0.3.14".gimli-symbolize or false) ||
        (backtrace."0.3.14"."gimli-symbolize" or false); }
      { "0.3.14".libbacktrace =
        (f.backtrace."0.3.14".libbacktrace or false) ||
        (f.backtrace."0.3.14".default or false) ||
        (backtrace."0.3.14"."default" or false); }
      { "0.3.14".libunwind =
        (f.backtrace."0.3.14".libunwind or false) ||
        (f.backtrace."0.3.14".default or false) ||
        (backtrace."0.3.14"."default" or false); }
      { "0.3.14".memmap =
        (f.backtrace."0.3.14".memmap or false) ||
        (f.backtrace."0.3.14".gimli-symbolize or false) ||
        (backtrace."0.3.14"."gimli-symbolize" or false); }
      { "0.3.14".object =
        (f.backtrace."0.3.14".object or false) ||
        (f.backtrace."0.3.14".gimli-symbolize or false) ||
        (backtrace."0.3.14"."gimli-symbolize" or false); }
      { "0.3.14".rustc-serialize =
        (f.backtrace."0.3.14".rustc-serialize or false) ||
        (f.backtrace."0.3.14".serialize-rustc or false) ||
        (backtrace."0.3.14"."serialize-rustc" or false); }
      { "0.3.14".serde =
        (f.backtrace."0.3.14".serde or false) ||
        (f.backtrace."0.3.14".serialize-serde or false) ||
        (backtrace."0.3.14"."serialize-serde" or false); }
      { "0.3.14".serde_derive =
        (f.backtrace."0.3.14".serde_derive or false) ||
        (f.backtrace."0.3.14".serialize-serde or false) ||
        (backtrace."0.3.14"."serialize-serde" or false); }
      { "0.3.14".std =
        (f.backtrace."0.3.14".std or false) ||
        (f.backtrace."0.3.14".default or false) ||
        (backtrace."0.3.14"."default" or false) ||
        (f.backtrace."0.3.14".libbacktrace or false) ||
        (backtrace."0.3.14"."libbacktrace" or false); }
    ];
    backtrace_sys."${deps.backtrace."0.3.14".backtrace_sys}".default = true;
    cfg_if."${deps.backtrace."0.3.14".cfg_if}".default = true;
    libc."${deps.backtrace."0.3.14".libc}".default = (f.libc."${deps.backtrace."0.3.14".libc}".default or false);
    rustc_demangle."${deps.backtrace."0.3.14".rustc_demangle}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.14".winapi}"."dbghelp" = true; }
      { "${deps.backtrace."0.3.14".winapi}"."minwindef" = true; }
      { "${deps.backtrace."0.3.14".winapi}"."processthreadsapi" = true; }
      { "${deps.backtrace."0.3.14".winapi}"."winnt" = true; }
      { "${deps.backtrace."0.3.14".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."backtrace"."0.3.14"."cfg_if"}" deps)
    (features_.rustc_demangle."${deps."backtrace"."0.3.14"."rustc_demangle"}" deps)
    (features_.autocfg."${deps."backtrace"."0.3.14"."autocfg"}" deps)
    (features_.backtrace_sys."${deps."backtrace"."0.3.14"."backtrace_sys"}" deps)
    (features_.libc."${deps."backtrace"."0.3.14"."libc"}" deps)
    (features_.winapi."${deps."backtrace"."0.3.14"."winapi"}" deps)
  ];


# end
# backtrace-0.3.9

  crates.backtrace."0.3.9" = deps: { features?(features_.backtrace."0.3.9" deps {}) }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.9";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "137pjkcn89b7fqk78w65ggj92pynmf1hkr1sjz53aga4b50lkmwm";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."backtrace"."0.3.9"."cfg_if"}" deps)
      (crates."rustc_demangle"."${deps."backtrace"."0.3.9"."rustc_demangle"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.9".backtrace-sys or false then [ (crates.backtrace_sys."${deps."backtrace"."0.3.9".backtrace_sys}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."backtrace"."0.3.9"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.9".winapi or false then [ (crates.winapi."${deps."backtrace"."0.3.9".winapi}" deps) ] else [])) else []);
    features = mkFeatures (features."backtrace"."0.3.9" or {});
  };
  features_.backtrace."0.3.9" = deps: f: updateFeatures f (rec {
    backtrace = fold recursiveUpdate {} [
      { "0.3.9".addr2line =
        (f.backtrace."0.3.9".addr2line or false) ||
        (f.backtrace."0.3.9".gimli-symbolize or false) ||
        (backtrace."0.3.9"."gimli-symbolize" or false); }
      { "0.3.9".backtrace-sys =
        (f.backtrace."0.3.9".backtrace-sys or false) ||
        (f.backtrace."0.3.9".libbacktrace or false) ||
        (backtrace."0.3.9"."libbacktrace" or false); }
      { "0.3.9".coresymbolication =
        (f.backtrace."0.3.9".coresymbolication or false) ||
        (f.backtrace."0.3.9".default or false) ||
        (backtrace."0.3.9"."default" or false); }
      { "0.3.9".dbghelp =
        (f.backtrace."0.3.9".dbghelp or false) ||
        (f.backtrace."0.3.9".default or false) ||
        (backtrace."0.3.9"."default" or false); }
      { "0.3.9".default = (f.backtrace."0.3.9".default or true); }
      { "0.3.9".dladdr =
        (f.backtrace."0.3.9".dladdr or false) ||
        (f.backtrace."0.3.9".default or false) ||
        (backtrace."0.3.9"."default" or false); }
      { "0.3.9".findshlibs =
        (f.backtrace."0.3.9".findshlibs or false) ||
        (f.backtrace."0.3.9".gimli-symbolize or false) ||
        (backtrace."0.3.9"."gimli-symbolize" or false); }
      { "0.3.9".gimli =
        (f.backtrace."0.3.9".gimli or false) ||
        (f.backtrace."0.3.9".gimli-symbolize or false) ||
        (backtrace."0.3.9"."gimli-symbolize" or false); }
      { "0.3.9".libbacktrace =
        (f.backtrace."0.3.9".libbacktrace or false) ||
        (f.backtrace."0.3.9".default or false) ||
        (backtrace."0.3.9"."default" or false); }
      { "0.3.9".libunwind =
        (f.backtrace."0.3.9".libunwind or false) ||
        (f.backtrace."0.3.9".default or false) ||
        (backtrace."0.3.9"."default" or false); }
      { "0.3.9".memmap =
        (f.backtrace."0.3.9".memmap or false) ||
        (f.backtrace."0.3.9".gimli-symbolize or false) ||
        (backtrace."0.3.9"."gimli-symbolize" or false); }
      { "0.3.9".object =
        (f.backtrace."0.3.9".object or false) ||
        (f.backtrace."0.3.9".gimli-symbolize or false) ||
        (backtrace."0.3.9"."gimli-symbolize" or false); }
      { "0.3.9".rustc-serialize =
        (f.backtrace."0.3.9".rustc-serialize or false) ||
        (f.backtrace."0.3.9".serialize-rustc or false) ||
        (backtrace."0.3.9"."serialize-rustc" or false); }
      { "0.3.9".serde =
        (f.backtrace."0.3.9".serde or false) ||
        (f.backtrace."0.3.9".serialize-serde or false) ||
        (backtrace."0.3.9"."serialize-serde" or false); }
      { "0.3.9".serde_derive =
        (f.backtrace."0.3.9".serde_derive or false) ||
        (f.backtrace."0.3.9".serialize-serde or false) ||
        (backtrace."0.3.9"."serialize-serde" or false); }
      { "0.3.9".winapi =
        (f.backtrace."0.3.9".winapi or false) ||
        (f.backtrace."0.3.9".dbghelp or false) ||
        (backtrace."0.3.9"."dbghelp" or false); }
    ];
    backtrace_sys."${deps.backtrace."0.3.9".backtrace_sys}".default = true;
    cfg_if."${deps.backtrace."0.3.9".cfg_if}".default = true;
    libc."${deps.backtrace."0.3.9".libc}".default = true;
    rustc_demangle."${deps.backtrace."0.3.9".rustc_demangle}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.9".winapi}"."dbghelp" = true; }
      { "${deps.backtrace."0.3.9".winapi}"."minwindef" = true; }
      { "${deps.backtrace."0.3.9".winapi}"."processthreadsapi" = true; }
      { "${deps.backtrace."0.3.9".winapi}"."std" = true; }
      { "${deps.backtrace."0.3.9".winapi}"."winnt" = true; }
      { "${deps.backtrace."0.3.9".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."backtrace"."0.3.9"."cfg_if"}" deps)
    (features_.rustc_demangle."${deps."backtrace"."0.3.9"."rustc_demangle"}" deps)
    (features_.backtrace_sys."${deps."backtrace"."0.3.9"."backtrace_sys"}" deps)
    (features_.libc."${deps."backtrace"."0.3.9"."libc"}" deps)
    (features_.winapi."${deps."backtrace"."0.3.9"."winapi"}" deps)
  ];


# end
# backtrace-sys-0.1.24

  crates.backtrace_sys."0.1.24" = deps: { features?(features_.backtrace_sys."0.1.24" deps {}) }: buildRustCrate {
    crateName = "backtrace-sys";
    version = "0.1.24";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "15d6jlknykiijcin3vqbx33760w24ss5qw3l1xd3hms5k4vc8305";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."backtrace_sys"."0.1.24"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."backtrace_sys"."0.1.24"."cc"}" deps)
    ]);
  };
  features_.backtrace_sys."0.1.24" = deps: f: updateFeatures f (rec {
    backtrace_sys."0.1.24".default = (f.backtrace_sys."0.1.24".default or true);
    cc."${deps.backtrace_sys."0.1.24".cc}".default = true;
    libc."${deps.backtrace_sys."0.1.24".libc}".default = true;
  }) [
    (features_.libc."${deps."backtrace_sys"."0.1.24"."libc"}" deps)
    (features_.cc."${deps."backtrace_sys"."0.1.24"."cc"}" deps)
  ];


# end
# backtrace-sys-0.1.28

  crates.backtrace_sys."0.1.28" = deps: { features?(features_.backtrace_sys."0.1.28" deps {}) }: buildRustCrate {
    crateName = "backtrace-sys";
    version = "0.1.28";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1bbw8chs0wskxwzz7f3yy7mjqhyqj8lslq8pcjw1rbd2g23c34xl";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."backtrace_sys"."0.1.28"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."backtrace_sys"."0.1.28"."cc"}" deps)
    ]);
  };
  features_.backtrace_sys."0.1.28" = deps: f: updateFeatures f (rec {
    backtrace_sys."0.1.28".default = (f.backtrace_sys."0.1.28".default or true);
    cc."${deps.backtrace_sys."0.1.28".cc}".default = true;
    libc."${deps.backtrace_sys."0.1.28".libc}".default = (f.libc."${deps.backtrace_sys."0.1.28".libc}".default or false);
  }) [
    (features_.libc."${deps."backtrace_sys"."0.1.28"."libc"}" deps)
    (features_.cc."${deps."backtrace_sys"."0.1.28"."cc"}" deps)
  ];


# end
# base64-0.10.1

  crates.base64."0.10.1" = deps: { features?(features_.base64."0.10.1" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.10.1";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "1zz3jq619hahla1f70ra38818b5n8cp4iilij81i90jq6z7hlfhg";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.10.1"."byteorder"}" deps)
    ]);
  };
  features_.base64."0.10.1" = deps: f: updateFeatures f (rec {
    base64."0.10.1".default = (f.base64."0.10.1".default or true);
    byteorder."${deps.base64."0.10.1".byteorder}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.10.1"."byteorder"}" deps)
  ];


# end
# base64-0.6.0

  crates.base64."0.6.0" = deps: { features?(features_.base64."0.6.0" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.6.0";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "0ql1rmczbnww3iszc0pfc6mqa47ravpsdf525vp6s8r32nyzspl5";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.6.0"."byteorder"}" deps)
      (crates."safemem"."${deps."base64"."0.6.0"."safemem"}" deps)
    ]);
  };
  features_.base64."0.6.0" = deps: f: updateFeatures f (rec {
    base64."0.6.0".default = (f.base64."0.6.0".default or true);
    byteorder."${deps.base64."0.6.0".byteorder}".default = true;
    safemem."${deps.base64."0.6.0".safemem}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.6.0"."byteorder"}" deps)
    (features_.safemem."${deps."base64"."0.6.0"."safemem"}" deps)
  ];


# end
# base64-0.9.3

  crates.base64."0.9.3" = deps: { features?(features_.base64."0.9.3" deps {}) }: buildRustCrate {
    crateName = "base64";
    version = "0.9.3";
    authors = [ "Alice Maz <alice@alicemaz.com>" "Marshall Pierce <marshall@mpierce.org>" ];
    sha256 = "11hhz8ln4zbpn2h2gm9fbbb9j254wrd4fpmddlyah2rrnqsmmqkd";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."base64"."0.9.3"."byteorder"}" deps)
      (crates."safemem"."${deps."base64"."0.9.3"."safemem"}" deps)
    ]);
  };
  features_.base64."0.9.3" = deps: f: updateFeatures f (rec {
    base64."0.9.3".default = (f.base64."0.9.3".default or true);
    byteorder."${deps.base64."0.9.3".byteorder}".default = true;
    safemem."${deps.base64."0.9.3".safemem}".default = true;
  }) [
    (features_.byteorder."${deps."base64"."0.9.3"."byteorder"}" deps)
    (features_.safemem."${deps."base64"."0.9.3"."safemem"}" deps)
  ];


# end
# bincode-1.1.2

  crates.bincode."1.1.2" = deps: { features?(features_.bincode."1.1.2" deps {}) }: buildRustCrate {
    crateName = "bincode";
    version = "1.1.2";
    authors = [ "Ty Overby <ty@pre-alpha.com>" "Francesco Mazzoli <f@mazzo.li>" "David Tolnay <dtolnay@gmail.com>" "Daniel Griffen" ];
    sha256 = "1mh5yraq4rlljz3sh1rqqw1dxr7srhwp77bi3jbn873y41zpvzvf";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."bincode"."1.1.2"."byteorder"}" deps)
      (crates."serde"."${deps."bincode"."1.1.2"."serde"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."bincode"."1.1.2"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."bincode"."1.1.2" or {});
  };
  features_.bincode."1.1.2" = deps: f: updateFeatures f (rec {
    autocfg."${deps.bincode."1.1.2".autocfg}".default = true;
    bincode."1.1.2".default = (f.bincode."1.1.2".default or true);
    byteorder."${deps.bincode."1.1.2".byteorder}".default = true;
    serde."${deps.bincode."1.1.2".serde}".default = true;
  }) [
    (features_.byteorder."${deps."bincode"."1.1.2"."byteorder"}" deps)
    (features_.serde."${deps."bincode"."1.1.2"."serde"}" deps)
    (features_.autocfg."${deps."bincode"."1.1.2"."autocfg"}" deps)
  ];


# end
# bindgen-0.43.2

  crates.bindgen."0.43.2" = deps: { features?(features_.bindgen."0.43.2" deps {}) }: buildRustCrate {
    crateName = "bindgen";
    version = "0.43.2";
    authors = [ "Jyun-Yan You <jyyou.tw@gmail.com>" "Emilio Cobos Álvarez <emilio@crisal.io>" "Nick Fitzgerald <fitzgen@gmail.com>" "The Servo project developers" ];
    sha256 = "0s3rdl5gdhvz01cp04y0mwzprxw40x05gmpgrlr0qv4y2969p86f";
    libPath = "src/lib.rs";
    crateBin =
      [{  name = "bindgen";  path = "src/main.rs"; }];
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."bindgen"."0.43.2"."bitflags"}" deps)
      (crates."cexpr"."${deps."bindgen"."0.43.2"."cexpr"}" deps)
      (crates."cfg_if"."${deps."bindgen"."0.43.2"."cfg_if"}" deps)
      (crates."clang_sys"."${deps."bindgen"."0.43.2"."clang_sys"}" deps)
      (crates."clap"."${deps."bindgen"."0.43.2"."clap"}" deps)
      (crates."lazy_static"."${deps."bindgen"."0.43.2"."lazy_static"}" deps)
      (crates."peeking_take_while"."${deps."bindgen"."0.43.2"."peeking_take_while"}" deps)
      (crates."proc_macro2"."${deps."bindgen"."0.43.2"."proc_macro2"}" deps)
      (crates."quote"."${deps."bindgen"."0.43.2"."quote"}" deps)
      (crates."regex"."${deps."bindgen"."0.43.2"."regex"}" deps)
      (crates."which"."${deps."bindgen"."0.43.2"."which"}" deps)
    ]
      ++ (if features.bindgen."0.43.2".env_logger or false then [ (crates.env_logger."${deps."bindgen"."0.43.2".env_logger}" deps) ] else [])
      ++ (if features.bindgen."0.43.2".log or false then [ (crates.log."${deps."bindgen"."0.43.2".log}" deps) ] else []));
    features = mkFeatures (features."bindgen"."0.43.2" or {});
  };
  features_.bindgen."0.43.2" = deps: f: updateFeatures f (rec {
    bindgen = fold recursiveUpdate {} [
      { "0.43.2".default = (f.bindgen."0.43.2".default or true); }
      { "0.43.2".env_logger =
        (f.bindgen."0.43.2".env_logger or false) ||
        (f.bindgen."0.43.2".logging or false) ||
        (bindgen."0.43.2"."logging" or false); }
      { "0.43.2".log =
        (f.bindgen."0.43.2".log or false) ||
        (f.bindgen."0.43.2".logging or false) ||
        (bindgen."0.43.2"."logging" or false); }
      { "0.43.2".logging =
        (f.bindgen."0.43.2".logging or false) ||
        (f.bindgen."0.43.2".default or false) ||
        (bindgen."0.43.2"."default" or false); }
    ];
    bitflags."${deps.bindgen."0.43.2".bitflags}".default = true;
    cexpr."${deps.bindgen."0.43.2".cexpr}".default = true;
    cfg_if."${deps.bindgen."0.43.2".cfg_if}".default = true;
    clang_sys = fold recursiveUpdate {} [
      { "${deps.bindgen."0.43.2".clang_sys}"."clang_6_0" = true; }
      { "${deps.bindgen."0.43.2".clang_sys}"."runtime" = true; }
      { "${deps.bindgen."0.43.2".clang_sys}".default = true; }
    ];
    clap."${deps.bindgen."0.43.2".clap}".default = true;
    env_logger."${deps.bindgen."0.43.2".env_logger}".default = true;
    lazy_static."${deps.bindgen."0.43.2".lazy_static}".default = true;
    log."${deps.bindgen."0.43.2".log}".default = true;
    peeking_take_while."${deps.bindgen."0.43.2".peeking_take_while}".default = true;
    proc_macro2."${deps.bindgen."0.43.2".proc_macro2}".default = (f.proc_macro2."${deps.bindgen."0.43.2".proc_macro2}".default or false);
    quote."${deps.bindgen."0.43.2".quote}".default = (f.quote."${deps.bindgen."0.43.2".quote}".default or false);
    regex."${deps.bindgen."0.43.2".regex}".default = true;
    which."${deps.bindgen."0.43.2".which}".default = true;
  }) [
    (features_.bitflags."${deps."bindgen"."0.43.2"."bitflags"}" deps)
    (features_.cexpr."${deps."bindgen"."0.43.2"."cexpr"}" deps)
    (features_.cfg_if."${deps."bindgen"."0.43.2"."cfg_if"}" deps)
    (features_.clang_sys."${deps."bindgen"."0.43.2"."clang_sys"}" deps)
    (features_.clap."${deps."bindgen"."0.43.2"."clap"}" deps)
    (features_.env_logger."${deps."bindgen"."0.43.2"."env_logger"}" deps)
    (features_.lazy_static."${deps."bindgen"."0.43.2"."lazy_static"}" deps)
    (features_.log."${deps."bindgen"."0.43.2"."log"}" deps)
    (features_.peeking_take_while."${deps."bindgen"."0.43.2"."peeking_take_while"}" deps)
    (features_.proc_macro2."${deps."bindgen"."0.43.2"."proc_macro2"}" deps)
    (features_.quote."${deps."bindgen"."0.43.2"."quote"}" deps)
    (features_.regex."${deps."bindgen"."0.43.2"."regex"}" deps)
    (features_.which."${deps."bindgen"."0.43.2"."which"}" deps)
  ];


# end
# bit-set-0.5.0

  crates.bit_set."0.5.0" = deps: { features?(features_.bit_set."0.5.0" deps {}) }: buildRustCrate {
    crateName = "bit-set";
    version = "0.5.0";
    authors = [ "Alexis Beingessner <a.beingessner@gmail.com>" ];
    sha256 = "1hwar0maz5pb1ggifrqi79hm14ffc75qiac0xy5lvf3vp6y8din1";
    dependencies = mapFeatures features ([
      (crates."bit_vec"."${deps."bit_set"."0.5.0"."bit_vec"}" deps)
    ]);
    features = mkFeatures (features."bit_set"."0.5.0" or {});
  };
  features_.bit_set."0.5.0" = deps: f: updateFeatures f (rec {
    bit_set = fold recursiveUpdate {} [
      { "0.5.0".default = (f.bit_set."0.5.0".default or true); }
      { "0.5.0".std =
        (f.bit_set."0.5.0".std or false) ||
        (f.bit_set."0.5.0".default or false) ||
        (bit_set."0.5.0"."default" or false); }
    ];
    bit_vec = fold recursiveUpdate {} [
      { "${deps.bit_set."0.5.0".bit_vec}"."nightly" =
        (f.bit_vec."${deps.bit_set."0.5.0".bit_vec}"."nightly" or false) ||
        (bit_set."0.5.0"."nightly" or false) ||
        (f."bit_set"."0.5.0"."nightly" or false); }
      { "${deps.bit_set."0.5.0".bit_vec}"."std" =
        (f.bit_vec."${deps.bit_set."0.5.0".bit_vec}"."std" or false) ||
        (bit_set."0.5.0"."std" or false) ||
        (f."bit_set"."0.5.0"."std" or false); }
      { "${deps.bit_set."0.5.0".bit_vec}".default = (f.bit_vec."${deps.bit_set."0.5.0".bit_vec}".default or false); }
    ];
  }) [
    (features_.bit_vec."${deps."bit_set"."0.5.0"."bit_vec"}" deps)
  ];


# end
# bit-vec-0.4.4

  crates.bit_vec."0.4.4" = deps: { features?(features_.bit_vec."0.4.4" deps {}) }: buildRustCrate {
    crateName = "bit-vec";
    version = "0.4.4";
    authors = [ "Alexis Beingessner <a.beingessner@gmail.com>" ];
    sha256 = "06czykmn001z6c3a4nsrpc3lrj63ga0kzp7kgva9r9wylhkkqpq9";
    features = mkFeatures (features."bit_vec"."0.4.4" or {});
  };
  features_.bit_vec."0.4.4" = deps: f: updateFeatures f (rec {
    bit_vec."0.4.4".default = (f.bit_vec."0.4.4".default or true);
  }) [];


# end
# bit-vec-0.5.0

  crates.bit_vec."0.5.0" = deps: { features?(features_.bit_vec."0.5.0" deps {}) }: buildRustCrate {
    crateName = "bit-vec";
    version = "0.5.0";
    authors = [ "Alexis Beingessner <a.beingessner@gmail.com>" ];
    sha256 = "05q0cdrw5b7mjnac3a76f896wr1vm0g041zm9q3fx3n92nr8xvh6";
    features = mkFeatures (features."bit_vec"."0.5.0" or {});
  };
  features_.bit_vec."0.5.0" = deps: f: updateFeatures f (rec {
    bit_vec = fold recursiveUpdate {} [
      { "0.5.0".default = (f.bit_vec."0.5.0".default or true); }
      { "0.5.0".std =
        (f.bit_vec."0.5.0".std or false) ||
        (f.bit_vec."0.5.0".default or false) ||
        (bit_vec."0.5.0"."default" or false); }
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
# blake2-rfc-0.2.18

  crates.blake2_rfc."0.2.18" = deps: { features?(features_.blake2_rfc."0.2.18" deps {}) }: buildRustCrate {
    crateName = "blake2-rfc";
    version = "0.2.18";
    authors = [ "Cesar Eduardo Barros <cesarb@cesarb.eti.br>" ];
    sha256 = "0pyqrik4471ljk16prs0iwb2sam39z0z6axyyjxlqxdmf4wprf0l";
    dependencies = mapFeatures features ([
      (crates."arrayvec"."${deps."blake2_rfc"."0.2.18"."arrayvec"}" deps)
      (crates."constant_time_eq"."${deps."blake2_rfc"."0.2.18"."constant_time_eq"}" deps)
    ]);
    features = mkFeatures (features."blake2_rfc"."0.2.18" or {});
  };
  features_.blake2_rfc."0.2.18" = deps: f: updateFeatures f (rec {
    arrayvec."${deps.blake2_rfc."0.2.18".arrayvec}".default = (f.arrayvec."${deps.blake2_rfc."0.2.18".arrayvec}".default or false);
    blake2_rfc = fold recursiveUpdate {} [
      { "0.2.18".default = (f.blake2_rfc."0.2.18".default or true); }
      { "0.2.18".simd =
        (f.blake2_rfc."0.2.18".simd or false) ||
        (f.blake2_rfc."0.2.18".simd_opt or false) ||
        (blake2_rfc."0.2.18"."simd_opt" or false); }
      { "0.2.18".simd_opt =
        (f.blake2_rfc."0.2.18".simd_opt or false) ||
        (f.blake2_rfc."0.2.18".simd_asm or false) ||
        (blake2_rfc."0.2.18"."simd_asm" or false); }
      { "0.2.18".std =
        (f.blake2_rfc."0.2.18".std or false) ||
        (f.blake2_rfc."0.2.18".default or false) ||
        (blake2_rfc."0.2.18"."default" or false); }
    ];
    constant_time_eq."${deps.blake2_rfc."0.2.18".constant_time_eq}".default = true;
  }) [
    (features_.arrayvec."${deps."blake2_rfc"."0.2.18"."arrayvec"}" deps)
    (features_.constant_time_eq."${deps."blake2_rfc"."0.2.18"."constant_time_eq"}" deps)
  ];


# end
# block-buffer-0.3.3

  crates.block_buffer."0.3.3" = deps: { features?(features_.block_buffer."0.3.3" deps {}) }: buildRustCrate {
    crateName = "block-buffer";
    version = "0.3.3";
    authors = [ "RustCrypto Developers" ];
    sha256 = "0ka14535hlndyig1dqxqvdv60mgmnnhfi6x87npha3x3yg5sx201";
    dependencies = mapFeatures features ([
      (crates."arrayref"."${deps."block_buffer"."0.3.3"."arrayref"}" deps)
      (crates."byte_tools"."${deps."block_buffer"."0.3.3"."byte_tools"}" deps)
    ]);
  };
  features_.block_buffer."0.3.3" = deps: f: updateFeatures f (rec {
    arrayref."${deps.block_buffer."0.3.3".arrayref}".default = true;
    block_buffer."0.3.3".default = (f.block_buffer."0.3.3".default or true);
    byte_tools."${deps.block_buffer."0.3.3".byte_tools}".default = true;
  }) [
    (features_.arrayref."${deps."block_buffer"."0.3.3"."arrayref"}" deps)
    (features_.byte_tools."${deps."block_buffer"."0.3.3"."byte_tools"}" deps)
  ];


# end
# block-buffer-0.7.0

  crates.block_buffer."0.7.0" = deps: { features?(features_.block_buffer."0.7.0" deps {}) }: buildRustCrate {
    crateName = "block-buffer";
    version = "0.7.0";
    authors = [ "RustCrypto Developers" ];
    sha256 = "06m0nbam681zjqsy4j2k3jnvjpwhhgrg2rplzwcnkglbjqf125f9";
    dependencies = mapFeatures features ([
      (crates."block_padding"."${deps."block_buffer"."0.7.0"."block_padding"}" deps)
      (crates."byte_tools"."${deps."block_buffer"."0.7.0"."byte_tools"}" deps)
      (crates."byteorder"."${deps."block_buffer"."0.7.0"."byteorder"}" deps)
      (crates."generic_array"."${deps."block_buffer"."0.7.0"."generic_array"}" deps)
    ]);
  };
  features_.block_buffer."0.7.0" = deps: f: updateFeatures f (rec {
    block_buffer."0.7.0".default = (f.block_buffer."0.7.0".default or true);
    block_padding."${deps.block_buffer."0.7.0".block_padding}".default = true;
    byte_tools."${deps.block_buffer."0.7.0".byte_tools}".default = true;
    byteorder."${deps.block_buffer."0.7.0".byteorder}".default = (f.byteorder."${deps.block_buffer."0.7.0".byteorder}".default or false);
    generic_array."${deps.block_buffer."0.7.0".generic_array}".default = true;
  }) [
    (features_.block_padding."${deps."block_buffer"."0.7.0"."block_padding"}" deps)
    (features_.byte_tools."${deps."block_buffer"."0.7.0"."byte_tools"}" deps)
    (features_.byteorder."${deps."block_buffer"."0.7.0"."byteorder"}" deps)
    (features_.generic_array."${deps."block_buffer"."0.7.0"."generic_array"}" deps)
  ];


# end
# block-padding-0.1.3

  crates.block_padding."0.1.3" = deps: { features?(features_.block_padding."0.1.3" deps {}) }: buildRustCrate {
    crateName = "block-padding";
    version = "0.1.3";
    authors = [ "RustCrypto Developers" ];
    sha256 = "0215kqxwgs5bzrpykg86wz3ix77lnci666b724dxb0iln91ch2ag";
    dependencies = mapFeatures features ([
      (crates."byte_tools"."${deps."block_padding"."0.1.3"."byte_tools"}" deps)
    ]);
  };
  features_.block_padding."0.1.3" = deps: f: updateFeatures f (rec {
    block_padding."0.1.3".default = (f.block_padding."0.1.3".default or true);
    byte_tools."${deps.block_padding."0.1.3".byte_tools}".default = true;
  }) [
    (features_.byte_tools."${deps."block_padding"."0.1.3"."byte_tools"}" deps)
  ];


# end
# bs58-0.2.2

  crates.bs58."0.2.2" = deps: { features?(features_.bs58."0.2.2" deps {}) }: buildRustCrate {
    crateName = "bs58";
    version = "0.2.2";
    authors = [ "Wim Looman <wim@nemo157.com>" ];
    sha256 = "19ycymardcrgf14b2b1466xviczw88yimp7lmc8ik9ykyvn9q53h";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."bs58"."0.2.2" or {});
  };
  features_.bs58."0.2.2" = deps: f: updateFeatures f (rec {
    bs58 = fold recursiveUpdate {} [
      { "0.2.2".default = (f.bs58."0.2.2".default or true); }
      { "0.2.2".sha2 =
        (f.bs58."0.2.2".sha2 or false) ||
        (f.bs58."0.2.2".check or false) ||
        (bs58."0.2.2"."check" or false); }
    ];
  }) [];


# end
# buffered-reader-0.3.0

  crates.buffered_reader."0.3.0" = deps: { features?(features_.buffered_reader."0.3.0" deps {}) }: buildRustCrate {
    crateName = "buffered-reader";
    version = "0.3.0";
    authors = [ "Justus Winter <justus@sequoia-pgp.org>" "Kai Michaelis <kai@sequoia-pgp.org>" "Neal H. Walfield <neal@sequoia-pgp.org>" ];
    sha256 = "0rqcgyd3j66w3961s6m0z0nv3hb8ih8f26yb53vb970svkawxp5m";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."buffered_reader"."0.3.0"."libc"}" deps)
    ]
      ++ (if features.buffered_reader."0.3.0".bzip2 or false then [ (crates.bzip2."${deps."buffered_reader"."0.3.0".bzip2}" deps) ] else [])
      ++ (if features.buffered_reader."0.3.0".flate2 or false then [ (crates.flate2."${deps."buffered_reader"."0.3.0".flate2}" deps) ] else []));
    features = mkFeatures (features."buffered_reader"."0.3.0" or {});
  };
  features_.buffered_reader."0.3.0" = deps: f: updateFeatures f (rec {
    buffered_reader = fold recursiveUpdate {} [
      { "0.3.0".bzip2 =
        (f.buffered_reader."0.3.0".bzip2 or false) ||
        (f.buffered_reader."0.3.0".compression-bzip2 or false) ||
        (buffered_reader."0.3.0"."compression-bzip2" or false); }
      { "0.3.0".compression =
        (f.buffered_reader."0.3.0".compression or false) ||
        (f.buffered_reader."0.3.0".default or false) ||
        (buffered_reader."0.3.0"."default" or false); }
      { "0.3.0".compression-bzip2 =
        (f.buffered_reader."0.3.0".compression-bzip2 or false) ||
        (f.buffered_reader."0.3.0".compression or false) ||
        (buffered_reader."0.3.0"."compression" or false); }
      { "0.3.0".compression-deflate =
        (f.buffered_reader."0.3.0".compression-deflate or false) ||
        (f.buffered_reader."0.3.0".compression or false) ||
        (buffered_reader."0.3.0"."compression" or false); }
      { "0.3.0".default = (f.buffered_reader."0.3.0".default or true); }
      { "0.3.0".flate2 =
        (f.buffered_reader."0.3.0".flate2 or false) ||
        (f.buffered_reader."0.3.0".compression-deflate or false) ||
        (buffered_reader."0.3.0"."compression-deflate" or false); }
    ];
    bzip2."${deps.buffered_reader."0.3.0".bzip2}".default = true;
    flate2."${deps.buffered_reader."0.3.0".flate2}".default = true;
    libc."${deps.buffered_reader."0.3.0".libc}".default = true;
  }) [
    (features_.bzip2."${deps."buffered_reader"."0.3.0"."bzip2"}" deps)
    (features_.flate2."${deps."buffered_reader"."0.3.0"."flate2"}" deps)
    (features_.libc."${deps."buffered_reader"."0.3.0"."libc"}" deps)
  ];


# end
# build_const-0.2.1

  crates.build_const."0.2.1" = deps: { features?(features_.build_const."0.2.1" deps {}) }: buildRustCrate {
    crateName = "build_const";
    version = "0.2.1";
    authors = [ "Garrett Berg <vitiral@gmail.com>" ];
    sha256 = "15249xzi3qlm72p4glxgavwyq70fx2sp4df6ii0sdlrixrrp77pl";
    features = mkFeatures (features."build_const"."0.2.1" or {});
  };
  features_.build_const."0.2.1" = deps: f: updateFeatures f (rec {
    build_const = fold recursiveUpdate {} [
      { "0.2.1".default = (f.build_const."0.2.1".default or true); }
      { "0.2.1".std =
        (f.build_const."0.2.1".std or false) ||
        (f.build_const."0.2.1".default or false) ||
        (build_const."0.2.1"."default" or false); }
    ];
  }) [];


# end
# byte-tools-0.2.0

  crates.byte_tools."0.2.0" = deps: { features?(features_.byte_tools."0.2.0" deps {}) }: buildRustCrate {
    crateName = "byte-tools";
    version = "0.2.0";
    authors = [ "The Rust-Crypto Project Developers" ];
    sha256 = "15cm6sxkk2ikrz8sxld3hv9g419j4kjzwdjp4fn53gjq07awq6il";
  };
  features_.byte_tools."0.2.0" = deps: f: updateFeatures f (rec {
    byte_tools."0.2.0".default = (f.byte_tools."0.2.0".default or true);
  }) [];


# end
# byte-tools-0.3.1

  crates.byte_tools."0.3.1" = deps: { features?(features_.byte_tools."0.3.1" deps {}) }: buildRustCrate {
    crateName = "byte-tools";
    version = "0.3.1";
    authors = [ "RustCrypto Developers" ];
    sha256 = "01hfp59bxq74glhfmhvm9wma2migq2kfmvcvqq5pssk5k52g8ja0";
  };
  features_.byte_tools."0.3.1" = deps: f: updateFeatures f (rec {
    byte_tools."0.3.1".default = (f.byte_tools."0.3.1".default or true);
  }) [];


# end
# byteorder-1.3.1

  crates.byteorder."1.3.1" = deps: { features?(features_.byteorder."1.3.1" deps {}) }: buildRustCrate {
    crateName = "byteorder";
    version = "1.3.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1dd46l7fvmxfq90kh6ip1ghsxzzcdybac8f0mh2jivsdv9vy8k4w";
    build = "build.rs";
    features = mkFeatures (features."byteorder"."1.3.1" or {});
  };
  features_.byteorder."1.3.1" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "1.3.1".default = (f.byteorder."1.3.1".default or true); }
      { "1.3.1".std =
        (f.byteorder."1.3.1".std or false) ||
        (f.byteorder."1.3.1".default or false) ||
        (byteorder."1.3.1"."default" or false); }
    ];
  }) [];


# end
# bytes-0.4.12

  crates.bytes."0.4.12" = deps: { features?(features_.bytes."0.4.12" deps {}) }: buildRustCrate {
    crateName = "bytes";
    version = "0.4.12";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0cw577vll9qp0h3l1sy24anr5mcnd5j26q9q7nw4f0mddssvfphf";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."bytes"."0.4.12"."byteorder"}" deps)
      (crates."iovec"."${deps."bytes"."0.4.12"."iovec"}" deps)
    ]);
    features = mkFeatures (features."bytes"."0.4.12" or {});
  };
  features_.bytes."0.4.12" = deps: f: updateFeatures f (rec {
    byteorder = fold recursiveUpdate {} [
      { "${deps.bytes."0.4.12".byteorder}"."i128" =
        (f.byteorder."${deps.bytes."0.4.12".byteorder}"."i128" or false) ||
        (bytes."0.4.12"."i128" or false) ||
        (f."bytes"."0.4.12"."i128" or false); }
      { "${deps.bytes."0.4.12".byteorder}".default = true; }
    ];
    bytes."0.4.12".default = (f.bytes."0.4.12".default or true);
    iovec."${deps.bytes."0.4.12".iovec}".default = true;
  }) [
    (features_.byteorder."${deps."bytes"."0.4.12"."byteorder"}" deps)
    (features_.iovec."${deps."bytes"."0.4.12"."iovec"}" deps)
  ];


# end
# bzip2-0.3.3

  crates.bzip2."0.3.3" = deps: { features?(features_.bzip2."0.3.3" deps {}) }: buildRustCrate {
    crateName = "bzip2";
    version = "0.3.3";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1jfrxq7ddqy89cdlgl0m00ljvifp8j9njhqjim1xpq3xy8gichh5";
    dependencies = mapFeatures features ([
      (crates."bzip2_sys"."${deps."bzip2"."0.3.3"."bzip2_sys"}" deps)
      (crates."libc"."${deps."bzip2"."0.3.3"."libc"}" deps)
    ]);
    features = mkFeatures (features."bzip2"."0.3.3" or {});
  };
  features_.bzip2."0.3.3" = deps: f: updateFeatures f (rec {
    bzip2 = fold recursiveUpdate {} [
      { "0.3.3".default = (f.bzip2."0.3.3".default or true); }
      { "0.3.3".futures =
        (f.bzip2."0.3.3".futures or false) ||
        (f.bzip2."0.3.3".tokio or false) ||
        (bzip2."0.3.3"."tokio" or false); }
      { "0.3.3".tokio-io =
        (f.bzip2."0.3.3".tokio-io or false) ||
        (f.bzip2."0.3.3".tokio or false) ||
        (bzip2."0.3.3"."tokio" or false); }
    ];
    bzip2_sys."${deps.bzip2."0.3.3".bzip2_sys}".default = true;
    libc."${deps.bzip2."0.3.3".libc}".default = true;
  }) [
    (features_.bzip2_sys."${deps."bzip2"."0.3.3"."bzip2_sys"}" deps)
    (features_.libc."${deps."bzip2"."0.3.3"."libc"}" deps)
  ];


# end
# bzip2-sys-0.1.7

  crates.bzip2_sys."0.1.7" = deps: { features?(features_.bzip2_sys."0.1.7" deps {}) }: buildRustCrate {
    crateName = "bzip2-sys";
    version = "0.1.7";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1wflg3zpnldpnxhfv57sbfl6h67wqq4r3f7idgcs4f6d4h09dfdb";
    libPath = "lib.rs";
    libName = "bzip2_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."bzip2_sys"."0.1.7"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."bzip2_sys"."0.1.7"."cc"}" deps)
    ]);
  };
  features_.bzip2_sys."0.1.7" = deps: f: updateFeatures f (rec {
    bzip2_sys."0.1.7".default = (f.bzip2_sys."0.1.7".default or true);
    cc."${deps.bzip2_sys."0.1.7".cc}".default = true;
    libc."${deps.bzip2_sys."0.1.7".libc}".default = true;
  }) [
    (features_.libc."${deps."bzip2_sys"."0.1.7"."libc"}" deps)
    (features_.cc."${deps."bzip2_sys"."0.1.7"."cc"}" deps)
  ];


# end
# carnix-0.9.1

  crates.carnix."0.9.1" = deps: { features?(features_.carnix."0.9.1" deps {}) }: buildRustCrate {
    crateName = "carnix";
    version = "0.9.1";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    sha256 = "0dn292d4mjlxif0kclrljzff8rm35cd9d92vycjbzklyhz5d62wi";
    crateBin =
      [{  name = "cargo-generate-nixfile";  path = "src/cargo-generate-nixfile.rs"; }] ++
      [{  name = "carnix";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."carnix"."0.9.1"."clap"}" deps)
      (crates."dirs"."${deps."carnix"."0.9.1"."dirs"}" deps)
      (crates."env_logger"."${deps."carnix"."0.9.1"."env_logger"}" deps)
      (crates."error_chain"."${deps."carnix"."0.9.1"."error_chain"}" deps)
      (crates."itertools"."${deps."carnix"."0.9.1"."itertools"}" deps)
      (crates."log"."${deps."carnix"."0.9.1"."log"}" deps)
      (crates."nom"."${deps."carnix"."0.9.1"."nom"}" deps)
      (crates."regex"."${deps."carnix"."0.9.1"."regex"}" deps)
      (crates."serde"."${deps."carnix"."0.9.1"."serde"}" deps)
      (crates."serde_derive"."${deps."carnix"."0.9.1"."serde_derive"}" deps)
      (crates."serde_json"."${deps."carnix"."0.9.1"."serde_json"}" deps)
      (crates."tempdir"."${deps."carnix"."0.9.1"."tempdir"}" deps)
      (crates."toml"."${deps."carnix"."0.9.1"."toml"}" deps)
    ]);
  };
  features_.carnix."0.9.1" = deps: f: updateFeatures f (rec {
    carnix."0.9.1".default = (f.carnix."0.9.1".default or true);
    clap."${deps.carnix."0.9.1".clap}".default = true;
    dirs."${deps.carnix."0.9.1".dirs}".default = true;
    env_logger."${deps.carnix."0.9.1".env_logger}".default = true;
    error_chain."${deps.carnix."0.9.1".error_chain}".default = true;
    itertools."${deps.carnix."0.9.1".itertools}".default = true;
    log."${deps.carnix."0.9.1".log}".default = true;
    nom."${deps.carnix."0.9.1".nom}".default = true;
    regex."${deps.carnix."0.9.1".regex}".default = true;
    serde."${deps.carnix."0.9.1".serde}".default = true;
    serde_derive."${deps.carnix."0.9.1".serde_derive}".default = true;
    serde_json."${deps.carnix."0.9.1".serde_json}".default = true;
    tempdir."${deps.carnix."0.9.1".tempdir}".default = true;
    toml."${deps.carnix."0.9.1".toml}".default = true;
  }) [
    (features_.clap."${deps."carnix"."0.9.1"."clap"}" deps)
    (features_.dirs."${deps."carnix"."0.9.1"."dirs"}" deps)
    (features_.env_logger."${deps."carnix"."0.9.1"."env_logger"}" deps)
    (features_.error_chain."${deps."carnix"."0.9.1"."error_chain"}" deps)
    (features_.itertools."${deps."carnix"."0.9.1"."itertools"}" deps)
    (features_.log."${deps."carnix"."0.9.1"."log"}" deps)
    (features_.nom."${deps."carnix"."0.9.1"."nom"}" deps)
    (features_.regex."${deps."carnix"."0.9.1"."regex"}" deps)
    (features_.serde."${deps."carnix"."0.9.1"."serde"}" deps)
    (features_.serde_derive."${deps."carnix"."0.9.1"."serde_derive"}" deps)
    (features_.serde_json."${deps."carnix"."0.9.1"."serde_json"}" deps)
    (features_.tempdir."${deps."carnix"."0.9.1"."tempdir"}" deps)
    (features_.toml."${deps."carnix"."0.9.1"."toml"}" deps)
  ];


# end
# carnix-0.9.2

  crates.carnix."0.9.2" = deps: { features?(features_.carnix."0.9.2" deps {}) }: buildRustCrate {
    crateName = "carnix";
    version = "0.9.2";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    sha256 = "1r668rjqcwsxjpz2hrr7j3k099c1xsb8vfq1w7y1ps9hap9af42z";
    crateBin =
      [{  name = "cargo-generate-nixfile";  path = "src/cargo-generate-nixfile.rs"; }] ++
      [{  name = "carnix";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."carnix"."0.9.2"."clap"}" deps)
      (crates."dirs"."${deps."carnix"."0.9.2"."dirs"}" deps)
      (crates."env_logger"."${deps."carnix"."0.9.2"."env_logger"}" deps)
      (crates."error_chain"."${deps."carnix"."0.9.2"."error_chain"}" deps)
      (crates."itertools"."${deps."carnix"."0.9.2"."itertools"}" deps)
      (crates."log"."${deps."carnix"."0.9.2"."log"}" deps)
      (crates."nom"."${deps."carnix"."0.9.2"."nom"}" deps)
      (crates."regex"."${deps."carnix"."0.9.2"."regex"}" deps)
      (crates."serde"."${deps."carnix"."0.9.2"."serde"}" deps)
      (crates."serde_derive"."${deps."carnix"."0.9.2"."serde_derive"}" deps)
      (crates."serde_json"."${deps."carnix"."0.9.2"."serde_json"}" deps)
      (crates."tempdir"."${deps."carnix"."0.9.2"."tempdir"}" deps)
      (crates."toml"."${deps."carnix"."0.9.2"."toml"}" deps)
    ]);
  };
  features_.carnix."0.9.2" = deps: f: updateFeatures f (rec {
    carnix."0.9.2".default = (f.carnix."0.9.2".default or true);
    clap."${deps.carnix."0.9.2".clap}".default = true;
    dirs."${deps.carnix."0.9.2".dirs}".default = true;
    env_logger."${deps.carnix."0.9.2".env_logger}".default = true;
    error_chain."${deps.carnix."0.9.2".error_chain}".default = true;
    itertools."${deps.carnix."0.9.2".itertools}".default = true;
    log."${deps.carnix."0.9.2".log}".default = true;
    nom."${deps.carnix."0.9.2".nom}".default = true;
    regex."${deps.carnix."0.9.2".regex}".default = true;
    serde."${deps.carnix."0.9.2".serde}".default = true;
    serde_derive."${deps.carnix."0.9.2".serde_derive}".default = true;
    serde_json."${deps.carnix."0.9.2".serde_json}".default = true;
    tempdir."${deps.carnix."0.9.2".tempdir}".default = true;
    toml."${deps.carnix."0.9.2".toml}".default = true;
  }) [
    (features_.clap."${deps."carnix"."0.9.2"."clap"}" deps)
    (features_.dirs."${deps."carnix"."0.9.2"."dirs"}" deps)
    (features_.env_logger."${deps."carnix"."0.9.2"."env_logger"}" deps)
    (features_.error_chain."${deps."carnix"."0.9.2"."error_chain"}" deps)
    (features_.itertools."${deps."carnix"."0.9.2"."itertools"}" deps)
    (features_.log."${deps."carnix"."0.9.2"."log"}" deps)
    (features_.nom."${deps."carnix"."0.9.2"."nom"}" deps)
    (features_.regex."${deps."carnix"."0.9.2"."regex"}" deps)
    (features_.serde."${deps."carnix"."0.9.2"."serde"}" deps)
    (features_.serde_derive."${deps."carnix"."0.9.2"."serde_derive"}" deps)
    (features_.serde_json."${deps."carnix"."0.9.2"."serde_json"}" deps)
    (features_.tempdir."${deps."carnix"."0.9.2"."tempdir"}" deps)
    (features_.toml."${deps."carnix"."0.9.2"."toml"}" deps)
  ];


# end
# carnix-0.9.8

  crates.carnix."0.9.8" = deps: { features?(features_.carnix."0.9.8" deps {}) }: buildRustCrate {
    crateName = "carnix";
    version = "0.9.8";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    sha256 = "0c2k98qjm1yyx5wl0wqs0rrjczp6h62ri1x8a99442clxsyvp4n9";
    crateBin =
      [{  name = "cargo-generate-nixfile";  path = "src/cargo-generate-nixfile.rs"; }] ++
      [{  name = "carnix";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."clap"."${deps."carnix"."0.9.8"."clap"}" deps)
      (crates."dirs"."${deps."carnix"."0.9.8"."dirs"}" deps)
      (crates."env_logger"."${deps."carnix"."0.9.8"."env_logger"}" deps)
      (crates."error_chain"."${deps."carnix"."0.9.8"."error_chain"}" deps)
      (crates."itertools"."${deps."carnix"."0.9.8"."itertools"}" deps)
      (crates."log"."${deps."carnix"."0.9.8"."log"}" deps)
      (crates."nom"."${deps."carnix"."0.9.8"."nom"}" deps)
      (crates."regex"."${deps."carnix"."0.9.8"."regex"}" deps)
      (crates."serde"."${deps."carnix"."0.9.8"."serde"}" deps)
      (crates."serde_derive"."${deps."carnix"."0.9.8"."serde_derive"}" deps)
      (crates."serde_json"."${deps."carnix"."0.9.8"."serde_json"}" deps)
      (crates."tempdir"."${deps."carnix"."0.9.8"."tempdir"}" deps)
      (crates."toml"."${deps."carnix"."0.9.8"."toml"}" deps)
      (crates."url"."${deps."carnix"."0.9.8"."url"}" deps)
    ]);
  };
  features_.carnix."0.9.8" = deps: f: updateFeatures f (rec {
    carnix."0.9.8".default = (f.carnix."0.9.8".default or true);
    clap."${deps.carnix."0.9.8".clap}".default = true;
    dirs."${deps.carnix."0.9.8".dirs}".default = true;
    env_logger."${deps.carnix."0.9.8".env_logger}".default = true;
    error_chain."${deps.carnix."0.9.8".error_chain}".default = true;
    itertools."${deps.carnix."0.9.8".itertools}".default = true;
    log."${deps.carnix."0.9.8".log}".default = true;
    nom."${deps.carnix."0.9.8".nom}".default = true;
    regex."${deps.carnix."0.9.8".regex}".default = true;
    serde."${deps.carnix."0.9.8".serde}".default = true;
    serde_derive."${deps.carnix."0.9.8".serde_derive}".default = true;
    serde_json."${deps.carnix."0.9.8".serde_json}".default = true;
    tempdir."${deps.carnix."0.9.8".tempdir}".default = true;
    toml."${deps.carnix."0.9.8".toml}".default = true;
    url."${deps.carnix."0.9.8".url}".default = true;
  }) [
    (features_.clap."${deps."carnix"."0.9.8"."clap"}" deps)
    (features_.dirs."${deps."carnix"."0.9.8"."dirs"}" deps)
    (features_.env_logger."${deps."carnix"."0.9.8"."env_logger"}" deps)
    (features_.error_chain."${deps."carnix"."0.9.8"."error_chain"}" deps)
    (features_.itertools."${deps."carnix"."0.9.8"."itertools"}" deps)
    (features_.log."${deps."carnix"."0.9.8"."log"}" deps)
    (features_.nom."${deps."carnix"."0.9.8"."nom"}" deps)
    (features_.regex."${deps."carnix"."0.9.8"."regex"}" deps)
    (features_.serde."${deps."carnix"."0.9.8"."serde"}" deps)
    (features_.serde_derive."${deps."carnix"."0.9.8"."serde_derive"}" deps)
    (features_.serde_json."${deps."carnix"."0.9.8"."serde_json"}" deps)
    (features_.tempdir."${deps."carnix"."0.9.8"."tempdir"}" deps)
    (features_.toml."${deps."carnix"."0.9.8"."toml"}" deps)
    (features_.url."${deps."carnix"."0.9.8"."url"}" deps)
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
# cc-1.0.30

  crates.cc."1.0.30" = deps: { features?(features_.cc."1.0.30" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.30";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1rb8n4ncdkgm3agsa7s7383yzvgxajly0274z99asfbj3jyblfw4";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.30" or {});
  };
  features_.cc."1.0.30" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.30".default = (f.cc."1.0.30".default or true); }
      { "1.0.30".rayon =
        (f.cc."1.0.30".rayon or false) ||
        (f.cc."1.0.30".parallel or false) ||
        (cc."1.0.30"."parallel" or false); }
    ];
  }) [];


# end
# cexpr-0.3.4

  crates.cexpr."0.3.4" = deps: { features?(features_.cexpr."0.3.4" deps {}) }: buildRustCrate {
    crateName = "cexpr";
    version = "0.3.4";
    authors = [ "Jethro Beekman <jethro@jbeekman.nl>" ];
    sha256 = "14lm5niwjrn68yk8h1jc4i39w0dfnxabpr4px1sjahrqpjsm7xam";
    dependencies = mapFeatures features ([
      (crates."nom"."${deps."cexpr"."0.3.4"."nom"}" deps)
    ]);
  };
  features_.cexpr."0.3.4" = deps: f: updateFeatures f (rec {
    cexpr."0.3.4".default = (f.cexpr."0.3.4".default or true);
    nom = fold recursiveUpdate {} [
      { "${deps.cexpr."0.3.4".nom}"."verbose-errors" = true; }
      { "${deps.cexpr."0.3.4".nom}".default = true; }
    ];
  }) [
    (features_.nom."${deps."cexpr"."0.3.4"."nom"}" deps)
  ];


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
# cfg-if-0.1.7

  crates.cfg_if."0.1.7" = deps: { features?(features_.cfg_if."0.1.7" deps {}) }: buildRustCrate {
    crateName = "cfg-if";
    version = "0.1.7";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "13gvcx1dxjq4mpmpj26hpg3yc97qffkx2zi58ykr1dwr8q2biiig";
  };
  features_.cfg_if."0.1.7" = deps: f: updateFeatures f (rec {
    cfg_if."0.1.7".default = (f.cfg_if."0.1.7".default or true);
  }) [];


# end
# chrono-0.4.6

  crates.chrono."0.4.6" = deps: { features?(features_.chrono."0.4.6" deps {}) }: buildRustCrate {
    crateName = "chrono";
    version = "0.4.6";
    authors = [ "Kang Seonghoon <public+rust@mearie.org>" "Brandon W Maister <quodlibetor@gmail.com>" ];
    sha256 = "0cxgqgf4lknsii1k806dpmzapi2zccjpa350ns5wpb568mij096x";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."chrono"."0.4.6"."num_integer"}" deps)
      (crates."num_traits"."${deps."chrono"."0.4.6"."num_traits"}" deps)
    ]
      ++ (if features.chrono."0.4.6".serde or false then [ (crates.serde."${deps."chrono"."0.4.6".serde}" deps) ] else [])
      ++ (if features.chrono."0.4.6".time or false then [ (crates.time."${deps."chrono"."0.4.6".time}" deps) ] else []));
    features = mkFeatures (features."chrono"."0.4.6" or {});
  };
  features_.chrono."0.4.6" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "0.4.6".clock =
        (f.chrono."0.4.6".clock or false) ||
        (f.chrono."0.4.6".default or false) ||
        (chrono."0.4.6"."default" or false); }
      { "0.4.6".default = (f.chrono."0.4.6".default or true); }
      { "0.4.6".time =
        (f.chrono."0.4.6".time or false) ||
        (f.chrono."0.4.6".clock or false) ||
        (chrono."0.4.6"."clock" or false); }
    ];
    num_integer."${deps.chrono."0.4.6".num_integer}".default = (f.num_integer."${deps.chrono."0.4.6".num_integer}".default or false);
    num_traits."${deps.chrono."0.4.6".num_traits}".default = (f.num_traits."${deps.chrono."0.4.6".num_traits}".default or false);
    serde."${deps.chrono."0.4.6".serde}".default = true;
    time."${deps.chrono."0.4.6".time}".default = true;
  }) [
    (features_.num_integer."${deps."chrono"."0.4.6"."num_integer"}" deps)
    (features_.num_traits."${deps."chrono"."0.4.6"."num_traits"}" deps)
    (features_.serde."${deps."chrono"."0.4.6"."serde"}" deps)
    (features_.time."${deps."chrono"."0.4.6"."time"}" deps)
  ];


# end
# clang-sys-0.26.4

  crates.clang_sys."0.26.4" = deps: { features?(features_.clang_sys."0.26.4" deps {}) }: buildRustCrate {
    crateName = "clang-sys";
    version = "0.26.4";
    authors = [ "Kyle Mayes <kyle@mayeses.com>" ];
    sha256 = "097hhblr4yhkj22i5zjc635mmqp3vfz1jbrsv4nc061ws1nz4brx";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."glob"."${deps."clang_sys"."0.26.4"."glob"}" deps)
      (crates."libc"."${deps."clang_sys"."0.26.4"."libc"}" deps)
    ]
      ++ (if features.clang_sys."0.26.4".libloading or false then [ (crates.libloading."${deps."clang_sys"."0.26.4".libloading}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."glob"."${deps."clang_sys"."0.26.4"."glob"}" deps)
    ]);
    features = mkFeatures (features."clang_sys"."0.26.4" or {});
  };
  features_.clang_sys."0.26.4" = deps: f: updateFeatures f (rec {
    clang_sys = fold recursiveUpdate {} [
      { "0.26.4".default = (f.clang_sys."0.26.4".default or true); }
      { "0.26.4".gte_clang_3_6 =
        (f.clang_sys."0.26.4".gte_clang_3_6 or false) ||
        (f.clang_sys."0.26.4".clang_3_6 or false) ||
        (clang_sys."0.26.4"."clang_3_6" or false) ||
        (f.clang_sys."0.26.4".clang_3_7 or false) ||
        (clang_sys."0.26.4"."clang_3_7" or false) ||
        (f.clang_sys."0.26.4".clang_3_8 or false) ||
        (clang_sys."0.26.4"."clang_3_8" or false) ||
        (f.clang_sys."0.26.4".clang_3_9 or false) ||
        (clang_sys."0.26.4"."clang_3_9" or false) ||
        (f.clang_sys."0.26.4".clang_4_0 or false) ||
        (clang_sys."0.26.4"."clang_4_0" or false) ||
        (f.clang_sys."0.26.4".clang_5_0 or false) ||
        (clang_sys."0.26.4"."clang_5_0" or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_3_7 =
        (f.clang_sys."0.26.4".gte_clang_3_7 or false) ||
        (f.clang_sys."0.26.4".clang_3_7 or false) ||
        (clang_sys."0.26.4"."clang_3_7" or false) ||
        (f.clang_sys."0.26.4".clang_3_8 or false) ||
        (clang_sys."0.26.4"."clang_3_8" or false) ||
        (f.clang_sys."0.26.4".clang_3_9 or false) ||
        (clang_sys."0.26.4"."clang_3_9" or false) ||
        (f.clang_sys."0.26.4".clang_4_0 or false) ||
        (clang_sys."0.26.4"."clang_4_0" or false) ||
        (f.clang_sys."0.26.4".clang_5_0 or false) ||
        (clang_sys."0.26.4"."clang_5_0" or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_3_8 =
        (f.clang_sys."0.26.4".gte_clang_3_8 or false) ||
        (f.clang_sys."0.26.4".clang_3_8 or false) ||
        (clang_sys."0.26.4"."clang_3_8" or false) ||
        (f.clang_sys."0.26.4".clang_3_9 or false) ||
        (clang_sys."0.26.4"."clang_3_9" or false) ||
        (f.clang_sys."0.26.4".clang_4_0 or false) ||
        (clang_sys."0.26.4"."clang_4_0" or false) ||
        (f.clang_sys."0.26.4".clang_5_0 or false) ||
        (clang_sys."0.26.4"."clang_5_0" or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_3_9 =
        (f.clang_sys."0.26.4".gte_clang_3_9 or false) ||
        (f.clang_sys."0.26.4".clang_3_9 or false) ||
        (clang_sys."0.26.4"."clang_3_9" or false) ||
        (f.clang_sys."0.26.4".clang_4_0 or false) ||
        (clang_sys."0.26.4"."clang_4_0" or false) ||
        (f.clang_sys."0.26.4".clang_5_0 or false) ||
        (clang_sys."0.26.4"."clang_5_0" or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_4_0 =
        (f.clang_sys."0.26.4".gte_clang_4_0 or false) ||
        (f.clang_sys."0.26.4".clang_4_0 or false) ||
        (clang_sys."0.26.4"."clang_4_0" or false) ||
        (f.clang_sys."0.26.4".clang_5_0 or false) ||
        (clang_sys."0.26.4"."clang_5_0" or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_5_0 =
        (f.clang_sys."0.26.4".gte_clang_5_0 or false) ||
        (f.clang_sys."0.26.4".clang_5_0 or false) ||
        (clang_sys."0.26.4"."clang_5_0" or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_6_0 =
        (f.clang_sys."0.26.4".gte_clang_6_0 or false) ||
        (f.clang_sys."0.26.4".clang_6_0 or false) ||
        (clang_sys."0.26.4"."clang_6_0" or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".gte_clang_7_0 =
        (f.clang_sys."0.26.4".gte_clang_7_0 or false) ||
        (f.clang_sys."0.26.4".clang_7_0 or false) ||
        (clang_sys."0.26.4"."clang_7_0" or false); }
      { "0.26.4".libloading =
        (f.clang_sys."0.26.4".libloading or false) ||
        (f.clang_sys."0.26.4".runtime or false) ||
        (clang_sys."0.26.4"."runtime" or false); }
    ];
    glob."${deps.clang_sys."0.26.4".glob}".default = true;
    libc."${deps.clang_sys."0.26.4".libc}".default = (f.libc."${deps.clang_sys."0.26.4".libc}".default or false);
    libloading."${deps.clang_sys."0.26.4".libloading}".default = true;
  }) [
    (features_.glob."${deps."clang_sys"."0.26.4"."glob"}" deps)
    (features_.libc."${deps."clang_sys"."0.26.4"."libc"}" deps)
    (features_.libloading."${deps."clang_sys"."0.26.4"."libloading"}" deps)
    (features_.glob."${deps."clang_sys"."0.26.4"."glob"}" deps)
  ];


# end
# clap-2.32.0

  crates.clap."2.32.0" = deps: { features?(features_.clap."2.32.0" deps {}) }: buildRustCrate {
    crateName = "clap";
    version = "2.32.0";
    authors = [ "Kevin K. <kbknapp@gmail.com>" ];
    sha256 = "1hdjf0janvpjkwrjdjx1mm2aayzr54k72w6mriyr0n5anjkcj1lx";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."clap"."2.32.0"."bitflags"}" deps)
      (crates."textwrap"."${deps."clap"."2.32.0"."textwrap"}" deps)
      (crates."unicode_width"."${deps."clap"."2.32.0"."unicode_width"}" deps)
    ]
      ++ (if features.clap."2.32.0".atty or false then [ (crates.atty."${deps."clap"."2.32.0".atty}" deps) ] else [])
      ++ (if features.clap."2.32.0".strsim or false then [ (crates.strsim."${deps."clap"."2.32.0".strsim}" deps) ] else [])
      ++ (if features.clap."2.32.0".vec_map or false then [ (crates.vec_map."${deps."clap"."2.32.0".vec_map}" deps) ] else []))
      ++ (if !(kernel == "windows") then mapFeatures features ([
    ]
      ++ (if features.clap."2.32.0".ansi_term or false then [ (crates.ansi_term."${deps."clap"."2.32.0".ansi_term}" deps) ] else [])) else []);
    features = mkFeatures (features."clap"."2.32.0" or {});
  };
  features_.clap."2.32.0" = deps: f: updateFeatures f (rec {
    ansi_term."${deps.clap."2.32.0".ansi_term}".default = true;
    atty."${deps.clap."2.32.0".atty}".default = true;
    bitflags."${deps.clap."2.32.0".bitflags}".default = true;
    clap = fold recursiveUpdate {} [
      { "2.32.0".ansi_term =
        (f.clap."2.32.0".ansi_term or false) ||
        (f.clap."2.32.0".color or false) ||
        (clap."2.32.0"."color" or false); }
      { "2.32.0".atty =
        (f.clap."2.32.0".atty or false) ||
        (f.clap."2.32.0".color or false) ||
        (clap."2.32.0"."color" or false); }
      { "2.32.0".clippy =
        (f.clap."2.32.0".clippy or false) ||
        (f.clap."2.32.0".lints or false) ||
        (clap."2.32.0"."lints" or false); }
      { "2.32.0".color =
        (f.clap."2.32.0".color or false) ||
        (f.clap."2.32.0".default or false) ||
        (clap."2.32.0"."default" or false); }
      { "2.32.0".default = (f.clap."2.32.0".default or true); }
      { "2.32.0".strsim =
        (f.clap."2.32.0".strsim or false) ||
        (f.clap."2.32.0".suggestions or false) ||
        (clap."2.32.0"."suggestions" or false); }
      { "2.32.0".suggestions =
        (f.clap."2.32.0".suggestions or false) ||
        (f.clap."2.32.0".default or false) ||
        (clap."2.32.0"."default" or false); }
      { "2.32.0".term_size =
        (f.clap."2.32.0".term_size or false) ||
        (f.clap."2.32.0".wrap_help or false) ||
        (clap."2.32.0"."wrap_help" or false); }
      { "2.32.0".vec_map =
        (f.clap."2.32.0".vec_map or false) ||
        (f.clap."2.32.0".default or false) ||
        (clap."2.32.0"."default" or false); }
      { "2.32.0".yaml =
        (f.clap."2.32.0".yaml or false) ||
        (f.clap."2.32.0".doc or false) ||
        (clap."2.32.0"."doc" or false); }
      { "2.32.0".yaml-rust =
        (f.clap."2.32.0".yaml-rust or false) ||
        (f.clap."2.32.0".yaml or false) ||
        (clap."2.32.0"."yaml" or false); }
    ];
    strsim."${deps.clap."2.32.0".strsim}".default = true;
    textwrap = fold recursiveUpdate {} [
      { "${deps.clap."2.32.0".textwrap}"."term_size" =
        (f.textwrap."${deps.clap."2.32.0".textwrap}"."term_size" or false) ||
        (clap."2.32.0"."wrap_help" or false) ||
        (f."clap"."2.32.0"."wrap_help" or false); }
      { "${deps.clap."2.32.0".textwrap}".default = true; }
    ];
    unicode_width."${deps.clap."2.32.0".unicode_width}".default = true;
    vec_map."${deps.clap."2.32.0".vec_map}".default = true;
  }) [
    (features_.atty."${deps."clap"."2.32.0"."atty"}" deps)
    (features_.bitflags."${deps."clap"."2.32.0"."bitflags"}" deps)
    (features_.strsim."${deps."clap"."2.32.0"."strsim"}" deps)
    (features_.textwrap."${deps."clap"."2.32.0"."textwrap"}" deps)
    (features_.unicode_width."${deps."clap"."2.32.0"."unicode_width"}" deps)
    (features_.vec_map."${deps."clap"."2.32.0"."vec_map"}" deps)
    (features_.ansi_term."${deps."clap"."2.32.0"."ansi_term"}" deps)
  ];


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
# color_quant-1.0.1

  crates.color_quant."1.0.1" = deps: { features?(features_.color_quant."1.0.1" deps {}) }: buildRustCrate {
    crateName = "color_quant";
    version = "1.0.1";
    authors = [ "nwin <nwin@users.noreply.github.com>" ];
    sha256 = "12rqk6rbw4klnlr6q6njhsjllsg0nsvhm8g04sazhpkk4mw9mn8q";
  };
  features_.color_quant."1.0.1" = deps: f: updateFeatures f (rec {
    color_quant."1.0.1".default = (f.color_quant."1.0.1".default or true);
  }) [];


# end
# constant_time_eq-0.1.3

  crates.constant_time_eq."0.1.3" = deps: { features?(features_.constant_time_eq."0.1.3" deps {}) }: buildRustCrate {
    crateName = "constant_time_eq";
    version = "0.1.3";
    authors = [ "Cesar Eduardo Barros <cesarb@cesarb.eti.br>" ];
    sha256 = "03qri9hjf049gwqg9q527lybpg918q6y5q4g9a5lma753nff49wd";
  };
  features_.constant_time_eq."0.1.3" = deps: f: updateFeatures f (rec {
    constant_time_eq."0.1.3".default = (f.constant_time_eq."0.1.3".default or true);
  }) [];


# end
# cookie-0.11.0

  crates.cookie."0.11.0" = deps: { features?(features_.cookie."0.11.0" deps {}) }: buildRustCrate {
    crateName = "cookie";
    version = "0.11.0";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "0a2mwk3fzm16nsmlpmh4jxkb42p8yvxkwx6a4r5cpa14na98ix16";
    dependencies = mapFeatures features ([
      (crates."time"."${deps."cookie"."0.11.0"."time"}" deps)
    ]);
    features = mkFeatures (features."cookie"."0.11.0" or {});
  };
  features_.cookie."0.11.0" = deps: f: updateFeatures f (rec {
    cookie = fold recursiveUpdate {} [
      { "0.11.0".base64 =
        (f.cookie."0.11.0".base64 or false) ||
        (f.cookie."0.11.0".secure or false) ||
        (cookie."0.11.0"."secure" or false); }
      { "0.11.0".default = (f.cookie."0.11.0".default or true); }
      { "0.11.0".ring =
        (f.cookie."0.11.0".ring or false) ||
        (f.cookie."0.11.0".secure or false) ||
        (cookie."0.11.0"."secure" or false); }
      { "0.11.0".url =
        (f.cookie."0.11.0".url or false) ||
        (f.cookie."0.11.0".percent-encode or false) ||
        (cookie."0.11.0"."percent-encode" or false); }
    ];
    time."${deps.cookie."0.11.0".time}".default = true;
  }) [
    (features_.time."${deps."cookie"."0.11.0"."time"}" deps)
  ];


# end
# core-foundation-0.5.1

  crates.core_foundation."0.5.1" = deps: { features?(features_.core_foundation."0.5.1" deps {}) }: buildRustCrate {
    crateName = "core-foundation";
    version = "0.5.1";
    authors = [ "The Servo Project Developers" ];
    sha256 = "03s11z23rb1kk325c34rmsbd7k0l5rkzk4q6id55n174z28zqln1";
    dependencies = mapFeatures features ([
      (crates."core_foundation_sys"."${deps."core_foundation"."0.5.1"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."core_foundation"."0.5.1"."libc"}" deps)
    ]);
    features = mkFeatures (features."core_foundation"."0.5.1" or {});
  };
  features_.core_foundation."0.5.1" = deps: f: updateFeatures f (rec {
    core_foundation = fold recursiveUpdate {} [
      { "0.5.1".chrono =
        (f.core_foundation."0.5.1".chrono or false) ||
        (f.core_foundation."0.5.1".with-chrono or false) ||
        (core_foundation."0.5.1"."with-chrono" or false); }
      { "0.5.1".default = (f.core_foundation."0.5.1".default or true); }
      { "0.5.1".uuid =
        (f.core_foundation."0.5.1".uuid or false) ||
        (f.core_foundation."0.5.1".with-uuid or false) ||
        (core_foundation."0.5.1"."with-uuid" or false); }
    ];
    core_foundation_sys = fold recursiveUpdate {} [
      { "${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_7_support" =
        (f.core_foundation_sys."${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_7_support" or false) ||
        (core_foundation."0.5.1"."mac_os_10_7_support" or false) ||
        (f."core_foundation"."0.5.1"."mac_os_10_7_support" or false); }
      { "${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_8_features" =
        (f.core_foundation_sys."${deps.core_foundation."0.5.1".core_foundation_sys}"."mac_os_10_8_features" or false) ||
        (core_foundation."0.5.1"."mac_os_10_8_features" or false) ||
        (f."core_foundation"."0.5.1"."mac_os_10_8_features" or false); }
      { "${deps.core_foundation."0.5.1".core_foundation_sys}".default = true; }
    ];
    libc."${deps.core_foundation."0.5.1".libc}".default = true;
  }) [
    (features_.core_foundation_sys."${deps."core_foundation"."0.5.1"."core_foundation_sys"}" deps)
    (features_.libc."${deps."core_foundation"."0.5.1"."libc"}" deps)
  ];


# end
# core-foundation-sys-0.5.1

  crates.core_foundation_sys."0.5.1" = deps: { features?(features_.core_foundation_sys."0.5.1" deps {}) }: buildRustCrate {
    crateName = "core-foundation-sys";
    version = "0.5.1";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0qbrasll5nw1bgr071i8s8jc975d0y4qfysf868bh9xp0f6vcypa";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."core_foundation_sys"."0.5.1"."libc"}" deps)
    ]);
    features = mkFeatures (features."core_foundation_sys"."0.5.1" or {});
  };
  features_.core_foundation_sys."0.5.1" = deps: f: updateFeatures f (rec {
    core_foundation_sys."0.5.1".default = (f.core_foundation_sys."0.5.1".default or true);
    libc."${deps.core_foundation_sys."0.5.1".libc}".default = true;
  }) [
    (features_.libc."${deps."core_foundation_sys"."0.5.1"."libc"}" deps)
  ];


# end
# crc-1.8.1

  crates.crc."1.8.1" = deps: { features?(features_.crc."1.8.1" deps {}) }: buildRustCrate {
    crateName = "crc";
    version = "1.8.1";
    authors = [ "Rui Hu <code@mrhooray.com>" ];
    sha256 = "00m9jjqrddp3bqyanvyxv0hf6s56bx1wy51vcdcxg4n2jdhg109s";

    buildDependencies = mapFeatures features ([
      (crates."build_const"."${deps."crc"."1.8.1"."build_const"}" deps)
    ]);
    features = mkFeatures (features."crc"."1.8.1" or {});
  };
  features_.crc."1.8.1" = deps: f: updateFeatures f (rec {
    build_const."${deps.crc."1.8.1".build_const}".default = true;
    crc = fold recursiveUpdate {} [
      { "1.8.1".default = (f.crc."1.8.1".default or true); }
      { "1.8.1".std =
        (f.crc."1.8.1".std or false) ||
        (f.crc."1.8.1".default or false) ||
        (crc."1.8.1"."default" or false); }
    ];
  }) [
    (features_.build_const."${deps."crc"."1.8.1"."build_const"}" deps)
  ];


# end
# crc32fast-1.2.0

  crates.crc32fast."1.2.0" = deps: { features?(features_.crc32fast."1.2.0" deps {}) }: buildRustCrate {
    crateName = "crc32fast";
    version = "1.2.0";
    authors = [ "Sam Rijs <srijs@airpost.net>" "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1mx88ndqln6vzg7hjhjp8b7g0qggpqggsjrlsdqrfsrbpdzffcn8";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."crc32fast"."1.2.0"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."crc32fast"."1.2.0" or {});
  };
  features_.crc32fast."1.2.0" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.crc32fast."1.2.0".cfg_if}".default = true;
    crc32fast = fold recursiveUpdate {} [
      { "1.2.0".default = (f.crc32fast."1.2.0".default or true); }
      { "1.2.0".std =
        (f.crc32fast."1.2.0".std or false) ||
        (f.crc32fast."1.2.0".default or false) ||
        (crc32fast."1.2.0"."default" or false); }
    ];
  }) [
    (features_.cfg_if."${deps."crc32fast"."1.2.0"."cfg_if"}" deps)
  ];


# end
# crossbeam-channel-0.3.8

  crates.crossbeam_channel."0.3.8" = deps: { features?(features_.crossbeam_channel."0.3.8" deps {}) }: buildRustCrate {
    crateName = "crossbeam-channel";
    version = "0.3.8";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "0apm8why2qsgr8ykh9x677kc9ml7qp71mvirfkdzdn4c1jyqyyzm";
    dependencies = mapFeatures features ([
      (crates."crossbeam_utils"."${deps."crossbeam_channel"."0.3.8"."crossbeam_utils"}" deps)
      (crates."smallvec"."${deps."crossbeam_channel"."0.3.8"."smallvec"}" deps)
    ]);
  };
  features_.crossbeam_channel."0.3.8" = deps: f: updateFeatures f (rec {
    crossbeam_channel."0.3.8".default = (f.crossbeam_channel."0.3.8".default or true);
    crossbeam_utils."${deps.crossbeam_channel."0.3.8".crossbeam_utils}".default = true;
    smallvec."${deps.crossbeam_channel."0.3.8".smallvec}".default = true;
  }) [
    (features_.crossbeam_utils."${deps."crossbeam_channel"."0.3.8"."crossbeam_utils"}" deps)
    (features_.smallvec."${deps."crossbeam_channel"."0.3.8"."smallvec"}" deps)
  ];


# end
# crossbeam-deque-0.2.0

  crates.crossbeam_deque."0.2.0" = deps: { features?(features_.crossbeam_deque."0.2.0" deps {}) }: buildRustCrate {
    crateName = "crossbeam-deque";
    version = "0.2.0";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1h3n1p1qy45b6388j3svfy1m72xlcx9j9a5y0mww6jz8fmknipnb";
    dependencies = mapFeatures features ([
      (crates."crossbeam_epoch"."${deps."crossbeam_deque"."0.2.0"."crossbeam_epoch"}" deps)
      (crates."crossbeam_utils"."${deps."crossbeam_deque"."0.2.0"."crossbeam_utils"}" deps)
    ]);
  };
  features_.crossbeam_deque."0.2.0" = deps: f: updateFeatures f (rec {
    crossbeam_deque."0.2.0".default = (f.crossbeam_deque."0.2.0".default or true);
    crossbeam_epoch."${deps.crossbeam_deque."0.2.0".crossbeam_epoch}".default = true;
    crossbeam_utils."${deps.crossbeam_deque."0.2.0".crossbeam_utils}".default = true;
  }) [
    (features_.crossbeam_epoch."${deps."crossbeam_deque"."0.2.0"."crossbeam_epoch"}" deps)
    (features_.crossbeam_utils."${deps."crossbeam_deque"."0.2.0"."crossbeam_utils"}" deps)
  ];


# end
# crossbeam-deque-0.7.1

  crates.crossbeam_deque."0.7.1" = deps: { features?(features_.crossbeam_deque."0.7.1" deps {}) }: buildRustCrate {
    crateName = "crossbeam-deque";
    version = "0.7.1";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "11l7idrx3diksrxbaa13f9h9i6f3456qq3647f3kglxfjmz9bm8s";
    dependencies = mapFeatures features ([
      (crates."crossbeam_epoch"."${deps."crossbeam_deque"."0.7.1"."crossbeam_epoch"}" deps)
      (crates."crossbeam_utils"."${deps."crossbeam_deque"."0.7.1"."crossbeam_utils"}" deps)
    ]);
  };
  features_.crossbeam_deque."0.7.1" = deps: f: updateFeatures f (rec {
    crossbeam_deque."0.7.1".default = (f.crossbeam_deque."0.7.1".default or true);
    crossbeam_epoch."${deps.crossbeam_deque."0.7.1".crossbeam_epoch}".default = true;
    crossbeam_utils."${deps.crossbeam_deque."0.7.1".crossbeam_utils}".default = true;
  }) [
    (features_.crossbeam_epoch."${deps."crossbeam_deque"."0.7.1"."crossbeam_epoch"}" deps)
    (features_.crossbeam_utils."${deps."crossbeam_deque"."0.7.1"."crossbeam_utils"}" deps)
  ];


# end
# crossbeam-epoch-0.3.1

  crates.crossbeam_epoch."0.3.1" = deps: { features?(features_.crossbeam_epoch."0.3.1" deps {}) }: buildRustCrate {
    crateName = "crossbeam-epoch";
    version = "0.3.1";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1ljrrpvalabi3r2nnpcz7rqkbl2ydmd0mrrr2fv335f7d46xgfxa";
    dependencies = mapFeatures features ([
      (crates."arrayvec"."${deps."crossbeam_epoch"."0.3.1"."arrayvec"}" deps)
      (crates."cfg_if"."${deps."crossbeam_epoch"."0.3.1"."cfg_if"}" deps)
      (crates."crossbeam_utils"."${deps."crossbeam_epoch"."0.3.1"."crossbeam_utils"}" deps)
      (crates."memoffset"."${deps."crossbeam_epoch"."0.3.1"."memoffset"}" deps)
      (crates."nodrop"."${deps."crossbeam_epoch"."0.3.1"."nodrop"}" deps)
      (crates."scopeguard"."${deps."crossbeam_epoch"."0.3.1"."scopeguard"}" deps)
    ]
      ++ (if features.crossbeam_epoch."0.3.1".lazy_static or false then [ (crates.lazy_static."${deps."crossbeam_epoch"."0.3.1".lazy_static}" deps) ] else []));
    features = mkFeatures (features."crossbeam_epoch"."0.3.1" or {});
  };
  features_.crossbeam_epoch."0.3.1" = deps: f: updateFeatures f (rec {
    arrayvec = fold recursiveUpdate {} [
      { "${deps.crossbeam_epoch."0.3.1".arrayvec}"."use_union" =
        (f.arrayvec."${deps.crossbeam_epoch."0.3.1".arrayvec}"."use_union" or false) ||
        (crossbeam_epoch."0.3.1"."nightly" or false) ||
        (f."crossbeam_epoch"."0.3.1"."nightly" or false); }
      { "${deps.crossbeam_epoch."0.3.1".arrayvec}".default = (f.arrayvec."${deps.crossbeam_epoch."0.3.1".arrayvec}".default or false); }
    ];
    cfg_if."${deps.crossbeam_epoch."0.3.1".cfg_if}".default = true;
    crossbeam_epoch = fold recursiveUpdate {} [
      { "0.3.1".default = (f.crossbeam_epoch."0.3.1".default or true); }
      { "0.3.1".lazy_static =
        (f.crossbeam_epoch."0.3.1".lazy_static or false) ||
        (f.crossbeam_epoch."0.3.1".use_std or false) ||
        (crossbeam_epoch."0.3.1"."use_std" or false); }
      { "0.3.1".use_std =
        (f.crossbeam_epoch."0.3.1".use_std or false) ||
        (f.crossbeam_epoch."0.3.1".default or false) ||
        (crossbeam_epoch."0.3.1"."default" or false); }
    ];
    crossbeam_utils = fold recursiveUpdate {} [
      { "${deps.crossbeam_epoch."0.3.1".crossbeam_utils}"."use_std" =
        (f.crossbeam_utils."${deps.crossbeam_epoch."0.3.1".crossbeam_utils}"."use_std" or false) ||
        (crossbeam_epoch."0.3.1"."use_std" or false) ||
        (f."crossbeam_epoch"."0.3.1"."use_std" or false); }
      { "${deps.crossbeam_epoch."0.3.1".crossbeam_utils}".default = (f.crossbeam_utils."${deps.crossbeam_epoch."0.3.1".crossbeam_utils}".default or false); }
    ];
    lazy_static."${deps.crossbeam_epoch."0.3.1".lazy_static}".default = true;
    memoffset."${deps.crossbeam_epoch."0.3.1".memoffset}".default = true;
    nodrop."${deps.crossbeam_epoch."0.3.1".nodrop}".default = (f.nodrop."${deps.crossbeam_epoch."0.3.1".nodrop}".default or false);
    scopeguard."${deps.crossbeam_epoch."0.3.1".scopeguard}".default = (f.scopeguard."${deps.crossbeam_epoch."0.3.1".scopeguard}".default or false);
  }) [
    (features_.arrayvec."${deps."crossbeam_epoch"."0.3.1"."arrayvec"}" deps)
    (features_.cfg_if."${deps."crossbeam_epoch"."0.3.1"."cfg_if"}" deps)
    (features_.crossbeam_utils."${deps."crossbeam_epoch"."0.3.1"."crossbeam_utils"}" deps)
    (features_.lazy_static."${deps."crossbeam_epoch"."0.3.1"."lazy_static"}" deps)
    (features_.memoffset."${deps."crossbeam_epoch"."0.3.1"."memoffset"}" deps)
    (features_.nodrop."${deps."crossbeam_epoch"."0.3.1"."nodrop"}" deps)
    (features_.scopeguard."${deps."crossbeam_epoch"."0.3.1"."scopeguard"}" deps)
  ];


# end
# crossbeam-epoch-0.7.1

  crates.crossbeam_epoch."0.7.1" = deps: { features?(features_.crossbeam_epoch."0.7.1" deps {}) }: buildRustCrate {
    crateName = "crossbeam-epoch";
    version = "0.7.1";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1n2p8rqsg0g8dws6kvjgi5jsbnd42l45dklnzc8vihjcxa6712bg";
    dependencies = mapFeatures features ([
      (crates."arrayvec"."${deps."crossbeam_epoch"."0.7.1"."arrayvec"}" deps)
      (crates."cfg_if"."${deps."crossbeam_epoch"."0.7.1"."cfg_if"}" deps)
      (crates."crossbeam_utils"."${deps."crossbeam_epoch"."0.7.1"."crossbeam_utils"}" deps)
      (crates."memoffset"."${deps."crossbeam_epoch"."0.7.1"."memoffset"}" deps)
      (crates."scopeguard"."${deps."crossbeam_epoch"."0.7.1"."scopeguard"}" deps)
    ]
      ++ (if features.crossbeam_epoch."0.7.1".lazy_static or false then [ (crates.lazy_static."${deps."crossbeam_epoch"."0.7.1".lazy_static}" deps) ] else []));
    features = mkFeatures (features."crossbeam_epoch"."0.7.1" or {});
  };
  features_.crossbeam_epoch."0.7.1" = deps: f: updateFeatures f (rec {
    arrayvec = fold recursiveUpdate {} [
      { "${deps.crossbeam_epoch."0.7.1".arrayvec}"."use_union" =
        (f.arrayvec."${deps.crossbeam_epoch."0.7.1".arrayvec}"."use_union" or false) ||
        (crossbeam_epoch."0.7.1"."nightly" or false) ||
        (f."crossbeam_epoch"."0.7.1"."nightly" or false); }
      { "${deps.crossbeam_epoch."0.7.1".arrayvec}".default = (f.arrayvec."${deps.crossbeam_epoch."0.7.1".arrayvec}".default or false); }
    ];
    cfg_if."${deps.crossbeam_epoch."0.7.1".cfg_if}".default = true;
    crossbeam_epoch = fold recursiveUpdate {} [
      { "0.7.1".default = (f.crossbeam_epoch."0.7.1".default or true); }
      { "0.7.1".lazy_static =
        (f.crossbeam_epoch."0.7.1".lazy_static or false) ||
        (f.crossbeam_epoch."0.7.1".std or false) ||
        (crossbeam_epoch."0.7.1"."std" or false); }
      { "0.7.1".std =
        (f.crossbeam_epoch."0.7.1".std or false) ||
        (f.crossbeam_epoch."0.7.1".default or false) ||
        (crossbeam_epoch."0.7.1"."default" or false); }
    ];
    crossbeam_utils = fold recursiveUpdate {} [
      { "${deps.crossbeam_epoch."0.7.1".crossbeam_utils}"."nightly" =
        (f.crossbeam_utils."${deps.crossbeam_epoch."0.7.1".crossbeam_utils}"."nightly" or false) ||
        (crossbeam_epoch."0.7.1"."nightly" or false) ||
        (f."crossbeam_epoch"."0.7.1"."nightly" or false); }
      { "${deps.crossbeam_epoch."0.7.1".crossbeam_utils}"."std" =
        (f.crossbeam_utils."${deps.crossbeam_epoch."0.7.1".crossbeam_utils}"."std" or false) ||
        (crossbeam_epoch."0.7.1"."std" or false) ||
        (f."crossbeam_epoch"."0.7.1"."std" or false); }
      { "${deps.crossbeam_epoch."0.7.1".crossbeam_utils}".default = (f.crossbeam_utils."${deps.crossbeam_epoch."0.7.1".crossbeam_utils}".default or false); }
    ];
    lazy_static."${deps.crossbeam_epoch."0.7.1".lazy_static}".default = true;
    memoffset."${deps.crossbeam_epoch."0.7.1".memoffset}".default = true;
    scopeguard."${deps.crossbeam_epoch."0.7.1".scopeguard}".default = (f.scopeguard."${deps.crossbeam_epoch."0.7.1".scopeguard}".default or false);
  }) [
    (features_.arrayvec."${deps."crossbeam_epoch"."0.7.1"."arrayvec"}" deps)
    (features_.cfg_if."${deps."crossbeam_epoch"."0.7.1"."cfg_if"}" deps)
    (features_.crossbeam_utils."${deps."crossbeam_epoch"."0.7.1"."crossbeam_utils"}" deps)
    (features_.lazy_static."${deps."crossbeam_epoch"."0.7.1"."lazy_static"}" deps)
    (features_.memoffset."${deps."crossbeam_epoch"."0.7.1"."memoffset"}" deps)
    (features_.scopeguard."${deps."crossbeam_epoch"."0.7.1"."scopeguard"}" deps)
  ];


# end
# crossbeam-queue-0.1.2

  crates.crossbeam_queue."0.1.2" = deps: { features?(features_.crossbeam_queue."0.1.2" deps {}) }: buildRustCrate {
    crateName = "crossbeam-queue";
    version = "0.1.2";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1hannzr5w6j5061kg5iba4fzi6f2xpqv7bkcspfq17y1i8g0mzjj";
    dependencies = mapFeatures features ([
      (crates."crossbeam_utils"."${deps."crossbeam_queue"."0.1.2"."crossbeam_utils"}" deps)
    ]);
  };
  features_.crossbeam_queue."0.1.2" = deps: f: updateFeatures f (rec {
    crossbeam_queue."0.1.2".default = (f.crossbeam_queue."0.1.2".default or true);
    crossbeam_utils."${deps.crossbeam_queue."0.1.2".crossbeam_utils}".default = true;
  }) [
    (features_.crossbeam_utils."${deps."crossbeam_queue"."0.1.2"."crossbeam_utils"}" deps)
  ];


# end
# crossbeam-utils-0.2.2

  crates.crossbeam_utils."0.2.2" = deps: { features?(features_.crossbeam_utils."0.2.2" deps {}) }: buildRustCrate {
    crateName = "crossbeam-utils";
    version = "0.2.2";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "0jiwzxv0lysjq68yk4bzkygrf69zhdidyw55nxlmimxlm6xv0j4m";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."crossbeam_utils"."0.2.2"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."crossbeam_utils"."0.2.2" or {});
  };
  features_.crossbeam_utils."0.2.2" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.crossbeam_utils."0.2.2".cfg_if}".default = true;
    crossbeam_utils = fold recursiveUpdate {} [
      { "0.2.2".default = (f.crossbeam_utils."0.2.2".default or true); }
      { "0.2.2".use_std =
        (f.crossbeam_utils."0.2.2".use_std or false) ||
        (f.crossbeam_utils."0.2.2".default or false) ||
        (crossbeam_utils."0.2.2"."default" or false); }
    ];
  }) [
    (features_.cfg_if."${deps."crossbeam_utils"."0.2.2"."cfg_if"}" deps)
  ];


# end
# crossbeam-utils-0.6.5

  crates.crossbeam_utils."0.6.5" = deps: { features?(features_.crossbeam_utils."0.6.5" deps {}) }: buildRustCrate {
    crateName = "crossbeam-utils";
    version = "0.6.5";
    authors = [ "The Crossbeam Project Developers" ];
    sha256 = "1z7wgcl9d22r2x6769r5945rnwf3jqfrrmb16q7kzk292r1d4rdg";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."crossbeam_utils"."0.6.5"."cfg_if"}" deps)
    ]
      ++ (if features.crossbeam_utils."0.6.5".lazy_static or false then [ (crates.lazy_static."${deps."crossbeam_utils"."0.6.5".lazy_static}" deps) ] else []));
    features = mkFeatures (features."crossbeam_utils"."0.6.5" or {});
  };
  features_.crossbeam_utils."0.6.5" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.crossbeam_utils."0.6.5".cfg_if}".default = true;
    crossbeam_utils = fold recursiveUpdate {} [
      { "0.6.5".default = (f.crossbeam_utils."0.6.5".default or true); }
      { "0.6.5".lazy_static =
        (f.crossbeam_utils."0.6.5".lazy_static or false) ||
        (f.crossbeam_utils."0.6.5".std or false) ||
        (crossbeam_utils."0.6.5"."std" or false); }
      { "0.6.5".std =
        (f.crossbeam_utils."0.6.5".std or false) ||
        (f.crossbeam_utils."0.6.5".default or false) ||
        (crossbeam_utils."0.6.5"."default" or false); }
    ];
    lazy_static."${deps.crossbeam_utils."0.6.5".lazy_static}".default = true;
  }) [
    (features_.cfg_if."${deps."crossbeam_utils"."0.6.5"."cfg_if"}" deps)
    (features_.lazy_static."${deps."crossbeam_utils"."0.6.5"."lazy_static"}" deps)
  ];


# end
# crypto-mac-0.5.2

  crates.crypto_mac."0.5.2" = deps: { features?(features_.crypto_mac."0.5.2" deps {}) }: buildRustCrate {
    crateName = "crypto-mac";
    version = "0.5.2";
    authors = [ "RustCrypto Developers" ];
    sha256 = "0lm5blwpl5bdg128218z7yphgjfsazi7vg1xq807cdd36mxdbgny";
    dependencies = mapFeatures features ([
      (crates."constant_time_eq"."${deps."crypto_mac"."0.5.2"."constant_time_eq"}" deps)
      (crates."generic_array"."${deps."crypto_mac"."0.5.2"."generic_array"}" deps)
    ]);
    features = mkFeatures (features."crypto_mac"."0.5.2" or {});
  };
  features_.crypto_mac."0.5.2" = deps: f: updateFeatures f (rec {
    constant_time_eq."${deps.crypto_mac."0.5.2".constant_time_eq}".default = true;
    crypto_mac."0.5.2".default = (f.crypto_mac."0.5.2".default or true);
    generic_array."${deps.crypto_mac."0.5.2".generic_array}".default = true;
  }) [
    (features_.constant_time_eq."${deps."crypto_mac"."0.5.2"."constant_time_eq"}" deps)
    (features_.generic_array."${deps."crypto_mac"."0.5.2"."generic_array"}" deps)
  ];


# end
# cryptovec-0.4.6

  crates.cryptovec."0.4.6" = deps: { features?(features_.cryptovec."0.4.6" deps {}) }: buildRustCrate {
    crateName = "cryptovec";
    version = "0.4.6";
    authors = [ "Pierre-Étienne Meunier <pe@pijul.org>" ];
    sha256 = "0yvhn1rd0fxkcpawrhqsi9gafl53xlxi1yq5lxygz5bwbdnmaf97";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."cryptovec"."0.4.6"."kernel32_sys"}" deps)
      (crates."libc"."${deps."cryptovec"."0.4.6"."libc"}" deps)
      (crates."winapi"."${deps."cryptovec"."0.4.6"."winapi"}" deps)
    ]);
  };
  features_.cryptovec."0.4.6" = deps: f: updateFeatures f (rec {
    cryptovec."0.4.6".default = (f.cryptovec."0.4.6".default or true);
    kernel32_sys."${deps.cryptovec."0.4.6".kernel32_sys}".default = true;
    libc."${deps.cryptovec."0.4.6".libc}".default = true;
    winapi."${deps.cryptovec."0.4.6".winapi}".default = true;
  }) [
    (features_.kernel32_sys."${deps."cryptovec"."0.4.6"."kernel32_sys"}" deps)
    (features_.libc."${deps."cryptovec"."0.4.6"."libc"}" deps)
    (features_.winapi."${deps."cryptovec"."0.4.6"."winapi"}" deps)
  ];


# end
# cuach-0.1.1

  crates.cuach."0.1.1" = deps: { features?(features_.cuach."0.1.1" deps {}) }: buildRustCrate {
    crateName = "cuach";
    version = "0.1.1";
    authors = [ "Pierre-Étienne Meunier <pe@pijul.org>" ];
    edition = "2018";
    sha256 = "0csz49384xsjjp72mynpf106lgn5giqrd1zccf90lgc1vm2ar9a7";
    dependencies = mapFeatures features ([
      (crates."cuach_derive"."${deps."cuach"."0.1.1"."cuach_derive"}" deps)
      (crates."uuid"."${deps."cuach"."0.1.1"."uuid"}" deps)
      (crates."v_htmlescape"."${deps."cuach"."0.1.1"."v_htmlescape"}" deps)
    ]);
  };
  features_.cuach."0.1.1" = deps: f: updateFeatures f (rec {
    cuach."0.1.1".default = (f.cuach."0.1.1".default or true);
    cuach_derive."${deps.cuach."0.1.1".cuach_derive}".default = true;
    uuid."${deps.cuach."0.1.1".uuid}".default = true;
    v_htmlescape."${deps.cuach."0.1.1".v_htmlescape}".default = true;
  }) [
    (features_.cuach_derive."${deps."cuach"."0.1.1"."cuach_derive"}" deps)
    (features_.uuid."${deps."cuach"."0.1.1"."uuid"}" deps)
    (features_.v_htmlescape."${deps."cuach"."0.1.1"."v_htmlescape"}" deps)
  ];


# end
# cuach-derive-0.1.1

  crates.cuach_derive."0.1.1" = deps: { features?(features_.cuach_derive."0.1.1" deps {}) }: buildRustCrate {
    crateName = "cuach-derive";
    version = "0.1.1";
    authors = [ "Pierre-Étienne Meunier <pe@pijul.org>" ];
    edition = "2018";
    sha256 = "1rymis9r3674ra47fgv0mmnrylqpz1hq09qx10nvjrsljkhh0qsc";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."log"."${deps."cuach_derive"."0.1.1"."log"}" deps)
      (crates."proc_macro2"."${deps."cuach_derive"."0.1.1"."proc_macro2"}" deps)
      (crates."quote"."${deps."cuach_derive"."0.1.1"."quote"}" deps)
      (crates."regex"."${deps."cuach_derive"."0.1.1"."regex"}" deps)
      (crates."syn"."${deps."cuach_derive"."0.1.1"."syn"}" deps)
      (crates."xml_rs"."${deps."cuach_derive"."0.1.1"."xml_rs"}" deps)
    ]);
  };
  features_.cuach_derive."0.1.1" = deps: f: updateFeatures f (rec {
    cuach_derive."0.1.1".default = (f.cuach_derive."0.1.1".default or true);
    log."${deps.cuach_derive."0.1.1".log}".default = true;
    proc_macro2."${deps.cuach_derive."0.1.1".proc_macro2}".default = true;
    quote."${deps.cuach_derive."0.1.1".quote}".default = true;
    regex."${deps.cuach_derive."0.1.1".regex}".default = true;
    syn."${deps.cuach_derive."0.1.1".syn}".default = true;
    xml_rs."${deps.cuach_derive."0.1.1".xml_rs}".default = true;
  }) [
    (features_.log."${deps."cuach_derive"."0.1.1"."log"}" deps)
    (features_.proc_macro2."${deps."cuach_derive"."0.1.1"."proc_macro2"}" deps)
    (features_.quote."${deps."cuach_derive"."0.1.1"."quote"}" deps)
    (features_.regex."${deps."cuach_derive"."0.1.1"."regex"}" deps)
    (features_.syn."${deps."cuach_derive"."0.1.1"."syn"}" deps)
    (features_.xml_rs."${deps."cuach_derive"."0.1.1"."xml_rs"}" deps)
  ];


# end
# deflate-0.7.19

  crates.deflate."0.7.19" = deps: { features?(features_.deflate."0.7.19" deps {}) }: buildRustCrate {
    crateName = "deflate";
    version = "0.7.19";
    authors = [ "oyvindln <oyvindln@users.noreply.github.com>" ];
    sha256 = "0458vwwrm5wapy6dfmww0xk3fb1zjqsjw18c7carqs3pwm345mfl";
    dependencies = mapFeatures features ([
      (crates."adler32"."${deps."deflate"."0.7.19"."adler32"}" deps)
      (crates."byteorder"."${deps."deflate"."0.7.19"."byteorder"}" deps)
    ]);
    features = mkFeatures (features."deflate"."0.7.19" or {});
  };
  features_.deflate."0.7.19" = deps: f: updateFeatures f (rec {
    adler32."${deps.deflate."0.7.19".adler32}".default = true;
    byteorder."${deps.deflate."0.7.19".byteorder}".default = true;
    deflate = fold recursiveUpdate {} [
      { "0.7.19".default = (f.deflate."0.7.19".default or true); }
      { "0.7.19".gzip-header =
        (f.deflate."0.7.19".gzip-header or false) ||
        (f.deflate."0.7.19".gzip or false) ||
        (deflate."0.7.19"."gzip" or false); }
    ];
  }) [
    (features_.adler32."${deps."deflate"."0.7.19"."adler32"}" deps)
    (features_.byteorder."${deps."deflate"."0.7.19"."byteorder"}" deps)
  ];


# end
# diff-0.1.11

  crates.diff."0.1.11" = deps: { features?(features_.diff."0.1.11" deps {}) }: buildRustCrate {
    crateName = "diff";
    version = "0.1.11";
    authors = [ "Utkarsh Kukreti <utkarshkukreti@gmail.com>" ];
    sha256 = "1wg4vmv7myyx95kdvgxpfagfyd7yf6aakpm82zy4qn82pwp4aicw";
  };
  features_.diff."0.1.11" = deps: f: updateFeatures f (rec {
    diff."0.1.11".default = (f.diff."0.1.11".default or true);
  }) [];


# end
# digest-0.7.6

  crates.digest."0.7.6" = deps: { features?(features_.digest."0.7.6" deps {}) }: buildRustCrate {
    crateName = "digest";
    version = "0.7.6";
    authors = [ "RustCrypto Developers" ];
    sha256 = "074cw6sk5qfha3gjwgx3fg50z64wrabszfkrda2mi6b3rjrk80d4";
    dependencies = mapFeatures features ([
      (crates."generic_array"."${deps."digest"."0.7.6"."generic_array"}" deps)
    ]);
    features = mkFeatures (features."digest"."0.7.6" or {});
  };
  features_.digest."0.7.6" = deps: f: updateFeatures f (rec {
    digest."0.7.6".default = (f.digest."0.7.6".default or true);
    generic_array."${deps.digest."0.7.6".generic_array}".default = true;
  }) [
    (features_.generic_array."${deps."digest"."0.7.6"."generic_array"}" deps)
  ];


# end
# digest-0.8.0

  crates.digest."0.8.0" = deps: { features?(features_.digest."0.8.0" deps {}) }: buildRustCrate {
    crateName = "digest";
    version = "0.8.0";
    authors = [ "RustCrypto Developers" ];
    sha256 = "1bsddd8vdmncmprks8b392yccf132wjwzrcy5wdy1kh05qm23il8";
    dependencies = mapFeatures features ([
      (crates."generic_array"."${deps."digest"."0.8.0"."generic_array"}" deps)
    ]);
    features = mkFeatures (features."digest"."0.8.0" or {});
  };
  features_.digest."0.8.0" = deps: f: updateFeatures f (rec {
    digest = fold recursiveUpdate {} [
      { "0.8.0".blobby =
        (f.digest."0.8.0".blobby or false) ||
        (f.digest."0.8.0".dev or false) ||
        (digest."0.8.0"."dev" or false); }
      { "0.8.0".default = (f.digest."0.8.0".default or true); }
    ];
    generic_array."${deps.digest."0.8.0".generic_array}".default = true;
  }) [
    (features_.generic_array."${deps."digest"."0.8.0"."generic_array"}" deps)
  ];


# end
# dirs-1.0.4

  crates.dirs."1.0.4" = deps: { features?(features_.dirs."1.0.4" deps {}) }: buildRustCrate {
    crateName = "dirs";
    version = "1.0.4";
    authors = [ "Simon Ochsenreither <simon@ochsenreither.de>" ];
    sha256 = "1hp3nz0350b0gpavb3w5ajqc9l1k59cfrcsr3hcavwlkizdnpv1y";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."redox_users"."${deps."dirs"."1.0.4"."redox_users"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."dirs"."1.0.4"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."dirs"."1.0.4"."winapi"}" deps)
    ]) else []);
  };
  features_.dirs."1.0.4" = deps: f: updateFeatures f (rec {
    dirs."1.0.4".default = (f.dirs."1.0.4".default or true);
    libc."${deps.dirs."1.0.4".libc}".default = true;
    redox_users."${deps.dirs."1.0.4".redox_users}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.dirs."1.0.4".winapi}"."knownfolders" = true; }
      { "${deps.dirs."1.0.4".winapi}"."objbase" = true; }
      { "${deps.dirs."1.0.4".winapi}"."shlobj" = true; }
      { "${deps.dirs."1.0.4".winapi}"."winbase" = true; }
      { "${deps.dirs."1.0.4".winapi}"."winerror" = true; }
      { "${deps.dirs."1.0.4".winapi}".default = true; }
    ];
  }) [
    (features_.redox_users."${deps."dirs"."1.0.4"."redox_users"}" deps)
    (features_.libc."${deps."dirs"."1.0.4"."libc"}" deps)
    (features_.winapi."${deps."dirs"."1.0.4"."winapi"}" deps)
  ];


# end
# dirs-1.0.5

  crates.dirs."1.0.5" = deps: { features?(features_.dirs."1.0.5" deps {}) }: buildRustCrate {
    crateName = "dirs";
    version = "1.0.5";
    authors = [ "Simon Ochsenreither <simon@ochsenreither.de>" ];
    sha256 = "1py68zwwrhlj5vbz9f9ansjmhc8y4gs5bpamw9ycmqz030pprwf3";
    dependencies = (if kernel == "redox" then mapFeatures features ([
      (crates."redox_users"."${deps."dirs"."1.0.5"."redox_users"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."dirs"."1.0.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."dirs"."1.0.5"."winapi"}" deps)
    ]) else []);
  };
  features_.dirs."1.0.5" = deps: f: updateFeatures f (rec {
    dirs."1.0.5".default = (f.dirs."1.0.5".default or true);
    libc."${deps.dirs."1.0.5".libc}".default = true;
    redox_users."${deps.dirs."1.0.5".redox_users}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.dirs."1.0.5".winapi}"."knownfolders" = true; }
      { "${deps.dirs."1.0.5".winapi}"."objbase" = true; }
      { "${deps.dirs."1.0.5".winapi}"."shlobj" = true; }
      { "${deps.dirs."1.0.5".winapi}"."winbase" = true; }
      { "${deps.dirs."1.0.5".winapi}"."winerror" = true; }
      { "${deps.dirs."1.0.5".winapi}".default = true; }
    ];
  }) [
    (features_.redox_users."${deps."dirs"."1.0.5"."redox_users"}" deps)
    (features_.libc."${deps."dirs"."1.0.5"."libc"}" deps)
    (features_.winapi."${deps."dirs"."1.0.5"."winapi"}" deps)
  ];


# end
# docopt-1.0.2

  crates.docopt."1.0.2" = deps: { features?(features_.docopt."1.0.2" deps {}) }: buildRustCrate {
    crateName = "docopt";
    version = "1.0.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1iix1ck1pkmgajz606vylbackgymsqnbxp280v8nj6kvb6ydfgnz";
    crateBin =
      [{  name = "docopt-wordlist";  path = "src/wordlist.rs"; }];
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."docopt"."1.0.2"."lazy_static"}" deps)
      (crates."regex"."${deps."docopt"."1.0.2"."regex"}" deps)
      (crates."serde"."${deps."docopt"."1.0.2"."serde"}" deps)
      (crates."serde_derive"."${deps."docopt"."1.0.2"."serde_derive"}" deps)
      (crates."strsim"."${deps."docopt"."1.0.2"."strsim"}" deps)
    ]);
  };
  features_.docopt."1.0.2" = deps: f: updateFeatures f (rec {
    docopt."1.0.2".default = (f.docopt."1.0.2".default or true);
    lazy_static."${deps.docopt."1.0.2".lazy_static}".default = true;
    regex."${deps.docopt."1.0.2".regex}".default = true;
    serde."${deps.docopt."1.0.2".serde}".default = true;
    serde_derive."${deps.docopt."1.0.2".serde_derive}".default = true;
    strsim."${deps.docopt."1.0.2".strsim}".default = true;
  }) [
    (features_.lazy_static."${deps."docopt"."1.0.2"."lazy_static"}" deps)
    (features_.regex."${deps."docopt"."1.0.2"."regex"}" deps)
    (features_.serde."${deps."docopt"."1.0.2"."serde"}" deps)
    (features_.serde_derive."${deps."docopt"."1.0.2"."serde_derive"}" deps)
    (features_.strsim."${deps."docopt"."1.0.2"."strsim"}" deps)
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
# either-1.5.0

  crates.either."1.5.0" = deps: { features?(features_.either."1.5.0" deps {}) }: buildRustCrate {
    crateName = "either";
    version = "1.5.0";
    authors = [ "bluss" ];
    sha256 = "1f7kl2ln01y02m8fpd2zrdjiwqmgfvl9nxxrfry3k19d1gd2bsvz";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."either"."1.5.0" or {});
  };
  features_.either."1.5.0" = deps: f: updateFeatures f (rec {
    either = fold recursiveUpdate {} [
      { "1.5.0".default = (f.either."1.5.0".default or true); }
      { "1.5.0".use_std =
        (f.either."1.5.0".use_std or false) ||
        (f.either."1.5.0".default or false) ||
        (either."1.5.0"."default" or false); }
    ];
  }) [];


# end
# either-1.5.1

  crates.either."1.5.1" = deps: { features?(features_.either."1.5.1" deps {}) }: buildRustCrate {
    crateName = "either";
    version = "1.5.1";
    authors = [ "bluss" ];
    sha256 = "049dmvnyrrhf0fw955jrfazdapdl84x32grwwxllh8in39yv3783";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."either"."1.5.1" or {});
  };
  features_.either."1.5.1" = deps: f: updateFeatures f (rec {
    either = fold recursiveUpdate {} [
      { "1.5.1".default = (f.either."1.5.1".default or true); }
      { "1.5.1".use_std =
        (f.either."1.5.1".use_std or false) ||
        (f.either."1.5.1".default or false) ||
        (either."1.5.1"."default" or false); }
    ];
  }) [];


# end
# ena-0.11.0

  crates.ena."0.11.0" = deps: { features?(features_.ena."0.11.0" deps {}) }: buildRustCrate {
    crateName = "ena";
    version = "0.11.0";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" ];
    sha256 = "1r4rc48bg0z1sx2fskccx67cz1mr31hqfraz4g40fxkx0b8ax05d";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."ena"."0.11.0"."log"}" deps)
    ]);
    features = mkFeatures (features."ena"."0.11.0" or {});
  };
  features_.ena."0.11.0" = deps: f: updateFeatures f (rec {
    ena = fold recursiveUpdate {} [
      { "0.11.0".default = (f.ena."0.11.0".default or true); }
      { "0.11.0".dogged =
        (f.ena."0.11.0".dogged or false) ||
        (f.ena."0.11.0".persistent or false) ||
        (ena."0.11.0"."persistent" or false); }
      { "0.11.0".petgraph =
        (f.ena."0.11.0".petgraph or false) ||
        (f.ena."0.11.0".congruence-closure or false) ||
        (ena."0.11.0"."congruence-closure" or false); }
    ];
    log."${deps.ena."0.11.0".log}".default = true;
  }) [
    (features_.log."${deps."ena"."0.11.0"."log"}" deps)
  ];


# end
# encoding_rs-0.8.17

  crates.encoding_rs."0.8.17" = deps: { features?(features_.encoding_rs."0.8.17" deps {}) }: buildRustCrate {
    crateName = "encoding_rs";
    version = "0.8.17";
    authors = [ "Henri Sivonen <hsivonen@hsivonen.fi>" ];
    sha256 = "0p8afcx1flzr1sz2ja2gvn9c000mb8k7ysy5vv0ia3khac3i30li";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."encoding_rs"."0.8.17"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."encoding_rs"."0.8.17" or {});
  };
  features_.encoding_rs."0.8.17" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.encoding_rs."0.8.17".cfg_if}".default = true;
    encoding_rs = fold recursiveUpdate {} [
      { "0.8.17".default = (f.encoding_rs."0.8.17".default or true); }
      { "0.8.17".fast-big5-hanzi-encode =
        (f.encoding_rs."0.8.17".fast-big5-hanzi-encode or false) ||
        (f.encoding_rs."0.8.17".fast-legacy-encode or false) ||
        (encoding_rs."0.8.17"."fast-legacy-encode" or false); }
      { "0.8.17".fast-gb-hanzi-encode =
        (f.encoding_rs."0.8.17".fast-gb-hanzi-encode or false) ||
        (f.encoding_rs."0.8.17".fast-legacy-encode or false) ||
        (encoding_rs."0.8.17"."fast-legacy-encode" or false); }
      { "0.8.17".fast-hangul-encode =
        (f.encoding_rs."0.8.17".fast-hangul-encode or false) ||
        (f.encoding_rs."0.8.17".fast-legacy-encode or false) ||
        (encoding_rs."0.8.17"."fast-legacy-encode" or false); }
      { "0.8.17".fast-hanja-encode =
        (f.encoding_rs."0.8.17".fast-hanja-encode or false) ||
        (f.encoding_rs."0.8.17".fast-legacy-encode or false) ||
        (encoding_rs."0.8.17"."fast-legacy-encode" or false); }
      { "0.8.17".fast-kanji-encode =
        (f.encoding_rs."0.8.17".fast-kanji-encode or false) ||
        (f.encoding_rs."0.8.17".fast-legacy-encode or false) ||
        (encoding_rs."0.8.17"."fast-legacy-encode" or false); }
      { "0.8.17".packed_simd =
        (f.encoding_rs."0.8.17".packed_simd or false) ||
        (f.encoding_rs."0.8.17".simd-accel or false) ||
        (encoding_rs."0.8.17"."simd-accel" or false); }
    ];
  }) [
    (features_.cfg_if."${deps."encoding_rs"."0.8.17"."cfg_if"}" deps)
  ];


# end
# env_logger-0.5.13

  crates.env_logger."0.5.13" = deps: { features?(features_.env_logger."0.5.13" deps {}) }: buildRustCrate {
    crateName = "env_logger";
    version = "0.5.13";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1q6vylngcz4bn088b4hvsl879l8yz1k2bma75waljb5p4h4kbb72";
    dependencies = mapFeatures features ([
      (crates."atty"."${deps."env_logger"."0.5.13"."atty"}" deps)
      (crates."humantime"."${deps."env_logger"."0.5.13"."humantime"}" deps)
      (crates."log"."${deps."env_logger"."0.5.13"."log"}" deps)
      (crates."termcolor"."${deps."env_logger"."0.5.13"."termcolor"}" deps)
    ]
      ++ (if features.env_logger."0.5.13".regex or false then [ (crates.regex."${deps."env_logger"."0.5.13".regex}" deps) ] else []));
    features = mkFeatures (features."env_logger"."0.5.13" or {});
  };
  features_.env_logger."0.5.13" = deps: f: updateFeatures f (rec {
    atty."${deps.env_logger."0.5.13".atty}".default = true;
    env_logger = fold recursiveUpdate {} [
      { "0.5.13".default = (f.env_logger."0.5.13".default or true); }
      { "0.5.13".regex =
        (f.env_logger."0.5.13".regex or false) ||
        (f.env_logger."0.5.13".default or false) ||
        (env_logger."0.5.13"."default" or false); }
    ];
    humantime."${deps.env_logger."0.5.13".humantime}".default = true;
    log = fold recursiveUpdate {} [
      { "${deps.env_logger."0.5.13".log}"."std" = true; }
      { "${deps.env_logger."0.5.13".log}".default = true; }
    ];
    regex."${deps.env_logger."0.5.13".regex}".default = true;
    termcolor."${deps.env_logger."0.5.13".termcolor}".default = true;
  }) [
    (features_.atty."${deps."env_logger"."0.5.13"."atty"}" deps)
    (features_.humantime."${deps."env_logger"."0.5.13"."humantime"}" deps)
    (features_.log."${deps."env_logger"."0.5.13"."log"}" deps)
    (features_.regex."${deps."env_logger"."0.5.13"."regex"}" deps)
    (features_.termcolor."${deps."env_logger"."0.5.13"."termcolor"}" deps)
  ];


# end
# env_logger-0.6.1

  crates.env_logger."0.6.1" = deps: { features?(features_.env_logger."0.6.1" deps {}) }: buildRustCrate {
    crateName = "env_logger";
    version = "0.6.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1d02i2yaqpnmbgw42pf0hd56ddd9jr4zq5yypbmfvc8rs13x0jql";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."env_logger"."0.6.1"."log"}" deps)
    ]
      ++ (if features.env_logger."0.6.1".atty or false then [ (crates.atty."${deps."env_logger"."0.6.1".atty}" deps) ] else [])
      ++ (if features.env_logger."0.6.1".humantime or false then [ (crates.humantime."${deps."env_logger"."0.6.1".humantime}" deps) ] else [])
      ++ (if features.env_logger."0.6.1".regex or false then [ (crates.regex."${deps."env_logger"."0.6.1".regex}" deps) ] else [])
      ++ (if features.env_logger."0.6.1".termcolor or false then [ (crates.termcolor."${deps."env_logger"."0.6.1".termcolor}" deps) ] else []));
    features = mkFeatures (features."env_logger"."0.6.1" or {});
  };
  features_.env_logger."0.6.1" = deps: f: updateFeatures f (rec {
    atty."${deps.env_logger."0.6.1".atty}".default = true;
    env_logger = fold recursiveUpdate {} [
      { "0.6.1".atty =
        (f.env_logger."0.6.1".atty or false) ||
        (f.env_logger."0.6.1".default or false) ||
        (env_logger."0.6.1"."default" or false); }
      { "0.6.1".default = (f.env_logger."0.6.1".default or true); }
      { "0.6.1".humantime =
        (f.env_logger."0.6.1".humantime or false) ||
        (f.env_logger."0.6.1".default or false) ||
        (env_logger."0.6.1"."default" or false); }
      { "0.6.1".regex =
        (f.env_logger."0.6.1".regex or false) ||
        (f.env_logger."0.6.1".default or false) ||
        (env_logger."0.6.1"."default" or false); }
      { "0.6.1".termcolor =
        (f.env_logger."0.6.1".termcolor or false) ||
        (f.env_logger."0.6.1".default or false) ||
        (env_logger."0.6.1"."default" or false); }
    ];
    humantime."${deps.env_logger."0.6.1".humantime}".default = true;
    log = fold recursiveUpdate {} [
      { "${deps.env_logger."0.6.1".log}"."std" = true; }
      { "${deps.env_logger."0.6.1".log}".default = true; }
    ];
    regex."${deps.env_logger."0.6.1".regex}".default = true;
    termcolor."${deps.env_logger."0.6.1".termcolor}".default = true;
  }) [
    (features_.atty."${deps."env_logger"."0.6.1"."atty"}" deps)
    (features_.humantime."${deps."env_logger"."0.6.1"."humantime"}" deps)
    (features_.log."${deps."env_logger"."0.6.1"."log"}" deps)
    (features_.regex."${deps."env_logger"."0.6.1"."regex"}" deps)
    (features_.termcolor."${deps."env_logger"."0.6.1"."termcolor"}" deps)
  ];


# end
# error-chain-0.12.0

  crates.error_chain."0.12.0" = deps: { features?(features_.error_chain."0.12.0" deps {}) }: buildRustCrate {
    crateName = "error-chain";
    version = "0.12.0";
    authors = [ "Brian Anderson <banderson@mozilla.com>" "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" "Yamakaky <yamakaky@yamaworld.fr>" ];
    sha256 = "1m6wk1r6wqg1mn69bxxvk5k081cb4xy6bfhsxb99rv408x9wjcnl";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.error_chain."0.12.0".backtrace or false then [ (crates.backtrace."${deps."error_chain"."0.12.0".backtrace}" deps) ] else []));
    features = mkFeatures (features."error_chain"."0.12.0" or {});
  };
  features_.error_chain."0.12.0" = deps: f: updateFeatures f (rec {
    backtrace."${deps.error_chain."0.12.0".backtrace}".default = true;
    error_chain = fold recursiveUpdate {} [
      { "0.12.0".backtrace =
        (f.error_chain."0.12.0".backtrace or false) ||
        (f.error_chain."0.12.0".default or false) ||
        (error_chain."0.12.0"."default" or false); }
      { "0.12.0".default = (f.error_chain."0.12.0".default or true); }
      { "0.12.0".example_generated =
        (f.error_chain."0.12.0".example_generated or false) ||
        (f.error_chain."0.12.0".default or false) ||
        (error_chain."0.12.0"."default" or false); }
    ];
  }) [
    (features_.backtrace."${deps."error_chain"."0.12.0"."backtrace"}" deps)
  ];


# end
# failure-0.1.3

  crates.failure."0.1.3" = deps: { features?(features_.failure."0.1.3" deps {}) }: buildRustCrate {
    crateName = "failure";
    version = "0.1.3";
    authors = [ "Without Boats <boats@mozilla.com>" ];
    sha256 = "0cibp01z0clyxrvkl7v7kq6jszsgcg9vwv6d9l6d1drk9jqdss4s";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.failure."0.1.3".backtrace or false then [ (crates.backtrace."${deps."failure"."0.1.3".backtrace}" deps) ] else [])
      ++ (if features.failure."0.1.3".failure_derive or false then [ (crates.failure_derive."${deps."failure"."0.1.3".failure_derive}" deps) ] else []));
    features = mkFeatures (features."failure"."0.1.3" or {});
  };
  features_.failure."0.1.3" = deps: f: updateFeatures f (rec {
    backtrace."${deps.failure."0.1.3".backtrace}".default = true;
    failure = fold recursiveUpdate {} [
      { "0.1.3".backtrace =
        (f.failure."0.1.3".backtrace or false) ||
        (f.failure."0.1.3".std or false) ||
        (failure."0.1.3"."std" or false); }
      { "0.1.3".default = (f.failure."0.1.3".default or true); }
      { "0.1.3".derive =
        (f.failure."0.1.3".derive or false) ||
        (f.failure."0.1.3".default or false) ||
        (failure."0.1.3"."default" or false); }
      { "0.1.3".failure_derive =
        (f.failure."0.1.3".failure_derive or false) ||
        (f.failure."0.1.3".derive or false) ||
        (failure."0.1.3"."derive" or false); }
      { "0.1.3".std =
        (f.failure."0.1.3".std or false) ||
        (f.failure."0.1.3".default or false) ||
        (failure."0.1.3"."default" or false); }
    ];
    failure_derive."${deps.failure."0.1.3".failure_derive}".default = true;
  }) [
    (features_.backtrace."${deps."failure"."0.1.3"."backtrace"}" deps)
    (features_.failure_derive."${deps."failure"."0.1.3"."failure_derive"}" deps)
  ];


# end
# failure-0.1.5

  crates.failure."0.1.5" = deps: { features?(features_.failure."0.1.5" deps {}) }: buildRustCrate {
    crateName = "failure";
    version = "0.1.5";
    authors = [ "Without Boats <boats@mozilla.com>" ];
    sha256 = "1msaj1c0fg12dzyf4fhxqlx1gfx41lj2smdjmkc9hkrgajk2g3kx";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.failure."0.1.5".backtrace or false then [ (crates.backtrace."${deps."failure"."0.1.5".backtrace}" deps) ] else [])
      ++ (if features.failure."0.1.5".failure_derive or false then [ (crates.failure_derive."${deps."failure"."0.1.5".failure_derive}" deps) ] else []));
    features = mkFeatures (features."failure"."0.1.5" or {});
  };
  features_.failure."0.1.5" = deps: f: updateFeatures f (rec {
    backtrace."${deps.failure."0.1.5".backtrace}".default = true;
    failure = fold recursiveUpdate {} [
      { "0.1.5".backtrace =
        (f.failure."0.1.5".backtrace or false) ||
        (f.failure."0.1.5".std or false) ||
        (failure."0.1.5"."std" or false); }
      { "0.1.5".default = (f.failure."0.1.5".default or true); }
      { "0.1.5".derive =
        (f.failure."0.1.5".derive or false) ||
        (f.failure."0.1.5".default or false) ||
        (failure."0.1.5"."default" or false); }
      { "0.1.5".failure_derive =
        (f.failure."0.1.5".failure_derive or false) ||
        (f.failure."0.1.5".derive or false) ||
        (failure."0.1.5"."derive" or false); }
      { "0.1.5".std =
        (f.failure."0.1.5".std or false) ||
        (f.failure."0.1.5".default or false) ||
        (failure."0.1.5"."default" or false); }
    ];
    failure_derive."${deps.failure."0.1.5".failure_derive}".default = true;
  }) [
    (features_.backtrace."${deps."failure"."0.1.5"."backtrace"}" deps)
    (features_.failure_derive."${deps."failure"."0.1.5"."failure_derive"}" deps)
  ];


# end
# failure_derive-0.1.3

  crates.failure_derive."0.1.3" = deps: { features?(features_.failure_derive."0.1.3" deps {}) }: buildRustCrate {
    crateName = "failure_derive";
    version = "0.1.3";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1mh7ad2d17f13g0k29bskp0f9faws0w1q4a5yfzlzi75bw9kidgm";
    procMacro = true;
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."failure_derive"."0.1.3"."proc_macro2"}" deps)
      (crates."quote"."${deps."failure_derive"."0.1.3"."quote"}" deps)
      (crates."syn"."${deps."failure_derive"."0.1.3"."syn"}" deps)
      (crates."synstructure"."${deps."failure_derive"."0.1.3"."synstructure"}" deps)
    ]);
    features = mkFeatures (features."failure_derive"."0.1.3" or {});
  };
  features_.failure_derive."0.1.3" = deps: f: updateFeatures f (rec {
    failure_derive."0.1.3".default = (f.failure_derive."0.1.3".default or true);
    proc_macro2."${deps.failure_derive."0.1.3".proc_macro2}".default = true;
    quote."${deps.failure_derive."0.1.3".quote}".default = true;
    syn."${deps.failure_derive."0.1.3".syn}".default = true;
    synstructure."${deps.failure_derive."0.1.3".synstructure}".default = true;
  }) [
    (features_.proc_macro2."${deps."failure_derive"."0.1.3"."proc_macro2"}" deps)
    (features_.quote."${deps."failure_derive"."0.1.3"."quote"}" deps)
    (features_.syn."${deps."failure_derive"."0.1.3"."syn"}" deps)
    (features_.synstructure."${deps."failure_derive"."0.1.3"."synstructure"}" deps)
  ];


# end
# failure_derive-0.1.5

  crates.failure_derive."0.1.5" = deps: { features?(features_.failure_derive."0.1.5" deps {}) }: buildRustCrate {
    crateName = "failure_derive";
    version = "0.1.5";
    authors = [ "Without Boats <woboats@gmail.com>" ];
    sha256 = "1wzk484b87r4qszcvdl2bkniv5ls4r2f2dshz7hmgiv6z4ln12g0";
    procMacro = true;
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."failure_derive"."0.1.5"."proc_macro2"}" deps)
      (crates."quote"."${deps."failure_derive"."0.1.5"."quote"}" deps)
      (crates."syn"."${deps."failure_derive"."0.1.5"."syn"}" deps)
      (crates."synstructure"."${deps."failure_derive"."0.1.5"."synstructure"}" deps)
    ]);
    features = mkFeatures (features."failure_derive"."0.1.5" or {});
  };
  features_.failure_derive."0.1.5" = deps: f: updateFeatures f (rec {
    failure_derive."0.1.5".default = (f.failure_derive."0.1.5".default or true);
    proc_macro2."${deps.failure_derive."0.1.5".proc_macro2}".default = true;
    quote."${deps.failure_derive."0.1.5".quote}".default = true;
    syn."${deps.failure_derive."0.1.5".syn}".default = true;
    synstructure."${deps.failure_derive."0.1.5".synstructure}".default = true;
  }) [
    (features_.proc_macro2."${deps."failure_derive"."0.1.5"."proc_macro2"}" deps)
    (features_.quote."${deps."failure_derive"."0.1.5"."quote"}" deps)
    (features_.syn."${deps."failure_derive"."0.1.5"."syn"}" deps)
    (features_.synstructure."${deps."failure_derive"."0.1.5"."synstructure"}" deps)
  ];


# end
# fake-simd-0.1.2

  crates.fake_simd."0.1.2" = deps: { features?(features_.fake_simd."0.1.2" deps {}) }: buildRustCrate {
    crateName = "fake-simd";
    version = "0.1.2";
    authors = [ "The Rust-Crypto Project Developers" ];
    sha256 = "1a0f1j66nkwfy17s06vm2bn9vh8vy8llcijfhh9m10p58v08661a";
  };
  features_.fake_simd."0.1.2" = deps: f: updateFeatures f (rec {
    fake_simd."0.1.2".default = (f.fake_simd."0.1.2".default or true);
  }) [];


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
# flate2-1.0.6

  crates.flate2."1.0.6" = deps: { features?(features_.flate2."1.0.6" deps {}) }: buildRustCrate {
    crateName = "flate2";
    version = "1.0.6";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0l2rkb5labwhacv9jdjw7fwd7r54a6jw976q89kiwa9xhn1yxkld";
    dependencies = mapFeatures features ([
      (crates."crc32fast"."${deps."flate2"."1.0.6"."crc32fast"}" deps)
      (crates."libc"."${deps."flate2"."1.0.6"."libc"}" deps)
    ]
      ++ (if features.flate2."1.0.6".miniz-sys or false then [ (crates.miniz_sys."${deps."flate2"."1.0.6".miniz_sys}" deps) ] else [])
      ++ (if features.flate2."1.0.6".miniz_oxide_c_api or false then [ (crates.miniz_oxide_c_api."${deps."flate2"."1.0.6".miniz_oxide_c_api}" deps) ] else []))
      ++ (if cpu == "wasm32" && !(kernel == "emscripten") then mapFeatures features ([
      (crates."miniz_oxide_c_api"."${deps."flate2"."1.0.6"."miniz_oxide_c_api"}" deps)
    ]) else []);
    features = mkFeatures (features."flate2"."1.0.6" or {});
  };
  features_.flate2."1.0.6" = deps: f: updateFeatures f (rec {
    crc32fast."${deps.flate2."1.0.6".crc32fast}".default = true;
    flate2 = fold recursiveUpdate {} [
      { "1.0.6".default = (f.flate2."1.0.6".default or true); }
      { "1.0.6".futures =
        (f.flate2."1.0.6".futures or false) ||
        (f.flate2."1.0.6".tokio or false) ||
        (flate2."1.0.6"."tokio" or false); }
      { "1.0.6".libz-sys =
        (f.flate2."1.0.6".libz-sys or false) ||
        (f.flate2."1.0.6".zlib or false) ||
        (flate2."1.0.6"."zlib" or false); }
      { "1.0.6".miniz-sys =
        (f.flate2."1.0.6".miniz-sys or false) ||
        (f.flate2."1.0.6".default or false) ||
        (flate2."1.0.6"."default" or false); }
      { "1.0.6".miniz_oxide_c_api =
        (f.flate2."1.0.6".miniz_oxide_c_api or false) ||
        (f.flate2."1.0.6".rust_backend or false) ||
        (flate2."1.0.6"."rust_backend" or false); }
      { "1.0.6".tokio-io =
        (f.flate2."1.0.6".tokio-io or false) ||
        (f.flate2."1.0.6".tokio or false) ||
        (flate2."1.0.6"."tokio" or false); }
    ];
    libc."${deps.flate2."1.0.6".libc}".default = true;
    miniz_oxide_c_api = fold recursiveUpdate {} [
      { "${deps.flate2."1.0.6".miniz_oxide_c_api}"."no_c_export" =
        (f.miniz_oxide_c_api."${deps.flate2."1.0.6".miniz_oxide_c_api}"."no_c_export" or false) ||
        true ||
        true; }
      { "${deps.flate2."1.0.6".miniz_oxide_c_api}".default = true; }
    ];
    miniz_sys."${deps.flate2."1.0.6".miniz_sys}".default = true;
  }) [
    (features_.crc32fast."${deps."flate2"."1.0.6"."crc32fast"}" deps)
    (features_.libc."${deps."flate2"."1.0.6"."libc"}" deps)
    (features_.miniz_sys."${deps."flate2"."1.0.6"."miniz_sys"}" deps)
    (features_.miniz_oxide_c_api."${deps."flate2"."1.0.6"."miniz_oxide_c_api"}" deps)
    (features_.miniz_oxide_c_api."${deps."flate2"."1.0.6"."miniz_oxide_c_api"}" deps)
  ];


# end
# fnv-1.0.6

  crates.fnv."1.0.6" = deps: { features?(features_.fnv."1.0.6" deps {}) }: buildRustCrate {
    crateName = "fnv";
    version = "1.0.6";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "128mlh23y3gg6ag5h8iiqlcbl59smisdzraqy88ldrf75kbw27ip";
    libPath = "lib.rs";
  };
  features_.fnv."1.0.6" = deps: f: updateFeatures f (rec {
    fnv."1.0.6".default = (f.fnv."1.0.6".default or true);
  }) [];


# end
# foreign-types-0.3.2

  crates.foreign_types."0.3.2" = deps: { features?(features_.foreign_types."0.3.2" deps {}) }: buildRustCrate {
    crateName = "foreign-types";
    version = "0.3.2";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "105n8sp2djb1s5lzrw04p7ss3dchr5qa3canmynx396nh3vwm2p8";
    dependencies = mapFeatures features ([
      (crates."foreign_types_shared"."${deps."foreign_types"."0.3.2"."foreign_types_shared"}" deps)
    ]);
  };
  features_.foreign_types."0.3.2" = deps: f: updateFeatures f (rec {
    foreign_types."0.3.2".default = (f.foreign_types."0.3.2".default or true);
    foreign_types_shared."${deps.foreign_types."0.3.2".foreign_types_shared}".default = true;
  }) [
    (features_.foreign_types_shared."${deps."foreign_types"."0.3.2"."foreign_types_shared"}" deps)
  ];


# end
# foreign-types-shared-0.1.1

  crates.foreign_types_shared."0.1.1" = deps: { features?(features_.foreign_types_shared."0.1.1" deps {}) }: buildRustCrate {
    crateName = "foreign-types-shared";
    version = "0.1.1";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0b6cnvqbflws8dxywk4589vgbz80049lz4x1g9dfy4s1ppd3g4z5";
  };
  features_.foreign_types_shared."0.1.1" = deps: f: updateFeatures f (rec {
    foreign_types_shared."0.1.1".default = (f.foreign_types_shared."0.1.1".default or true);
  }) [];


# end
# fs2-0.4.3

  crates.fs2."0.4.3" = deps: { features?(features_.fs2."0.4.3" deps {}) }: buildRustCrate {
    crateName = "fs2";
    version = "0.4.3";
    authors = [ "Dan Burkert <dan@danburkert.com>" ];
    sha256 = "1crj36rhhpk3qby9yj7r77w7sld0mzab2yicmphbdkfymbmp3ldp";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."fs2"."0.4.3"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."fs2"."0.4.3"."winapi"}" deps)
    ]) else []);
  };
  features_.fs2."0.4.3" = deps: f: updateFeatures f (rec {
    fs2."0.4.3".default = (f.fs2."0.4.3".default or true);
    libc."${deps.fs2."0.4.3".libc}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.fs2."0.4.3".winapi}"."fileapi" = true; }
      { "${deps.fs2."0.4.3".winapi}"."handleapi" = true; }
      { "${deps.fs2."0.4.3".winapi}"."processthreadsapi" = true; }
      { "${deps.fs2."0.4.3".winapi}"."std" = true; }
      { "${deps.fs2."0.4.3".winapi}"."winbase" = true; }
      { "${deps.fs2."0.4.3".winapi}"."winerror" = true; }
      { "${deps.fs2."0.4.3".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."fs2"."0.4.3"."libc"}" deps)
    (features_.winapi."${deps."fs2"."0.4.3"."winapi"}" deps)
  ];


# end
# fuchsia-cprng-0.1.1

  crates.fuchsia_cprng."0.1.1" = deps: { features?(features_.fuchsia_cprng."0.1.1" deps {}) }: buildRustCrate {
    crateName = "fuchsia-cprng";
    version = "0.1.1";
    authors = [ "Erick Tryzelaar <etryzelaar@google.com>" ];
    edition = "2018";
    sha256 = "07apwv9dj716yjlcj29p94vkqn5zmfh7hlrqvrjx3wzshphc95h9";
  };
  features_.fuchsia_cprng."0.1.1" = deps: f: updateFeatures f (rec {
    fuchsia_cprng."0.1.1".default = (f.fuchsia_cprng."0.1.1".default or true);
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
# futf-0.1.4

  crates.futf."0.1.4" = deps: { features?(features_.futf."0.1.4" deps {}) }: buildRustCrate {
    crateName = "futf";
    version = "0.1.4";
    authors = [ "Keegan McAllister <kmcallister@mozilla.com>" ];
    sha256 = "0sf664dbha0iwgqbpa1nhvssm3xi9z07mz90m9bfipgdybbs1pbn";
    dependencies = mapFeatures features ([
      (crates."mac"."${deps."futf"."0.1.4"."mac"}" deps)
      (crates."new_debug_unreachable"."${deps."futf"."0.1.4"."new_debug_unreachable"}" deps)
    ]);
  };
  features_.futf."0.1.4" = deps: f: updateFeatures f (rec {
    futf."0.1.4".default = (f.futf."0.1.4".default or true);
    mac."${deps.futf."0.1.4".mac}".default = true;
    new_debug_unreachable."${deps.futf."0.1.4".new_debug_unreachable}".default = true;
  }) [
    (features_.mac."${deps."futf"."0.1.4"."mac"}" deps)
    (features_.new_debug_unreachable."${deps."futf"."0.1.4"."new_debug_unreachable"}" deps)
  ];


# end
# futures-0.1.25

  crates.futures."0.1.25" = deps: { features?(features_.futures."0.1.25" deps {}) }: buildRustCrate {
    crateName = "futures";
    version = "0.1.25";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1gdn9z3mi3jjzbxgvawqh90895130c3ydks55rshja0ncpn985q3";
    features = mkFeatures (features."futures"."0.1.25" or {});
  };
  features_.futures."0.1.25" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "0.1.25".default = (f.futures."0.1.25".default or true); }
      { "0.1.25".use_std =
        (f.futures."0.1.25".use_std or false) ||
        (f.futures."0.1.25".default or false) ||
        (futures."0.1.25"."default" or false); }
      { "0.1.25".with-deprecated =
        (f.futures."0.1.25".with-deprecated or false) ||
        (f.futures."0.1.25".default or false) ||
        (futures."0.1.25"."default" or false); }
    ];
  }) [];


# end
# futures-cpupool-0.1.8

  crates.futures_cpupool."0.1.8" = deps: { features?(features_.futures_cpupool."0.1.8" deps {}) }: buildRustCrate {
    crateName = "futures-cpupool";
    version = "0.1.8";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0ficd31n5ljiixy6x0vjglhq4fp0v1p4qzxm3v6ymsrb3z080l5c";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."futures_cpupool"."0.1.8"."futures"}" deps)
      (crates."num_cpus"."${deps."futures_cpupool"."0.1.8"."num_cpus"}" deps)
    ]);
    features = mkFeatures (features."futures_cpupool"."0.1.8" or {});
  };
  features_.futures_cpupool."0.1.8" = deps: f: updateFeatures f (rec {
    futures = fold recursiveUpdate {} [
      { "${deps.futures_cpupool."0.1.8".futures}"."use_std" = true; }
      { "${deps.futures_cpupool."0.1.8".futures}"."with-deprecated" =
        (f.futures."${deps.futures_cpupool."0.1.8".futures}"."with-deprecated" or false) ||
        (futures_cpupool."0.1.8"."with-deprecated" or false) ||
        (f."futures_cpupool"."0.1.8"."with-deprecated" or false); }
      { "${deps.futures_cpupool."0.1.8".futures}".default = (f.futures."${deps.futures_cpupool."0.1.8".futures}".default or false); }
    ];
    futures_cpupool = fold recursiveUpdate {} [
      { "0.1.8".default = (f.futures_cpupool."0.1.8".default or true); }
      { "0.1.8".with-deprecated =
        (f.futures_cpupool."0.1.8".with-deprecated or false) ||
        (f.futures_cpupool."0.1.8".default or false) ||
        (futures_cpupool."0.1.8"."default" or false); }
    ];
    num_cpus."${deps.futures_cpupool."0.1.8".num_cpus}".default = true;
  }) [
    (features_.futures."${deps."futures_cpupool"."0.1.8"."futures"}" deps)
    (features_.num_cpus."${deps."futures_cpupool"."0.1.8"."num_cpus"}" deps)
  ];


# end
# generic-array-0.12.0

  crates.generic_array."0.12.0" = deps: { features?(features_.generic_array."0.12.0" deps {}) }: buildRustCrate {
    crateName = "generic-array";
    version = "0.12.0";
    authors = [ "Bartłomiej Kamiński <fizyk20@gmail.com>" "Aaron Trent <novacrazy@gmail.com>" ];
    sha256 = "12fjpkx1ilqlmynis45g0gh69zkad6jnsc589j64z3idk18lvv91";
    libName = "generic_array";
    dependencies = mapFeatures features ([
      (crates."typenum"."${deps."generic_array"."0.12.0"."typenum"}" deps)
    ]);
  };
  features_.generic_array."0.12.0" = deps: f: updateFeatures f (rec {
    generic_array."0.12.0".default = (f.generic_array."0.12.0".default or true);
    typenum."${deps.generic_array."0.12.0".typenum}".default = true;
  }) [
    (features_.typenum."${deps."generic_array"."0.12.0"."typenum"}" deps)
  ];


# end
# generic-array-0.9.0

  crates.generic_array."0.9.0" = deps: { features?(features_.generic_array."0.9.0" deps {}) }: buildRustCrate {
    crateName = "generic-array";
    version = "0.9.0";
    authors = [ "Bartłomiej Kamiński <fizyk20@gmail.com>" ];
    sha256 = "1gk3g5yxvh361syfz38nlf6vg7d0qx7crpa83mnqzaf9dymz19g7";
    libName = "generic_array";
    dependencies = mapFeatures features ([
      (crates."typenum"."${deps."generic_array"."0.9.0"."typenum"}" deps)
    ]);
  };
  features_.generic_array."0.9.0" = deps: f: updateFeatures f (rec {
    generic_array."0.9.0".default = (f.generic_array."0.9.0".default or true);
    typenum."${deps.generic_array."0.9.0".typenum}".default = true;
  }) [
    (features_.typenum."${deps."generic_array"."0.9.0"."typenum"}" deps)
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
# gif-0.10.1

  crates.gif."0.10.1" = deps: { features?(features_.gif."0.10.1" deps {}) }: buildRustCrate {
    crateName = "gif";
    version = "0.10.1";
    authors = [ "nwin <nwin@users.noreply.github.com>" ];
    sha256 = "18b7hykm0difvi8v1d9vf9l18pw41v9v0yvgc77fd1jlmlkqj649";
    dependencies = mapFeatures features ([
      (crates."color_quant"."${deps."gif"."0.10.1"."color_quant"}" deps)
      (crates."lzw"."${deps."gif"."0.10.1"."lzw"}" deps)
    ]);
    features = mkFeatures (features."gif"."0.10.1" or {});
  };
  features_.gif."0.10.1" = deps: f: updateFeatures f (rec {
    color_quant."${deps.gif."0.10.1".color_quant}".default = true;
    gif = fold recursiveUpdate {} [
      { "0.10.1".default = (f.gif."0.10.1".default or true); }
      { "0.10.1".libc =
        (f.gif."0.10.1".libc or false) ||
        (f.gif."0.10.1".c_api or false) ||
        (gif."0.10.1"."c_api" or false); }
      { "0.10.1".raii_no_panic =
        (f.gif."0.10.1".raii_no_panic or false) ||
        (f.gif."0.10.1".default or false) ||
        (gif."0.10.1"."default" or false); }
    ];
    lzw."${deps.gif."0.10.1".lzw}".default = true;
  }) [
    (features_.color_quant."${deps."gif"."0.10.1"."color_quant"}" deps)
    (features_.lzw."${deps."gif"."0.10.1"."lzw"}" deps)
  ];


# end
# glob-0.2.11

  crates.glob."0.2.11" = deps: { features?(features_.glob."0.2.11" deps {}) }: buildRustCrate {
    crateName = "glob";
    version = "0.2.11";
    authors = [ "The Rust Project Developers" ];
    sha256 = "104389jjxs8r2f5cc9p0axhjmndgln60ih5x4f00ccgg9d3zarlf";
  };
  features_.glob."0.2.11" = deps: f: updateFeatures f (rec {
    glob."0.2.11".default = (f.glob."0.2.11".default or true);
  }) [];


# end
# globset-0.4.2

  crates.globset."0.4.2" = deps: { features?(features_.globset."0.4.2" deps {}) }: buildRustCrate {
    crateName = "globset";
    version = "0.4.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0cymxnzzzadk13f344gska1apvggc0mnd3klhw3h504vhqrb1l2b";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."globset"."0.4.2"."aho_corasick"}" deps)
      (crates."fnv"."${deps."globset"."0.4.2"."fnv"}" deps)
      (crates."log"."${deps."globset"."0.4.2"."log"}" deps)
      (crates."memchr"."${deps."globset"."0.4.2"."memchr"}" deps)
      (crates."regex"."${deps."globset"."0.4.2"."regex"}" deps)
    ]);
    features = mkFeatures (features."globset"."0.4.2" or {});
  };
  features_.globset."0.4.2" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.globset."0.4.2".aho_corasick}".default = true;
    fnv."${deps.globset."0.4.2".fnv}".default = true;
    globset."0.4.2".default = (f.globset."0.4.2".default or true);
    log."${deps.globset."0.4.2".log}".default = true;
    memchr."${deps.globset."0.4.2".memchr}".default = true;
    regex."${deps.globset."0.4.2".regex}".default = true;
  }) [
    (features_.aho_corasick."${deps."globset"."0.4.2"."aho_corasick"}" deps)
    (features_.fnv."${deps."globset"."0.4.2"."fnv"}" deps)
    (features_.log."${deps."globset"."0.4.2"."log"}" deps)
    (features_.memchr."${deps."globset"."0.4.2"."memchr"}" deps)
    (features_.regex."${deps."globset"."0.4.2"."regex"}" deps)
  ];


# end
# h2-0.1.16

  crates.h2."0.1.16" = deps: { features?(features_.h2."0.1.16" deps {}) }: buildRustCrate {
    crateName = "h2";
    version = "0.1.16";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1c50yfizd5x9hdcnj07bjlaa1wjzqlkxqjf89a15jq6j39i24r04";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."h2"."0.1.16"."byteorder"}" deps)
      (crates."bytes"."${deps."h2"."0.1.16"."bytes"}" deps)
      (crates."fnv"."${deps."h2"."0.1.16"."fnv"}" deps)
      (crates."futures"."${deps."h2"."0.1.16"."futures"}" deps)
      (crates."http"."${deps."h2"."0.1.16"."http"}" deps)
      (crates."indexmap"."${deps."h2"."0.1.16"."indexmap"}" deps)
      (crates."log"."${deps."h2"."0.1.16"."log"}" deps)
      (crates."slab"."${deps."h2"."0.1.16"."slab"}" deps)
      (crates."string"."${deps."h2"."0.1.16"."string"}" deps)
      (crates."tokio_io"."${deps."h2"."0.1.16"."tokio_io"}" deps)
    ]);
    features = mkFeatures (features."h2"."0.1.16" or {});
  };
  features_.h2."0.1.16" = deps: f: updateFeatures f (rec {
    byteorder."${deps.h2."0.1.16".byteorder}".default = true;
    bytes."${deps.h2."0.1.16".bytes}".default = true;
    fnv."${deps.h2."0.1.16".fnv}".default = true;
    futures."${deps.h2."0.1.16".futures}".default = true;
    h2."0.1.16".default = (f.h2."0.1.16".default or true);
    http."${deps.h2."0.1.16".http}".default = true;
    indexmap."${deps.h2."0.1.16".indexmap}".default = true;
    log."${deps.h2."0.1.16".log}".default = true;
    slab."${deps.h2."0.1.16".slab}".default = true;
    string."${deps.h2."0.1.16".string}".default = true;
    tokio_io."${deps.h2."0.1.16".tokio_io}".default = true;
  }) [
    (features_.byteorder."${deps."h2"."0.1.16"."byteorder"}" deps)
    (features_.bytes."${deps."h2"."0.1.16"."bytes"}" deps)
    (features_.fnv."${deps."h2"."0.1.16"."fnv"}" deps)
    (features_.futures."${deps."h2"."0.1.16"."futures"}" deps)
    (features_.http."${deps."h2"."0.1.16"."http"}" deps)
    (features_.indexmap."${deps."h2"."0.1.16"."indexmap"}" deps)
    (features_.log."${deps."h2"."0.1.16"."log"}" deps)
    (features_.slab."${deps."h2"."0.1.16"."slab"}" deps)
    (features_.string."${deps."h2"."0.1.16"."string"}" deps)
    (features_.tokio_io."${deps."h2"."0.1.16"."tokio_io"}" deps)
  ];


# end
# hex-0.3.2

  crates.hex."0.3.2" = deps: { features?(features_.hex."0.3.2" deps {}) }: buildRustCrate {
    crateName = "hex";
    version = "0.3.2";
    authors = [ "KokaKiwi <kokakiwi@kokakiwi.net>" ];
    sha256 = "0hs0xfb4x67y4ss9mmbjmibkwakbn3xf23i21m409bw2zqk9b6kz";
    features = mkFeatures (features."hex"."0.3.2" or {});
  };
  features_.hex."0.3.2" = deps: f: updateFeatures f (rec {
    hex."0.3.2".default = (f.hex."0.3.2".default or true);
  }) [];


# end
# hmac-0.5.0

  crates.hmac."0.5.0" = deps: { features?(features_.hmac."0.5.0" deps {}) }: buildRustCrate {
    crateName = "hmac";
    version = "0.5.0";
    authors = [ "RustCrypto Developers" ];
    sha256 = "0zh24045j67cwbm5bm9xrbdigxrjmqki105m03xmkq3zb8dj869b";
    dependencies = mapFeatures features ([
      (crates."crypto_mac"."${deps."hmac"."0.5.0"."crypto_mac"}" deps)
      (crates."digest"."${deps."hmac"."0.5.0"."digest"}" deps)
    ]);
  };
  features_.hmac."0.5.0" = deps: f: updateFeatures f (rec {
    crypto_mac."${deps.hmac."0.5.0".crypto_mac}".default = true;
    digest."${deps.hmac."0.5.0".digest}".default = true;
    hmac."0.5.0".default = (f.hmac."0.5.0".default or true);
  }) [
    (features_.crypto_mac."${deps."hmac"."0.5.0"."crypto_mac"}" deps)
    (features_.digest."${deps."hmac"."0.5.0"."digest"}" deps)
  ];


# end
# html5ever-0.22.5

  crates.html5ever."0.22.5" = deps: { features?(features_.html5ever."0.22.5" deps {}) }: buildRustCrate {
    crateName = "html5ever";
    version = "0.22.5";
    authors = [ "The html5ever Project Developers" ];
    sha256 = "1hbkxvy4za50y78h1dv6h75cpj83iwg6df94nyj003j7nvq5zchf";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."html5ever"."0.22.5"."log"}" deps)
      (crates."mac"."${deps."html5ever"."0.22.5"."mac"}" deps)
      (crates."markup5ever"."${deps."html5ever"."0.22.5"."markup5ever"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."html5ever"."0.22.5"."proc_macro2"}" deps)
      (crates."quote"."${deps."html5ever"."0.22.5"."quote"}" deps)
      (crates."syn"."${deps."html5ever"."0.22.5"."syn"}" deps)
    ]);
  };
  features_.html5ever."0.22.5" = deps: f: updateFeatures f (rec {
    html5ever."0.22.5".default = (f.html5ever."0.22.5".default or true);
    log."${deps.html5ever."0.22.5".log}".default = true;
    mac."${deps.html5ever."0.22.5".mac}".default = true;
    markup5ever."${deps.html5ever."0.22.5".markup5ever}".default = true;
    proc_macro2."${deps.html5ever."0.22.5".proc_macro2}".default = true;
    quote."${deps.html5ever."0.22.5".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.html5ever."0.22.5".syn}"."extra-traits" = true; }
      { "${deps.html5ever."0.22.5".syn}"."fold" = true; }
      { "${deps.html5ever."0.22.5".syn}"."full" = true; }
      { "${deps.html5ever."0.22.5".syn}".default = true; }
    ];
  }) [
    (features_.log."${deps."html5ever"."0.22.5"."log"}" deps)
    (features_.mac."${deps."html5ever"."0.22.5"."mac"}" deps)
    (features_.markup5ever."${deps."html5ever"."0.22.5"."markup5ever"}" deps)
    (features_.proc_macro2."${deps."html5ever"."0.22.5"."proc_macro2"}" deps)
    (features_.quote."${deps."html5ever"."0.22.5"."quote"}" deps)
    (features_.syn."${deps."html5ever"."0.22.5"."syn"}" deps)
  ];


# end
# http-0.1.16

  crates.http."0.1.16" = deps: { features?(features_.http."0.1.16" deps {}) }: buildRustCrate {
    crateName = "http";
    version = "0.1.16";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Carl Lerche <me@carllerche.com>" "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "0s0sghi8j8lr1frra38pz4p7nhav80ys0jpc7k2fsrn9m9k1dj1q";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."http"."0.1.16"."bytes"}" deps)
      (crates."fnv"."${deps."http"."0.1.16"."fnv"}" deps)
      (crates."itoa"."${deps."http"."0.1.16"."itoa"}" deps)
    ]);
  };
  features_.http."0.1.16" = deps: f: updateFeatures f (rec {
    bytes."${deps.http."0.1.16".bytes}".default = true;
    fnv."${deps.http."0.1.16".fnv}".default = true;
    http."0.1.16".default = (f.http."0.1.16".default or true);
    itoa."${deps.http."0.1.16".itoa}".default = true;
  }) [
    (features_.bytes."${deps."http"."0.1.16"."bytes"}" deps)
    (features_.fnv."${deps."http"."0.1.16"."fnv"}" deps)
    (features_.itoa."${deps."http"."0.1.16"."itoa"}" deps)
  ];


# end
# httparse-1.3.3

  crates.httparse."1.3.3" = deps: { features?(features_.httparse."1.3.3" deps {}) }: buildRustCrate {
    crateName = "httparse";
    version = "1.3.3";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1jymxy4bl0mzgp2dx0pzqzbr72sw5jmr5sjqiry4xr88z4z9qlyx";
    build = "build.rs";
    features = mkFeatures (features."httparse"."1.3.3" or {});
  };
  features_.httparse."1.3.3" = deps: f: updateFeatures f (rec {
    httparse = fold recursiveUpdate {} [
      { "1.3.3".default = (f.httparse."1.3.3".default or true); }
      { "1.3.3".std =
        (f.httparse."1.3.3".std or false) ||
        (f.httparse."1.3.3".default or false) ||
        (httparse."1.3.3"."default" or false); }
    ];
  }) [];


# end
# httpdate-0.3.2

  crates.httpdate."0.3.2" = deps: { features?(features_.httpdate."0.3.2" deps {}) }: buildRustCrate {
    crateName = "httpdate";
    version = "0.3.2";
    authors = [ "Pyfisch <pyfisch@gmail.com>" ];
    sha256 = "1l9qlv48h0jr8vkhblddxhlj2pxqfn7fx6gcg3k15x0mwdnspz81";
    features = mkFeatures (features."httpdate"."0.3.2" or {});
  };
  features_.httpdate."0.3.2" = deps: f: updateFeatures f (rec {
    httpdate."0.3.2".default = (f.httpdate."0.3.2".default or true);
  }) [];


# end
# humantime-1.1.1

  crates.humantime."1.1.1" = deps: { features?(features_.humantime."1.1.1" deps {}) }: buildRustCrate {
    crateName = "humantime";
    version = "1.1.1";
    authors = [ "Paul Colomiets <paul@colomiets.name>" ];
    sha256 = "1lzdfsfzdikcp1qb6wcdvnsdv16pmzr7p7cv171vnbnyz2lrwbgn";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."quick_error"."${deps."humantime"."1.1.1"."quick_error"}" deps)
    ]);
  };
  features_.humantime."1.1.1" = deps: f: updateFeatures f (rec {
    humantime."1.1.1".default = (f.humantime."1.1.1".default or true);
    quick_error."${deps.humantime."1.1.1".quick_error}".default = true;
  }) [
    (features_.quick_error."${deps."humantime"."1.1.1"."quick_error"}" deps)
  ];


# end
# humantime-1.2.0

  crates.humantime."1.2.0" = deps: { features?(features_.humantime."1.2.0" deps {}) }: buildRustCrate {
    crateName = "humantime";
    version = "1.2.0";
    authors = [ "Paul Colomiets <paul@colomiets.name>" ];
    sha256 = "0wlcxzz2mhq0brkfbjb12hc6jm17bgm8m6pdgblw4qjwmf26aw28";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."quick_error"."${deps."humantime"."1.2.0"."quick_error"}" deps)
    ]);
  };
  features_.humantime."1.2.0" = deps: f: updateFeatures f (rec {
    humantime."1.2.0".default = (f.humantime."1.2.0".default or true);
    quick_error."${deps.humantime."1.2.0".quick_error}".default = true;
  }) [
    (features_.quick_error."${deps."humantime"."1.2.0"."quick_error"}" deps)
  ];


# end
# hyper-0.12.25

  crates.hyper."0.12.25" = deps: { features?(features_.hyper."0.12.25" deps {}) }: buildRustCrate {
    crateName = "hyper";
    version = "0.12.25";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1qsxj2azsm2p24hpc1h5ihlpc54z8qiijh9ym75wlwdgwa5rq2y3";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."hyper"."0.12.25"."bytes"}" deps)
      (crates."futures"."${deps."hyper"."0.12.25"."futures"}" deps)
      (crates."h2"."${deps."hyper"."0.12.25"."h2"}" deps)
      (crates."http"."${deps."hyper"."0.12.25"."http"}" deps)
      (crates."httparse"."${deps."hyper"."0.12.25"."httparse"}" deps)
      (crates."iovec"."${deps."hyper"."0.12.25"."iovec"}" deps)
      (crates."itoa"."${deps."hyper"."0.12.25"."itoa"}" deps)
      (crates."log"."${deps."hyper"."0.12.25"."log"}" deps)
      (crates."time"."${deps."hyper"."0.12.25"."time"}" deps)
      (crates."tokio_io"."${deps."hyper"."0.12.25"."tokio_io"}" deps)
      (crates."want"."${deps."hyper"."0.12.25"."want"}" deps)
    ]
      ++ (if features.hyper."0.12.25".futures-cpupool or false then [ (crates.futures_cpupool."${deps."hyper"."0.12.25".futures_cpupool}" deps) ] else [])
      ++ (if features.hyper."0.12.25".net2 or false then [ (crates.net2."${deps."hyper"."0.12.25".net2}" deps) ] else [])
      ++ (if features.hyper."0.12.25".tokio or false then [ (crates.tokio."${deps."hyper"."0.12.25".tokio}" deps) ] else [])
      ++ (if features.hyper."0.12.25".tokio-executor or false then [ (crates.tokio_executor."${deps."hyper"."0.12.25".tokio_executor}" deps) ] else [])
      ++ (if features.hyper."0.12.25".tokio-reactor or false then [ (crates.tokio_reactor."${deps."hyper"."0.12.25".tokio_reactor}" deps) ] else [])
      ++ (if features.hyper."0.12.25".tokio-tcp or false then [ (crates.tokio_tcp."${deps."hyper"."0.12.25".tokio_tcp}" deps) ] else [])
      ++ (if features.hyper."0.12.25".tokio-threadpool or false then [ (crates.tokio_threadpool."${deps."hyper"."0.12.25".tokio_threadpool}" deps) ] else [])
      ++ (if features.hyper."0.12.25".tokio-timer or false then [ (crates.tokio_timer."${deps."hyper"."0.12.25".tokio_timer}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."hyper"."0.12.25"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."hyper"."0.12.25" or {});
  };
  features_.hyper."0.12.25" = deps: f: updateFeatures f (rec {
    bytes."${deps.hyper."0.12.25".bytes}".default = true;
    futures."${deps.hyper."0.12.25".futures}".default = true;
    futures_cpupool."${deps.hyper."0.12.25".futures_cpupool}".default = true;
    h2."${deps.hyper."0.12.25".h2}".default = true;
    http."${deps.hyper."0.12.25".http}".default = true;
    httparse."${deps.hyper."0.12.25".httparse}".default = true;
    hyper = fold recursiveUpdate {} [
      { "0.12.25".__internal_flaky_tests =
        (f.hyper."0.12.25".__internal_flaky_tests or false) ||
        (f.hyper."0.12.25".default or false) ||
        (hyper."0.12.25"."default" or false); }
      { "0.12.25".default = (f.hyper."0.12.25".default or true); }
      { "0.12.25".futures-cpupool =
        (f.hyper."0.12.25".futures-cpupool or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".net2 =
        (f.hyper."0.12.25".net2 or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".runtime =
        (f.hyper."0.12.25".runtime or false) ||
        (f.hyper."0.12.25".default or false) ||
        (hyper."0.12.25"."default" or false); }
      { "0.12.25".tokio =
        (f.hyper."0.12.25".tokio or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".tokio-executor =
        (f.hyper."0.12.25".tokio-executor or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".tokio-reactor =
        (f.hyper."0.12.25".tokio-reactor or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".tokio-tcp =
        (f.hyper."0.12.25".tokio-tcp or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".tokio-threadpool =
        (f.hyper."0.12.25".tokio-threadpool or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
      { "0.12.25".tokio-timer =
        (f.hyper."0.12.25".tokio-timer or false) ||
        (f.hyper."0.12.25".runtime or false) ||
        (hyper."0.12.25"."runtime" or false); }
    ];
    iovec."${deps.hyper."0.12.25".iovec}".default = true;
    itoa."${deps.hyper."0.12.25".itoa}".default = true;
    log."${deps.hyper."0.12.25".log}".default = true;
    net2."${deps.hyper."0.12.25".net2}".default = true;
    rustc_version."${deps.hyper."0.12.25".rustc_version}".default = true;
    time."${deps.hyper."0.12.25".time}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.hyper."0.12.25".tokio}"."rt-full" = true; }
      { "${deps.hyper."0.12.25".tokio}".default = (f.tokio."${deps.hyper."0.12.25".tokio}".default or false); }
    ];
    tokio_executor."${deps.hyper."0.12.25".tokio_executor}".default = true;
    tokio_io."${deps.hyper."0.12.25".tokio_io}".default = true;
    tokio_reactor."${deps.hyper."0.12.25".tokio_reactor}".default = true;
    tokio_tcp."${deps.hyper."0.12.25".tokio_tcp}".default = true;
    tokio_threadpool."${deps.hyper."0.12.25".tokio_threadpool}".default = true;
    tokio_timer."${deps.hyper."0.12.25".tokio_timer}".default = true;
    want."${deps.hyper."0.12.25".want}".default = true;
  }) [
    (features_.bytes."${deps."hyper"."0.12.25"."bytes"}" deps)
    (features_.futures."${deps."hyper"."0.12.25"."futures"}" deps)
    (features_.futures_cpupool."${deps."hyper"."0.12.25"."futures_cpupool"}" deps)
    (features_.h2."${deps."hyper"."0.12.25"."h2"}" deps)
    (features_.http."${deps."hyper"."0.12.25"."http"}" deps)
    (features_.httparse."${deps."hyper"."0.12.25"."httparse"}" deps)
    (features_.iovec."${deps."hyper"."0.12.25"."iovec"}" deps)
    (features_.itoa."${deps."hyper"."0.12.25"."itoa"}" deps)
    (features_.log."${deps."hyper"."0.12.25"."log"}" deps)
    (features_.net2."${deps."hyper"."0.12.25"."net2"}" deps)
    (features_.time."${deps."hyper"."0.12.25"."time"}" deps)
    (features_.tokio."${deps."hyper"."0.12.25"."tokio"}" deps)
    (features_.tokio_executor."${deps."hyper"."0.12.25"."tokio_executor"}" deps)
    (features_.tokio_io."${deps."hyper"."0.12.25"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."hyper"."0.12.25"."tokio_reactor"}" deps)
    (features_.tokio_tcp."${deps."hyper"."0.12.25"."tokio_tcp"}" deps)
    (features_.tokio_threadpool."${deps."hyper"."0.12.25"."tokio_threadpool"}" deps)
    (features_.tokio_timer."${deps."hyper"."0.12.25"."tokio_timer"}" deps)
    (features_.want."${deps."hyper"."0.12.25"."want"}" deps)
    (features_.rustc_version."${deps."hyper"."0.12.25"."rustc_version"}" deps)
  ];


# end
# hyper-openssl-0.7.1

  crates.hyper_openssl."0.7.1" = deps: { features?(features_.hyper_openssl."0.7.1" deps {}) }: buildRustCrate {
    crateName = "hyper-openssl";
    version = "0.7.1";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1yi2z35ajyr7nc9zqiwhzsac9yirlqad0jyvrc216jdcnv7mjqld";
    dependencies = mapFeatures features ([
      (crates."antidote"."${deps."hyper_openssl"."0.7.1"."antidote"}" deps)
      (crates."bytes"."${deps."hyper_openssl"."0.7.1"."bytes"}" deps)
      (crates."futures"."${deps."hyper_openssl"."0.7.1"."futures"}" deps)
      (crates."hyper"."${deps."hyper_openssl"."0.7.1"."hyper"}" deps)
      (crates."lazy_static"."${deps."hyper_openssl"."0.7.1"."lazy_static"}" deps)
      (crates."linked_hash_set"."${deps."hyper_openssl"."0.7.1"."linked_hash_set"}" deps)
      (crates."openssl"."${deps."hyper_openssl"."0.7.1"."openssl"}" deps)
      (crates."openssl_sys"."${deps."hyper_openssl"."0.7.1"."openssl_sys"}" deps)
      (crates."tokio_io"."${deps."hyper_openssl"."0.7.1"."tokio_io"}" deps)
      (crates."tokio_openssl"."${deps."hyper_openssl"."0.7.1"."tokio_openssl"}" deps)
    ]);
    features = mkFeatures (features."hyper_openssl"."0.7.1" or {});
  };
  features_.hyper_openssl."0.7.1" = deps: f: updateFeatures f (rec {
    antidote."${deps.hyper_openssl."0.7.1".antidote}".default = true;
    bytes."${deps.hyper_openssl."0.7.1".bytes}".default = true;
    futures."${deps.hyper_openssl."0.7.1".futures}".default = true;
    hyper = fold recursiveUpdate {} [
      { "${deps.hyper_openssl."0.7.1".hyper}"."runtime" =
        (f.hyper."${deps.hyper_openssl."0.7.1".hyper}"."runtime" or false) ||
        (hyper_openssl."0.7.1"."runtime" or false) ||
        (f."hyper_openssl"."0.7.1"."runtime" or false); }
      { "${deps.hyper_openssl."0.7.1".hyper}".default = (f.hyper."${deps.hyper_openssl."0.7.1".hyper}".default or false); }
    ];
    hyper_openssl = fold recursiveUpdate {} [
      { "0.7.1".default = (f.hyper_openssl."0.7.1".default or true); }
      { "0.7.1".runtime =
        (f.hyper_openssl."0.7.1".runtime or false) ||
        (f.hyper_openssl."0.7.1".default or false) ||
        (hyper_openssl."0.7.1"."default" or false); }
    ];
    lazy_static."${deps.hyper_openssl."0.7.1".lazy_static}".default = true;
    linked_hash_set."${deps.hyper_openssl."0.7.1".linked_hash_set}".default = true;
    openssl."${deps.hyper_openssl."0.7.1".openssl}".default = true;
    openssl_sys."${deps.hyper_openssl."0.7.1".openssl_sys}".default = true;
    tokio_io."${deps.hyper_openssl."0.7.1".tokio_io}".default = true;
    tokio_openssl."${deps.hyper_openssl."0.7.1".tokio_openssl}".default = true;
  }) [
    (features_.antidote."${deps."hyper_openssl"."0.7.1"."antidote"}" deps)
    (features_.bytes."${deps."hyper_openssl"."0.7.1"."bytes"}" deps)
    (features_.futures."${deps."hyper_openssl"."0.7.1"."futures"}" deps)
    (features_.hyper."${deps."hyper_openssl"."0.7.1"."hyper"}" deps)
    (features_.lazy_static."${deps."hyper_openssl"."0.7.1"."lazy_static"}" deps)
    (features_.linked_hash_set."${deps."hyper_openssl"."0.7.1"."linked_hash_set"}" deps)
    (features_.openssl."${deps."hyper_openssl"."0.7.1"."openssl"}" deps)
    (features_.openssl_sys."${deps."hyper_openssl"."0.7.1"."openssl_sys"}" deps)
    (features_.tokio_io."${deps."hyper_openssl"."0.7.1"."tokio_io"}" deps)
    (features_.tokio_openssl."${deps."hyper_openssl"."0.7.1"."tokio_openssl"}" deps)
  ];


# end
# hyper-tls-0.3.1

  crates.hyper_tls."0.3.1" = deps: { features?(features_.hyper_tls."0.3.1" deps {}) }: buildRustCrate {
    crateName = "hyper-tls";
    version = "0.3.1";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "0sk46mmnccxgxwn62rl5m58c2ivwgxgd590cjwg60pjkhx9qn5r7";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."hyper_tls"."0.3.1"."bytes"}" deps)
      (crates."futures"."${deps."hyper_tls"."0.3.1"."futures"}" deps)
      (crates."hyper"."${deps."hyper_tls"."0.3.1"."hyper"}" deps)
      (crates."native_tls"."${deps."hyper_tls"."0.3.1"."native_tls"}" deps)
      (crates."tokio_io"."${deps."hyper_tls"."0.3.1"."tokio_io"}" deps)
    ]);
    features = mkFeatures (features."hyper_tls"."0.3.1" or {});
  };
  features_.hyper_tls."0.3.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.hyper_tls."0.3.1".bytes}".default = true;
    futures."${deps.hyper_tls."0.3.1".futures}".default = true;
    hyper."${deps.hyper_tls."0.3.1".hyper}".default = true;
    hyper_tls."0.3.1".default = (f.hyper_tls."0.3.1".default or true);
    native_tls = fold recursiveUpdate {} [
      { "${deps.hyper_tls."0.3.1".native_tls}"."vendored" =
        (f.native_tls."${deps.hyper_tls."0.3.1".native_tls}"."vendored" or false) ||
        (hyper_tls."0.3.1"."vendored" or false) ||
        (f."hyper_tls"."0.3.1"."vendored" or false); }
      { "${deps.hyper_tls."0.3.1".native_tls}".default = true; }
    ];
    tokio_io."${deps.hyper_tls."0.3.1".tokio_io}".default = true;
  }) [
    (features_.bytes."${deps."hyper_tls"."0.3.1"."bytes"}" deps)
    (features_.futures."${deps."hyper_tls"."0.3.1"."futures"}" deps)
    (features_.hyper."${deps."hyper_tls"."0.3.1"."hyper"}" deps)
    (features_.native_tls."${deps."hyper_tls"."0.3.1"."native_tls"}" deps)
    (features_.tokio_io."${deps."hyper_tls"."0.3.1"."tokio_io"}" deps)
  ];


# end
# idna-0.1.5

  crates.idna."0.1.5" = deps: { features?(features_.idna."0.1.5" deps {}) }: buildRustCrate {
    crateName = "idna";
    version = "0.1.5";
    authors = [ "The rust-url developers" ];
    sha256 = "1gwgl19rz5vzi67rrhamczhxy050f5ynx4ybabfapyalv7z1qmjy";
    dependencies = mapFeatures features ([
      (crates."matches"."${deps."idna"."0.1.5"."matches"}" deps)
      (crates."unicode_bidi"."${deps."idna"."0.1.5"."unicode_bidi"}" deps)
      (crates."unicode_normalization"."${deps."idna"."0.1.5"."unicode_normalization"}" deps)
    ]);
  };
  features_.idna."0.1.5" = deps: f: updateFeatures f (rec {
    idna."0.1.5".default = (f.idna."0.1.5".default or true);
    matches."${deps.idna."0.1.5".matches}".default = true;
    unicode_bidi."${deps.idna."0.1.5".unicode_bidi}".default = true;
    unicode_normalization."${deps.idna."0.1.5".unicode_normalization}".default = true;
  }) [
    (features_.matches."${deps."idna"."0.1.5"."matches"}" deps)
    (features_.unicode_bidi."${deps."idna"."0.1.5"."unicode_bidi"}" deps)
    (features_.unicode_normalization."${deps."idna"."0.1.5"."unicode_normalization"}" deps)
  ];


# end
# ignore-0.4.6

  crates.ignore."0.4.6" = deps: { features?(features_.ignore."0.4.6" deps {}) }: buildRustCrate {
    crateName = "ignore";
    version = "0.4.6";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1gx1dia1ws3qm2m7pxfnsp43i0wz2fkzn4yv6zxqzib7qp3cpzb6";
    dependencies = mapFeatures features ([
      (crates."crossbeam_channel"."${deps."ignore"."0.4.6"."crossbeam_channel"}" deps)
      (crates."globset"."${deps."ignore"."0.4.6"."globset"}" deps)
      (crates."lazy_static"."${deps."ignore"."0.4.6"."lazy_static"}" deps)
      (crates."log"."${deps."ignore"."0.4.6"."log"}" deps)
      (crates."memchr"."${deps."ignore"."0.4.6"."memchr"}" deps)
      (crates."regex"."${deps."ignore"."0.4.6"."regex"}" deps)
      (crates."same_file"."${deps."ignore"."0.4.6"."same_file"}" deps)
      (crates."thread_local"."${deps."ignore"."0.4.6"."thread_local"}" deps)
      (crates."walkdir"."${deps."ignore"."0.4.6"."walkdir"}" deps)
    ])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi_util"."${deps."ignore"."0.4.6"."winapi_util"}" deps)
    ]) else []);
    features = mkFeatures (features."ignore"."0.4.6" or {});
  };
  features_.ignore."0.4.6" = deps: f: updateFeatures f (rec {
    crossbeam_channel."${deps.ignore."0.4.6".crossbeam_channel}".default = true;
    globset = fold recursiveUpdate {} [
      { "${deps.ignore."0.4.6".globset}"."simd-accel" =
        (f.globset."${deps.ignore."0.4.6".globset}"."simd-accel" or false) ||
        (ignore."0.4.6"."simd-accel" or false) ||
        (f."ignore"."0.4.6"."simd-accel" or false); }
      { "${deps.ignore."0.4.6".globset}".default = true; }
    ];
    ignore."0.4.6".default = (f.ignore."0.4.6".default or true);
    lazy_static."${deps.ignore."0.4.6".lazy_static}".default = true;
    log."${deps.ignore."0.4.6".log}".default = true;
    memchr."${deps.ignore."0.4.6".memchr}".default = true;
    regex."${deps.ignore."0.4.6".regex}".default = true;
    same_file."${deps.ignore."0.4.6".same_file}".default = true;
    thread_local."${deps.ignore."0.4.6".thread_local}".default = true;
    walkdir."${deps.ignore."0.4.6".walkdir}".default = true;
    winapi_util."${deps.ignore."0.4.6".winapi_util}".default = true;
  }) [
    (features_.crossbeam_channel."${deps."ignore"."0.4.6"."crossbeam_channel"}" deps)
    (features_.globset."${deps."ignore"."0.4.6"."globset"}" deps)
    (features_.lazy_static."${deps."ignore"."0.4.6"."lazy_static"}" deps)
    (features_.log."${deps."ignore"."0.4.6"."log"}" deps)
    (features_.memchr."${deps."ignore"."0.4.6"."memchr"}" deps)
    (features_.regex."${deps."ignore"."0.4.6"."regex"}" deps)
    (features_.same_file."${deps."ignore"."0.4.6"."same_file"}" deps)
    (features_.thread_local."${deps."ignore"."0.4.6"."thread_local"}" deps)
    (features_.walkdir."${deps."ignore"."0.4.6"."walkdir"}" deps)
    (features_.winapi_util."${deps."ignore"."0.4.6"."winapi_util"}" deps)
  ];


# end
# image-0.21.0

  crates.image."0.21.0" = deps: { features?(features_.image."0.21.0" deps {}) }: buildRustCrate {
    crateName = "image";
    version = "0.21.0";
    authors = [ "ccgn" "bvssvni <bvssvni@gmail.com>" "nwin" "TyOverby <ty@pre-alpha.com>" "HeroicKatora" "Calum" "CensoredUsername <cens.username@gmail.com>" "fintelia <fintelia@gmail.com>" ];
    sha256 = "1hb8m5w100qh9x1arz2g25z3jj1m0rkkmrhnb5ha6309i0287x7k";
    libPath = "./src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."image"."0.21.0"."byteorder"}" deps)
      (crates."lzw"."${deps."image"."0.21.0"."lzw"}" deps)
      (crates."num_iter"."${deps."image"."0.21.0"."num_iter"}" deps)
      (crates."num_rational"."${deps."image"."0.21.0"."num_rational"}" deps)
      (crates."num_traits"."${deps."image"."0.21.0"."num_traits"}" deps)
      (crates."safe_transmute"."${deps."image"."0.21.0"."safe_transmute"}" deps)
    ]
      ++ (if features.image."0.21.0".gif or false then [ (crates.gif."${deps."image"."0.21.0".gif}" deps) ] else [])
      ++ (if features.image."0.21.0".jpeg-decoder or false then [ (crates.jpeg_decoder."${deps."image"."0.21.0".jpeg_decoder}" deps) ] else [])
      ++ (if features.image."0.21.0".png or false then [ (crates.png."${deps."image"."0.21.0".png}" deps) ] else [])
      ++ (if features.image."0.21.0".scoped_threadpool or false then [ (crates.scoped_threadpool."${deps."image"."0.21.0".scoped_threadpool}" deps) ] else [])
      ++ (if features.image."0.21.0".tiff or false then [ (crates.tiff."${deps."image"."0.21.0".tiff}" deps) ] else []));
    features = mkFeatures (features."image"."0.21.0" or {});
  };
  features_.image."0.21.0" = deps: f: updateFeatures f (rec {
    byteorder."${deps.image."0.21.0".byteorder}".default = true;
    gif."${deps.image."0.21.0".gif}".default = true;
    image = fold recursiveUpdate {} [
      { "0.21.0".bmp =
        (f.image."0.21.0".bmp or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false) ||
        (f.image."0.21.0".ico or false) ||
        (image."0.21.0"."ico" or false); }
      { "0.21.0".default = (f.image."0.21.0".default or true); }
      { "0.21.0".dxt =
        (f.image."0.21.0".dxt or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".gif =
        (f.image."0.21.0".gif or false) ||
        (f.image."0.21.0".gif_codec or false) ||
        (image."0.21.0"."gif_codec" or false); }
      { "0.21.0".gif_codec =
        (f.image."0.21.0".gif_codec or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".hdr =
        (f.image."0.21.0".hdr or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".ico =
        (f.image."0.21.0".ico or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".jpeg =
        (f.image."0.21.0".jpeg or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".jpeg-decoder =
        (f.image."0.21.0".jpeg-decoder or false) ||
        (f.image."0.21.0".jpeg or false) ||
        (image."0.21.0"."jpeg" or false); }
      { "0.21.0".jpeg_rayon =
        (f.image."0.21.0".jpeg_rayon or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".png =
        (f.image."0.21.0".png or false) ||
        (f.image."0.21.0".png_codec or false) ||
        (image."0.21.0"."png_codec" or false); }
      { "0.21.0".png_codec =
        (f.image."0.21.0".png_codec or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false) ||
        (f.image."0.21.0".ico or false) ||
        (image."0.21.0"."ico" or false); }
      { "0.21.0".pnm =
        (f.image."0.21.0".pnm or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".scoped_threadpool =
        (f.image."0.21.0".scoped_threadpool or false) ||
        (f.image."0.21.0".hdr or false) ||
        (image."0.21.0"."hdr" or false); }
      { "0.21.0".tga =
        (f.image."0.21.0".tga or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".tiff =
        (f.image."0.21.0".tiff or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
      { "0.21.0".webp =
        (f.image."0.21.0".webp or false) ||
        (f.image."0.21.0".default or false) ||
        (image."0.21.0"."default" or false); }
    ];
    jpeg_decoder = fold recursiveUpdate {} [
      { "${deps.image."0.21.0".jpeg_decoder}"."rayon" =
        (f.jpeg_decoder."${deps.image."0.21.0".jpeg_decoder}"."rayon" or false) ||
        (image."0.21.0"."jpeg_rayon" or false) ||
        (f."image"."0.21.0"."jpeg_rayon" or false); }
      { "${deps.image."0.21.0".jpeg_decoder}".default = (f.jpeg_decoder."${deps.image."0.21.0".jpeg_decoder}".default or false); }
    ];
    lzw."${deps.image."0.21.0".lzw}".default = true;
    num_iter."${deps.image."0.21.0".num_iter}".default = true;
    num_rational."${deps.image."0.21.0".num_rational}".default = (f.num_rational."${deps.image."0.21.0".num_rational}".default or false);
    num_traits."${deps.image."0.21.0".num_traits}".default = true;
    png."${deps.image."0.21.0".png}".default = true;
    safe_transmute."${deps.image."0.21.0".safe_transmute}".default = true;
    scoped_threadpool."${deps.image."0.21.0".scoped_threadpool}".default = true;
    tiff."${deps.image."0.21.0".tiff}".default = true;
  }) [
    (features_.byteorder."${deps."image"."0.21.0"."byteorder"}" deps)
    (features_.gif."${deps."image"."0.21.0"."gif"}" deps)
    (features_.jpeg_decoder."${deps."image"."0.21.0"."jpeg_decoder"}" deps)
    (features_.lzw."${deps."image"."0.21.0"."lzw"}" deps)
    (features_.num_iter."${deps."image"."0.21.0"."num_iter"}" deps)
    (features_.num_rational."${deps."image"."0.21.0"."num_rational"}" deps)
    (features_.num_traits."${deps."image"."0.21.0"."num_traits"}" deps)
    (features_.png."${deps."image"."0.21.0"."png"}" deps)
    (features_.safe_transmute."${deps."image"."0.21.0"."safe_transmute"}" deps)
    (features_.scoped_threadpool."${deps."image"."0.21.0"."scoped_threadpool"}" deps)
    (features_.tiff."${deps."image"."0.21.0"."tiff"}" deps)
  ];


# end
# indexmap-1.0.2

  crates.indexmap."1.0.2" = deps: { features?(features_.indexmap."1.0.2" deps {}) }: buildRustCrate {
    crateName = "indexmap";
    version = "1.0.2";
    authors = [ "bluss" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "18a0cn5xy3a7wswxg5lwfg3j4sh5blk28ykw0ysgr486djd353gf";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."indexmap"."1.0.2" or {});
  };
  features_.indexmap."1.0.2" = deps: f: updateFeatures f (rec {
    indexmap = fold recursiveUpdate {} [
      { "1.0.2".default = (f.indexmap."1.0.2".default or true); }
      { "1.0.2".serde =
        (f.indexmap."1.0.2".serde or false) ||
        (f.indexmap."1.0.2".serde-1 or false) ||
        (indexmap."1.0.2"."serde-1" or false); }
    ];
  }) [];


# end
# inflate-0.4.5

  crates.inflate."0.4.5" = deps: { features?(features_.inflate."0.4.5" deps {}) }: buildRustCrate {
    crateName = "inflate";
    version = "0.4.5";
    authors = [ "nwin <nwin@users.noreply.github.com>" ];
    sha256 = "0dq5n218vdckp4q1m8b4vpg14bk3x98dvxcg51780ps0hpa2c9sm";
    dependencies = mapFeatures features ([
      (crates."adler32"."${deps."inflate"."0.4.5"."adler32"}" deps)
    ]);
    features = mkFeatures (features."inflate"."0.4.5" or {});
  };
  features_.inflate."0.4.5" = deps: f: updateFeatures f (rec {
    adler32."${deps.inflate."0.4.5".adler32}".default = true;
    inflate."0.4.5".default = (f.inflate."0.4.5".default or true);
  }) [
    (features_.adler32."${deps."inflate"."0.4.5"."adler32"}" deps)
  ];


# end
# iovec-0.1.2

  crates.iovec."0.1.2" = deps: { features?(features_.iovec."0.1.2" deps {}) }: buildRustCrate {
    crateName = "iovec";
    version = "0.1.2";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0vjymmb7wj4v4kza5jjn48fcdb85j3k37y7msjl3ifz0p9yiyp2r";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."iovec"."0.1.2"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."iovec"."0.1.2"."winapi"}" deps)
    ]) else []);
  };
  features_.iovec."0.1.2" = deps: f: updateFeatures f (rec {
    iovec."0.1.2".default = (f.iovec."0.1.2".default or true);
    libc."${deps.iovec."0.1.2".libc}".default = true;
    winapi."${deps.iovec."0.1.2".winapi}".default = true;
  }) [
    (features_.libc."${deps."iovec"."0.1.2"."libc"}" deps)
    (features_.winapi."${deps."iovec"."0.1.2"."winapi"}" deps)
  ];


# end
# itertools-0.7.8

  crates.itertools."0.7.8" = deps: { features?(features_.itertools."0.7.8" deps {}) }: buildRustCrate {
    crateName = "itertools";
    version = "0.7.8";
    authors = [ "bluss" ];
    sha256 = "0ib30cd7d1icjxsa13mji1gry3grp72kx8p33yd84mphdbc3d357";
    dependencies = mapFeatures features ([
      (crates."either"."${deps."itertools"."0.7.8"."either"}" deps)
    ]);
    features = mkFeatures (features."itertools"."0.7.8" or {});
  };
  features_.itertools."0.7.8" = deps: f: updateFeatures f (rec {
    either."${deps.itertools."0.7.8".either}".default = (f.either."${deps.itertools."0.7.8".either}".default or false);
    itertools = fold recursiveUpdate {} [
      { "0.7.8".default = (f.itertools."0.7.8".default or true); }
      { "0.7.8".use_std =
        (f.itertools."0.7.8".use_std or false) ||
        (f.itertools."0.7.8".default or false) ||
        (itertools."0.7.8"."default" or false); }
    ];
  }) [
    (features_.either."${deps."itertools"."0.7.8"."either"}" deps)
  ];


# end
# itertools-0.8.0

  crates.itertools."0.8.0" = deps: { features?(features_.itertools."0.8.0" deps {}) }: buildRustCrate {
    crateName = "itertools";
    version = "0.8.0";
    authors = [ "bluss" ];
    sha256 = "0xpz59yf03vyj540i7sqypn2aqfid08c4vzyg0l6rqm08da77n7n";
    dependencies = mapFeatures features ([
      (crates."either"."${deps."itertools"."0.8.0"."either"}" deps)
    ]);
    features = mkFeatures (features."itertools"."0.8.0" or {});
  };
  features_.itertools."0.8.0" = deps: f: updateFeatures f (rec {
    either."${deps.itertools."0.8.0".either}".default = (f.either."${deps.itertools."0.8.0".either}".default or false);
    itertools = fold recursiveUpdate {} [
      { "0.8.0".default = (f.itertools."0.8.0".default or true); }
      { "0.8.0".use_std =
        (f.itertools."0.8.0".use_std or false) ||
        (f.itertools."0.8.0".default or false) ||
        (itertools."0.8.0"."default" or false); }
    ];
  }) [
    (features_.either."${deps."itertools"."0.8.0"."either"}" deps)
  ];


# end
# itoa-0.4.3

  crates.itoa."0.4.3" = deps: { features?(features_.itoa."0.4.3" deps {}) }: buildRustCrate {
    crateName = "itoa";
    version = "0.4.3";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0zadimmdgvili3gdwxqg7ljv3r4wcdg1kkdfp9nl15vnm23vrhy1";
    features = mkFeatures (features."itoa"."0.4.3" or {});
  };
  features_.itoa."0.4.3" = deps: f: updateFeatures f (rec {
    itoa = fold recursiveUpdate {} [
      { "0.4.3".default = (f.itoa."0.4.3".default or true); }
      { "0.4.3".std =
        (f.itoa."0.4.3".std or false) ||
        (f.itoa."0.4.3".default or false) ||
        (itoa."0.4.3"."default" or false); }
    ];
  }) [];


# end
# jpeg-decoder-0.1.15

  crates.jpeg_decoder."0.1.15" = deps: { features?(features_.jpeg_decoder."0.1.15" deps {}) }: buildRustCrate {
    crateName = "jpeg-decoder";
    version = "0.1.15";
    authors = [ "Ulf Nilsson <kaksmet@gmail.com>" ];
    sha256 = "10hqj11lcq8q1p97470dgqwx0wjs81ib7kr1gqyk0nff320vj48c";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."jpeg_decoder"."0.1.15"."byteorder"}" deps)
    ]
      ++ (if features.jpeg_decoder."0.1.15".rayon or false then [ (crates.rayon."${deps."jpeg_decoder"."0.1.15".rayon}" deps) ] else []));
    features = mkFeatures (features."jpeg_decoder"."0.1.15" or {});
  };
  features_.jpeg_decoder."0.1.15" = deps: f: updateFeatures f (rec {
    byteorder."${deps.jpeg_decoder."0.1.15".byteorder}".default = true;
    jpeg_decoder = fold recursiveUpdate {} [
      { "0.1.15".default = (f.jpeg_decoder."0.1.15".default or true); }
      { "0.1.15".rayon =
        (f.jpeg_decoder."0.1.15".rayon or false) ||
        (f.jpeg_decoder."0.1.15".default or false) ||
        (jpeg_decoder."0.1.15"."default" or false); }
    ];
    rayon."${deps.jpeg_decoder."0.1.15".rayon}".default = true;
  }) [
    (features_.byteorder."${deps."jpeg_decoder"."0.1.15"."byteorder"}" deps)
    (features_.rayon."${deps."jpeg_decoder"."0.1.15"."rayon"}" deps)
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
# lalrpop-0.16.3

  crates.lalrpop."0.16.3" = deps: { features?(features_.lalrpop."0.16.3" deps {}) }: buildRustCrate {
    crateName = "lalrpop";
    version = "0.16.3";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" ];
    sha256 = "0fa99vi4s463kf0mj7y0pfisx5zskl2vgzcxgva3904bm6nz3ssd";
    dependencies = mapFeatures features ([
      (crates."ascii_canvas"."${deps."lalrpop"."0.16.3"."ascii_canvas"}" deps)
      (crates."atty"."${deps."lalrpop"."0.16.3"."atty"}" deps)
      (crates."bit_set"."${deps."lalrpop"."0.16.3"."bit_set"}" deps)
      (crates."diff"."${deps."lalrpop"."0.16.3"."diff"}" deps)
      (crates."docopt"."${deps."lalrpop"."0.16.3"."docopt"}" deps)
      (crates."ena"."${deps."lalrpop"."0.16.3"."ena"}" deps)
      (crates."itertools"."${deps."lalrpop"."0.16.3"."itertools"}" deps)
      (crates."lalrpop_util"."${deps."lalrpop"."0.16.3"."lalrpop_util"}" deps)
      (crates."petgraph"."${deps."lalrpop"."0.16.3"."petgraph"}" deps)
      (crates."regex"."${deps."lalrpop"."0.16.3"."regex"}" deps)
      (crates."regex_syntax"."${deps."lalrpop"."0.16.3"."regex_syntax"}" deps)
      (crates."serde"."${deps."lalrpop"."0.16.3"."serde"}" deps)
      (crates."serde_derive"."${deps."lalrpop"."0.16.3"."serde_derive"}" deps)
      (crates."sha2"."${deps."lalrpop"."0.16.3"."sha2"}" deps)
      (crates."string_cache"."${deps."lalrpop"."0.16.3"."string_cache"}" deps)
      (crates."term"."${deps."lalrpop"."0.16.3"."term"}" deps)
      (crates."unicode_xid"."${deps."lalrpop"."0.16.3"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."lalrpop"."0.16.3" or {});
  };
  features_.lalrpop."0.16.3" = deps: f: updateFeatures f (rec {
    ascii_canvas."${deps.lalrpop."0.16.3".ascii_canvas}".default = true;
    atty."${deps.lalrpop."0.16.3".atty}".default = true;
    bit_set."${deps.lalrpop."0.16.3".bit_set}".default = true;
    diff."${deps.lalrpop."0.16.3".diff}".default = true;
    docopt."${deps.lalrpop."0.16.3".docopt}".default = true;
    ena."${deps.lalrpop."0.16.3".ena}".default = true;
    itertools."${deps.lalrpop."0.16.3".itertools}".default = true;
    lalrpop."0.16.3".default = (f.lalrpop."0.16.3".default or true);
    lalrpop_util."${deps.lalrpop."0.16.3".lalrpop_util}".default = true;
    petgraph."${deps.lalrpop."0.16.3".petgraph}".default = true;
    regex."${deps.lalrpop."0.16.3".regex}".default = true;
    regex_syntax."${deps.lalrpop."0.16.3".regex_syntax}".default = true;
    serde."${deps.lalrpop."0.16.3".serde}".default = true;
    serde_derive."${deps.lalrpop."0.16.3".serde_derive}".default = true;
    sha2."${deps.lalrpop."0.16.3".sha2}".default = true;
    string_cache."${deps.lalrpop."0.16.3".string_cache}".default = true;
    term."${deps.lalrpop."0.16.3".term}".default = true;
    unicode_xid."${deps.lalrpop."0.16.3".unicode_xid}".default = true;
  }) [
    (features_.ascii_canvas."${deps."lalrpop"."0.16.3"."ascii_canvas"}" deps)
    (features_.atty."${deps."lalrpop"."0.16.3"."atty"}" deps)
    (features_.bit_set."${deps."lalrpop"."0.16.3"."bit_set"}" deps)
    (features_.diff."${deps."lalrpop"."0.16.3"."diff"}" deps)
    (features_.docopt."${deps."lalrpop"."0.16.3"."docopt"}" deps)
    (features_.ena."${deps."lalrpop"."0.16.3"."ena"}" deps)
    (features_.itertools."${deps."lalrpop"."0.16.3"."itertools"}" deps)
    (features_.lalrpop_util."${deps."lalrpop"."0.16.3"."lalrpop_util"}" deps)
    (features_.petgraph."${deps."lalrpop"."0.16.3"."petgraph"}" deps)
    (features_.regex."${deps."lalrpop"."0.16.3"."regex"}" deps)
    (features_.regex_syntax."${deps."lalrpop"."0.16.3"."regex_syntax"}" deps)
    (features_.serde."${deps."lalrpop"."0.16.3"."serde"}" deps)
    (features_.serde_derive."${deps."lalrpop"."0.16.3"."serde_derive"}" deps)
    (features_.sha2."${deps."lalrpop"."0.16.3"."sha2"}" deps)
    (features_.string_cache."${deps."lalrpop"."0.16.3"."string_cache"}" deps)
    (features_.term."${deps."lalrpop"."0.16.3"."term"}" deps)
    (features_.unicode_xid."${deps."lalrpop"."0.16.3"."unicode_xid"}" deps)
  ];


# end
# lalrpop-util-0.16.3

  crates.lalrpop_util."0.16.3" = deps: { features?(features_.lalrpop_util."0.16.3" deps {}) }: buildRustCrate {
    crateName = "lalrpop-util";
    version = "0.16.3";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" ];
    sha256 = "0m0735kf9g6wm33xkb32fsndfw393fqp0jzjvwpcn1ywshdhxlk9";
  };
  features_.lalrpop_util."0.16.3" = deps: f: updateFeatures f (rec {
    lalrpop_util."0.16.3".default = (f.lalrpop_util."0.16.3".default or true);
  }) [];


# end
# lazy_static-1.1.0

  crates.lazy_static."1.1.0" = deps: { features?(features_.lazy_static."1.1.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.1.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1da2b6nxfc2l547qgl9kd1pn9sh1af96a6qx6xw8xdnv6hh5fag0";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."lazy_static"."1.1.0"."version_check"}" deps)
    ]);
    features = mkFeatures (features."lazy_static"."1.1.0" or {});
  };
  features_.lazy_static."1.1.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.1.0".default = (f.lazy_static."1.1.0".default or true); }
      { "1.1.0".nightly =
        (f.lazy_static."1.1.0".nightly or false) ||
        (f.lazy_static."1.1.0".spin_no_std or false) ||
        (lazy_static."1.1.0"."spin_no_std" or false); }
      { "1.1.0".spin =
        (f.lazy_static."1.1.0".spin or false) ||
        (f.lazy_static."1.1.0".spin_no_std or false) ||
        (lazy_static."1.1.0"."spin_no_std" or false); }
    ];
    version_check."${deps.lazy_static."1.1.0".version_check}".default = true;
  }) [
    (features_.version_check."${deps."lazy_static"."1.1.0"."version_check"}" deps)
  ];


# end
# lazy_static-1.3.0

  crates.lazy_static."1.3.0" = deps: { features?(features_.lazy_static."1.3.0" deps {}) }: buildRustCrate {
    crateName = "lazy_static";
    version = "1.3.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1vv47va18ydk7dx5paz88g3jy1d3lwbx6qpxkbj8gyfv770i4b1y";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazy_static"."1.3.0" or {});
  };
  features_.lazy_static."1.3.0" = deps: f: updateFeatures f (rec {
    lazy_static = fold recursiveUpdate {} [
      { "1.3.0".default = (f.lazy_static."1.3.0".default or true); }
      { "1.3.0".spin =
        (f.lazy_static."1.3.0".spin or false) ||
        (f.lazy_static."1.3.0".spin_no_std or false) ||
        (lazy_static."1.3.0"."spin_no_std" or false); }
    ];
  }) [];


# end
# lazycell-1.2.1

  crates.lazycell."1.2.1" = deps: { features?(features_.lazycell."1.2.1" deps {}) }: buildRustCrate {
    crateName = "lazycell";
    version = "1.2.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "1m4h2q9rgxrgc7xjnws1x81lrb68jll8w3pykx1a9bhr29q2mcwm";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."lazycell"."1.2.1" or {});
  };
  features_.lazycell."1.2.1" = deps: f: updateFeatures f (rec {
    lazycell = fold recursiveUpdate {} [
      { "1.2.1".clippy =
        (f.lazycell."1.2.1".clippy or false) ||
        (f.lazycell."1.2.1".nightly-testing or false) ||
        (lazycell."1.2.1"."nightly-testing" or false); }
      { "1.2.1".default = (f.lazycell."1.2.1".default or true); }
      { "1.2.1".nightly =
        (f.lazycell."1.2.1".nightly or false) ||
        (f.lazycell."1.2.1".nightly-testing or false) ||
        (lazycell."1.2.1"."nightly-testing" or false); }
    ];
  }) [];


# end
# libc-0.2.43

  crates.libc."0.2.43" = deps: { features?(features_.libc."0.2.43" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.43";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0pshydmsq71kl9276zc2928ld50sp524ixcqkcqsgq410dx6c50b";
    features = mkFeatures (features."libc"."0.2.43" or {});
  };
  features_.libc."0.2.43" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.43".default = (f.libc."0.2.43".default or true); }
      { "0.2.43".use_std =
        (f.libc."0.2.43".use_std or false) ||
        (f.libc."0.2.43".default or false) ||
        (libc."0.2.43"."default" or false); }
    ];
  }) [];


# end
# libc-0.2.50

  crates.libc."0.2.50" = deps: { features?(features_.libc."0.2.50" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.50";
    authors = [ "The Rust Project Developers" ];
    sha256 = "14y4zm0xp2xbj3l1kxqf2wpl58xb7hglxdbfx5dcxjlchbvk5dzs";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.50" or {});
  };
  features_.libc."0.2.50" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.50".align =
        (f.libc."0.2.50".align or false) ||
        (f.libc."0.2.50".rustc-dep-of-std or false) ||
        (libc."0.2.50"."rustc-dep-of-std" or false); }
      { "0.2.50".default = (f.libc."0.2.50".default or true); }
      { "0.2.50".rustc-std-workspace-core =
        (f.libc."0.2.50".rustc-std-workspace-core or false) ||
        (f.libc."0.2.50".rustc-dep-of-std or false) ||
        (libc."0.2.50"."rustc-dep-of-std" or false); }
      { "0.2.50".use_std =
        (f.libc."0.2.50".use_std or false) ||
        (f.libc."0.2.50".default or false) ||
        (libc."0.2.50"."default" or false); }
    ];
  }) [];


# end
# libflate-0.1.21

  crates.libflate."0.1.21" = deps: { features?(features_.libflate."0.1.21" deps {}) }: buildRustCrate {
    crateName = "libflate";
    version = "0.1.21";
    authors = [ "Takeru Ohta <phjgt308@gmail.com>" ];
    sha256 = "0vi2lw0chngc5ph3abdzphp9bfgsflhxarydsgf4s2ph9gdgi91g";
    dependencies = mapFeatures features ([
      (crates."adler32"."${deps."libflate"."0.1.21"."adler32"}" deps)
      (crates."byteorder"."${deps."libflate"."0.1.21"."byteorder"}" deps)
      (crates."crc32fast"."${deps."libflate"."0.1.21"."crc32fast"}" deps)
    ]);
  };
  features_.libflate."0.1.21" = deps: f: updateFeatures f (rec {
    adler32."${deps.libflate."0.1.21".adler32}".default = true;
    byteorder."${deps.libflate."0.1.21".byteorder}".default = true;
    crc32fast."${deps.libflate."0.1.21".crc32fast}".default = true;
    libflate."0.1.21".default = (f.libflate."0.1.21".default or true);
  }) [
    (features_.adler32."${deps."libflate"."0.1.21"."adler32"}" deps)
    (features_.byteorder."${deps."libflate"."0.1.21"."byteorder"}" deps)
    (features_.crc32fast."${deps."libflate"."0.1.21"."crc32fast"}" deps)
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
# libpijul-0.11.1

  crates.libpijul."0.11.1" = deps: { features?(features_.libpijul."0.11.1" deps {}) }: buildRustCrate {
    crateName = "libpijul";
    version = "0.11.1";
    authors = [ "Pierre-Étienne Meunier" "Florent Becker" ];
    sha256 = "18dj7cw08nvf5bynnx065zjahz0nkvj0qb6im2pfx86x707jqafw";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."libpijul"."0.11.1"."base64"}" deps)
      (crates."bincode"."${deps."libpijul"."0.11.1"."bincode"}" deps)
      (crates."bitflags"."${deps."libpijul"."0.11.1"."bitflags"}" deps)
      (crates."bs58"."${deps."libpijul"."0.11.1"."bs58"}" deps)
      (crates."byteorder"."${deps."libpijul"."0.11.1"."byteorder"}" deps)
      (crates."chrono"."${deps."libpijul"."0.11.1"."chrono"}" deps)
      (crates."flate2"."${deps."libpijul"."0.11.1"."flate2"}" deps)
      (crates."hex"."${deps."libpijul"."0.11.1"."hex"}" deps)
      (crates."ignore"."${deps."libpijul"."0.11.1"."ignore"}" deps)
      (crates."log"."${deps."libpijul"."0.11.1"."log"}" deps)
      (crates."openssl"."${deps."libpijul"."0.11.1"."openssl"}" deps)
      (crates."rand"."${deps."libpijul"."0.11.1"."rand"}" deps)
      (crates."sanakirja"."${deps."libpijul"."0.11.1"."sanakirja"}" deps)
      (crates."serde"."${deps."libpijul"."0.11.1"."serde"}" deps)
      (crates."serde_derive"."${deps."libpijul"."0.11.1"."serde_derive"}" deps)
      (crates."serde_json"."${deps."libpijul"."0.11.1"."serde_json"}" deps)
      (crates."tempdir"."${deps."libpijul"."0.11.1"."tempdir"}" deps)
      (crates."thrussh_keys"."${deps."libpijul"."0.11.1"."thrussh_keys"}" deps)
      (crates."toml"."${deps."libpijul"."0.11.1"."toml"}" deps)
    ]);
  };
  features_.libpijul."0.11.1" = deps: f: updateFeatures f (rec {
    base64."${deps.libpijul."0.11.1".base64}".default = true;
    bincode."${deps.libpijul."0.11.1".bincode}".default = true;
    bitflags."${deps.libpijul."0.11.1".bitflags}".default = true;
    bs58."${deps.libpijul."0.11.1".bs58}".default = true;
    byteorder."${deps.libpijul."0.11.1".byteorder}".default = true;
    chrono = fold recursiveUpdate {} [
      { "${deps.libpijul."0.11.1".chrono}"."serde" = true; }
      { "${deps.libpijul."0.11.1".chrono}".default = true; }
    ];
    flate2."${deps.libpijul."0.11.1".flate2}".default = true;
    hex."${deps.libpijul."0.11.1".hex}".default = true;
    ignore."${deps.libpijul."0.11.1".ignore}".default = true;
    libpijul."0.11.1".default = (f.libpijul."0.11.1".default or true);
    log."${deps.libpijul."0.11.1".log}".default = true;
    openssl."${deps.libpijul."0.11.1".openssl}".default = true;
    rand."${deps.libpijul."0.11.1".rand}".default = true;
    sanakirja."${deps.libpijul."0.11.1".sanakirja}".default = true;
    serde."${deps.libpijul."0.11.1".serde}".default = true;
    serde_derive."${deps.libpijul."0.11.1".serde_derive}".default = true;
    serde_json."${deps.libpijul."0.11.1".serde_json}".default = true;
    tempdir."${deps.libpijul."0.11.1".tempdir}".default = true;
    thrussh_keys."${deps.libpijul."0.11.1".thrussh_keys}".default = true;
    toml."${deps.libpijul."0.11.1".toml}".default = true;
  }) [
    (features_.base64."${deps."libpijul"."0.11.1"."base64"}" deps)
    (features_.bincode."${deps."libpijul"."0.11.1"."bincode"}" deps)
    (features_.bitflags."${deps."libpijul"."0.11.1"."bitflags"}" deps)
    (features_.bs58."${deps."libpijul"."0.11.1"."bs58"}" deps)
    (features_.byteorder."${deps."libpijul"."0.11.1"."byteorder"}" deps)
    (features_.chrono."${deps."libpijul"."0.11.1"."chrono"}" deps)
    (features_.flate2."${deps."libpijul"."0.11.1"."flate2"}" deps)
    (features_.hex."${deps."libpijul"."0.11.1"."hex"}" deps)
    (features_.ignore."${deps."libpijul"."0.11.1"."ignore"}" deps)
    (features_.log."${deps."libpijul"."0.11.1"."log"}" deps)
    (features_.openssl."${deps."libpijul"."0.11.1"."openssl"}" deps)
    (features_.rand."${deps."libpijul"."0.11.1"."rand"}" deps)
    (features_.sanakirja."${deps."libpijul"."0.11.1"."sanakirja"}" deps)
    (features_.serde."${deps."libpijul"."0.11.1"."serde"}" deps)
    (features_.serde_derive."${deps."libpijul"."0.11.1"."serde_derive"}" deps)
    (features_.serde_json."${deps."libpijul"."0.11.1"."serde_json"}" deps)
    (features_.tempdir."${deps."libpijul"."0.11.1"."tempdir"}" deps)
    (features_.thrussh_keys."${deps."libpijul"."0.11.1"."thrussh_keys"}" deps)
    (features_.toml."${deps."libpijul"."0.11.1"."toml"}" deps)
  ];


# end
# linked-hash-map-0.4.2

  crates.linked_hash_map."0.4.2" = deps: { features?(features_.linked_hash_map."0.4.2" deps {}) }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.4.2";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "04da208h6jb69f46j37jnvsw2i1wqplglp4d61csqcrhh83avbgl";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."linked_hash_map"."0.4.2" or {});
  };
  features_.linked_hash_map."0.4.2" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "0.4.2".default = (f.linked_hash_map."0.4.2".default or true); }
      { "0.4.2".heapsize =
        (f.linked_hash_map."0.4.2".heapsize or false) ||
        (f.linked_hash_map."0.4.2".heapsize_impl or false) ||
        (linked_hash_map."0.4.2"."heapsize_impl" or false); }
      { "0.4.2".serde =
        (f.linked_hash_map."0.4.2".serde or false) ||
        (f.linked_hash_map."0.4.2".serde_impl or false) ||
        (linked_hash_map."0.4.2"."serde_impl" or false); }
      { "0.4.2".serde_test =
        (f.linked_hash_map."0.4.2".serde_test or false) ||
        (f.linked_hash_map."0.4.2".serde_impl or false) ||
        (linked_hash_map."0.4.2"."serde_impl" or false); }
    ];
  }) [];


# end
# linked-hash-map-0.5.1

  crates.linked_hash_map."0.5.1" = deps: { features?(features_.linked_hash_map."0.5.1" deps {}) }: buildRustCrate {
    crateName = "linked-hash-map";
    version = "0.5.1";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
    sha256 = "1f29c7j53z7w5v0g115yii9dmmbsahr93ak375g48vi75v3p4030";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."linked_hash_map"."0.5.1" or {});
  };
  features_.linked_hash_map."0.5.1" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "0.5.1".default = (f.linked_hash_map."0.5.1".default or true); }
      { "0.5.1".heapsize =
        (f.linked_hash_map."0.5.1".heapsize or false) ||
        (f.linked_hash_map."0.5.1".heapsize_impl or false) ||
        (linked_hash_map."0.5.1"."heapsize_impl" or false); }
      { "0.5.1".serde =
        (f.linked_hash_map."0.5.1".serde or false) ||
        (f.linked_hash_map."0.5.1".serde_impl or false) ||
        (linked_hash_map."0.5.1"."serde_impl" or false); }
      { "0.5.1".serde_test =
        (f.linked_hash_map."0.5.1".serde_test or false) ||
        (f.linked_hash_map."0.5.1".serde_impl or false) ||
        (linked_hash_map."0.5.1"."serde_impl" or false); }
    ];
  }) [];


# end
# linked_hash_set-0.1.3

  crates.linked_hash_set."0.1.3" = deps: { features?(features_.linked_hash_set."0.1.3" deps {}) }: buildRustCrate {
    crateName = "linked_hash_set";
    version = "0.1.3";
    authors = [ "Alex Butler <alexheretic@gmail.com>" ];
    sha256 = "12vaq3lzmy437g3vz4vj0dnf8gv24x53wi4q6a92g6wc0brzmp3w";
    dependencies = mapFeatures features ([
      (crates."linked_hash_map"."${deps."linked_hash_set"."0.1.3"."linked_hash_map"}" deps)
    ]);
  };
  features_.linked_hash_set."0.1.3" = deps: f: updateFeatures f (rec {
    linked_hash_map."${deps.linked_hash_set."0.1.3".linked_hash_map}".default = true;
    linked_hash_set."0.1.3".default = (f.linked_hash_set."0.1.3".default or true);
  }) [
    (features_.linked_hash_map."${deps."linked_hash_set"."0.1.3"."linked_hash_map"}" deps)
  ];


# end
# lock_api-0.1.5

  crates.lock_api."0.1.5" = deps: { features?(features_.lock_api."0.1.5" deps {}) }: buildRustCrate {
    crateName = "lock_api";
    version = "0.1.5";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "132sidr5hvjfkaqm3l95zpcpi8yk5ddd0g79zf1ad4v65sxirqqm";
    dependencies = mapFeatures features ([
      (crates."scopeguard"."${deps."lock_api"."0.1.5"."scopeguard"}" deps)
    ]
      ++ (if features.lock_api."0.1.5".owning_ref or false then [ (crates.owning_ref."${deps."lock_api"."0.1.5".owning_ref}" deps) ] else []));
    features = mkFeatures (features."lock_api"."0.1.5" or {});
  };
  features_.lock_api."0.1.5" = deps: f: updateFeatures f (rec {
    lock_api."0.1.5".default = (f.lock_api."0.1.5".default or true);
    owning_ref."${deps.lock_api."0.1.5".owning_ref}".default = true;
    scopeguard."${deps.lock_api."0.1.5".scopeguard}".default = (f.scopeguard."${deps.lock_api."0.1.5".scopeguard}".default or false);
  }) [
    (features_.owning_ref."${deps."lock_api"."0.1.5"."owning_ref"}" deps)
    (features_.scopeguard."${deps."lock_api"."0.1.5"."scopeguard"}" deps)
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
# log-0.4.5

  crates.log."0.4.5" = deps: { features?(features_.log."0.4.5" deps {}) }: buildRustCrate {
    crateName = "log";
    version = "0.4.5";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1hdcj17al94ga90q7jx2y1rmxi68n3akra1awv3hr3s9b9zipgq6";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."log"."0.4.5"."cfg_if"}" deps)
    ]);
    features = mkFeatures (features."log"."0.4.5" or {});
  };
  features_.log."0.4.5" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.log."0.4.5".cfg_if}".default = true;
    log."0.4.5".default = (f.log."0.4.5".default or true);
  }) [
    (features_.cfg_if."${deps."log"."0.4.5"."cfg_if"}" deps)
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
# lru-cache-0.1.1

  crates.lru_cache."0.1.1" = deps: { features?(features_.lru_cache."0.1.1" deps {}) }: buildRustCrate {
    crateName = "lru-cache";
    version = "0.1.1";
    authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" ];
    sha256 = "1hl6kii1g54sq649gnscv858mmw7a02xj081l4vcgvrswdi2z8fw";
    dependencies = mapFeatures features ([
      (crates."linked_hash_map"."${deps."lru_cache"."0.1.1"."linked_hash_map"}" deps)
    ]);
    features = mkFeatures (features."lru_cache"."0.1.1" or {});
  };
  features_.lru_cache."0.1.1" = deps: f: updateFeatures f (rec {
    linked_hash_map = fold recursiveUpdate {} [
      { "${deps.lru_cache."0.1.1".linked_hash_map}"."heapsize_impl" =
        (f.linked_hash_map."${deps.lru_cache."0.1.1".linked_hash_map}"."heapsize_impl" or false) ||
        (lru_cache."0.1.1"."heapsize_impl" or false) ||
        (f."lru_cache"."0.1.1"."heapsize_impl" or false); }
      { "${deps.lru_cache."0.1.1".linked_hash_map}".default = true; }
    ];
    lru_cache = fold recursiveUpdate {} [
      { "0.1.1".default = (f.lru_cache."0.1.1".default or true); }
      { "0.1.1".heapsize =
        (f.lru_cache."0.1.1".heapsize or false) ||
        (f.lru_cache."0.1.1".heapsize_impl or false) ||
        (lru_cache."0.1.1"."heapsize_impl" or false); }
    ];
  }) [
    (features_.linked_hash_map."${deps."lru_cache"."0.1.1"."linked_hash_map"}" deps)
  ];


# end
# lzw-0.10.0

  crates.lzw."0.10.0" = deps: { features?(features_.lzw."0.10.0" deps {}) }: buildRustCrate {
    crateName = "lzw";
    version = "0.10.0";
    authors = [ "nwin <nwin@users.noreply.github.com>" ];
    sha256 = "1cfsy2w26kbz9bjaqp9dh1wyyh47rpmhwvj4jpc1rmffbf438fvb";
    features = mkFeatures (features."lzw"."0.10.0" or {});
  };
  features_.lzw."0.10.0" = deps: f: updateFeatures f (rec {
    lzw = fold recursiveUpdate {} [
      { "0.10.0".default = (f.lzw."0.10.0".default or true); }
      { "0.10.0".raii_no_panic =
        (f.lzw."0.10.0".raii_no_panic or false) ||
        (f.lzw."0.10.0".default or false) ||
        (lzw."0.10.0"."default" or false); }
    ];
  }) [];


# end
# mac-0.1.1

  crates.mac."0.1.1" = deps: { features?(features_.mac."0.1.1" deps {}) }: buildRustCrate {
    crateName = "mac";
    version = "0.1.1";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "17fq2w1q33swr37dvpdc50xiaslym2jak4jrix83a075kk18c8fm";
  };
  features_.mac."0.1.1" = deps: f: updateFeatures f (rec {
    mac."0.1.1".default = (f.mac."0.1.1".default or true);
  }) [];


# end
# mach_o_sys-0.1.1

  crates.mach_o_sys."0.1.1" = deps: { features?(features_.mach_o_sys."0.1.1" deps {}) }: buildRustCrate {
    crateName = "mach_o_sys";
    version = "0.1.1";
    authors = [ "Nick Fitzgerald <fitzgen@gmail.com>" ];
    sha256 = "1ja9kl5j4d7z880icwpjn94imkq939m6hrmg03ly93wk94l0hvnj";
  };
  features_.mach_o_sys."0.1.1" = deps: f: updateFeatures f (rec {
    mach_o_sys."0.1.1".default = (f.mach_o_sys."0.1.1".default or true);
  }) [];


# end
# maplit-1.0.1

  crates.maplit."1.0.1" = deps: { features?(features_.maplit."1.0.1" deps {}) }: buildRustCrate {
    crateName = "maplit";
    version = "1.0.1";
    authors = [ "bluss" ];
    sha256 = "1lcadhrcy2qyb6zazmzj7gvgb50rmlvkcivw287016j4q723x72g";
  };
  features_.maplit."1.0.1" = deps: f: updateFeatures f (rec {
    maplit."1.0.1".default = (f.maplit."1.0.1".default or true);
  }) [];


# end
# markup5ever-0.7.5

  crates.markup5ever."0.7.5" = deps: { features?(features_.markup5ever."0.7.5" deps {}) }: buildRustCrate {
    crateName = "markup5ever";
    version = "0.7.5";
    authors = [ "The html5ever Project Developers" ];
    sha256 = "039m4lsyhnma1jkrjlk8rwqhmvc1jgbs8dskqn16gc2yr5f6ji2k";
    libPath = "lib.rs";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."phf"."${deps."markup5ever"."0.7.5"."phf"}" deps)
      (crates."string_cache"."${deps."markup5ever"."0.7.5"."string_cache"}" deps)
      (crates."tendril"."${deps."markup5ever"."0.7.5"."tendril"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."phf_codegen"."${deps."markup5ever"."0.7.5"."phf_codegen"}" deps)
      (crates."serde"."${deps."markup5ever"."0.7.5"."serde"}" deps)
      (crates."serde_derive"."${deps."markup5ever"."0.7.5"."serde_derive"}" deps)
      (crates."serde_json"."${deps."markup5ever"."0.7.5"."serde_json"}" deps)
      (crates."string_cache_codegen"."${deps."markup5ever"."0.7.5"."string_cache_codegen"}" deps)
    ]);
  };
  features_.markup5ever."0.7.5" = deps: f: updateFeatures f (rec {
    markup5ever."0.7.5".default = (f.markup5ever."0.7.5".default or true);
    phf."${deps.markup5ever."0.7.5".phf}".default = true;
    phf_codegen."${deps.markup5ever."0.7.5".phf_codegen}".default = true;
    serde."${deps.markup5ever."0.7.5".serde}".default = true;
    serde_derive."${deps.markup5ever."0.7.5".serde_derive}".default = true;
    serde_json."${deps.markup5ever."0.7.5".serde_json}".default = true;
    string_cache."${deps.markup5ever."0.7.5".string_cache}".default = true;
    string_cache_codegen."${deps.markup5ever."0.7.5".string_cache_codegen}".default = true;
    tendril."${deps.markup5ever."0.7.5".tendril}".default = true;
  }) [
    (features_.phf."${deps."markup5ever"."0.7.5"."phf"}" deps)
    (features_.string_cache."${deps."markup5ever"."0.7.5"."string_cache"}" deps)
    (features_.tendril."${deps."markup5ever"."0.7.5"."tendril"}" deps)
    (features_.phf_codegen."${deps."markup5ever"."0.7.5"."phf_codegen"}" deps)
    (features_.serde."${deps."markup5ever"."0.7.5"."serde"}" deps)
    (features_.serde_derive."${deps."markup5ever"."0.7.5"."serde_derive"}" deps)
    (features_.serde_json."${deps."markup5ever"."0.7.5"."serde_json"}" deps)
    (features_.string_cache_codegen."${deps."markup5ever"."0.7.5"."string_cache_codegen"}" deps)
  ];


# end
# matches-0.1.8

  crates.matches."0.1.8" = deps: { features?(features_.matches."0.1.8" deps {}) }: buildRustCrate {
    crateName = "matches";
    version = "0.1.8";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "03hl636fg6xggy0a26200xs74amk3k9n0908rga2szn68agyz3cv";
    libPath = "lib.rs";
  };
  features_.matches."0.1.8" = deps: f: updateFeatures f (rec {
    matches."0.1.8".default = (f.matches."0.1.8".default or true);
  }) [];


# end
# maxminddb-0.13.0

  crates.maxminddb."0.13.0" = deps: { features?(features_.maxminddb."0.13.0" deps {}) }: buildRustCrate {
    crateName = "maxminddb";
    version = "0.13.0";
    authors = [ "Gregory J. Oschwald <oschwald@gmail.com>" ];
    sha256 = "181aydf8lnhy2h00zmw6izgvkq0019lcbqlpz600xs24sxisjaiq";
    libPath = "src/maxminddb/lib.rs";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."maxminddb"."0.13.0"."log"}" deps)
      (crates."serde"."${deps."maxminddb"."0.13.0"."serde"}" deps)
      (crates."serde_derive"."${deps."maxminddb"."0.13.0"."serde_derive"}" deps)
    ]);
    features = mkFeatures (features."maxminddb"."0.13.0" or {});
  };
  features_.maxminddb."0.13.0" = deps: f: updateFeatures f (rec {
    log."${deps.maxminddb."0.13.0".log}".default = true;
    maxminddb = fold recursiveUpdate {} [
      { "0.13.0".default = (f.maxminddb."0.13.0".default or true); }
      { "0.13.0".memmap =
        (f.maxminddb."0.13.0".memmap or false) ||
        (f.maxminddb."0.13.0".mmap or false) ||
        (maxminddb."0.13.0"."mmap" or false); }
    ];
    serde."${deps.maxminddb."0.13.0".serde}".default = true;
    serde_derive."${deps.maxminddb."0.13.0".serde_derive}".default = true;
  }) [
    (features_.log."${deps."maxminddb"."0.13.0"."log"}" deps)
    (features_.serde."${deps."maxminddb"."0.13.0"."serde"}" deps)
    (features_.serde_derive."${deps."maxminddb"."0.13.0"."serde_derive"}" deps)
  ];


# end
# md5-0.3.8

  crates.md5."0.3.8" = deps: { features?(features_.md5."0.3.8" deps {}) }: buildRustCrate {
    crateName = "md5";
    version = "0.3.8";
    authors = [ "Ivan Ukhov <ivan.ukhov@gmail.com>" "Kamal Ahmad <shibe@openmailbox.org>" "Konstantin Stepanov <milezv@gmail.com>" "Lukas Kalbertodt <lukas.kalbertodt@gmail.com>" "Nathan Musoke <nathan.musoke@gmail.com>" "Tony Arcieri <bascule@gmail.com>" "Wim de With <register@dewith.io>" ];
    sha256 = "0ciydcf5y3zmygzschhg4f242p9rf1d75jfj0hay4xjj29l319yd";
  };
  features_.md5."0.3.8" = deps: f: updateFeatures f (rec {
    md5."0.3.8".default = (f.md5."0.3.8".default or true);
  }) [];


# end
# memchr-1.0.2

  crates.memchr."1.0.2" = deps: { features?(features_.memchr."1.0.2" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "1.0.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "0dfb8ifl9nrc9kzgd5z91q6qg87sh285q1ih7xgrsglmqfav9lg7";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.memchr."1.0.2".libc or false then [ (crates.libc."${deps."memchr"."1.0.2".libc}" deps) ] else []));
    features = mkFeatures (features."memchr"."1.0.2" or {});
  };
  features_.memchr."1.0.2" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "${deps.memchr."1.0.2".libc}"."use_std" =
        (f.libc."${deps.memchr."1.0.2".libc}"."use_std" or false) ||
        (memchr."1.0.2"."use_std" or false) ||
        (f."memchr"."1.0.2"."use_std" or false); }
      { "${deps.memchr."1.0.2".libc}".default = (f.libc."${deps.memchr."1.0.2".libc}".default or false); }
    ];
    memchr = fold recursiveUpdate {} [
      { "1.0.2".default = (f.memchr."1.0.2".default or true); }
      { "1.0.2".libc =
        (f.memchr."1.0.2".libc or false) ||
        (f.memchr."1.0.2".default or false) ||
        (memchr."1.0.2"."default" or false) ||
        (f.memchr."1.0.2".use_std or false) ||
        (memchr."1.0.2"."use_std" or false); }
      { "1.0.2".use_std =
        (f.memchr."1.0.2".use_std or false) ||
        (f.memchr."1.0.2".default or false) ||
        (memchr."1.0.2"."default" or false); }
    ];
  }) [
    (features_.libc."${deps."memchr"."1.0.2"."libc"}" deps)
  ];


# end
# memchr-2.1.0

  crates.memchr."2.1.0" = deps: { features?(features_.memchr."2.1.0" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.1.0";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "02w1fc5z1ccx8fbzgcr0mpk0xf2i9g4vbx9q5c2g8pjddbaqvjjq";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."memchr"."2.1.0"."cfg_if"}" deps)
    ]
      ++ (if features.memchr."2.1.0".libc or false then [ (crates.libc."${deps."memchr"."2.1.0".libc}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."memchr"."2.1.0"."version_check"}" deps)
    ]);
    features = mkFeatures (features."memchr"."2.1.0" or {});
  };
  features_.memchr."2.1.0" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.memchr."2.1.0".cfg_if}".default = true;
    libc = fold recursiveUpdate {} [
      { "${deps.memchr."2.1.0".libc}"."use_std" =
        (f.libc."${deps.memchr."2.1.0".libc}"."use_std" or false) ||
        (memchr."2.1.0"."use_std" or false) ||
        (f."memchr"."2.1.0"."use_std" or false); }
      { "${deps.memchr."2.1.0".libc}".default = (f.libc."${deps.memchr."2.1.0".libc}".default or false); }
    ];
    memchr = fold recursiveUpdate {} [
      { "2.1.0".default = (f.memchr."2.1.0".default or true); }
      { "2.1.0".libc =
        (f.memchr."2.1.0".libc or false) ||
        (f.memchr."2.1.0".default or false) ||
        (memchr."2.1.0"."default" or false) ||
        (f.memchr."2.1.0".use_std or false) ||
        (memchr."2.1.0"."use_std" or false); }
      { "2.1.0".use_std =
        (f.memchr."2.1.0".use_std or false) ||
        (f.memchr."2.1.0".default or false) ||
        (memchr."2.1.0"."default" or false); }
    ];
    version_check."${deps.memchr."2.1.0".version_check}".default = true;
  }) [
    (features_.cfg_if."${deps."memchr"."2.1.0"."cfg_if"}" deps)
    (features_.libc."${deps."memchr"."2.1.0"."libc"}" deps)
    (features_.version_check."${deps."memchr"."2.1.0"."version_check"}" deps)
  ];


# end
# memchr-2.2.0

  crates.memchr."2.2.0" = deps: { features?(features_.memchr."2.2.0" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.2.0";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "11vwg8iig9jyjxq3n1cq15g29ikzw5l7ar87md54k1aisjs0997p";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."memchr"."2.2.0" or {});
  };
  features_.memchr."2.2.0" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "2.2.0".default = (f.memchr."2.2.0".default or true); }
      { "2.2.0".use_std =
        (f.memchr."2.2.0".use_std or false) ||
        (f.memchr."2.2.0".default or false) ||
        (memchr."2.2.0"."default" or false); }
    ];
  }) [];


# end
# memmap-0.6.2

  crates.memmap."0.6.2" = deps: { features?(features_.memmap."0.6.2" deps {}) }: buildRustCrate {
    crateName = "memmap";
    version = "0.6.2";
    authors = [ "Dan Burkert <dan@danburkert.com>" ];
    sha256 = "0xs6wbx30fyyr51yscrhgwkmfphjgq8zan0lc2ficwxwsa7jj1cs";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."memmap"."0.6.2"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."memmap"."0.6.2"."winapi"}" deps)
    ]) else []);
  };
  features_.memmap."0.6.2" = deps: f: updateFeatures f (rec {
    libc."${deps.memmap."0.6.2".libc}".default = true;
    memmap."0.6.2".default = (f.memmap."0.6.2".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.memmap."0.6.2".winapi}"."basetsd" = true; }
      { "${deps.memmap."0.6.2".winapi}"."handleapi" = true; }
      { "${deps.memmap."0.6.2".winapi}"."memoryapi" = true; }
      { "${deps.memmap."0.6.2".winapi}"."minwindef" = true; }
      { "${deps.memmap."0.6.2".winapi}"."std" = true; }
      { "${deps.memmap."0.6.2".winapi}"."sysinfoapi" = true; }
      { "${deps.memmap."0.6.2".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."memmap"."0.6.2"."libc"}" deps)
    (features_.winapi."${deps."memmap"."0.6.2"."winapi"}" deps)
  ];


# end
# memoffset-0.2.1

  crates.memoffset."0.2.1" = deps: { features?(features_.memoffset."0.2.1" deps {}) }: buildRustCrate {
    crateName = "memoffset";
    version = "0.2.1";
    authors = [ "Gilad Naaman <gilad.naaman@gmail.com>" ];
    sha256 = "00vym01jk9slibq2nsiilgffp7n6k52a4q3n4dqp0xf5kzxvffcf";
  };
  features_.memoffset."0.2.1" = deps: f: updateFeatures f (rec {
    memoffset."0.2.1".default = (f.memoffset."0.2.1".default or true);
  }) [];


# end
# memsec-0.5.4

  crates.memsec."0.5.4" = deps: { features?(features_.memsec."0.5.4" deps {}) }: buildRustCrate {
    crateName = "memsec";
    version = "0.5.4";
    authors = [ "quininer kel <quininer@live.com>" ];
    sha256 = "13rp51k04y1i3cxal54yrf2kcdaw3m0pphhx7xs1xfyvdghcbzjs";
    build = "build.rs";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.memsec."0.5.4".rand or false then [ (crates.rand."${deps."memsec"."0.5.4".rand}" deps) ] else []))
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
    ]
      ++ (if features.memsec."0.5.4".mach_o_sys or false then [ (crates.mach_o_sys."${deps."memsec"."0.5.4".mach_o_sys}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.memsec."0.5.4".libc or false then [ (crates.libc."${deps."memsec"."0.5.4".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.memsec."0.5.4".winapi or false then [ (crates.winapi."${deps."memsec"."0.5.4".winapi}" deps) ] else [])) else []);
    features = mkFeatures (features."memsec"."0.5.4" or {});
  };
  features_.memsec."0.5.4" = deps: f: updateFeatures f (rec {
    libc."${deps.memsec."0.5.4".libc}".default = true;
    mach_o_sys."${deps.memsec."0.5.4".mach_o_sys}".default = true;
    memsec = fold recursiveUpdate {} [
      { "0.5.4".alloc =
        (f.memsec."0.5.4".alloc or false) ||
        (f.memsec."0.5.4".default or false) ||
        (memsec."0.5.4"."default" or false); }
      { "0.5.4".default = (f.memsec."0.5.4".default or true); }
      { "0.5.4".libc =
        (f.memsec."0.5.4".libc or false) ||
        (f.memsec."0.5.4".use_os or false) ||
        (memsec."0.5.4"."use_os" or false); }
      { "0.5.4".mach_o_sys =
        (f.memsec."0.5.4".mach_o_sys or false) ||
        (f.memsec."0.5.4".use_os or false) ||
        (memsec."0.5.4"."use_os" or false); }
      { "0.5.4".rand =
        (f.memsec."0.5.4".rand or false) ||
        (f.memsec."0.5.4".alloc or false) ||
        (memsec."0.5.4"."alloc" or false); }
      { "0.5.4".use_os =
        (f.memsec."0.5.4".use_os or false) ||
        (f.memsec."0.5.4".default or false) ||
        (memsec."0.5.4"."default" or false); }
      { "0.5.4".winapi =
        (f.memsec."0.5.4".winapi or false) ||
        (f.memsec."0.5.4".use_os or false) ||
        (memsec."0.5.4"."use_os" or false); }
    ];
    rand."${deps.memsec."0.5.4".rand}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.memsec."0.5.4".winapi}"."memoryapi" = true; }
      { "${deps.memsec."0.5.4".winapi}"."sysinfoapi" = true; }
      { "${deps.memsec."0.5.4".winapi}".default = true; }
    ];
  }) [
    (features_.rand."${deps."memsec"."0.5.4"."rand"}" deps)
    (features_.mach_o_sys."${deps."memsec"."0.5.4"."mach_o_sys"}" deps)
    (features_.libc."${deps."memsec"."0.5.4"."libc"}" deps)
    (features_.winapi."${deps."memsec"."0.5.4"."winapi"}" deps)
  ];


# end
# mime-0.2.6

  crates.mime."0.2.6" = deps: { features?(features_.mime."0.2.6" deps {}) }: buildRustCrate {
    crateName = "mime";
    version = "0.2.6";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "1skwwa0j3kqd8rm9387zgabjhp07zj99q71nzlhba4lrz9r911b3";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."mime"."0.2.6"."log"}" deps)
    ]);
    features = mkFeatures (features."mime"."0.2.6" or {});
  };
  features_.mime."0.2.6" = deps: f: updateFeatures f (rec {
    log."${deps.mime."0.2.6".log}".default = true;
    mime = fold recursiveUpdate {} [
      { "0.2.6".default = (f.mime."0.2.6".default or true); }
      { "0.2.6".heapsize =
        (f.mime."0.2.6".heapsize or false) ||
        (f.mime."0.2.6".heap_size or false) ||
        (mime."0.2.6"."heap_size" or false); }
    ];
  }) [
    (features_.log."${deps."mime"."0.2.6"."log"}" deps)
  ];


# end
# mime-0.3.13

  crates.mime."0.3.13" = deps: { features?(features_.mime."0.3.13" deps {}) }: buildRustCrate {
    crateName = "mime";
    version = "0.3.13";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "191b240rj0l8hq2bmn74z1c9rqnrfx0dbfxgyq7vnf3jkrbc5v86";
    dependencies = mapFeatures features ([
      (crates."unicase"."${deps."mime"."0.3.13"."unicase"}" deps)
    ]);
  };
  features_.mime."0.3.13" = deps: f: updateFeatures f (rec {
    mime."0.3.13".default = (f.mime."0.3.13".default or true);
    unicase."${deps.mime."0.3.13".unicase}".default = true;
  }) [
    (features_.unicase."${deps."mime"."0.3.13"."unicase"}" deps)
  ];


# end
# mime_guess-1.8.6

  crates.mime_guess."1.8.6" = deps: { features?(features_.mime_guess."1.8.6" deps {}) }: buildRustCrate {
    crateName = "mime_guess";
    version = "1.8.6";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "0jh41m556lja23b139a4m5lgzydm3sc7msrfx4a64999hq19567l";
    dependencies = mapFeatures features ([
      (crates."mime"."${deps."mime_guess"."1.8.6"."mime"}" deps)
      (crates."phf"."${deps."mime_guess"."1.8.6"."phf"}" deps)
      (crates."unicase"."${deps."mime_guess"."1.8.6"."unicase"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."phf_codegen"."${deps."mime_guess"."1.8.6"."phf_codegen"}" deps)
      (crates."unicase"."${deps."mime_guess"."1.8.6"."unicase"}" deps)
    ]);
    features = mkFeatures (features."mime_guess"."1.8.6" or {});
  };
  features_.mime_guess."1.8.6" = deps: f: updateFeatures f (rec {
    mime."${deps.mime_guess."1.8.6".mime}".default = true;
    mime_guess."1.8.6".default = (f.mime_guess."1.8.6".default or true);
    phf = fold recursiveUpdate {} [
      { "${deps.mime_guess."1.8.6".phf}"."unicase" = true; }
      { "${deps.mime_guess."1.8.6".phf}".default = true; }
    ];
    phf_codegen."${deps.mime_guess."1.8.6".phf_codegen}".default = true;
    unicase."${deps.mime_guess."1.8.6".unicase}".default = true;
  }) [
    (features_.mime."${deps."mime_guess"."1.8.6"."mime"}" deps)
    (features_.phf."${deps."mime_guess"."1.8.6"."phf"}" deps)
    (features_.unicase."${deps."mime_guess"."1.8.6"."unicase"}" deps)
    (features_.phf_codegen."${deps."mime_guess"."1.8.6"."phf_codegen"}" deps)
    (features_.unicase."${deps."mime_guess"."1.8.6"."unicase"}" deps)
  ];


# end
# mime_guess-2.0.0-alpha.6

  crates.mime_guess."2.0.0-alpha.6" = deps: { features?(features_.mime_guess."2.0.0-alpha.6" deps {}) }: buildRustCrate {
    crateName = "mime_guess";
    version = "2.0.0-alpha.6";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "1k2mdq43gi2qr63b7m5zs624rfi40ysk33cay49jlhq97jwnk9db";
    dependencies = mapFeatures features ([
      (crates."mime"."${deps."mime_guess"."2.0.0-alpha.6"."mime"}" deps)
      (crates."phf"."${deps."mime_guess"."2.0.0-alpha.6"."phf"}" deps)
      (crates."unicase"."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."phf_codegen"."${deps."mime_guess"."2.0.0-alpha.6"."phf_codegen"}" deps)
      (crates."unicase"."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
    ]);
    features = mkFeatures (features."mime_guess"."2.0.0-alpha.6" or {});
  };
  features_.mime_guess."2.0.0-alpha.6" = deps: f: updateFeatures f (rec {
    mime."${deps.mime_guess."2.0.0-alpha.6".mime}".default = true;
    mime_guess."2.0.0-alpha.6".default = (f.mime_guess."2.0.0-alpha.6".default or true);
    phf = fold recursiveUpdate {} [
      { "${deps.mime_guess."2.0.0-alpha.6".phf}"."unicase" = true; }
      { "${deps.mime_guess."2.0.0-alpha.6".phf}".default = true; }
    ];
    phf_codegen."${deps.mime_guess."2.0.0-alpha.6".phf_codegen}".default = true;
    unicase."${deps.mime_guess."2.0.0-alpha.6".unicase}".default = true;
  }) [
    (features_.mime."${deps."mime_guess"."2.0.0-alpha.6"."mime"}" deps)
    (features_.phf."${deps."mime_guess"."2.0.0-alpha.6"."phf"}" deps)
    (features_.unicase."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
    (features_.phf_codegen."${deps."mime_guess"."2.0.0-alpha.6"."phf_codegen"}" deps)
    (features_.unicase."${deps."mime_guess"."2.0.0-alpha.6"."unicase"}" deps)
  ];


# end
# miniz-sys-0.1.11

  crates.miniz_sys."0.1.11" = deps: { features?(features_.miniz_sys."0.1.11" deps {}) }: buildRustCrate {
    crateName = "miniz-sys";
    version = "0.1.11";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0l2wsakqjj7kc06dwxlpz4h8wih0f9d1idrz5gb1svipvh81khsm";
    libPath = "lib.rs";
    libName = "miniz_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."miniz_sys"."0.1.11"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."miniz_sys"."0.1.11"."cc"}" deps)
    ]);
  };
  features_.miniz_sys."0.1.11" = deps: f: updateFeatures f (rec {
    cc."${deps.miniz_sys."0.1.11".cc}".default = true;
    libc."${deps.miniz_sys."0.1.11".libc}".default = true;
    miniz_sys."0.1.11".default = (f.miniz_sys."0.1.11".default or true);
  }) [
    (features_.libc."${deps."miniz_sys"."0.1.11"."libc"}" deps)
    (features_.cc."${deps."miniz_sys"."0.1.11"."cc"}" deps)
  ];


# end
# miniz_oxide-0.2.1

  crates.miniz_oxide."0.2.1" = deps: { features?(features_.miniz_oxide."0.2.1" deps {}) }: buildRustCrate {
    crateName = "miniz_oxide";
    version = "0.2.1";
    authors = [ "Frommi <daniil.liferenko@gmail.com>" ];
    sha256 = "1ly14vlk0gq7czi1323l2dsy5y8dpvdwld4h9083i0y3hx9iyfdz";
    dependencies = mapFeatures features ([
      (crates."adler32"."${deps."miniz_oxide"."0.2.1"."adler32"}" deps)
    ]);
  };
  features_.miniz_oxide."0.2.1" = deps: f: updateFeatures f (rec {
    adler32."${deps.miniz_oxide."0.2.1".adler32}".default = true;
    miniz_oxide."0.2.1".default = (f.miniz_oxide."0.2.1".default or true);
  }) [
    (features_.adler32."${deps."miniz_oxide"."0.2.1"."adler32"}" deps)
  ];


# end
# miniz_oxide_c_api-0.2.1

  crates.miniz_oxide_c_api."0.2.1" = deps: { features?(features_.miniz_oxide_c_api."0.2.1" deps {}) }: buildRustCrate {
    crateName = "miniz_oxide_c_api";
    version = "0.2.1";
    authors = [ "Frommi <daniil.liferenko@gmail.com>" ];
    sha256 = "1zsk334nhy2rvyhbr0815l0gp6w40al6rxxafkycaafx3m9j8cj2";
    build = "src/build.rs";
    dependencies = mapFeatures features ([
      (crates."crc"."${deps."miniz_oxide_c_api"."0.2.1"."crc"}" deps)
      (crates."libc"."${deps."miniz_oxide_c_api"."0.2.1"."libc"}" deps)
      (crates."miniz_oxide"."${deps."miniz_oxide_c_api"."0.2.1"."miniz_oxide"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."miniz_oxide_c_api"."0.2.1"."cc"}" deps)
    ]);
    features = mkFeatures (features."miniz_oxide_c_api"."0.2.1" or {});
  };
  features_.miniz_oxide_c_api."0.2.1" = deps: f: updateFeatures f (rec {
    cc."${deps.miniz_oxide_c_api."0.2.1".cc}".default = true;
    crc."${deps.miniz_oxide_c_api."0.2.1".crc}".default = true;
    libc."${deps.miniz_oxide_c_api."0.2.1".libc}".default = true;
    miniz_oxide."${deps.miniz_oxide_c_api."0.2.1".miniz_oxide}".default = true;
    miniz_oxide_c_api = fold recursiveUpdate {} [
      { "0.2.1".build_orig_miniz =
        (f.miniz_oxide_c_api."0.2.1".build_orig_miniz or false) ||
        (f.miniz_oxide_c_api."0.2.1".benching or false) ||
        (miniz_oxide_c_api."0.2.1"."benching" or false) ||
        (f.miniz_oxide_c_api."0.2.1".fuzzing or false) ||
        (miniz_oxide_c_api."0.2.1"."fuzzing" or false); }
      { "0.2.1".build_stub_miniz =
        (f.miniz_oxide_c_api."0.2.1".build_stub_miniz or false) ||
        (f.miniz_oxide_c_api."0.2.1".miniz_zip or false) ||
        (miniz_oxide_c_api."0.2.1"."miniz_zip" or false); }
      { "0.2.1".default = (f.miniz_oxide_c_api."0.2.1".default or true); }
      { "0.2.1".no_c_export =
        (f.miniz_oxide_c_api."0.2.1".no_c_export or false) ||
        (f.miniz_oxide_c_api."0.2.1".benching or false) ||
        (miniz_oxide_c_api."0.2.1"."benching" or false) ||
        (f.miniz_oxide_c_api."0.2.1".fuzzing or false) ||
        (miniz_oxide_c_api."0.2.1"."fuzzing" or false); }
    ];
  }) [
    (features_.crc."${deps."miniz_oxide_c_api"."0.2.1"."crc"}" deps)
    (features_.libc."${deps."miniz_oxide_c_api"."0.2.1"."libc"}" deps)
    (features_.miniz_oxide."${deps."miniz_oxide_c_api"."0.2.1"."miniz_oxide"}" deps)
    (features_.cc."${deps."miniz_oxide_c_api"."0.2.1"."cc"}" deps)
  ];


# end
# mio-0.6.16

  crates.mio."0.6.16" = deps: { features?(features_.mio."0.6.16" deps {}) }: buildRustCrate {
    crateName = "mio";
    version = "0.6.16";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "14vyrlmf0w984pi7ad9qvmlfj6vrb0wn6i8ik9j87w5za2r3rban";
    dependencies = mapFeatures features ([
      (crates."iovec"."${deps."mio"."0.6.16"."iovec"}" deps)
      (crates."lazycell"."${deps."mio"."0.6.16"."lazycell"}" deps)
      (crates."log"."${deps."mio"."0.6.16"."log"}" deps)
      (crates."net2"."${deps."mio"."0.6.16"."net2"}" deps)
      (crates."slab"."${deps."mio"."0.6.16"."slab"}" deps)
    ])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_zircon"."${deps."mio"."0.6.16"."fuchsia_zircon"}" deps)
      (crates."fuchsia_zircon_sys"."${deps."mio"."0.6.16"."fuchsia_zircon_sys"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."mio"."0.6.16"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."mio"."0.6.16"."kernel32_sys"}" deps)
      (crates."miow"."${deps."mio"."0.6.16"."miow"}" deps)
      (crates."winapi"."${deps."mio"."0.6.16"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."mio"."0.6.16" or {});
  };
  features_.mio."0.6.16" = deps: f: updateFeatures f (rec {
    fuchsia_zircon."${deps.mio."0.6.16".fuchsia_zircon}".default = true;
    fuchsia_zircon_sys."${deps.mio."0.6.16".fuchsia_zircon_sys}".default = true;
    iovec."${deps.mio."0.6.16".iovec}".default = true;
    kernel32_sys."${deps.mio."0.6.16".kernel32_sys}".default = true;
    lazycell."${deps.mio."0.6.16".lazycell}".default = true;
    libc."${deps.mio."0.6.16".libc}".default = true;
    log."${deps.mio."0.6.16".log}".default = true;
    mio = fold recursiveUpdate {} [
      { "0.6.16".default = (f.mio."0.6.16".default or true); }
      { "0.6.16".with-deprecated =
        (f.mio."0.6.16".with-deprecated or false) ||
        (f.mio."0.6.16".default or false) ||
        (mio."0.6.16"."default" or false); }
    ];
    miow."${deps.mio."0.6.16".miow}".default = true;
    net2."${deps.mio."0.6.16".net2}".default = true;
    slab."${deps.mio."0.6.16".slab}".default = true;
    winapi."${deps.mio."0.6.16".winapi}".default = true;
  }) [
    (features_.iovec."${deps."mio"."0.6.16"."iovec"}" deps)
    (features_.lazycell."${deps."mio"."0.6.16"."lazycell"}" deps)
    (features_.log."${deps."mio"."0.6.16"."log"}" deps)
    (features_.net2."${deps."mio"."0.6.16"."net2"}" deps)
    (features_.slab."${deps."mio"."0.6.16"."slab"}" deps)
    (features_.fuchsia_zircon."${deps."mio"."0.6.16"."fuchsia_zircon"}" deps)
    (features_.fuchsia_zircon_sys."${deps."mio"."0.6.16"."fuchsia_zircon_sys"}" deps)
    (features_.libc."${deps."mio"."0.6.16"."libc"}" deps)
    (features_.kernel32_sys."${deps."mio"."0.6.16"."kernel32_sys"}" deps)
    (features_.miow."${deps."mio"."0.6.16"."miow"}" deps)
    (features_.winapi."${deps."mio"."0.6.16"."winapi"}" deps)
  ];


# end
# mio-uds-0.6.7

  crates.mio_uds."0.6.7" = deps: { features?(features_.mio_uds."0.6.7" deps {}) }: buildRustCrate {
    crateName = "mio-uds";
    version = "0.6.7";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1gff9908pvvysv7zgxvyxy7x34fnhs088cr0j8mgwj8j24mswrhm";
    dependencies = (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."iovec"."${deps."mio_uds"."0.6.7"."iovec"}" deps)
      (crates."libc"."${deps."mio_uds"."0.6.7"."libc"}" deps)
      (crates."mio"."${deps."mio_uds"."0.6.7"."mio"}" deps)
    ]) else []);
  };
  features_.mio_uds."0.6.7" = deps: f: updateFeatures f (rec {
    iovec."${deps.mio_uds."0.6.7".iovec}".default = true;
    libc."${deps.mio_uds."0.6.7".libc}".default = true;
    mio."${deps.mio_uds."0.6.7".mio}".default = true;
    mio_uds."0.6.7".default = (f.mio_uds."0.6.7".default or true);
  }) [
    (features_.iovec."${deps."mio_uds"."0.6.7"."iovec"}" deps)
    (features_.libc."${deps."mio_uds"."0.6.7"."libc"}" deps)
    (features_.mio."${deps."mio_uds"."0.6.7"."mio"}" deps)
  ];


# end
# miow-0.2.1

  crates.miow."0.2.1" = deps: { features?(features_.miow."0.2.1" deps {}) }: buildRustCrate {
    crateName = "miow";
    version = "0.2.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "14f8zkc6ix7mkyis1vsqnim8m29b6l55abkba3p2yz7j1ibcvrl0";
    dependencies = mapFeatures features ([
      (crates."kernel32_sys"."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
      (crates."net2"."${deps."miow"."0.2.1"."net2"}" deps)
      (crates."winapi"."${deps."miow"."0.2.1"."winapi"}" deps)
      (crates."ws2_32_sys"."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
    ]);
  };
  features_.miow."0.2.1" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.miow."0.2.1".kernel32_sys}".default = true;
    miow."0.2.1".default = (f.miow."0.2.1".default or true);
    net2."${deps.miow."0.2.1".net2}".default = (f.net2."${deps.miow."0.2.1".net2}".default or false);
    winapi."${deps.miow."0.2.1".winapi}".default = true;
    ws2_32_sys."${deps.miow."0.2.1".ws2_32_sys}".default = true;
  }) [
    (features_.kernel32_sys."${deps."miow"."0.2.1"."kernel32_sys"}" deps)
    (features_.net2."${deps."miow"."0.2.1"."net2"}" deps)
    (features_.winapi."${deps."miow"."0.2.1"."winapi"}" deps)
    (features_.ws2_32_sys."${deps."miow"."0.2.1"."ws2_32_sys"}" deps)
  ];


# end
# native-tls-0.2.2

  crates.native_tls."0.2.2" = deps: { features?(features_.native_tls."0.2.2" deps {}) }: buildRustCrate {
    crateName = "native-tls";
    version = "0.2.2";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0vl2hmmnrcjfylzjfsbnav20ri2n1qjgxn7bklb4mk3fyxfqm1m9";
    dependencies = (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
      (crates."lazy_static"."${deps."native_tls"."0.2.2"."lazy_static"}" deps)
      (crates."libc"."${deps."native_tls"."0.2.2"."libc"}" deps)
      (crates."security_framework"."${deps."native_tls"."0.2.2"."security_framework"}" deps)
      (crates."security_framework_sys"."${deps."native_tls"."0.2.2"."security_framework_sys"}" deps)
      (crates."tempfile"."${deps."native_tls"."0.2.2"."tempfile"}" deps)
    ]) else [])
      ++ (if !(kernel == "windows" || kernel == "darwin" || kernel == "ios") then mapFeatures features ([
      (crates."openssl"."${deps."native_tls"."0.2.2"."openssl"}" deps)
      (crates."openssl_probe"."${deps."native_tls"."0.2.2"."openssl_probe"}" deps)
      (crates."openssl_sys"."${deps."native_tls"."0.2.2"."openssl_sys"}" deps)
    ]) else [])
      ++ (if kernel == "android" then mapFeatures features ([
      (crates."log"."${deps."native_tls"."0.2.2"."log"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."schannel"."${deps."native_tls"."0.2.2"."schannel"}" deps)
    ]) else []);
    features = mkFeatures (features."native_tls"."0.2.2" or {});
  };
  features_.native_tls."0.2.2" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.native_tls."0.2.2".lazy_static}".default = true;
    libc."${deps.native_tls."0.2.2".libc}".default = true;
    log."${deps.native_tls."0.2.2".log}".default = true;
    native_tls."0.2.2".default = (f.native_tls."0.2.2".default or true);
    openssl."${deps.native_tls."0.2.2".openssl}".default = true;
    openssl_probe."${deps.native_tls."0.2.2".openssl_probe}".default = true;
    openssl_sys."${deps.native_tls."0.2.2".openssl_sys}".default = true;
    schannel."${deps.native_tls."0.2.2".schannel}".default = true;
    security_framework."${deps.native_tls."0.2.2".security_framework}".default = true;
    security_framework_sys."${deps.native_tls."0.2.2".security_framework_sys}".default = true;
    tempfile."${deps.native_tls."0.2.2".tempfile}".default = true;
  }) [
    (features_.lazy_static."${deps."native_tls"."0.2.2"."lazy_static"}" deps)
    (features_.libc."${deps."native_tls"."0.2.2"."libc"}" deps)
    (features_.security_framework."${deps."native_tls"."0.2.2"."security_framework"}" deps)
    (features_.security_framework_sys."${deps."native_tls"."0.2.2"."security_framework_sys"}" deps)
    (features_.tempfile."${deps."native_tls"."0.2.2"."tempfile"}" deps)
    (features_.openssl."${deps."native_tls"."0.2.2"."openssl"}" deps)
    (features_.openssl_probe."${deps."native_tls"."0.2.2"."openssl_probe"}" deps)
    (features_.openssl_sys."${deps."native_tls"."0.2.2"."openssl_sys"}" deps)
    (features_.log."${deps."native_tls"."0.2.2"."log"}" deps)
    (features_.schannel."${deps."native_tls"."0.2.2"."schannel"}" deps)
  ];


# end
# net2-0.2.33

  crates.net2."0.2.33" = deps: { features?(features_.net2."0.2.33" deps {}) }: buildRustCrate {
    crateName = "net2";
    version = "0.2.33";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1qnmajafgybj5wyxz9iffa8x5wgbwd2znfklmhqj7vl6lw1m65mq";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."net2"."0.2.33"."cfg_if"}" deps)
    ])
      ++ (if kernel == "redox" || (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."net2"."0.2.33"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."net2"."0.2.33"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."net2"."0.2.33" or {});
  };
  features_.net2."0.2.33" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.net2."0.2.33".cfg_if}".default = true;
    libc."${deps.net2."0.2.33".libc}".default = true;
    net2 = fold recursiveUpdate {} [
      { "0.2.33".default = (f.net2."0.2.33".default or true); }
      { "0.2.33".duration =
        (f.net2."0.2.33".duration or false) ||
        (f.net2."0.2.33".default or false) ||
        (net2."0.2.33"."default" or false); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.net2."0.2.33".winapi}"."handleapi" = true; }
      { "${deps.net2."0.2.33".winapi}"."winsock2" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2def" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2ipdef" = true; }
      { "${deps.net2."0.2.33".winapi}"."ws2tcpip" = true; }
      { "${deps.net2."0.2.33".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."net2"."0.2.33"."cfg_if"}" deps)
    (features_.libc."${deps."net2"."0.2.33"."libc"}" deps)
    (features_.winapi."${deps."net2"."0.2.33"."winapi"}" deps)
  ];


# end
# nettle-4.0.0

  crates.nettle."4.0.0" = deps: { features?(features_.nettle."4.0.0" deps {}) }: buildRustCrate {
    crateName = "nettle";
    version = "4.0.0";
    authors = [ "Kai Michaelis <kai.michaelis@pep-project.org>" ];
    sha256 = "1nr66j7dzw3jn4w80xk0f3fa0xhyyizwy39kdffmb5vszvbn0pln";
    dependencies = mapFeatures features ([
      (crates."failure"."${deps."nettle"."4.0.0"."failure"}" deps)
      (crates."libc"."${deps."nettle"."4.0.0"."libc"}" deps)
      (crates."nettle_sys"."${deps."nettle"."4.0.0"."nettle_sys"}" deps)
      (crates."rand"."${deps."nettle"."4.0.0"."rand"}" deps)
    ]);
  };
  features_.nettle."4.0.0" = deps: f: updateFeatures f (rec {
    failure."${deps.nettle."4.0.0".failure}".default = true;
    libc."${deps.nettle."4.0.0".libc}".default = true;
    nettle."4.0.0".default = (f.nettle."4.0.0".default or true);
    nettle_sys."${deps.nettle."4.0.0".nettle_sys}".default = true;
    rand."${deps.nettle."4.0.0".rand}".default = true;
  }) [
    (features_.failure."${deps."nettle"."4.0.0"."failure"}" deps)
    (features_.libc."${deps."nettle"."4.0.0"."libc"}" deps)
    (features_.nettle_sys."${deps."nettle"."4.0.0"."nettle_sys"}" deps)
    (features_.rand."${deps."nettle"."4.0.0"."rand"}" deps)
  ];


# end
# nettle-sys-1.0.1

  crates.nettle_sys."1.0.1" = deps: { features?(features_.nettle_sys."1.0.1" deps {}) }: buildRustCrate {
    crateName = "nettle-sys";
    version = "1.0.1";
    authors = [ "Kai Michaelis <kai.michaelis@pep-project.org>" ];
    sha256 = "103aqp7cnb767lb02lfkrgg9fv0kdsrljsks5alabv20cmsd1xfy";

    buildDependencies = mapFeatures features ([
      (crates."bindgen"."${deps."nettle_sys"."1.0.1"."bindgen"}" deps)
      (crates."pkg_config"."${deps."nettle_sys"."1.0.1"."pkg_config"}" deps)
    ]);
  };
  features_.nettle_sys."1.0.1" = deps: f: updateFeatures f (rec {
    bindgen."${deps.nettle_sys."1.0.1".bindgen}".default = true;
    nettle_sys."1.0.1".default = (f.nettle_sys."1.0.1".default or true);
    pkg_config."${deps.nettle_sys."1.0.1".pkg_config}".default = true;
  }) [
    (features_.bindgen."${deps."nettle_sys"."1.0.1"."bindgen"}" deps)
    (features_.pkg_config."${deps."nettle_sys"."1.0.1"."pkg_config"}" deps)
  ];


# end
# new_debug_unreachable-1.0.3

  crates.new_debug_unreachable."1.0.3" = deps: { features?(features_.new_debug_unreachable."1.0.3" deps {}) }: buildRustCrate {
    crateName = "new_debug_unreachable";
    version = "1.0.3";
    authors = [ "Matt Brubeck <mbrubeck@limpet.net>" "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1lxbd0n9gwvzg41bxiij0c28g1sp1jhp4h1rh10qisc8viyhsdj0";
    libPath = "src/lib.rs";
    libName = "debug_unreachable";
  };
  features_.new_debug_unreachable."1.0.3" = deps: f: updateFeatures f (rec {
    new_debug_unreachable."1.0.3".default = (f.new_debug_unreachable."1.0.3".default or true);
  }) [];


# end
# nix-0.13.0

  crates.nix."0.13.0" = deps: { features?(features_.nix."0.13.0" deps {}) }: buildRustCrate {
    crateName = "nix";
    version = "0.13.0";
    authors = [ "The nix-rust Project Developers" ];
    sha256 = "1kp5bgsd0bcx51byhr4ad5yfs34f1mhqqpzn2x4vfhfzapgq1xmc";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."nix"."0.13.0"."bitflags"}" deps)
      (crates."cfg_if"."${deps."nix"."0.13.0"."cfg_if"}" deps)
      (crates."libc"."${deps."nix"."0.13.0"."libc"}" deps)
      (crates."void"."${deps."nix"."0.13.0"."void"}" deps)
    ])
      ++ (if kernel == "dragonfly" then mapFeatures features ([
]) else [])
      ++ (if kernel == "freebsd" then mapFeatures features ([
]) else []);
  };
  features_.nix."0.13.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.nix."0.13.0".bitflags}".default = true;
    cfg_if."${deps.nix."0.13.0".cfg_if}".default = true;
    libc."${deps.nix."0.13.0".libc}".default = true;
    nix."0.13.0".default = (f.nix."0.13.0".default or true);
    void."${deps.nix."0.13.0".void}".default = true;
  }) [
    (features_.bitflags."${deps."nix"."0.13.0"."bitflags"}" deps)
    (features_.cfg_if."${deps."nix"."0.13.0"."cfg_if"}" deps)
    (features_.libc."${deps."nix"."0.13.0"."libc"}" deps)
    (features_.void."${deps."nix"."0.13.0"."void"}" deps)
  ];


# end
# nodrop-0.1.12

  crates.nodrop."0.1.12" = deps: { features?(features_.nodrop."0.1.12" deps {}) }: buildRustCrate {
    crateName = "nodrop";
    version = "0.1.12";
    authors = [ "bluss" ];
    sha256 = "1b9rxvdg8061gxjc239l9slndf0ds3m6fy2sf3gs8f9kknqgl49d";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."nodrop"."0.1.12" or {});
  };
  features_.nodrop."0.1.12" = deps: f: updateFeatures f (rec {
    nodrop = fold recursiveUpdate {} [
      { "0.1.12".default = (f.nodrop."0.1.12".default or true); }
      { "0.1.12".nodrop-union =
        (f.nodrop."0.1.12".nodrop-union or false) ||
        (f.nodrop."0.1.12".use_union or false) ||
        (nodrop."0.1.12"."use_union" or false); }
      { "0.1.12".std =
        (f.nodrop."0.1.12".std or false) ||
        (f.nodrop."0.1.12".default or false) ||
        (nodrop."0.1.12"."default" or false); }
    ];
  }) [];


# end
# nodrop-0.1.13

  crates.nodrop."0.1.13" = deps: { features?(features_.nodrop."0.1.13" deps {}) }: buildRustCrate {
    crateName = "nodrop";
    version = "0.1.13";
    authors = [ "bluss" ];
    sha256 = "0gkfx6wihr9z0m8nbdhma5pyvbipznjpkzny2d4zkc05b0vnhinb";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."nodrop"."0.1.13" or {});
  };
  features_.nodrop."0.1.13" = deps: f: updateFeatures f (rec {
    nodrop = fold recursiveUpdate {} [
      { "0.1.13".default = (f.nodrop."0.1.13".default or true); }
      { "0.1.13".nodrop-union =
        (f.nodrop."0.1.13".nodrop-union or false) ||
        (f.nodrop."0.1.13".use_union or false) ||
        (nodrop."0.1.13"."use_union" or false); }
      { "0.1.13".std =
        (f.nodrop."0.1.13".std or false) ||
        (f.nodrop."0.1.13".default or false) ||
        (nodrop."0.1.13"."default" or false); }
    ];
  }) [];


# end
# nom-3.2.1

  crates.nom."3.2.1" = deps: { features?(features_.nom."3.2.1" deps {}) }: buildRustCrate {
    crateName = "nom";
    version = "3.2.1";
    authors = [ "contact@geoffroycouprie.com" ];
    sha256 = "1vcllxrz9hdw6j25kn020ka3psz1vkaqh1hm3yfak2240zrxgi07";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."nom"."3.2.1"."memchr"}" deps)
    ]);
    features = mkFeatures (features."nom"."3.2.1" or {});
  };
  features_.nom."3.2.1" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "${deps.nom."3.2.1".memchr}"."use_std" =
        (f.memchr."${deps.nom."3.2.1".memchr}"."use_std" or false) ||
        (nom."3.2.1"."std" or false) ||
        (f."nom"."3.2.1"."std" or false); }
      { "${deps.nom."3.2.1".memchr}".default = (f.memchr."${deps.nom."3.2.1".memchr}".default or false); }
    ];
    nom = fold recursiveUpdate {} [
      { "3.2.1".compiler_error =
        (f.nom."3.2.1".compiler_error or false) ||
        (f.nom."3.2.1".nightly or false) ||
        (nom."3.2.1"."nightly" or false); }
      { "3.2.1".default = (f.nom."3.2.1".default or true); }
      { "3.2.1".lazy_static =
        (f.nom."3.2.1".lazy_static or false) ||
        (f.nom."3.2.1".regexp_macros or false) ||
        (nom."3.2.1"."regexp_macros" or false); }
      { "3.2.1".regex =
        (f.nom."3.2.1".regex or false) ||
        (f.nom."3.2.1".regexp or false) ||
        (nom."3.2.1"."regexp" or false); }
      { "3.2.1".regexp =
        (f.nom."3.2.1".regexp or false) ||
        (f.nom."3.2.1".regexp_macros or false) ||
        (nom."3.2.1"."regexp_macros" or false); }
      { "3.2.1".std =
        (f.nom."3.2.1".std or false) ||
        (f.nom."3.2.1".default or false) ||
        (nom."3.2.1"."default" or false); }
      { "3.2.1".stream =
        (f.nom."3.2.1".stream or false) ||
        (f.nom."3.2.1".default or false) ||
        (nom."3.2.1"."default" or false); }
    ];
  }) [
    (features_.memchr."${deps."nom"."3.2.1"."memchr"}" deps)
  ];


# end
# nom-4.2.2

  crates.nom."4.2.2" = deps: { features?(features_.nom."4.2.2" deps {}) }: buildRustCrate {
    crateName = "nom";
    version = "4.2.2";
    authors = [ "contact@geoffroycouprie.com" ];
    sha256 = "1sk6nzd30x1p800m5ci1j6vl420fz2iw338ky269kqjglwf4hl5h";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."nom"."4.2.2"."memchr"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."nom"."4.2.2"."version_check"}" deps)
    ]);
    features = mkFeatures (features."nom"."4.2.2" or {});
  };
  features_.nom."4.2.2" = deps: f: updateFeatures f (rec {
    memchr = fold recursiveUpdate {} [
      { "${deps.nom."4.2.2".memchr}"."use_std" =
        (f.memchr."${deps.nom."4.2.2".memchr}"."use_std" or false) ||
        (nom."4.2.2"."std" or false) ||
        (f."nom"."4.2.2"."std" or false); }
      { "${deps.nom."4.2.2".memchr}".default = (f.memchr."${deps.nom."4.2.2".memchr}".default or false); }
    ];
    nom = fold recursiveUpdate {} [
      { "4.2.2".alloc =
        (f.nom."4.2.2".alloc or false) ||
        (f.nom."4.2.2".std or false) ||
        (nom."4.2.2"."std" or false) ||
        (f.nom."4.2.2".verbose-errors or false) ||
        (nom."4.2.2"."verbose-errors" or false); }
      { "4.2.2".default = (f.nom."4.2.2".default or true); }
      { "4.2.2".lazy_static =
        (f.nom."4.2.2".lazy_static or false) ||
        (f.nom."4.2.2".regexp_macros or false) ||
        (nom."4.2.2"."regexp_macros" or false); }
      { "4.2.2".regex =
        (f.nom."4.2.2".regex or false) ||
        (f.nom."4.2.2".regexp or false) ||
        (nom."4.2.2"."regexp" or false); }
      { "4.2.2".regexp =
        (f.nom."4.2.2".regexp or false) ||
        (f.nom."4.2.2".regexp_macros or false) ||
        (nom."4.2.2"."regexp_macros" or false); }
      { "4.2.2".std =
        (f.nom."4.2.2".std or false) ||
        (f.nom."4.2.2".default or false) ||
        (nom."4.2.2"."default" or false); }
    ];
    version_check."${deps.nom."4.2.2".version_check}".default = true;
  }) [
    (features_.memchr."${deps."nom"."4.2.2"."memchr"}" deps)
    (features_.version_check."${deps."nom"."4.2.2"."version_check"}" deps)
  ];


# end
# num-0.1.42

  crates.num."0.1.42" = deps: { features?(features_.num."0.1.42" deps {}) }: buildRustCrate {
    crateName = "num";
    version = "0.1.42";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1632gczzrmmxdsj3jignwcr793jq8vxw3qkdzpdvbip3vaf1ljgq";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num"."0.1.42"."num_integer"}" deps)
      (crates."num_iter"."${deps."num"."0.1.42"."num_iter"}" deps)
      (crates."num_traits"."${deps."num"."0.1.42"."num_traits"}" deps)
    ]
      ++ (if features.num."0.1.42".num-bigint or false then [ (crates.num_bigint."${deps."num"."0.1.42".num_bigint}" deps) ] else [])
      ++ (if features.num."0.1.42".num-complex or false then [ (crates.num_complex."${deps."num"."0.1.42".num_complex}" deps) ] else [])
      ++ (if features.num."0.1.42".num-rational or false then [ (crates.num_rational."${deps."num"."0.1.42".num_rational}" deps) ] else []));
    features = mkFeatures (features."num"."0.1.42" or {});
  };
  features_.num."0.1.42" = deps: f: updateFeatures f (rec {
    num = fold recursiveUpdate {} [
      { "0.1.42".bigint =
        (f.num."0.1.42".bigint or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
      { "0.1.42".complex =
        (f.num."0.1.42".complex or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
      { "0.1.42".default = (f.num."0.1.42".default or true); }
      { "0.1.42".num-bigint =
        (f.num."0.1.42".num-bigint or false) ||
        (f.num."0.1.42".bigint or false) ||
        (num."0.1.42"."bigint" or false); }
      { "0.1.42".num-complex =
        (f.num."0.1.42".num-complex or false) ||
        (f.num."0.1.42".complex or false) ||
        (num."0.1.42"."complex" or false); }
      { "0.1.42".num-rational =
        (f.num."0.1.42".num-rational or false) ||
        (f.num."0.1.42".rational or false) ||
        (num."0.1.42"."rational" or false); }
      { "0.1.42".rational =
        (f.num."0.1.42".rational or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
      { "0.1.42".rustc-serialize =
        (f.num."0.1.42".rustc-serialize or false) ||
        (f.num."0.1.42".default or false) ||
        (num."0.1.42"."default" or false); }
    ];
    num_bigint = fold recursiveUpdate {} [
      { "${deps.num."0.1.42".num_bigint}"."rustc-serialize" =
        (f.num_bigint."${deps.num."0.1.42".num_bigint}"."rustc-serialize" or false) ||
        (num."0.1.42"."rustc-serialize" or false) ||
        (f."num"."0.1.42"."rustc-serialize" or false); }
      { "${deps.num."0.1.42".num_bigint}"."serde" =
        (f.num_bigint."${deps.num."0.1.42".num_bigint}"."serde" or false) ||
        (num."0.1.42"."serde" or false) ||
        (f."num"."0.1.42"."serde" or false); }
      { "${deps.num."0.1.42".num_bigint}".default = true; }
    ];
    num_complex = fold recursiveUpdate {} [
      { "${deps.num."0.1.42".num_complex}"."rustc-serialize" =
        (f.num_complex."${deps.num."0.1.42".num_complex}"."rustc-serialize" or false) ||
        (num."0.1.42"."rustc-serialize" or false) ||
        (f."num"."0.1.42"."rustc-serialize" or false); }
      { "${deps.num."0.1.42".num_complex}"."serde" =
        (f.num_complex."${deps.num."0.1.42".num_complex}"."serde" or false) ||
        (num."0.1.42"."serde" or false) ||
        (f."num"."0.1.42"."serde" or false); }
      { "${deps.num."0.1.42".num_complex}".default = true; }
    ];
    num_integer."${deps.num."0.1.42".num_integer}".default = true;
    num_iter."${deps.num."0.1.42".num_iter}".default = true;
    num_rational = fold recursiveUpdate {} [
      { "${deps.num."0.1.42".num_rational}"."rustc-serialize" =
        (f.num_rational."${deps.num."0.1.42".num_rational}"."rustc-serialize" or false) ||
        (num."0.1.42"."rustc-serialize" or false) ||
        (f."num"."0.1.42"."rustc-serialize" or false); }
      { "${deps.num."0.1.42".num_rational}"."serde" =
        (f.num_rational."${deps.num."0.1.42".num_rational}"."serde" or false) ||
        (num."0.1.42"."serde" or false) ||
        (f."num"."0.1.42"."serde" or false); }
      { "${deps.num."0.1.42".num_rational}".default = true; }
    ];
    num_traits."${deps.num."0.1.42".num_traits}".default = true;
  }) [
    (features_.num_bigint."${deps."num"."0.1.42"."num_bigint"}" deps)
    (features_.num_complex."${deps."num"."0.1.42"."num_complex"}" deps)
    (features_.num_integer."${deps."num"."0.1.42"."num_integer"}" deps)
    (features_.num_iter."${deps."num"."0.1.42"."num_iter"}" deps)
    (features_.num_rational."${deps."num"."0.1.42"."num_rational"}" deps)
    (features_.num_traits."${deps."num"."0.1.42"."num_traits"}" deps)
  ];


# end
# num-bigint-0.1.44

  crates.num_bigint."0.1.44" = deps: { features?(features_.num_bigint."0.1.44" deps {}) }: buildRustCrate {
    crateName = "num-bigint";
    version = "0.1.44";
    authors = [ "The Rust Project Developers" ];
    sha256 = "13sf3jhjs6y7cnfrdxns0k8vmbxwjl038wm3yl08b3dbrla7hvx1";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_bigint"."0.1.44"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_bigint"."0.1.44"."num_traits"}" deps)
    ]
      ++ (if features.num_bigint."0.1.44".rand or false then [ (crates.rand."${deps."num_bigint"."0.1.44".rand}" deps) ] else [])
      ++ (if features.num_bigint."0.1.44".rustc-serialize or false then [ (crates.rustc_serialize."${deps."num_bigint"."0.1.44".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."num_bigint"."0.1.44" or {});
  };
  features_.num_bigint."0.1.44" = deps: f: updateFeatures f (rec {
    num_bigint = fold recursiveUpdate {} [
      { "0.1.44".default = (f.num_bigint."0.1.44".default or true); }
      { "0.1.44".rand =
        (f.num_bigint."0.1.44".rand or false) ||
        (f.num_bigint."0.1.44".default or false) ||
        (num_bigint."0.1.44"."default" or false); }
      { "0.1.44".rustc-serialize =
        (f.num_bigint."0.1.44".rustc-serialize or false) ||
        (f.num_bigint."0.1.44".default or false) ||
        (num_bigint."0.1.44"."default" or false); }
    ];
    num_integer."${deps.num_bigint."0.1.44".num_integer}".default = (f.num_integer."${deps.num_bigint."0.1.44".num_integer}".default or false);
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_bigint."0.1.44".num_traits}"."std" = true; }
      { "${deps.num_bigint."0.1.44".num_traits}".default = (f.num_traits."${deps.num_bigint."0.1.44".num_traits}".default or false); }
    ];
    rand."${deps.num_bigint."0.1.44".rand}".default = true;
    rustc_serialize."${deps.num_bigint."0.1.44".rustc_serialize}".default = true;
  }) [
    (features_.num_integer."${deps."num_bigint"."0.1.44"."num_integer"}" deps)
    (features_.num_traits."${deps."num_bigint"."0.1.44"."num_traits"}" deps)
    (features_.rand."${deps."num_bigint"."0.1.44"."rand"}" deps)
    (features_.rustc_serialize."${deps."num_bigint"."0.1.44"."rustc_serialize"}" deps)
  ];


# end
# num-complex-0.1.43

  crates.num_complex."0.1.43" = deps: { features?(features_.num_complex."0.1.43" deps {}) }: buildRustCrate {
    crateName = "num-complex";
    version = "0.1.43";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1rs1rhwcxsdamllz1p88ibi8g8s4hhx8rqvvp819x71zphgpqsa2";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_complex"."0.1.43"."num_traits"}" deps)
    ]
      ++ (if features.num_complex."0.1.43".rustc-serialize or false then [ (crates.rustc_serialize."${deps."num_complex"."0.1.43".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."num_complex"."0.1.43" or {});
  };
  features_.num_complex."0.1.43" = deps: f: updateFeatures f (rec {
    num_complex = fold recursiveUpdate {} [
      { "0.1.43".default = (f.num_complex."0.1.43".default or true); }
      { "0.1.43".rustc-serialize =
        (f.num_complex."0.1.43".rustc-serialize or false) ||
        (f.num_complex."0.1.43".default or false) ||
        (num_complex."0.1.43"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_complex."0.1.43".num_traits}"."std" = true; }
      { "${deps.num_complex."0.1.43".num_traits}".default = (f.num_traits."${deps.num_complex."0.1.43".num_traits}".default or false); }
    ];
    rustc_serialize."${deps.num_complex."0.1.43".rustc_serialize}".default = true;
  }) [
    (features_.num_traits."${deps."num_complex"."0.1.43"."num_traits"}" deps)
    (features_.rustc_serialize."${deps."num_complex"."0.1.43"."rustc_serialize"}" deps)
  ];


# end
# num-derive-0.2.4

  crates.num_derive."0.2.4" = deps: { features?(features_.num_derive."0.2.4" deps {}) }: buildRustCrate {
    crateName = "num-derive";
    version = "0.2.4";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0dr6ds4cxpscjmvaq8w55zgj9dcv7gjj0rxm9yzadbaf5rapmzjc";
    libName = "num_derive";
    procMacro = true;
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."num_derive"."0.2.4"."proc_macro2"}" deps)
      (crates."quote"."${deps."num_derive"."0.2.4"."quote"}" deps)
      (crates."syn"."${deps."num_derive"."0.2.4"."syn"}" deps)
    ]);
    features = mkFeatures (features."num_derive"."0.2.4" or {});
  };
  features_.num_derive."0.2.4" = deps: f: updateFeatures f (rec {
    num_derive."0.2.4".default = (f.num_derive."0.2.4".default or true);
    proc_macro2."${deps.num_derive."0.2.4".proc_macro2}".default = true;
    quote."${deps.num_derive."0.2.4".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.num_derive."0.2.4".syn}"."full" =
        (f.syn."${deps.num_derive."0.2.4".syn}"."full" or false) ||
        (num_derive."0.2.4"."full-syntax" or false) ||
        (f."num_derive"."0.2.4"."full-syntax" or false); }
      { "${deps.num_derive."0.2.4".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."num_derive"."0.2.4"."proc_macro2"}" deps)
    (features_.quote."${deps."num_derive"."0.2.4"."quote"}" deps)
    (features_.syn."${deps."num_derive"."0.2.4"."syn"}" deps)
  ];


# end
# num-integer-0.1.39

  crates.num_integer."0.1.39" = deps: { features?(features_.num_integer."0.1.39" deps {}) }: buildRustCrate {
    crateName = "num-integer";
    version = "0.1.39";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1f42ls46cghs13qfzgbd7syib2zc6m7hlmv1qlar6c9mdxapvvbg";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."num_traits"."${deps."num_integer"."0.1.39"."num_traits"}" deps)
    ]);
    features = mkFeatures (features."num_integer"."0.1.39" or {});
  };
  features_.num_integer."0.1.39" = deps: f: updateFeatures f (rec {
    num_integer = fold recursiveUpdate {} [
      { "0.1.39".default = (f.num_integer."0.1.39".default or true); }
      { "0.1.39".std =
        (f.num_integer."0.1.39".std or false) ||
        (f.num_integer."0.1.39".default or false) ||
        (num_integer."0.1.39"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_integer."0.1.39".num_traits}"."i128" =
        (f.num_traits."${deps.num_integer."0.1.39".num_traits}"."i128" or false) ||
        (num_integer."0.1.39"."i128" or false) ||
        (f."num_integer"."0.1.39"."i128" or false); }
      { "${deps.num_integer."0.1.39".num_traits}"."std" =
        (f.num_traits."${deps.num_integer."0.1.39".num_traits}"."std" or false) ||
        (num_integer."0.1.39"."std" or false) ||
        (f."num_integer"."0.1.39"."std" or false); }
      { "${deps.num_integer."0.1.39".num_traits}".default = (f.num_traits."${deps.num_integer."0.1.39".num_traits}".default or false); }
    ];
  }) [
    (features_.num_traits."${deps."num_integer"."0.1.39"."num_traits"}" deps)
  ];


# end
# num-iter-0.1.37

  crates.num_iter."0.1.37" = deps: { features?(features_.num_iter."0.1.37" deps {}) }: buildRustCrate {
    crateName = "num-iter";
    version = "0.1.37";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1rglyvi4yjfxfvfm2s7i60g1dkl5xmsyi77g6vy53jb11r6wl8ly";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_iter"."0.1.37"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_iter"."0.1.37"."num_traits"}" deps)
    ]);
    features = mkFeatures (features."num_iter"."0.1.37" or {});
  };
  features_.num_iter."0.1.37" = deps: f: updateFeatures f (rec {
    num_integer = fold recursiveUpdate {} [
      { "${deps.num_iter."0.1.37".num_integer}"."i128" =
        (f.num_integer."${deps.num_iter."0.1.37".num_integer}"."i128" or false) ||
        (num_iter."0.1.37"."i128" or false) ||
        (f."num_iter"."0.1.37"."i128" or false); }
      { "${deps.num_iter."0.1.37".num_integer}"."std" =
        (f.num_integer."${deps.num_iter."0.1.37".num_integer}"."std" or false) ||
        (num_iter."0.1.37"."std" or false) ||
        (f."num_iter"."0.1.37"."std" or false); }
      { "${deps.num_iter."0.1.37".num_integer}".default = (f.num_integer."${deps.num_iter."0.1.37".num_integer}".default or false); }
    ];
    num_iter = fold recursiveUpdate {} [
      { "0.1.37".default = (f.num_iter."0.1.37".default or true); }
      { "0.1.37".std =
        (f.num_iter."0.1.37".std or false) ||
        (f.num_iter."0.1.37".default or false) ||
        (num_iter."0.1.37"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_iter."0.1.37".num_traits}"."i128" =
        (f.num_traits."${deps.num_iter."0.1.37".num_traits}"."i128" or false) ||
        (num_iter."0.1.37"."i128" or false) ||
        (f."num_iter"."0.1.37"."i128" or false); }
      { "${deps.num_iter."0.1.37".num_traits}"."std" =
        (f.num_traits."${deps.num_iter."0.1.37".num_traits}"."std" or false) ||
        (num_iter."0.1.37"."std" or false) ||
        (f."num_iter"."0.1.37"."std" or false); }
      { "${deps.num_iter."0.1.37".num_traits}".default = (f.num_traits."${deps.num_iter."0.1.37".num_traits}".default or false); }
    ];
  }) [
    (features_.num_integer."${deps."num_iter"."0.1.37"."num_integer"}" deps)
    (features_.num_traits."${deps."num_iter"."0.1.37"."num_traits"}" deps)
  ];


# end
# num-rational-0.1.42

  crates.num_rational."0.1.42" = deps: { features?(features_.num_rational."0.1.42" deps {}) }: buildRustCrate {
    crateName = "num-rational";
    version = "0.1.42";
    authors = [ "The Rust Project Developers" ];
    sha256 = "09gfmmak5p77rvi2mcsqsalzi81nc93nc8ipchnjv5b8lwn8mm89";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_rational"."0.1.42"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_rational"."0.1.42"."num_traits"}" deps)
    ]
      ++ (if features.num_rational."0.1.42".num-bigint or false then [ (crates.num_bigint."${deps."num_rational"."0.1.42".num_bigint}" deps) ] else [])
      ++ (if features.num_rational."0.1.42".rustc-serialize or false then [ (crates.rustc_serialize."${deps."num_rational"."0.1.42".rustc_serialize}" deps) ] else []));
    features = mkFeatures (features."num_rational"."0.1.42" or {});
  };
  features_.num_rational."0.1.42" = deps: f: updateFeatures f (rec {
    num_bigint."${deps.num_rational."0.1.42".num_bigint}".default = true;
    num_integer."${deps.num_rational."0.1.42".num_integer}".default = (f.num_integer."${deps.num_rational."0.1.42".num_integer}".default or false);
    num_rational = fold recursiveUpdate {} [
      { "0.1.42".bigint =
        (f.num_rational."0.1.42".bigint or false) ||
        (f.num_rational."0.1.42".default or false) ||
        (num_rational."0.1.42"."default" or false); }
      { "0.1.42".default = (f.num_rational."0.1.42".default or true); }
      { "0.1.42".num-bigint =
        (f.num_rational."0.1.42".num-bigint or false) ||
        (f.num_rational."0.1.42".bigint or false) ||
        (num_rational."0.1.42"."bigint" or false); }
      { "0.1.42".rustc-serialize =
        (f.num_rational."0.1.42".rustc-serialize or false) ||
        (f.num_rational."0.1.42".default or false) ||
        (num_rational."0.1.42"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_rational."0.1.42".num_traits}"."std" = true; }
      { "${deps.num_rational."0.1.42".num_traits}".default = (f.num_traits."${deps.num_rational."0.1.42".num_traits}".default or false); }
    ];
    rustc_serialize."${deps.num_rational."0.1.42".rustc_serialize}".default = true;
  }) [
    (features_.num_bigint."${deps."num_rational"."0.1.42"."num_bigint"}" deps)
    (features_.num_integer."${deps."num_rational"."0.1.42"."num_integer"}" deps)
    (features_.num_traits."${deps."num_rational"."0.1.42"."num_traits"}" deps)
    (features_.rustc_serialize."${deps."num_rational"."0.1.42"."rustc_serialize"}" deps)
  ];


# end
# num-rational-0.2.1

  crates.num_rational."0.2.1" = deps: { features?(features_.num_rational."0.2.1" deps {}) }: buildRustCrate {
    crateName = "num-rational";
    version = "0.2.1";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0zcldi5935qyphm1vadwn2x34h90w3rk5x631wxk6l08z1d58hbq";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."num_integer"."${deps."num_rational"."0.2.1"."num_integer"}" deps)
      (crates."num_traits"."${deps."num_rational"."0.2.1"."num_traits"}" deps)
    ]);
    features = mkFeatures (features."num_rational"."0.2.1" or {});
  };
  features_.num_rational."0.2.1" = deps: f: updateFeatures f (rec {
    num_integer = fold recursiveUpdate {} [
      { "${deps.num_rational."0.2.1".num_integer}"."i128" =
        (f.num_integer."${deps.num_rational."0.2.1".num_integer}"."i128" or false) ||
        (num_rational."0.2.1"."i128" or false) ||
        (f."num_rational"."0.2.1"."i128" or false); }
      { "${deps.num_rational."0.2.1".num_integer}"."std" =
        (f.num_integer."${deps.num_rational."0.2.1".num_integer}"."std" or false) ||
        (num_rational."0.2.1"."std" or false) ||
        (f."num_rational"."0.2.1"."std" or false); }
      { "${deps.num_rational."0.2.1".num_integer}".default = (f.num_integer."${deps.num_rational."0.2.1".num_integer}".default or false); }
    ];
    num_rational = fold recursiveUpdate {} [
      { "0.2.1".bigint =
        (f.num_rational."0.2.1".bigint or false) ||
        (f.num_rational."0.2.1".bigint-std or false) ||
        (num_rational."0.2.1"."bigint-std" or false); }
      { "0.2.1".bigint-std =
        (f.num_rational."0.2.1".bigint-std or false) ||
        (f.num_rational."0.2.1".default or false) ||
        (num_rational."0.2.1"."default" or false); }
      { "0.2.1".default = (f.num_rational."0.2.1".default or true); }
      { "0.2.1".num-bigint =
        (f.num_rational."0.2.1".num-bigint or false) ||
        (f.num_rational."0.2.1".bigint or false) ||
        (num_rational."0.2.1"."bigint" or false); }
      { "0.2.1".std =
        (f.num_rational."0.2.1".std or false) ||
        (f.num_rational."0.2.1".default or false) ||
        (num_rational."0.2.1"."default" or false); }
    ];
    num_traits = fold recursiveUpdate {} [
      { "${deps.num_rational."0.2.1".num_traits}"."i128" =
        (f.num_traits."${deps.num_rational."0.2.1".num_traits}"."i128" or false) ||
        (num_rational."0.2.1"."i128" or false) ||
        (f."num_rational"."0.2.1"."i128" or false); }
      { "${deps.num_rational."0.2.1".num_traits}"."std" =
        (f.num_traits."${deps.num_rational."0.2.1".num_traits}"."std" or false) ||
        (num_rational."0.2.1"."std" or false) ||
        (f."num_rational"."0.2.1"."std" or false); }
      { "${deps.num_rational."0.2.1".num_traits}".default = (f.num_traits."${deps.num_rational."0.2.1".num_traits}".default or false); }
    ];
  }) [
    (features_.num_integer."${deps."num_rational"."0.2.1"."num_integer"}" deps)
    (features_.num_traits."${deps."num_rational"."0.2.1"."num_traits"}" deps)
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
# num_cpus-1.10.0

  crates.num_cpus."1.10.0" = deps: { features?(features_.num_cpus."1.10.0" deps {}) }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.10.0";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1411jyxy1wd8d59mv7cf6ynkvvar92czmwhb9l2c1brdkxbbiqn7";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."num_cpus"."1.10.0"."libc"}" deps)
    ]);
  };
  features_.num_cpus."1.10.0" = deps: f: updateFeatures f (rec {
    libc."${deps.num_cpus."1.10.0".libc}".default = true;
    num_cpus."1.10.0".default = (f.num_cpus."1.10.0".default or true);
  }) [
    (features_.libc."${deps."num_cpus"."1.10.0"."libc"}" deps)
  ];


# end
# opaque-debug-0.2.2

  crates.opaque_debug."0.2.2" = deps: { features?(features_.opaque_debug."0.2.2" deps {}) }: buildRustCrate {
    crateName = "opaque-debug";
    version = "0.2.2";
    authors = [ "RustCrypto Developers" ];
    sha256 = "0dkzsnxpg50gz3gjcdzc4j6g4s0jphllg6q7jqmsy9nd9glidy74";
  };
  features_.opaque_debug."0.2.2" = deps: f: updateFeatures f (rec {
    opaque_debug."0.2.2".default = (f.opaque_debug."0.2.2".default or true);
  }) [];


# end
# openssl-0.10.19

  crates.openssl."0.10.19" = deps: { features?(features_.openssl."0.10.19" deps {}) }: buildRustCrate {
    crateName = "openssl";
    version = "0.10.19";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1vs2n3izv57cycdjhiy1799zhmzigx7qm1j0kb88qij2rdcxgzam";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."openssl"."0.10.19"."bitflags"}" deps)
      (crates."cfg_if"."${deps."openssl"."0.10.19"."cfg_if"}" deps)
      (crates."foreign_types"."${deps."openssl"."0.10.19"."foreign_types"}" deps)
      (crates."lazy_static"."${deps."openssl"."0.10.19"."lazy_static"}" deps)
      (crates."libc"."${deps."openssl"."0.10.19"."libc"}" deps)
      (crates."openssl_sys"."${deps."openssl"."0.10.19"."openssl_sys"}" deps)
    ]);
    features = mkFeatures (features."openssl"."0.10.19" or {});
  };
  features_.openssl."0.10.19" = deps: f: updateFeatures f (rec {
    bitflags."${deps.openssl."0.10.19".bitflags}".default = true;
    cfg_if."${deps.openssl."0.10.19".cfg_if}".default = true;
    foreign_types."${deps.openssl."0.10.19".foreign_types}".default = true;
    lazy_static."${deps.openssl."0.10.19".lazy_static}".default = true;
    libc."${deps.openssl."0.10.19".libc}".default = true;
    openssl."0.10.19".default = (f.openssl."0.10.19".default or true);
    openssl_sys = fold recursiveUpdate {} [
      { "${deps.openssl."0.10.19".openssl_sys}"."vendored" =
        (f.openssl_sys."${deps.openssl."0.10.19".openssl_sys}"."vendored" or false) ||
        (openssl."0.10.19"."vendored" or false) ||
        (f."openssl"."0.10.19"."vendored" or false); }
      { "${deps.openssl."0.10.19".openssl_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."openssl"."0.10.19"."bitflags"}" deps)
    (features_.cfg_if."${deps."openssl"."0.10.19"."cfg_if"}" deps)
    (features_.foreign_types."${deps."openssl"."0.10.19"."foreign_types"}" deps)
    (features_.lazy_static."${deps."openssl"."0.10.19"."lazy_static"}" deps)
    (features_.libc."${deps."openssl"."0.10.19"."libc"}" deps)
    (features_.openssl_sys."${deps."openssl"."0.10.19"."openssl_sys"}" deps)
  ];


# end
# openssl-probe-0.1.2

  crates.openssl_probe."0.1.2" = deps: { features?(features_.openssl_probe."0.1.2" deps {}) }: buildRustCrate {
    crateName = "openssl-probe";
    version = "0.1.2";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1a89fznx26vvaxyrxdvgf6iwai5xvs6xjvpjin68fgvrslv6n15a";
  };
  features_.openssl_probe."0.1.2" = deps: f: updateFeatures f (rec {
    openssl_probe."0.1.2".default = (f.openssl_probe."0.1.2".default or true);
  }) [];


# end
# openssl-sys-0.9.42

  crates.openssl_sys."0.9.42" = deps: { features?(features_.openssl_sys."0.9.42" deps {}) }: buildRustCrate {
    crateName = "openssl-sys";
    version = "0.9.42";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1s2bkfkpqfyis5b0q5piki64r7dywqpk49g6b6dsgzmbnzyhn78v";
    build = "build/main.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."openssl_sys"."0.9.42"."libc"}" deps)
    ])
      ++ (if abi == "msvc" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."openssl_sys"."0.9.42"."cc"}" deps)
      (crates."pkg_config"."${deps."openssl_sys"."0.9.42"."pkg_config"}" deps)
      (crates."rustc_version"."${deps."openssl_sys"."0.9.42"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."openssl_sys"."0.9.42" or {});
  };
  features_.openssl_sys."0.9.42" = deps: f: updateFeatures f (rec {
    cc."${deps.openssl_sys."0.9.42".cc}".default = true;
    libc."${deps.openssl_sys."0.9.42".libc}".default = true;
    openssl_sys = fold recursiveUpdate {} [
      { "0.9.42".default = (f.openssl_sys."0.9.42".default or true); }
      { "0.9.42".openssl-src =
        (f.openssl_sys."0.9.42".openssl-src or false) ||
        (f.openssl_sys."0.9.42".vendored or false) ||
        (openssl_sys."0.9.42"."vendored" or false); }
    ];
    pkg_config."${deps.openssl_sys."0.9.42".pkg_config}".default = true;
    rustc_version."${deps.openssl_sys."0.9.42".rustc_version}".default = true;
  }) [
    (features_.libc."${deps."openssl_sys"."0.9.42"."libc"}" deps)
    (features_.cc."${deps."openssl_sys"."0.9.42"."cc"}" deps)
    (features_.pkg_config."${deps."openssl_sys"."0.9.42"."pkg_config"}" deps)
    (features_.rustc_version."${deps."openssl_sys"."0.9.42"."rustc_version"}" deps)
  ];


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
# owning_ref-0.4.0

  crates.owning_ref."0.4.0" = deps: { features?(features_.owning_ref."0.4.0" deps {}) }: buildRustCrate {
    crateName = "owning_ref";
    version = "0.4.0";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1m95qpc3hamkw9wlbfzqkzk7h6skyj40zr6sa3ps151slcfnnchm";
    dependencies = mapFeatures features ([
      (crates."stable_deref_trait"."${deps."owning_ref"."0.4.0"."stable_deref_trait"}" deps)
    ]);
  };
  features_.owning_ref."0.4.0" = deps: f: updateFeatures f (rec {
    owning_ref."0.4.0".default = (f.owning_ref."0.4.0".default or true);
    stable_deref_trait."${deps.owning_ref."0.4.0".stable_deref_trait}".default = true;
  }) [
    (features_.stable_deref_trait."${deps."owning_ref"."0.4.0"."stable_deref_trait"}" deps)
  ];


# end
# parking_lot-0.7.1

  crates.parking_lot."0.7.1" = deps: { features?(features_.parking_lot."0.7.1" deps {}) }: buildRustCrate {
    crateName = "parking_lot";
    version = "0.7.1";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "1qpb49xd176hqqabxdb48f1hvylfbf68rpz8yfrhw0x68ys0lkq1";
    dependencies = mapFeatures features ([
      (crates."lock_api"."${deps."parking_lot"."0.7.1"."lock_api"}" deps)
      (crates."parking_lot_core"."${deps."parking_lot"."0.7.1"."parking_lot_core"}" deps)
    ]);
    features = mkFeatures (features."parking_lot"."0.7.1" or {});
  };
  features_.parking_lot."0.7.1" = deps: f: updateFeatures f (rec {
    lock_api = fold recursiveUpdate {} [
      { "${deps.parking_lot."0.7.1".lock_api}"."nightly" =
        (f.lock_api."${deps.parking_lot."0.7.1".lock_api}"."nightly" or false) ||
        (parking_lot."0.7.1"."nightly" or false) ||
        (f."parking_lot"."0.7.1"."nightly" or false); }
      { "${deps.parking_lot."0.7.1".lock_api}"."owning_ref" =
        (f.lock_api."${deps.parking_lot."0.7.1".lock_api}"."owning_ref" or false) ||
        (parking_lot."0.7.1"."owning_ref" or false) ||
        (f."parking_lot"."0.7.1"."owning_ref" or false); }
      { "${deps.parking_lot."0.7.1".lock_api}".default = true; }
    ];
    parking_lot = fold recursiveUpdate {} [
      { "0.7.1".default = (f.parking_lot."0.7.1".default or true); }
      { "0.7.1".owning_ref =
        (f.parking_lot."0.7.1".owning_ref or false) ||
        (f.parking_lot."0.7.1".default or false) ||
        (parking_lot."0.7.1"."default" or false); }
    ];
    parking_lot_core = fold recursiveUpdate {} [
      { "${deps.parking_lot."0.7.1".parking_lot_core}"."deadlock_detection" =
        (f.parking_lot_core."${deps.parking_lot."0.7.1".parking_lot_core}"."deadlock_detection" or false) ||
        (parking_lot."0.7.1"."deadlock_detection" or false) ||
        (f."parking_lot"."0.7.1"."deadlock_detection" or false); }
      { "${deps.parking_lot."0.7.1".parking_lot_core}"."nightly" =
        (f.parking_lot_core."${deps.parking_lot."0.7.1".parking_lot_core}"."nightly" or false) ||
        (parking_lot."0.7.1"."nightly" or false) ||
        (f."parking_lot"."0.7.1"."nightly" or false); }
      { "${deps.parking_lot."0.7.1".parking_lot_core}".default = true; }
    ];
  }) [
    (features_.lock_api."${deps."parking_lot"."0.7.1"."lock_api"}" deps)
    (features_.parking_lot_core."${deps."parking_lot"."0.7.1"."parking_lot_core"}" deps)
  ];


# end
# parking_lot_core-0.4.0

  crates.parking_lot_core."0.4.0" = deps: { features?(features_.parking_lot_core."0.4.0" deps {}) }: buildRustCrate {
    crateName = "parking_lot_core";
    version = "0.4.0";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "1mzk5i240ddvhwnz65hhjk4cq61z235g1n8bd7al4mg6vx437c16";
    dependencies = mapFeatures features ([
      (crates."rand"."${deps."parking_lot_core"."0.4.0"."rand"}" deps)
      (crates."smallvec"."${deps."parking_lot_core"."0.4.0"."smallvec"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."parking_lot_core"."0.4.0"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."parking_lot_core"."0.4.0"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."parking_lot_core"."0.4.0"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."parking_lot_core"."0.4.0" or {});
  };
  features_.parking_lot_core."0.4.0" = deps: f: updateFeatures f (rec {
    libc."${deps.parking_lot_core."0.4.0".libc}".default = true;
    parking_lot_core = fold recursiveUpdate {} [
      { "0.4.0".backtrace =
        (f.parking_lot_core."0.4.0".backtrace or false) ||
        (f.parking_lot_core."0.4.0".deadlock_detection or false) ||
        (parking_lot_core."0.4.0"."deadlock_detection" or false); }
      { "0.4.0".default = (f.parking_lot_core."0.4.0".default or true); }
      { "0.4.0".petgraph =
        (f.parking_lot_core."0.4.0".petgraph or false) ||
        (f.parking_lot_core."0.4.0".deadlock_detection or false) ||
        (parking_lot_core."0.4.0"."deadlock_detection" or false); }
      { "0.4.0".thread-id =
        (f.parking_lot_core."0.4.0".thread-id or false) ||
        (f.parking_lot_core."0.4.0".deadlock_detection or false) ||
        (parking_lot_core."0.4.0"."deadlock_detection" or false); }
    ];
    rand."${deps.parking_lot_core."0.4.0".rand}".default = true;
    rustc_version."${deps.parking_lot_core."0.4.0".rustc_version}".default = true;
    smallvec."${deps.parking_lot_core."0.4.0".smallvec}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.parking_lot_core."0.4.0".winapi}"."errhandlingapi" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}"."handleapi" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}"."minwindef" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}"."ntstatus" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}"."winbase" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}"."winerror" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}"."winnt" = true; }
      { "${deps.parking_lot_core."0.4.0".winapi}".default = true; }
    ];
  }) [
    (features_.rand."${deps."parking_lot_core"."0.4.0"."rand"}" deps)
    (features_.smallvec."${deps."parking_lot_core"."0.4.0"."smallvec"}" deps)
    (features_.rustc_version."${deps."parking_lot_core"."0.4.0"."rustc_version"}" deps)
    (features_.libc."${deps."parking_lot_core"."0.4.0"."libc"}" deps)
    (features_.winapi."${deps."parking_lot_core"."0.4.0"."winapi"}" deps)
  ];


# end
# peeking_take_while-0.1.2

  crates.peeking_take_while."0.1.2" = deps: { features?(features_.peeking_take_while."0.1.2" deps {}) }: buildRustCrate {
    crateName = "peeking_take_while";
    version = "0.1.2";
    authors = [ "Nick Fitzgerald <fitzgen@gmail.com>" ];
    sha256 = "1vdaxp3c73divj5rbyb2wm9pz61rg5idgh1g7bifnllf7xhw15zr";
  };
  features_.peeking_take_while."0.1.2" = deps: f: updateFeatures f (rec {
    peeking_take_while."0.1.2".default = (f.peeking_take_while."0.1.2".default or true);
  }) [];


# end
# percent-encoding-1.0.1

  crates.percent_encoding."1.0.1" = deps: { features?(features_.percent_encoding."1.0.1" deps {}) }: buildRustCrate {
    crateName = "percent-encoding";
    version = "1.0.1";
    authors = [ "The rust-url developers" ];
    sha256 = "04ahrp7aw4ip7fmadb0bknybmkfav0kk0gw4ps3ydq5w6hr0ib5i";
    libPath = "lib.rs";
  };
  features_.percent_encoding."1.0.1" = deps: f: updateFeatures f (rec {
    percent_encoding."1.0.1".default = (f.percent_encoding."1.0.1".default or true);
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
# phf-0.7.24

  crates.phf."0.7.24" = deps: { features?(features_.phf."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "19mmhmafd1dhywc7pzkmd1nq0kjfvg57viny20jqa91hhprf2dv5";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf"."0.7.24"."phf_shared"}" deps)
    ]);
    features = mkFeatures (features."phf"."0.7.24" or {});
  };
  features_.phf."0.7.24" = deps: f: updateFeatures f (rec {
    phf = fold recursiveUpdate {} [
      { "0.7.24".default = (f.phf."0.7.24".default or true); }
      { "0.7.24".phf_macros =
        (f.phf."0.7.24".phf_macros or false) ||
        (f.phf."0.7.24".macros or false) ||
        (phf."0.7.24"."macros" or false); }
    ];
    phf_shared = fold recursiveUpdate {} [
      { "${deps.phf."0.7.24".phf_shared}"."core" =
        (f.phf_shared."${deps.phf."0.7.24".phf_shared}"."core" or false) ||
        (phf."0.7.24"."core" or false) ||
        (f."phf"."0.7.24"."core" or false); }
      { "${deps.phf."0.7.24".phf_shared}"."unicase" =
        (f.phf_shared."${deps.phf."0.7.24".phf_shared}"."unicase" or false) ||
        (phf."0.7.24"."unicase" or false) ||
        (f."phf"."0.7.24"."unicase" or false); }
      { "${deps.phf."0.7.24".phf_shared}".default = true; }
    ];
  }) [
    (features_.phf_shared."${deps."phf"."0.7.24"."phf_shared"}" deps)
  ];


# end
# phf_codegen-0.7.24

  crates.phf_codegen."0.7.24" = deps: { features?(features_.phf_codegen."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf_codegen";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "0avkx97r4ph8rv70wwgniarlcfiq27yd74gmnxfdv3rx840cyf8g";
    dependencies = mapFeatures features ([
      (crates."phf_generator"."${deps."phf_codegen"."0.7.24"."phf_generator"}" deps)
      (crates."phf_shared"."${deps."phf_codegen"."0.7.24"."phf_shared"}" deps)
    ]);
  };
  features_.phf_codegen."0.7.24" = deps: f: updateFeatures f (rec {
    phf_codegen."0.7.24".default = (f.phf_codegen."0.7.24".default or true);
    phf_generator."${deps.phf_codegen."0.7.24".phf_generator}".default = true;
    phf_shared."${deps.phf_codegen."0.7.24".phf_shared}".default = true;
  }) [
    (features_.phf_generator."${deps."phf_codegen"."0.7.24"."phf_generator"}" deps)
    (features_.phf_shared."${deps."phf_codegen"."0.7.24"."phf_shared"}" deps)
  ];


# end
# phf_generator-0.7.24

  crates.phf_generator."0.7.24" = deps: { features?(features_.phf_generator."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf_generator";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1frn2jfydinifxb1fki0xnnsxf0f1ciaa79jz415r5qhw1ash72j";
    dependencies = mapFeatures features ([
      (crates."phf_shared"."${deps."phf_generator"."0.7.24"."phf_shared"}" deps)
      (crates."rand"."${deps."phf_generator"."0.7.24"."rand"}" deps)
    ]);
  };
  features_.phf_generator."0.7.24" = deps: f: updateFeatures f (rec {
    phf_generator."0.7.24".default = (f.phf_generator."0.7.24".default or true);
    phf_shared."${deps.phf_generator."0.7.24".phf_shared}".default = true;
    rand."${deps.phf_generator."0.7.24".rand}".default = true;
  }) [
    (features_.phf_shared."${deps."phf_generator"."0.7.24"."phf_shared"}" deps)
    (features_.rand."${deps."phf_generator"."0.7.24"."rand"}" deps)
  ];


# end
# phf_shared-0.7.24

  crates.phf_shared."0.7.24" = deps: { features?(features_.phf_shared."0.7.24" deps {}) }: buildRustCrate {
    crateName = "phf_shared";
    version = "0.7.24";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "1hndqn461jvm2r269ym4qh7fnjc6n8yy53avc2pb43p70vxhm9rl";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."siphasher"."${deps."phf_shared"."0.7.24"."siphasher"}" deps)
    ]
      ++ (if features.phf_shared."0.7.24".unicase or false then [ (crates.unicase."${deps."phf_shared"."0.7.24".unicase}" deps) ] else []));
    features = mkFeatures (features."phf_shared"."0.7.24" or {});
  };
  features_.phf_shared."0.7.24" = deps: f: updateFeatures f (rec {
    phf_shared."0.7.24".default = (f.phf_shared."0.7.24".default or true);
    siphasher."${deps.phf_shared."0.7.24".siphasher}".default = true;
    unicase."${deps.phf_shared."0.7.24".unicase}".default = true;
  }) [
    (features_.siphasher."${deps."phf_shared"."0.7.24"."siphasher"}" deps)
    (features_.unicase."${deps."phf_shared"."0.7.24"."unicase"}" deps)
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
# pleingres-0.4.5

  crates.pleingres."0.4.5" = deps: { features?(features_.pleingres."0.4.5" deps {}) }: buildRustCrate {
    crateName = "pleingres";
    version = "0.4.5";
    authors = [ "Pierre-Étienne Meunier" ];
    sha256 = "0k22vkb17ysmhbn0ffjwknizcivz1qk3m3cp29ki8vh5qzr75cv4";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."pleingres"."0.4.5"."byteorder"}" deps)
      (crates."bytes"."${deps."pleingres"."0.4.5"."bytes"}" deps)
      (crates."chrono"."${deps."pleingres"."0.4.5"."chrono"}" deps)
      (crates."digest"."${deps."pleingres"."0.4.5"."digest"}" deps)
      (crates."futures"."${deps."pleingres"."0.4.5"."futures"}" deps)
      (crates."log"."${deps."pleingres"."0.4.5"."log"}" deps)
      (crates."md5"."${deps."pleingres"."0.4.5"."md5"}" deps)
      (crates."openssl"."${deps."pleingres"."0.4.5"."openssl"}" deps)
      (crates."pleingres_macros"."${deps."pleingres"."0.4.5"."pleingres_macros"}" deps)
      (crates."serde"."${deps."pleingres"."0.4.5"."serde"}" deps)
      (crates."serde_derive"."${deps."pleingres"."0.4.5"."serde_derive"}" deps)
      (crates."tokio"."${deps."pleingres"."0.4.5"."tokio"}" deps)
      (crates."tokio_io"."${deps."pleingres"."0.4.5"."tokio_io"}" deps)
      (crates."tokio_openssl"."${deps."pleingres"."0.4.5"."tokio_openssl"}" deps)
      (crates."tokio_timer"."${deps."pleingres"."0.4.5"."tokio_timer"}" deps)
      (crates."uuid"."${deps."pleingres"."0.4.5"."uuid"}" deps)
    ]);
  };
  features_.pleingres."0.4.5" = deps: f: updateFeatures f (rec {
    byteorder."${deps.pleingres."0.4.5".byteorder}".default = true;
    bytes."${deps.pleingres."0.4.5".bytes}".default = true;
    chrono."${deps.pleingres."0.4.5".chrono}".default = true;
    digest."${deps.pleingres."0.4.5".digest}".default = true;
    futures."${deps.pleingres."0.4.5".futures}".default = true;
    log."${deps.pleingres."0.4.5".log}".default = true;
    md5."${deps.pleingres."0.4.5".md5}".default = true;
    openssl."${deps.pleingres."0.4.5".openssl}".default = true;
    pleingres."0.4.5".default = (f.pleingres."0.4.5".default or true);
    pleingres_macros."${deps.pleingres."0.4.5".pleingres_macros}".default = true;
    serde."${deps.pleingres."0.4.5".serde}".default = true;
    serde_derive."${deps.pleingres."0.4.5".serde_derive}".default = true;
    tokio."${deps.pleingres."0.4.5".tokio}".default = true;
    tokio_io."${deps.pleingres."0.4.5".tokio_io}".default = true;
    tokio_openssl."${deps.pleingres."0.4.5".tokio_openssl}".default = true;
    tokio_timer."${deps.pleingres."0.4.5".tokio_timer}".default = true;
    uuid."${deps.pleingres."0.4.5".uuid}".default = true;
  }) [
    (features_.byteorder."${deps."pleingres"."0.4.5"."byteorder"}" deps)
    (features_.bytes."${deps."pleingres"."0.4.5"."bytes"}" deps)
    (features_.chrono."${deps."pleingres"."0.4.5"."chrono"}" deps)
    (features_.digest."${deps."pleingres"."0.4.5"."digest"}" deps)
    (features_.futures."${deps."pleingres"."0.4.5"."futures"}" deps)
    (features_.log."${deps."pleingres"."0.4.5"."log"}" deps)
    (features_.md5."${deps."pleingres"."0.4.5"."md5"}" deps)
    (features_.openssl."${deps."pleingres"."0.4.5"."openssl"}" deps)
    (features_.pleingres_macros."${deps."pleingres"."0.4.5"."pleingres_macros"}" deps)
    (features_.serde."${deps."pleingres"."0.4.5"."serde"}" deps)
    (features_.serde_derive."${deps."pleingres"."0.4.5"."serde_derive"}" deps)
    (features_.tokio."${deps."pleingres"."0.4.5"."tokio"}" deps)
    (features_.tokio_io."${deps."pleingres"."0.4.5"."tokio_io"}" deps)
    (features_.tokio_openssl."${deps."pleingres"."0.4.5"."tokio_openssl"}" deps)
    (features_.tokio_timer."${deps."pleingres"."0.4.5"."tokio_timer"}" deps)
    (features_.uuid."${deps."pleingres"."0.4.5"."uuid"}" deps)
  ];


# end
# pleingres-macros-0.1.0

  crates.pleingres_macros."0.1.0" = deps: { features?(features_.pleingres_macros."0.1.0" deps {}) }: buildRustCrate {
    crateName = "pleingres-macros";
    version = "0.1.0";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    sha256 = "0nw9pi1x36xr6xa7lfzpv2lzjgf8bnm7dqaji7bdm2pd8rdihrr1";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."pleingres_macros"."0.1.0"."proc_macro2"}" deps)
      (crates."quote"."${deps."pleingres_macros"."0.1.0"."quote"}" deps)
      (crates."regex"."${deps."pleingres_macros"."0.1.0"."regex"}" deps)
      (crates."syn"."${deps."pleingres_macros"."0.1.0"."syn"}" deps)
    ]);
  };
  features_.pleingres_macros."0.1.0" = deps: f: updateFeatures f (rec {
    pleingres_macros."0.1.0".default = (f.pleingres_macros."0.1.0".default or true);
    proc_macro2."${deps.pleingres_macros."0.1.0".proc_macro2}".default = true;
    quote."${deps.pleingres_macros."0.1.0".quote}".default = true;
    regex."${deps.pleingres_macros."0.1.0".regex}".default = true;
    syn."${deps.pleingres_macros."0.1.0".syn}".default = true;
  }) [
    (features_.proc_macro2."${deps."pleingres_macros"."0.1.0"."proc_macro2"}" deps)
    (features_.quote."${deps."pleingres_macros"."0.1.0"."quote"}" deps)
    (features_.regex."${deps."pleingres_macros"."0.1.0"."regex"}" deps)
    (features_.syn."${deps."pleingres_macros"."0.1.0"."syn"}" deps)
  ];


# end
# png-0.14.0

  crates.png."0.14.0" = deps: { features?(features_.png."0.14.0" deps {}) }: buildRustCrate {
    crateName = "png";
    version = "0.14.0";
    authors = [ "nwin <nwin@users.noreply.github.com>" ];
    sha256 = "1lgh3c43piq6f2fjpm5b0hjb4vizpphiklm8d1pg2j1cvz5dwdgq";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."png"."0.14.0"."bitflags"}" deps)
      (crates."inflate"."${deps."png"."0.14.0"."inflate"}" deps)
      (crates."num_iter"."${deps."png"."0.14.0"."num_iter"}" deps)
    ]
      ++ (if features.png."0.14.0".deflate or false then [ (crates.deflate."${deps."png"."0.14.0".deflate}" deps) ] else []));
    features = mkFeatures (features."png"."0.14.0" or {});
  };
  features_.png."0.14.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.png."0.14.0".bitflags}".default = true;
    deflate."${deps.png."0.14.0".deflate}".default = true;
    inflate."${deps.png."0.14.0".inflate}".default = true;
    num_iter."${deps.png."0.14.0".num_iter}".default = true;
    png = fold recursiveUpdate {} [
      { "0.14.0".default = (f.png."0.14.0".default or true); }
      { "0.14.0".deflate =
        (f.png."0.14.0".deflate or false) ||
        (f.png."0.14.0".png-encoding or false) ||
        (png."0.14.0"."png-encoding" or false); }
      { "0.14.0".png-encoding =
        (f.png."0.14.0".png-encoding or false) ||
        (f.png."0.14.0".default or false) ||
        (png."0.14.0"."default" or false); }
    ];
  }) [
    (features_.bitflags."${deps."png"."0.14.0"."bitflags"}" deps)
    (features_.deflate."${deps."png"."0.14.0"."deflate"}" deps)
    (features_.inflate."${deps."png"."0.14.0"."inflate"}" deps)
    (features_.num_iter."${deps."png"."0.14.0"."num_iter"}" deps)
  ];


# end
# precomputed-hash-0.1.1

  crates.precomputed_hash."0.1.1" = deps: { features?(features_.precomputed_hash."0.1.1" deps {}) }: buildRustCrate {
    crateName = "precomputed-hash";
    version = "0.1.1";
    authors = [ "Emilio Cobos Álvarez <emilio@crisal.io>" ];
    sha256 = "1x37xiarlc39772glsrbb9ic5cpaky4q0fi0ax42bwwrn4jfqgyj";
  };
  features_.precomputed_hash."0.1.1" = deps: f: updateFeatures f (rec {
    precomputed_hash."0.1.1".default = (f.precomputed_hash."0.1.1".default or true);
  }) [];


# end
# privdrop-0.2.2

  crates.privdrop."0.2.2" = deps: { features?(features_.privdrop."0.2.2" deps {}) }: buildRustCrate {
    crateName = "privdrop";
    version = "0.2.2";
    authors = [ "Frank Denis <github@pureftpd.org>" ];
    edition = "2018";
    sha256 = "052rfcwr2ljnhkwwcbsra60jwmawvq1wyqs41bs9bfy6ymgfc41z";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."privdrop"."0.2.2"."libc"}" deps)
      (crates."nix"."${deps."privdrop"."0.2.2"."nix"}" deps)
    ]);
  };
  features_.privdrop."0.2.2" = deps: f: updateFeatures f (rec {
    libc."${deps.privdrop."0.2.2".libc}".default = true;
    nix."${deps.privdrop."0.2.2".nix}".default = true;
    privdrop."0.2.2".default = (f.privdrop."0.2.2".default or true);
  }) [
    (features_.libc."${deps."privdrop"."0.2.2"."libc"}" deps)
    (features_.nix."${deps."privdrop"."0.2.2"."nix"}" deps)
  ];


# end
# proc-macro2-0.3.5

  crates.proc_macro2."0.3.5" = deps: { features?(features_.proc_macro2."0.3.5" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.3.5";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0wkwj19ygy8ffdpixgj8da8c1p6ab8dh5hccyn8fjg8rhv8nvqcd";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.3.5"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.3.5" or {});
  };
  features_.proc_macro2."0.3.5" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.3.5".default = (f.proc_macro2."0.3.5".default or true); }
      { "0.3.5".proc-macro =
        (f.proc_macro2."0.3.5".proc-macro or false) ||
        (f.proc_macro2."0.3.5".default or false) ||
        (proc_macro2."0.3.5"."default" or false) ||
        (f.proc_macro2."0.3.5".nightly or false) ||
        (proc_macro2."0.3.5"."nightly" or false); }
    ];
    unicode_xid."${deps.proc_macro2."0.3.5".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.3.5"."unicode_xid"}" deps)
  ];


# end
# proc-macro2-0.4.20

  crates.proc_macro2."0.4.20" = deps: { features?(features_.proc_macro2."0.4.20" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.20";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0yr74b00d3wzg21kjvfln7vzzvf9aghbaff4c747i3grbd997ys2";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.4.20"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.4.20" or {});
  };
  features_.proc_macro2."0.4.20" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.4.20".default = (f.proc_macro2."0.4.20".default or true); }
      { "0.4.20".proc-macro =
        (f.proc_macro2."0.4.20".proc-macro or false) ||
        (f.proc_macro2."0.4.20".default or false) ||
        (proc_macro2."0.4.20"."default" or false) ||
        (f.proc_macro2."0.4.20".nightly or false) ||
        (proc_macro2."0.4.20"."nightly" or false); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.20".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.20"."unicode_xid"}" deps)
  ];


# end
# proc-macro2-0.4.27

  crates.proc_macro2."0.4.27" = deps: { features?(features_.proc_macro2."0.4.27" deps {}) }: buildRustCrate {
    crateName = "proc-macro2";
    version = "0.4.27";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1cp4c40p3hwn2sz72ssqa62gp5n8w4gbamdqvvadzp5l7gxnq95i";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."proc_macro2"."0.4.27"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."proc_macro2"."0.4.27" or {});
  };
  features_.proc_macro2."0.4.27" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "0.4.27".default = (f.proc_macro2."0.4.27".default or true); }
      { "0.4.27".proc-macro =
        (f.proc_macro2."0.4.27".proc-macro or false) ||
        (f.proc_macro2."0.4.27".default or false) ||
        (proc_macro2."0.4.27"."default" or false); }
    ];
    unicode_xid."${deps.proc_macro2."0.4.27".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."proc_macro2"."0.4.27"."unicode_xid"}" deps)
  ];


# end
# pulldown-cmark-0.2.0

  crates.pulldown_cmark."0.2.0" = deps: { features?(features_.pulldown_cmark."0.2.0" deps {}) }: buildRustCrate {
    crateName = "pulldown-cmark";
    version = "0.2.0";
    authors = [ "Raph Levien <raph.levien@gmail.com>" ];
    sha256 = "1vsqbbymps71gjzhj9v6w3nbarrbyi6cd743x4nkvi166wr6dcvk";
    crateBin =
      (if features."pulldown_cmark"."0.2.0"."getopts" then [{  name = "pulldown-cmark"; } ] else []);
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."pulldown_cmark"."0.2.0"."bitflags"}" deps)
    ]
      ++ (if features.pulldown_cmark."0.2.0".getopts or false then [ (crates.getopts."${deps."pulldown_cmark"."0.2.0".getopts}" deps) ] else []));
    features = mkFeatures (features."pulldown_cmark"."0.2.0" or {});
  };
  features_.pulldown_cmark."0.2.0" = deps: f: updateFeatures f (rec {
    bitflags."${deps.pulldown_cmark."0.2.0".bitflags}".default = true;
    getopts."${deps.pulldown_cmark."0.2.0".getopts}".default = true;
    pulldown_cmark = fold recursiveUpdate {} [
      { "0.2.0".default = (f.pulldown_cmark."0.2.0".default or true); }
      { "0.2.0".getopts =
        (f.pulldown_cmark."0.2.0".getopts or false) ||
        (f.pulldown_cmark."0.2.0".default or false) ||
        (pulldown_cmark."0.2.0"."default" or false); }
    ];
  }) [
    (features_.bitflags."${deps."pulldown_cmark"."0.2.0"."bitflags"}" deps)
    (features_.getopts."${deps."pulldown_cmark"."0.2.0"."getopts"}" deps)
  ];


# end
# quick-error-1.2.2

  crates.quick_error."1.2.2" = deps: { features?(features_.quick_error."1.2.2" deps {}) }: buildRustCrate {
    crateName = "quick-error";
    version = "1.2.2";
    authors = [ "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" ];
    sha256 = "192a3adc5phgpibgqblsdx1b421l5yg9bjbmv552qqq9f37h60k5";
  };
  features_.quick_error."1.2.2" = deps: f: updateFeatures f (rec {
    quick_error."1.2.2".default = (f.quick_error."1.2.2".default or true);
  }) [];


# end
# quickcheck-0.8.2

  crates.quickcheck."0.8.2" = deps: { features?(features_.quickcheck."0.8.2" deps {}) }: buildRustCrate {
    crateName = "quickcheck";
    version = "0.8.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "14gfpi6pcg61w97nw86wr6iassy11cbs37l0k4bvxb2q1n8z3ckf";
    dependencies = mapFeatures features ([
      (crates."rand"."${deps."quickcheck"."0.8.2"."rand"}" deps)
      (crates."rand_core"."${deps."quickcheck"."0.8.2"."rand_core"}" deps)
    ]
      ++ (if features.quickcheck."0.8.2".env_logger or false then [ (crates.env_logger."${deps."quickcheck"."0.8.2".env_logger}" deps) ] else [])
      ++ (if features.quickcheck."0.8.2".log or false then [ (crates.log."${deps."quickcheck"."0.8.2".log}" deps) ] else []));
    features = mkFeatures (features."quickcheck"."0.8.2" or {});
  };
  features_.quickcheck."0.8.2" = deps: f: updateFeatures f (rec {
    env_logger = fold recursiveUpdate {} [
      { "${deps.quickcheck."0.8.2".env_logger}"."regex" =
        (f.env_logger."${deps.quickcheck."0.8.2".env_logger}"."regex" or false) ||
        (quickcheck."0.8.2"."regex" or false) ||
        (f."quickcheck"."0.8.2"."regex" or false); }
      { "${deps.quickcheck."0.8.2".env_logger}".default = (f.env_logger."${deps.quickcheck."0.8.2".env_logger}".default or false); }
    ];
    log."${deps.quickcheck."0.8.2".log}".default = true;
    quickcheck = fold recursiveUpdate {} [
      { "0.8.2".default = (f.quickcheck."0.8.2".default or true); }
      { "0.8.2".env_logger =
        (f.quickcheck."0.8.2".env_logger or false) ||
        (f.quickcheck."0.8.2".use_logging or false) ||
        (quickcheck."0.8.2"."use_logging" or false); }
      { "0.8.2".log =
        (f.quickcheck."0.8.2".log or false) ||
        (f.quickcheck."0.8.2".use_logging or false) ||
        (quickcheck."0.8.2"."use_logging" or false); }
      { "0.8.2".regex =
        (f.quickcheck."0.8.2".regex or false) ||
        (f.quickcheck."0.8.2".default or false) ||
        (quickcheck."0.8.2"."default" or false); }
      { "0.8.2".use_logging =
        (f.quickcheck."0.8.2".use_logging or false) ||
        (f.quickcheck."0.8.2".default or false) ||
        (quickcheck."0.8.2"."default" or false); }
    ];
    rand."${deps.quickcheck."0.8.2".rand}".default = true;
    rand_core."${deps.quickcheck."0.8.2".rand_core}".default = true;
  }) [
    (features_.env_logger."${deps."quickcheck"."0.8.2"."env_logger"}" deps)
    (features_.log."${deps."quickcheck"."0.8.2"."log"}" deps)
    (features_.rand."${deps."quickcheck"."0.8.2"."rand"}" deps)
    (features_.rand_core."${deps."quickcheck"."0.8.2"."rand_core"}" deps)
  ];


# end
# quote-0.3.15

  crates.quote."0.3.15" = deps: { features?(features_.quote."0.3.15" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.3.15";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
  };
  features_.quote."0.3.15" = deps: f: updateFeatures f (rec {
    quote."0.3.15".default = (f.quote."0.3.15".default or true);
  }) [];


# end
# quote-0.5.2

  crates.quote."0.5.2" = deps: { features?(features_.quote."0.5.2" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.5.2";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "062cnp12j09x0z0nj4j5pfh26h35zlrks07asxgqhfhcym1ba595";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.5.2"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.5.2" or {});
  };
  features_.quote."0.5.2" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.5.2".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.5.2".proc_macro2}"."proc-macro" or false) ||
        (quote."0.5.2"."proc-macro" or false) ||
        (f."quote"."0.5.2"."proc-macro" or false); }
      { "${deps.quote."0.5.2".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.5.2".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.5.2".default = (f.quote."0.5.2".default or true); }
      { "0.5.2".proc-macro =
        (f.quote."0.5.2".proc-macro or false) ||
        (f.quote."0.5.2".default or false) ||
        (quote."0.5.2"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.5.2"."proc_macro2"}" deps)
  ];


# end
# quote-0.6.11

  crates.quote."0.6.11" = deps: { features?(features_.quote."0.6.11" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.11";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0agska77z58cypcq4knayzwx7r7n6m756z1cz9cp2z4sv0b846ga";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.11"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.11" or {});
  };
  features_.quote."0.6.11" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.11".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.11".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.11"."proc-macro" or false) ||
        (f."quote"."0.6.11"."proc-macro" or false); }
      { "${deps.quote."0.6.11".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.11".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.11".default = (f.quote."0.6.11".default or true); }
      { "0.6.11".proc-macro =
        (f.quote."0.6.11".proc-macro or false) ||
        (f.quote."0.6.11".default or false) ||
        (quote."0.6.11"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.11"."proc_macro2"}" deps)
  ];


# end
# quote-0.6.8

  crates.quote."0.6.8" = deps: { features?(features_.quote."0.6.8" deps {}) }: buildRustCrate {
    crateName = "quote";
    version = "0.6.8";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0dq6j23w6pmc4l6v490arixdwypy0b82z76nrzaingqhqri4p3mh";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."quote"."0.6.8"."proc_macro2"}" deps)
    ]);
    features = mkFeatures (features."quote"."0.6.8" or {});
  };
  features_.quote."0.6.8" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.quote."0.6.8".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.quote."0.6.8".proc_macro2}"."proc-macro" or false) ||
        (quote."0.6.8"."proc-macro" or false) ||
        (f."quote"."0.6.8"."proc-macro" or false); }
      { "${deps.quote."0.6.8".proc_macro2}".default = (f.proc_macro2."${deps.quote."0.6.8".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "0.6.8".default = (f.quote."0.6.8".default or true); }
      { "0.6.8".proc-macro =
        (f.quote."0.6.8".proc-macro or false) ||
        (f.quote."0.6.8".default or false) ||
        (quote."0.6.8"."default" or false); }
    ];
  }) [
    (features_.proc_macro2."${deps."quote"."0.6.8"."proc_macro2"}" deps)
  ];


# end
# rand-0.3.23

  crates.rand."0.3.23" = deps: { features?(features_.rand."0.3.23" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.3.23";
    authors = [ "The Rust Project Developers" ];
    sha256 = "118rairvv46npqqx7hmkf97kkimjrry9z31z4inxcv2vn0nj1s2g";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."rand"."0.3.23"."libc"}" deps)
      (crates."rand"."${deps."rand"."0.3.23"."rand"}" deps)
    ]);
    features = mkFeatures (features."rand"."0.3.23" or {});
  };
  features_.rand."0.3.23" = deps: f: updateFeatures f (rec {
    libc."${deps.rand."0.3.23".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "${deps.rand."0.3.23".rand}".default = true; }
      { "0.3.23".default = (f.rand."0.3.23".default or true); }
      { "0.3.23".i128_support =
        (f.rand."0.3.23".i128_support or false) ||
        (f.rand."0.3.23".nightly or false) ||
        (rand."0.3.23"."nightly" or false); }
    ];
  }) [
    (features_.libc."${deps."rand"."0.3.23"."libc"}" deps)
    (features_.rand."${deps."rand"."0.3.23"."rand"}" deps)
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
# rand-0.4.6

  crates.rand."0.4.6" = deps: { features?(features_.rand."0.4.6" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.4.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0c3rmg5q7d6qdi7cbmg5py9alm70wd3xsg0mmcawrnl35qv37zfs";
    dependencies = (if abi == "sgx" then mapFeatures features ([
      (crates."rand_core"."${deps."rand"."0.4.6"."rand_core"}" deps)
      (crates."rdrand"."${deps."rand"."0.4.6"."rdrand"}" deps)
    ]) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_cprng"."${deps."rand"."0.4.6"."fuchsia_cprng"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.4.6".libc or false then [ (crates.libc."${deps."rand"."0.4.6".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand"."0.4.6"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand"."0.4.6" or {});
  };
  features_.rand."0.4.6" = deps: f: updateFeatures f (rec {
    fuchsia_cprng."${deps.rand."0.4.6".fuchsia_cprng}".default = true;
    libc."${deps.rand."0.4.6".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.4.6".default = (f.rand."0.4.6".default or true); }
      { "0.4.6".i128_support =
        (f.rand."0.4.6".i128_support or false) ||
        (f.rand."0.4.6".nightly or false) ||
        (rand."0.4.6"."nightly" or false); }
      { "0.4.6".libc =
        (f.rand."0.4.6".libc or false) ||
        (f.rand."0.4.6".std or false) ||
        (rand."0.4.6"."std" or false); }
      { "0.4.6".std =
        (f.rand."0.4.6".std or false) ||
        (f.rand."0.4.6".default or false) ||
        (rand."0.4.6"."default" or false); }
    ];
    rand_core."${deps.rand."0.4.6".rand_core}".default = (f.rand_core."${deps.rand."0.4.6".rand_core}".default or false);
    rdrand."${deps.rand."0.4.6".rdrand}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.4.6".winapi}"."minwindef" = true; }
      { "${deps.rand."0.4.6".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.4.6".winapi}"."profileapi" = true; }
      { "${deps.rand."0.4.6".winapi}"."winnt" = true; }
      { "${deps.rand."0.4.6".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand"."0.4.6"."rand_core"}" deps)
    (features_.rdrand."${deps."rand"."0.4.6"."rdrand"}" deps)
    (features_.fuchsia_cprng."${deps."rand"."0.4.6"."fuchsia_cprng"}" deps)
    (features_.libc."${deps."rand"."0.4.6"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.4.6"."winapi"}" deps)
  ];


# end
# rand-0.5.6

  crates.rand."0.5.6" = deps: { features?(features_.rand."0.5.6" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.5.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "04f1gydiia347cx24n5cw4v21fhh9yga7dw739z4jsxzls2ss8w8";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand"."0.5.6"."rand_core"}" deps)
    ])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.6".cloudabi or false then [ (crates.cloudabi."${deps."rand"."0.5.6".cloudabi}" deps) ] else [])) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.6".fuchsia-cprng or false then [ (crates.fuchsia_cprng."${deps."rand"."0.5.6".fuchsia_cprng}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.6".libc or false then [ (crates.libc."${deps."rand"."0.5.6".libc}" deps) ] else [])) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
    ]
      ++ (if features.rand."0.5.6".winapi or false then [ (crates.winapi."${deps."rand"."0.5.6".winapi}" deps) ] else [])) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
    features = mkFeatures (features."rand"."0.5.6" or {});
  };
  features_.rand."0.5.6" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand."0.5.6".cloudabi}".default = true;
    fuchsia_cprng."${deps.rand."0.5.6".fuchsia_cprng}".default = true;
    libc."${deps.rand."0.5.6".libc}".default = true;
    rand = fold recursiveUpdate {} [
      { "0.5.6".alloc =
        (f.rand."0.5.6".alloc or false) ||
        (f.rand."0.5.6".std or false) ||
        (rand."0.5.6"."std" or false); }
      { "0.5.6".cloudabi =
        (f.rand."0.5.6".cloudabi or false) ||
        (f.rand."0.5.6".std or false) ||
        (rand."0.5.6"."std" or false); }
      { "0.5.6".default = (f.rand."0.5.6".default or true); }
      { "0.5.6".fuchsia-cprng =
        (f.rand."0.5.6".fuchsia-cprng or false) ||
        (f.rand."0.5.6".std or false) ||
        (rand."0.5.6"."std" or false); }
      { "0.5.6".i128_support =
        (f.rand."0.5.6".i128_support or false) ||
        (f.rand."0.5.6".nightly or false) ||
        (rand."0.5.6"."nightly" or false); }
      { "0.5.6".libc =
        (f.rand."0.5.6".libc or false) ||
        (f.rand."0.5.6".std or false) ||
        (rand."0.5.6"."std" or false); }
      { "0.5.6".serde =
        (f.rand."0.5.6".serde or false) ||
        (f.rand."0.5.6".serde1 or false) ||
        (rand."0.5.6"."serde1" or false); }
      { "0.5.6".serde_derive =
        (f.rand."0.5.6".serde_derive or false) ||
        (f.rand."0.5.6".serde1 or false) ||
        (rand."0.5.6"."serde1" or false); }
      { "0.5.6".std =
        (f.rand."0.5.6".std or false) ||
        (f.rand."0.5.6".default or false) ||
        (rand."0.5.6"."default" or false); }
      { "0.5.6".winapi =
        (f.rand."0.5.6".winapi or false) ||
        (f.rand."0.5.6".std or false) ||
        (rand."0.5.6"."std" or false); }
    ];
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.5.6".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.5.6".rand_core}"."alloc" or false) ||
        (rand."0.5.6"."alloc" or false) ||
        (f."rand"."0.5.6"."alloc" or false); }
      { "${deps.rand."0.5.6".rand_core}"."serde1" =
        (f.rand_core."${deps.rand."0.5.6".rand_core}"."serde1" or false) ||
        (rand."0.5.6"."serde1" or false) ||
        (f."rand"."0.5.6"."serde1" or false); }
      { "${deps.rand."0.5.6".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.5.6".rand_core}"."std" or false) ||
        (rand."0.5.6"."std" or false) ||
        (f."rand"."0.5.6"."std" or false); }
      { "${deps.rand."0.5.6".rand_core}".default = (f.rand_core."${deps.rand."0.5.6".rand_core}".default or false); }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.5.6".winapi}"."minwindef" = true; }
      { "${deps.rand."0.5.6".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.5.6".winapi}"."profileapi" = true; }
      { "${deps.rand."0.5.6".winapi}"."winnt" = true; }
      { "${deps.rand."0.5.6".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand"."0.5.6"."rand_core"}" deps)
    (features_.cloudabi."${deps."rand"."0.5.6"."cloudabi"}" deps)
    (features_.fuchsia_cprng."${deps."rand"."0.5.6"."fuchsia_cprng"}" deps)
    (features_.libc."${deps."rand"."0.5.6"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.5.6"."winapi"}" deps)
  ];


# end
# rand-0.6.5

  crates.rand."0.6.5" = deps: { features?(features_.rand."0.6.5" deps {}) }: buildRustCrate {
    crateName = "rand";
    version = "0.6.5";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0zbck48159aj8zrwzf80sd9xxh96w4f4968nshwjpysjvflimvgb";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_chacha"."${deps."rand"."0.6.5"."rand_chacha"}" deps)
      (crates."rand_core"."${deps."rand"."0.6.5"."rand_core"}" deps)
      (crates."rand_hc"."${deps."rand"."0.6.5"."rand_hc"}" deps)
      (crates."rand_isaac"."${deps."rand"."0.6.5"."rand_isaac"}" deps)
      (crates."rand_jitter"."${deps."rand"."0.6.5"."rand_jitter"}" deps)
      (crates."rand_pcg"."${deps."rand"."0.6.5"."rand_pcg"}" deps)
      (crates."rand_xorshift"."${deps."rand"."0.6.5"."rand_xorshift"}" deps)
    ]
      ++ (if features.rand."0.6.5".rand_os or false then [ (crates.rand_os."${deps."rand"."0.6.5".rand_os}" deps) ] else []))
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."rand"."0.6.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand"."0.6.5"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."rand"."0.6.5"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."rand"."0.6.5" or {});
  };
  features_.rand."0.6.5" = deps: f: updateFeatures f (rec {
    autocfg."${deps.rand."0.6.5".autocfg}".default = true;
    libc."${deps.rand."0.6.5".libc}".default = (f.libc."${deps.rand."0.6.5".libc}".default or false);
    rand = fold recursiveUpdate {} [
      { "0.6.5".alloc =
        (f.rand."0.6.5".alloc or false) ||
        (f.rand."0.6.5".std or false) ||
        (rand."0.6.5"."std" or false); }
      { "0.6.5".default = (f.rand."0.6.5".default or true); }
      { "0.6.5".packed_simd =
        (f.rand."0.6.5".packed_simd or false) ||
        (f.rand."0.6.5".simd_support or false) ||
        (rand."0.6.5"."simd_support" or false); }
      { "0.6.5".rand_os =
        (f.rand."0.6.5".rand_os or false) ||
        (f.rand."0.6.5".std or false) ||
        (rand."0.6.5"."std" or false); }
      { "0.6.5".simd_support =
        (f.rand."0.6.5".simd_support or false) ||
        (f.rand."0.6.5".nightly or false) ||
        (rand."0.6.5"."nightly" or false); }
      { "0.6.5".std =
        (f.rand."0.6.5".std or false) ||
        (f.rand."0.6.5".default or false) ||
        (rand."0.6.5"."default" or false); }
    ];
    rand_chacha."${deps.rand."0.6.5".rand_chacha}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_core}"."alloc" =
        (f.rand_core."${deps.rand."0.6.5".rand_core}"."alloc" or false) ||
        (rand."0.6.5"."alloc" or false) ||
        (f."rand"."0.6.5"."alloc" or false); }
      { "${deps.rand."0.6.5".rand_core}"."serde1" =
        (f.rand_core."${deps.rand."0.6.5".rand_core}"."serde1" or false) ||
        (rand."0.6.5"."serde1" or false) ||
        (f."rand"."0.6.5"."serde1" or false); }
      { "${deps.rand."0.6.5".rand_core}"."std" =
        (f.rand_core."${deps.rand."0.6.5".rand_core}"."std" or false) ||
        (rand."0.6.5"."std" or false) ||
        (f."rand"."0.6.5"."std" or false); }
      { "${deps.rand."0.6.5".rand_core}".default = true; }
    ];
    rand_hc."${deps.rand."0.6.5".rand_hc}".default = true;
    rand_isaac = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_isaac}"."serde1" =
        (f.rand_isaac."${deps.rand."0.6.5".rand_isaac}"."serde1" or false) ||
        (rand."0.6.5"."serde1" or false) ||
        (f."rand"."0.6.5"."serde1" or false); }
      { "${deps.rand."0.6.5".rand_isaac}".default = true; }
    ];
    rand_jitter = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_jitter}"."std" =
        (f.rand_jitter."${deps.rand."0.6.5".rand_jitter}"."std" or false) ||
        (rand."0.6.5"."std" or false) ||
        (f."rand"."0.6.5"."std" or false); }
      { "${deps.rand."0.6.5".rand_jitter}".default = true; }
    ];
    rand_os = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_os}"."stdweb" =
        (f.rand_os."${deps.rand."0.6.5".rand_os}"."stdweb" or false) ||
        (rand."0.6.5"."stdweb" or false) ||
        (f."rand"."0.6.5"."stdweb" or false); }
      { "${deps.rand."0.6.5".rand_os}"."wasm-bindgen" =
        (f.rand_os."${deps.rand."0.6.5".rand_os}"."wasm-bindgen" or false) ||
        (rand."0.6.5"."wasm-bindgen" or false) ||
        (f."rand"."0.6.5"."wasm-bindgen" or false); }
      { "${deps.rand."0.6.5".rand_os}".default = true; }
    ];
    rand_pcg."${deps.rand."0.6.5".rand_pcg}".default = true;
    rand_xorshift = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".rand_xorshift}"."serde1" =
        (f.rand_xorshift."${deps.rand."0.6.5".rand_xorshift}"."serde1" or false) ||
        (rand."0.6.5"."serde1" or false) ||
        (f."rand"."0.6.5"."serde1" or false); }
      { "${deps.rand."0.6.5".rand_xorshift}".default = true; }
    ];
    winapi = fold recursiveUpdate {} [
      { "${deps.rand."0.6.5".winapi}"."minwindef" = true; }
      { "${deps.rand."0.6.5".winapi}"."ntsecapi" = true; }
      { "${deps.rand."0.6.5".winapi}"."profileapi" = true; }
      { "${deps.rand."0.6.5".winapi}"."winnt" = true; }
      { "${deps.rand."0.6.5".winapi}".default = true; }
    ];
  }) [
    (features_.rand_chacha."${deps."rand"."0.6.5"."rand_chacha"}" deps)
    (features_.rand_core."${deps."rand"."0.6.5"."rand_core"}" deps)
    (features_.rand_hc."${deps."rand"."0.6.5"."rand_hc"}" deps)
    (features_.rand_isaac."${deps."rand"."0.6.5"."rand_isaac"}" deps)
    (features_.rand_jitter."${deps."rand"."0.6.5"."rand_jitter"}" deps)
    (features_.rand_os."${deps."rand"."0.6.5"."rand_os"}" deps)
    (features_.rand_pcg."${deps."rand"."0.6.5"."rand_pcg"}" deps)
    (features_.rand_xorshift."${deps."rand"."0.6.5"."rand_xorshift"}" deps)
    (features_.autocfg."${deps."rand"."0.6.5"."autocfg"}" deps)
    (features_.libc."${deps."rand"."0.6.5"."libc"}" deps)
    (features_.winapi."${deps."rand"."0.6.5"."winapi"}" deps)
  ];


# end
# rand_chacha-0.1.1

  crates.rand_chacha."0.1.1" = deps: { features?(features_.rand_chacha."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_chacha";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0xnxm4mjd7wjnh18zxc1yickw58axbycp35ciraplqdfwn1gffwi";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_chacha"."0.1.1"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."rand_chacha"."0.1.1"."autocfg"}" deps)
    ]);
  };
  features_.rand_chacha."0.1.1" = deps: f: updateFeatures f (rec {
    autocfg."${deps.rand_chacha."0.1.1".autocfg}".default = true;
    rand_chacha."0.1.1".default = (f.rand_chacha."0.1.1".default or true);
    rand_core."${deps.rand_chacha."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_chacha."0.1.1".rand_core}".default or false);
  }) [
    (features_.rand_core."${deps."rand_chacha"."0.1.1"."rand_core"}" deps)
    (features_.autocfg."${deps."rand_chacha"."0.1.1"."autocfg"}" deps)
  ];


# end
# rand_core-0.3.1

  crates.rand_core."0.3.1" = deps: { features?(features_.rand_core."0.3.1" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.3.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0q0ssgpj9x5a6fda83nhmfydy7a6c0wvxm0jhncsmjx8qp8gw91m";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_core"."0.3.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_core"."0.3.1" or {});
  };
  features_.rand_core."0.3.1" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_core."0.3.1".rand_core}"."alloc" =
        (f.rand_core."${deps.rand_core."0.3.1".rand_core}"."alloc" or false) ||
        (rand_core."0.3.1"."alloc" or false) ||
        (f."rand_core"."0.3.1"."alloc" or false); }
      { "${deps.rand_core."0.3.1".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_core."0.3.1".rand_core}"."serde1" or false) ||
        (rand_core."0.3.1"."serde1" or false) ||
        (f."rand_core"."0.3.1"."serde1" or false); }
      { "${deps.rand_core."0.3.1".rand_core}"."std" =
        (f.rand_core."${deps.rand_core."0.3.1".rand_core}"."std" or false) ||
        (rand_core."0.3.1"."std" or false) ||
        (f."rand_core"."0.3.1"."std" or false); }
      { "${deps.rand_core."0.3.1".rand_core}".default = true; }
      { "0.3.1".default = (f.rand_core."0.3.1".default or true); }
      { "0.3.1".std =
        (f.rand_core."0.3.1".std or false) ||
        (f.rand_core."0.3.1".default or false) ||
        (rand_core."0.3.1"."default" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_core"."0.3.1"."rand_core"}" deps)
  ];


# end
# rand_core-0.4.0

  crates.rand_core."0.4.0" = deps: { features?(features_.rand_core."0.4.0" deps {}) }: buildRustCrate {
    crateName = "rand_core";
    version = "0.4.0";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0wb5iwhffibj0pnpznhv1g3i7h1fnhz64s3nz74fz6vsm3q6q3br";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."rand_core"."0.4.0" or {});
  };
  features_.rand_core."0.4.0" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "0.4.0".alloc =
        (f.rand_core."0.4.0".alloc or false) ||
        (f.rand_core."0.4.0".std or false) ||
        (rand_core."0.4.0"."std" or false); }
      { "0.4.0".default = (f.rand_core."0.4.0".default or true); }
      { "0.4.0".serde =
        (f.rand_core."0.4.0".serde or false) ||
        (f.rand_core."0.4.0".serde1 or false) ||
        (rand_core."0.4.0"."serde1" or false); }
      { "0.4.0".serde_derive =
        (f.rand_core."0.4.0".serde_derive or false) ||
        (f.rand_core."0.4.0".serde1 or false) ||
        (rand_core."0.4.0"."serde1" or false); }
    ];
  }) [];


# end
# rand_hc-0.1.0

  crates.rand_hc."0.1.0" = deps: { features?(features_.rand_hc."0.1.0" deps {}) }: buildRustCrate {
    crateName = "rand_hc";
    version = "0.1.0";
    authors = [ "The Rand Project Developers" ];
    sha256 = "05agb75j87yp7y1zk8yf7bpm66hc0673r3dlypn0kazynr6fdgkz";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_hc"."0.1.0"."rand_core"}" deps)
    ]);
  };
  features_.rand_hc."0.1.0" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_hc."0.1.0".rand_core}".default = (f.rand_core."${deps.rand_hc."0.1.0".rand_core}".default or false);
    rand_hc."0.1.0".default = (f.rand_hc."0.1.0".default or true);
  }) [
    (features_.rand_core."${deps."rand_hc"."0.1.0"."rand_core"}" deps)
  ];


# end
# rand_isaac-0.1.1

  crates.rand_isaac."0.1.1" = deps: { features?(features_.rand_isaac."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_isaac";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "10hhdh5b5sa03s6b63y9bafm956jwilx41s71jbrzl63ccx8lxdq";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_isaac"."0.1.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_isaac"."0.1.1" or {});
  };
  features_.rand_isaac."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_isaac."0.1.1".rand_core}"."serde1" =
        (f.rand_core."${deps.rand_isaac."0.1.1".rand_core}"."serde1" or false) ||
        (rand_isaac."0.1.1"."serde1" or false) ||
        (f."rand_isaac"."0.1.1"."serde1" or false); }
      { "${deps.rand_isaac."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_isaac."0.1.1".rand_core}".default or false); }
    ];
    rand_isaac = fold recursiveUpdate {} [
      { "0.1.1".default = (f.rand_isaac."0.1.1".default or true); }
      { "0.1.1".serde =
        (f.rand_isaac."0.1.1".serde or false) ||
        (f.rand_isaac."0.1.1".serde1 or false) ||
        (rand_isaac."0.1.1"."serde1" or false); }
      { "0.1.1".serde_derive =
        (f.rand_isaac."0.1.1".serde_derive or false) ||
        (f.rand_isaac."0.1.1".serde1 or false) ||
        (rand_isaac."0.1.1"."serde1" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_isaac"."0.1.1"."rand_core"}" deps)
  ];


# end
# rand_jitter-0.1.3

  crates.rand_jitter."0.1.3" = deps: { features?(features_.rand_jitter."0.1.3" deps {}) }: buildRustCrate {
    crateName = "rand_jitter";
    version = "0.1.3";
    authors = [ "The Rand Project Developers" ];
    sha256 = "1cb4q73rmh1inlx3liy6rabapcqh6p6c1plsd2lxw6dmi67d1qc3";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_jitter"."0.1.3"."rand_core"}" deps)
    ])
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
      (crates."libc"."${deps."rand_jitter"."0.1.3"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand_jitter"."0.1.3"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand_jitter"."0.1.3" or {});
  };
  features_.rand_jitter."0.1.3" = deps: f: updateFeatures f (rec {
    libc."${deps.rand_jitter."0.1.3".libc}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_jitter."0.1.3".rand_core}"."std" =
        (f.rand_core."${deps.rand_jitter."0.1.3".rand_core}"."std" or false) ||
        (rand_jitter."0.1.3"."std" or false) ||
        (f."rand_jitter"."0.1.3"."std" or false); }
      { "${deps.rand_jitter."0.1.3".rand_core}".default = true; }
    ];
    rand_jitter."0.1.3".default = (f.rand_jitter."0.1.3".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.rand_jitter."0.1.3".winapi}"."profileapi" = true; }
      { "${deps.rand_jitter."0.1.3".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand_jitter"."0.1.3"."rand_core"}" deps)
    (features_.libc."${deps."rand_jitter"."0.1.3"."libc"}" deps)
    (features_.winapi."${deps."rand_jitter"."0.1.3"."winapi"}" deps)
  ];


# end
# rand_os-0.1.3

  crates.rand_os."0.1.3" = deps: { features?(features_.rand_os."0.1.3" deps {}) }: buildRustCrate {
    crateName = "rand_os";
    version = "0.1.3";
    authors = [ "The Rand Project Developers" ];
    sha256 = "0ywwspizgs9g8vzn6m5ix9yg36n15119d6n792h7mk4r5vs0ww4j";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_os"."0.1.3"."rand_core"}" deps)
    ])
      ++ (if abi == "sgx" then mapFeatures features ([
      (crates."rdrand"."${deps."rand_os"."0.1.3"."rdrand"}" deps)
    ]) else [])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
      (crates."cloudabi"."${deps."rand_os"."0.1.3"."cloudabi"}" deps)
    ]) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_cprng"."${deps."rand_os"."0.1.3"."fuchsia_cprng"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."rand_os"."0.1.3"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand_os"."0.1.3"."winapi"}" deps)
    ]) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
  };
  features_.rand_os."0.1.3" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand_os."0.1.3".cloudabi}".default = true;
    fuchsia_cprng."${deps.rand_os."0.1.3".fuchsia_cprng}".default = true;
    libc."${deps.rand_os."0.1.3".libc}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_os."0.1.3".rand_core}"."std" = true; }
      { "${deps.rand_os."0.1.3".rand_core}".default = true; }
    ];
    rand_os."0.1.3".default = (f.rand_os."0.1.3".default or true);
    rdrand."${deps.rand_os."0.1.3".rdrand}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.rand_os."0.1.3".winapi}"."minwindef" = true; }
      { "${deps.rand_os."0.1.3".winapi}"."ntsecapi" = true; }
      { "${deps.rand_os."0.1.3".winapi}"."winnt" = true; }
      { "${deps.rand_os."0.1.3".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand_os"."0.1.3"."rand_core"}" deps)
    (features_.rdrand."${deps."rand_os"."0.1.3"."rdrand"}" deps)
    (features_.cloudabi."${deps."rand_os"."0.1.3"."cloudabi"}" deps)
    (features_.fuchsia_cprng."${deps."rand_os"."0.1.3"."fuchsia_cprng"}" deps)
    (features_.libc."${deps."rand_os"."0.1.3"."libc"}" deps)
    (features_.winapi."${deps."rand_os"."0.1.3"."winapi"}" deps)
  ];


# end
# rand_pcg-0.1.2

  crates.rand_pcg."0.1.2" = deps: { features?(features_.rand_pcg."0.1.2" deps {}) }: buildRustCrate {
    crateName = "rand_pcg";
    version = "0.1.2";
    authors = [ "The Rand Project Developers" ];
    sha256 = "04qgi2ai2z42li5h4aawvxbpnlqyjfnipz9d6k73mdnl6p1xq938";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_pcg"."0.1.2"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."rand_pcg"."0.1.2"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."rand_pcg"."0.1.2" or {});
  };
  features_.rand_pcg."0.1.2" = deps: f: updateFeatures f (rec {
    autocfg."${deps.rand_pcg."0.1.2".autocfg}".default = true;
    rand_core."${deps.rand_pcg."0.1.2".rand_core}".default = true;
    rand_pcg = fold recursiveUpdate {} [
      { "0.1.2".default = (f.rand_pcg."0.1.2".default or true); }
      { "0.1.2".serde =
        (f.rand_pcg."0.1.2".serde or false) ||
        (f.rand_pcg."0.1.2".serde1 or false) ||
        (rand_pcg."0.1.2"."serde1" or false); }
      { "0.1.2".serde_derive =
        (f.rand_pcg."0.1.2".serde_derive or false) ||
        (f.rand_pcg."0.1.2".serde1 or false) ||
        (rand_pcg."0.1.2"."serde1" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_pcg"."0.1.2"."rand_core"}" deps)
    (features_.autocfg."${deps."rand_pcg"."0.1.2"."autocfg"}" deps)
  ];


# end
# rand_xorshift-0.1.1

  crates.rand_xorshift."0.1.1" = deps: { features?(features_.rand_xorshift."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_xorshift";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" "The Rust Project Developers" ];
    sha256 = "0v365c4h4lzxwz5k5kp9m0661s0sss7ylv74if0xb4svis9sswnn";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_xorshift"."0.1.1"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rand_xorshift"."0.1.1" or {});
  };
  features_.rand_xorshift."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_xorshift."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_xorshift."0.1.1".rand_core}".default or false);
    rand_xorshift = fold recursiveUpdate {} [
      { "0.1.1".default = (f.rand_xorshift."0.1.1".default or true); }
      { "0.1.1".serde =
        (f.rand_xorshift."0.1.1".serde or false) ||
        (f.rand_xorshift."0.1.1".serde1 or false) ||
        (rand_xorshift."0.1.1"."serde1" or false); }
      { "0.1.1".serde_derive =
        (f.rand_xorshift."0.1.1".serde_derive or false) ||
        (f.rand_xorshift."0.1.1".serde1 or false) ||
        (rand_xorshift."0.1.1"."serde1" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rand_xorshift"."0.1.1"."rand_core"}" deps)
  ];


# end
# rayon-1.0.3

  crates.rayon."1.0.3" = deps: { features?(features_.rayon."1.0.3" deps {}) }: buildRustCrate {
    crateName = "rayon";
    version = "1.0.3";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "0bmwk0l5nbx20a5x16dhrgrmkh3m40v6i0qs2gi2iqimlszyhq93";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."crossbeam_deque"."${deps."rayon"."1.0.3"."crossbeam_deque"}" deps)
      (crates."either"."${deps."rayon"."1.0.3"."either"}" deps)
      (crates."rayon_core"."${deps."rayon"."1.0.3"."rayon_core"}" deps)
    ]);
  };
  features_.rayon."1.0.3" = deps: f: updateFeatures f (rec {
    crossbeam_deque."${deps.rayon."1.0.3".crossbeam_deque}".default = true;
    either."${deps.rayon."1.0.3".either}".default = (f.either."${deps.rayon."1.0.3".either}".default or false);
    rayon."1.0.3".default = (f.rayon."1.0.3".default or true);
    rayon_core."${deps.rayon."1.0.3".rayon_core}".default = true;
  }) [
    (features_.crossbeam_deque."${deps."rayon"."1.0.3"."crossbeam_deque"}" deps)
    (features_.either."${deps."rayon"."1.0.3"."either"}" deps)
    (features_.rayon_core."${deps."rayon"."1.0.3"."rayon_core"}" deps)
  ];


# end
# rayon-core-1.4.1

  crates.rayon_core."1.4.1" = deps: { features?(features_.rayon_core."1.4.1" deps {}) }: buildRustCrate {
    crateName = "rayon-core";
    version = "1.4.1";
    authors = [ "Niko Matsakis <niko@alum.mit.edu>" "Josh Stone <cuviper@gmail.com>" ];
    sha256 = "01xf3mwmmji7yaarrpzpqjhz928ajxkwmjczbwmnpy39y95m4fbn";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."crossbeam_deque"."${deps."rayon_core"."1.4.1"."crossbeam_deque"}" deps)
      (crates."lazy_static"."${deps."rayon_core"."1.4.1"."lazy_static"}" deps)
      (crates."libc"."${deps."rayon_core"."1.4.1"."libc"}" deps)
      (crates."num_cpus"."${deps."rayon_core"."1.4.1"."num_cpus"}" deps)
    ]);
  };
  features_.rayon_core."1.4.1" = deps: f: updateFeatures f (rec {
    crossbeam_deque."${deps.rayon_core."1.4.1".crossbeam_deque}".default = true;
    lazy_static."${deps.rayon_core."1.4.1".lazy_static}".default = true;
    libc."${deps.rayon_core."1.4.1".libc}".default = true;
    num_cpus."${deps.rayon_core."1.4.1".num_cpus}".default = true;
    rayon_core."1.4.1".default = (f.rayon_core."1.4.1".default or true);
  }) [
    (features_.crossbeam_deque."${deps."rayon_core"."1.4.1"."crossbeam_deque"}" deps)
    (features_.lazy_static."${deps."rayon_core"."1.4.1"."lazy_static"}" deps)
    (features_.libc."${deps."rayon_core"."1.4.1"."libc"}" deps)
    (features_.num_cpus."${deps."rayon_core"."1.4.1"."num_cpus"}" deps)
  ];


# end
# rdrand-0.4.0

  crates.rdrand."0.4.0" = deps: { features?(features_.rdrand."0.4.0" deps {}) }: buildRustCrate {
    crateName = "rdrand";
    version = "0.4.0";
    authors = [ "Simonas Kazlauskas <rdrand@kazlauskas.me>" ];
    sha256 = "15hrcasn0v876wpkwab1dwbk9kvqwrb3iv4y4dibb6yxnfvzwajk";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rdrand"."0.4.0"."rand_core"}" deps)
    ]);
    features = mkFeatures (features."rdrand"."0.4.0" or {});
  };
  features_.rdrand."0.4.0" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rdrand."0.4.0".rand_core}".default = (f.rand_core."${deps.rdrand."0.4.0".rand_core}".default or false);
    rdrand = fold recursiveUpdate {} [
      { "0.4.0".default = (f.rdrand."0.4.0".default or true); }
      { "0.4.0".std =
        (f.rdrand."0.4.0".std or false) ||
        (f.rdrand."0.4.0".default or false) ||
        (rdrand."0.4.0"."default" or false); }
    ];
  }) [
    (features_.rand_core."${deps."rdrand"."0.4.0"."rand_core"}" deps)
  ];


# end
# redox_syscall-0.1.40

  crates.redox_syscall."0.1.40" = deps: { features?(features_.redox_syscall."0.1.40" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.40";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "132rnhrq49l3z7gjrwj2zfadgw6q0355s6a7id7x7c0d7sk72611";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.40" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.40".default = (f.redox_syscall."0.1.40".default or true);
  }) [];


# end
# redox_syscall-0.1.51

  crates.redox_syscall."0.1.51" = deps: { features?(features_.redox_syscall."0.1.51" deps {}) }: buildRustCrate {
    crateName = "redox_syscall";
    version = "0.1.51";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "1a61cv7yydx64vpyvzr0z0hwzdvy4gcvcnfc6k70zpkngj5sz3ip";
    libName = "syscall";
  };
  features_.redox_syscall."0.1.51" = deps: f: updateFeatures f (rec {
    redox_syscall."0.1.51".default = (f.redox_syscall."0.1.51".default or true);
  }) [];


# end
# redox_termios-0.1.1

  crates.redox_termios."0.1.1" = deps: { features?(features_.redox_termios."0.1.1" deps {}) }: buildRustCrate {
    crateName = "redox_termios";
    version = "0.1.1";
    authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
    sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."redox_syscall"."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
    ]);
  };
  features_.redox_termios."0.1.1" = deps: f: updateFeatures f (rec {
    redox_syscall."${deps.redox_termios."0.1.1".redox_syscall}".default = true;
    redox_termios."0.1.1".default = (f.redox_termios."0.1.1".default or true);
  }) [
    (features_.redox_syscall."${deps."redox_termios"."0.1.1"."redox_syscall"}" deps)
  ];


# end
# redox_users-0.2.0

  crates.redox_users."0.2.0" = deps: { features?(features_.redox_users."0.2.0" deps {}) }: buildRustCrate {
    crateName = "redox_users";
    version = "0.2.0";
    authors = [ "Jose Narvaez <goyox86@gmail.com>" "Wesley Hershberger <mggmugginsmc@gmail.com>" ];
    sha256 = "0s9jrh378jk8rfi1xfwxvh2r1gv6rn3bq6n7sbajkrqqq0xzijvf";
    dependencies = mapFeatures features ([
      (crates."argon2rs"."${deps."redox_users"."0.2.0"."argon2rs"}" deps)
      (crates."failure"."${deps."redox_users"."0.2.0"."failure"}" deps)
      (crates."rand"."${deps."redox_users"."0.2.0"."rand"}" deps)
      (crates."redox_syscall"."${deps."redox_users"."0.2.0"."redox_syscall"}" deps)
    ]);
  };
  features_.redox_users."0.2.0" = deps: f: updateFeatures f (rec {
    argon2rs."${deps.redox_users."0.2.0".argon2rs}".default = (f.argon2rs."${deps.redox_users."0.2.0".argon2rs}".default or false);
    failure."${deps.redox_users."0.2.0".failure}".default = true;
    rand."${deps.redox_users."0.2.0".rand}".default = true;
    redox_syscall."${deps.redox_users."0.2.0".redox_syscall}".default = true;
    redox_users."0.2.0".default = (f.redox_users."0.2.0".default or true);
  }) [
    (features_.argon2rs."${deps."redox_users"."0.2.0"."argon2rs"}" deps)
    (features_.failure."${deps."redox_users"."0.2.0"."failure"}" deps)
    (features_.rand."${deps."redox_users"."0.2.0"."rand"}" deps)
    (features_.redox_syscall."${deps."redox_users"."0.2.0"."redox_syscall"}" deps)
  ];


# end
# redox_users-0.3.0

  crates.redox_users."0.3.0" = deps: { features?(features_.redox_users."0.3.0" deps {}) }: buildRustCrate {
    crateName = "redox_users";
    version = "0.3.0";
    authors = [ "Jose Narvaez <goyox86@gmail.com>" "Wesley Hershberger <mggmugginsmc@gmail.com>" ];
    sha256 = "051rzqgk5hn7rf24nwgbb32zfdn8qp2kwqvdp0772ia85p737p4j";
    dependencies = mapFeatures features ([
      (crates."argon2rs"."${deps."redox_users"."0.3.0"."argon2rs"}" deps)
      (crates."failure"."${deps."redox_users"."0.3.0"."failure"}" deps)
      (crates."rand_os"."${deps."redox_users"."0.3.0"."rand_os"}" deps)
      (crates."redox_syscall"."${deps."redox_users"."0.3.0"."redox_syscall"}" deps)
    ]);
  };
  features_.redox_users."0.3.0" = deps: f: updateFeatures f (rec {
    argon2rs."${deps.redox_users."0.3.0".argon2rs}".default = (f.argon2rs."${deps.redox_users."0.3.0".argon2rs}".default or false);
    failure."${deps.redox_users."0.3.0".failure}".default = true;
    rand_os."${deps.redox_users."0.3.0".rand_os}".default = true;
    redox_syscall."${deps.redox_users."0.3.0".redox_syscall}".default = true;
    redox_users."0.3.0".default = (f.redox_users."0.3.0".default or true);
  }) [
    (features_.argon2rs."${deps."redox_users"."0.3.0"."argon2rs"}" deps)
    (features_.failure."${deps."redox_users"."0.3.0"."failure"}" deps)
    (features_.rand_os."${deps."redox_users"."0.3.0"."rand_os"}" deps)
    (features_.redox_syscall."${deps."redox_users"."0.3.0"."redox_syscall"}" deps)
  ];


# end
# regex-0.2.11

  crates.regex."0.2.11" = deps: { features?(features_.regex."0.2.11" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "0.2.11";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0r50cymxdqp0fv1dxd22mjr6y32q450nwacd279p9s7lh0cafijj";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."0.2.11"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."0.2.11"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."0.2.11"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."0.2.11"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."0.2.11" or {});
  };
  features_.regex."0.2.11" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."0.2.11".aho_corasick}".default = true;
    memchr."${deps.regex."0.2.11".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "0.2.11".default = (f.regex."0.2.11".default or true); }
      { "0.2.11".pattern =
        (f.regex."0.2.11".pattern or false) ||
        (f.regex."0.2.11".unstable or false) ||
        (regex."0.2.11"."unstable" or false); }
    ];
    regex_syntax."${deps.regex."0.2.11".regex_syntax}".default = true;
    thread_local."${deps.regex."0.2.11".thread_local}".default = true;
    utf8_ranges."${deps.regex."0.2.11".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."0.2.11"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."0.2.11"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."0.2.11"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."0.2.11"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."0.2.11"."utf8_ranges"}" deps)
  ];


# end
# regex-1.0.5

  crates.regex."1.0.5" = deps: { features?(features_.regex."1.0.5" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.0.5";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1nb4dva9lhb3v76bdds9qcxldb2xy998sdraqnqaqdr6axfsfp02";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."1.0.5"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."1.0.5"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."1.0.5"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."1.0.5"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."1.0.5"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."1.0.5" or {});
  };
  features_.regex."1.0.5" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.0.5".aho_corasick}".default = true;
    memchr."${deps.regex."1.0.5".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.0.5".default = (f.regex."1.0.5".default or true); }
      { "1.0.5".pattern =
        (f.regex."1.0.5".pattern or false) ||
        (f.regex."1.0.5".unstable or false) ||
        (regex."1.0.5"."unstable" or false); }
      { "1.0.5".use_std =
        (f.regex."1.0.5".use_std or false) ||
        (f.regex."1.0.5".default or false) ||
        (regex."1.0.5"."default" or false); }
    ];
    regex_syntax."${deps.regex."1.0.5".regex_syntax}".default = true;
    thread_local."${deps.regex."1.0.5".thread_local}".default = true;
    utf8_ranges."${deps.regex."1.0.5".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.0.5"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.0.5"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.0.5"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.0.5"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."1.0.5"."utf8_ranges"}" deps)
  ];


# end
# regex-1.1.2

  crates.regex."1.1.2" = deps: { features?(features_.regex."1.1.2" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.1.2";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1c9nb031z1vw5l6lzfkfra2mah9hb2s1wgq9f1lmgcbkiiprj9xd";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."1.1.2"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."1.1.2"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."1.1.2"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."1.1.2"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."1.1.2"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."1.1.2" or {});
  };
  features_.regex."1.1.2" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.1.2".aho_corasick}".default = true;
    memchr."${deps.regex."1.1.2".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.1.2".default = (f.regex."1.1.2".default or true); }
      { "1.1.2".pattern =
        (f.regex."1.1.2".pattern or false) ||
        (f.regex."1.1.2".unstable or false) ||
        (regex."1.1.2"."unstable" or false); }
      { "1.1.2".use_std =
        (f.regex."1.1.2".use_std or false) ||
        (f.regex."1.1.2".default or false) ||
        (regex."1.1.2"."default" or false); }
    ];
    regex_syntax."${deps.regex."1.1.2".regex_syntax}".default = true;
    thread_local."${deps.regex."1.1.2".thread_local}".default = true;
    utf8_ranges."${deps.regex."1.1.2".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.1.2"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.1.2"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.1.2"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.1.2"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."1.1.2"."utf8_ranges"}" deps)
  ];


# end
# regex-syntax-0.5.6

  crates.regex_syntax."0.5.6" = deps: { features?(features_.regex_syntax."0.5.6" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.5.6";
    authors = [ "The Rust Project Developers" ];
    sha256 = "10vf3r34bgjnbrnqd5aszn35bjvm8insw498l1vjy8zx5yms3427";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.5.6" = deps: f: updateFeatures f (rec {
    regex_syntax."0.5.6".default = (f.regex_syntax."0.5.6".default or true);
    ucd_util."${deps.regex_syntax."0.5.6".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.5.6"."ucd_util"}" deps)
  ];


# end
# regex-syntax-0.6.2

  crates.regex_syntax."0.6.2" = deps: { features?(features_.regex_syntax."0.6.2" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.2";
    authors = [ "The Rust Project Developers" ];
    sha256 = "109426mj7nhwr6szdzbcvn1a8g5zy52f9maqxjd9agm8wg87ylyw";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.6.2"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.6.2" = deps: f: updateFeatures f (rec {
    regex_syntax."0.6.2".default = (f.regex_syntax."0.6.2".default or true);
    ucd_util."${deps.regex_syntax."0.6.2".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.6.2"."ucd_util"}" deps)
  ];


# end
# regex-syntax-0.6.5

  crates.regex_syntax."0.6.5" = deps: { features?(features_.regex_syntax."0.6.5" deps {}) }: buildRustCrate {
    crateName = "regex-syntax";
    version = "0.6.5";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0aaaba1fan2qfyc31wzdmgmbmyirc27zgcbz41ba5wm1lb2d8kli";
    dependencies = mapFeatures features ([
      (crates."ucd_util"."${deps."regex_syntax"."0.6.5"."ucd_util"}" deps)
    ]);
  };
  features_.regex_syntax."0.6.5" = deps: f: updateFeatures f (rec {
    regex_syntax."0.6.5".default = (f.regex_syntax."0.6.5".default or true);
    ucd_util."${deps.regex_syntax."0.6.5".ucd_util}".default = true;
  }) [
    (features_.ucd_util."${deps."regex_syntax"."0.6.5"."ucd_util"}" deps)
  ];


# end
# remove_dir_all-0.5.1

  crates.remove_dir_all."0.5.1" = deps: { features?(features_.remove_dir_all."0.5.1" deps {}) }: buildRustCrate {
    crateName = "remove_dir_all";
    version = "0.5.1";
    authors = [ "Aaronepower <theaaronepower@gmail.com>" ];
    sha256 = "1chx3yvfbj46xjz4bzsvps208l46hfbcy0sm98gpiya454n4rrl7";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."remove_dir_all"."0.5.1"."winapi"}" deps)
    ]) else []);
  };
  features_.remove_dir_all."0.5.1" = deps: f: updateFeatures f (rec {
    remove_dir_all."0.5.1".default = (f.remove_dir_all."0.5.1".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.remove_dir_all."0.5.1".winapi}"."errhandlingapi" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."fileapi" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."std" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."winbase" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}"."winerror" = true; }
      { "${deps.remove_dir_all."0.5.1".winapi}".default = true; }
    ];
  }) [
    (features_.winapi."${deps."remove_dir_all"."0.5.1"."winapi"}" deps)
  ];


# end
# reqwest-0.9.11

  crates.reqwest."0.9.11" = deps: { features?(features_.reqwest."0.9.11" deps {}) }: buildRustCrate {
    crateName = "reqwest";
    version = "0.9.11";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "10vkjg8d7is98822ibdajs27596xf9910mqidxlxgg01zjii4mfv";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."reqwest"."0.9.11"."base64"}" deps)
      (crates."bytes"."${deps."reqwest"."0.9.11"."bytes"}" deps)
      (crates."encoding_rs"."${deps."reqwest"."0.9.11"."encoding_rs"}" deps)
      (crates."futures"."${deps."reqwest"."0.9.11"."futures"}" deps)
      (crates."http"."${deps."reqwest"."0.9.11"."http"}" deps)
      (crates."hyper"."${deps."reqwest"."0.9.11"."hyper"}" deps)
      (crates."libflate"."${deps."reqwest"."0.9.11"."libflate"}" deps)
      (crates."log"."${deps."reqwest"."0.9.11"."log"}" deps)
      (crates."mime"."${deps."reqwest"."0.9.11"."mime"}" deps)
      (crates."mime_guess"."${deps."reqwest"."0.9.11"."mime_guess"}" deps)
      (crates."serde"."${deps."reqwest"."0.9.11"."serde"}" deps)
      (crates."serde_json"."${deps."reqwest"."0.9.11"."serde_json"}" deps)
      (crates."serde_urlencoded"."${deps."reqwest"."0.9.11"."serde_urlencoded"}" deps)
      (crates."tokio"."${deps."reqwest"."0.9.11"."tokio"}" deps)
      (crates."tokio_executor"."${deps."reqwest"."0.9.11"."tokio_executor"}" deps)
      (crates."tokio_io"."${deps."reqwest"."0.9.11"."tokio_io"}" deps)
      (crates."tokio_threadpool"."${deps."reqwest"."0.9.11"."tokio_threadpool"}" deps)
      (crates."tokio_timer"."${deps."reqwest"."0.9.11"."tokio_timer"}" deps)
      (crates."url"."${deps."reqwest"."0.9.11"."url"}" deps)
      (crates."uuid"."${deps."reqwest"."0.9.11"."uuid"}" deps)
    ]
      ++ (if features.reqwest."0.9.11".hyper-tls or false then [ (crates.hyper_tls."${deps."reqwest"."0.9.11".hyper_tls}" deps) ] else [])
      ++ (if features.reqwest."0.9.11".native-tls or false then [ (crates.native_tls."${deps."reqwest"."0.9.11".native_tls}" deps) ] else []));
    features = mkFeatures (features."reqwest"."0.9.11" or {});
  };
  features_.reqwest."0.9.11" = deps: f: updateFeatures f (rec {
    base64."${deps.reqwest."0.9.11".base64}".default = true;
    bytes."${deps.reqwest."0.9.11".bytes}".default = true;
    encoding_rs."${deps.reqwest."0.9.11".encoding_rs}".default = true;
    futures."${deps.reqwest."0.9.11".futures}".default = true;
    http."${deps.reqwest."0.9.11".http}".default = true;
    hyper."${deps.reqwest."0.9.11".hyper}".default = true;
    hyper_tls."${deps.reqwest."0.9.11".hyper_tls}".default = true;
    libflate."${deps.reqwest."0.9.11".libflate}".default = true;
    log."${deps.reqwest."0.9.11".log}".default = true;
    mime."${deps.reqwest."0.9.11".mime}".default = true;
    mime_guess."${deps.reqwest."0.9.11".mime_guess}".default = true;
    native_tls = fold recursiveUpdate {} [
      { "${deps.reqwest."0.9.11".native_tls}"."vendored" =
        (f.native_tls."${deps.reqwest."0.9.11".native_tls}"."vendored" or false) ||
        (reqwest."0.9.11"."default-tls-vendored" or false) ||
        (f."reqwest"."0.9.11"."default-tls-vendored" or false); }
      { "${deps.reqwest."0.9.11".native_tls}".default = true; }
    ];
    reqwest = fold recursiveUpdate {} [
      { "0.9.11".default = (f.reqwest."0.9.11".default or true); }
      { "0.9.11".default-tls =
        (f.reqwest."0.9.11".default-tls or false) ||
        (f.reqwest."0.9.11".default or false) ||
        (reqwest."0.9.11"."default" or false) ||
        (f.reqwest."0.9.11".default-tls-vendored or false) ||
        (reqwest."0.9.11"."default-tls-vendored" or false); }
      { "0.9.11".hyper-old-types =
        (f.reqwest."0.9.11".hyper-old-types or false) ||
        (f.reqwest."0.9.11".hyper-011 or false) ||
        (reqwest."0.9.11"."hyper-011" or false); }
      { "0.9.11".hyper-rustls =
        (f.reqwest."0.9.11".hyper-rustls or false) ||
        (f.reqwest."0.9.11".rustls-tls or false) ||
        (reqwest."0.9.11"."rustls-tls" or false); }
      { "0.9.11".hyper-tls =
        (f.reqwest."0.9.11".hyper-tls or false) ||
        (f.reqwest."0.9.11".default-tls or false) ||
        (reqwest."0.9.11"."default-tls" or false); }
      { "0.9.11".native-tls =
        (f.reqwest."0.9.11".native-tls or false) ||
        (f.reqwest."0.9.11".default-tls or false) ||
        (reqwest."0.9.11"."default-tls" or false); }
      { "0.9.11".rustls =
        (f.reqwest."0.9.11".rustls or false) ||
        (f.reqwest."0.9.11".rustls-tls or false) ||
        (reqwest."0.9.11"."rustls-tls" or false); }
      { "0.9.11".tls =
        (f.reqwest."0.9.11".tls or false) ||
        (f.reqwest."0.9.11".default-tls or false) ||
        (reqwest."0.9.11"."default-tls" or false) ||
        (f.reqwest."0.9.11".rustls-tls or false) ||
        (reqwest."0.9.11"."rustls-tls" or false); }
      { "0.9.11".tokio-rustls =
        (f.reqwest."0.9.11".tokio-rustls or false) ||
        (f.reqwest."0.9.11".rustls-tls or false) ||
        (reqwest."0.9.11"."rustls-tls" or false); }
      { "0.9.11".trust-dns-resolver =
        (f.reqwest."0.9.11".trust-dns-resolver or false) ||
        (f.reqwest."0.9.11".trust-dns or false) ||
        (reqwest."0.9.11"."trust-dns" or false); }
      { "0.9.11".webpki-roots =
        (f.reqwest."0.9.11".webpki-roots or false) ||
        (f.reqwest."0.9.11".rustls-tls or false) ||
        (reqwest."0.9.11"."rustls-tls" or false); }
    ];
    serde."${deps.reqwest."0.9.11".serde}".default = true;
    serde_json."${deps.reqwest."0.9.11".serde_json}".default = true;
    serde_urlencoded."${deps.reqwest."0.9.11".serde_urlencoded}".default = true;
    tokio = fold recursiveUpdate {} [
      { "${deps.reqwest."0.9.11".tokio}"."rt-full" = true; }
      { "${deps.reqwest."0.9.11".tokio}".default = (f.tokio."${deps.reqwest."0.9.11".tokio}".default or false); }
    ];
    tokio_executor."${deps.reqwest."0.9.11".tokio_executor}".default = true;
    tokio_io."${deps.reqwest."0.9.11".tokio_io}".default = true;
    tokio_threadpool."${deps.reqwest."0.9.11".tokio_threadpool}".default = true;
    tokio_timer."${deps.reqwest."0.9.11".tokio_timer}".default = true;
    url."${deps.reqwest."0.9.11".url}".default = true;
    uuid = fold recursiveUpdate {} [
      { "${deps.reqwest."0.9.11".uuid}"."v4" = true; }
      { "${deps.reqwest."0.9.11".uuid}".default = true; }
    ];
  }) [
    (features_.base64."${deps."reqwest"."0.9.11"."base64"}" deps)
    (features_.bytes."${deps."reqwest"."0.9.11"."bytes"}" deps)
    (features_.encoding_rs."${deps."reqwest"."0.9.11"."encoding_rs"}" deps)
    (features_.futures."${deps."reqwest"."0.9.11"."futures"}" deps)
    (features_.http."${deps."reqwest"."0.9.11"."http"}" deps)
    (features_.hyper."${deps."reqwest"."0.9.11"."hyper"}" deps)
    (features_.hyper_tls."${deps."reqwest"."0.9.11"."hyper_tls"}" deps)
    (features_.libflate."${deps."reqwest"."0.9.11"."libflate"}" deps)
    (features_.log."${deps."reqwest"."0.9.11"."log"}" deps)
    (features_.mime."${deps."reqwest"."0.9.11"."mime"}" deps)
    (features_.mime_guess."${deps."reqwest"."0.9.11"."mime_guess"}" deps)
    (features_.native_tls."${deps."reqwest"."0.9.11"."native_tls"}" deps)
    (features_.serde."${deps."reqwest"."0.9.11"."serde"}" deps)
    (features_.serde_json."${deps."reqwest"."0.9.11"."serde_json"}" deps)
    (features_.serde_urlencoded."${deps."reqwest"."0.9.11"."serde_urlencoded"}" deps)
    (features_.tokio."${deps."reqwest"."0.9.11"."tokio"}" deps)
    (features_.tokio_executor."${deps."reqwest"."0.9.11"."tokio_executor"}" deps)
    (features_.tokio_io."${deps."reqwest"."0.9.11"."tokio_io"}" deps)
    (features_.tokio_threadpool."${deps."reqwest"."0.9.11"."tokio_threadpool"}" deps)
    (features_.tokio_timer."${deps."reqwest"."0.9.11"."tokio_timer"}" deps)
    (features_.url."${deps."reqwest"."0.9.11"."url"}" deps)
    (features_.uuid."${deps."reqwest"."0.9.11"."uuid"}" deps)
  ];


# end
# rusoto_core-0.36.0

  crates.rusoto_core."0.36.0" = deps: { features?(features_.rusoto_core."0.36.0" deps {}) }: buildRustCrate {
    crateName = "rusoto_core";
    version = "0.36.0";
    authors = [ "Anthony DiMarco <ocramida@gmail.com>" "Jimmy Cuadra <jimmy@jimmycuadra.com>" "Matthew Mayer <matthewkmayer@gmail.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "1ba9ks6rhaxhck3hspnckilfdj3kvm2hff4k6z7g04crlwc1rqk7";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."rusoto_core"."0.36.0"."base64"}" deps)
      (crates."futures"."${deps."rusoto_core"."0.36.0"."futures"}" deps)
      (crates."hex"."${deps."rusoto_core"."0.36.0"."hex"}" deps)
      (crates."hmac"."${deps."rusoto_core"."0.36.0"."hmac"}" deps)
      (crates."hyper"."${deps."rusoto_core"."0.36.0"."hyper"}" deps)
      (crates."lazy_static"."${deps."rusoto_core"."0.36.0"."lazy_static"}" deps)
      (crates."log"."${deps."rusoto_core"."0.36.0"."log"}" deps)
      (crates."md5"."${deps."rusoto_core"."0.36.0"."md5"}" deps)
      (crates."rusoto_credential"."${deps."rusoto_core"."0.36.0"."rusoto_credential"}" deps)
      (crates."serde"."${deps."rusoto_core"."0.36.0"."serde"}" deps)
      (crates."sha2"."${deps."rusoto_core"."0.36.0"."sha2"}" deps)
      (crates."time"."${deps."rusoto_core"."0.36.0"."time"}" deps)
      (crates."tokio"."${deps."rusoto_core"."0.36.0"."tokio"}" deps)
      (crates."tokio_timer"."${deps."rusoto_core"."0.36.0"."tokio_timer"}" deps)
      (crates."url"."${deps."rusoto_core"."0.36.0"."url"}" deps)
      (crates."xml_rs"."${deps."rusoto_core"."0.36.0"."xml_rs"}" deps)
    ]
      ++ (if features.rusoto_core."0.36.0".hyper-tls or false then [ (crates.hyper_tls."${deps."rusoto_core"."0.36.0".hyper_tls}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."rusoto_core"."0.36.0"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."rusoto_core"."0.36.0" or {});
  };
  features_.rusoto_core."0.36.0" = deps: f: updateFeatures f (rec {
    base64."${deps.rusoto_core."0.36.0".base64}".default = true;
    futures."${deps.rusoto_core."0.36.0".futures}".default = true;
    hex."${deps.rusoto_core."0.36.0".hex}".default = true;
    hmac."${deps.rusoto_core."0.36.0".hmac}".default = true;
    hyper."${deps.rusoto_core."0.36.0".hyper}".default = true;
    hyper_tls."${deps.rusoto_core."0.36.0".hyper_tls}".default = true;
    lazy_static."${deps.rusoto_core."0.36.0".lazy_static}".default = true;
    log."${deps.rusoto_core."0.36.0".log}".default = true;
    md5."${deps.rusoto_core."0.36.0".md5}".default = true;
    rusoto_core = fold recursiveUpdate {} [
      { "0.36.0".clippy =
        (f.rusoto_core."0.36.0".clippy or false) ||
        (f.rusoto_core."0.36.0".nightly-testing or false) ||
        (rusoto_core."0.36.0"."nightly-testing" or false); }
      { "0.36.0".default = (f.rusoto_core."0.36.0".default or true); }
      { "0.36.0".hyper-rustls =
        (f.rusoto_core."0.36.0".hyper-rustls or false) ||
        (f.rusoto_core."0.36.0".rustls or false) ||
        (rusoto_core."0.36.0"."rustls" or false); }
      { "0.36.0".hyper-tls =
        (f.rusoto_core."0.36.0".hyper-tls or false) ||
        (f.rusoto_core."0.36.0".native-tls or false) ||
        (rusoto_core."0.36.0"."native-tls" or false); }
      { "0.36.0".native-tls =
        (f.rusoto_core."0.36.0".native-tls or false) ||
        (f.rusoto_core."0.36.0".default or false) ||
        (rusoto_core."0.36.0"."default" or false); }
    ];
    rusoto_credential = fold recursiveUpdate {} [
      { "${deps.rusoto_core."0.36.0".rusoto_credential}"."nightly-testing" =
        (f.rusoto_credential."${deps.rusoto_core."0.36.0".rusoto_credential}"."nightly-testing" or false) ||
        (rusoto_core."0.36.0"."nightly-testing" or false) ||
        (f."rusoto_core"."0.36.0"."nightly-testing" or false); }
      { "${deps.rusoto_core."0.36.0".rusoto_credential}".default = true; }
    ];
    rustc_version."${deps.rusoto_core."0.36.0".rustc_version}".default = true;
    serde."${deps.rusoto_core."0.36.0".serde}".default = true;
    sha2."${deps.rusoto_core."0.36.0".sha2}".default = true;
    time."${deps.rusoto_core."0.36.0".time}".default = true;
    tokio."${deps.rusoto_core."0.36.0".tokio}".default = true;
    tokio_timer."${deps.rusoto_core."0.36.0".tokio_timer}".default = true;
    url."${deps.rusoto_core."0.36.0".url}".default = true;
    xml_rs."${deps.rusoto_core."0.36.0".xml_rs}".default = true;
  }) [
    (features_.base64."${deps."rusoto_core"."0.36.0"."base64"}" deps)
    (features_.futures."${deps."rusoto_core"."0.36.0"."futures"}" deps)
    (features_.hex."${deps."rusoto_core"."0.36.0"."hex"}" deps)
    (features_.hmac."${deps."rusoto_core"."0.36.0"."hmac"}" deps)
    (features_.hyper."${deps."rusoto_core"."0.36.0"."hyper"}" deps)
    (features_.hyper_tls."${deps."rusoto_core"."0.36.0"."hyper_tls"}" deps)
    (features_.lazy_static."${deps."rusoto_core"."0.36.0"."lazy_static"}" deps)
    (features_.log."${deps."rusoto_core"."0.36.0"."log"}" deps)
    (features_.md5."${deps."rusoto_core"."0.36.0"."md5"}" deps)
    (features_.rusoto_credential."${deps."rusoto_core"."0.36.0"."rusoto_credential"}" deps)
    (features_.serde."${deps."rusoto_core"."0.36.0"."serde"}" deps)
    (features_.sha2."${deps."rusoto_core"."0.36.0"."sha2"}" deps)
    (features_.time."${deps."rusoto_core"."0.36.0"."time"}" deps)
    (features_.tokio."${deps."rusoto_core"."0.36.0"."tokio"}" deps)
    (features_.tokio_timer."${deps."rusoto_core"."0.36.0"."tokio_timer"}" deps)
    (features_.url."${deps."rusoto_core"."0.36.0"."url"}" deps)
    (features_.xml_rs."${deps."rusoto_core"."0.36.0"."xml_rs"}" deps)
    (features_.rustc_version."${deps."rusoto_core"."0.36.0"."rustc_version"}" deps)
  ];


# end
# rusoto_credential-0.15.0

  crates.rusoto_credential."0.15.0" = deps: { features?(features_.rusoto_credential."0.15.0" deps {}) }: buildRustCrate {
    crateName = "rusoto_credential";
    version = "0.15.0";
    authors = [ "Anthony DiMarco <ocramida@gmail.com>" "Jimmy Cuadra <jimmy@jimmycuadra.com>" "Matthew Mayer <matthewkmayer@gmail.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "19kzqmybk4i0qrlg0y7x56aybnqvpws969lmr2xq4xyav0p8c3j0";
    dependencies = mapFeatures features ([
      (crates."chrono"."${deps."rusoto_credential"."0.15.0"."chrono"}" deps)
      (crates."dirs"."${deps."rusoto_credential"."0.15.0"."dirs"}" deps)
      (crates."futures"."${deps."rusoto_credential"."0.15.0"."futures"}" deps)
      (crates."hyper"."${deps."rusoto_credential"."0.15.0"."hyper"}" deps)
      (crates."regex"."${deps."rusoto_credential"."0.15.0"."regex"}" deps)
      (crates."serde"."${deps."rusoto_credential"."0.15.0"."serde"}" deps)
      (crates."serde_derive"."${deps."rusoto_credential"."0.15.0"."serde_derive"}" deps)
      (crates."serde_json"."${deps."rusoto_credential"."0.15.0"."serde_json"}" deps)
      (crates."tokio_timer"."${deps."rusoto_credential"."0.15.0"."tokio_timer"}" deps)
    ]);
    features = mkFeatures (features."rusoto_credential"."0.15.0" or {});
  };
  features_.rusoto_credential."0.15.0" = deps: f: updateFeatures f (rec {
    chrono = fold recursiveUpdate {} [
      { "${deps.rusoto_credential."0.15.0".chrono}"."serde" = true; }
      { "${deps.rusoto_credential."0.15.0".chrono}".default = true; }
    ];
    dirs."${deps.rusoto_credential."0.15.0".dirs}".default = true;
    futures."${deps.rusoto_credential."0.15.0".futures}".default = true;
    hyper."${deps.rusoto_credential."0.15.0".hyper}".default = true;
    regex."${deps.rusoto_credential."0.15.0".regex}".default = true;
    rusoto_credential = fold recursiveUpdate {} [
      { "0.15.0".clippy =
        (f.rusoto_credential."0.15.0".clippy or false) ||
        (f.rusoto_credential."0.15.0".nightly-testing or false) ||
        (rusoto_credential."0.15.0"."nightly-testing" or false); }
      { "0.15.0".default = (f.rusoto_credential."0.15.0".default or true); }
    ];
    serde."${deps.rusoto_credential."0.15.0".serde}".default = true;
    serde_derive."${deps.rusoto_credential."0.15.0".serde_derive}".default = true;
    serde_json."${deps.rusoto_credential."0.15.0".serde_json}".default = true;
    tokio_timer."${deps.rusoto_credential."0.15.0".tokio_timer}".default = true;
  }) [
    (features_.chrono."${deps."rusoto_credential"."0.15.0"."chrono"}" deps)
    (features_.dirs."${deps."rusoto_credential"."0.15.0"."dirs"}" deps)
    (features_.futures."${deps."rusoto_credential"."0.15.0"."futures"}" deps)
    (features_.hyper."${deps."rusoto_credential"."0.15.0"."hyper"}" deps)
    (features_.regex."${deps."rusoto_credential"."0.15.0"."regex"}" deps)
    (features_.serde."${deps."rusoto_credential"."0.15.0"."serde"}" deps)
    (features_.serde_derive."${deps."rusoto_credential"."0.15.0"."serde_derive"}" deps)
    (features_.serde_json."${deps."rusoto_credential"."0.15.0"."serde_json"}" deps)
    (features_.tokio_timer."${deps."rusoto_credential"."0.15.0"."tokio_timer"}" deps)
  ];


# end
# rusoto_ses-0.36.0

  crates.rusoto_ses."0.36.0" = deps: { features?(features_.rusoto_ses."0.36.0" deps {}) }: buildRustCrate {
    crateName = "rusoto_ses";
    version = "0.36.0";
    authors = [ "Anthony DiMarco <ocramida@gmail.com>" "Jimmy Cuadra <jimmy@jimmycuadra.com>" "Matthew Mayer <matthewkmayer@gmail.com>" "Nikita Pekin <contact@nikitapek.in>" ];
    sha256 = "1g5rrb1dcar5269cckyhqsr0wsrxxx6bsdvg8946ldrqkdadc5hz";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."rusoto_ses"."0.36.0"."futures"}" deps)
      (crates."rusoto_core"."${deps."rusoto_ses"."0.36.0"."rusoto_core"}" deps)
      (crates."serde_urlencoded"."${deps."rusoto_ses"."0.36.0"."serde_urlencoded"}" deps)
      (crates."xml_rs"."${deps."rusoto_ses"."0.36.0"."xml_rs"}" deps)
    ]);
    features = mkFeatures (features."rusoto_ses"."0.36.0" or {});
  };
  features_.rusoto_ses."0.36.0" = deps: f: updateFeatures f (rec {
    futures."${deps.rusoto_ses."0.36.0".futures}".default = true;
    rusoto_core = fold recursiveUpdate {} [
      { "${deps.rusoto_ses."0.36.0".rusoto_core}"."native-tls" =
        (f.rusoto_core."${deps.rusoto_ses."0.36.0".rusoto_core}"."native-tls" or false) ||
        (rusoto_ses."0.36.0"."native-tls" or false) ||
        (f."rusoto_ses"."0.36.0"."native-tls" or false); }
      { "${deps.rusoto_ses."0.36.0".rusoto_core}"."rustls" =
        (f.rusoto_core."${deps.rusoto_ses."0.36.0".rusoto_core}"."rustls" or false) ||
        (rusoto_ses."0.36.0"."rustls" or false) ||
        (f."rusoto_ses"."0.36.0"."rustls" or false); }
      { "${deps.rusoto_ses."0.36.0".rusoto_core}".default = (f.rusoto_core."${deps.rusoto_ses."0.36.0".rusoto_core}".default or false); }
    ];
    rusoto_ses = fold recursiveUpdate {} [
      { "0.36.0".default = (f.rusoto_ses."0.36.0".default or true); }
      { "0.36.0".native-tls =
        (f.rusoto_ses."0.36.0".native-tls or false) ||
        (f.rusoto_ses."0.36.0".default or false) ||
        (rusoto_ses."0.36.0"."default" or false); }
    ];
    serde_urlencoded."${deps.rusoto_ses."0.36.0".serde_urlencoded}".default = true;
    xml_rs."${deps.rusoto_ses."0.36.0".xml_rs}".default = true;
  }) [
    (features_.futures."${deps."rusoto_ses"."0.36.0"."futures"}" deps)
    (features_.rusoto_core."${deps."rusoto_ses"."0.36.0"."rusoto_core"}" deps)
    (features_.serde_urlencoded."${deps."rusoto_ses"."0.36.0"."serde_urlencoded"}" deps)
    (features_.xml_rs."${deps."rusoto_ses"."0.36.0"."xml_rs"}" deps)
  ];


# end
# rustc-demangle-0.1.13

  crates.rustc_demangle."0.1.13" = deps: { features?(features_.rustc_demangle."0.1.13" deps {}) }: buildRustCrate {
    crateName = "rustc-demangle";
    version = "0.1.13";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0sr6cr02araqnlqwc5ghvnafjmkw11vzjswqaz757lvyrcl8xcy6";
  };
  features_.rustc_demangle."0.1.13" = deps: f: updateFeatures f (rec {
    rustc_demangle."0.1.13".default = (f.rustc_demangle."0.1.13".default or true);
  }) [];


# end
# rustc-demangle-0.1.9

  crates.rustc_demangle."0.1.9" = deps: { features?(features_.rustc_demangle."0.1.9" deps {}) }: buildRustCrate {
    crateName = "rustc-demangle";
    version = "0.1.9";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "00ma4r9haq0zv5krps617mym6y74056pfcivyld0kpci156vfaax";
  };
  features_.rustc_demangle."0.1.9" = deps: f: updateFeatures f (rec {
    rustc_demangle."0.1.9".default = (f.rustc_demangle."0.1.9".default or true);
  }) [];


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
# rustc_version-0.2.3

  crates.rustc_version."0.2.3" = deps: { features?(features_.rustc_version."0.2.3" deps {}) }: buildRustCrate {
    crateName = "rustc_version";
    version = "0.2.3";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "0rgwzbgs3i9fqjm1p4ra3n7frafmpwl29c8lw85kv1rxn7n2zaa7";
    dependencies = mapFeatures features ([
      (crates."semver"."${deps."rustc_version"."0.2.3"."semver"}" deps)
    ]);
  };
  features_.rustc_version."0.2.3" = deps: f: updateFeatures f (rec {
    rustc_version."0.2.3".default = (f.rustc_version."0.2.3".default or true);
    semver."${deps.rustc_version."0.2.3".semver}".default = true;
  }) [
    (features_.semver."${deps."rustc_version"."0.2.3"."semver"}" deps)
  ];


# end
# ryu-0.2.6

  crates.ryu."0.2.6" = deps: { features?(features_.ryu."0.2.6" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "0.2.6";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1vdh6z4aysc9kiiqhl7vxkqz3fykcnp24kgfizshlwfsz2j0p9dr";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."0.2.6" or {});
  };
  features_.ryu."0.2.6" = deps: f: updateFeatures f (rec {
    ryu."0.2.6".default = (f.ryu."0.2.6".default or true);
  }) [];


# end
# ryu-0.2.7

  crates.ryu."0.2.7" = deps: { features?(features_.ryu."0.2.7" deps {}) }: buildRustCrate {
    crateName = "ryu";
    version = "0.2.7";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0m8szf1m87wfqkwh1f9zp9bn2mb0m9nav028xxnd0hlig90b44bd";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."ryu"."0.2.7" or {});
  };
  features_.ryu."0.2.7" = deps: f: updateFeatures f (rec {
    ryu."0.2.7".default = (f.ryu."0.2.7".default or true);
  }) [];


# end
# safe-transmute-0.10.1

  crates.safe_transmute."0.10.1" = deps: { features?(features_.safe_transmute."0.10.1" deps {}) }: buildRustCrate {
    crateName = "safe-transmute";
    version = "0.10.1";
    authors = [ "nabijaczleweli <nabijaczleweli@gmail.com>" "Eduardo Pinho <enet4mikeenet@gmail.com>" ];
    sha256 = "0aazbwabj8521hr0gvs8l2rrhryngpsf0qck9ps792pvcv3h5rja";
    features = mkFeatures (features."safe_transmute"."0.10.1" or {});
  };
  features_.safe_transmute."0.10.1" = deps: f: updateFeatures f (rec {
    safe_transmute = fold recursiveUpdate {} [
      { "0.10.1".default = (f.safe_transmute."0.10.1".default or true); }
      { "0.10.1".std =
        (f.safe_transmute."0.10.1".std or false) ||
        (f.safe_transmute."0.10.1".default or false) ||
        (safe_transmute."0.10.1"."default" or false); }
    ];
  }) [];


# end
# safemem-0.2.0

  crates.safemem."0.2.0" = deps: { features?(features_.safemem."0.2.0" deps {}) }: buildRustCrate {
    crateName = "safemem";
    version = "0.2.0";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "058m251q202n479ip1h6s91yw3plg66vsk5mpaflssn6rs5hijdm";
  };
  features_.safemem."0.2.0" = deps: f: updateFeatures f (rec {
    safemem."0.2.0".default = (f.safemem."0.2.0".default or true);
  }) [];


# end
# safemem-0.3.0

  crates.safemem."0.3.0" = deps: { features?(features_.safemem."0.3.0" deps {}) }: buildRustCrate {
    crateName = "safemem";
    version = "0.3.0";
    authors = [ "Austin Bonander <austin.bonander@gmail.com>" ];
    sha256 = "0pr39b468d05f6m7m4alsngmj5p7an8df21apsxbi57k0lmwrr18";
    features = mkFeatures (features."safemem"."0.3.0" or {});
  };
  features_.safemem."0.3.0" = deps: f: updateFeatures f (rec {
    safemem = fold recursiveUpdate {} [
      { "0.3.0".default = (f.safemem."0.3.0".default or true); }
      { "0.3.0".std =
        (f.safemem."0.3.0".std or false) ||
        (f.safemem."0.3.0".default or false) ||
        (safemem."0.3.0"."default" or false); }
    ];
  }) [];


# end
# same-file-1.0.4

  crates.same_file."1.0.4" = deps: { features?(features_.same_file."1.0.4" deps {}) }: buildRustCrate {
    crateName = "same-file";
    version = "1.0.4";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1zs244ssl381cqlnh2g42g3i60qip4z72i26z44d6kas3y3gy77q";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi_util"."${deps."same_file"."1.0.4"."winapi_util"}" deps)
    ]) else []);
  };
  features_.same_file."1.0.4" = deps: f: updateFeatures f (rec {
    same_file."1.0.4".default = (f.same_file."1.0.4".default or true);
    winapi_util."${deps.same_file."1.0.4".winapi_util}".default = true;
  }) [
    (features_.winapi_util."${deps."same_file"."1.0.4"."winapi_util"}" deps)
  ];


# end
# sanakirja-0.8.22

  crates.sanakirja."0.8.22" = deps: { features?(features_.sanakirja."0.8.22" deps {}) }: buildRustCrate {
    crateName = "sanakirja";
    version = "0.8.22";
    authors = [ "Pierre-Étienne Meunier" "Florent Becker" ];
    sha256 = "0bj92j2nzbfqbiwnr6dhd23yzps5q1zky2kx328lsfqn12xjvwdi";
    dependencies = mapFeatures features ([
      (crates."fs2"."${deps."sanakirja"."0.8.22"."fs2"}" deps)
      (crates."log"."${deps."sanakirja"."0.8.22"."log"}" deps)
      (crates."memmap"."${deps."sanakirja"."0.8.22"."memmap"}" deps)
      (crates."rand"."${deps."sanakirja"."0.8.22"."rand"}" deps)
    ]);
  };
  features_.sanakirja."0.8.22" = deps: f: updateFeatures f (rec {
    fs2."${deps.sanakirja."0.8.22".fs2}".default = true;
    log."${deps.sanakirja."0.8.22".log}".default = true;
    memmap."${deps.sanakirja."0.8.22".memmap}".default = true;
    rand."${deps.sanakirja."0.8.22".rand}".default = true;
    sanakirja."0.8.22".default = (f.sanakirja."0.8.22".default or true);
  }) [
    (features_.fs2."${deps."sanakirja"."0.8.22"."fs2"}" deps)
    (features_.log."${deps."sanakirja"."0.8.22"."log"}" deps)
    (features_.memmap."${deps."sanakirja"."0.8.22"."memmap"}" deps)
    (features_.rand."${deps."sanakirja"."0.8.22"."rand"}" deps)
  ];


# end
# schannel-0.1.15

  crates.schannel."0.1.15" = deps: { features?(features_.schannel."0.1.15" deps {}) }: buildRustCrate {
    crateName = "schannel";
    version = "0.1.15";
    authors = [ "Steven Fackler <sfackler@gmail.com>" "Steffen Butzer <steffen.butzer@outlook.com>" ];
    sha256 = "1x9i0z9y8n5cg23ppyglgqdlz6rwcv2a489m5qpfk6l2ib8a1jdv";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."schannel"."0.1.15"."lazy_static"}" deps)
      (crates."winapi"."${deps."schannel"."0.1.15"."winapi"}" deps)
    ]);
  };
  features_.schannel."0.1.15" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.schannel."0.1.15".lazy_static}".default = true;
    schannel."0.1.15".default = (f.schannel."0.1.15".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.schannel."0.1.15".winapi}"."lmcons" = true; }
      { "${deps.schannel."0.1.15".winapi}"."minschannel" = true; }
      { "${deps.schannel."0.1.15".winapi}"."schannel" = true; }
      { "${deps.schannel."0.1.15".winapi}"."securitybaseapi" = true; }
      { "${deps.schannel."0.1.15".winapi}"."sspi" = true; }
      { "${deps.schannel."0.1.15".winapi}"."sysinfoapi" = true; }
      { "${deps.schannel."0.1.15".winapi}"."timezoneapi" = true; }
      { "${deps.schannel."0.1.15".winapi}"."winbase" = true; }
      { "${deps.schannel."0.1.15".winapi}"."wincrypt" = true; }
      { "${deps.schannel."0.1.15".winapi}"."winerror" = true; }
      { "${deps.schannel."0.1.15".winapi}".default = true; }
    ];
  }) [
    (features_.lazy_static."${deps."schannel"."0.1.15"."lazy_static"}" deps)
    (features_.winapi."${deps."schannel"."0.1.15"."winapi"}" deps)
  ];


# end
# scoped_threadpool-0.1.9

  crates.scoped_threadpool."0.1.9" = deps: { features?(features_.scoped_threadpool."0.1.9" deps {}) }: buildRustCrate {
    crateName = "scoped_threadpool";
    version = "0.1.9";
    authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
    sha256 = "1arqj2skcfr46s1lcyvnlmfr5456kg5nhn8k90xyfjnxkp5yga2v";
    features = mkFeatures (features."scoped_threadpool"."0.1.9" or {});
  };
  features_.scoped_threadpool."0.1.9" = deps: f: updateFeatures f (rec {
    scoped_threadpool."0.1.9".default = (f.scoped_threadpool."0.1.9".default or true);
  }) [];


# end
# scopeguard-0.3.3

  crates.scopeguard."0.3.3" = deps: { features?(features_.scopeguard."0.3.3" deps {}) }: buildRustCrate {
    crateName = "scopeguard";
    version = "0.3.3";
    authors = [ "bluss" ];
    sha256 = "0i1l013csrqzfz6c68pr5pi01hg5v5yahq8fsdmaxy6p8ygsjf3r";
    features = mkFeatures (features."scopeguard"."0.3.3" or {});
  };
  features_.scopeguard."0.3.3" = deps: f: updateFeatures f (rec {
    scopeguard = fold recursiveUpdate {} [
      { "0.3.3".default = (f.scopeguard."0.3.3".default or true); }
      { "0.3.3".use_std =
        (f.scopeguard."0.3.3".use_std or false) ||
        (f.scopeguard."0.3.3".default or false) ||
        (scopeguard."0.3.3"."default" or false); }
    ];
  }) [];


# end
# security-framework-0.2.2

  crates.security_framework."0.2.2" = deps: { features?(features_.security_framework."0.2.2" deps {}) }: buildRustCrate {
    crateName = "security-framework";
    version = "0.2.2";
    authors = [ "Steven Fackler <sfackler@gmail.com>" "Kornel <kornel@geekhood.net>" ];
    sha256 = "1hs3xk4fq3641nrzfgm5m9hbwg1k5bxnhhj6s8yh1xnhlkrlndf0";
    dependencies = mapFeatures features ([
      (crates."core_foundation"."${deps."security_framework"."0.2.2"."core_foundation"}" deps)
      (crates."core_foundation_sys"."${deps."security_framework"."0.2.2"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."security_framework"."0.2.2"."libc"}" deps)
      (crates."security_framework_sys"."${deps."security_framework"."0.2.2"."security_framework_sys"}" deps)
    ]);
    features = mkFeatures (features."security_framework"."0.2.2" or {});
  };
  features_.security_framework."0.2.2" = deps: f: updateFeatures f (rec {
    core_foundation."${deps.security_framework."0.2.2".core_foundation}".default = true;
    core_foundation_sys."${deps.security_framework."0.2.2".core_foundation_sys}".default = true;
    libc."${deps.security_framework."0.2.2".libc}".default = true;
    security_framework = fold recursiveUpdate {} [
      { "0.2.2".OSX_10_10 =
        (f.security_framework."0.2.2".OSX_10_10 or false) ||
        (f.security_framework."0.2.2".OSX_10_11 or false) ||
        (security_framework."0.2.2"."OSX_10_11" or false); }
      { "0.2.2".OSX_10_11 =
        (f.security_framework."0.2.2".OSX_10_11 or false) ||
        (f.security_framework."0.2.2".OSX_10_12 or false) ||
        (security_framework."0.2.2"."OSX_10_12" or false); }
      { "0.2.2".OSX_10_12 =
        (f.security_framework."0.2.2".OSX_10_12 or false) ||
        (f.security_framework."0.2.2".OSX_10_13 or false) ||
        (security_framework."0.2.2"."OSX_10_13" or false); }
      { "0.2.2".OSX_10_9 =
        (f.security_framework."0.2.2".OSX_10_9 or false) ||
        (f.security_framework."0.2.2".OSX_10_10 or false) ||
        (security_framework."0.2.2"."OSX_10_10" or false); }
      { "0.2.2".alpn =
        (f.security_framework."0.2.2".alpn or false) ||
        (f.security_framework."0.2.2".OSX_10_13 or false) ||
        (security_framework."0.2.2"."OSX_10_13" or false); }
      { "0.2.2".default = (f.security_framework."0.2.2".default or true); }
    ];
    security_framework_sys = fold recursiveUpdate {} [
      { "${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_10" =
        (f.security_framework_sys."${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_10" or false) ||
        (security_framework."0.2.2"."OSX_10_10" or false) ||
        (f."security_framework"."0.2.2"."OSX_10_10" or false); }
      { "${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_11" =
        (f.security_framework_sys."${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_11" or false) ||
        (security_framework."0.2.2"."OSX_10_11" or false) ||
        (f."security_framework"."0.2.2"."OSX_10_11" or false); }
      { "${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_12" =
        (f.security_framework_sys."${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_12" or false) ||
        (security_framework."0.2.2"."OSX_10_12" or false) ||
        (f."security_framework"."0.2.2"."OSX_10_12" or false); }
      { "${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_13" =
        (f.security_framework_sys."${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_13" or false) ||
        (security_framework."0.2.2"."OSX_10_13" or false) ||
        (f."security_framework"."0.2.2"."OSX_10_13" or false); }
      { "${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_9" =
        (f.security_framework_sys."${deps.security_framework."0.2.2".security_framework_sys}"."OSX_10_9" or false) ||
        (security_framework."0.2.2"."OSX_10_9" or false) ||
        (f."security_framework"."0.2.2"."OSX_10_9" or false); }
      { "${deps.security_framework."0.2.2".security_framework_sys}".default = true; }
    ];
  }) [
    (features_.core_foundation."${deps."security_framework"."0.2.2"."core_foundation"}" deps)
    (features_.core_foundation_sys."${deps."security_framework"."0.2.2"."core_foundation_sys"}" deps)
    (features_.libc."${deps."security_framework"."0.2.2"."libc"}" deps)
    (features_.security_framework_sys."${deps."security_framework"."0.2.2"."security_framework_sys"}" deps)
  ];


# end
# security-framework-sys-0.2.3

  crates.security_framework_sys."0.2.3" = deps: { features?(features_.security_framework_sys."0.2.3" deps {}) }: buildRustCrate {
    crateName = "security-framework-sys";
    version = "0.2.3";
    authors = [ "Steven Fackler <sfackler@gmail.com>" "Kornel <kornel@geekhood.net>" ];
    sha256 = "0j9v5gxn25fk24d1mcwdwgwm5b4ll0z4a33gkq4ajqdc97jazmr1";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."MacTypes_sys"."${deps."security_framework_sys"."0.2.3"."MacTypes_sys"}" deps)
      (crates."core_foundation_sys"."${deps."security_framework_sys"."0.2.3"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."security_framework_sys"."0.2.3"."libc"}" deps)
    ]);
    features = mkFeatures (features."security_framework_sys"."0.2.3" or {});
  };
  features_.security_framework_sys."0.2.3" = deps: f: updateFeatures f (rec {
    MacTypes_sys."${deps.security_framework_sys."0.2.3".MacTypes_sys}".default = true;
    core_foundation_sys."${deps.security_framework_sys."0.2.3".core_foundation_sys}".default = true;
    libc."${deps.security_framework_sys."0.2.3".libc}".default = true;
    security_framework_sys = fold recursiveUpdate {} [
      { "0.2.3".OSX_10_10 =
        (f.security_framework_sys."0.2.3".OSX_10_10 or false) ||
        (f.security_framework_sys."0.2.3".OSX_10_11 or false) ||
        (security_framework_sys."0.2.3"."OSX_10_11" or false); }
      { "0.2.3".OSX_10_11 =
        (f.security_framework_sys."0.2.3".OSX_10_11 or false) ||
        (f.security_framework_sys."0.2.3".OSX_10_12 or false) ||
        (security_framework_sys."0.2.3"."OSX_10_12" or false); }
      { "0.2.3".OSX_10_12 =
        (f.security_framework_sys."0.2.3".OSX_10_12 or false) ||
        (f.security_framework_sys."0.2.3".OSX_10_13 or false) ||
        (security_framework_sys."0.2.3"."OSX_10_13" or false); }
      { "0.2.3".OSX_10_9 =
        (f.security_framework_sys."0.2.3".OSX_10_9 or false) ||
        (f.security_framework_sys."0.2.3".OSX_10_10 or false) ||
        (security_framework_sys."0.2.3"."OSX_10_10" or false); }
      { "0.2.3".default = (f.security_framework_sys."0.2.3".default or true); }
    ];
  }) [
    (features_.MacTypes_sys."${deps."security_framework_sys"."0.2.3"."MacTypes_sys"}" deps)
    (features_.core_foundation_sys."${deps."security_framework_sys"."0.2.3"."core_foundation_sys"}" deps)
    (features_.libc."${deps."security_framework_sys"."0.2.3"."libc"}" deps)
  ];


# end
# semver-0.9.0

  crates.semver."0.9.0" = deps: { features?(features_.semver."0.9.0" deps {}) }: buildRustCrate {
    crateName = "semver";
    version = "0.9.0";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" "The Rust Project Developers" ];
    sha256 = "0azak2lb2wc36s3x15az886kck7rpnksrw14lalm157rg9sc9z63";
    dependencies = mapFeatures features ([
      (crates."semver_parser"."${deps."semver"."0.9.0"."semver_parser"}" deps)
    ]);
    features = mkFeatures (features."semver"."0.9.0" or {});
  };
  features_.semver."0.9.0" = deps: f: updateFeatures f (rec {
    semver = fold recursiveUpdate {} [
      { "0.9.0".default = (f.semver."0.9.0".default or true); }
      { "0.9.0".serde =
        (f.semver."0.9.0".serde or false) ||
        (f.semver."0.9.0".ci or false) ||
        (semver."0.9.0"."ci" or false); }
    ];
    semver_parser."${deps.semver."0.9.0".semver_parser}".default = true;
  }) [
    (features_.semver_parser."${deps."semver"."0.9.0"."semver_parser"}" deps)
  ];


# end
# semver-parser-0.7.0

  crates.semver_parser."0.7.0" = deps: { features?(features_.semver_parser."0.7.0" deps {}) }: buildRustCrate {
    crateName = "semver-parser";
    version = "0.7.0";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" ];
    sha256 = "1da66c8413yakx0y15k8c055yna5lyb6fr0fw9318kdwkrk5k12h";
  };
  features_.semver_parser."0.7.0" = deps: f: updateFeatures f (rec {
    semver_parser."0.7.0".default = (f.semver_parser."0.7.0".default or true);
  }) [];


# end
# sequoia-openpgp-0.4.1

  crates.sequoia_openpgp."0.4.1" = deps: { features?(features_.sequoia_openpgp."0.4.1" deps {}) }: buildRustCrate {
    crateName = "sequoia-openpgp";
    version = "0.4.1";
    authors = [ "Justus Winter <justus@sequoia-pgp.org>" "Kai Michaelis <kai@sequoia-pgp.org>" "Neal H. Walfield <neal@sequoia-pgp.org>" ];
    sha256 = "1z10n6h2wawsq076dqybaiby8ls07ln5kb8arn699s48x0rb9j5c";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."sequoia_openpgp"."0.4.1"."base64"}" deps)
      (crates."buffered_reader"."${deps."sequoia_openpgp"."0.4.1"."buffered_reader"}" deps)
      (crates."failure"."${deps."sequoia_openpgp"."0.4.1"."failure"}" deps)
      (crates."lalrpop_util"."${deps."sequoia_openpgp"."0.4.1"."lalrpop_util"}" deps)
      (crates."memsec"."${deps."sequoia_openpgp"."0.4.1"."memsec"}" deps)
      (crates."nettle"."${deps."sequoia_openpgp"."0.4.1"."nettle"}" deps)
      (crates."quickcheck"."${deps."sequoia_openpgp"."0.4.1"."quickcheck"}" deps)
      (crates."rand"."${deps."sequoia_openpgp"."0.4.1"."rand"}" deps)
      (crates."time"."${deps."sequoia_openpgp"."0.4.1"."time"}" deps)
    ]
      ++ (if features.sequoia_openpgp."0.4.1".bzip2 or false then [ (crates.bzip2."${deps."sequoia_openpgp"."0.4.1".bzip2}" deps) ] else [])
      ++ (if features.sequoia_openpgp."0.4.1".flate2 or false then [ (crates.flate2."${deps."sequoia_openpgp"."0.4.1".flate2}" deps) ] else []));

    buildDependencies = mapFeatures features ([
      (crates."lalrpop"."${deps."sequoia_openpgp"."0.4.1"."lalrpop"}" deps)
    ]);
    features = mkFeatures (features."sequoia_openpgp"."0.4.1" or {});
  };
  features_.sequoia_openpgp."0.4.1" = deps: f: updateFeatures f (rec {
    base64."${deps.sequoia_openpgp."0.4.1".base64}".default = true;
    buffered_reader = fold recursiveUpdate {} [
      { "${deps.sequoia_openpgp."0.4.1".buffered_reader}"."compression-bzip2" =
        (f.buffered_reader."${deps.sequoia_openpgp."0.4.1".buffered_reader}"."compression-bzip2" or false) ||
        (sequoia_openpgp."0.4.1"."compression-bzip2" or false) ||
        (f."sequoia_openpgp"."0.4.1"."compression-bzip2" or false); }
      { "${deps.sequoia_openpgp."0.4.1".buffered_reader}"."compression-deflate" =
        (f.buffered_reader."${deps.sequoia_openpgp."0.4.1".buffered_reader}"."compression-deflate" or false) ||
        (sequoia_openpgp."0.4.1"."compression-deflate" or false) ||
        (f."sequoia_openpgp"."0.4.1"."compression-deflate" or false); }
      { "${deps.sequoia_openpgp."0.4.1".buffered_reader}".default = (f.buffered_reader."${deps.sequoia_openpgp."0.4.1".buffered_reader}".default or false); }
    ];
    bzip2."${deps.sequoia_openpgp."0.4.1".bzip2}".default = true;
    failure."${deps.sequoia_openpgp."0.4.1".failure}".default = true;
    flate2."${deps.sequoia_openpgp."0.4.1".flate2}".default = true;
    lalrpop."${deps.sequoia_openpgp."0.4.1".lalrpop}".default = true;
    lalrpop_util."${deps.sequoia_openpgp."0.4.1".lalrpop_util}".default = true;
    memsec."${deps.sequoia_openpgp."0.4.1".memsec}".default = true;
    nettle."${deps.sequoia_openpgp."0.4.1".nettle}".default = true;
    quickcheck."${deps.sequoia_openpgp."0.4.1".quickcheck}".default = true;
    rand."${deps.sequoia_openpgp."0.4.1".rand}".default = true;
    sequoia_openpgp = fold recursiveUpdate {} [
      { "0.4.1".bzip2 =
        (f.sequoia_openpgp."0.4.1".bzip2 or false) ||
        (f.sequoia_openpgp."0.4.1".compression-bzip2 or false) ||
        (sequoia_openpgp."0.4.1"."compression-bzip2" or false); }
      { "0.4.1".compression =
        (f.sequoia_openpgp."0.4.1".compression or false) ||
        (f.sequoia_openpgp."0.4.1".default or false) ||
        (sequoia_openpgp."0.4.1"."default" or false); }
      { "0.4.1".compression-bzip2 =
        (f.sequoia_openpgp."0.4.1".compression-bzip2 or false) ||
        (f.sequoia_openpgp."0.4.1".compression or false) ||
        (sequoia_openpgp."0.4.1"."compression" or false); }
      { "0.4.1".compression-deflate =
        (f.sequoia_openpgp."0.4.1".compression-deflate or false) ||
        (f.sequoia_openpgp."0.4.1".compression or false) ||
        (sequoia_openpgp."0.4.1"."compression" or false); }
      { "0.4.1".default = (f.sequoia_openpgp."0.4.1".default or true); }
      { "0.4.1".flate2 =
        (f.sequoia_openpgp."0.4.1".flate2 or false) ||
        (f.sequoia_openpgp."0.4.1".compression-deflate or false) ||
        (sequoia_openpgp."0.4.1"."compression-deflate" or false); }
    ];
    time."${deps.sequoia_openpgp."0.4.1".time}".default = true;
  }) [
    (features_.base64."${deps."sequoia_openpgp"."0.4.1"."base64"}" deps)
    (features_.buffered_reader."${deps."sequoia_openpgp"."0.4.1"."buffered_reader"}" deps)
    (features_.bzip2."${deps."sequoia_openpgp"."0.4.1"."bzip2"}" deps)
    (features_.failure."${deps."sequoia_openpgp"."0.4.1"."failure"}" deps)
    (features_.flate2."${deps."sequoia_openpgp"."0.4.1"."flate2"}" deps)
    (features_.lalrpop_util."${deps."sequoia_openpgp"."0.4.1"."lalrpop_util"}" deps)
    (features_.memsec."${deps."sequoia_openpgp"."0.4.1"."memsec"}" deps)
    (features_.nettle."${deps."sequoia_openpgp"."0.4.1"."nettle"}" deps)
    (features_.quickcheck."${deps."sequoia_openpgp"."0.4.1"."quickcheck"}" deps)
    (features_.rand."${deps."sequoia_openpgp"."0.4.1"."rand"}" deps)
    (features_.time."${deps."sequoia_openpgp"."0.4.1"."time"}" deps)
    (features_.lalrpop."${deps."sequoia_openpgp"."0.4.1"."lalrpop"}" deps)
  ];


# end
# serde-1.0.80

  crates.serde."1.0.80" = deps: { features?(features_.serde."1.0.80" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.80";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0vyciw2qhrws4hz87pfnsjdfzzdw2sclxqxq394g3a219a2rdcxz";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.80" or {});
  };
  features_.serde."1.0.80" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.80".default = (f.serde."1.0.80".default or true); }
      { "1.0.80".serde_derive =
        (f.serde."1.0.80".serde_derive or false) ||
        (f.serde."1.0.80".derive or false) ||
        (serde."1.0.80"."derive" or false); }
      { "1.0.80".std =
        (f.serde."1.0.80".std or false) ||
        (f.serde."1.0.80".default or false) ||
        (serde."1.0.80"."default" or false); }
      { "1.0.80".unstable =
        (f.serde."1.0.80".unstable or false) ||
        (f.serde."1.0.80".alloc or false) ||
        (serde."1.0.80"."alloc" or false); }
    ];
  }) [];


# end
# serde-1.0.84

  crates.serde."1.0.84" = deps: { features?(features_.serde."1.0.84" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.84";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1x40cvvkbkz592jflwbfbxhim3wxdqp9dy0qxjw13ra7q57b29gy";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.84" or {});
  };
  features_.serde."1.0.84" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.84".default = (f.serde."1.0.84".default or true); }
      { "1.0.84".serde_derive =
        (f.serde."1.0.84".serde_derive or false) ||
        (f.serde."1.0.84".derive or false) ||
        (serde."1.0.84"."derive" or false); }
      { "1.0.84".std =
        (f.serde."1.0.84".std or false) ||
        (f.serde."1.0.84".default or false) ||
        (serde."1.0.84"."default" or false); }
      { "1.0.84".unstable =
        (f.serde."1.0.84".unstable or false) ||
        (f.serde."1.0.84".alloc or false) ||
        (serde."1.0.84"."alloc" or false); }
    ];
  }) [];


# end
# serde-1.0.89

  crates.serde."1.0.89" = deps: { features?(features_.serde."1.0.89" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.89";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "14pidc6skkm92vhp431wi1aam5vv5g6rmsimik38wzb0qy72c71g";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.89" or {});
  };
  features_.serde."1.0.89" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.89".default = (f.serde."1.0.89".default or true); }
      { "1.0.89".serde_derive =
        (f.serde."1.0.89".serde_derive or false) ||
        (f.serde."1.0.89".derive or false) ||
        (serde."1.0.89"."derive" or false); }
      { "1.0.89".std =
        (f.serde."1.0.89".std or false) ||
        (f.serde."1.0.89".default or false) ||
        (serde."1.0.89"."default" or false); }
      { "1.0.89".unstable =
        (f.serde."1.0.89".unstable or false) ||
        (f.serde."1.0.89".alloc or false) ||
        (serde."1.0.89"."alloc" or false); }
    ];
  }) [];


# end
# serde_derive-1.0.80

  crates.serde_derive."1.0.80" = deps: { features?(features_.serde_derive."1.0.80" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.80";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1akvzhbnnqhd92lfj7vp43scs1vdml7x27c82l5yh0kz7xf7jaky";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.80"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.80"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.80"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.80" or {});
  };
  features_.serde_derive."1.0.80" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.80".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.80".quote}".default = true;
    serde_derive."1.0.80".default = (f.serde_derive."1.0.80".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.80".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.80".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.80"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.80"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.80"."syn"}" deps)
  ];


# end
# serde_derive-1.0.89

  crates.serde_derive."1.0.89" = deps: { features?(features_.serde_derive."1.0.89" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.89";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0wxbxq9sccrd939pfnrgfzykkwl9gag2yf7vxhg2c2p9kx36d3wm";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.89"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.89"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.89"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.89" or {});
  };
  features_.serde_derive."1.0.89" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.89".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.89".quote}".default = true;
    serde_derive."1.0.89".default = (f.serde_derive."1.0.89".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.89".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.89".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.89"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.89"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.89"."syn"}" deps)
  ];


# end
# serde_json-1.0.32

  crates.serde_json."1.0.32" = deps: { features?(features_.serde_json."1.0.32" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.32";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1dqkvizi02j1bs5c21kw20idf4aa5399g29ndwl6vkmmrqkr1gr0";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.32"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.32"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.32"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.32" or {});
  };
  features_.serde_json."1.0.32" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.32".itoa}".default = true;
    ryu."${deps.serde_json."1.0.32".ryu}".default = true;
    serde."${deps.serde_json."1.0.32".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.32".default = (f.serde_json."1.0.32".default or true); }
      { "1.0.32".indexmap =
        (f.serde_json."1.0.32".indexmap or false) ||
        (f.serde_json."1.0.32".preserve_order or false) ||
        (serde_json."1.0.32"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.32"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.32"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.32"."serde"}" deps)
  ];


# end
# serde_json-1.0.39

  crates.serde_json."1.0.39" = deps: { features?(features_.serde_json."1.0.39" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.39";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "07ydv06hn8x0yl0rc94l2wl9r2xz1fqd97n1s6j3bgdc6gw406a8";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.39"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.39"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.39"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.39" or {});
  };
  features_.serde_json."1.0.39" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.39".itoa}".default = true;
    ryu."${deps.serde_json."1.0.39".ryu}".default = true;
    serde."${deps.serde_json."1.0.39".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.39".default = (f.serde_json."1.0.39".default or true); }
      { "1.0.39".indexmap =
        (f.serde_json."1.0.39".indexmap or false) ||
        (f.serde_json."1.0.39".preserve_order or false) ||
        (serde_json."1.0.39"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.39"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.39"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.39"."serde"}" deps)
  ];


# end
# serde_urlencoded-0.5.4

  crates.serde_urlencoded."0.5.4" = deps: { features?(features_.serde_urlencoded."0.5.4" deps {}) }: buildRustCrate {
    crateName = "serde_urlencoded";
    version = "0.5.4";
    authors = [ "Anthony Ramine <n.oxyde@gmail.com>" ];
    sha256 = "01dbyyr73ilyz3yqfmalhxs9zpsqvfvzj977199lh5v9j7dwh6cc";
    dependencies = mapFeatures features ([
      (crates."dtoa"."${deps."serde_urlencoded"."0.5.4"."dtoa"}" deps)
      (crates."itoa"."${deps."serde_urlencoded"."0.5.4"."itoa"}" deps)
      (crates."serde"."${deps."serde_urlencoded"."0.5.4"."serde"}" deps)
      (crates."url"."${deps."serde_urlencoded"."0.5.4"."url"}" deps)
    ]);
  };
  features_.serde_urlencoded."0.5.4" = deps: f: updateFeatures f (rec {
    dtoa."${deps.serde_urlencoded."0.5.4".dtoa}".default = true;
    itoa."${deps.serde_urlencoded."0.5.4".itoa}".default = true;
    serde."${deps.serde_urlencoded."0.5.4".serde}".default = true;
    serde_urlencoded."0.5.4".default = (f.serde_urlencoded."0.5.4".default or true);
    url."${deps.serde_urlencoded."0.5.4".url}".default = true;
  }) [
    (features_.dtoa."${deps."serde_urlencoded"."0.5.4"."dtoa"}" deps)
    (features_.itoa."${deps."serde_urlencoded"."0.5.4"."itoa"}" deps)
    (features_.serde."${deps."serde_urlencoded"."0.5.4"."serde"}" deps)
    (features_.url."${deps."serde_urlencoded"."0.5.4"."url"}" deps)
  ];


# end
# sha2-0.7.1

  crates.sha2."0.7.1" = deps: { features?(features_.sha2."0.7.1" deps {}) }: buildRustCrate {
    crateName = "sha2";
    version = "0.7.1";
    authors = [ "RustCrypto Developers" ];
    sha256 = "1x5034qjkk6l3q5anlffh46jb4rlyyiwigwlxrnw7d6ijxpygfzb";
    dependencies = mapFeatures features ([
      (crates."block_buffer"."${deps."sha2"."0.7.1"."block_buffer"}" deps)
      (crates."byte_tools"."${deps."sha2"."0.7.1"."byte_tools"}" deps)
      (crates."digest"."${deps."sha2"."0.7.1"."digest"}" deps)
      (crates."fake_simd"."${deps."sha2"."0.7.1"."fake_simd"}" deps)
    ]);
    features = mkFeatures (features."sha2"."0.7.1" or {});
  };
  features_.sha2."0.7.1" = deps: f: updateFeatures f (rec {
    block_buffer."${deps.sha2."0.7.1".block_buffer}".default = true;
    byte_tools."${deps.sha2."0.7.1".byte_tools}".default = true;
    digest."${deps.sha2."0.7.1".digest}".default = true;
    fake_simd."${deps.sha2."0.7.1".fake_simd}".default = true;
    sha2 = fold recursiveUpdate {} [
      { "0.7.1".default = (f.sha2."0.7.1".default or true); }
      { "0.7.1".sha2-asm =
        (f.sha2."0.7.1".sha2-asm or false) ||
        (f.sha2."0.7.1".asm or false) ||
        (sha2."0.7.1"."asm" or false); }
    ];
  }) [
    (features_.block_buffer."${deps."sha2"."0.7.1"."block_buffer"}" deps)
    (features_.byte_tools."${deps."sha2"."0.7.1"."byte_tools"}" deps)
    (features_.digest."${deps."sha2"."0.7.1"."digest"}" deps)
    (features_.fake_simd."${deps."sha2"."0.7.1"."fake_simd"}" deps)
  ];


# end
# sha2-0.8.0

  crates.sha2."0.8.0" = deps: { features?(features_.sha2."0.8.0" deps {}) }: buildRustCrate {
    crateName = "sha2";
    version = "0.8.0";
    authors = [ "RustCrypto Developers" ];
    sha256 = "0jhg56v7m6mj3jb857np4qvr72146garnabcgdk368fm0csfs1sq";
    dependencies = mapFeatures features ([
      (crates."block_buffer"."${deps."sha2"."0.8.0"."block_buffer"}" deps)
      (crates."digest"."${deps."sha2"."0.8.0"."digest"}" deps)
      (crates."fake_simd"."${deps."sha2"."0.8.0"."fake_simd"}" deps)
      (crates."opaque_debug"."${deps."sha2"."0.8.0"."opaque_debug"}" deps)
    ]);
    features = mkFeatures (features."sha2"."0.8.0" or {});
  };
  features_.sha2."0.8.0" = deps: f: updateFeatures f (rec {
    block_buffer."${deps.sha2."0.8.0".block_buffer}".default = true;
    digest = fold recursiveUpdate {} [
      { "${deps.sha2."0.8.0".digest}"."std" =
        (f.digest."${deps.sha2."0.8.0".digest}"."std" or false) ||
        (sha2."0.8.0"."std" or false) ||
        (f."sha2"."0.8.0"."std" or false); }
      { "${deps.sha2."0.8.0".digest}".default = true; }
    ];
    fake_simd."${deps.sha2."0.8.0".fake_simd}".default = true;
    opaque_debug."${deps.sha2."0.8.0".opaque_debug}".default = true;
    sha2 = fold recursiveUpdate {} [
      { "0.8.0".default = (f.sha2."0.8.0".default or true); }
      { "0.8.0".sha2-asm =
        (f.sha2."0.8.0".sha2-asm or false) ||
        (f.sha2."0.8.0".asm or false) ||
        (sha2."0.8.0"."asm" or false); }
      { "0.8.0".std =
        (f.sha2."0.8.0".std or false) ||
        (f.sha2."0.8.0".default or false) ||
        (sha2."0.8.0"."default" or false); }
    ];
  }) [
    (features_.block_buffer."${deps."sha2"."0.8.0"."block_buffer"}" deps)
    (features_.digest."${deps."sha2"."0.8.0"."digest"}" deps)
    (features_.fake_simd."${deps."sha2"."0.8.0"."fake_simd"}" deps)
    (features_.opaque_debug."${deps."sha2"."0.8.0"."opaque_debug"}" deps)
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
# slab-0.4.2

  crates.slab."0.4.2" = deps: { features?(features_.slab."0.4.2" deps {}) }: buildRustCrate {
    crateName = "slab";
    version = "0.4.2";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0h1l2z7qy6207kv0v3iigdf2xfk9yrhbwj1svlxk6wxjmdxvgdl7";
  };
  features_.slab."0.4.2" = deps: f: updateFeatures f (rec {
    slab."0.4.2".default = (f.slab."0.4.2".default or true);
  }) [];


# end
# smallvec-0.6.9

  crates.smallvec."0.6.9" = deps: { features?(features_.smallvec."0.6.9" deps {}) }: buildRustCrate {
    crateName = "smallvec";
    version = "0.6.9";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "0p96l51a2pq5y0vn48nhbm6qslbc6k8h28cxm0pmzkqmj7xynz6w";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."smallvec"."0.6.9" or {});
  };
  features_.smallvec."0.6.9" = deps: f: updateFeatures f (rec {
    smallvec = fold recursiveUpdate {} [
      { "0.6.9".default = (f.smallvec."0.6.9".default or true); }
      { "0.6.9".std =
        (f.smallvec."0.6.9".std or false) ||
        (f.smallvec."0.6.9".default or false) ||
        (smallvec."0.6.9"."default" or false); }
    ];
  }) [];


# end
# stable_deref_trait-1.1.1

  crates.stable_deref_trait."1.1.1" = deps: { features?(features_.stable_deref_trait."1.1.1" deps {}) }: buildRustCrate {
    crateName = "stable_deref_trait";
    version = "1.1.1";
    authors = [ "Robert Grosse <n210241048576@gmail.com>" ];
    sha256 = "1xy9slzslrzr31nlnw52sl1d820b09y61b7f13lqgsn8n7y0l4g8";
    features = mkFeatures (features."stable_deref_trait"."1.1.1" or {});
  };
  features_.stable_deref_trait."1.1.1" = deps: f: updateFeatures f (rec {
    stable_deref_trait = fold recursiveUpdate {} [
      { "1.1.1".default = (f.stable_deref_trait."1.1.1".default or true); }
      { "1.1.1".std =
        (f.stable_deref_trait."1.1.1".std or false) ||
        (f.stable_deref_trait."1.1.1".default or false) ||
        (stable_deref_trait."1.1.1"."default" or false); }
    ];
  }) [];


# end
# string-0.1.3

  crates.string."0.1.3" = deps: { features?(features_.string."0.1.3" deps {}) }: buildRustCrate {
    crateName = "string";
    version = "0.1.3";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "03hr559lsxf13i1p5r2zd7m3ppqlbhqajbx80adi3cpp2rwnsvfw";
  };
  features_.string."0.1.3" = deps: f: updateFeatures f (rec {
    string."0.1.3".default = (f.string."0.1.3".default or true);
  }) [];


# end
# string_cache-0.7.3

  crates.string_cache."0.7.3" = deps: { features?(features_.string_cache."0.7.3" deps {}) }: buildRustCrate {
    crateName = "string_cache";
    version = "0.7.3";
    authors = [ "The Servo Project Developers" ];
    sha256 = "1z2995v9m7cbz84b8bwpz25xgskq1a7kzsv467zn6fm5gdj8jzh0";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."string_cache"."0.7.3"."lazy_static"}" deps)
      (crates."new_debug_unreachable"."${deps."string_cache"."0.7.3"."new_debug_unreachable"}" deps)
      (crates."phf_shared"."${deps."string_cache"."0.7.3"."phf_shared"}" deps)
      (crates."precomputed_hash"."${deps."string_cache"."0.7.3"."precomputed_hash"}" deps)
      (crates."serde"."${deps."string_cache"."0.7.3"."serde"}" deps)
      (crates."string_cache_shared"."${deps."string_cache"."0.7.3"."string_cache_shared"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."string_cache_codegen"."${deps."string_cache"."0.7.3"."string_cache_codegen"}" deps)
    ]);
    features = mkFeatures (features."string_cache"."0.7.3" or {});
  };
  features_.string_cache."0.7.3" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.string_cache."0.7.3".lazy_static}".default = true;
    new_debug_unreachable."${deps.string_cache."0.7.3".new_debug_unreachable}".default = true;
    phf_shared."${deps.string_cache."0.7.3".phf_shared}".default = true;
    precomputed_hash."${deps.string_cache."0.7.3".precomputed_hash}".default = true;
    serde."${deps.string_cache."0.7.3".serde}".default = true;
    string_cache."0.7.3".default = (f.string_cache."0.7.3".default or true);
    string_cache_codegen."${deps.string_cache."0.7.3".string_cache_codegen}".default = true;
    string_cache_shared."${deps.string_cache."0.7.3".string_cache_shared}".default = true;
  }) [
    (features_.lazy_static."${deps."string_cache"."0.7.3"."lazy_static"}" deps)
    (features_.new_debug_unreachable."${deps."string_cache"."0.7.3"."new_debug_unreachable"}" deps)
    (features_.phf_shared."${deps."string_cache"."0.7.3"."phf_shared"}" deps)
    (features_.precomputed_hash."${deps."string_cache"."0.7.3"."precomputed_hash"}" deps)
    (features_.serde."${deps."string_cache"."0.7.3"."serde"}" deps)
    (features_.string_cache_shared."${deps."string_cache"."0.7.3"."string_cache_shared"}" deps)
    (features_.string_cache_codegen."${deps."string_cache"."0.7.3"."string_cache_codegen"}" deps)
  ];


# end
# string_cache_codegen-0.4.2

  crates.string_cache_codegen."0.4.2" = deps: { features?(features_.string_cache_codegen."0.4.2" deps {}) }: buildRustCrate {
    crateName = "string_cache_codegen";
    version = "0.4.2";
    authors = [ "The Servo Project Developers" ];
    sha256 = "1y4fmlxqilijdvbsfr2z98paggfj9fpsyaq50v0p0vd9755z791i";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."phf_generator"."${deps."string_cache_codegen"."0.4.2"."phf_generator"}" deps)
      (crates."phf_shared"."${deps."string_cache_codegen"."0.4.2"."phf_shared"}" deps)
      (crates."proc_macro2"."${deps."string_cache_codegen"."0.4.2"."proc_macro2"}" deps)
      (crates."quote"."${deps."string_cache_codegen"."0.4.2"."quote"}" deps)
      (crates."string_cache_shared"."${deps."string_cache_codegen"."0.4.2"."string_cache_shared"}" deps)
    ]);
  };
  features_.string_cache_codegen."0.4.2" = deps: f: updateFeatures f (rec {
    phf_generator."${deps.string_cache_codegen."0.4.2".phf_generator}".default = true;
    phf_shared."${deps.string_cache_codegen."0.4.2".phf_shared}".default = true;
    proc_macro2."${deps.string_cache_codegen."0.4.2".proc_macro2}".default = true;
    quote."${deps.string_cache_codegen."0.4.2".quote}".default = true;
    string_cache_codegen."0.4.2".default = (f.string_cache_codegen."0.4.2".default or true);
    string_cache_shared."${deps.string_cache_codegen."0.4.2".string_cache_shared}".default = true;
  }) [
    (features_.phf_generator."${deps."string_cache_codegen"."0.4.2"."phf_generator"}" deps)
    (features_.phf_shared."${deps."string_cache_codegen"."0.4.2"."phf_shared"}" deps)
    (features_.proc_macro2."${deps."string_cache_codegen"."0.4.2"."proc_macro2"}" deps)
    (features_.quote."${deps."string_cache_codegen"."0.4.2"."quote"}" deps)
    (features_.string_cache_shared."${deps."string_cache_codegen"."0.4.2"."string_cache_shared"}" deps)
  ];


# end
# string_cache_shared-0.3.0

  crates.string_cache_shared."0.3.0" = deps: { features?(features_.string_cache_shared."0.3.0" deps {}) }: buildRustCrate {
    crateName = "string_cache_shared";
    version = "0.3.0";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0yc59f5npg4ip56aha03yzc7nxgl7c31hv6kq7zrx7rvs3h1cb8j";
    libPath = "lib.rs";
  };
  features_.string_cache_shared."0.3.0" = deps: f: updateFeatures f (rec {
    string_cache_shared."0.3.0".default = (f.string_cache_shared."0.3.0".default or true);
  }) [];


# end
# strsim-0.7.0

  crates.strsim."0.7.0" = deps: { features?(features_.strsim."0.7.0" deps {}) }: buildRustCrate {
    crateName = "strsim";
    version = "0.7.0";
    authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
    sha256 = "0fy0k5f2705z73mb3x9459bpcvrx4ky8jpr4zikcbiwan4bnm0iv";
  };
  features_.strsim."0.7.0" = deps: f: updateFeatures f (rec {
    strsim."0.7.0".default = (f.strsim."0.7.0".default or true);
  }) [];


# end
# syn-0.11.11

  crates.syn."0.11.11" = deps: { features?(features_.syn."0.11.11" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.11.11";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0yw8ng7x1dn5a6ykg0ib49y7r9nhzgpiq2989rqdp7rdz3n85502";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.syn."0.11.11".quote or false then [ (crates.quote."${deps."syn"."0.11.11".quote}" deps) ] else [])
      ++ (if features.syn."0.11.11".synom or false then [ (crates.synom."${deps."syn"."0.11.11".synom}" deps) ] else [])
      ++ (if features.syn."0.11.11".unicode-xid or false then [ (crates.unicode_xid."${deps."syn"."0.11.11".unicode_xid}" deps) ] else []));
    features = mkFeatures (features."syn"."0.11.11" or {});
  };
  features_.syn."0.11.11" = deps: f: updateFeatures f (rec {
    quote."${deps.syn."0.11.11".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "0.11.11".default = (f.syn."0.11.11".default or true); }
      { "0.11.11".parsing =
        (f.syn."0.11.11".parsing or false) ||
        (f.syn."0.11.11".default or false) ||
        (syn."0.11.11"."default" or false); }
      { "0.11.11".printing =
        (f.syn."0.11.11".printing or false) ||
        (f.syn."0.11.11".default or false) ||
        (syn."0.11.11"."default" or false); }
      { "0.11.11".quote =
        (f.syn."0.11.11".quote or false) ||
        (f.syn."0.11.11".printing or false) ||
        (syn."0.11.11"."printing" or false); }
      { "0.11.11".synom =
        (f.syn."0.11.11".synom or false) ||
        (f.syn."0.11.11".parsing or false) ||
        (syn."0.11.11"."parsing" or false); }
      { "0.11.11".unicode-xid =
        (f.syn."0.11.11".unicode-xid or false) ||
        (f.syn."0.11.11".parsing or false) ||
        (syn."0.11.11"."parsing" or false); }
    ];
    synom."${deps.syn."0.11.11".synom}".default = true;
    unicode_xid."${deps.syn."0.11.11".unicode_xid}".default = true;
  }) [
    (features_.quote."${deps."syn"."0.11.11"."quote"}" deps)
    (features_.synom."${deps."syn"."0.11.11"."synom"}" deps)
    (features_.unicode_xid."${deps."syn"."0.11.11"."unicode_xid"}" deps)
  ];


# end
# syn-0.15.13

  crates.syn."0.15.13" = deps: { features?(features_.syn."0.15.13" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.13";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1zvnppl08f2njpkl3m10h221sdl4vsm7v6vyq63dxk16nn37b1bh";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.13"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.13"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.13".quote or false then [ (crates.quote."${deps."syn"."0.15.13".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.13" or {});
  };
  features_.syn."0.15.13" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.13".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.13".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.13"."proc-macro" or false) ||
        (f."syn"."0.15.13"."proc-macro" or false); }
      { "${deps.syn."0.15.13".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.13".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.13".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.13".quote}"."proc-macro" or false) ||
        (syn."0.15.13"."proc-macro" or false) ||
        (f."syn"."0.15.13"."proc-macro" or false); }
      { "${deps.syn."0.15.13".quote}".default = (f.quote."${deps.syn."0.15.13".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.13".clone-impls =
        (f.syn."0.15.13".clone-impls or false) ||
        (f.syn."0.15.13".default or false) ||
        (syn."0.15.13"."default" or false); }
      { "0.15.13".default = (f.syn."0.15.13".default or true); }
      { "0.15.13".derive =
        (f.syn."0.15.13".derive or false) ||
        (f.syn."0.15.13".default or false) ||
        (syn."0.15.13"."default" or false); }
      { "0.15.13".parsing =
        (f.syn."0.15.13".parsing or false) ||
        (f.syn."0.15.13".default or false) ||
        (syn."0.15.13"."default" or false); }
      { "0.15.13".printing =
        (f.syn."0.15.13".printing or false) ||
        (f.syn."0.15.13".default or false) ||
        (syn."0.15.13"."default" or false); }
      { "0.15.13".proc-macro =
        (f.syn."0.15.13".proc-macro or false) ||
        (f.syn."0.15.13".default or false) ||
        (syn."0.15.13"."default" or false); }
      { "0.15.13".quote =
        (f.syn."0.15.13".quote or false) ||
        (f.syn."0.15.13".printing or false) ||
        (syn."0.15.13"."printing" or false); }
    ];
    unicode_xid."${deps.syn."0.15.13".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.13"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.13"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.13"."unicode_xid"}" deps)
  ];


# end
# syn-0.15.29

  crates.syn."0.15.29" = deps: { features?(features_.syn."0.15.29" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.29";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0wrd6awgc6f1iwfn2v9fvwyd2yddgxdjv9s106kvwg1ljbw3fajw";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.29"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.29"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.29".quote or false then [ (crates.quote."${deps."syn"."0.15.29".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.29" or {});
  };
  features_.syn."0.15.29" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.29".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.29".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.29"."proc-macro" or false) ||
        (f."syn"."0.15.29"."proc-macro" or false); }
      { "${deps.syn."0.15.29".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.29".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.29".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.29".quote}"."proc-macro" or false) ||
        (syn."0.15.29"."proc-macro" or false) ||
        (f."syn"."0.15.29"."proc-macro" or false); }
      { "${deps.syn."0.15.29".quote}".default = (f.quote."${deps.syn."0.15.29".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.29".clone-impls =
        (f.syn."0.15.29".clone-impls or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".default = (f.syn."0.15.29".default or true); }
      { "0.15.29".derive =
        (f.syn."0.15.29".derive or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".parsing =
        (f.syn."0.15.29".parsing or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".printing =
        (f.syn."0.15.29".printing or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".proc-macro =
        (f.syn."0.15.29".proc-macro or false) ||
        (f.syn."0.15.29".default or false) ||
        (syn."0.15.29"."default" or false); }
      { "0.15.29".quote =
        (f.syn."0.15.29".quote or false) ||
        (f.syn."0.15.29".printing or false) ||
        (syn."0.15.29"."printing" or false); }
    ];
    unicode_xid."${deps.syn."0.15.29".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.29"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.29"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.29"."unicode_xid"}" deps)
  ];


# end
# synom-0.11.3

  crates.synom."0.11.3" = deps: { features?(features_.synom."0.11.3" deps {}) }: buildRustCrate {
    crateName = "synom";
    version = "0.11.3";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1l6d1s9qjfp6ng2s2z8219igvlv7gyk8gby97sdykqc1r93d8rhc";
    dependencies = mapFeatures features ([
      (crates."unicode_xid"."${deps."synom"."0.11.3"."unicode_xid"}" deps)
    ]);
  };
  features_.synom."0.11.3" = deps: f: updateFeatures f (rec {
    synom."0.11.3".default = (f.synom."0.11.3".default or true);
    unicode_xid."${deps.synom."0.11.3".unicode_xid}".default = true;
  }) [
    (features_.unicode_xid."${deps."synom"."0.11.3"."unicode_xid"}" deps)
  ];


# end
# synstructure-0.10.0

  crates.synstructure."0.10.0" = deps: { features?(features_.synstructure."0.10.0" deps {}) }: buildRustCrate {
    crateName = "synstructure";
    version = "0.10.0";
    authors = [ "Nika Layzell <nika@thelayzells.com>" ];
    sha256 = "1alb4hsbm5qf4jy7nmdkqrh3jagqk1xj88w0pmz67f16dvgpf0qf";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."synstructure"."0.10.0"."proc_macro2"}" deps)
      (crates."quote"."${deps."synstructure"."0.10.0"."quote"}" deps)
      (crates."syn"."${deps."synstructure"."0.10.0"."syn"}" deps)
      (crates."unicode_xid"."${deps."synstructure"."0.10.0"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."synstructure"."0.10.0" or {});
  };
  features_.synstructure."0.10.0" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.synstructure."0.10.0".proc_macro2}".default = true;
    quote."${deps.synstructure."0.10.0".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.synstructure."0.10.0".syn}"."extra-traits" = true; }
      { "${deps.synstructure."0.10.0".syn}"."visit" = true; }
      { "${deps.synstructure."0.10.0".syn}".default = true; }
    ];
    synstructure."0.10.0".default = (f.synstructure."0.10.0".default or true);
    unicode_xid."${deps.synstructure."0.10.0".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."synstructure"."0.10.0"."proc_macro2"}" deps)
    (features_.quote."${deps."synstructure"."0.10.0"."quote"}" deps)
    (features_.syn."${deps."synstructure"."0.10.0"."syn"}" deps)
    (features_.unicode_xid."${deps."synstructure"."0.10.0"."unicode_xid"}" deps)
  ];


# end
# synstructure-0.10.1

  crates.synstructure."0.10.1" = deps: { features?(features_.synstructure."0.10.1" deps {}) }: buildRustCrate {
    crateName = "synstructure";
    version = "0.10.1";
    authors = [ "Nika Layzell <nika@thelayzells.com>" ];
    sha256 = "0mx2vwd0d0f7hanz15nkp0ikkfjsx9rfkph7pynxyfbj45ank4g3";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."synstructure"."0.10.1"."proc_macro2"}" deps)
      (crates."quote"."${deps."synstructure"."0.10.1"."quote"}" deps)
      (crates."syn"."${deps."synstructure"."0.10.1"."syn"}" deps)
      (crates."unicode_xid"."${deps."synstructure"."0.10.1"."unicode_xid"}" deps)
    ]);
    features = mkFeatures (features."synstructure"."0.10.1" or {});
  };
  features_.synstructure."0.10.1" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.synstructure."0.10.1".proc_macro2}".default = true;
    quote."${deps.synstructure."0.10.1".quote}".default = true;
    syn = fold recursiveUpdate {} [
      { "${deps.synstructure."0.10.1".syn}"."extra-traits" = true; }
      { "${deps.synstructure."0.10.1".syn}"."visit" = true; }
      { "${deps.synstructure."0.10.1".syn}".default = true; }
    ];
    synstructure."0.10.1".default = (f.synstructure."0.10.1".default or true);
    unicode_xid."${deps.synstructure."0.10.1".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."synstructure"."0.10.1"."proc_macro2"}" deps)
    (features_.quote."${deps."synstructure"."0.10.1"."quote"}" deps)
    (features_.syn."${deps."synstructure"."0.10.1"."syn"}" deps)
    (features_.unicode_xid."${deps."synstructure"."0.10.1"."unicode_xid"}" deps)
  ];


# end
# tempdir-0.3.7

  crates.tempdir."0.3.7" = deps: { features?(features_.tempdir."0.3.7" deps {}) }: buildRustCrate {
    crateName = "tempdir";
    version = "0.3.7";
    authors = [ "The Rust Project Developers" ];
    sha256 = "0y53sxybyljrr7lh0x0ysrsa7p7cljmwv9v80acy3rc6n97g67vy";
    dependencies = mapFeatures features ([
      (crates."rand"."${deps."tempdir"."0.3.7"."rand"}" deps)
      (crates."remove_dir_all"."${deps."tempdir"."0.3.7"."remove_dir_all"}" deps)
    ]);
  };
  features_.tempdir."0.3.7" = deps: f: updateFeatures f (rec {
    rand."${deps.tempdir."0.3.7".rand}".default = true;
    remove_dir_all."${deps.tempdir."0.3.7".remove_dir_all}".default = true;
    tempdir."0.3.7".default = (f.tempdir."0.3.7".default or true);
  }) [
    (features_.rand."${deps."tempdir"."0.3.7"."rand"}" deps)
    (features_.remove_dir_all."${deps."tempdir"."0.3.7"."remove_dir_all"}" deps)
  ];


# end
# tempfile-3.0.7

  crates.tempfile."3.0.7" = deps: { features?(features_.tempfile."3.0.7" deps {}) }: buildRustCrate {
    crateName = "tempfile";
    version = "3.0.7";
    authors = [ "Steven Allen <steven@stebalien.com>" "The Rust Project Developers" "Ashley Mannix <ashleymannix@live.com.au>" "Jason White <jasonaw0@gmail.com>" ];
    sha256 = "19h7ch8fvisxrrmabcnhlfj6b8vg34zaw8491x141p0n0727niaf";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."tempfile"."3.0.7"."cfg_if"}" deps)
      (crates."rand"."${deps."tempfile"."3.0.7"."rand"}" deps)
      (crates."remove_dir_all"."${deps."tempfile"."3.0.7"."remove_dir_all"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."tempfile"."3.0.7"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."tempfile"."3.0.7"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."tempfile"."3.0.7"."winapi"}" deps)
    ]) else []);
  };
  features_.tempfile."3.0.7" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.tempfile."3.0.7".cfg_if}".default = true;
    libc."${deps.tempfile."3.0.7".libc}".default = true;
    rand."${deps.tempfile."3.0.7".rand}".default = true;
    redox_syscall."${deps.tempfile."3.0.7".redox_syscall}".default = true;
    remove_dir_all."${deps.tempfile."3.0.7".remove_dir_all}".default = true;
    tempfile."3.0.7".default = (f.tempfile."3.0.7".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.tempfile."3.0.7".winapi}"."fileapi" = true; }
      { "${deps.tempfile."3.0.7".winapi}"."handleapi" = true; }
      { "${deps.tempfile."3.0.7".winapi}"."winbase" = true; }
      { "${deps.tempfile."3.0.7".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."tempfile"."3.0.7"."cfg_if"}" deps)
    (features_.rand."${deps."tempfile"."3.0.7"."rand"}" deps)
    (features_.remove_dir_all."${deps."tempfile"."3.0.7"."remove_dir_all"}" deps)
    (features_.redox_syscall."${deps."tempfile"."3.0.7"."redox_syscall"}" deps)
    (features_.libc."${deps."tempfile"."3.0.7"."libc"}" deps)
    (features_.winapi."${deps."tempfile"."3.0.7"."winapi"}" deps)
  ];


# end
# tendril-0.4.1

  crates.tendril."0.4.1" = deps: { features?(features_.tendril."0.4.1" deps {}) }: buildRustCrate {
    crateName = "tendril";
    version = "0.4.1";
    authors = [ "Keegan McAllister <mcallister.keegan@gmail.com>" "Simon Sapin <simon.sapin@exyr.org>" "Chris Morgan <me@chrismorgan.info>" ];
    sha256 = "02k6iwlyqd3xvjvi50l6n5yspmcf4rkhs6b49h3a1d6kr4ydmydm";
    dependencies = mapFeatures features ([
      (crates."futf"."${deps."tendril"."0.4.1"."futf"}" deps)
      (crates."mac"."${deps."tendril"."0.4.1"."mac"}" deps)
      (crates."utf_8"."${deps."tendril"."0.4.1"."utf_8"}" deps)
    ]);
    features = mkFeatures (features."tendril"."0.4.1" or {});
  };
  features_.tendril."0.4.1" = deps: f: updateFeatures f (rec {
    futf."${deps.tendril."0.4.1".futf}".default = true;
    mac."${deps.tendril."0.4.1".mac}".default = true;
    tendril."0.4.1".default = (f.tendril."0.4.1".default or true);
    utf_8."${deps.tendril."0.4.1".utf_8}".default = true;
  }) [
    (features_.futf."${deps."tendril"."0.4.1"."futf"}" deps)
    (features_.mac."${deps."tendril"."0.4.1"."mac"}" deps)
    (features_.utf_8."${deps."tendril"."0.4.1"."utf_8"}" deps)
  ];


# end
# term-0.4.6

  crates.term."0.4.6" = deps: { features?(features_.term."0.4.6" deps {}) }: buildRustCrate {
    crateName = "term";
    version = "0.4.6";
    authors = [ "The Rust Project Developers" "Steven Allen" ];
    sha256 = "14fll0l6247b4iyxnj52lpvxhd10yxbkmnpyxrn84iafzqmp56kv";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."term"."0.4.6"."kernel32_sys"}" deps)
      (crates."winapi"."${deps."term"."0.4.6"."winapi"}" deps)
    ]) else []);
  };
  features_.term."0.4.6" = deps: f: updateFeatures f (rec {
    kernel32_sys."${deps.term."0.4.6".kernel32_sys}".default = true;
    term."0.4.6".default = (f.term."0.4.6".default or true);
    winapi."${deps.term."0.4.6".winapi}".default = true;
  }) [
    (features_.kernel32_sys."${deps."term"."0.4.6"."kernel32_sys"}" deps)
    (features_.winapi."${deps."term"."0.4.6"."winapi"}" deps)
  ];


# end
# termcolor-1.0.4

  crates.termcolor."1.0.4" = deps: { features?(features_.termcolor."1.0.4" deps {}) }: buildRustCrate {
    crateName = "termcolor";
    version = "1.0.4";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0xydrjc0bxg08llcbcmkka29szdrfklk4vh6l6mdd67ajifqw1mv";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."wincolor"."${deps."termcolor"."1.0.4"."wincolor"}" deps)
    ]) else []);
  };
  features_.termcolor."1.0.4" = deps: f: updateFeatures f (rec {
    termcolor."1.0.4".default = (f.termcolor."1.0.4".default or true);
    wincolor."${deps.termcolor."1.0.4".wincolor}".default = true;
  }) [
    (features_.wincolor."${deps."termcolor"."1.0.4"."wincolor"}" deps)
  ];


# end
# termion-1.5.1

  crates.termion."1.5.1" = deps: { features?(features_.termion."1.5.1" deps {}) }: buildRustCrate {
    crateName = "termion";
    version = "1.5.1";
    authors = [ "ticki <Ticki@users.noreply.github.com>" "gycos <alexandre.bury@gmail.com>" "IGI-111 <igi-111@protonmail.com>" ];
    sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
    dependencies = (if !(kernel == "redox") then mapFeatures features ([
      (crates."libc"."${deps."termion"."1.5.1"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."termion"."1.5.1"."redox_syscall"}" deps)
      (crates."redox_termios"."${deps."termion"."1.5.1"."redox_termios"}" deps)
    ]) else []);
  };
  features_.termion."1.5.1" = deps: f: updateFeatures f (rec {
    libc."${deps.termion."1.5.1".libc}".default = true;
    redox_syscall."${deps.termion."1.5.1".redox_syscall}".default = true;
    redox_termios."${deps.termion."1.5.1".redox_termios}".default = true;
    termion."1.5.1".default = (f.termion."1.5.1".default or true);
  }) [
    (features_.libc."${deps."termion"."1.5.1"."libc"}" deps)
    (features_.redox_syscall."${deps."termion"."1.5.1"."redox_syscall"}" deps)
    (features_.redox_termios."${deps."termion"."1.5.1"."redox_termios"}" deps)
  ];


# end
# textwrap-0.10.0

  crates.textwrap."0.10.0" = deps: { features?(features_.textwrap."0.10.0" deps {}) }: buildRustCrate {
    crateName = "textwrap";
    version = "0.10.0";
    authors = [ "Martin Geisler <martin@geisler.net>" ];
    sha256 = "1s8d5cna12smhgj0x2y1xphklyk2an1yzbadnj89p1vy5vnjpsas";
    dependencies = mapFeatures features ([
      (crates."unicode_width"."${deps."textwrap"."0.10.0"."unicode_width"}" deps)
    ]);
  };
  features_.textwrap."0.10.0" = deps: f: updateFeatures f (rec {
    textwrap."0.10.0".default = (f.textwrap."0.10.0".default or true);
    unicode_width."${deps.textwrap."0.10.0".unicode_width}".default = true;
  }) [
    (features_.unicode_width."${deps."textwrap"."0.10.0"."unicode_width"}" deps)
  ];


# end
# thread_local-0.3.6

  crates.thread_local."0.3.6" = deps: { features?(features_.thread_local."0.3.6" deps {}) }: buildRustCrate {
    crateName = "thread_local";
    version = "0.3.6";
    authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
    sha256 = "02rksdwjmz2pw9bmgbb4c0bgkbq5z6nvg510sq1s6y2j1gam0c7i";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
    ]);
  };
  features_.thread_local."0.3.6" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.thread_local."0.3.6".lazy_static}".default = true;
    thread_local."0.3.6".default = (f.thread_local."0.3.6".default or true);
  }) [
    (features_.lazy_static."${deps."thread_local"."0.3.6"."lazy_static"}" deps)
  ];


# end
# thrussh-0.21.2

  crates.thrussh."0.21.2" = deps: { features?(features_.thrussh."0.21.2" deps {}) }: buildRustCrate {
    crateName = "thrussh";
    version = "0.21.2";
    authors = [ "Pierre-Étienne Meunier <pe@pijul.org>" ];
    sha256 = "121agyx4ds4vvjhg67y76fxxmkhn97v5jyamkb4jkwszsi5s0ixv";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."thrussh"."0.21.2"."bitflags"}" deps)
      (crates."byteorder"."${deps."thrussh"."0.21.2"."byteorder"}" deps)
      (crates."cryptovec"."${deps."thrussh"."0.21.2"."cryptovec"}" deps)
      (crates."futures"."${deps."thrussh"."0.21.2"."futures"}" deps)
      (crates."log"."${deps."thrussh"."0.21.2"."log"}" deps)
      (crates."openssl"."${deps."thrussh"."0.21.2"."openssl"}" deps)
      (crates."thrussh_keys"."${deps."thrussh"."0.21.2"."thrussh_keys"}" deps)
      (crates."thrussh_libsodium"."${deps."thrussh"."0.21.2"."thrussh_libsodium"}" deps)
      (crates."tokio"."${deps."thrussh"."0.21.2"."tokio"}" deps)
      (crates."tokio_io"."${deps."thrussh"."0.21.2"."tokio_io"}" deps)
    ]);
  };
  features_.thrussh."0.21.2" = deps: f: updateFeatures f (rec {
    bitflags."${deps.thrussh."0.21.2".bitflags}".default = true;
    byteorder."${deps.thrussh."0.21.2".byteorder}".default = true;
    cryptovec."${deps.thrussh."0.21.2".cryptovec}".default = true;
    futures."${deps.thrussh."0.21.2".futures}".default = true;
    log."${deps.thrussh."0.21.2".log}".default = true;
    openssl."${deps.thrussh."0.21.2".openssl}".default = true;
    thrussh."0.21.2".default = (f.thrussh."0.21.2".default or true);
    thrussh_keys."${deps.thrussh."0.21.2".thrussh_keys}".default = true;
    thrussh_libsodium."${deps.thrussh."0.21.2".thrussh_libsodium}".default = true;
    tokio."${deps.thrussh."0.21.2".tokio}".default = true;
    tokio_io."${deps.thrussh."0.21.2".tokio_io}".default = true;
  }) [
    (features_.bitflags."${deps."thrussh"."0.21.2"."bitflags"}" deps)
    (features_.byteorder."${deps."thrussh"."0.21.2"."byteorder"}" deps)
    (features_.cryptovec."${deps."thrussh"."0.21.2"."cryptovec"}" deps)
    (features_.futures."${deps."thrussh"."0.21.2"."futures"}" deps)
    (features_.log."${deps."thrussh"."0.21.2"."log"}" deps)
    (features_.openssl."${deps."thrussh"."0.21.2"."openssl"}" deps)
    (features_.thrussh_keys."${deps."thrussh"."0.21.2"."thrussh_keys"}" deps)
    (features_.thrussh_libsodium."${deps."thrussh"."0.21.2"."thrussh_libsodium"}" deps)
    (features_.tokio."${deps."thrussh"."0.21.2"."tokio"}" deps)
    (features_.tokio_io."${deps."thrussh"."0.21.2"."tokio_io"}" deps)
  ];


# end
# thrussh-keys-0.11.9

  crates.thrussh_keys."0.11.9" = deps: { features?(features_.thrussh_keys."0.11.9" deps {}) }: buildRustCrate {
    crateName = "thrussh-keys";
    version = "0.11.9";
    authors = [ "Pierre-Étienne Meunier <pe@pijul.org>" ];
    sha256 = "1rfd1yskx23wr2m40w75bfcm2ls2jqv4j0h793agihikxgfxfgdg";
    dependencies = mapFeatures features ([
      (crates."base64"."${deps."thrussh_keys"."0.11.9"."base64"}" deps)
      (crates."bit_vec"."${deps."thrussh_keys"."0.11.9"."bit_vec"}" deps)
      (crates."byteorder"."${deps."thrussh_keys"."0.11.9"."byteorder"}" deps)
      (crates."cryptovec"."${deps."thrussh_keys"."0.11.9"."cryptovec"}" deps)
      (crates."dirs"."${deps."thrussh_keys"."0.11.9"."dirs"}" deps)
      (crates."futures"."${deps."thrussh_keys"."0.11.9"."futures"}" deps)
      (crates."hex"."${deps."thrussh_keys"."0.11.9"."hex"}" deps)
      (crates."log"."${deps."thrussh_keys"."0.11.9"."log"}" deps)
      (crates."num_bigint"."${deps."thrussh_keys"."0.11.9"."num_bigint"}" deps)
      (crates."num_integer"."${deps."thrussh_keys"."0.11.9"."num_integer"}" deps)
      (crates."openssl"."${deps."thrussh_keys"."0.11.9"."openssl"}" deps)
      (crates."serde"."${deps."thrussh_keys"."0.11.9"."serde"}" deps)
      (crates."serde_derive"."${deps."thrussh_keys"."0.11.9"."serde_derive"}" deps)
      (crates."thrussh_libsodium"."${deps."thrussh_keys"."0.11.9"."thrussh_libsodium"}" deps)
      (crates."tokio"."${deps."thrussh_keys"."0.11.9"."tokio"}" deps)
      (crates."yasna"."${deps."thrussh_keys"."0.11.9"."yasna"}" deps)
    ]);
  };
  features_.thrussh_keys."0.11.9" = deps: f: updateFeatures f (rec {
    base64."${deps.thrussh_keys."0.11.9".base64}".default = true;
    bit_vec."${deps.thrussh_keys."0.11.9".bit_vec}".default = true;
    byteorder."${deps.thrussh_keys."0.11.9".byteorder}".default = true;
    cryptovec."${deps.thrussh_keys."0.11.9".cryptovec}".default = true;
    dirs."${deps.thrussh_keys."0.11.9".dirs}".default = true;
    futures."${deps.thrussh_keys."0.11.9".futures}".default = true;
    hex."${deps.thrussh_keys."0.11.9".hex}".default = true;
    log."${deps.thrussh_keys."0.11.9".log}".default = true;
    num_bigint."${deps.thrussh_keys."0.11.9".num_bigint}".default = (f.num_bigint."${deps.thrussh_keys."0.11.9".num_bigint}".default or false);
    num_integer."${deps.thrussh_keys."0.11.9".num_integer}".default = (f.num_integer."${deps.thrussh_keys."0.11.9".num_integer}".default or false);
    openssl."${deps.thrussh_keys."0.11.9".openssl}".default = true;
    serde."${deps.thrussh_keys."0.11.9".serde}".default = true;
    serde_derive."${deps.thrussh_keys."0.11.9".serde_derive}".default = true;
    thrussh_keys."0.11.9".default = (f.thrussh_keys."0.11.9".default or true);
    thrussh_libsodium."${deps.thrussh_keys."0.11.9".thrussh_libsodium}".default = true;
    tokio."${deps.thrussh_keys."0.11.9".tokio}".default = true;
    yasna."${deps.thrussh_keys."0.11.9".yasna}".default = true;
  }) [
    (features_.base64."${deps."thrussh_keys"."0.11.9"."base64"}" deps)
    (features_.bit_vec."${deps."thrussh_keys"."0.11.9"."bit_vec"}" deps)
    (features_.byteorder."${deps."thrussh_keys"."0.11.9"."byteorder"}" deps)
    (features_.cryptovec."${deps."thrussh_keys"."0.11.9"."cryptovec"}" deps)
    (features_.dirs."${deps."thrussh_keys"."0.11.9"."dirs"}" deps)
    (features_.futures."${deps."thrussh_keys"."0.11.9"."futures"}" deps)
    (features_.hex."${deps."thrussh_keys"."0.11.9"."hex"}" deps)
    (features_.log."${deps."thrussh_keys"."0.11.9"."log"}" deps)
    (features_.num_bigint."${deps."thrussh_keys"."0.11.9"."num_bigint"}" deps)
    (features_.num_integer."${deps."thrussh_keys"."0.11.9"."num_integer"}" deps)
    (features_.openssl."${deps."thrussh_keys"."0.11.9"."openssl"}" deps)
    (features_.serde."${deps."thrussh_keys"."0.11.9"."serde"}" deps)
    (features_.serde_derive."${deps."thrussh_keys"."0.11.9"."serde_derive"}" deps)
    (features_.thrussh_libsodium."${deps."thrussh_keys"."0.11.9"."thrussh_libsodium"}" deps)
    (features_.tokio."${deps."thrussh_keys"."0.11.9"."tokio"}" deps)
    (features_.yasna."${deps."thrussh_keys"."0.11.9"."yasna"}" deps)
  ];


# end
# thrussh-libsodium-0.1.3

  crates.thrussh_libsodium."0.1.3" = deps: { features?(features_.thrussh_libsodium."0.1.3" deps {}) }: buildRustCrate {
    crateName = "thrussh-libsodium";
    version = "0.1.3";
    authors = [ "pe@pijul.org <pe@pijul.org>" ];
    sha256 = "07rskar3rbqnjmyh9zpmfl9q7xhclpgs6703i30hvh4qnd6f91yh";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."thrussh_libsodium"."0.1.3"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."pkg_config"."${deps."thrussh_libsodium"."0.1.3"."pkg_config"}" deps)
    ]);
  };
  features_.thrussh_libsodium."0.1.3" = deps: f: updateFeatures f (rec {
    libc."${deps.thrussh_libsodium."0.1.3".libc}".default = true;
    pkg_config."${deps.thrussh_libsodium."0.1.3".pkg_config}".default = true;
    thrussh_libsodium."0.1.3".default = (f.thrussh_libsodium."0.1.3".default or true);
  }) [
    (features_.libc."${deps."thrussh_libsodium"."0.1.3"."libc"}" deps)
    (features_.pkg_config."${deps."thrussh_libsodium"."0.1.3"."pkg_config"}" deps)
  ];


# end
# tiff-0.2.2

  crates.tiff."0.2.2" = deps: { features?(features_.tiff."0.2.2" deps {}) }: buildRustCrate {
    crateName = "tiff";
    version = "0.2.2";
    authors = [ "ccgn" "bvssvni <bvssvni@gmail.com>" "nwin" "TyOverby <ty@pre-alpha.com>" "HeroicKatora" "Calum" "CensoredUsername <cens.username@gmail.com>" "Robzz" ];
    sha256 = "0na8sv77k9gakn0mgiw309zimw34b3598bjl1rg0s236hx8vj3f2";
    dependencies = mapFeatures features ([
      (crates."byteorder"."${deps."tiff"."0.2.2"."byteorder"}" deps)
      (crates."lzw"."${deps."tiff"."0.2.2"."lzw"}" deps)
      (crates."num_derive"."${deps."tiff"."0.2.2"."num_derive"}" deps)
      (crates."num_traits"."${deps."tiff"."0.2.2"."num_traits"}" deps)
    ]);
  };
  features_.tiff."0.2.2" = deps: f: updateFeatures f (rec {
    byteorder."${deps.tiff."0.2.2".byteorder}".default = true;
    lzw."${deps.tiff."0.2.2".lzw}".default = true;
    num_derive."${deps.tiff."0.2.2".num_derive}".default = true;
    num_traits."${deps.tiff."0.2.2".num_traits}".default = true;
    tiff."0.2.2".default = (f.tiff."0.2.2".default or true);
  }) [
    (features_.byteorder."${deps."tiff"."0.2.2"."byteorder"}" deps)
    (features_.lzw."${deps."tiff"."0.2.2"."lzw"}" deps)
    (features_.num_derive."${deps."tiff"."0.2.2"."num_derive"}" deps)
    (features_.num_traits."${deps."tiff"."0.2.2"."num_traits"}" deps)
  ];


# end
# time-0.1.42

  crates.time."0.1.42" = deps: { features?(features_.time."0.1.42" deps {}) }: buildRustCrate {
    crateName = "time";
    version = "0.1.42";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1ny809kmdjwd4b478ipc33dz7q6nq7rxk766x8cnrg6zygcksmmx";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."time"."0.1.42"."libc"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."time"."0.1.42"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."time"."0.1.42"."winapi"}" deps)
    ]) else []);
  };
  features_.time."0.1.42" = deps: f: updateFeatures f (rec {
    libc."${deps.time."0.1.42".libc}".default = true;
    redox_syscall."${deps.time."0.1.42".redox_syscall}".default = true;
    time."0.1.42".default = (f.time."0.1.42".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.time."0.1.42".winapi}"."minwinbase" = true; }
      { "${deps.time."0.1.42".winapi}"."minwindef" = true; }
      { "${deps.time."0.1.42".winapi}"."ntdef" = true; }
      { "${deps.time."0.1.42".winapi}"."profileapi" = true; }
      { "${deps.time."0.1.42".winapi}"."std" = true; }
      { "${deps.time."0.1.42".winapi}"."sysinfoapi" = true; }
      { "${deps.time."0.1.42".winapi}"."timezoneapi" = true; }
      { "${deps.time."0.1.42".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."time"."0.1.42"."libc"}" deps)
    (features_.redox_syscall."${deps."time"."0.1.42"."redox_syscall"}" deps)
    (features_.winapi."${deps."time"."0.1.42"."winapi"}" deps)
  ];


# end
# tokio-0.1.16

  crates.tokio."0.1.16" = deps: { features?(features_.tokio."0.1.16" deps {}) }: buildRustCrate {
    crateName = "tokio";
    version = "0.1.16";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0csxsa01piri6lzl8506jn7famq38zkj3wx42c6kp5f63m69wdys";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio"."0.1.16"."futures"}" deps)
    ]
      ++ (if features.tokio."0.1.16".bytes or false then [ (crates.bytes."${deps."tokio"."0.1.16".bytes}" deps) ] else [])
      ++ (if features.tokio."0.1.16".mio or false then [ (crates.mio."${deps."tokio"."0.1.16".mio}" deps) ] else [])
      ++ (if features.tokio."0.1.16".num_cpus or false then [ (crates.num_cpus."${deps."tokio"."0.1.16".num_cpus}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-codec or false then [ (crates.tokio_codec."${deps."tokio"."0.1.16".tokio_codec}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-current-thread or false then [ (crates.tokio_current_thread."${deps."tokio"."0.1.16".tokio_current_thread}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-executor or false then [ (crates.tokio_executor."${deps."tokio"."0.1.16".tokio_executor}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-fs or false then [ (crates.tokio_fs."${deps."tokio"."0.1.16".tokio_fs}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-io or false then [ (crates.tokio_io."${deps."tokio"."0.1.16".tokio_io}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-reactor or false then [ (crates.tokio_reactor."${deps."tokio"."0.1.16".tokio_reactor}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-sync or false then [ (crates.tokio_sync."${deps."tokio"."0.1.16".tokio_sync}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-tcp or false then [ (crates.tokio_tcp."${deps."tokio"."0.1.16".tokio_tcp}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-threadpool or false then [ (crates.tokio_threadpool."${deps."tokio"."0.1.16".tokio_threadpool}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-timer or false then [ (crates.tokio_timer."${deps."tokio"."0.1.16".tokio_timer}" deps) ] else [])
      ++ (if features.tokio."0.1.16".tokio-udp or false then [ (crates.tokio_udp."${deps."tokio"."0.1.16".tokio_udp}" deps) ] else []))
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.tokio."0.1.16".tokio-uds or false then [ (crates.tokio_uds."${deps."tokio"."0.1.16".tokio_uds}" deps) ] else [])) else []);
    features = mkFeatures (features."tokio"."0.1.16" or {});
  };
  features_.tokio."0.1.16" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio."0.1.16".bytes}".default = true;
    futures."${deps.tokio."0.1.16".futures}".default = true;
    mio."${deps.tokio."0.1.16".mio}".default = true;
    num_cpus."${deps.tokio."0.1.16".num_cpus}".default = true;
    tokio = fold recursiveUpdate {} [
      { "0.1.16".bytes =
        (f.tokio."0.1.16".bytes or false) ||
        (f.tokio."0.1.16".io or false) ||
        (tokio."0.1.16"."io" or false); }
      { "0.1.16".codec =
        (f.tokio."0.1.16".codec or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
      { "0.1.16".default = (f.tokio."0.1.16".default or true); }
      { "0.1.16".fs =
        (f.tokio."0.1.16".fs or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
      { "0.1.16".io =
        (f.tokio."0.1.16".io or false) ||
        (f.tokio."0.1.16".codec or false) ||
        (tokio."0.1.16"."codec" or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false) ||
        (f.tokio."0.1.16".reactor or false) ||
        (tokio."0.1.16"."reactor" or false); }
      { "0.1.16".mio =
        (f.tokio."0.1.16".mio or false) ||
        (f.tokio."0.1.16".reactor or false) ||
        (tokio."0.1.16"."reactor" or false); }
      { "0.1.16".num_cpus =
        (f.tokio."0.1.16".num_cpus or false) ||
        (f.tokio."0.1.16".rt-full or false) ||
        (tokio."0.1.16"."rt-full" or false); }
      { "0.1.16".reactor =
        (f.tokio."0.1.16".reactor or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false) ||
        (f.tokio."0.1.16".rt-full or false) ||
        (tokio."0.1.16"."rt-full" or false); }
      { "0.1.16".rt-full =
        (f.tokio."0.1.16".rt-full or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
      { "0.1.16".sync =
        (f.tokio."0.1.16".sync or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
      { "0.1.16".tcp =
        (f.tokio."0.1.16".tcp or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
      { "0.1.16".timer =
        (f.tokio."0.1.16".timer or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false) ||
        (f.tokio."0.1.16".rt-full or false) ||
        (tokio."0.1.16"."rt-full" or false); }
      { "0.1.16".tokio-codec =
        (f.tokio."0.1.16".tokio-codec or false) ||
        (f.tokio."0.1.16".codec or false) ||
        (tokio."0.1.16"."codec" or false); }
      { "0.1.16".tokio-current-thread =
        (f.tokio."0.1.16".tokio-current-thread or false) ||
        (f.tokio."0.1.16".rt-full or false) ||
        (tokio."0.1.16"."rt-full" or false); }
      { "0.1.16".tokio-executor =
        (f.tokio."0.1.16".tokio-executor or false) ||
        (f.tokio."0.1.16".rt-full or false) ||
        (tokio."0.1.16"."rt-full" or false); }
      { "0.1.16".tokio-fs =
        (f.tokio."0.1.16".tokio-fs or false) ||
        (f.tokio."0.1.16".fs or false) ||
        (tokio."0.1.16"."fs" or false); }
      { "0.1.16".tokio-io =
        (f.tokio."0.1.16".tokio-io or false) ||
        (f.tokio."0.1.16".io or false) ||
        (tokio."0.1.16"."io" or false); }
      { "0.1.16".tokio-reactor =
        (f.tokio."0.1.16".tokio-reactor or false) ||
        (f.tokio."0.1.16".reactor or false) ||
        (tokio."0.1.16"."reactor" or false); }
      { "0.1.16".tokio-sync =
        (f.tokio."0.1.16".tokio-sync or false) ||
        (f.tokio."0.1.16".sync or false) ||
        (tokio."0.1.16"."sync" or false); }
      { "0.1.16".tokio-tcp =
        (f.tokio."0.1.16".tokio-tcp or false) ||
        (f.tokio."0.1.16".tcp or false) ||
        (tokio."0.1.16"."tcp" or false); }
      { "0.1.16".tokio-threadpool =
        (f.tokio."0.1.16".tokio-threadpool or false) ||
        (f.tokio."0.1.16".rt-full or false) ||
        (tokio."0.1.16"."rt-full" or false); }
      { "0.1.16".tokio-timer =
        (f.tokio."0.1.16".tokio-timer or false) ||
        (f.tokio."0.1.16".timer or false) ||
        (tokio."0.1.16"."timer" or false); }
      { "0.1.16".tokio-udp =
        (f.tokio."0.1.16".tokio-udp or false) ||
        (f.tokio."0.1.16".udp or false) ||
        (tokio."0.1.16"."udp" or false); }
      { "0.1.16".tokio-uds =
        (f.tokio."0.1.16".tokio-uds or false) ||
        (f.tokio."0.1.16".uds or false) ||
        (tokio."0.1.16"."uds" or false); }
      { "0.1.16".udp =
        (f.tokio."0.1.16".udp or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
      { "0.1.16".uds =
        (f.tokio."0.1.16".uds or false) ||
        (f.tokio."0.1.16".default or false) ||
        (tokio."0.1.16"."default" or false); }
    ];
    tokio_codec."${deps.tokio."0.1.16".tokio_codec}".default = true;
    tokio_current_thread."${deps.tokio."0.1.16".tokio_current_thread}".default = true;
    tokio_executor."${deps.tokio."0.1.16".tokio_executor}".default = true;
    tokio_fs."${deps.tokio."0.1.16".tokio_fs}".default = true;
    tokio_io."${deps.tokio."0.1.16".tokio_io}".default = true;
    tokio_reactor."${deps.tokio."0.1.16".tokio_reactor}".default = true;
    tokio_sync."${deps.tokio."0.1.16".tokio_sync}".default = true;
    tokio_tcp."${deps.tokio."0.1.16".tokio_tcp}".default = true;
    tokio_threadpool."${deps.tokio."0.1.16".tokio_threadpool}".default = true;
    tokio_timer."${deps.tokio."0.1.16".tokio_timer}".default = true;
    tokio_udp."${deps.tokio."0.1.16".tokio_udp}".default = true;
    tokio_uds."${deps.tokio."0.1.16".tokio_uds}".default = true;
  }) [
    (features_.bytes."${deps."tokio"."0.1.16"."bytes"}" deps)
    (features_.futures."${deps."tokio"."0.1.16"."futures"}" deps)
    (features_.mio."${deps."tokio"."0.1.16"."mio"}" deps)
    (features_.num_cpus."${deps."tokio"."0.1.16"."num_cpus"}" deps)
    (features_.tokio_codec."${deps."tokio"."0.1.16"."tokio_codec"}" deps)
    (features_.tokio_current_thread."${deps."tokio"."0.1.16"."tokio_current_thread"}" deps)
    (features_.tokio_executor."${deps."tokio"."0.1.16"."tokio_executor"}" deps)
    (features_.tokio_fs."${deps."tokio"."0.1.16"."tokio_fs"}" deps)
    (features_.tokio_io."${deps."tokio"."0.1.16"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio"."0.1.16"."tokio_reactor"}" deps)
    (features_.tokio_sync."${deps."tokio"."0.1.16"."tokio_sync"}" deps)
    (features_.tokio_tcp."${deps."tokio"."0.1.16"."tokio_tcp"}" deps)
    (features_.tokio_threadpool."${deps."tokio"."0.1.16"."tokio_threadpool"}" deps)
    (features_.tokio_timer."${deps."tokio"."0.1.16"."tokio_timer"}" deps)
    (features_.tokio_udp."${deps."tokio"."0.1.16"."tokio_udp"}" deps)
    (features_.tokio_uds."${deps."tokio"."0.1.16"."tokio_uds"}" deps)
  ];


# end
# tokio-codec-0.1.1

  crates.tokio_codec."0.1.1" = deps: { features?(features_.tokio_codec."0.1.1" deps {}) }: buildRustCrate {
    crateName = "tokio-codec";
    version = "0.1.1";
    authors = [ "Carl Lerche <me@carllerche.com>" "Bryan Burgers <bryan@burgers.io>" ];
    sha256 = "0jc9lik540zyj4chbygg1rjh37m3zax8pd4bwcrwjmi1v56qwi4h";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_codec"."0.1.1"."bytes"}" deps)
      (crates."futures"."${deps."tokio_codec"."0.1.1"."futures"}" deps)
      (crates."tokio_io"."${deps."tokio_codec"."0.1.1"."tokio_io"}" deps)
    ]);
  };
  features_.tokio_codec."0.1.1" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_codec."0.1.1".bytes}".default = true;
    futures."${deps.tokio_codec."0.1.1".futures}".default = true;
    tokio_codec."0.1.1".default = (f.tokio_codec."0.1.1".default or true);
    tokio_io."${deps.tokio_codec."0.1.1".tokio_io}".default = true;
  }) [
    (features_.bytes."${deps."tokio_codec"."0.1.1"."bytes"}" deps)
    (features_.futures."${deps."tokio_codec"."0.1.1"."futures"}" deps)
    (features_.tokio_io."${deps."tokio_codec"."0.1.1"."tokio_io"}" deps)
  ];


# end
# tokio-current-thread-0.1.5

  crates.tokio_current_thread."0.1.5" = deps: { features?(features_.tokio_current_thread."0.1.5" deps {}) }: buildRustCrate {
    crateName = "tokio-current-thread";
    version = "0.1.5";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "00ay0kgrwj70jybbdfmvph4k4nk419pqk7v2ddrw2crfl9qqybm5";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_current_thread"."0.1.5"."futures"}" deps)
      (crates."tokio_executor"."${deps."tokio_current_thread"."0.1.5"."tokio_executor"}" deps)
    ]);
  };
  features_.tokio_current_thread."0.1.5" = deps: f: updateFeatures f (rec {
    futures."${deps.tokio_current_thread."0.1.5".futures}".default = true;
    tokio_current_thread."0.1.5".default = (f.tokio_current_thread."0.1.5".default or true);
    tokio_executor."${deps.tokio_current_thread."0.1.5".tokio_executor}".default = true;
  }) [
    (features_.futures."${deps."tokio_current_thread"."0.1.5"."futures"}" deps)
    (features_.tokio_executor."${deps."tokio_current_thread"."0.1.5"."tokio_executor"}" deps)
  ];


# end
# tokio-executor-0.1.6

  crates.tokio_executor."0.1.6" = deps: { features?(features_.tokio_executor."0.1.6" deps {}) }: buildRustCrate {
    crateName = "tokio-executor";
    version = "0.1.6";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0dwbzdq97fija2scd8lkxa7lfahj056ii7fpwn7bwrc38sqyd8ld";
    dependencies = mapFeatures features ([
      (crates."crossbeam_utils"."${deps."tokio_executor"."0.1.6"."crossbeam_utils"}" deps)
      (crates."futures"."${deps."tokio_executor"."0.1.6"."futures"}" deps)
    ]);
  };
  features_.tokio_executor."0.1.6" = deps: f: updateFeatures f (rec {
    crossbeam_utils."${deps.tokio_executor."0.1.6".crossbeam_utils}".default = true;
    futures."${deps.tokio_executor."0.1.6".futures}".default = true;
    tokio_executor."0.1.6".default = (f.tokio_executor."0.1.6".default or true);
  }) [
    (features_.crossbeam_utils."${deps."tokio_executor"."0.1.6"."crossbeam_utils"}" deps)
    (features_.futures."${deps."tokio_executor"."0.1.6"."futures"}" deps)
  ];


# end
# tokio-fs-0.1.6

  crates.tokio_fs."0.1.6" = deps: { features?(features_.tokio_fs."0.1.6" deps {}) }: buildRustCrate {
    crateName = "tokio-fs";
    version = "0.1.6";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0v4mkwg7dj0fakzszy7nvr88y0bskwcvsy2w6d4pzmd186b0v640";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_fs"."0.1.6"."futures"}" deps)
      (crates."tokio_io"."${deps."tokio_fs"."0.1.6"."tokio_io"}" deps)
      (crates."tokio_threadpool"."${deps."tokio_fs"."0.1.6"."tokio_threadpool"}" deps)
    ]);
  };
  features_.tokio_fs."0.1.6" = deps: f: updateFeatures f (rec {
    futures."${deps.tokio_fs."0.1.6".futures}".default = true;
    tokio_fs."0.1.6".default = (f.tokio_fs."0.1.6".default or true);
    tokio_io."${deps.tokio_fs."0.1.6".tokio_io}".default = true;
    tokio_threadpool."${deps.tokio_fs."0.1.6".tokio_threadpool}".default = true;
  }) [
    (features_.futures."${deps."tokio_fs"."0.1.6"."futures"}" deps)
    (features_.tokio_io."${deps."tokio_fs"."0.1.6"."tokio_io"}" deps)
    (features_.tokio_threadpool."${deps."tokio_fs"."0.1.6"."tokio_threadpool"}" deps)
  ];


# end
# tokio-io-0.1.12

  crates.tokio_io."0.1.12" = deps: { features?(features_.tokio_io."0.1.12" deps {}) }: buildRustCrate {
    crateName = "tokio-io";
    version = "0.1.12";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0z64yfcm9i5ci2h9h7npa292plia9kb04xbm7cp0bzp1wsddv91r";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_io"."0.1.12"."bytes"}" deps)
      (crates."futures"."${deps."tokio_io"."0.1.12"."futures"}" deps)
      (crates."log"."${deps."tokio_io"."0.1.12"."log"}" deps)
    ]);
  };
  features_.tokio_io."0.1.12" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_io."0.1.12".bytes}".default = true;
    futures."${deps.tokio_io."0.1.12".futures}".default = true;
    log."${deps.tokio_io."0.1.12".log}".default = true;
    tokio_io."0.1.12".default = (f.tokio_io."0.1.12".default or true);
  }) [
    (features_.bytes."${deps."tokio_io"."0.1.12"."bytes"}" deps)
    (features_.futures."${deps."tokio_io"."0.1.12"."futures"}" deps)
    (features_.log."${deps."tokio_io"."0.1.12"."log"}" deps)
  ];


# end
# tokio-openssl-0.2.1

  crates.tokio_openssl."0.2.1" = deps: { features?(features_.tokio_openssl."0.2.1" deps {}) }: buildRustCrate {
    crateName = "tokio-openssl";
    version = "0.2.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1nbp74nrcxbcp4mg5j1shdlpsgr9rpjqc26wz8gn7kmgd9cyk2x8";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_openssl"."0.2.1"."futures"}" deps)
      (crates."openssl"."${deps."tokio_openssl"."0.2.1"."openssl"}" deps)
      (crates."tokio_io"."${deps."tokio_openssl"."0.2.1"."tokio_io"}" deps)
    ]);
  };
  features_.tokio_openssl."0.2.1" = deps: f: updateFeatures f (rec {
    futures."${deps.tokio_openssl."0.2.1".futures}".default = true;
    openssl."${deps.tokio_openssl."0.2.1".openssl}".default = true;
    tokio_io."${deps.tokio_openssl."0.2.1".tokio_io}".default = true;
    tokio_openssl."0.2.1".default = (f.tokio_openssl."0.2.1".default or true);
  }) [
    (features_.futures."${deps."tokio_openssl"."0.2.1"."futures"}" deps)
    (features_.openssl."${deps."tokio_openssl"."0.2.1"."openssl"}" deps)
    (features_.tokio_io."${deps."tokio_openssl"."0.2.1"."tokio_io"}" deps)
  ];


# end
# tokio-openssl-0.3.0

  crates.tokio_openssl."0.3.0" = deps: { features?(features_.tokio_openssl."0.3.0" deps {}) }: buildRustCrate {
    crateName = "tokio-openssl";
    version = "0.3.0";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1hpga4nrdi5hlxfsdnzb9g6kwxgp632nq6ysirmfvfc6c4fx54l9";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."tokio_openssl"."0.3.0"."futures"}" deps)
      (crates."openssl"."${deps."tokio_openssl"."0.3.0"."openssl"}" deps)
      (crates."tokio_io"."${deps."tokio_openssl"."0.3.0"."tokio_io"}" deps)
    ]);
  };
  features_.tokio_openssl."0.3.0" = deps: f: updateFeatures f (rec {
    futures."${deps.tokio_openssl."0.3.0".futures}".default = true;
    openssl."${deps.tokio_openssl."0.3.0".openssl}".default = true;
    tokio_io."${deps.tokio_openssl."0.3.0".tokio_io}".default = true;
    tokio_openssl."0.3.0".default = (f.tokio_openssl."0.3.0".default or true);
  }) [
    (features_.futures."${deps."tokio_openssl"."0.3.0"."futures"}" deps)
    (features_.openssl."${deps."tokio_openssl"."0.3.0"."openssl"}" deps)
    (features_.tokio_io."${deps."tokio_openssl"."0.3.0"."tokio_io"}" deps)
  ];


# end
# tokio-reactor-0.1.9

  crates.tokio_reactor."0.1.9" = deps: { features?(features_.tokio_reactor."0.1.9" deps {}) }: buildRustCrate {
    crateName = "tokio-reactor";
    version = "0.1.9";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "11gpxrykd6lbpj9b26dh4fymzawfxgqdx1pbhc771gxbf8qyj1gc";
    dependencies = mapFeatures features ([
      (crates."crossbeam_utils"."${deps."tokio_reactor"."0.1.9"."crossbeam_utils"}" deps)
      (crates."futures"."${deps."tokio_reactor"."0.1.9"."futures"}" deps)
      (crates."lazy_static"."${deps."tokio_reactor"."0.1.9"."lazy_static"}" deps)
      (crates."log"."${deps."tokio_reactor"."0.1.9"."log"}" deps)
      (crates."mio"."${deps."tokio_reactor"."0.1.9"."mio"}" deps)
      (crates."num_cpus"."${deps."tokio_reactor"."0.1.9"."num_cpus"}" deps)
      (crates."parking_lot"."${deps."tokio_reactor"."0.1.9"."parking_lot"}" deps)
      (crates."slab"."${deps."tokio_reactor"."0.1.9"."slab"}" deps)
      (crates."tokio_executor"."${deps."tokio_reactor"."0.1.9"."tokio_executor"}" deps)
      (crates."tokio_io"."${deps."tokio_reactor"."0.1.9"."tokio_io"}" deps)
      (crates."tokio_sync"."${deps."tokio_reactor"."0.1.9"."tokio_sync"}" deps)
    ]);
  };
  features_.tokio_reactor."0.1.9" = deps: f: updateFeatures f (rec {
    crossbeam_utils."${deps.tokio_reactor."0.1.9".crossbeam_utils}".default = true;
    futures."${deps.tokio_reactor."0.1.9".futures}".default = true;
    lazy_static."${deps.tokio_reactor."0.1.9".lazy_static}".default = true;
    log."${deps.tokio_reactor."0.1.9".log}".default = true;
    mio."${deps.tokio_reactor."0.1.9".mio}".default = true;
    num_cpus."${deps.tokio_reactor."0.1.9".num_cpus}".default = true;
    parking_lot."${deps.tokio_reactor."0.1.9".parking_lot}".default = true;
    slab."${deps.tokio_reactor."0.1.9".slab}".default = true;
    tokio_executor."${deps.tokio_reactor."0.1.9".tokio_executor}".default = true;
    tokio_io."${deps.tokio_reactor."0.1.9".tokio_io}".default = true;
    tokio_reactor."0.1.9".default = (f.tokio_reactor."0.1.9".default or true);
    tokio_sync."${deps.tokio_reactor."0.1.9".tokio_sync}".default = true;
  }) [
    (features_.crossbeam_utils."${deps."tokio_reactor"."0.1.9"."crossbeam_utils"}" deps)
    (features_.futures."${deps."tokio_reactor"."0.1.9"."futures"}" deps)
    (features_.lazy_static."${deps."tokio_reactor"."0.1.9"."lazy_static"}" deps)
    (features_.log."${deps."tokio_reactor"."0.1.9"."log"}" deps)
    (features_.mio."${deps."tokio_reactor"."0.1.9"."mio"}" deps)
    (features_.num_cpus."${deps."tokio_reactor"."0.1.9"."num_cpus"}" deps)
    (features_.parking_lot."${deps."tokio_reactor"."0.1.9"."parking_lot"}" deps)
    (features_.slab."${deps."tokio_reactor"."0.1.9"."slab"}" deps)
    (features_.tokio_executor."${deps."tokio_reactor"."0.1.9"."tokio_executor"}" deps)
    (features_.tokio_io."${deps."tokio_reactor"."0.1.9"."tokio_io"}" deps)
    (features_.tokio_sync."${deps."tokio_reactor"."0.1.9"."tokio_sync"}" deps)
  ];


# end
# tokio-sync-0.1.3

  crates.tokio_sync."0.1.3" = deps: { features?(features_.tokio_sync."0.1.3" deps {}) }: buildRustCrate {
    crateName = "tokio-sync";
    version = "0.1.3";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "0ih6syciwr6idhiy9cbly1jgixxcb399vpjkhfdd9y1m0v1444mm";
    dependencies = mapFeatures features ([
      (crates."fnv"."${deps."tokio_sync"."0.1.3"."fnv"}" deps)
      (crates."futures"."${deps."tokio_sync"."0.1.3"."futures"}" deps)
    ]);
  };
  features_.tokio_sync."0.1.3" = deps: f: updateFeatures f (rec {
    fnv."${deps.tokio_sync."0.1.3".fnv}".default = true;
    futures."${deps.tokio_sync."0.1.3".futures}".default = true;
    tokio_sync."0.1.3".default = (f.tokio_sync."0.1.3".default or true);
  }) [
    (features_.fnv."${deps."tokio_sync"."0.1.3"."fnv"}" deps)
    (features_.futures."${deps."tokio_sync"."0.1.3"."futures"}" deps)
  ];


# end
# tokio-tcp-0.1.3

  crates.tokio_tcp."0.1.3" = deps: { features?(features_.tokio_tcp."0.1.3" deps {}) }: buildRustCrate {
    crateName = "tokio-tcp";
    version = "0.1.3";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "07v5p339660zjy1w73wddagj3n5wa4v7v5gj7hnvw95ka407zvcz";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_tcp"."0.1.3"."bytes"}" deps)
      (crates."futures"."${deps."tokio_tcp"."0.1.3"."futures"}" deps)
      (crates."iovec"."${deps."tokio_tcp"."0.1.3"."iovec"}" deps)
      (crates."mio"."${deps."tokio_tcp"."0.1.3"."mio"}" deps)
      (crates."tokio_io"."${deps."tokio_tcp"."0.1.3"."tokio_io"}" deps)
      (crates."tokio_reactor"."${deps."tokio_tcp"."0.1.3"."tokio_reactor"}" deps)
    ]);
  };
  features_.tokio_tcp."0.1.3" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_tcp."0.1.3".bytes}".default = true;
    futures."${deps.tokio_tcp."0.1.3".futures}".default = true;
    iovec."${deps.tokio_tcp."0.1.3".iovec}".default = true;
    mio."${deps.tokio_tcp."0.1.3".mio}".default = true;
    tokio_io."${deps.tokio_tcp."0.1.3".tokio_io}".default = true;
    tokio_reactor."${deps.tokio_tcp."0.1.3".tokio_reactor}".default = true;
    tokio_tcp."0.1.3".default = (f.tokio_tcp."0.1.3".default or true);
  }) [
    (features_.bytes."${deps."tokio_tcp"."0.1.3"."bytes"}" deps)
    (features_.futures."${deps."tokio_tcp"."0.1.3"."futures"}" deps)
    (features_.iovec."${deps."tokio_tcp"."0.1.3"."iovec"}" deps)
    (features_.mio."${deps."tokio_tcp"."0.1.3"."mio"}" deps)
    (features_.tokio_io."${deps."tokio_tcp"."0.1.3"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio_tcp"."0.1.3"."tokio_reactor"}" deps)
  ];


# end
# tokio-threadpool-0.1.12

  crates.tokio_threadpool."0.1.12" = deps: { features?(features_.tokio_threadpool."0.1.12" deps {}) }: buildRustCrate {
    crateName = "tokio-threadpool";
    version = "0.1.12";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "08h0ji23b876ids6dj3dns95635l80l3wd9f3alphwvflz1np4n9";
    dependencies = mapFeatures features ([
      (crates."crossbeam_deque"."${deps."tokio_threadpool"."0.1.12"."crossbeam_deque"}" deps)
      (crates."crossbeam_queue"."${deps."tokio_threadpool"."0.1.12"."crossbeam_queue"}" deps)
      (crates."crossbeam_utils"."${deps."tokio_threadpool"."0.1.12"."crossbeam_utils"}" deps)
      (crates."futures"."${deps."tokio_threadpool"."0.1.12"."futures"}" deps)
      (crates."log"."${deps."tokio_threadpool"."0.1.12"."log"}" deps)
      (crates."num_cpus"."${deps."tokio_threadpool"."0.1.12"."num_cpus"}" deps)
      (crates."rand"."${deps."tokio_threadpool"."0.1.12"."rand"}" deps)
      (crates."slab"."${deps."tokio_threadpool"."0.1.12"."slab"}" deps)
      (crates."tokio_executor"."${deps."tokio_threadpool"."0.1.12"."tokio_executor"}" deps)
    ]);
  };
  features_.tokio_threadpool."0.1.12" = deps: f: updateFeatures f (rec {
    crossbeam_deque."${deps.tokio_threadpool."0.1.12".crossbeam_deque}".default = true;
    crossbeam_queue."${deps.tokio_threadpool."0.1.12".crossbeam_queue}".default = true;
    crossbeam_utils."${deps.tokio_threadpool."0.1.12".crossbeam_utils}".default = true;
    futures."${deps.tokio_threadpool."0.1.12".futures}".default = true;
    log."${deps.tokio_threadpool."0.1.12".log}".default = true;
    num_cpus."${deps.tokio_threadpool."0.1.12".num_cpus}".default = true;
    rand."${deps.tokio_threadpool."0.1.12".rand}".default = true;
    slab."${deps.tokio_threadpool."0.1.12".slab}".default = true;
    tokio_executor."${deps.tokio_threadpool."0.1.12".tokio_executor}".default = true;
    tokio_threadpool."0.1.12".default = (f.tokio_threadpool."0.1.12".default or true);
  }) [
    (features_.crossbeam_deque."${deps."tokio_threadpool"."0.1.12"."crossbeam_deque"}" deps)
    (features_.crossbeam_queue."${deps."tokio_threadpool"."0.1.12"."crossbeam_queue"}" deps)
    (features_.crossbeam_utils."${deps."tokio_threadpool"."0.1.12"."crossbeam_utils"}" deps)
    (features_.futures."${deps."tokio_threadpool"."0.1.12"."futures"}" deps)
    (features_.log."${deps."tokio_threadpool"."0.1.12"."log"}" deps)
    (features_.num_cpus."${deps."tokio_threadpool"."0.1.12"."num_cpus"}" deps)
    (features_.rand."${deps."tokio_threadpool"."0.1.12"."rand"}" deps)
    (features_.slab."${deps."tokio_threadpool"."0.1.12"."slab"}" deps)
    (features_.tokio_executor."${deps."tokio_threadpool"."0.1.12"."tokio_executor"}" deps)
  ];


# end
# tokio-timer-0.2.10

  crates.tokio_timer."0.2.10" = deps: { features?(features_.tokio_timer."0.2.10" deps {}) }: buildRustCrate {
    crateName = "tokio-timer";
    version = "0.2.10";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "17a5irj7ph95l30845vg6hy3igc0k04bhxnqs2qww4v8ix30vbkz";
    dependencies = mapFeatures features ([
      (crates."crossbeam_utils"."${deps."tokio_timer"."0.2.10"."crossbeam_utils"}" deps)
      (crates."futures"."${deps."tokio_timer"."0.2.10"."futures"}" deps)
      (crates."slab"."${deps."tokio_timer"."0.2.10"."slab"}" deps)
      (crates."tokio_executor"."${deps."tokio_timer"."0.2.10"."tokio_executor"}" deps)
    ]);
  };
  features_.tokio_timer."0.2.10" = deps: f: updateFeatures f (rec {
    crossbeam_utils."${deps.tokio_timer."0.2.10".crossbeam_utils}".default = true;
    futures."${deps.tokio_timer."0.2.10".futures}".default = true;
    slab."${deps.tokio_timer."0.2.10".slab}".default = true;
    tokio_executor."${deps.tokio_timer."0.2.10".tokio_executor}".default = true;
    tokio_timer."0.2.10".default = (f.tokio_timer."0.2.10".default or true);
  }) [
    (features_.crossbeam_utils."${deps."tokio_timer"."0.2.10"."crossbeam_utils"}" deps)
    (features_.futures."${deps."tokio_timer"."0.2.10"."futures"}" deps)
    (features_.slab."${deps."tokio_timer"."0.2.10"."slab"}" deps)
    (features_.tokio_executor."${deps."tokio_timer"."0.2.10"."tokio_executor"}" deps)
  ];


# end
# tokio-udp-0.1.3

  crates.tokio_udp."0.1.3" = deps: { features?(features_.tokio_udp."0.1.3" deps {}) }: buildRustCrate {
    crateName = "tokio-udp";
    version = "0.1.3";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1g1x499vqvzwy7xfccr32vwymlx25zpmkx8ppqgifzqwrjnncajf";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_udp"."0.1.3"."bytes"}" deps)
      (crates."futures"."${deps."tokio_udp"."0.1.3"."futures"}" deps)
      (crates."log"."${deps."tokio_udp"."0.1.3"."log"}" deps)
      (crates."mio"."${deps."tokio_udp"."0.1.3"."mio"}" deps)
      (crates."tokio_codec"."${deps."tokio_udp"."0.1.3"."tokio_codec"}" deps)
      (crates."tokio_io"."${deps."tokio_udp"."0.1.3"."tokio_io"}" deps)
      (crates."tokio_reactor"."${deps."tokio_udp"."0.1.3"."tokio_reactor"}" deps)
    ]);
  };
  features_.tokio_udp."0.1.3" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_udp."0.1.3".bytes}".default = true;
    futures."${deps.tokio_udp."0.1.3".futures}".default = true;
    log."${deps.tokio_udp."0.1.3".log}".default = true;
    mio."${deps.tokio_udp."0.1.3".mio}".default = true;
    tokio_codec."${deps.tokio_udp."0.1.3".tokio_codec}".default = true;
    tokio_io."${deps.tokio_udp."0.1.3".tokio_io}".default = true;
    tokio_reactor."${deps.tokio_udp."0.1.3".tokio_reactor}".default = true;
    tokio_udp."0.1.3".default = (f.tokio_udp."0.1.3".default or true);
  }) [
    (features_.bytes."${deps."tokio_udp"."0.1.3"."bytes"}" deps)
    (features_.futures."${deps."tokio_udp"."0.1.3"."futures"}" deps)
    (features_.log."${deps."tokio_udp"."0.1.3"."log"}" deps)
    (features_.mio."${deps."tokio_udp"."0.1.3"."mio"}" deps)
    (features_.tokio_codec."${deps."tokio_udp"."0.1.3"."tokio_codec"}" deps)
    (features_.tokio_io."${deps."tokio_udp"."0.1.3"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio_udp"."0.1.3"."tokio_reactor"}" deps)
  ];


# end
# tokio-uds-0.2.5

  crates.tokio_uds."0.2.5" = deps: { features?(features_.tokio_uds."0.2.5" deps {}) }: buildRustCrate {
    crateName = "tokio-uds";
    version = "0.2.5";
    authors = [ "Carl Lerche <me@carllerche.com>" ];
    sha256 = "1i4d9b4v9a3rza8bi1j2701w6xjvxxdpdaaw2za4h1x9qriq4rv9";
    dependencies = mapFeatures features ([
      (crates."bytes"."${deps."tokio_uds"."0.2.5"."bytes"}" deps)
      (crates."futures"."${deps."tokio_uds"."0.2.5"."futures"}" deps)
      (crates."iovec"."${deps."tokio_uds"."0.2.5"."iovec"}" deps)
      (crates."libc"."${deps."tokio_uds"."0.2.5"."libc"}" deps)
      (crates."log"."${deps."tokio_uds"."0.2.5"."log"}" deps)
      (crates."mio"."${deps."tokio_uds"."0.2.5"."mio"}" deps)
      (crates."mio_uds"."${deps."tokio_uds"."0.2.5"."mio_uds"}" deps)
      (crates."tokio_codec"."${deps."tokio_uds"."0.2.5"."tokio_codec"}" deps)
      (crates."tokio_io"."${deps."tokio_uds"."0.2.5"."tokio_io"}" deps)
      (crates."tokio_reactor"."${deps."tokio_uds"."0.2.5"."tokio_reactor"}" deps)
    ]);
  };
  features_.tokio_uds."0.2.5" = deps: f: updateFeatures f (rec {
    bytes."${deps.tokio_uds."0.2.5".bytes}".default = true;
    futures."${deps.tokio_uds."0.2.5".futures}".default = true;
    iovec."${deps.tokio_uds."0.2.5".iovec}".default = true;
    libc."${deps.tokio_uds."0.2.5".libc}".default = true;
    log."${deps.tokio_uds."0.2.5".log}".default = true;
    mio."${deps.tokio_uds."0.2.5".mio}".default = true;
    mio_uds."${deps.tokio_uds."0.2.5".mio_uds}".default = true;
    tokio_codec."${deps.tokio_uds."0.2.5".tokio_codec}".default = true;
    tokio_io."${deps.tokio_uds."0.2.5".tokio_io}".default = true;
    tokio_reactor."${deps.tokio_uds."0.2.5".tokio_reactor}".default = true;
    tokio_uds."0.2.5".default = (f.tokio_uds."0.2.5".default or true);
  }) [
    (features_.bytes."${deps."tokio_uds"."0.2.5"."bytes"}" deps)
    (features_.futures."${deps."tokio_uds"."0.2.5"."futures"}" deps)
    (features_.iovec."${deps."tokio_uds"."0.2.5"."iovec"}" deps)
    (features_.libc."${deps."tokio_uds"."0.2.5"."libc"}" deps)
    (features_.log."${deps."tokio_uds"."0.2.5"."log"}" deps)
    (features_.mio."${deps."tokio_uds"."0.2.5"."mio"}" deps)
    (features_.mio_uds."${deps."tokio_uds"."0.2.5"."mio_uds"}" deps)
    (features_.tokio_codec."${deps."tokio_uds"."0.2.5"."tokio_codec"}" deps)
    (features_.tokio_io."${deps."tokio_uds"."0.2.5"."tokio_io"}" deps)
    (features_.tokio_reactor."${deps."tokio_uds"."0.2.5"."tokio_reactor"}" deps)
  ];


# end
# toml-0.4.10

  crates.toml."0.4.10" = deps: { features?(features_.toml."0.4.10" deps {}) }: buildRustCrate {
    crateName = "toml";
    version = "0.4.10";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0fs4kxl86w3kmgwcgcv23nk79zagayz1spg281r83w0ywf88d6f1";
    dependencies = mapFeatures features ([
      (crates."serde"."${deps."toml"."0.4.10"."serde"}" deps)
    ]);
  };
  features_.toml."0.4.10" = deps: f: updateFeatures f (rec {
    serde."${deps.toml."0.4.10".serde}".default = true;
    toml."0.4.10".default = (f.toml."0.4.10".default or true);
  }) [
    (features_.serde."${deps."toml"."0.4.10"."serde"}" deps)
  ];


# end
# toml-0.4.8

  crates.toml."0.4.8" = deps: { features?(features_.toml."0.4.8" deps {}) }: buildRustCrate {
    crateName = "toml";
    version = "0.4.8";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1xm3chgsvi3qqi7vj8sb5xvnbfpkqyl4fiwh7y2cl6r4brwlmif1";
    dependencies = mapFeatures features ([
      (crates."serde"."${deps."toml"."0.4.8"."serde"}" deps)
    ]);
  };
  features_.toml."0.4.8" = deps: f: updateFeatures f (rec {
    serde."${deps.toml."0.4.8".serde}".default = true;
    toml."0.4.8".default = (f.toml."0.4.8".default or true);
  }) [
    (features_.serde."${deps."toml"."0.4.8"."serde"}" deps)
  ];


# end
# toml2nix-0.1.1

  crates.toml2nix."0.1.1" = deps: { features?(features_.toml2nix."0.1.1" deps {}) }: buildRustCrate {
    crateName = "toml2nix";
    version = "0.1.1";
    authors = [ "Pierre-Étienne Meunier <pierre-etienne.meunier@inria.fr>" ];
    sha256 = "167qyylp0s76h7r0n99as3jwry5mrn5q1wxh2sdwh51d5qnnw6b2";
    dependencies = mapFeatures features ([
      (crates."toml"."${deps."toml2nix"."0.1.1"."toml"}" deps)
    ]);
  };
  features_.toml2nix."0.1.1" = deps: f: updateFeatures f (rec {
    toml."${deps.toml2nix."0.1.1".toml}".default = true;
    toml2nix."0.1.1".default = (f.toml2nix."0.1.1".default or true);
  }) [
    (features_.toml."${deps."toml2nix"."0.1.1"."toml"}" deps)
  ];


# end
# try-lock-0.2.2

  crates.try_lock."0.2.2" = deps: { features?(features_.try_lock."0.2.2" deps {}) }: buildRustCrate {
    crateName = "try-lock";
    version = "0.2.2";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "1k8xc0jpbrmzp0fwghdh6pwzjb9xx2p8yy0xxnnb8065smc5fsrv";
  };
  features_.try_lock."0.2.2" = deps: f: updateFeatures f (rec {
    try_lock."0.2.2".default = (f.try_lock."0.2.2".default or true);
  }) [];


# end
# typenum-1.10.0

  crates.typenum."1.10.0" = deps: { features?(features_.typenum."1.10.0" deps {}) }: buildRustCrate {
    crateName = "typenum";
    version = "1.10.0";
    authors = [ "Paho Lurie-Gregg <paho@paholg.com>" "Andre Bogus <bogusandre@gmail.com>" ];
    sha256 = "1v2cgg0mlzkg5prs7swysckgk2ay6bpda8m83c2sn3z77dcsx3bc";
    build = "build/main.rs";
    features = mkFeatures (features."typenum"."1.10.0" or {});
  };
  features_.typenum."1.10.0" = deps: f: updateFeatures f (rec {
    typenum."1.10.0".default = (f.typenum."1.10.0".default or true);
  }) [];


# end
# ucd-util-0.1.1

  crates.ucd_util."0.1.1" = deps: { features?(features_.ucd_util."0.1.1" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "02a8h3siipx52b832xc8m8rwasj6nx9jpiwfldw8hp6k205hgkn0";
  };
  features_.ucd_util."0.1.1" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.1".default = (f.ucd_util."0.1.1".default or true);
  }) [];


# end
# ucd-util-0.1.3

  crates.ucd_util."0.1.3" = deps: { features?(features_.ucd_util."0.1.3" deps {}) }: buildRustCrate {
    crateName = "ucd-util";
    version = "0.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1n1qi3jywq5syq90z9qd8qzbn58pcjgv1sx4sdmipm4jf9zanz15";
  };
  features_.ucd_util."0.1.3" = deps: f: updateFeatures f (rec {
    ucd_util."0.1.3".default = (f.ucd_util."0.1.3".default or true);
  }) [];


# end
# unicase-1.4.2

  crates.unicase."1.4.2" = deps: { features?(features_.unicase."1.4.2" deps {}) }: buildRustCrate {
    crateName = "unicase";
    version = "1.4.2";
    authors = [ "Sean McArthur <sean.monstar@gmail.com>" ];
    sha256 = "0rbnhw2mnhcwrij3vczp0sl8zdfmvf2dlh8hly81kj7132kfj0mf";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."unicase"."1.4.2"."version_check"}" deps)
    ]);
    features = mkFeatures (features."unicase"."1.4.2" or {});
  };
  features_.unicase."1.4.2" = deps: f: updateFeatures f (rec {
    unicase = fold recursiveUpdate {} [
      { "1.4.2".default = (f.unicase."1.4.2".default or true); }
      { "1.4.2".heapsize =
        (f.unicase."1.4.2".heapsize or false) ||
        (f.unicase."1.4.2".heap_size or false) ||
        (unicase."1.4.2"."heap_size" or false); }
      { "1.4.2".heapsize_plugin =
        (f.unicase."1.4.2".heapsize_plugin or false) ||
        (f.unicase."1.4.2".heap_size or false) ||
        (unicase."1.4.2"."heap_size" or false); }
    ];
    version_check."${deps.unicase."1.4.2".version_check}".default = true;
  }) [
    (features_.version_check."${deps."unicase"."1.4.2"."version_check"}" deps)
  ];


# end
# unicase-2.3.0

  crates.unicase."2.3.0" = deps: { features?(features_.unicase."2.3.0" deps {}) }: buildRustCrate {
    crateName = "unicase";
    version = "2.3.0";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "10r6kqh11kg3fyjcb5wq7fyn0fdnnrwq07p6lrgqzn9p6wxw7vwc";
    build = "build.rs";

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."unicase"."2.3.0"."version_check"}" deps)
    ]);
    features = mkFeatures (features."unicase"."2.3.0" or {});
  };
  features_.unicase."2.3.0" = deps: f: updateFeatures f (rec {
    unicase."2.3.0".default = (f.unicase."2.3.0".default or true);
    version_check."${deps.unicase."2.3.0".version_check}".default = true;
  }) [
    (features_.version_check."${deps."unicase"."2.3.0"."version_check"}" deps)
  ];


# end
# unicode-bidi-0.3.4

  crates.unicode_bidi."0.3.4" = deps: { features?(features_.unicode_bidi."0.3.4" deps {}) }: buildRustCrate {
    crateName = "unicode-bidi";
    version = "0.3.4";
    authors = [ "The Servo Project Developers" ];
    sha256 = "0lcd6jasrf8p9p0q20qyf10c6xhvw40m2c4rr105hbk6zy26nj1q";
    libName = "unicode_bidi";
    dependencies = mapFeatures features ([
      (crates."matches"."${deps."unicode_bidi"."0.3.4"."matches"}" deps)
    ]);
    features = mkFeatures (features."unicode_bidi"."0.3.4" or {});
  };
  features_.unicode_bidi."0.3.4" = deps: f: updateFeatures f (rec {
    matches."${deps.unicode_bidi."0.3.4".matches}".default = true;
    unicode_bidi = fold recursiveUpdate {} [
      { "0.3.4".default = (f.unicode_bidi."0.3.4".default or true); }
      { "0.3.4".flame =
        (f.unicode_bidi."0.3.4".flame or false) ||
        (f.unicode_bidi."0.3.4".flame_it or false) ||
        (unicode_bidi."0.3.4"."flame_it" or false); }
      { "0.3.4".flamer =
        (f.unicode_bidi."0.3.4".flamer or false) ||
        (f.unicode_bidi."0.3.4".flame_it or false) ||
        (unicode_bidi."0.3.4"."flame_it" or false); }
      { "0.3.4".serde =
        (f.unicode_bidi."0.3.4".serde or false) ||
        (f.unicode_bidi."0.3.4".with_serde or false) ||
        (unicode_bidi."0.3.4"."with_serde" or false); }
    ];
  }) [
    (features_.matches."${deps."unicode_bidi"."0.3.4"."matches"}" deps)
  ];


# end
# unicode-normalization-0.1.7

  crates.unicode_normalization."0.1.7" = deps: { features?(features_.unicode_normalization."0.1.7" deps {}) }: buildRustCrate {
    crateName = "unicode-normalization";
    version = "0.1.7";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "1da2hv800pd0wilmn4idwpgv5p510hjxizjcfv6xzb40xcsjd8gs";
  };
  features_.unicode_normalization."0.1.7" = deps: f: updateFeatures f (rec {
    unicode_normalization."0.1.7".default = (f.unicode_normalization."0.1.7".default or true);
  }) [];


# end
# unicode-normalization-0.1.8

  crates.unicode_normalization."0.1.8" = deps: { features?(features_.unicode_normalization."0.1.8" deps {}) }: buildRustCrate {
    crateName = "unicode-normalization";
    version = "0.1.8";
    authors = [ "kwantam <kwantam@gmail.com>" ];
    sha256 = "1pb26i2xd5zz0icabyqahikpca0iwj2jd4145pczc4bb7p641dsz";
    dependencies = mapFeatures features ([
      (crates."smallvec"."${deps."unicode_normalization"."0.1.8"."smallvec"}" deps)
    ]);
  };
  features_.unicode_normalization."0.1.8" = deps: f: updateFeatures f (rec {
    smallvec."${deps.unicode_normalization."0.1.8".smallvec}".default = true;
    unicode_normalization."0.1.8".default = (f.unicode_normalization."0.1.8".default or true);
  }) [
    (features_.smallvec."${deps."unicode_normalization"."0.1.8"."smallvec"}" deps)
  ];


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
# unicode-xid-0.0.4

  crates.unicode_xid."0.0.4" = deps: { features?(features_.unicode_xid."0.0.4" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.0.4";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "1dc8wkkcd3s6534s5aw4lbjn8m67flkkbnajp5bl8408wdg8rh9v";
    features = mkFeatures (features."unicode_xid"."0.0.4" or {});
  };
  features_.unicode_xid."0.0.4" = deps: f: updateFeatures f (rec {
    unicode_xid."0.0.4".default = (f.unicode_xid."0.0.4".default or true);
  }) [];


# end
# unicode-xid-0.1.0

  crates.unicode_xid."0.1.0" = deps: { features?(features_.unicode_xid."0.1.0" deps {}) }: buildRustCrate {
    crateName = "unicode-xid";
    version = "0.1.0";
    authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
    sha256 = "05wdmwlfzxhq3nhsxn6wx4q8dhxzzfb9szsz6wiw092m1rjj01zj";
    features = mkFeatures (features."unicode_xid"."0.1.0" or {});
  };
  features_.unicode_xid."0.1.0" = deps: f: updateFeatures f (rec {
    unicode_xid."0.1.0".default = (f.unicode_xid."0.1.0".default or true);
  }) [];


# end
# url-1.7.2

  crates.url."1.7.2" = deps: { features?(features_.url."1.7.2" deps {}) }: buildRustCrate {
    crateName = "url";
    version = "1.7.2";
    authors = [ "The rust-url developers" ];
    sha256 = "0qzrjzd9r1niv7037x4cgnv98fs1vj0k18lpxx890ipc47x5gc09";
    dependencies = mapFeatures features ([
      (crates."idna"."${deps."url"."1.7.2"."idna"}" deps)
      (crates."matches"."${deps."url"."1.7.2"."matches"}" deps)
      (crates."percent_encoding"."${deps."url"."1.7.2"."percent_encoding"}" deps)
    ]);
    features = mkFeatures (features."url"."1.7.2" or {});
  };
  features_.url."1.7.2" = deps: f: updateFeatures f (rec {
    idna."${deps.url."1.7.2".idna}".default = true;
    matches."${deps.url."1.7.2".matches}".default = true;
    percent_encoding."${deps.url."1.7.2".percent_encoding}".default = true;
    url = fold recursiveUpdate {} [
      { "1.7.2".default = (f.url."1.7.2".default or true); }
      { "1.7.2".encoding =
        (f.url."1.7.2".encoding or false) ||
        (f.url."1.7.2".query_encoding or false) ||
        (url."1.7.2"."query_encoding" or false); }
      { "1.7.2".heapsize =
        (f.url."1.7.2".heapsize or false) ||
        (f.url."1.7.2".heap_size or false) ||
        (url."1.7.2"."heap_size" or false); }
    ];
  }) [
    (features_.idna."${deps."url"."1.7.2"."idna"}" deps)
    (features_.matches."${deps."url"."1.7.2"."matches"}" deps)
    (features_.percent_encoding."${deps."url"."1.7.2"."percent_encoding"}" deps)
  ];


# end
# utf-8-0.7.5

  crates.utf_8."0.7.5" = deps: { features?(features_.utf_8."0.7.5" deps {}) }: buildRustCrate {
    crateName = "utf-8";
    version = "0.7.5";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "02y7d0ch5zfdy0mailqfb14vcbhr7kw1nsfrs0q9c4bq5g9c10qp";
    libName = "utf8";
  };
  features_.utf_8."0.7.5" = deps: f: updateFeatures f (rec {
    utf_8."0.7.5".default = (f.utf_8."0.7.5".default or true);
  }) [];


# end
# utf8-ranges-1.0.1

  crates.utf8_ranges."1.0.1" = deps: { features?(features_.utf8_ranges."1.0.1" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1s56ihd2c8ba6191078wivvv59247szaiszrh8x2rxqfsxlfrnpp";
  };
  features_.utf8_ranges."1.0.1" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.1".default = (f.utf8_ranges."1.0.1".default or true);
  }) [];


# end
# utf8-ranges-1.0.2

  crates.utf8_ranges."1.0.2" = deps: { features?(features_.utf8_ranges."1.0.2" deps {}) }: buildRustCrate {
    crateName = "utf8-ranges";
    version = "1.0.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1my02laqsgnd8ib4dvjgd4rilprqjad6pb9jj9vi67csi5qs2281";
  };
  features_.utf8_ranges."1.0.2" = deps: f: updateFeatures f (rec {
    utf8_ranges."1.0.2".default = (f.utf8_ranges."1.0.2".default or true);
  }) [];


# end
# uuid-0.7.2

  crates.uuid."0.7.2" = deps: { features?(features_.uuid."0.7.2" deps {}) }: buildRustCrate {
    crateName = "uuid";
    version = "0.7.2";
    authors = [ "Ashley Mannix<ashleymannix@live.com.au>" "Christopher Armstrong" "Dylan DPC<dylan.dpc@gmail.com>" "Hunar Roop Kahlon<hunar.roop@gmail.com>" ];
    sha256 = "0jz5awsbncf2z6gx55h9y4y5x1ziyjgag8x6flzl5fqrw5fwfdym";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.uuid."0.7.2".rand or false then [ (crates.rand."${deps."uuid"."0.7.2".rand}" deps) ] else [])
      ++ (if features.uuid."0.7.2".serde or false then [ (crates.serde."${deps."uuid"."0.7.2".serde}" deps) ] else []));
    features = mkFeatures (features."uuid"."0.7.2" or {});
  };
  features_.uuid."0.7.2" = deps: f: updateFeatures f (rec {
    rand = fold recursiveUpdate {} [
      { "${deps.uuid."0.7.2".rand}"."stdweb" =
        (f.rand."${deps.uuid."0.7.2".rand}"."stdweb" or false) ||
        (uuid."0.7.2"."stdweb" or false) ||
        (f."uuid"."0.7.2"."stdweb" or false); }
      { "${deps.uuid."0.7.2".rand}"."wasm-bindgen" =
        (f.rand."${deps.uuid."0.7.2".rand}"."wasm-bindgen" or false) ||
        (uuid."0.7.2"."wasm-bindgen" or false) ||
        (f."uuid"."0.7.2"."wasm-bindgen" or false); }
      { "${deps.uuid."0.7.2".rand}".default = true; }
    ];
    serde."${deps.uuid."0.7.2".serde}".default = (f.serde."${deps.uuid."0.7.2".serde}".default or false);
    uuid = fold recursiveUpdate {} [
      { "0.7.2".byteorder =
        (f.uuid."0.7.2".byteorder or false) ||
        (f.uuid."0.7.2".u128 or false) ||
        (uuid."0.7.2"."u128" or false); }
      { "0.7.2".default = (f.uuid."0.7.2".default or true); }
      { "0.7.2".md5 =
        (f.uuid."0.7.2".md5 or false) ||
        (f.uuid."0.7.2".v3 or false) ||
        (uuid."0.7.2"."v3" or false); }
      { "0.7.2".nightly =
        (f.uuid."0.7.2".nightly or false) ||
        (f.uuid."0.7.2".const_fn or false) ||
        (uuid."0.7.2"."const_fn" or false); }
      { "0.7.2".rand =
        (f.uuid."0.7.2".rand or false) ||
        (f.uuid."0.7.2".v3 or false) ||
        (uuid."0.7.2"."v3" or false) ||
        (f.uuid."0.7.2".v4 or false) ||
        (uuid."0.7.2"."v4" or false) ||
        (f.uuid."0.7.2".v5 or false) ||
        (uuid."0.7.2"."v5" or false); }
      { "0.7.2".sha1 =
        (f.uuid."0.7.2".sha1 or false) ||
        (f.uuid."0.7.2".v5 or false) ||
        (uuid."0.7.2"."v5" or false); }
      { "0.7.2".std =
        (f.uuid."0.7.2".std or false) ||
        (f.uuid."0.7.2".default or false) ||
        (uuid."0.7.2"."default" or false); }
      { "0.7.2".winapi =
        (f.uuid."0.7.2".winapi or false) ||
        (f.uuid."0.7.2".guid or false) ||
        (uuid."0.7.2"."guid" or false); }
    ];
  }) [
    (features_.rand."${deps."uuid"."0.7.2"."rand"}" deps)
    (features_.serde."${deps."uuid"."0.7.2"."serde"}" deps)
  ];


# end
# v_escape-0.7.2

  crates.v_escape."0.7.2" = deps: { features?(features_.v_escape."0.7.2" deps {}) }: buildRustCrate {
    crateName = "v_escape";
    version = "0.7.2";
    authors = [ "Rust-iendo Barcelona <riendocontributions@gmail.com>" ];
    edition = "2018";
    sha256 = "05rhxmk2mzf1pcna4idilmhdqp95vdy2k3ixx7iqgncjidxkaiaw";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."v_escape_derive"."${deps."v_escape"."0.7.2"."v_escape_derive"}" deps)
      (crates."version_check"."${deps."v_escape"."0.7.2"."version_check"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."version_check"."${deps."v_escape"."0.7.2"."version_check"}" deps)
    ]);
  };
  features_.v_escape."0.7.2" = deps: f: updateFeatures f (rec {
    v_escape."0.7.2".default = (f.v_escape."0.7.2".default or true);
    v_escape_derive."${deps.v_escape."0.7.2".v_escape_derive}".default = true;
    version_check."${deps.v_escape."0.7.2".version_check}".default = true;
  }) [
    (features_.v_escape_derive."${deps."v_escape"."0.7.2"."v_escape_derive"}" deps)
    (features_.version_check."${deps."v_escape"."0.7.2"."version_check"}" deps)
    (features_.version_check."${deps."v_escape"."0.7.2"."version_check"}" deps)
  ];


# end
# v_escape_derive-0.5.3

  crates.v_escape_derive."0.5.3" = deps: { features?(features_.v_escape_derive."0.5.3" deps {}) }: buildRustCrate {
    crateName = "v_escape_derive";
    version = "0.5.3";
    authors = [ "Rust-iendo Barcelona <riendocontributions@gmail.com>" ];
    edition = "2018";
    sha256 = "0wgyvapii8bnz2g52i3al5vycbiplr62bfmvlv2pplrj9ff40pv3";
    libPath = "src/lib.rs";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."nom"."${deps."v_escape_derive"."0.5.3"."nom"}" deps)
      (crates."proc_macro2"."${deps."v_escape_derive"."0.5.3"."proc_macro2"}" deps)
      (crates."quote"."${deps."v_escape_derive"."0.5.3"."quote"}" deps)
      (crates."syn"."${deps."v_escape_derive"."0.5.3"."syn"}" deps)
    ]);
  };
  features_.v_escape_derive."0.5.3" = deps: f: updateFeatures f (rec {
    nom."${deps.v_escape_derive."0.5.3".nom}".default = true;
    proc_macro2."${deps.v_escape_derive."0.5.3".proc_macro2}".default = true;
    quote."${deps.v_escape_derive."0.5.3".quote}".default = true;
    syn."${deps.v_escape_derive."0.5.3".syn}".default = true;
    v_escape_derive."0.5.3".default = (f.v_escape_derive."0.5.3".default or true);
  }) [
    (features_.nom."${deps."v_escape_derive"."0.5.3"."nom"}" deps)
    (features_.proc_macro2."${deps."v_escape_derive"."0.5.3"."proc_macro2"}" deps)
    (features_.quote."${deps."v_escape_derive"."0.5.3"."quote"}" deps)
    (features_.syn."${deps."v_escape_derive"."0.5.3"."syn"}" deps)
  ];


# end
# v_htmlescape-0.4.3

  crates.v_htmlescape."0.4.3" = deps: { features?(features_.v_htmlescape."0.4.3" deps {}) }: buildRustCrate {
    crateName = "v_htmlescape";
    version = "0.4.3";
    authors = [ "Rust-iendo Barcelona <riendocontributions@gmail.com>" ];
    edition = "2018";
    sha256 = "09vma0ydjnah6j7d2s7yahx6bqri54pmxj84sv9wmggnidg3d0qx";
    libPath = "src/lib.rs";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."v_htmlescape"."0.4.3"."cfg_if"}" deps)
      (crates."v_escape"."${deps."v_htmlescape"."0.4.3"."v_escape"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."v_escape"."${deps."v_htmlescape"."0.4.3"."v_escape"}" deps)
    ]);
  };
  features_.v_htmlescape."0.4.3" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.v_htmlescape."0.4.3".cfg_if}".default = true;
    v_escape."${deps.v_htmlescape."0.4.3".v_escape}".default = true;
    v_htmlescape."0.4.3".default = (f.v_htmlescape."0.4.3".default or true);
  }) [
    (features_.cfg_if."${deps."v_htmlescape"."0.4.3"."cfg_if"}" deps)
    (features_.v_escape."${deps."v_htmlescape"."0.4.3"."v_escape"}" deps)
    (features_.v_escape."${deps."v_htmlescape"."0.4.3"."v_escape"}" deps)
  ];


# end
# vcpkg-0.2.6

  crates.vcpkg."0.2.6" = deps: { features?(features_.vcpkg."0.2.6" deps {}) }: buildRustCrate {
    crateName = "vcpkg";
    version = "0.2.6";
    authors = [ "Jim McGrath <jimmc2@gmail.com>" ];
    sha256 = "1ig6jqpzzl1z9vk4qywgpfr4hfbd8ny8frqsgm3r449wkc4n1i5x";
  };
  features_.vcpkg."0.2.6" = deps: f: updateFeatures f (rec {
    vcpkg."0.2.6".default = (f.vcpkg."0.2.6".default or true);
  }) [];


# end
# vec_map-0.8.1

  crates.vec_map."0.8.1" = deps: { features?(features_.vec_map."0.8.1" deps {}) }: buildRustCrate {
    crateName = "vec_map";
    version = "0.8.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
    sha256 = "1jj2nrg8h3l53d43rwkpkikq5a5x15ms4rf1rw92hp5lrqhi8mpi";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."vec_map"."0.8.1" or {});
  };
  features_.vec_map."0.8.1" = deps: f: updateFeatures f (rec {
    vec_map = fold recursiveUpdate {} [
      { "0.8.1".default = (f.vec_map."0.8.1".default or true); }
      { "0.8.1".serde =
        (f.vec_map."0.8.1".serde or false) ||
        (f.vec_map."0.8.1".eders or false) ||
        (vec_map."0.8.1"."eders" or false); }
    ];
  }) [];


# end
# version_check-0.1.5

  crates.version_check."0.1.5" = deps: { features?(features_.version_check."0.1.5" deps {}) }: buildRustCrate {
    crateName = "version_check";
    version = "0.1.5";
    authors = [ "Sergio Benitez <sb@sergio.bz>" ];
    sha256 = "1yrx9xblmwbafw2firxyqbj8f771kkzfd24n3q7xgwiqyhi0y8qd";
  };
  features_.version_check."0.1.5" = deps: f: updateFeatures f (rec {
    version_check."0.1.5".default = (f.version_check."0.1.5".default or true);
  }) [];


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
# walkdir-2.2.7

  crates.walkdir."2.2.7" = deps: { features?(features_.walkdir."2.2.7" deps {}) }: buildRustCrate {
    crateName = "walkdir";
    version = "2.2.7";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0wq3v28916kkla29yyi0g0xfc16apwx24py68049kriz3gjlig03";
    dependencies = mapFeatures features ([
      (crates."same_file"."${deps."walkdir"."2.2.7"."same_file"}" deps)
    ])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."walkdir"."2.2.7"."winapi"}" deps)
      (crates."winapi_util"."${deps."walkdir"."2.2.7"."winapi_util"}" deps)
    ]) else []);
  };
  features_.walkdir."2.2.7" = deps: f: updateFeatures f (rec {
    same_file."${deps.walkdir."2.2.7".same_file}".default = true;
    walkdir."2.2.7".default = (f.walkdir."2.2.7".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.walkdir."2.2.7".winapi}"."std" = true; }
      { "${deps.walkdir."2.2.7".winapi}"."winnt" = true; }
      { "${deps.walkdir."2.2.7".winapi}".default = true; }
    ];
    winapi_util."${deps.walkdir."2.2.7".winapi_util}".default = true;
  }) [
    (features_.same_file."${deps."walkdir"."2.2.7"."same_file"}" deps)
    (features_.winapi."${deps."walkdir"."2.2.7"."winapi"}" deps)
    (features_.winapi_util."${deps."walkdir"."2.2.7"."winapi_util"}" deps)
  ];


# end
# want-0.0.6

  crates.want."0.0.6" = deps: { features?(features_.want."0.0.6" deps {}) }: buildRustCrate {
    crateName = "want";
    version = "0.0.6";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "03cc2lndz531a4kgql1v9kppyb1yz2abcz5l52j1gg2nypmy3lh8";
    dependencies = mapFeatures features ([
      (crates."futures"."${deps."want"."0.0.6"."futures"}" deps)
      (crates."log"."${deps."want"."0.0.6"."log"}" deps)
      (crates."try_lock"."${deps."want"."0.0.6"."try_lock"}" deps)
    ]);
  };
  features_.want."0.0.6" = deps: f: updateFeatures f (rec {
    futures."${deps.want."0.0.6".futures}".default = true;
    log."${deps.want."0.0.6".log}".default = true;
    try_lock."${deps.want."0.0.6".try_lock}".default = true;
    want."0.0.6".default = (f.want."0.0.6".default or true);
  }) [
    (features_.futures."${deps."want"."0.0.6"."futures"}" deps)
    (features_.log."${deps."want"."0.0.6"."log"}" deps)
    (features_.try_lock."${deps."want"."0.0.6"."try_lock"}" deps)
  ];


# end
# which-1.0.5

  crates.which."1.0.5" = deps: { features?(features_.which."1.0.5" deps {}) }: buildRustCrate {
    crateName = "which";
    version = "1.0.5";
    authors = [ "fangyuanziti <tiziyuanfang@gmail.com>" ];
    sha256 = "1xv34mrbbafmir51c5k7dkgnpk299aga64dx71p6ijzhl14612qj";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."which"."1.0.5"."libc"}" deps)
    ]);
  };
  features_.which."1.0.5" = deps: f: updateFeatures f (rec {
    libc."${deps.which."1.0.5".libc}".default = true;
    which."1.0.5".default = (f.which."1.0.5".default or true);
  }) [
    (features_.libc."${deps."which"."1.0.5"."libc"}" deps)
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
# winapi-util-0.1.1

  crates.winapi_util."0.1.1" = deps: { features?(features_.winapi_util."0.1.1" deps {}) }: buildRustCrate {
    crateName = "winapi-util";
    version = "0.1.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "10madanla73aagbklx6y73r2g2vwq9w8a0qcghbbbpn9vfr6a95f";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."winapi_util"."0.1.1"."winapi"}" deps)
    ]) else []);
  };
  features_.winapi_util."0.1.1" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "${deps.winapi_util."0.1.1".winapi}"."consoleapi" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."errhandlingapi" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."fileapi" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."minwindef" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."processenv" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."std" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."winbase" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."wincon" = true; }
      { "${deps.winapi_util."0.1.1".winapi}"."winerror" = true; }
      { "${deps.winapi_util."0.1.1".winapi}".default = true; }
    ];
    winapi_util."0.1.1".default = (f.winapi_util."0.1.1".default or true);
  }) [
    (features_.winapi."${deps."winapi_util"."0.1.1"."winapi"}" deps)
  ];


# end
# winapi-util-0.1.2

  crates.winapi_util."0.1.2" = deps: { features?(features_.winapi_util."0.1.2" deps {}) }: buildRustCrate {
    crateName = "winapi-util";
    version = "0.1.2";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "07jj7rg7nndd7bqhjin1xphbv8kb5clvhzpqpxkvm3wl84r3mj1h";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."winapi_util"."0.1.2"."winapi"}" deps)
    ]) else []);
  };
  features_.winapi_util."0.1.2" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "${deps.winapi_util."0.1.2".winapi}"."consoleapi" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."errhandlingapi" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."fileapi" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."minwindef" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."processenv" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."std" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."winbase" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."wincon" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."winerror" = true; }
      { "${deps.winapi_util."0.1.2".winapi}"."winnt" = true; }
      { "${deps.winapi_util."0.1.2".winapi}".default = true; }
    ];
    winapi_util."0.1.2".default = (f.winapi_util."0.1.2".default or true);
  }) [
    (features_.winapi."${deps."winapi_util"."0.1.2"."winapi"}" deps)
  ];


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
# wincolor-1.0.1

  crates.wincolor."1.0.1" = deps: { features?(features_.wincolor."1.0.1" deps {}) }: buildRustCrate {
    crateName = "wincolor";
    version = "1.0.1";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "0gr7v4krmjba7yq16071rfacz42qbapas7mxk5nphjwb042a8gvz";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."wincolor"."1.0.1"."winapi"}" deps)
      (crates."winapi_util"."${deps."wincolor"."1.0.1"."winapi_util"}" deps)
    ]);
  };
  features_.wincolor."1.0.1" = deps: f: updateFeatures f (rec {
    winapi = fold recursiveUpdate {} [
      { "${deps.wincolor."1.0.1".winapi}"."minwindef" = true; }
      { "${deps.wincolor."1.0.1".winapi}"."wincon" = true; }
      { "${deps.wincolor."1.0.1".winapi}".default = true; }
    ];
    winapi_util."${deps.wincolor."1.0.1".winapi_util}".default = true;
    wincolor."1.0.1".default = (f.wincolor."1.0.1".default or true);
  }) [
    (features_.winapi."${deps."wincolor"."1.0.1"."winapi"}" deps)
    (features_.winapi_util."${deps."wincolor"."1.0.1"."winapi_util"}" deps)
  ];


# end
# ws2_32-sys-0.2.1

  crates.ws2_32_sys."0.2.1" = deps: { features?(features_.ws2_32_sys."0.2.1" deps {}) }: buildRustCrate {
    crateName = "ws2_32-sys";
    version = "0.2.1";
    authors = [ "Peter Atashian <retep998@gmail.com>" ];
    sha256 = "1zpy9d9wk11sj17fczfngcj28w4xxjs3b4n036yzpy38dxp4f7kc";
    libName = "ws2_32";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."winapi"."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."winapi_build"."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
    ]);
  };
  features_.ws2_32_sys."0.2.1" = deps: f: updateFeatures f (rec {
    winapi."${deps.ws2_32_sys."0.2.1".winapi}".default = true;
    winapi_build."${deps.ws2_32_sys."0.2.1".winapi_build}".default = true;
    ws2_32_sys."0.2.1".default = (f.ws2_32_sys."0.2.1".default or true);
  }) [
    (features_.winapi."${deps."ws2_32_sys"."0.2.1"."winapi"}" deps)
    (features_.winapi_build."${deps."ws2_32_sys"."0.2.1"."winapi_build"}" deps)
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
# yasna-0.1.3

  crates.yasna."0.1.3" = deps: { features?(features_.yasna."0.1.3" deps {}) }: buildRustCrate {
    crateName = "yasna";
    version = "0.1.3";
    authors = [ "Masaki Hara <ackie.h.gmai@gmail.com>" ];
    sha256 = "0zixv2vkq146nb8x1i0zrfsrvc19m5pb7rv8j9qq01cglrpw7rhf";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.yasna."0.1.3".bit-vec or false then [ (crates.bit_vec."${deps."yasna"."0.1.3".bit_vec}" deps) ] else [])
      ++ (if features.yasna."0.1.3".num or false then [ (crates.num."${deps."yasna"."0.1.3".num}" deps) ] else []));
    features = mkFeatures (features."yasna"."0.1.3" or {});
  };
  features_.yasna."0.1.3" = deps: f: updateFeatures f (rec {
    bit_vec."${deps.yasna."0.1.3".bit_vec}".default = true;
    num = fold recursiveUpdate {} [
      { "${deps.yasna."0.1.3".num}"."bigint" = true; }
      { "${deps.yasna."0.1.3".num}".default = true; }
    ];
    yasna = fold recursiveUpdate {} [
      { "0.1.3".bigint =
        (f.yasna."0.1.3".bigint or false) ||
        (f.yasna."0.1.3".default or false) ||
        (yasna."0.1.3"."default" or false); }
      { "0.1.3".bit-vec =
        (f.yasna."0.1.3".bit-vec or false) ||
        (f.yasna."0.1.3".bitvec or false) ||
        (yasna."0.1.3"."bitvec" or false); }
      { "0.1.3".bitvec =
        (f.yasna."0.1.3".bitvec or false) ||
        (f.yasna."0.1.3".default or false) ||
        (yasna."0.1.3"."default" or false); }
      { "0.1.3".default = (f.yasna."0.1.3".default or true); }
      { "0.1.3".num =
        (f.yasna."0.1.3".num or false) ||
        (f.yasna."0.1.3".bigint or false) ||
        (yasna."0.1.3"."bigint" or false); }
    ];
  }) [
    (features_.bit_vec."${deps."yasna"."0.1.3"."bit_vec"}" deps)
    (features_.num."${deps."yasna"."0.1.3"."num"}" deps)
  ];


# end
}

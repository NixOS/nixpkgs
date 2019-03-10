{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {

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
# aho-corasick-0.6.9

  crates.aho_corasick."0.6.9" = deps: { features?(features_.aho_corasick."0.6.9" deps {}) }: buildRustCrate {
    crateName = "aho-corasick";
    version = "0.6.9";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
    sha256 = "1lj20py6bvw3y7m9n2nqh0mkshfl1kjfp72lfika9gpkrp2r204l";
    libName = "aho_corasick";
    crateBin =
      [{  name = "aho-corasick-dot";  path = "src/main.rs"; }];
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."aho_corasick"."0.6.9"."memchr"}" deps)
    ]);
  };
  features_.aho_corasick."0.6.9" = deps: f: updateFeatures f (rec {
    aho_corasick."0.6.9".default = (f.aho_corasick."0.6.9".default or true);
    memchr."${deps.aho_corasick."0.6.9".memchr}".default = true;
  }) [
    (features_.memchr."${deps."aho_corasick"."0.6.9"."memchr"}" deps)
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
# backtrace-0.3.13

  crates.backtrace."0.3.13" = deps: { features?(features_.backtrace."0.3.13" deps {}) }: buildRustCrate {
    crateName = "backtrace";
    version = "0.3.13";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
    sha256 = "1xx0vjdih9zqj6vp8l69n0f213wmif5471prgpkp24jbzxndvb1v";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."backtrace"."0.3.13"."cfg_if"}" deps)
      (crates."rustc_demangle"."${deps."backtrace"."0.3.13"."rustc_demangle"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then mapFeatures features ([
    ]
      ++ (if features.backtrace."0.3.13".backtrace-sys or false then [ (crates.backtrace_sys."${deps."backtrace"."0.3.13".backtrace_sys}" deps) ] else [])) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."backtrace"."0.3.13"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."backtrace"."0.3.13"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."autocfg"."${deps."backtrace"."0.3.13"."autocfg"}" deps)
    ]);
    features = mkFeatures (features."backtrace"."0.3.13" or {});
  };
  features_.backtrace."0.3.13" = deps: f: updateFeatures f (rec {
    autocfg."${deps.backtrace."0.3.13".autocfg}".default = true;
    backtrace = fold recursiveUpdate {} [
      { "0.3.13".addr2line =
        (f.backtrace."0.3.13".addr2line or false) ||
        (f.backtrace."0.3.13".gimli-symbolize or false) ||
        (backtrace."0.3.13"."gimli-symbolize" or false); }
      { "0.3.13".backtrace-sys =
        (f.backtrace."0.3.13".backtrace-sys or false) ||
        (f.backtrace."0.3.13".libbacktrace or false) ||
        (backtrace."0.3.13"."libbacktrace" or false); }
      { "0.3.13".coresymbolication =
        (f.backtrace."0.3.13".coresymbolication or false) ||
        (f.backtrace."0.3.13".default or false) ||
        (backtrace."0.3.13"."default" or false); }
      { "0.3.13".dbghelp =
        (f.backtrace."0.3.13".dbghelp or false) ||
        (f.backtrace."0.3.13".default or false) ||
        (backtrace."0.3.13"."default" or false); }
      { "0.3.13".default = (f.backtrace."0.3.13".default or true); }
      { "0.3.13".dladdr =
        (f.backtrace."0.3.13".dladdr or false) ||
        (f.backtrace."0.3.13".default or false) ||
        (backtrace."0.3.13"."default" or false); }
      { "0.3.13".findshlibs =
        (f.backtrace."0.3.13".findshlibs or false) ||
        (f.backtrace."0.3.13".gimli-symbolize or false) ||
        (backtrace."0.3.13"."gimli-symbolize" or false); }
      { "0.3.13".gimli =
        (f.backtrace."0.3.13".gimli or false) ||
        (f.backtrace."0.3.13".gimli-symbolize or false) ||
        (backtrace."0.3.13"."gimli-symbolize" or false); }
      { "0.3.13".libbacktrace =
        (f.backtrace."0.3.13".libbacktrace or false) ||
        (f.backtrace."0.3.13".default or false) ||
        (backtrace."0.3.13"."default" or false); }
      { "0.3.13".libunwind =
        (f.backtrace."0.3.13".libunwind or false) ||
        (f.backtrace."0.3.13".default or false) ||
        (backtrace."0.3.13"."default" or false); }
      { "0.3.13".memmap =
        (f.backtrace."0.3.13".memmap or false) ||
        (f.backtrace."0.3.13".gimli-symbolize or false) ||
        (backtrace."0.3.13"."gimli-symbolize" or false); }
      { "0.3.13".object =
        (f.backtrace."0.3.13".object or false) ||
        (f.backtrace."0.3.13".gimli-symbolize or false) ||
        (backtrace."0.3.13"."gimli-symbolize" or false); }
      { "0.3.13".rustc-serialize =
        (f.backtrace."0.3.13".rustc-serialize or false) ||
        (f.backtrace."0.3.13".serialize-rustc or false) ||
        (backtrace."0.3.13"."serialize-rustc" or false); }
      { "0.3.13".serde =
        (f.backtrace."0.3.13".serde or false) ||
        (f.backtrace."0.3.13".serialize-serde or false) ||
        (backtrace."0.3.13"."serialize-serde" or false); }
      { "0.3.13".serde_derive =
        (f.backtrace."0.3.13".serde_derive or false) ||
        (f.backtrace."0.3.13".serialize-serde or false) ||
        (backtrace."0.3.13"."serialize-serde" or false); }
      { "0.3.13".std =
        (f.backtrace."0.3.13".std or false) ||
        (f.backtrace."0.3.13".default or false) ||
        (backtrace."0.3.13"."default" or false) ||
        (f.backtrace."0.3.13".libbacktrace or false) ||
        (backtrace."0.3.13"."libbacktrace" or false); }
    ];
    backtrace_sys."${deps.backtrace."0.3.13".backtrace_sys}".default = true;
    cfg_if."${deps.backtrace."0.3.13".cfg_if}".default = true;
    libc."${deps.backtrace."0.3.13".libc}".default = (f.libc."${deps.backtrace."0.3.13".libc}".default or false);
    rustc_demangle."${deps.backtrace."0.3.13".rustc_demangle}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.backtrace."0.3.13".winapi}"."dbghelp" = true; }
      { "${deps.backtrace."0.3.13".winapi}"."minwindef" = true; }
      { "${deps.backtrace."0.3.13".winapi}"."processthreadsapi" = true; }
      { "${deps.backtrace."0.3.13".winapi}"."winnt" = true; }
      { "${deps.backtrace."0.3.13".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."backtrace"."0.3.13"."cfg_if"}" deps)
    (features_.rustc_demangle."${deps."backtrace"."0.3.13"."rustc_demangle"}" deps)
    (features_.autocfg."${deps."backtrace"."0.3.13"."autocfg"}" deps)
    (features_.backtrace_sys."${deps."backtrace"."0.3.13"."backtrace_sys"}" deps)
    (features_.libc."${deps."backtrace"."0.3.13"."libc"}" deps)
    (features_.winapi."${deps."backtrace"."0.3.13"."winapi"}" deps)
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
# bytesize-1.0.0

  crates.bytesize."1.0.0" = deps: { features?(features_.bytesize."1.0.0" deps {}) }: buildRustCrate {
    crateName = "bytesize";
    version = "1.0.0";
    authors = [ "Hyunsik Choi <hyunsik.choi@gmail.com>" ];
    sha256 = "04j5hibh1sskjbifrm5d10vmd1fycfgm10cdfa9hpyir7lbkhbg9";
    dependencies = mapFeatures features ([
]);
  };
  features_.bytesize."1.0.0" = deps: f: updateFeatures f (rec {
    bytesize."1.0.0".default = (f.bytesize."1.0.0".default or true);
  }) [];


# end
# cargo-0.33.0

  crates.cargo."0.33.0" = deps: { features?(features_.cargo."0.33.0" deps {}) }: buildRustCrate {
    crateName = "cargo";
    version = "0.33.0";
    authors = [ "Yehuda Katz <wycats@gmail.com>" "Carl Lerche <me@carllerche.com>" "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0ygqv1m5j4isr6cfn5fs3g2d6srb9cn8n5rivrsgfa7k45lxbwfq";
    libPath = "src/cargo/lib.rs";
    crateBin =
      [{  name = "cargo"; }];
    dependencies = mapFeatures features ([
      (crates."atty"."${deps."cargo"."0.33.0"."atty"}" deps)
      (crates."bytesize"."${deps."cargo"."0.33.0"."bytesize"}" deps)
      (crates."clap"."${deps."cargo"."0.33.0"."clap"}" deps)
      (crates."crates_io"."${deps."cargo"."0.33.0"."crates_io"}" deps)
      (crates."crossbeam_utils"."${deps."cargo"."0.33.0"."crossbeam_utils"}" deps)
      (crates."crypto_hash"."${deps."cargo"."0.33.0"."crypto_hash"}" deps)
      (crates."curl"."${deps."cargo"."0.33.0"."curl"}" deps)
      (crates."curl_sys"."${deps."cargo"."0.33.0"."curl_sys"}" deps)
      (crates."env_logger"."${deps."cargo"."0.33.0"."env_logger"}" deps)
      (crates."failure"."${deps."cargo"."0.33.0"."failure"}" deps)
      (crates."filetime"."${deps."cargo"."0.33.0"."filetime"}" deps)
      (crates."flate2"."${deps."cargo"."0.33.0"."flate2"}" deps)
      (crates."fs2"."${deps."cargo"."0.33.0"."fs2"}" deps)
      (crates."git2"."${deps."cargo"."0.33.0"."git2"}" deps)
      (crates."git2_curl"."${deps."cargo"."0.33.0"."git2_curl"}" deps)
      (crates."glob"."${deps."cargo"."0.33.0"."glob"}" deps)
      (crates."hex"."${deps."cargo"."0.33.0"."hex"}" deps)
      (crates."home"."${deps."cargo"."0.33.0"."home"}" deps)
      (crates."ignore"."${deps."cargo"."0.33.0"."ignore"}" deps)
      (crates."im_rc"."${deps."cargo"."0.33.0"."im_rc"}" deps)
      (crates."jobserver"."${deps."cargo"."0.33.0"."jobserver"}" deps)
      (crates."lazy_static"."${deps."cargo"."0.33.0"."lazy_static"}" deps)
      (crates."lazycell"."${deps."cargo"."0.33.0"."lazycell"}" deps)
      (crates."libc"."${deps."cargo"."0.33.0"."libc"}" deps)
      (crates."libgit2_sys"."${deps."cargo"."0.33.0"."libgit2_sys"}" deps)
      (crates."log"."${deps."cargo"."0.33.0"."log"}" deps)
      (crates."num_cpus"."${deps."cargo"."0.33.0"."num_cpus"}" deps)
      (crates."opener"."${deps."cargo"."0.33.0"."opener"}" deps)
      (crates."rustc_workspace_hack"."${deps."cargo"."0.33.0"."rustc_workspace_hack"}" deps)
      (crates."rustfix"."${deps."cargo"."0.33.0"."rustfix"}" deps)
      (crates."same_file"."${deps."cargo"."0.33.0"."same_file"}" deps)
      (crates."semver"."${deps."cargo"."0.33.0"."semver"}" deps)
      (crates."serde"."${deps."cargo"."0.33.0"."serde"}" deps)
      (crates."serde_derive"."${deps."cargo"."0.33.0"."serde_derive"}" deps)
      (crates."serde_ignored"."${deps."cargo"."0.33.0"."serde_ignored"}" deps)
      (crates."serde_json"."${deps."cargo"."0.33.0"."serde_json"}" deps)
      (crates."shell_escape"."${deps."cargo"."0.33.0"."shell_escape"}" deps)
      (crates."tar"."${deps."cargo"."0.33.0"."tar"}" deps)
      (crates."tempfile"."${deps."cargo"."0.33.0"."tempfile"}" deps)
      (crates."termcolor"."${deps."cargo"."0.33.0"."termcolor"}" deps)
      (crates."toml"."${deps."cargo"."0.33.0"."toml"}" deps)
      (crates."unicode_width"."${deps."cargo"."0.33.0"."unicode_width"}" deps)
      (crates."url"."${deps."cargo"."0.33.0"."url"}" deps)
    ])
      ++ (if kernel == "darwin" then mapFeatures features ([
      (crates."core_foundation"."${deps."cargo"."0.33.0"."core_foundation"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."fwdansi"."${deps."cargo"."0.33.0"."fwdansi"}" deps)
      (crates."miow"."${deps."cargo"."0.33.0"."miow"}" deps)
      (crates."winapi"."${deps."cargo"."0.33.0"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."cargo"."0.33.0" or {});
  };
  features_.cargo."0.33.0" = deps: f: updateFeatures f (rec {
    atty."${deps.cargo."0.33.0".atty}".default = true;
    bytesize."${deps.cargo."0.33.0".bytesize}".default = true;
    cargo = fold recursiveUpdate {} [
      { "0.33.0".default = (f.cargo."0.33.0".default or true); }
      { "0.33.0".pretty_env_logger =
        (f.cargo."0.33.0".pretty_env_logger or false) ||
        (f.cargo."0.33.0".pretty-env-logger or false) ||
        (cargo."0.33.0"."pretty-env-logger" or false); }
    ];
    clap."${deps.cargo."0.33.0".clap}".default = true;
    core_foundation = fold recursiveUpdate {} [
      { "${deps.cargo."0.33.0".core_foundation}"."mac_os_10_7_support" = true; }
      { "${deps.cargo."0.33.0".core_foundation}".default = true; }
    ];
    crates_io."${deps.cargo."0.33.0".crates_io}".default = true;
    crossbeam_utils."${deps.cargo."0.33.0".crossbeam_utils}".default = true;
    crypto_hash."${deps.cargo."0.33.0".crypto_hash}".default = true;
    curl = fold recursiveUpdate {} [
      { "${deps.cargo."0.33.0".curl}"."http2" = true; }
      { "${deps.cargo."0.33.0".curl}".default = true; }
    ];
    curl_sys."${deps.cargo."0.33.0".curl_sys}".default = true;
    env_logger."${deps.cargo."0.33.0".env_logger}".default = true;
    failure."${deps.cargo."0.33.0".failure}".default = true;
    filetime."${deps.cargo."0.33.0".filetime}".default = true;
    flate2 = fold recursiveUpdate {} [
      { "${deps.cargo."0.33.0".flate2}"."zlib" = true; }
      { "${deps.cargo."0.33.0".flate2}".default = true; }
    ];
    fs2."${deps.cargo."0.33.0".fs2}".default = true;
    fwdansi."${deps.cargo."0.33.0".fwdansi}".default = true;
    git2."${deps.cargo."0.33.0".git2}".default = true;
    git2_curl."${deps.cargo."0.33.0".git2_curl}".default = true;
    glob."${deps.cargo."0.33.0".glob}".default = true;
    hex."${deps.cargo."0.33.0".hex}".default = true;
    home."${deps.cargo."0.33.0".home}".default = true;
    ignore."${deps.cargo."0.33.0".ignore}".default = true;
    im_rc."${deps.cargo."0.33.0".im_rc}".default = true;
    jobserver."${deps.cargo."0.33.0".jobserver}".default = true;
    lazy_static."${deps.cargo."0.33.0".lazy_static}".default = true;
    lazycell."${deps.cargo."0.33.0".lazycell}".default = true;
    libc."${deps.cargo."0.33.0".libc}".default = true;
    libgit2_sys."${deps.cargo."0.33.0".libgit2_sys}".default = true;
    log."${deps.cargo."0.33.0".log}".default = true;
    miow."${deps.cargo."0.33.0".miow}".default = true;
    num_cpus."${deps.cargo."0.33.0".num_cpus}".default = true;
    opener."${deps.cargo."0.33.0".opener}".default = true;
    rustc_workspace_hack."${deps.cargo."0.33.0".rustc_workspace_hack}".default = true;
    rustfix."${deps.cargo."0.33.0".rustfix}".default = true;
    same_file."${deps.cargo."0.33.0".same_file}".default = true;
    semver = fold recursiveUpdate {} [
      { "${deps.cargo."0.33.0".semver}"."serde" = true; }
      { "${deps.cargo."0.33.0".semver}".default = true; }
    ];
    serde."${deps.cargo."0.33.0".serde}".default = true;
    serde_derive."${deps.cargo."0.33.0".serde_derive}".default = true;
    serde_ignored."${deps.cargo."0.33.0".serde_ignored}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "${deps.cargo."0.33.0".serde_json}"."raw_value" = true; }
      { "${deps.cargo."0.33.0".serde_json}".default = true; }
    ];
    shell_escape."${deps.cargo."0.33.0".shell_escape}".default = true;
    tar."${deps.cargo."0.33.0".tar}".default = (f.tar."${deps.cargo."0.33.0".tar}".default or false);
    tempfile."${deps.cargo."0.33.0".tempfile}".default = true;
    termcolor."${deps.cargo."0.33.0".termcolor}".default = true;
    toml."${deps.cargo."0.33.0".toml}".default = true;
    unicode_width."${deps.cargo."0.33.0".unicode_width}".default = true;
    url."${deps.cargo."0.33.0".url}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.cargo."0.33.0".winapi}"."basetsd" = true; }
      { "${deps.cargo."0.33.0".winapi}"."handleapi" = true; }
      { "${deps.cargo."0.33.0".winapi}"."jobapi" = true; }
      { "${deps.cargo."0.33.0".winapi}"."jobapi2" = true; }
      { "${deps.cargo."0.33.0".winapi}"."memoryapi" = true; }
      { "${deps.cargo."0.33.0".winapi}"."minwindef" = true; }
      { "${deps.cargo."0.33.0".winapi}"."ntdef" = true; }
      { "${deps.cargo."0.33.0".winapi}"."ntstatus" = true; }
      { "${deps.cargo."0.33.0".winapi}"."processenv" = true; }
      { "${deps.cargo."0.33.0".winapi}"."processthreadsapi" = true; }
      { "${deps.cargo."0.33.0".winapi}"."psapi" = true; }
      { "${deps.cargo."0.33.0".winapi}"."synchapi" = true; }
      { "${deps.cargo."0.33.0".winapi}"."winbase" = true; }
      { "${deps.cargo."0.33.0".winapi}"."wincon" = true; }
      { "${deps.cargo."0.33.0".winapi}"."winerror" = true; }
      { "${deps.cargo."0.33.0".winapi}"."winnt" = true; }
      { "${deps.cargo."0.33.0".winapi}".default = true; }
    ];
  }) [
    (features_.atty."${deps."cargo"."0.33.0"."atty"}" deps)
    (features_.bytesize."${deps."cargo"."0.33.0"."bytesize"}" deps)
    (features_.clap."${deps."cargo"."0.33.0"."clap"}" deps)
    (features_.crates_io."${deps."cargo"."0.33.0"."crates_io"}" deps)
    (features_.crossbeam_utils."${deps."cargo"."0.33.0"."crossbeam_utils"}" deps)
    (features_.crypto_hash."${deps."cargo"."0.33.0"."crypto_hash"}" deps)
    (features_.curl."${deps."cargo"."0.33.0"."curl"}" deps)
    (features_.curl_sys."${deps."cargo"."0.33.0"."curl_sys"}" deps)
    (features_.env_logger."${deps."cargo"."0.33.0"."env_logger"}" deps)
    (features_.failure."${deps."cargo"."0.33.0"."failure"}" deps)
    (features_.filetime."${deps."cargo"."0.33.0"."filetime"}" deps)
    (features_.flate2."${deps."cargo"."0.33.0"."flate2"}" deps)
    (features_.fs2."${deps."cargo"."0.33.0"."fs2"}" deps)
    (features_.git2."${deps."cargo"."0.33.0"."git2"}" deps)
    (features_.git2_curl."${deps."cargo"."0.33.0"."git2_curl"}" deps)
    (features_.glob."${deps."cargo"."0.33.0"."glob"}" deps)
    (features_.hex."${deps."cargo"."0.33.0"."hex"}" deps)
    (features_.home."${deps."cargo"."0.33.0"."home"}" deps)
    (features_.ignore."${deps."cargo"."0.33.0"."ignore"}" deps)
    (features_.im_rc."${deps."cargo"."0.33.0"."im_rc"}" deps)
    (features_.jobserver."${deps."cargo"."0.33.0"."jobserver"}" deps)
    (features_.lazy_static."${deps."cargo"."0.33.0"."lazy_static"}" deps)
    (features_.lazycell."${deps."cargo"."0.33.0"."lazycell"}" deps)
    (features_.libc."${deps."cargo"."0.33.0"."libc"}" deps)
    (features_.libgit2_sys."${deps."cargo"."0.33.0"."libgit2_sys"}" deps)
    (features_.log."${deps."cargo"."0.33.0"."log"}" deps)
    (features_.num_cpus."${deps."cargo"."0.33.0"."num_cpus"}" deps)
    (features_.opener."${deps."cargo"."0.33.0"."opener"}" deps)
    (features_.rustc_workspace_hack."${deps."cargo"."0.33.0"."rustc_workspace_hack"}" deps)
    (features_.rustfix."${deps."cargo"."0.33.0"."rustfix"}" deps)
    (features_.same_file."${deps."cargo"."0.33.0"."same_file"}" deps)
    (features_.semver."${deps."cargo"."0.33.0"."semver"}" deps)
    (features_.serde."${deps."cargo"."0.33.0"."serde"}" deps)
    (features_.serde_derive."${deps."cargo"."0.33.0"."serde_derive"}" deps)
    (features_.serde_ignored."${deps."cargo"."0.33.0"."serde_ignored"}" deps)
    (features_.serde_json."${deps."cargo"."0.33.0"."serde_json"}" deps)
    (features_.shell_escape."${deps."cargo"."0.33.0"."shell_escape"}" deps)
    (features_.tar."${deps."cargo"."0.33.0"."tar"}" deps)
    (features_.tempfile."${deps."cargo"."0.33.0"."tempfile"}" deps)
    (features_.termcolor."${deps."cargo"."0.33.0"."termcolor"}" deps)
    (features_.toml."${deps."cargo"."0.33.0"."toml"}" deps)
    (features_.unicode_width."${deps."cargo"."0.33.0"."unicode_width"}" deps)
    (features_.url."${deps."cargo"."0.33.0"."url"}" deps)
    (features_.core_foundation."${deps."cargo"."0.33.0"."core_foundation"}" deps)
    (features_.fwdansi."${deps."cargo"."0.33.0"."fwdansi"}" deps)
    (features_.miow."${deps."cargo"."0.33.0"."miow"}" deps)
    (features_.winapi."${deps."cargo"."0.33.0"."winapi"}" deps)
  ];


# end
# cargo-vendor-0.1.23

  crates.cargo_vendor."0.1.23" = deps: { features?(features_.cargo_vendor."0.1.23" deps {}) }: buildRustCrate {
    crateName = "cargo-vendor";
    version = "0.1.23";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1mnqayb40ssbqqyb8kif1ldfcmhq7bx3q6qkfaxzw2vdbkvdl29s";
    dependencies = mapFeatures features ([
      (crates."cargo"."${deps."cargo_vendor"."0.1.23"."cargo"}" deps)
      (crates."docopt"."${deps."cargo_vendor"."0.1.23"."docopt"}" deps)
      (crates."env_logger"."${deps."cargo_vendor"."0.1.23"."env_logger"}" deps)
      (crates."failure"."${deps."cargo_vendor"."0.1.23"."failure"}" deps)
      (crates."serde"."${deps."cargo_vendor"."0.1.23"."serde"}" deps)
      (crates."serde_derive"."${deps."cargo_vendor"."0.1.23"."serde_derive"}" deps)
      (crates."serde_json"."${deps."cargo_vendor"."0.1.23"."serde_json"}" deps)
      (crates."toml"."${deps."cargo_vendor"."0.1.23"."toml"}" deps)
    ]
      ++ (if features.cargo_vendor."0.1.23".openssl or false then [ (crates.openssl."${deps."cargo_vendor"."0.1.23".openssl}" deps) ] else []));
    features = mkFeatures (features."cargo_vendor"."0.1.23" or {});
  };
  features_.cargo_vendor."0.1.23" = deps: f: updateFeatures f (rec {
    cargo."${deps.cargo_vendor."0.1.23".cargo}".default = true;
    cargo_vendor."0.1.23".default = (f.cargo_vendor."0.1.23".default or true);
    docopt."${deps.cargo_vendor."0.1.23".docopt}".default = true;
    env_logger."${deps.cargo_vendor."0.1.23".env_logger}".default = true;
    failure."${deps.cargo_vendor."0.1.23".failure}".default = true;
    openssl = fold recursiveUpdate {} [
      { "${deps.cargo_vendor."0.1.23".openssl}"."vendored" =
        (f.openssl."${deps.cargo_vendor."0.1.23".openssl}"."vendored" or false) ||
        (cargo_vendor."0.1.23"."vendored-openssl" or false) ||
        (f."cargo_vendor"."0.1.23"."vendored-openssl" or false); }
      { "${deps.cargo_vendor."0.1.23".openssl}".default = true; }
    ];
    serde."${deps.cargo_vendor."0.1.23".serde}".default = true;
    serde_derive."${deps.cargo_vendor."0.1.23".serde_derive}".default = true;
    serde_json."${deps.cargo_vendor."0.1.23".serde_json}".default = true;
    toml."${deps.cargo_vendor."0.1.23".toml}".default = true;
  }) [
    (features_.cargo."${deps."cargo_vendor"."0.1.23"."cargo"}" deps)
    (features_.docopt."${deps."cargo_vendor"."0.1.23"."docopt"}" deps)
    (features_.env_logger."${deps."cargo_vendor"."0.1.23"."env_logger"}" deps)
    (features_.failure."${deps."cargo_vendor"."0.1.23"."failure"}" deps)
    (features_.openssl."${deps."cargo_vendor"."0.1.23"."openssl"}" deps)
    (features_.serde."${deps."cargo_vendor"."0.1.23"."serde"}" deps)
    (features_.serde_derive."${deps."cargo_vendor"."0.1.23"."serde_derive"}" deps)
    (features_.serde_json."${deps."cargo_vendor"."0.1.23"."serde_json"}" deps)
    (features_.toml."${deps."cargo_vendor"."0.1.23"."toml"}" deps)
  ];


# end
# cc-1.0.28

  crates.cc."1.0.28" = deps: { features?(features_.cc."1.0.28" deps {}) }: buildRustCrate {
    crateName = "cc";
    version = "1.0.28";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "07harxg2cjw75qvnq637z088w9qaa0hgj0nmcm6yh9in8m2swl19";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."cc"."1.0.28" or {});
  };
  features_.cc."1.0.28" = deps: f: updateFeatures f (rec {
    cc = fold recursiveUpdate {} [
      { "1.0.28".default = (f.cc."1.0.28".default or true); }
      { "1.0.28".rayon =
        (f.cc."1.0.28".rayon or false) ||
        (f.cc."1.0.28".parallel or false) ||
        (cc."1.0.28"."parallel" or false); }
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
# commoncrypto-0.2.0

  crates.commoncrypto."0.2.0" = deps: { features?(features_.commoncrypto."0.2.0" deps {}) }: buildRustCrate {
    crateName = "commoncrypto";
    version = "0.2.0";
    authors = [ "Mark Lee" ];
    sha256 = "1ywgmv5ai4f6yskr3wv3j1wzfsdm9km8j8lm4x4j5ccln5362xdf";
    dependencies = mapFeatures features ([
      (crates."commoncrypto_sys"."${deps."commoncrypto"."0.2.0"."commoncrypto_sys"}" deps)
    ]);
    features = mkFeatures (features."commoncrypto"."0.2.0" or {});
  };
  features_.commoncrypto."0.2.0" = deps: f: updateFeatures f (rec {
    commoncrypto = fold recursiveUpdate {} [
      { "0.2.0".clippy =
        (f.commoncrypto."0.2.0".clippy or false) ||
        (f.commoncrypto."0.2.0".lint or false) ||
        (commoncrypto."0.2.0"."lint" or false); }
      { "0.2.0".default = (f.commoncrypto."0.2.0".default or true); }
    ];
    commoncrypto_sys."${deps.commoncrypto."0.2.0".commoncrypto_sys}".default = true;
  }) [
    (features_.commoncrypto_sys."${deps."commoncrypto"."0.2.0"."commoncrypto_sys"}" deps)
  ];


# end
# commoncrypto-sys-0.2.0

  crates.commoncrypto_sys."0.2.0" = deps: { features?(features_.commoncrypto_sys."0.2.0" deps {}) }: buildRustCrate {
    crateName = "commoncrypto-sys";
    version = "0.2.0";
    authors = [ "Mark Lee" ];
    sha256 = "001i2g7xbfi48r2xjgxwrgjjjf00x9c24vfrs3g6p2q2djhwww4i";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."commoncrypto_sys"."0.2.0"."libc"}" deps)
    ]);
    features = mkFeatures (features."commoncrypto_sys"."0.2.0" or {});
  };
  features_.commoncrypto_sys."0.2.0" = deps: f: updateFeatures f (rec {
    commoncrypto_sys = fold recursiveUpdate {} [
      { "0.2.0".clippy =
        (f.commoncrypto_sys."0.2.0".clippy or false) ||
        (f.commoncrypto_sys."0.2.0".lint or false) ||
        (commoncrypto_sys."0.2.0"."lint" or false); }
      { "0.2.0".default = (f.commoncrypto_sys."0.2.0".default or true); }
    ];
    libc."${deps.commoncrypto_sys."0.2.0".libc}".default = true;
  }) [
    (features_.libc."${deps."commoncrypto_sys"."0.2.0"."libc"}" deps)
  ];


# end
# core-foundation-0.6.3

  crates.core_foundation."0.6.3" = deps: { features?(features_.core_foundation."0.6.3" deps {}) }: buildRustCrate {
    crateName = "core-foundation";
    version = "0.6.3";
    authors = [ "The Servo Project Developers" ];
    sha256 = "1j06ay1jhv9c049kvwkz2myz1r5z3adqrd27nl5fjqqv3d2yl3xk";
    dependencies = mapFeatures features ([
      (crates."core_foundation_sys"."${deps."core_foundation"."0.6.3"."core_foundation_sys"}" deps)
      (crates."libc"."${deps."core_foundation"."0.6.3"."libc"}" deps)
    ]);
    features = mkFeatures (features."core_foundation"."0.6.3" or {});
  };
  features_.core_foundation."0.6.3" = deps: f: updateFeatures f (rec {
    core_foundation = fold recursiveUpdate {} [
      { "0.6.3".chrono =
        (f.core_foundation."0.6.3".chrono or false) ||
        (f.core_foundation."0.6.3".with-chrono or false) ||
        (core_foundation."0.6.3"."with-chrono" or false); }
      { "0.6.3".default = (f.core_foundation."0.6.3".default or true); }
      { "0.6.3".uuid =
        (f.core_foundation."0.6.3".uuid or false) ||
        (f.core_foundation."0.6.3".with-uuid or false) ||
        (core_foundation."0.6.3"."with-uuid" or false); }
    ];
    core_foundation_sys = fold recursiveUpdate {} [
      { "${deps.core_foundation."0.6.3".core_foundation_sys}"."mac_os_10_7_support" =
        (f.core_foundation_sys."${deps.core_foundation."0.6.3".core_foundation_sys}"."mac_os_10_7_support" or false) ||
        (core_foundation."0.6.3"."mac_os_10_7_support" or false) ||
        (f."core_foundation"."0.6.3"."mac_os_10_7_support" or false); }
      { "${deps.core_foundation."0.6.3".core_foundation_sys}"."mac_os_10_8_features" =
        (f.core_foundation_sys."${deps.core_foundation."0.6.3".core_foundation_sys}"."mac_os_10_8_features" or false) ||
        (core_foundation."0.6.3"."mac_os_10_8_features" or false) ||
        (f."core_foundation"."0.6.3"."mac_os_10_8_features" or false); }
      { "${deps.core_foundation."0.6.3".core_foundation_sys}".default = true; }
    ];
    libc."${deps.core_foundation."0.6.3".libc}".default = true;
  }) [
    (features_.core_foundation_sys."${deps."core_foundation"."0.6.3"."core_foundation_sys"}" deps)
    (features_.libc."${deps."core_foundation"."0.6.3"."libc"}" deps)
  ];


# end
# core-foundation-sys-0.6.2

  crates.core_foundation_sys."0.6.2" = deps: { features?(features_.core_foundation_sys."0.6.2" deps {}) }: buildRustCrate {
    crateName = "core-foundation-sys";
    version = "0.6.2";
    authors = [ "The Servo Project Developers" ];
    sha256 = "1n2v6wlqkmqwhl7k6y50irx51p37xb0fcm3njbman82gnyq8di2c";
    build = "build.rs";
    features = mkFeatures (features."core_foundation_sys"."0.6.2" or {});
  };
  features_.core_foundation_sys."0.6.2" = deps: f: updateFeatures f (rec {
    core_foundation_sys."0.6.2".default = (f.core_foundation_sys."0.6.2".default or true);
  }) [];


# end
# crates-io-0.21.0

  crates.crates_io."0.21.0" = deps: { features?(features_.crates_io."0.21.0" deps {}) }: buildRustCrate {
    crateName = "crates-io";
    version = "0.21.0";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1i4b1z6pw447crlr5js9jjk9fda13agc1v20l552z04hlyff1yyj";
    libPath = "lib.rs";
    libName = "crates_io";
    dependencies = mapFeatures features ([
      (crates."curl"."${deps."crates_io"."0.21.0"."curl"}" deps)
      (crates."failure"."${deps."crates_io"."0.21.0"."failure"}" deps)
      (crates."serde"."${deps."crates_io"."0.21.0"."serde"}" deps)
      (crates."serde_derive"."${deps."crates_io"."0.21.0"."serde_derive"}" deps)
      (crates."serde_json"."${deps."crates_io"."0.21.0"."serde_json"}" deps)
      (crates."url"."${deps."crates_io"."0.21.0"."url"}" deps)
    ]);
  };
  features_.crates_io."0.21.0" = deps: f: updateFeatures f (rec {
    crates_io."0.21.0".default = (f.crates_io."0.21.0".default or true);
    curl."${deps.crates_io."0.21.0".curl}".default = true;
    failure."${deps.crates_io."0.21.0".failure}".default = true;
    serde."${deps.crates_io."0.21.0".serde}".default = true;
    serde_derive."${deps.crates_io."0.21.0".serde_derive}".default = true;
    serde_json."${deps.crates_io."0.21.0".serde_json}".default = true;
    url."${deps.crates_io."0.21.0".url}".default = true;
  }) [
    (features_.curl."${deps."crates_io"."0.21.0"."curl"}" deps)
    (features_.failure."${deps."crates_io"."0.21.0"."failure"}" deps)
    (features_.serde."${deps."crates_io"."0.21.0"."serde"}" deps)
    (features_.serde_derive."${deps."crates_io"."0.21.0"."serde_derive"}" deps)
    (features_.serde_json."${deps."crates_io"."0.21.0"."serde_json"}" deps)
    (features_.url."${deps."crates_io"."0.21.0"."url"}" deps)
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
# crc32fast-1.1.2

  crates.crc32fast."1.1.2" = deps: { features?(features_.crc32fast."1.1.2" deps {}) }: buildRustCrate {
    crateName = "crc32fast";
    version = "1.1.2";
    authors = [ "Sam Rijs <srijs@airpost.net>" "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "19hjgifwvsgcvhm7f6bqkp4sfijnx3ddiv8szdfwjn3sjn4lysd6";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."crc32fast"."1.1.2"."cfg_if"}" deps)
    ]);
  };
  features_.crc32fast."1.1.2" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.crc32fast."1.1.2".cfg_if}".default = true;
    crc32fast."1.1.2".default = (f.crc32fast."1.1.2".default or true);
  }) [
    (features_.cfg_if."${deps."crc32fast"."1.1.2"."cfg_if"}" deps)
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
# crypto-hash-0.3.3

  crates.crypto_hash."0.3.3" = deps: { features?(features_.crypto_hash."0.3.3" deps {}) }: buildRustCrate {
    crateName = "crypto-hash";
    version = "0.3.3";
    authors = [ "Mark Lee" ];
    sha256 = "0ybl3q06snf0p0w5c743yipf1gyhim2z0yqczgdhclfmzgj4gxqy";
    dependencies = mapFeatures features ([
      (crates."hex"."${deps."crypto_hash"."0.3.3"."hex"}" deps)
    ])
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
      (crates."commoncrypto"."${deps."crypto_hash"."0.3.3"."commoncrypto"}" deps)
    ]) else [])
      ++ (if !(kernel == "windows" || kernel == "darwin" || kernel == "ios") then mapFeatures features ([
      (crates."openssl"."${deps."crypto_hash"."0.3.3"."openssl"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."crypto_hash"."0.3.3"."winapi"}" deps)
    ]) else []);
  };
  features_.crypto_hash."0.3.3" = deps: f: updateFeatures f (rec {
    commoncrypto."${deps.crypto_hash."0.3.3".commoncrypto}".default = true;
    crypto_hash."0.3.3".default = (f.crypto_hash."0.3.3".default or true);
    hex."${deps.crypto_hash."0.3.3".hex}".default = true;
    openssl."${deps.crypto_hash."0.3.3".openssl}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.crypto_hash."0.3.3".winapi}"."minwindef" = true; }
      { "${deps.crypto_hash."0.3.3".winapi}"."wincrypt" = true; }
      { "${deps.crypto_hash."0.3.3".winapi}".default = true; }
    ];
  }) [
    (features_.hex."${deps."crypto_hash"."0.3.3"."hex"}" deps)
    (features_.commoncrypto."${deps."crypto_hash"."0.3.3"."commoncrypto"}" deps)
    (features_.openssl."${deps."crypto_hash"."0.3.3"."openssl"}" deps)
    (features_.winapi."${deps."crypto_hash"."0.3.3"."winapi"}" deps)
  ];


# end
# curl-0.4.19

  crates.curl."0.4.19" = deps: { features?(features_.curl."0.4.19" deps {}) }: buildRustCrate {
    crateName = "curl";
    version = "0.4.19";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1innmvjzh6dd5x4h02gzyqqncqwgmv6xaqmfwcjmy9wflrf4fsnn";
    dependencies = mapFeatures features ([
      (crates."curl_sys"."${deps."curl"."0.4.19"."curl_sys"}" deps)
      (crates."libc"."${deps."curl"."0.4.19"."libc"}" deps)
      (crates."socket2"."${deps."curl"."0.4.19"."socket2"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.curl."0.4.19".openssl-probe or false then [ (crates.openssl_probe."${deps."curl"."0.4.19".openssl_probe}" deps) ] else [])
      ++ (if features.curl."0.4.19".openssl-sys or false then [ (crates.openssl_sys."${deps."curl"."0.4.19".openssl_sys}" deps) ] else [])) else [])
      ++ (if abi == "msvc" then mapFeatures features ([
      (crates."kernel32_sys"."${deps."curl"."0.4.19"."kernel32_sys"}" deps)
      (crates."schannel"."${deps."curl"."0.4.19"."schannel"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."curl"."0.4.19"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."curl"."0.4.19" or {});
  };
  features_.curl."0.4.19" = deps: f: updateFeatures f (rec {
    curl = fold recursiveUpdate {} [
      { "0.4.19".default = (f.curl."0.4.19".default or true); }
      { "0.4.19".openssl-probe =
        (f.curl."0.4.19".openssl-probe or false) ||
        (f.curl."0.4.19".ssl or false) ||
        (curl."0.4.19"."ssl" or false); }
      { "0.4.19".openssl-sys =
        (f.curl."0.4.19".openssl-sys or false) ||
        (f.curl."0.4.19".ssl or false) ||
        (curl."0.4.19"."ssl" or false); }
      { "0.4.19".ssl =
        (f.curl."0.4.19".ssl or false) ||
        (f.curl."0.4.19".default or false) ||
        (curl."0.4.19"."default" or false); }
    ];
    curl_sys = fold recursiveUpdate {} [
      { "${deps.curl."0.4.19".curl_sys}"."force-system-lib-on-osx" =
        (f.curl_sys."${deps.curl."0.4.19".curl_sys}"."force-system-lib-on-osx" or false) ||
        (curl."0.4.19"."force-system-lib-on-osx" or false) ||
        (f."curl"."0.4.19"."force-system-lib-on-osx" or false); }
      { "${deps.curl."0.4.19".curl_sys}"."http2" =
        (f.curl_sys."${deps.curl."0.4.19".curl_sys}"."http2" or false) ||
        (curl."0.4.19"."http2" or false) ||
        (f."curl"."0.4.19"."http2" or false); }
      { "${deps.curl."0.4.19".curl_sys}"."ssl" =
        (f.curl_sys."${deps.curl."0.4.19".curl_sys}"."ssl" or false) ||
        (curl."0.4.19"."ssl" or false) ||
        (f."curl"."0.4.19"."ssl" or false); }
      { "${deps.curl."0.4.19".curl_sys}"."static-curl" =
        (f.curl_sys."${deps.curl."0.4.19".curl_sys}"."static-curl" or false) ||
        (curl."0.4.19"."static-curl" or false) ||
        (f."curl"."0.4.19"."static-curl" or false); }
      { "${deps.curl."0.4.19".curl_sys}"."static-ssl" =
        (f.curl_sys."${deps.curl."0.4.19".curl_sys}"."static-ssl" or false) ||
        (curl."0.4.19"."static-ssl" or false) ||
        (f."curl"."0.4.19"."static-ssl" or false); }
      { "${deps.curl."0.4.19".curl_sys}".default = (f.curl_sys."${deps.curl."0.4.19".curl_sys}".default or false); }
    ];
    kernel32_sys."${deps.curl."0.4.19".kernel32_sys}".default = true;
    libc."${deps.curl."0.4.19".libc}".default = true;
    openssl_probe."${deps.curl."0.4.19".openssl_probe}".default = true;
    openssl_sys."${deps.curl."0.4.19".openssl_sys}".default = true;
    schannel."${deps.curl."0.4.19".schannel}".default = true;
    socket2."${deps.curl."0.4.19".socket2}".default = true;
    winapi."${deps.curl."0.4.19".winapi}".default = true;
  }) [
    (features_.curl_sys."${deps."curl"."0.4.19"."curl_sys"}" deps)
    (features_.libc."${deps."curl"."0.4.19"."libc"}" deps)
    (features_.socket2."${deps."curl"."0.4.19"."socket2"}" deps)
    (features_.openssl_probe."${deps."curl"."0.4.19"."openssl_probe"}" deps)
    (features_.openssl_sys."${deps."curl"."0.4.19"."openssl_sys"}" deps)
    (features_.kernel32_sys."${deps."curl"."0.4.19"."kernel32_sys"}" deps)
    (features_.schannel."${deps."curl"."0.4.19"."schannel"}" deps)
    (features_.winapi."${deps."curl"."0.4.19"."winapi"}" deps)
  ];


# end
# curl-sys-0.4.16

  crates.curl_sys."0.4.16" = deps: { features?(features_.curl_sys."0.4.16" deps {}) }: buildRustCrate {
    crateName = "curl-sys";
    version = "0.4.16";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "03gv0rfaka8qn0sxq20f5l7x72nxyqsyx56waiwz3l13ssk3i1vx";
    libPath = "lib.rs";
    libName = "curl_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."curl_sys"."0.4.16"."libc"}" deps)
      (crates."libz_sys"."${deps."curl_sys"."0.4.16"."libz_sys"}" deps)
    ]
      ++ (if features.curl_sys."0.4.16".libnghttp2-sys or false then [ (crates.libnghttp2_sys."${deps."curl_sys"."0.4.16".libnghttp2_sys}" deps) ] else []))
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.curl_sys."0.4.16".openssl-sys or false then [ (crates.openssl_sys."${deps."curl_sys"."0.4.16".openssl_sys}" deps) ] else [])) else [])
      ++ (if abi == "msvc" then mapFeatures features ([
]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."curl_sys"."0.4.16"."winapi"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."curl_sys"."0.4.16"."cc"}" deps)
      (crates."pkg_config"."${deps."curl_sys"."0.4.16"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."curl_sys"."0.4.16" or {});
  };
  features_.curl_sys."0.4.16" = deps: f: updateFeatures f (rec {
    cc."${deps.curl_sys."0.4.16".cc}".default = true;
    curl_sys = fold recursiveUpdate {} [
      { "0.4.16".default = (f.curl_sys."0.4.16".default or true); }
      { "0.4.16".libnghttp2-sys =
        (f.curl_sys."0.4.16".libnghttp2-sys or false) ||
        (f.curl_sys."0.4.16".http2 or false) ||
        (curl_sys."0.4.16"."http2" or false); }
      { "0.4.16".openssl-sys =
        (f.curl_sys."0.4.16".openssl-sys or false) ||
        (f.curl_sys."0.4.16".ssl or false) ||
        (curl_sys."0.4.16"."ssl" or false); }
      { "0.4.16".ssl =
        (f.curl_sys."0.4.16".ssl or false) ||
        (f.curl_sys."0.4.16".default or false) ||
        (curl_sys."0.4.16"."default" or false); }
    ];
    libc."${deps.curl_sys."0.4.16".libc}".default = true;
    libnghttp2_sys."${deps.curl_sys."0.4.16".libnghttp2_sys}".default = true;
    libz_sys."${deps.curl_sys."0.4.16".libz_sys}".default = true;
    openssl_sys."${deps.curl_sys."0.4.16".openssl_sys}".default = true;
    pkg_config."${deps.curl_sys."0.4.16".pkg_config}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.curl_sys."0.4.16".winapi}"."winsock2" = true; }
      { "${deps.curl_sys."0.4.16".winapi}"."ws2def" = true; }
      { "${deps.curl_sys."0.4.16".winapi}".default = true; }
    ];
  }) [
    (features_.libc."${deps."curl_sys"."0.4.16"."libc"}" deps)
    (features_.libnghttp2_sys."${deps."curl_sys"."0.4.16"."libnghttp2_sys"}" deps)
    (features_.libz_sys."${deps."curl_sys"."0.4.16"."libz_sys"}" deps)
    (features_.cc."${deps."curl_sys"."0.4.16"."cc"}" deps)
    (features_.pkg_config."${deps."curl_sys"."0.4.16"."pkg_config"}" deps)
    (features_.openssl_sys."${deps."curl_sys"."0.4.16"."openssl_sys"}" deps)
    (features_.winapi."${deps."curl_sys"."0.4.16"."winapi"}" deps)
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
# env_logger-0.6.0

  crates.env_logger."0.6.0" = deps: { features?(features_.env_logger."0.6.0" deps {}) }: buildRustCrate {
    crateName = "env_logger";
    version = "0.6.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1k2v2wz2725c7rrxzc05x2jifw3frp0fnsr0p8r4n4jj9j12bkp9";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."env_logger"."0.6.0"."log"}" deps)
    ]
      ++ (if features.env_logger."0.6.0".atty or false then [ (crates.atty."${deps."env_logger"."0.6.0".atty}" deps) ] else [])
      ++ (if features.env_logger."0.6.0".humantime or false then [ (crates.humantime."${deps."env_logger"."0.6.0".humantime}" deps) ] else [])
      ++ (if features.env_logger."0.6.0".regex or false then [ (crates.regex."${deps."env_logger"."0.6.0".regex}" deps) ] else [])
      ++ (if features.env_logger."0.6.0".termcolor or false then [ (crates.termcolor."${deps."env_logger"."0.6.0".termcolor}" deps) ] else []));
    features = mkFeatures (features."env_logger"."0.6.0" or {});
  };
  features_.env_logger."0.6.0" = deps: f: updateFeatures f (rec {
    atty."${deps.env_logger."0.6.0".atty}".default = true;
    env_logger = fold recursiveUpdate {} [
      { "0.6.0".atty =
        (f.env_logger."0.6.0".atty or false) ||
        (f.env_logger."0.6.0".default or false) ||
        (env_logger."0.6.0"."default" or false); }
      { "0.6.0".default = (f.env_logger."0.6.0".default or true); }
      { "0.6.0".humantime =
        (f.env_logger."0.6.0".humantime or false) ||
        (f.env_logger."0.6.0".default or false) ||
        (env_logger."0.6.0"."default" or false); }
      { "0.6.0".regex =
        (f.env_logger."0.6.0".regex or false) ||
        (f.env_logger."0.6.0".default or false) ||
        (env_logger."0.6.0"."default" or false); }
      { "0.6.0".termcolor =
        (f.env_logger."0.6.0".termcolor or false) ||
        (f.env_logger."0.6.0".default or false) ||
        (env_logger."0.6.0"."default" or false); }
    ];
    humantime."${deps.env_logger."0.6.0".humantime}".default = true;
    log = fold recursiveUpdate {} [
      { "${deps.env_logger."0.6.0".log}"."std" = true; }
      { "${deps.env_logger."0.6.0".log}".default = true; }
    ];
    regex."${deps.env_logger."0.6.0".regex}".default = true;
    termcolor."${deps.env_logger."0.6.0".termcolor}".default = true;
  }) [
    (features_.atty."${deps."env_logger"."0.6.0"."atty"}" deps)
    (features_.humantime."${deps."env_logger"."0.6.0"."humantime"}" deps)
    (features_.log."${deps."env_logger"."0.6.0"."log"}" deps)
    (features_.regex."${deps."env_logger"."0.6.0"."regex"}" deps)
    (features_.termcolor."${deps."env_logger"."0.6.0"."termcolor"}" deps)
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
# filetime-0.2.4

  crates.filetime."0.2.4" = deps: { features?(features_.filetime."0.2.4" deps {}) }: buildRustCrate {
    crateName = "filetime";
    version = "0.2.4";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1lsc0qjihr8y56rlzdcldzr0nbljm8qqi691msgwhy6wrkawwx5d";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."filetime"."0.2.4"."cfg_if"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."filetime"."0.2.4"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."filetime"."0.2.4"."libc"}" deps)
    ]) else []);
  };
  features_.filetime."0.2.4" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.filetime."0.2.4".cfg_if}".default = true;
    filetime."0.2.4".default = (f.filetime."0.2.4".default or true);
    libc."${deps.filetime."0.2.4".libc}".default = true;
    redox_syscall."${deps.filetime."0.2.4".redox_syscall}".default = true;
  }) [
    (features_.cfg_if."${deps."filetime"."0.2.4"."cfg_if"}" deps)
    (features_.redox_syscall."${deps."filetime"."0.2.4"."redox_syscall"}" deps)
    (features_.libc."${deps."filetime"."0.2.4"."libc"}" deps)
  ];


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
      ++ (if features.flate2."1.0.6".libz-sys or false then [ (crates.libz_sys."${deps."flate2"."1.0.6".libz_sys}" deps) ] else [])
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
    libz_sys."${deps.flate2."1.0.6".libz_sys}".default = true;
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
    (features_.libz_sys."${deps."flate2"."1.0.6"."libz_sys"}" deps)
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
# fuchsia-cprng-0.1.0

  crates.fuchsia_cprng."0.1.0" = deps: { features?(features_.fuchsia_cprng."0.1.0" deps {}) }: buildRustCrate {
    crateName = "fuchsia-cprng";
    version = "0.1.0";
    authors = [ "Erick Tryzelaar <etryzelaar@google.com>" ];
    edition = "2018";
    sha256 = "0q7cllm3giiccvymdiizsqxiz21ja7wgmccz3my3bqwsl7mci5l7";
  };
  features_.fuchsia_cprng."0.1.0" = deps: f: updateFeatures f (rec {
    fuchsia_cprng."0.1.0".default = (f.fuchsia_cprng."0.1.0".default or true);
  }) [];


# end
# fwdansi-1.0.1

  crates.fwdansi."1.0.1" = deps: { features?(features_.fwdansi."1.0.1" deps {}) }: buildRustCrate {
    crateName = "fwdansi";
    version = "1.0.1";
    authors = [ "kennytm <kennytm@gmail.com>" ];
    sha256 = "00mzclq1wx55p6x5xx4yhpj70vsrivk2w1wbzq8bnf6xnl2km0xn";
    dependencies = mapFeatures features ([
      (crates."memchr"."${deps."fwdansi"."1.0.1"."memchr"}" deps)
      (crates."termcolor"."${deps."fwdansi"."1.0.1"."termcolor"}" deps)
    ]);
  };
  features_.fwdansi."1.0.1" = deps: f: updateFeatures f (rec {
    fwdansi."1.0.1".default = (f.fwdansi."1.0.1".default or true);
    memchr."${deps.fwdansi."1.0.1".memchr}".default = true;
    termcolor."${deps.fwdansi."1.0.1".termcolor}".default = true;
  }) [
    (features_.memchr."${deps."fwdansi"."1.0.1"."memchr"}" deps)
    (features_.termcolor."${deps."fwdansi"."1.0.1"."termcolor"}" deps)
  ];


# end
# git2-0.7.5

  crates.git2."0.7.5" = deps: { features?(features_.git2."0.7.5" deps {}) }: buildRustCrate {
    crateName = "git2";
    version = "0.7.5";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0niyjy68vb790x5hl72qbpp1145xfbfrlf0rgmc8fq4qwbz4p5pb";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."git2"."0.7.5"."bitflags"}" deps)
      (crates."libc"."${deps."git2"."0.7.5"."libc"}" deps)
      (crates."libgit2_sys"."${deps."git2"."0.7.5"."libgit2_sys"}" deps)
      (crates."log"."${deps."git2"."0.7.5"."log"}" deps)
      (crates."url"."${deps."git2"."0.7.5"."url"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.git2."0.7.5".openssl-probe or false then [ (crates.openssl_probe."${deps."git2"."0.7.5".openssl_probe}" deps) ] else [])
      ++ (if features.git2."0.7.5".openssl-sys or false then [ (crates.openssl_sys."${deps."git2"."0.7.5".openssl_sys}" deps) ] else [])) else []);
    features = mkFeatures (features."git2"."0.7.5" or {});
  };
  features_.git2."0.7.5" = deps: f: updateFeatures f (rec {
    bitflags."${deps.git2."0.7.5".bitflags}".default = true;
    git2 = fold recursiveUpdate {} [
      { "0.7.5".curl =
        (f.git2."0.7.5".curl or false) ||
        (f.git2."0.7.5".default or false) ||
        (git2."0.7.5"."default" or false); }
      { "0.7.5".default = (f.git2."0.7.5".default or true); }
      { "0.7.5".https =
        (f.git2."0.7.5".https or false) ||
        (f.git2."0.7.5".default or false) ||
        (git2."0.7.5"."default" or false); }
      { "0.7.5".openssl-probe =
        (f.git2."0.7.5".openssl-probe or false) ||
        (f.git2."0.7.5".https or false) ||
        (git2."0.7.5"."https" or false); }
      { "0.7.5".openssl-sys =
        (f.git2."0.7.5".openssl-sys or false) ||
        (f.git2."0.7.5".https or false) ||
        (git2."0.7.5"."https" or false); }
      { "0.7.5".ssh =
        (f.git2."0.7.5".ssh or false) ||
        (f.git2."0.7.5".default or false) ||
        (git2."0.7.5"."default" or false); }
      { "0.7.5".ssh_key_from_memory =
        (f.git2."0.7.5".ssh_key_from_memory or false) ||
        (f.git2."0.7.5".default or false) ||
        (git2."0.7.5"."default" or false); }
    ];
    libc."${deps.git2."0.7.5".libc}".default = true;
    libgit2_sys = fold recursiveUpdate {} [
      { "${deps.git2."0.7.5".libgit2_sys}"."curl" =
        (f.libgit2_sys."${deps.git2."0.7.5".libgit2_sys}"."curl" or false) ||
        (git2."0.7.5"."curl" or false) ||
        (f."git2"."0.7.5"."curl" or false); }
      { "${deps.git2."0.7.5".libgit2_sys}"."https" =
        (f.libgit2_sys."${deps.git2."0.7.5".libgit2_sys}"."https" or false) ||
        (git2."0.7.5"."https" or false) ||
        (f."git2"."0.7.5"."https" or false); }
      { "${deps.git2."0.7.5".libgit2_sys}"."ssh" =
        (f.libgit2_sys."${deps.git2."0.7.5".libgit2_sys}"."ssh" or false) ||
        (git2."0.7.5"."ssh" or false) ||
        (f."git2"."0.7.5"."ssh" or false); }
      { "${deps.git2."0.7.5".libgit2_sys}"."ssh_key_from_memory" =
        (f.libgit2_sys."${deps.git2."0.7.5".libgit2_sys}"."ssh_key_from_memory" or false) ||
        (git2."0.7.5"."ssh_key_from_memory" or false) ||
        (f."git2"."0.7.5"."ssh_key_from_memory" or false); }
      { "${deps.git2."0.7.5".libgit2_sys}".default = true; }
    ];
    log."${deps.git2."0.7.5".log}".default = true;
    openssl_probe."${deps.git2."0.7.5".openssl_probe}".default = true;
    openssl_sys."${deps.git2."0.7.5".openssl_sys}".default = true;
    url."${deps.git2."0.7.5".url}".default = true;
  }) [
    (features_.bitflags."${deps."git2"."0.7.5"."bitflags"}" deps)
    (features_.libc."${deps."git2"."0.7.5"."libc"}" deps)
    (features_.libgit2_sys."${deps."git2"."0.7.5"."libgit2_sys"}" deps)
    (features_.log."${deps."git2"."0.7.5"."log"}" deps)
    (features_.url."${deps."git2"."0.7.5"."url"}" deps)
    (features_.openssl_probe."${deps."git2"."0.7.5"."openssl_probe"}" deps)
    (features_.openssl_sys."${deps."git2"."0.7.5"."openssl_sys"}" deps)
  ];


# end
# git2-curl-0.8.2

  crates.git2_curl."0.8.2" = deps: { features?(features_.git2_curl."0.8.2" deps {}) }: buildRustCrate {
    crateName = "git2-curl";
    version = "0.8.2";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1sfj0yys2mk56b9yhpfijxr9hil4p19laycqcrbswrwmd2cvcqqi";
    dependencies = mapFeatures features ([
      (crates."curl"."${deps."git2_curl"."0.8.2"."curl"}" deps)
      (crates."git2"."${deps."git2_curl"."0.8.2"."git2"}" deps)
      (crates."log"."${deps."git2_curl"."0.8.2"."log"}" deps)
      (crates."url"."${deps."git2_curl"."0.8.2"."url"}" deps)
    ]);
  };
  features_.git2_curl."0.8.2" = deps: f: updateFeatures f (rec {
    curl."${deps.git2_curl."0.8.2".curl}".default = true;
    git2."${deps.git2_curl."0.8.2".git2}".default = (f.git2."${deps.git2_curl."0.8.2".git2}".default or false);
    git2_curl."0.8.2".default = (f.git2_curl."0.8.2".default or true);
    log."${deps.git2_curl."0.8.2".log}".default = true;
    url."${deps.git2_curl."0.8.2".url}".default = true;
  }) [
    (features_.curl."${deps."git2_curl"."0.8.2"."curl"}" deps)
    (features_.git2."${deps."git2_curl"."0.8.2"."git2"}" deps)
    (features_.log."${deps."git2_curl"."0.8.2"."log"}" deps)
    (features_.url."${deps."git2_curl"."0.8.2"."url"}" deps)
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
# home-0.3.4

  crates.home."0.3.4" = deps: { features?(features_.home."0.3.4" deps {}) }: buildRustCrate {
    crateName = "home";
    version = "0.3.4";
    authors = [ "Brian Anderson <andersrb@gmail.com>" ];
    sha256 = "19fbzvv74wqxqpdlz6ri1p270i8hp17h8njjj68k98sgrabkcr0n";
    dependencies = (if kernel == "windows" then mapFeatures features ([
      (crates."scopeguard"."${deps."home"."0.3.4"."scopeguard"}" deps)
      (crates."winapi"."${deps."home"."0.3.4"."winapi"}" deps)
    ]) else []);
  };
  features_.home."0.3.4" = deps: f: updateFeatures f (rec {
    home."0.3.4".default = (f.home."0.3.4".default or true);
    scopeguard."${deps.home."0.3.4".scopeguard}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.home."0.3.4".winapi}"."errhandlingapi" = true; }
      { "${deps.home."0.3.4".winapi}"."handleapi" = true; }
      { "${deps.home."0.3.4".winapi}"."processthreadsapi" = true; }
      { "${deps.home."0.3.4".winapi}"."std" = true; }
      { "${deps.home."0.3.4".winapi}"."userenv" = true; }
      { "${deps.home."0.3.4".winapi}"."winerror" = true; }
      { "${deps.home."0.3.4".winapi}"."winnt" = true; }
      { "${deps.home."0.3.4".winapi}".default = true; }
    ];
  }) [
    (features_.scopeguard."${deps."home"."0.3.4"."scopeguard"}" deps)
    (features_.winapi."${deps."home"."0.3.4"."winapi"}" deps)
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
# im-rc-12.3.0

  crates.im_rc."12.3.0" = deps: { features?(features_.im_rc."12.3.0" deps {}) }: buildRustCrate {
    crateName = "im-rc";
    version = "12.3.0";
    authors = [ "Bodil Stokke <bodil@bodil.org>" ];
    sha256 = "074nz4rxa7pkwj36a0zw0iisisj8sh61nh3jq5zwcwrbyy1nqim8";
    libPath = "./src/lib.rs";
    build = "./build.rs";
    dependencies = mapFeatures features ([
      (crates."typenum"."${deps."im_rc"."12.3.0"."typenum"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."im_rc"."12.3.0"."rustc_version"}" deps)
    ]);
  };
  features_.im_rc."12.3.0" = deps: f: updateFeatures f (rec {
    im_rc."12.3.0".default = (f.im_rc."12.3.0".default or true);
    rustc_version."${deps.im_rc."12.3.0".rustc_version}".default = true;
    typenum."${deps.im_rc."12.3.0".typenum}".default = true;
  }) [
    (features_.typenum."${deps."im_rc"."12.3.0"."typenum"}" deps)
    (features_.rustc_version."${deps."im_rc"."12.3.0"."rustc_version"}" deps)
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
# jobserver-0.1.12

  crates.jobserver."0.1.12" = deps: { features?(features_.jobserver."0.1.12" deps {}) }: buildRustCrate {
    crateName = "jobserver";
    version = "0.1.12";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0914nknpj79ilzk8n00hy0xvyvdgvljxrvwwqb7xj85lhhmms7qc";
    dependencies = mapFeatures features ([
      (crates."log"."${deps."jobserver"."0.1.12"."log"}" deps)
    ])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."jobserver"."0.1.12"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."rand"."${deps."jobserver"."0.1.12"."rand"}" deps)
    ]) else []);
  };
  features_.jobserver."0.1.12" = deps: f: updateFeatures f (rec {
    jobserver."0.1.12".default = (f.jobserver."0.1.12".default or true);
    libc."${deps.jobserver."0.1.12".libc}".default = true;
    log."${deps.jobserver."0.1.12".log}".default = true;
    rand."${deps.jobserver."0.1.12".rand}".default = true;
  }) [
    (features_.log."${deps."jobserver"."0.1.12"."log"}" deps)
    (features_.libc."${deps."jobserver"."0.1.12"."libc"}" deps)
    (features_.rand."${deps."jobserver"."0.1.12"."rand"}" deps)
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
# libc-0.2.48

  crates.libc."0.2.48" = deps: { features?(features_.libc."0.2.48" deps {}) }: buildRustCrate {
    crateName = "libc";
    version = "0.2.48";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1jnjd4g9ibs02gd7z81amj7p1xkari0ciwg9if285fxnml4lmwxs";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."libc"."0.2.48" or {});
  };
  features_.libc."0.2.48" = deps: f: updateFeatures f (rec {
    libc = fold recursiveUpdate {} [
      { "0.2.48".align =
        (f.libc."0.2.48".align or false) ||
        (f.libc."0.2.48".rustc-dep-of-std or false) ||
        (libc."0.2.48"."rustc-dep-of-std" or false); }
      { "0.2.48".default = (f.libc."0.2.48".default or true); }
      { "0.2.48".rustc-std-workspace-core =
        (f.libc."0.2.48".rustc-std-workspace-core or false) ||
        (f.libc."0.2.48".rustc-dep-of-std or false) ||
        (libc."0.2.48"."rustc-dep-of-std" or false); }
      { "0.2.48".use_std =
        (f.libc."0.2.48".use_std or false) ||
        (f.libc."0.2.48".default or false) ||
        (libc."0.2.48"."default" or false); }
    ];
  }) [];


# end
# libgit2-sys-0.7.11

  crates.libgit2_sys."0.7.11" = deps: { features?(features_.libgit2_sys."0.7.11" deps {}) }: buildRustCrate {
    crateName = "libgit2-sys";
    version = "0.7.11";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "12wyfl7xl7lpz65s17j5rf9xfkn461792f67jqsz0ign3daaac9h";
    libPath = "lib.rs";
    libName = "libgit2_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."libgit2_sys"."0.7.11"."libc"}" deps)
      (crates."libz_sys"."${deps."libgit2_sys"."0.7.11"."libz_sys"}" deps)
    ]
      ++ (if features.libgit2_sys."0.7.11".curl-sys or false then [ (crates.curl_sys."${deps."libgit2_sys"."0.7.11".curl_sys}" deps) ] else [])
      ++ (if features.libgit2_sys."0.7.11".libssh2-sys or false then [ (crates.libssh2_sys."${deps."libgit2_sys"."0.7.11".libssh2_sys}" deps) ] else []))
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
    ]
      ++ (if features.libgit2_sys."0.7.11".openssl-sys or false then [ (crates.openssl_sys."${deps."libgit2_sys"."0.7.11".openssl_sys}" deps) ] else [])) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."libgit2_sys"."0.7.11"."cc"}" deps)
      (crates."pkg_config"."${deps."libgit2_sys"."0.7.11"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."libgit2_sys"."0.7.11" or {});
  };
  features_.libgit2_sys."0.7.11" = deps: f: updateFeatures f (rec {
    cc."${deps.libgit2_sys."0.7.11".cc}".default = true;
    curl_sys."${deps.libgit2_sys."0.7.11".curl_sys}".default = true;
    libc."${deps.libgit2_sys."0.7.11".libc}".default = true;
    libgit2_sys = fold recursiveUpdate {} [
      { "0.7.11".curl-sys =
        (f.libgit2_sys."0.7.11".curl-sys or false) ||
        (f.libgit2_sys."0.7.11".curl or false) ||
        (libgit2_sys."0.7.11"."curl" or false); }
      { "0.7.11".default = (f.libgit2_sys."0.7.11".default or true); }
      { "0.7.11".libssh2-sys =
        (f.libgit2_sys."0.7.11".libssh2-sys or false) ||
        (f.libgit2_sys."0.7.11".ssh or false) ||
        (libgit2_sys."0.7.11"."ssh" or false); }
      { "0.7.11".openssl-sys =
        (f.libgit2_sys."0.7.11".openssl-sys or false) ||
        (f.libgit2_sys."0.7.11".https or false) ||
        (libgit2_sys."0.7.11"."https" or false); }
    ];
    libssh2_sys."${deps.libgit2_sys."0.7.11".libssh2_sys}".default = true;
    libz_sys."${deps.libgit2_sys."0.7.11".libz_sys}".default = true;
    openssl_sys."${deps.libgit2_sys."0.7.11".openssl_sys}".default = true;
    pkg_config."${deps.libgit2_sys."0.7.11".pkg_config}".default = true;
  }) [
    (features_.curl_sys."${deps."libgit2_sys"."0.7.11"."curl_sys"}" deps)
    (features_.libc."${deps."libgit2_sys"."0.7.11"."libc"}" deps)
    (features_.libssh2_sys."${deps."libgit2_sys"."0.7.11"."libssh2_sys"}" deps)
    (features_.libz_sys."${deps."libgit2_sys"."0.7.11"."libz_sys"}" deps)
    (features_.cc."${deps."libgit2_sys"."0.7.11"."cc"}" deps)
    (features_.pkg_config."${deps."libgit2_sys"."0.7.11"."pkg_config"}" deps)
    (features_.openssl_sys."${deps."libgit2_sys"."0.7.11"."openssl_sys"}" deps)
  ];


# end
# libnghttp2-sys-0.1.1

  crates.libnghttp2_sys."0.1.1" = deps: { features?(features_.libnghttp2_sys."0.1.1" deps {}) }: buildRustCrate {
    crateName = "libnghttp2-sys";
    version = "0.1.1";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "08z41i7d8pm0jzv6p77kp22hh0a4psdy109n6nxr8x2k1ibjxk8w";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."libnghttp2_sys"."0.1.1"."libc"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."libnghttp2_sys"."0.1.1"."cc"}" deps)
    ]);
  };
  features_.libnghttp2_sys."0.1.1" = deps: f: updateFeatures f (rec {
    cc."${deps.libnghttp2_sys."0.1.1".cc}".default = true;
    libc."${deps.libnghttp2_sys."0.1.1".libc}".default = true;
    libnghttp2_sys."0.1.1".default = (f.libnghttp2_sys."0.1.1".default or true);
  }) [
    (features_.libc."${deps."libnghttp2_sys"."0.1.1"."libc"}" deps)
    (features_.cc."${deps."libnghttp2_sys"."0.1.1"."cc"}" deps)
  ];


# end
# libssh2-sys-0.2.11

  crates.libssh2_sys."0.2.11" = deps: { features?(features_.libssh2_sys."0.2.11" deps {}) }: buildRustCrate {
    crateName = "libssh2-sys";
    version = "0.2.11";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1mjily9qjjjf31pzvlxyqnp1midjc77s6sd303j46d14igna7nhi";
    libPath = "lib.rs";
    libName = "libssh2_sys";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."libssh2_sys"."0.2.11"."libc"}" deps)
      (crates."libz_sys"."${deps."libssh2_sys"."0.2.11"."libz_sys"}" deps)
    ])
      ++ (if abi == "msvc" then mapFeatures features ([
]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."openssl_sys"."${deps."libssh2_sys"."0.2.11"."openssl_sys"}" deps)
    ]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."libssh2_sys"."0.2.11"."cc"}" deps)
      (crates."pkg_config"."${deps."libssh2_sys"."0.2.11"."pkg_config"}" deps)
    ]);
  };
  features_.libssh2_sys."0.2.11" = deps: f: updateFeatures f (rec {
    cc."${deps.libssh2_sys."0.2.11".cc}".default = true;
    libc."${deps.libssh2_sys."0.2.11".libc}".default = true;
    libssh2_sys."0.2.11".default = (f.libssh2_sys."0.2.11".default or true);
    libz_sys."${deps.libssh2_sys."0.2.11".libz_sys}".default = true;
    openssl_sys."${deps.libssh2_sys."0.2.11".openssl_sys}".default = true;
    pkg_config."${deps.libssh2_sys."0.2.11".pkg_config}".default = true;
  }) [
    (features_.libc."${deps."libssh2_sys"."0.2.11"."libc"}" deps)
    (features_.libz_sys."${deps."libssh2_sys"."0.2.11"."libz_sys"}" deps)
    (features_.cc."${deps."libssh2_sys"."0.2.11"."cc"}" deps)
    (features_.pkg_config."${deps."libssh2_sys"."0.2.11"."pkg_config"}" deps)
    (features_.openssl_sys."${deps."libssh2_sys"."0.2.11"."openssl_sys"}" deps)
  ];


# end
# libz-sys-1.0.25

  crates.libz_sys."1.0.25" = deps: { features?(features_.libz_sys."1.0.25" deps {}) }: buildRustCrate {
    crateName = "libz-sys";
    version = "1.0.25";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "195jzg8mgjbvmkbpx1rzkzrqm0g2fdivk79v44c9lzl64r3f9fym";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."libz_sys"."1.0.25"."libc"}" deps)
    ])
      ++ (if abi == "msvc" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."libz_sys"."1.0.25"."cc"}" deps)
      (crates."pkg_config"."${deps."libz_sys"."1.0.25"."pkg_config"}" deps)
    ]);
    features = mkFeatures (features."libz_sys"."1.0.25" or {});
  };
  features_.libz_sys."1.0.25" = deps: f: updateFeatures f (rec {
    cc."${deps.libz_sys."1.0.25".cc}".default = true;
    libc."${deps.libz_sys."1.0.25".libc}".default = true;
    libz_sys."1.0.25".default = (f.libz_sys."1.0.25".default or true);
    pkg_config."${deps.libz_sys."1.0.25".pkg_config}".default = true;
  }) [
    (features_.libc."${deps."libz_sys"."1.0.25"."libc"}" deps)
    (features_.cc."${deps."libz_sys"."1.0.25"."cc"}" deps)
    (features_.pkg_config."${deps."libz_sys"."1.0.25"."pkg_config"}" deps)
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
    ]);
    features = mkFeatures (features."lock_api"."0.1.5" or {});
  };
  features_.lock_api."0.1.5" = deps: f: updateFeatures f (rec {
    lock_api."0.1.5".default = (f.lock_api."0.1.5".default or true);
    scopeguard."${deps.lock_api."0.1.5".scopeguard}".default = (f.scopeguard."${deps.lock_api."0.1.5".scopeguard}".default or false);
  }) [
    (features_.scopeguard."${deps."lock_api"."0.1.5"."scopeguard"}" deps)
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
# memchr-2.1.3

  crates.memchr."2.1.3" = deps: { features?(features_.memchr."2.1.3" deps {}) }: buildRustCrate {
    crateName = "memchr";
    version = "2.1.3";
    authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
    sha256 = "14nakv3gc8qvjdaal329nxp109zbmn710l2al7zjbcpij6i19nnk";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."memchr"."2.1.3"."cfg_if"}" deps)
    ]
      ++ (if features.memchr."2.1.3".libc or false then [ (crates.libc."${deps."memchr"."2.1.3".libc}" deps) ] else []));
    features = mkFeatures (features."memchr"."2.1.3" or {});
  };
  features_.memchr."2.1.3" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.memchr."2.1.3".cfg_if}".default = true;
    libc = fold recursiveUpdate {} [
      { "${deps.memchr."2.1.3".libc}"."use_std" =
        (f.libc."${deps.memchr."2.1.3".libc}"."use_std" or false) ||
        (memchr."2.1.3"."use_std" or false) ||
        (f."memchr"."2.1.3"."use_std" or false); }
      { "${deps.memchr."2.1.3".libc}".default = (f.libc."${deps.memchr."2.1.3".libc}".default or false); }
    ];
    memchr = fold recursiveUpdate {} [
      { "2.1.3".default = (f.memchr."2.1.3".default or true); }
      { "2.1.3".libc =
        (f.memchr."2.1.3".libc or false) ||
        (f.memchr."2.1.3".default or false) ||
        (memchr."2.1.3"."default" or false) ||
        (f.memchr."2.1.3".use_std or false) ||
        (memchr."2.1.3"."use_std" or false); }
      { "2.1.3".use_std =
        (f.memchr."2.1.3".use_std or false) ||
        (f.memchr."2.1.3".default or false) ||
        (memchr."2.1.3"."default" or false); }
    ];
  }) [
    (features_.cfg_if."${deps."memchr"."2.1.3"."cfg_if"}" deps)
    (features_.libc."${deps."memchr"."2.1.3"."libc"}" deps)
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
# miow-0.3.3

  crates.miow."0.3.3" = deps: { features?(features_.miow."0.3.3" deps {}) }: buildRustCrate {
    crateName = "miow";
    version = "0.3.3";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1mlk5mn00cl6bmf8qlpc6r85dxf4l45vbkbzshsr1mrkb3hn1j57";
    dependencies = mapFeatures features ([
      (crates."socket2"."${deps."miow"."0.3.3"."socket2"}" deps)
      (crates."winapi"."${deps."miow"."0.3.3"."winapi"}" deps)
    ]);
  };
  features_.miow."0.3.3" = deps: f: updateFeatures f (rec {
    miow."0.3.3".default = (f.miow."0.3.3".default or true);
    socket2."${deps.miow."0.3.3".socket2}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.miow."0.3.3".winapi}"."fileapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."handleapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."ioapiset" = true; }
      { "${deps.miow."0.3.3".winapi}"."minwindef" = true; }
      { "${deps.miow."0.3.3".winapi}"."namedpipeapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."ntdef" = true; }
      { "${deps.miow."0.3.3".winapi}"."std" = true; }
      { "${deps.miow."0.3.3".winapi}"."synchapi" = true; }
      { "${deps.miow."0.3.3".winapi}"."winerror" = true; }
      { "${deps.miow."0.3.3".winapi}"."winsock2" = true; }
      { "${deps.miow."0.3.3".winapi}"."ws2def" = true; }
      { "${deps.miow."0.3.3".winapi}"."ws2ipdef" = true; }
      { "${deps.miow."0.3.3".winapi}".default = true; }
    ];
  }) [
    (features_.socket2."${deps."miow"."0.3.3"."socket2"}" deps)
    (features_.winapi."${deps."miow"."0.3.3"."winapi"}" deps)
  ];


# end
# num_cpus-1.9.0

  crates.num_cpus."1.9.0" = deps: { features?(features_.num_cpus."1.9.0" deps {}) }: buildRustCrate {
    crateName = "num_cpus";
    version = "1.9.0";
    authors = [ "Sean McArthur <sean@seanmonstar.com>" ];
    sha256 = "0lv81a9sapkprfsi03rag1mygm9qxhdw2qscdvvx2yb62pc54pvi";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."num_cpus"."1.9.0"."libc"}" deps)
    ]);
  };
  features_.num_cpus."1.9.0" = deps: f: updateFeatures f (rec {
    libc."${deps.num_cpus."1.9.0".libc}".default = true;
    num_cpus."1.9.0".default = (f.num_cpus."1.9.0".default or true);
  }) [
    (features_.libc."${deps."num_cpus"."1.9.0"."libc"}" deps)
  ];


# end
# once_cell-0.1.7

  crates.once_cell."0.1.7" = deps: { features?(features_.once_cell."0.1.7" deps {}) }: buildRustCrate {
    crateName = "once_cell";
    version = "0.1.7";
    authors = [ "Aleksey Kladov <aleksey.kladov@gmail.com>" ];
    sha256 = "0j1293g5wwpvdmcsif2jz1jykh7kp3c36k7cg4g4lbl4xs62vjx1";
    dependencies = mapFeatures features ([
    ]
      ++ (if features.once_cell."0.1.7".parking_lot or false then [ (crates.parking_lot."${deps."once_cell"."0.1.7".parking_lot}" deps) ] else []));
    features = mkFeatures (features."once_cell"."0.1.7" or {});
  };
  features_.once_cell."0.1.7" = deps: f: updateFeatures f (rec {
    once_cell = fold recursiveUpdate {} [
      { "0.1.7".default = (f.once_cell."0.1.7".default or true); }
      { "0.1.7".parking_lot =
        (f.once_cell."0.1.7".parking_lot or false) ||
        (f.once_cell."0.1.7".default or false) ||
        (once_cell."0.1.7"."default" or false); }
    ];
    parking_lot."${deps.once_cell."0.1.7".parking_lot}".default = true;
  }) [
    (features_.parking_lot."${deps."once_cell"."0.1.7"."parking_lot"}" deps)
  ];


# end
# opener-0.3.2

  crates.opener."0.3.2" = deps: { features?(features_.opener."0.3.2" deps {}) }: buildRustCrate {
    crateName = "opener";
    version = "0.3.2";
    authors = [ "Brian Bowman <seeker14491@gmail.com>" ];
    sha256 = "1ql2snax07n3xxn4nz9r6d95rhrri66qy5s5zl9jfsdbs193hzcm";
    dependencies = mapFeatures features ([
      (crates."failure"."${deps."opener"."0.3.2"."failure"}" deps)
      (crates."failure_derive"."${deps."opener"."0.3.2"."failure_derive"}" deps)
    ])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."opener"."0.3.2"."winapi"}" deps)
    ]) else []);
  };
  features_.opener."0.3.2" = deps: f: updateFeatures f (rec {
    failure."${deps.opener."0.3.2".failure}".default = true;
    failure_derive."${deps.opener."0.3.2".failure_derive}".default = true;
    opener."0.3.2".default = (f.opener."0.3.2".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.opener."0.3.2".winapi}"."shellapi" = true; }
      { "${deps.opener."0.3.2".winapi}".default = true; }
    ];
  }) [
    (features_.failure."${deps."opener"."0.3.2"."failure"}" deps)
    (features_.failure_derive."${deps."opener"."0.3.2"."failure_derive"}" deps)
    (features_.winapi."${deps."opener"."0.3.2"."winapi"}" deps)
  ];


# end
# openssl-0.10.16

  crates.openssl."0.10.16" = deps: { features?(features_.openssl."0.10.16" deps {}) }: buildRustCrate {
    crateName = "openssl";
    version = "0.10.16";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "17mi6p323rqkydfwykiba3b1a24j7jv7bmr7j5wai4c32i2khqsm";
    dependencies = mapFeatures features ([
      (crates."bitflags"."${deps."openssl"."0.10.16"."bitflags"}" deps)
      (crates."cfg_if"."${deps."openssl"."0.10.16"."cfg_if"}" deps)
      (crates."foreign_types"."${deps."openssl"."0.10.16"."foreign_types"}" deps)
      (crates."lazy_static"."${deps."openssl"."0.10.16"."lazy_static"}" deps)
      (crates."libc"."${deps."openssl"."0.10.16"."libc"}" deps)
      (crates."openssl_sys"."${deps."openssl"."0.10.16"."openssl_sys"}" deps)
    ]);
    features = mkFeatures (features."openssl"."0.10.16" or {});
  };
  features_.openssl."0.10.16" = deps: f: updateFeatures f (rec {
    bitflags."${deps.openssl."0.10.16".bitflags}".default = true;
    cfg_if."${deps.openssl."0.10.16".cfg_if}".default = true;
    foreign_types."${deps.openssl."0.10.16".foreign_types}".default = true;
    lazy_static."${deps.openssl."0.10.16".lazy_static}".default = true;
    libc."${deps.openssl."0.10.16".libc}".default = true;
    openssl."0.10.16".default = (f.openssl."0.10.16".default or true);
    openssl_sys = fold recursiveUpdate {} [
      { "${deps.openssl."0.10.16".openssl_sys}"."vendored" =
        (f.openssl_sys."${deps.openssl."0.10.16".openssl_sys}"."vendored" or false) ||
        (openssl."0.10.16"."vendored" or false) ||
        (f."openssl"."0.10.16"."vendored" or false); }
      { "${deps.openssl."0.10.16".openssl_sys}".default = true; }
    ];
  }) [
    (features_.bitflags."${deps."openssl"."0.10.16"."bitflags"}" deps)
    (features_.cfg_if."${deps."openssl"."0.10.16"."cfg_if"}" deps)
    (features_.foreign_types."${deps."openssl"."0.10.16"."foreign_types"}" deps)
    (features_.lazy_static."${deps."openssl"."0.10.16"."lazy_static"}" deps)
    (features_.libc."${deps."openssl"."0.10.16"."libc"}" deps)
    (features_.openssl_sys."${deps."openssl"."0.10.16"."openssl_sys"}" deps)
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
# openssl-src-111.1.0+1.1.1a

  crates.openssl_src."111.1.0+1.1.1a" = deps: { features?(features_.openssl_src."111.1.0+1.1.1a" deps {}) }: buildRustCrate {
    crateName = "openssl-src";
    version = "111.1.0+1.1.1a";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1m8z63jqp1v53fbz08figxavg4xbkq33is3q97z1p9aw37csz1fc";
    dependencies = mapFeatures features ([
      (crates."cc"."${deps."openssl_src"."111.1.0+1.1.1a"."cc"}" deps)
    ]);
  };
  features_.openssl_src."111.1.0+1.1.1a" = deps: f: updateFeatures f (rec {
    cc."${deps.openssl_src."111.1.0+1.1.1a".cc}".default = true;
    openssl_src."111.1.0+1.1.1a".default = (f.openssl_src."111.1.0+1.1.1a".default or true);
  }) [
    (features_.cc."${deps."openssl_src"."111.1.0+1.1.1a"."cc"}" deps)
  ];


# end
# openssl-sys-0.9.40

  crates.openssl_sys."0.9.40" = deps: { features?(features_.openssl_sys."0.9.40" deps {}) }: buildRustCrate {
    crateName = "openssl-sys";
    version = "0.9.40";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "11dqyk9g2wdwwj21zma71w5hd5d4sw3hm4pnpk8jjh0wjpkgjdvq";
    build = "build/main.rs";
    dependencies = mapFeatures features ([
      (crates."libc"."${deps."openssl_sys"."0.9.40"."libc"}" deps)
    ])
      ++ (if abi == "msvc" then mapFeatures features ([
]) else []);

    buildDependencies = mapFeatures features ([
      (crates."cc"."${deps."openssl_sys"."0.9.40"."cc"}" deps)
      (crates."pkg_config"."${deps."openssl_sys"."0.9.40"."pkg_config"}" deps)
    ]
      ++ (if features.openssl_sys."0.9.40".openssl-src or false then [ (crates.openssl_src."${deps."openssl_sys"."0.9.40".openssl_src}" deps) ] else []));
    features = mkFeatures (features."openssl_sys"."0.9.40" or {});
  };
  features_.openssl_sys."0.9.40" = deps: f: updateFeatures f (rec {
    cc."${deps.openssl_sys."0.9.40".cc}".default = true;
    libc."${deps.openssl_sys."0.9.40".libc}".default = true;
    openssl_src."${deps.openssl_sys."0.9.40".openssl_src}".default = true;
    openssl_sys = fold recursiveUpdate {} [
      { "0.9.40".default = (f.openssl_sys."0.9.40".default or true); }
      { "0.9.40".openssl-src =
        (f.openssl_sys."0.9.40".openssl-src or false) ||
        (f.openssl_sys."0.9.40".vendored or false) ||
        (openssl_sys."0.9.40"."vendored" or false); }
    ];
    pkg_config."${deps.openssl_sys."0.9.40".pkg_config}".default = true;
  }) [
    (features_.libc."${deps."openssl_sys"."0.9.40"."libc"}" deps)
    (features_.cc."${deps."openssl_sys"."0.9.40"."cc"}" deps)
    (features_.openssl_src."${deps."openssl_sys"."0.9.40"."openssl_src"}" deps)
    (features_.pkg_config."${deps."openssl_sys"."0.9.40"."pkg_config"}" deps)
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
# rand_jitter-0.1.2

  crates.rand_jitter."0.1.2" = deps: { features?(features_.rand_jitter."0.1.2" deps {}) }: buildRustCrate {
    crateName = "rand_jitter";
    version = "0.1.2";
    authors = [ "The Rand Project Developers" ];
    sha256 = "0jrjl1fjag8d27lg8r9nrzkhzqji2idzn6901a0wb70ghc48w1d8";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_jitter"."0.1.2"."rand_core"}" deps)
    ])
      ++ (if kernel == "darwin" || kernel == "ios" then mapFeatures features ([
      (crates."libc"."${deps."rand_jitter"."0.1.2"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand_jitter"."0.1.2"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."rand_jitter"."0.1.2" or {});
  };
  features_.rand_jitter."0.1.2" = deps: f: updateFeatures f (rec {
    libc."${deps.rand_jitter."0.1.2".libc}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_jitter."0.1.2".rand_core}"."std" =
        (f.rand_core."${deps.rand_jitter."0.1.2".rand_core}"."std" or false) ||
        (rand_jitter."0.1.2"."std" or false) ||
        (f."rand_jitter"."0.1.2"."std" or false); }
      { "${deps.rand_jitter."0.1.2".rand_core}".default = true; }
    ];
    rand_jitter."0.1.2".default = (f.rand_jitter."0.1.2".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.rand_jitter."0.1.2".winapi}"."profileapi" = true; }
      { "${deps.rand_jitter."0.1.2".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand_jitter"."0.1.2"."rand_core"}" deps)
    (features_.libc."${deps."rand_jitter"."0.1.2"."libc"}" deps)
    (features_.winapi."${deps."rand_jitter"."0.1.2"."winapi"}" deps)
  ];


# end
# rand_os-0.1.2

  crates.rand_os."0.1.2" = deps: { features?(features_.rand_os."0.1.2" deps {}) }: buildRustCrate {
    crateName = "rand_os";
    version = "0.1.2";
    authors = [ "The Rand Project Developers" ];
    sha256 = "07wzs8zn24gc6kg7sv75dszxswm6kd47zd4c1fg9h1d7bkwd4337";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_os"."0.1.2"."rand_core"}" deps)
    ])
      ++ (if abi == "sgx" then mapFeatures features ([
      (crates."rdrand"."${deps."rand_os"."0.1.2"."rdrand"}" deps)
    ]) else [])
      ++ (if kernel == "cloudabi" then mapFeatures features ([
      (crates."cloudabi"."${deps."rand_os"."0.1.2"."cloudabi"}" deps)
    ]) else [])
      ++ (if kernel == "fuchsia" then mapFeatures features ([
      (crates."fuchsia_cprng"."${deps."rand_os"."0.1.2"."fuchsia_cprng"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."rand_os"."0.1.2"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."rand_os"."0.1.2"."winapi"}" deps)
    ]) else [])
      ++ (if kernel == "wasm32-unknown-unknown" then mapFeatures features ([
]) else []);
  };
  features_.rand_os."0.1.2" = deps: f: updateFeatures f (rec {
    cloudabi."${deps.rand_os."0.1.2".cloudabi}".default = true;
    fuchsia_cprng."${deps.rand_os."0.1.2".fuchsia_cprng}".default = true;
    libc."${deps.rand_os."0.1.2".libc}".default = true;
    rand_core = fold recursiveUpdate {} [
      { "${deps.rand_os."0.1.2".rand_core}"."std" = true; }
      { "${deps.rand_os."0.1.2".rand_core}".default = true; }
    ];
    rand_os."0.1.2".default = (f.rand_os."0.1.2".default or true);
    rdrand."${deps.rand_os."0.1.2".rdrand}".default = true;
    winapi = fold recursiveUpdate {} [
      { "${deps.rand_os."0.1.2".winapi}"."minwindef" = true; }
      { "${deps.rand_os."0.1.2".winapi}"."ntsecapi" = true; }
      { "${deps.rand_os."0.1.2".winapi}"."winnt" = true; }
      { "${deps.rand_os."0.1.2".winapi}".default = true; }
    ];
  }) [
    (features_.rand_core."${deps."rand_os"."0.1.2"."rand_core"}" deps)
    (features_.rdrand."${deps."rand_os"."0.1.2"."rdrand"}" deps)
    (features_.cloudabi."${deps."rand_os"."0.1.2"."cloudabi"}" deps)
    (features_.fuchsia_cprng."${deps."rand_os"."0.1.2"."fuchsia_cprng"}" deps)
    (features_.libc."${deps."rand_os"."0.1.2"."libc"}" deps)
    (features_.winapi."${deps."rand_os"."0.1.2"."winapi"}" deps)
  ];


# end
# rand_pcg-0.1.1

  crates.rand_pcg."0.1.1" = deps: { features?(features_.rand_pcg."0.1.1" deps {}) }: buildRustCrate {
    crateName = "rand_pcg";
    version = "0.1.1";
    authors = [ "The Rand Project Developers" ];
    sha256 = "0x6pzldj0c8c7gmr67ni5i7w2f7n7idvs3ckx0fc3wkhwl7wrbza";
    build = "build.rs";
    dependencies = mapFeatures features ([
      (crates."rand_core"."${deps."rand_pcg"."0.1.1"."rand_core"}" deps)
    ]);

    buildDependencies = mapFeatures features ([
      (crates."rustc_version"."${deps."rand_pcg"."0.1.1"."rustc_version"}" deps)
    ]);
    features = mkFeatures (features."rand_pcg"."0.1.1" or {});
  };
  features_.rand_pcg."0.1.1" = deps: f: updateFeatures f (rec {
    rand_core."${deps.rand_pcg."0.1.1".rand_core}".default = (f.rand_core."${deps.rand_pcg."0.1.1".rand_core}".default or false);
    rand_pcg = fold recursiveUpdate {} [
      { "0.1.1".default = (f.rand_pcg."0.1.1".default or true); }
      { "0.1.1".serde =
        (f.rand_pcg."0.1.1".serde or false) ||
        (f.rand_pcg."0.1.1".serde1 or false) ||
        (rand_pcg."0.1.1"."serde1" or false); }
      { "0.1.1".serde_derive =
        (f.rand_pcg."0.1.1".serde_derive or false) ||
        (f.rand_pcg."0.1.1".serde1 or false) ||
        (rand_pcg."0.1.1"."serde1" or false); }
    ];
    rustc_version."${deps.rand_pcg."0.1.1".rustc_version}".default = true;
  }) [
    (features_.rand_core."${deps."rand_pcg"."0.1.1"."rand_core"}" deps)
    (features_.rustc_version."${deps."rand_pcg"."0.1.1"."rustc_version"}" deps)
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
# regex-1.1.0

  crates.regex."1.1.0" = deps: { features?(features_.regex."1.1.0" deps {}) }: buildRustCrate {
    crateName = "regex";
    version = "1.1.0";
    authors = [ "The Rust Project Developers" ];
    sha256 = "1myzfgs1yp6vs2rxyg6arn6ab05j6c2m922w3b4iv6zix1rl7z0n";
    dependencies = mapFeatures features ([
      (crates."aho_corasick"."${deps."regex"."1.1.0"."aho_corasick"}" deps)
      (crates."memchr"."${deps."regex"."1.1.0"."memchr"}" deps)
      (crates."regex_syntax"."${deps."regex"."1.1.0"."regex_syntax"}" deps)
      (crates."thread_local"."${deps."regex"."1.1.0"."thread_local"}" deps)
      (crates."utf8_ranges"."${deps."regex"."1.1.0"."utf8_ranges"}" deps)
    ]);
    features = mkFeatures (features."regex"."1.1.0" or {});
  };
  features_.regex."1.1.0" = deps: f: updateFeatures f (rec {
    aho_corasick."${deps.regex."1.1.0".aho_corasick}".default = true;
    memchr."${deps.regex."1.1.0".memchr}".default = true;
    regex = fold recursiveUpdate {} [
      { "1.1.0".default = (f.regex."1.1.0".default or true); }
      { "1.1.0".pattern =
        (f.regex."1.1.0".pattern or false) ||
        (f.regex."1.1.0".unstable or false) ||
        (regex."1.1.0"."unstable" or false); }
      { "1.1.0".use_std =
        (f.regex."1.1.0".use_std or false) ||
        (f.regex."1.1.0".default or false) ||
        (regex."1.1.0"."default" or false); }
    ];
    regex_syntax."${deps.regex."1.1.0".regex_syntax}".default = true;
    thread_local."${deps.regex."1.1.0".thread_local}".default = true;
    utf8_ranges."${deps.regex."1.1.0".utf8_ranges}".default = true;
  }) [
    (features_.aho_corasick."${deps."regex"."1.1.0"."aho_corasick"}" deps)
    (features_.memchr."${deps."regex"."1.1.0"."memchr"}" deps)
    (features_.regex_syntax."${deps."regex"."1.1.0"."regex_syntax"}" deps)
    (features_.thread_local."${deps."regex"."1.1.0"."thread_local"}" deps)
    (features_.utf8_ranges."${deps."regex"."1.1.0"."utf8_ranges"}" deps)
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
# rustc-workspace-hack-1.0.0

  crates.rustc_workspace_hack."1.0.0" = deps: { features?(features_.rustc_workspace_hack."1.0.0" deps {}) }: buildRustCrate {
    crateName = "rustc-workspace-hack";
    version = "1.0.0";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "0arpdp472j4lrwxbmf4z21d8kh95rbbphnzccf605pqq2rvczv3p";
  };
  features_.rustc_workspace_hack."1.0.0" = deps: f: updateFeatures f (rec {
    rustc_workspace_hack."1.0.0".default = (f.rustc_workspace_hack."1.0.0".default or true);
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
# rustfix-0.4.4

  crates.rustfix."0.4.4" = deps: { features?(features_.rustfix."0.4.4" deps {}) }: buildRustCrate {
    crateName = "rustfix";
    version = "0.4.4";
    authors = [ "Pascal Hertleif <killercup@gmail.com>" "Oliver Schneider <oli-obk@users.noreply.github.com>" ];
    sha256 = "12yxdqsax5d6i46yybjal001chy03d5yzbllmih83r0z9287xyq9";
    dependencies = mapFeatures features ([
      (crates."failure"."${deps."rustfix"."0.4.4"."failure"}" deps)
      (crates."log"."${deps."rustfix"."0.4.4"."log"}" deps)
      (crates."serde"."${deps."rustfix"."0.4.4"."serde"}" deps)
      (crates."serde_derive"."${deps."rustfix"."0.4.4"."serde_derive"}" deps)
      (crates."serde_json"."${deps."rustfix"."0.4.4"."serde_json"}" deps)
    ]);
  };
  features_.rustfix."0.4.4" = deps: f: updateFeatures f (rec {
    failure."${deps.rustfix."0.4.4".failure}".default = true;
    log."${deps.rustfix."0.4.4".log}".default = true;
    rustfix."0.4.4".default = (f.rustfix."0.4.4".default or true);
    serde."${deps.rustfix."0.4.4".serde}".default = true;
    serde_derive."${deps.rustfix."0.4.4".serde_derive}".default = true;
    serde_json."${deps.rustfix."0.4.4".serde_json}".default = true;
  }) [
    (features_.failure."${deps."rustfix"."0.4.4"."failure"}" deps)
    (features_.log."${deps."rustfix"."0.4.4"."log"}" deps)
    (features_.serde."${deps."rustfix"."0.4.4"."serde"}" deps)
    (features_.serde_derive."${deps."rustfix"."0.4.4"."serde_derive"}" deps)
    (features_.serde_json."${deps."rustfix"."0.4.4"."serde_json"}" deps)
  ];


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
# schannel-0.1.14

  crates.schannel."0.1.14" = deps: { features?(features_.schannel."0.1.14" deps {}) }: buildRustCrate {
    crateName = "schannel";
    version = "0.1.14";
    authors = [ "Steven Fackler <sfackler@gmail.com>" "Steffen Butzer <steffen.butzer@outlook.com>" ];
    sha256 = "1g0a88jknns1kwn3x1k3ci5y5zvg58pwdg1xrxkrw3cwd2hynm9k";
    dependencies = mapFeatures features ([
      (crates."lazy_static"."${deps."schannel"."0.1.14"."lazy_static"}" deps)
      (crates."winapi"."${deps."schannel"."0.1.14"."winapi"}" deps)
    ]);
  };
  features_.schannel."0.1.14" = deps: f: updateFeatures f (rec {
    lazy_static."${deps.schannel."0.1.14".lazy_static}".default = true;
    schannel."0.1.14".default = (f.schannel."0.1.14".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.schannel."0.1.14".winapi}"."lmcons" = true; }
      { "${deps.schannel."0.1.14".winapi}"."minschannel" = true; }
      { "${deps.schannel."0.1.14".winapi}"."schannel" = true; }
      { "${deps.schannel."0.1.14".winapi}"."securitybaseapi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."sspi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."sysinfoapi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."timezoneapi" = true; }
      { "${deps.schannel."0.1.14".winapi}"."winbase" = true; }
      { "${deps.schannel."0.1.14".winapi}"."wincrypt" = true; }
      { "${deps.schannel."0.1.14".winapi}"."winerror" = true; }
      { "${deps.schannel."0.1.14".winapi}".default = true; }
    ];
  }) [
    (features_.lazy_static."${deps."schannel"."0.1.14"."lazy_static"}" deps)
    (features_.winapi."${deps."schannel"."0.1.14"."winapi"}" deps)
  ];


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
# semver-0.9.0

  crates.semver."0.9.0" = deps: { features?(features_.semver."0.9.0" deps {}) }: buildRustCrate {
    crateName = "semver";
    version = "0.9.0";
    authors = [ "Steve Klabnik <steve@steveklabnik.com>" "The Rust Project Developers" ];
    sha256 = "0azak2lb2wc36s3x15az886kck7rpnksrw14lalm157rg9sc9z63";
    dependencies = mapFeatures features ([
      (crates."semver_parser"."${deps."semver"."0.9.0"."semver_parser"}" deps)
    ]
      ++ (if features.semver."0.9.0".serde or false then [ (crates.serde."${deps."semver"."0.9.0".serde}" deps) ] else []));
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
    serde."${deps.semver."0.9.0".serde}".default = true;
  }) [
    (features_.semver_parser."${deps."semver"."0.9.0"."semver_parser"}" deps)
    (features_.serde."${deps."semver"."0.9.0"."serde"}" deps)
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
# serde-1.0.86

  crates.serde."1.0.86" = deps: { features?(features_.serde."1.0.86" deps {}) }: buildRustCrate {
    crateName = "serde";
    version = "1.0.86";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0ydp244wyqfywnq579yw9rxgfb740x5agii9077lsnc2maxp1d4k";
    build = "build.rs";
    dependencies = mapFeatures features ([
]);
    features = mkFeatures (features."serde"."1.0.86" or {});
  };
  features_.serde."1.0.86" = deps: f: updateFeatures f (rec {
    serde = fold recursiveUpdate {} [
      { "1.0.86".default = (f.serde."1.0.86".default or true); }
      { "1.0.86".serde_derive =
        (f.serde."1.0.86".serde_derive or false) ||
        (f.serde."1.0.86".derive or false) ||
        (serde."1.0.86"."derive" or false); }
      { "1.0.86".std =
        (f.serde."1.0.86".std or false) ||
        (f.serde."1.0.86".default or false) ||
        (serde."1.0.86"."default" or false); }
      { "1.0.86".unstable =
        (f.serde."1.0.86".unstable or false) ||
        (f.serde."1.0.86".alloc or false) ||
        (serde."1.0.86"."alloc" or false); }
    ];
  }) [];


# end
# serde_derive-1.0.86

  crates.serde_derive."1.0.86" = deps: { features?(features_.serde_derive."1.0.86" deps {}) }: buildRustCrate {
    crateName = "serde_derive";
    version = "1.0.86";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "0za7q8rp9cp615pi8wnhmdnnxj2nfvl62yfli51plfjd2dxsf616";
    procMacro = true;
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."serde_derive"."1.0.86"."proc_macro2"}" deps)
      (crates."quote"."${deps."serde_derive"."1.0.86"."quote"}" deps)
      (crates."syn"."${deps."serde_derive"."1.0.86"."syn"}" deps)
    ]);
    features = mkFeatures (features."serde_derive"."1.0.86" or {});
  };
  features_.serde_derive."1.0.86" = deps: f: updateFeatures f (rec {
    proc_macro2."${deps.serde_derive."1.0.86".proc_macro2}".default = true;
    quote."${deps.serde_derive."1.0.86".quote}".default = true;
    serde_derive."1.0.86".default = (f.serde_derive."1.0.86".default or true);
    syn = fold recursiveUpdate {} [
      { "${deps.serde_derive."1.0.86".syn}"."visit" = true; }
      { "${deps.serde_derive."1.0.86".syn}".default = true; }
    ];
  }) [
    (features_.proc_macro2."${deps."serde_derive"."1.0.86"."proc_macro2"}" deps)
    (features_.quote."${deps."serde_derive"."1.0.86"."quote"}" deps)
    (features_.syn."${deps."serde_derive"."1.0.86"."syn"}" deps)
  ];


# end
# serde_ignored-0.0.4

  crates.serde_ignored."0.0.4" = deps: { features?(features_.serde_ignored."0.0.4" deps {}) }: buildRustCrate {
    crateName = "serde_ignored";
    version = "0.0.4";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "1ljsywm58p1s645rg2l9mchc5xa6mzxjpm8ag8nc2b74yp09h4jh";
    dependencies = mapFeatures features ([
      (crates."serde"."${deps."serde_ignored"."0.0.4"."serde"}" deps)
    ]);
  };
  features_.serde_ignored."0.0.4" = deps: f: updateFeatures f (rec {
    serde."${deps.serde_ignored."0.0.4".serde}".default = true;
    serde_ignored."0.0.4".default = (f.serde_ignored."0.0.4".default or true);
  }) [
    (features_.serde."${deps."serde_ignored"."0.0.4"."serde"}" deps)
  ];


# end
# serde_json-1.0.38

  crates.serde_json."1.0.38" = deps: { features?(features_.serde_json."1.0.38" deps {}) }: buildRustCrate {
    crateName = "serde_json";
    version = "1.0.38";
    authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "10zhcsk1qh92320fjmgrdd23jf99rr504gp3d5nv9fddy5viq6a1";
    dependencies = mapFeatures features ([
      (crates."itoa"."${deps."serde_json"."1.0.38"."itoa"}" deps)
      (crates."ryu"."${deps."serde_json"."1.0.38"."ryu"}" deps)
      (crates."serde"."${deps."serde_json"."1.0.38"."serde"}" deps)
    ]);
    features = mkFeatures (features."serde_json"."1.0.38" or {});
  };
  features_.serde_json."1.0.38" = deps: f: updateFeatures f (rec {
    itoa."${deps.serde_json."1.0.38".itoa}".default = true;
    ryu."${deps.serde_json."1.0.38".ryu}".default = true;
    serde."${deps.serde_json."1.0.38".serde}".default = true;
    serde_json = fold recursiveUpdate {} [
      { "1.0.38".default = (f.serde_json."1.0.38".default or true); }
      { "1.0.38".indexmap =
        (f.serde_json."1.0.38".indexmap or false) ||
        (f.serde_json."1.0.38".preserve_order or false) ||
        (serde_json."1.0.38"."preserve_order" or false); }
    ];
  }) [
    (features_.itoa."${deps."serde_json"."1.0.38"."itoa"}" deps)
    (features_.ryu."${deps."serde_json"."1.0.38"."ryu"}" deps)
    (features_.serde."${deps."serde_json"."1.0.38"."serde"}" deps)
  ];


# end
# shell-escape-0.1.4

  crates.shell_escape."0.1.4" = deps: { features?(features_.shell_escape."0.1.4" deps {}) }: buildRustCrate {
    crateName = "shell-escape";
    version = "0.1.4";
    authors = [ "Steven Fackler <sfackler@gmail.com>" ];
    sha256 = "02ik28la039b8anx0sx8mbdp2yx66m64mjrjyy6x0dgpbmfxmc24";
  };
  features_.shell_escape."0.1.4" = deps: f: updateFeatures f (rec {
    shell_escape."0.1.4".default = (f.shell_escape."0.1.4".default or true);
  }) [];


# end
# smallvec-0.6.8

  crates.smallvec."0.6.8" = deps: { features?(features_.smallvec."0.6.8" deps {}) }: buildRustCrate {
    crateName = "smallvec";
    version = "0.6.8";
    authors = [ "Simon Sapin <simon.sapin@exyr.org>" ];
    sha256 = "1rqy0k6ilv8yqf9aasrhc7n3gx1m2rpfqfbqzk5wdjmgi4y63m1a";
    libPath = "lib.rs";
    dependencies = mapFeatures features ([
      (crates."unreachable"."${deps."smallvec"."0.6.8"."unreachable"}" deps)
    ]);
    features = mkFeatures (features."smallvec"."0.6.8" or {});
  };
  features_.smallvec."0.6.8" = deps: f: updateFeatures f (rec {
    smallvec = fold recursiveUpdate {} [
      { "0.6.8".default = (f.smallvec."0.6.8".default or true); }
      { "0.6.8".std =
        (f.smallvec."0.6.8".std or false) ||
        (f.smallvec."0.6.8".default or false) ||
        (smallvec."0.6.8"."default" or false); }
    ];
    unreachable."${deps.smallvec."0.6.8".unreachable}".default = true;
  }) [
    (features_.unreachable."${deps."smallvec"."0.6.8"."unreachable"}" deps)
  ];


# end
# socket2-0.3.8

  crates.socket2."0.3.8" = deps: { features?(features_.socket2."0.3.8" deps {}) }: buildRustCrate {
    crateName = "socket2";
    version = "0.3.8";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1a71m20jxmf9kqqinksphc7wj1j7q672q29cpza7p9siyzyfx598";
    dependencies = (if (kernel == "linux" || kernel == "darwin") || kernel == "redox" then mapFeatures features ([
      (crates."cfg_if"."${deps."socket2"."0.3.8"."cfg_if"}" deps)
      (crates."libc"."${deps."socket2"."0.3.8"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."socket2"."0.3.8"."redox_syscall"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."socket2"."0.3.8"."winapi"}" deps)
    ]) else []);
    features = mkFeatures (features."socket2"."0.3.8" or {});
  };
  features_.socket2."0.3.8" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.socket2."0.3.8".cfg_if}".default = true;
    libc."${deps.socket2."0.3.8".libc}".default = true;
    redox_syscall."${deps.socket2."0.3.8".redox_syscall}".default = true;
    socket2."0.3.8".default = (f.socket2."0.3.8".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.socket2."0.3.8".winapi}"."handleapi" = true; }
      { "${deps.socket2."0.3.8".winapi}"."minwindef" = true; }
      { "${deps.socket2."0.3.8".winapi}"."ws2def" = true; }
      { "${deps.socket2."0.3.8".winapi}"."ws2ipdef" = true; }
      { "${deps.socket2."0.3.8".winapi}"."ws2tcpip" = true; }
      { "${deps.socket2."0.3.8".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."socket2"."0.3.8"."cfg_if"}" deps)
    (features_.libc."${deps."socket2"."0.3.8"."libc"}" deps)
    (features_.redox_syscall."${deps."socket2"."0.3.8"."redox_syscall"}" deps)
    (features_.winapi."${deps."socket2"."0.3.8"."winapi"}" deps)
  ];


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
# syn-0.15.26

  crates.syn."0.15.26" = deps: { features?(features_.syn."0.15.26" deps {}) }: buildRustCrate {
    crateName = "syn";
    version = "0.15.26";
    authors = [ "David Tolnay <dtolnay@gmail.com>" ];
    sha256 = "12kf63vxbiirycv10zzxw3g8a3cxblmpi6kx4xxz4csd15wapxid";
    dependencies = mapFeatures features ([
      (crates."proc_macro2"."${deps."syn"."0.15.26"."proc_macro2"}" deps)
      (crates."unicode_xid"."${deps."syn"."0.15.26"."unicode_xid"}" deps)
    ]
      ++ (if features.syn."0.15.26".quote or false then [ (crates.quote."${deps."syn"."0.15.26".quote}" deps) ] else []));
    features = mkFeatures (features."syn"."0.15.26" or {});
  };
  features_.syn."0.15.26" = deps: f: updateFeatures f (rec {
    proc_macro2 = fold recursiveUpdate {} [
      { "${deps.syn."0.15.26".proc_macro2}"."proc-macro" =
        (f.proc_macro2."${deps.syn."0.15.26".proc_macro2}"."proc-macro" or false) ||
        (syn."0.15.26"."proc-macro" or false) ||
        (f."syn"."0.15.26"."proc-macro" or false); }
      { "${deps.syn."0.15.26".proc_macro2}".default = (f.proc_macro2."${deps.syn."0.15.26".proc_macro2}".default or false); }
    ];
    quote = fold recursiveUpdate {} [
      { "${deps.syn."0.15.26".quote}"."proc-macro" =
        (f.quote."${deps.syn."0.15.26".quote}"."proc-macro" or false) ||
        (syn."0.15.26"."proc-macro" or false) ||
        (f."syn"."0.15.26"."proc-macro" or false); }
      { "${deps.syn."0.15.26".quote}".default = (f.quote."${deps.syn."0.15.26".quote}".default or false); }
    ];
    syn = fold recursiveUpdate {} [
      { "0.15.26".clone-impls =
        (f.syn."0.15.26".clone-impls or false) ||
        (f.syn."0.15.26".default or false) ||
        (syn."0.15.26"."default" or false); }
      { "0.15.26".default = (f.syn."0.15.26".default or true); }
      { "0.15.26".derive =
        (f.syn."0.15.26".derive or false) ||
        (f.syn."0.15.26".default or false) ||
        (syn."0.15.26"."default" or false); }
      { "0.15.26".parsing =
        (f.syn."0.15.26".parsing or false) ||
        (f.syn."0.15.26".default or false) ||
        (syn."0.15.26"."default" or false); }
      { "0.15.26".printing =
        (f.syn."0.15.26".printing or false) ||
        (f.syn."0.15.26".default or false) ||
        (syn."0.15.26"."default" or false); }
      { "0.15.26".proc-macro =
        (f.syn."0.15.26".proc-macro or false) ||
        (f.syn."0.15.26".default or false) ||
        (syn."0.15.26"."default" or false); }
      { "0.15.26".quote =
        (f.syn."0.15.26".quote or false) ||
        (f.syn."0.15.26".printing or false) ||
        (syn."0.15.26"."printing" or false); }
    ];
    unicode_xid."${deps.syn."0.15.26".unicode_xid}".default = true;
  }) [
    (features_.proc_macro2."${deps."syn"."0.15.26"."proc_macro2"}" deps)
    (features_.quote."${deps."syn"."0.15.26"."quote"}" deps)
    (features_.unicode_xid."${deps."syn"."0.15.26"."unicode_xid"}" deps)
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
# tar-0.4.20

  crates.tar."0.4.20" = deps: { features?(features_.tar."0.4.20" deps {}) }: buildRustCrate {
    crateName = "tar";
    version = "0.4.20";
    authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
    sha256 = "1nk51cirksnlq67lqbxh7bmq7kdwkkcys5x169nc5v4k6c53rska";
    dependencies = mapFeatures features ([
      (crates."filetime"."${deps."tar"."0.4.20"."filetime"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."tar"."0.4.20"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."tar"."0.4.20"."libc"}" deps)
    ]) else []);
  };
  features_.tar."0.4.20" = deps: f: updateFeatures f (rec {
    filetime."${deps.tar."0.4.20".filetime}".default = true;
    libc."${deps.tar."0.4.20".libc}".default = true;
    redox_syscall."${deps.tar."0.4.20".redox_syscall}".default = true;
    tar = fold recursiveUpdate {} [
      { "0.4.20".default = (f.tar."0.4.20".default or true); }
      { "0.4.20".xattr =
        (f.tar."0.4.20".xattr or false) ||
        (f.tar."0.4.20".default or false) ||
        (tar."0.4.20"."default" or false); }
    ];
  }) [
    (features_.filetime."${deps."tar"."0.4.20"."filetime"}" deps)
    (features_.redox_syscall."${deps."tar"."0.4.20"."redox_syscall"}" deps)
    (features_.libc."${deps."tar"."0.4.20"."libc"}" deps)
  ];


# end
# tempfile-3.0.5

  crates.tempfile."3.0.5" = deps: { features?(features_.tempfile."3.0.5" deps {}) }: buildRustCrate {
    crateName = "tempfile";
    version = "3.0.5";
    authors = [ "Steven Allen <steven@stebalien.com>" "The Rust Project Developers" "Ashley Mannix <ashleymannix@live.com.au>" "Jason White <jasonaw0@gmail.com>" ];
    sha256 = "11xc89br78ypk4g27v51lm2baz57gp6v555i3sxhrj9qlas2iqfl";
    dependencies = mapFeatures features ([
      (crates."cfg_if"."${deps."tempfile"."3.0.5"."cfg_if"}" deps)
      (crates."rand"."${deps."tempfile"."3.0.5"."rand"}" deps)
      (crates."remove_dir_all"."${deps."tempfile"."3.0.5"."remove_dir_all"}" deps)
    ])
      ++ (if kernel == "redox" then mapFeatures features ([
      (crates."redox_syscall"."${deps."tempfile"."3.0.5"."redox_syscall"}" deps)
    ]) else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then mapFeatures features ([
      (crates."libc"."${deps."tempfile"."3.0.5"."libc"}" deps)
    ]) else [])
      ++ (if kernel == "windows" then mapFeatures features ([
      (crates."winapi"."${deps."tempfile"."3.0.5"."winapi"}" deps)
    ]) else []);
  };
  features_.tempfile."3.0.5" = deps: f: updateFeatures f (rec {
    cfg_if."${deps.tempfile."3.0.5".cfg_if}".default = true;
    libc."${deps.tempfile."3.0.5".libc}".default = true;
    rand."${deps.tempfile."3.0.5".rand}".default = true;
    redox_syscall."${deps.tempfile."3.0.5".redox_syscall}".default = true;
    remove_dir_all."${deps.tempfile."3.0.5".remove_dir_all}".default = true;
    tempfile."3.0.5".default = (f.tempfile."3.0.5".default or true);
    winapi = fold recursiveUpdate {} [
      { "${deps.tempfile."3.0.5".winapi}"."fileapi" = true; }
      { "${deps.tempfile."3.0.5".winapi}"."handleapi" = true; }
      { "${deps.tempfile."3.0.5".winapi}"."winbase" = true; }
      { "${deps.tempfile."3.0.5".winapi}".default = true; }
    ];
  }) [
    (features_.cfg_if."${deps."tempfile"."3.0.5"."cfg_if"}" deps)
    (features_.rand."${deps."tempfile"."3.0.5"."rand"}" deps)
    (features_.remove_dir_all."${deps."tempfile"."3.0.5"."remove_dir_all"}" deps)
    (features_.redox_syscall."${deps."tempfile"."3.0.5"."redox_syscall"}" deps)
    (features_.libc."${deps."tempfile"."3.0.5"."libc"}" deps)
    (features_.winapi."${deps."tempfile"."3.0.5"."winapi"}" deps)
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
# unreachable-1.0.0

  crates.unreachable."1.0.0" = deps: { features?(features_.unreachable."1.0.0" deps {}) }: buildRustCrate {
    crateName = "unreachable";
    version = "1.0.0";
    authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
    sha256 = "1am8czbk5wwr25gbp2zr007744fxjshhdqjz9liz7wl4pnv3whcf";
    dependencies = mapFeatures features ([
      (crates."void"."${deps."unreachable"."1.0.0"."void"}" deps)
    ]);
  };
  features_.unreachable."1.0.0" = deps: f: updateFeatures f (rec {
    unreachable."1.0.0".default = (f.unreachable."1.0.0".default or true);
    void."${deps.unreachable."1.0.0".void}".default = (f.void."${deps.unreachable."1.0.0".void}".default or false);
  }) [
    (features_.void."${deps."unreachable"."1.0.0"."void"}" deps)
  ];


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
}

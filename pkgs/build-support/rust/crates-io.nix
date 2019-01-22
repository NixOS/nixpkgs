{ lib, buildRustCrate, buildRustCrateHelpers }:
with buildRustCrateHelpers;
let inherit (lib.lists) fold;
    inherit (lib.attrsets) recursiveUpdate;
in
rec {
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

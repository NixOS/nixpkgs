{ buildPlatform, buildRustCrate, fetchgit, ... }:
let kernel = buildPlatform.parsed.kernel.name;
    abi = buildPlatform.parsed.abi.name;
    aho_corasick_0_6_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "aho-corasick";
      version = "0.6.3";
      authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
      sha256 = "1cpqzf6acj8lm06z3f1cg41wn6c2n9l3v49nh0dvimv4055qib6k";
      libName = "aho_corasick";
      crateBin = [ {  name = "aho-corasick-dot"; } ];
      inherit dependencies buildDependencies features;
    };
    ansi_term_0_10_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "ansi_term";
      version = "0.10.2";
      authors = [ "ogham@bsago.me" "Ryan Scheel (Havvy) <ryan.havvy@gmail.com>" "Josh Triplett <josh@joshtriplett.org>" ];
      sha256 = "07k0hfmlhv43lihyxb9d81l5mq5zlpqvv30dkfd3knmv2ginasn9";
      inherit dependencies buildDependencies features;
    };
    atty_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "atty";
      version = "0.2.3";
      authors = [ "softprops <d.tangren@gmail.com>" ];
      sha256 = "0zl0cjfgarp5y78nd755lpki5bbkj4hgmi88v265m543yg29i88f";
      inherit dependencies buildDependencies features;
    };
    backtrace_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "backtrace";
      version = "0.3.4";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" "The Rust Project Developers" ];
      sha256 = "1caba8w3rqd5ghr88ghyz5wgkf81dgx18bj1llkax6qmianc6gk7";
      inherit dependencies buildDependencies features;
    };
    backtrace_sys_0_1_16_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "backtrace-sys";
      version = "0.1.16";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
      sha256 = "1cn2c8q3dn06crmnk0p62czkngam4l8nf57wy33nz1y5g25pszwy";
      build = "build.rs";
      inherit dependencies buildDependencies features;
    };
    bitflags_0_7_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "bitflags";
      version = "0.7.0";
      authors = [ "The Rust Project Developers" ];
      sha256 = "1hr72xg5slm0z4pxs2hiy4wcyx3jva70h58b7mid8l0a4c8f7gn5";
      inherit dependencies buildDependencies features;
    };
    bitflags_1_0_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "bitflags";
      version = "1.0.1";
      authors = [ "The Rust Project Developers" ];
      sha256 = "0p4b3nr0s5nda2qmm7xdhnvh4lkqk3xd8l9ffmwbvqw137vx7mj1";
      inherit dependencies buildDependencies features;
    };
    carnix_0_4_10_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "carnix";
      version = "0.4.10";
      authors = [ "pe@pijul.org <pe@pijul.org>" ];
      sha256 = "06zsvylwc21vrwgrr9lbg39kp5p71nil4vcwkk292j0wrm28s32z";
      inherit dependencies buildDependencies features;
    };
    cc_1_0_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "cc";
      version = "1.0.3";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
      sha256 = "193pwqgh79w6k0k29svyds5nnlrwx44myqyrw605d5jj4yk2zmpr";
      inherit dependencies buildDependencies features;
    };
    cfg_if_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "cfg-if";
      version = "0.1.2";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
      sha256 = "0x06hvrrqy96m97593823vvxcgvjaxckghwyy2jcyc8qc7c6cyhi";
      inherit dependencies buildDependencies features;
    };
    clap_2_28_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "clap";
      version = "2.28.0";
      authors = [ "Kevin K. <kbknapp@gmail.com>" ];
      sha256 = "0m0rj9xw6mja4gdhqmaldv0q5y5jfsfzbyzfd70mm3857aynq03k";
      inherit dependencies buildDependencies features;
    };
    dbghelp_sys_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "dbghelp-sys";
      version = "0.2.0";
      authors = [ "Peter Atashian <retep998@gmail.com>" ];
      sha256 = "0ylpi3bbiy233m57hnisn1df1v0lbl7nsxn34b0anzsgg440hqpq";
      libName = "dbghelp";
      build = "build.rs";
      inherit dependencies buildDependencies features;
    };
    dtoa_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "dtoa";
      version = "0.4.2";
      authors = [ "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "1bxsh6fags7nr36vlz07ik2a1rzyipc8x1y30kjk832hf2pzadmw";
      inherit dependencies buildDependencies features;
    };
    either_1_4_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "either";
      version = "1.4.0";
      authors = [ "bluss" ];
      sha256 = "04kpfd84lvyrkb2z4sljlz2d3d5qczd0sb1yy37fgijq2yx3vb37";
      inherit dependencies buildDependencies features;
    };
    env_logger_0_4_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "env_logger";
      version = "0.4.3";
      authors = [ "The Rust Project Developers" ];
      sha256 = "0nrx04p4xa86d5kc7aq4fwvipbqji9cmgy449h47nc9f1chafhgg";
      inherit dependencies buildDependencies features;
    };
    error_chain_0_11_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "error-chain";
      version = "0.11.0";
      authors = [ "Brian Anderson <banderson@mozilla.com>" "Paul Colomiets <paul@colomiets.name>" "Colin Kiegel <kiegel@gmx.de>" "Yamakaky <yamakaky@yamaworld.fr>" ];
      sha256 = "19nz17q6dzp0mx2jhh9qbj45gkvvgcl7zq9z2ai5a8ihbisfj6d7";
      inherit dependencies buildDependencies features;
    };
    fuchsia_zircon_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "fuchsia-zircon";
      version = "0.2.1";
      authors = [ "Raph Levien <raph@google.com>" ];
      sha256 = "0yd4rd7ql1vdr349p6vgq2dnwmpylky1kjp8g1zgvp250jxrhddb";
      inherit dependencies buildDependencies features;
    };
    fuchsia_zircon_sys_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "fuchsia-zircon-sys";
      version = "0.2.0";
      authors = [ "Raph Levien <raph@google.com>" ];
      sha256 = "1yrqsrjwlhl3di6prxf5xmyd82gyjaysldbka5wwk83z11mpqh4w";
      inherit dependencies buildDependencies features;
    };
    itertools_0_7_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "itertools";
      version = "0.7.3";
      authors = [ "bluss" ];
      sha256 = "128a69cnmgpj38rs6lcwzya773d2vx7f9y7012iycjf9yi2pyckj";
      inherit dependencies buildDependencies features;
    };
    itoa_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "itoa";
      version = "0.3.4";
      authors = [ "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "1nfkzz6vrgj0d9l3yzjkkkqzdgs68y294fjdbl7jq118qi8xc9d9";
      inherit dependencies buildDependencies features;
    };
    kernel32_sys_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "kernel32-sys";
      version = "0.2.2";
      authors = [ "Peter Atashian <retep998@gmail.com>" ];
      sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
      libName = "kernel32";
      build = "build.rs";
      inherit dependencies buildDependencies features;
    };
    lazy_static_0_2_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "lazy_static";
      version = "0.2.11";
      authors = [ "Marvin Löbel <loebel.marvin@gmail.com>" ];
      sha256 = "1x6871cvpy5b96yv4c7jvpq316fp5d4609s9py7qk6cd6x9k34vm";
      inherit dependencies buildDependencies features;
    };
    libc_0_2_33_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "libc";
      version = "0.2.33";
      authors = [ "The Rust Project Developers" ];
      sha256 = "1l7synziccnvarsq2kk22vps720ih6chmn016bhr2bq54hblbnl1";
      inherit dependencies buildDependencies features;
    };
    libsqlite3_sys_0_9_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "libsqlite3-sys";
      version = "0.9.0";
      authors = [ "John Gallagher <jgallagher@bignerdranch.com>" ];
      sha256 = "1pnx3i9h85si6cs4nhazfb28hsvk7dn0arnfvpdzpjdnj9z38q57";
      build = "build.rs";
      inherit dependencies buildDependencies features;
    };
    linked_hash_map_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "linked-hash-map";
      version = "0.4.2";
      authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" "Andrew Paseltiner <apaseltiner@gmail.com>" ];
      sha256 = "04da208h6jb69f46j37jnvsw2i1wqplglp4d61csqcrhh83avbgl";
      inherit dependencies buildDependencies features;
    };
    log_0_3_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "log";
      version = "0.3.8";
      authors = [ "The Rust Project Developers" ];
      sha256 = "1c43z4z85sxrsgir4s1hi84558ab5ic7jrn5qgmsiqcv90vvn006";
      inherit dependencies buildDependencies features;
    };
    lru_cache_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "lru-cache";
      version = "0.1.1";
      authors = [ "Stepan Koltsov <stepan.koltsov@gmail.com>" ];
      sha256 = "1hl6kii1g54sq649gnscv858mmw7a02xj081l4vcgvrswdi2z8fw";
      inherit dependencies buildDependencies features;
    };
    memchr_1_0_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "memchr";
      version = "1.0.2";
      authors = [ "Andrew Gallant <jamslam@gmail.com>" "bluss" ];
      sha256 = "0dfb8ifl9nrc9kzgd5z91q6qg87sh285q1ih7xgrsglmqfav9lg7";
      inherit dependencies buildDependencies features;
    };
    nom_3_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "nom";
      version = "3.2.1";
      authors = [ "contact@geoffroycouprie.com" ];
      sha256 = "1vcllxrz9hdw6j25kn020ka3psz1vkaqh1hm3yfak2240zrxgi07";
      inherit dependencies buildDependencies features;
    };
    num_traits_0_1_40_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "num-traits";
      version = "0.1.40";
      authors = [ "The Rust Project Developers" ];
      sha256 = "1fr8ghp4i97q3agki54i0hpmqxv3s65i2mqd1pinc7w7arc3fplw";
      inherit dependencies buildDependencies features;
    };
    pkg_config_0_3_9_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "pkg-config";
      version = "0.3.9";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
      sha256 = "06k8fxgrsrxj8mjpjcq1n7mn2p1shpxif4zg9y5h09c7vy20s146";
      inherit dependencies buildDependencies features;
    };
    quote_0_3_15_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "quote";
      version = "0.3.15";
      authors = [ "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
      inherit dependencies buildDependencies features;
    };
    rand_0_3_18_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "rand";
      version = "0.3.18";
      authors = [ "The Rust Project Developers" ];
      sha256 = "15d7c3myn968dzjs0a2pgv58hzdavxnq6swgj032lw2v966ir4xv";
      inherit dependencies buildDependencies features;
    };
    redox_syscall_0_1_32_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "redox_syscall";
      version = "0.1.32";
      authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
      sha256 = "1axxj8x6ngh6npkzqc5h216fajkcyrdxdgb7m2f0n5xfclbk47fv";
      libName = "syscall";
      inherit dependencies buildDependencies features;
    };
    redox_termios_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "redox_termios";
      version = "0.1.1";
      authors = [ "Jeremy Soller <jackpot51@gmail.com>" ];
      sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
      libPath = "src/lib.rs";
      inherit dependencies buildDependencies features;
    };
    regex_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "regex";
      version = "0.2.2";
      authors = [ "The Rust Project Developers" ];
      sha256 = "1f1zrrynfylg0vcfyfp60bybq4rp5g1yk2k7lc7fyz7mmc7k2qr7";
      inherit dependencies buildDependencies features;
    };
    regex_syntax_0_4_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "regex-syntax";
      version = "0.4.1";
      authors = [ "The Rust Project Developers" ];
      sha256 = "01yrsm68lj86ad1whgg1z95c2pfsvv58fz8qjcgw7mlszc0c08ls";
      inherit dependencies buildDependencies features;
    };
    rusqlite_0_13_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "rusqlite";
      version = "0.13.0";
      authors = [ "John Gallagher <jgallagher@bignerdranch.com>" ];
      sha256 = "1hj2464ar2y4324sk3jx7m9byhkcp60krrrs1v1i8dlhhlnkb9hc";
      inherit dependencies buildDependencies features;
    };
    rustc_demangle_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "rustc-demangle";
      version = "0.1.5";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
      sha256 = "096kkcx9j747700fhxj1s4rlwkj21pqjmvj64psdj6bakb2q13nc";
      inherit dependencies buildDependencies features;
    };
    serde_1_0_21_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "serde";
      version = "1.0.21";
      authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "10almq7pvx8s4ryiqk8gf7fj5igl0yq6dcjknwc67rkmxd8q50w3";
      inherit dependencies buildDependencies features;
    };
    serde_derive_1_0_21_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "serde_derive";
      version = "1.0.21";
      authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "0r20qyimm9scfaz7lc0swnhik9d045zklmbidd0zzpd4b2f3jsqm";
      procMacro = true;
      inherit dependencies buildDependencies features;
    };
    serde_derive_internals_0_17_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "serde_derive_internals";
      version = "0.17.0";
      authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "1g1j3v6pj9wbcz3v3w4smjpwrcdwjicmf6yd5cbai04as9iwhw74";
      inherit dependencies buildDependencies features;
    };
    serde_json_1_0_6_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "serde_json";
      version = "1.0.6";
      authors = [ "Erick Tryzelaar <erick.tryzelaar@gmail.com>" "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "1kacyc59splwbg8gr7qs32pp9smgy1khq0ggnv07yxhs7h355vjz";
      inherit dependencies buildDependencies features;
    };
    strsim_0_6_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "strsim";
      version = "0.6.0";
      authors = [ "Danny Guo <dannyguo91@gmail.com>" ];
      sha256 = "1lz85l6y68hr62lv4baww29yy7g8pg20dlr0lbaswxmmcb0wl7gd";
      inherit dependencies buildDependencies features;
    };
    syn_0_11_11_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "syn";
      version = "0.11.11";
      authors = [ "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "0yw8ng7x1dn5a6ykg0ib49y7r9nhzgpiq2989rqdp7rdz3n85502";
      inherit dependencies buildDependencies features;
    };
    synom_0_11_3_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "synom";
      version = "0.11.3";
      authors = [ "David Tolnay <dtolnay@gmail.com>" ];
      sha256 = "1l6d1s9qjfp6ng2s2z8219igvlv7gyk8gby97sdykqc1r93d8rhc";
      inherit dependencies buildDependencies features;
    };
    tempdir_0_3_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "tempdir";
      version = "0.3.5";
      authors = [ "The Rust Project Developers" ];
      sha256 = "0rirc5prqppzgd15fm8ayan349lgk2k5iqdkrbwrwrv5pm4znsnz";
      inherit dependencies buildDependencies features;
    };
    termion_1_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "termion";
      version = "1.5.1";
      authors = [ "ticki <Ticki@users.noreply.github.com>" "gycos <alexandre.bury@gmail.com>" "IGI-111 <igi-111@protonmail.com>" ];
      sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
      inherit dependencies buildDependencies features;
    };
    textwrap_0_9_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "textwrap";
      version = "0.9.0";
      authors = [ "Martin Geisler <martin@geisler.net>" ];
      sha256 = "18jg79ndjlwndz01mlbh82kkr2arqm658yn5kwp65l5n1hz8w4yb";
      inherit dependencies buildDependencies features;
    };
    thread_local_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "thread_local";
      version = "0.3.4";
      authors = [ "Amanieu d'Antras <amanieu@gmail.com>" ];
      sha256 = "1y6cwyhhx2nkz4b3dziwhqdvgq830z8wjp32b40pjd8r0hxqv2jr";
      inherit dependencies buildDependencies features;
    };
    time_0_1_38_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "time";
      version = "0.1.38";
      authors = [ "The Rust Project Developers" ];
      sha256 = "1ws283vvz7c6jfiwn53rmc6kybapr4pjaahfxxrz232b0qzw7gcp";
      inherit dependencies buildDependencies features;
    };
    toml_0_4_5_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "toml";
      version = "0.4.5";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" ];
      sha256 = "06zxqhn3y58yzjfaykhcrvlf7p2dnn54kn3g4apmja3cn5b18lkk";
      inherit dependencies buildDependencies features;
    };
    unicode_width_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "unicode-width";
      version = "0.1.4";
      authors = [ "kwantam <kwantam@gmail.com>" ];
      sha256 = "1rp7a04icn9y5c0lm74nrd4py0rdl0af8bhdwq7g478n1xifpifl";
      inherit dependencies buildDependencies features;
    };
    unicode_xid_0_0_4_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "unicode-xid";
      version = "0.0.4";
      authors = [ "erick.tryzelaar <erick.tryzelaar@gmail.com>" "kwantam <kwantam@gmail.com>" ];
      sha256 = "1dc8wkkcd3s6534s5aw4lbjn8m67flkkbnajp5bl8408wdg8rh9v";
      inherit dependencies buildDependencies features;
    };
    unreachable_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "unreachable";
      version = "1.0.0";
      authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
      sha256 = "1am8czbk5wwr25gbp2zr007744fxjshhdqjz9liz7wl4pnv3whcf";
      inherit dependencies buildDependencies features;
    };
    utf8_ranges_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "utf8-ranges";
      version = "1.0.0";
      authors = [ "Andrew Gallant <jamslam@gmail.com>" ];
      sha256 = "0rzmqprwjv9yp1n0qqgahgm24872x6c0xddfym5pfndy7a36vkn0";
      inherit dependencies buildDependencies features;
    };
    vcpkg_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "vcpkg";
      version = "0.2.2";
      authors = [ "Jim McGrath <jimmc2@gmail.com>" ];
      sha256 = "1fl5j0ksnwrnsrf1b1a9lqbjgnajdipq0030vsbhx81mb7d9478a";
      inherit dependencies buildDependencies features;
    };
    vec_map_0_8_0_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "vec_map";
      version = "0.8.0";
      authors = [ "Alex Crichton <alex@alexcrichton.com>" "Jorge Aparicio <japaricious@gmail.com>" "Alexis Beingessner <a.beingessner@gmail.com>" "Brian Anderson <>" "tbu- <>" "Manish Goregaokar <>" "Aaron Turon <aturon@mozilla.com>" "Adolfo Ochagavía <>" "Niko Matsakis <>" "Steven Fackler <>" "Chase Southwood <csouth3@illinois.edu>" "Eduard Burtescu <>" "Florian Wilkens <>" "Félix Raimundo <>" "Tibor Benke <>" "Markus Siemens <markus@m-siemens.de>" "Josh Branchaud <jbranchaud@gmail.com>" "Huon Wilson <dbau.pp@gmail.com>" "Corey Farwell <coref@rwell.org>" "Aaron Liblong <>" "Nick Cameron <nrc@ncameron.org>" "Patrick Walton <pcwalton@mimiga.net>" "Felix S Klock II <>" "Andrew Paseltiner <apaseltiner@gmail.com>" "Sean McArthur <sean.monstar@gmail.com>" "Vadim Petrochenkov <>" ];
      sha256 = "07sgxp3cf1a4cxm9n3r27fcvqmld32bl2576mrcahnvm34j11xay";
      inherit dependencies buildDependencies features;
    };
    void_1_0_2_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "void";
      version = "1.0.2";
      authors = [ "Jonathan Reem <jonathan.reem@gmail.com>" ];
      sha256 = "0h1dm0dx8dhf56a83k68mijyxigqhizpskwxfdrs1drwv2cdclv3";
      inherit dependencies buildDependencies features;
    };
    winapi_0_2_8_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "winapi";
      version = "0.2.8";
      authors = [ "Peter Atashian <retep998@gmail.com>" ];
      sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
      inherit dependencies buildDependencies features;
    };
    winapi_build_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: buildRustCrate {
      crateName = "winapi-build";
      version = "0.1.1";
      authors = [ "Peter Atashian <retep998@gmail.com>" ];
      sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
      libName = "build";
      inherit dependencies buildDependencies features;
    };

in
rec {
  aho_corasick_0_6_3 = aho_corasick_0_6_3_ {
    dependencies = [ memchr_1_0_2 ];
  };
  ansi_term_0_10_2 = ansi_term_0_10_2_ {};
  atty_0_2_3 = atty_0_2_3_ {
    dependencies = (if kernel == "redox" then [ termion_1_5_1 ] else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then [ libc_0_2_33 ] else [])
      ++ (if kernel == "windows" then [ kernel32_sys_0_2_2 winapi_0_2_8 ] else []);
  };
  backtrace_0_3_4 = backtrace_0_3_4_ {
    dependencies = [ cfg_if_0_1_2 rustc_demangle_0_1_5 ]
      ++ (if (kernel == "linux" || kernel == "darwin") && !(kernel == "fuchsia") && !(kernel == "emscripten") && !(kernel == "darwin") && !(kernel == "ios") then [ backtrace_sys_0_1_16 ] else [])
      ++ (if (kernel == "linux" || kernel == "darwin") then [ libc_0_2_33 ] else [])
      ++ (if kernel == "windows" then [ dbghelp_sys_0_2_0 kernel32_sys_0_2_2 winapi_0_2_8 ] else []);
    features = [ "backtrace-sys" "coresymbolication" "dbghelp" "dbghelp-sys" "dladdr" "kernel32-sys" "libbacktrace" "libunwind" "winapi" ];
  };
  backtrace_sys_0_1_16 = backtrace_sys_0_1_16_ {
    dependencies = [ libc_0_2_33 ];
    buildDependencies = [ cc_1_0_3 ];
  };
  bitflags_0_7_0 = bitflags_0_7_0_ {};
  bitflags_1_0_1 = bitflags_1_0_1_ {
    features = [ "example_generated" ];
  };
  carnix_0_4_10 = carnix_0_4_10_ {
    dependencies = [ clap_2_28_0 env_logger_0_4_3 error_chain_0_11_0 itertools_0_7_3 log_0_3_8 nom_3_2_1 regex_0_2_2 rusqlite_0_13_0 serde_1_0_21 serde_derive_1_0_21 serde_json_1_0_6 tempdir_0_3_5 toml_0_4_5 ];
  };
  cc_1_0_3 = cc_1_0_3_ {
    dependencies = [];
  };
  cfg_if_0_1_2 = cfg_if_0_1_2_ {};
  clap_2_28_0 = clap_2_28_0_ {
    dependencies = [ ansi_term_0_10_2 atty_0_2_3 bitflags_1_0_1 strsim_0_6_0 textwrap_0_9_0 unicode_width_0_1_4 vec_map_0_8_0 ];
    features = [ "ansi_term" "atty" "color" "strsim" "suggestions" "vec_map" ];
  };
  dbghelp_sys_0_2_0 = dbghelp_sys_0_2_0_ {
    dependencies = [ winapi_0_2_8 ];
    buildDependencies = [ winapi_build_0_1_1 ];
  };
  dtoa_0_4_2 = dtoa_0_4_2_ {};
  either_1_4_0 = either_1_4_0_ {
    features = [ "use_std" ];
  };
  env_logger_0_4_3 = env_logger_0_4_3_ {
    dependencies = [ log_0_3_8 regex_0_2_2 ];
    features = [ "regex" ];
  };
  error_chain_0_11_0 = error_chain_0_11_0_ {
    dependencies = [ backtrace_0_3_4 ];
    features = [ "backtrace" "example_generated" ];
  };
  fuchsia_zircon_0_2_1 = fuchsia_zircon_0_2_1_ {
    dependencies = [ fuchsia_zircon_sys_0_2_0 ];
  };
  fuchsia_zircon_sys_0_2_0 = fuchsia_zircon_sys_0_2_0_ {
    dependencies = [ bitflags_0_7_0 ];
  };
  itertools_0_7_3 = itertools_0_7_3_ {
    dependencies = [ either_1_4_0 ];
    features = [ "use_std" ];
  };
  itoa_0_3_4 = itoa_0_3_4_ {};
  kernel32_sys_0_2_2 = kernel32_sys_0_2_2_ {
    dependencies = [ winapi_0_2_8 ];
    buildDependencies = [ winapi_build_0_1_1 ];
  };
  lazy_static_0_2_11 = lazy_static_0_2_11_ {};
  libc_0_2_33 = libc_0_2_33_ {
    features = [ "use_std" ];
  };
  libsqlite3_sys_0_9_0 = libsqlite3_sys_0_9_0_ {
    dependencies = (if abi == "msvc" then [] else []);
    buildDependencies = [ pkg_config_0_3_9 ];
    features = [ "min_sqlite_version_3_6_8" "pkg-config" "vcpkg" ];
  };
  linked_hash_map_0_4_2 = linked_hash_map_0_4_2_ {};
  log_0_3_8 = log_0_3_8_ {
    features = [ "use_std" ];
  };
  lru_cache_0_1_1 = lru_cache_0_1_1_ {
    dependencies = [ linked_hash_map_0_4_2 ];
  };
  memchr_1_0_2 = memchr_1_0_2_ {
    dependencies = [ libc_0_2_33 ];
    features = [ "libc" "use_std" ];
  };
  nom_3_2_1 = nom_3_2_1_ {
    dependencies = [ memchr_1_0_2 ];
    features = [ "std" "stream" ];
  };
  num_traits_0_1_40 = num_traits_0_1_40_ {};
  pkg_config_0_3_9 = pkg_config_0_3_9_ {};
  quote_0_3_15 = quote_0_3_15_ {};
  rand_0_3_18 = rand_0_3_18_ {
    dependencies = [ libc_0_2_33 ]
      ++ (if kernel == "fuchsia" then [ fuchsia_zircon_0_2_1 ] else []);
  };
  redox_syscall_0_1_32 = redox_syscall_0_1_32_ {};
  redox_termios_0_1_1 = redox_termios_0_1_1_ {
    dependencies = [ redox_syscall_0_1_32 ];
  };
  regex_0_2_2 = regex_0_2_2_ {
    dependencies = [ aho_corasick_0_6_3 memchr_1_0_2 regex_syntax_0_4_1 thread_local_0_3_4 utf8_ranges_1_0_0 ];
  };
  regex_syntax_0_4_1 = regex_syntax_0_4_1_ {};
  rusqlite_0_13_0 = rusqlite_0_13_0_ {
    dependencies = [ bitflags_1_0_1 libsqlite3_sys_0_9_0 lru_cache_0_1_1 time_0_1_38 ];
  };
  rustc_demangle_0_1_5 = rustc_demangle_0_1_5_ {};
  serde_1_0_21 = serde_1_0_21_ {
    features = [ "std" ];
  };
  serde_derive_1_0_21 = serde_derive_1_0_21_ {
    dependencies = [ quote_0_3_15 serde_derive_internals_0_17_0 syn_0_11_11 ];
  };
  serde_derive_internals_0_17_0 = serde_derive_internals_0_17_0_ {
    dependencies = [ syn_0_11_11 synom_0_11_3 ];
  };
  serde_json_1_0_6 = serde_json_1_0_6_ {
    dependencies = [ dtoa_0_4_2 itoa_0_3_4 num_traits_0_1_40 serde_1_0_21 ];
  };
  strsim_0_6_0 = strsim_0_6_0_ {};
  syn_0_11_11 = syn_0_11_11_ {
    dependencies = [ quote_0_3_15 synom_0_11_3 unicode_xid_0_0_4 ];
    features = [ "parsing" "printing" "quote" "synom" "unicode-xid" "visit" ];
  };
  synom_0_11_3 = synom_0_11_3_ {
    dependencies = [ unicode_xid_0_0_4 ];
  };
  tempdir_0_3_5 = tempdir_0_3_5_ {
    dependencies = [ rand_0_3_18 ];
  };
  termion_1_5_1 = termion_1_5_1_ {
    dependencies = (if !(kernel == "redox") then [ libc_0_2_33 ] else [])
      ++ (if kernel == "redox" then [ redox_syscall_0_1_32 redox_termios_0_1_1 ] else []);
  };
  textwrap_0_9_0 = textwrap_0_9_0_ {
    dependencies = [ unicode_width_0_1_4 ];
  };
  thread_local_0_3_4 = thread_local_0_3_4_ {
    dependencies = [ lazy_static_0_2_11 unreachable_1_0_0 ];
  };
  time_0_1_38 = time_0_1_38_ {
    dependencies = [ libc_0_2_33 ]
      ++ (if kernel == "redox" then [ redox_syscall_0_1_32 ] else [])
      ++ (if kernel == "windows" then [ kernel32_sys_0_2_2 winapi_0_2_8 ] else []);
  };
  toml_0_4_5 = toml_0_4_5_ {
    dependencies = [ serde_1_0_21 ];
  };
  unicode_width_0_1_4 = unicode_width_0_1_4_ {};
  unicode_xid_0_0_4 = unicode_xid_0_0_4_ {};
  unreachable_1_0_0 = unreachable_1_0_0_ {
    dependencies = [ void_1_0_2 ];
  };
  utf8_ranges_1_0_0 = utf8_ranges_1_0_0_ {};
  vcpkg_0_2_2 = vcpkg_0_2_2_ {};
  vec_map_0_8_0 = vec_map_0_8_0_ {};
  void_1_0_2 = void_1_0_2_ {
    features = [ "std" ];
  };
  winapi_0_2_8 = winapi_0_2_8_ {};
  winapi_build_0_1_1 = winapi_build_0_1_1_ {};
}

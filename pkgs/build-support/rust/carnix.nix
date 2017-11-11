# This file contains the nix expression necessary to compile carnix, a
# tool to generate nix expression from Rust Cargo.lock files.
#
# Starts with functions that output crates, and then calls them with
# the proper dependencies computed from the carnix's own Cargo.lock.

{ pkgs, ... }:
with pkgs;
let release = true;
    verbose = true;
    aho_corasick_0_6_3_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "aho-corasick";
      version = "0.6.3";
      sha256 = "1cpqzf6acj8lm06z3f1cg41wn6c2n9l3v49nh0dvimv4055qib6k";
      libName = "aho_corasick";
      crateBin = [ {  name = "aho-corasick-dot"; } ];
      inherit dependencies buildDependencies features release verbose;
    };
    ansi_term_0_9_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "ansi_term";
      version = "0.9.0";
      sha256 = "1vcd8m2hglrdi4zmqnkkz5zy3c73ifgii245k7vj6qr5dzpn9hij";
      inherit dependencies buildDependencies features release verbose;
    };
    atty_0_2_3_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "atty";
      version = "0.2.3";
      sha256 = "0zl0cjfgarp5y78nd755lpki5bbkj4hgmi88v265m543yg29i88f";
      inherit dependencies buildDependencies features release verbose;
    };
    backtrace_0_3_3_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "backtrace";
      version = "0.3.3";
      sha256 = "0invfdxkj85v8zyrjs3amfxjdk2a36x8irq7wq7kny6q49hh8y0z";
      inherit dependencies buildDependencies features release verbose;
    };
    backtrace_sys_0_1_16_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "backtrace-sys";
      version = "0.1.16";
      sha256 = "1cn2c8q3dn06crmnk0p62czkngam4l8nf57wy33nz1y5g25pszwy";
      build = "build.rs";
      inherit dependencies buildDependencies features release verbose;
    };
    bitflags_0_7_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "bitflags";
      version = "0.7.0";
      sha256 = "1hr72xg5slm0z4pxs2hiy4wcyx3jva70h58b7mid8l0a4c8f7gn5";
      inherit dependencies buildDependencies features release verbose;
    };
    bitflags_0_9_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "bitflags";
      version = "0.9.1";
      sha256 = "18h073l5jd88rx4qdr95fjddr9rk79pb1aqnshzdnw16cfmb9rws";
      inherit dependencies buildDependencies features release verbose;
    };
    carnix_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "carnix";
      version = "0.4.2";
      sha256 = "1p13ba4wh19zkrrpba0vpgv47k2lx05pxh7nwcwc9yi710qs3mf3";
      inherit dependencies buildDependencies features release verbose;
    };
    cc_1_0_3_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "cc";
      version = "1.0.3";
      sha256 = "193pwqgh79w6k0k29svyds5nnlrwx44myqyrw605d5jj4yk2zmpr";
      inherit dependencies buildDependencies features release verbose;
    };
    cfg_if_0_1_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "cfg-if";
      version = "0.1.2";
      sha256 = "0x06hvrrqy96m97593823vvxcgvjaxckghwyy2jcyc8qc7c6cyhi";
      inherit dependencies buildDependencies features release verbose;
    };
    clap_2_27_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "clap";
      version = "2.27.1";
      sha256 = "0zx8rskqfl3iqn3vlyxzyd99hpifa7bm871akhxpz9wvrm688zaj";
      inherit dependencies buildDependencies features release verbose;
    };
    dbghelp_sys_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "dbghelp-sys";
      version = "0.2.0";
      sha256 = "0ylpi3bbiy233m57hnisn1df1v0lbl7nsxn34b0anzsgg440hqpq";
      libName = "dbghelp";
      build = "build.rs";
      inherit dependencies buildDependencies features release verbose;
    };
    dtoa_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "dtoa";
      version = "0.4.2";
      sha256 = "1bxsh6fags7nr36vlz07ik2a1rzyipc8x1y30kjk832hf2pzadmw";
      inherit dependencies buildDependencies features release verbose;
    };
    env_logger_0_4_3_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "env_logger";
      version = "0.4.3";
      sha256 = "0nrx04p4xa86d5kc7aq4fwvipbqji9cmgy449h47nc9f1chafhgg";
      inherit dependencies buildDependencies features release verbose;
    };
    error_chain_0_11_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "error-chain";
      version = "0.11.0";
      sha256 = "19nz17q6dzp0mx2jhh9qbj45gkvvgcl7zq9z2ai5a8ihbisfj6d7";
      inherit dependencies buildDependencies features release verbose;
    };
    fuchsia_zircon_0_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "fuchsia-zircon";
      version = "0.2.1";
      sha256 = "0yd4rd7ql1vdr349p6vgq2dnwmpylky1kjp8g1zgvp250jxrhddb";
      inherit dependencies buildDependencies features release verbose;
    };
    fuchsia_zircon_sys_0_2_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "fuchsia-zircon-sys";
      version = "0.2.0";
      sha256 = "1yrqsrjwlhl3di6prxf5xmyd82gyjaysldbka5wwk83z11mpqh4w";
      inherit dependencies buildDependencies features release verbose;
    };
    itoa_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "itoa";
      version = "0.3.4";
      sha256 = "1nfkzz6vrgj0d9l3yzjkkkqzdgs68y294fjdbl7jq118qi8xc9d9";
      inherit dependencies buildDependencies features release verbose;
    };
    kernel32_sys_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "kernel32-sys";
      version = "0.2.2";
      sha256 = "1lrw1hbinyvr6cp28g60z97w32w8vsk6pahk64pmrv2fmby8srfj";
      libName = "kernel32";
      build = "build.rs";
      inherit dependencies buildDependencies features release verbose;
    };
    lazy_static_0_2_9_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "lazy_static";
      version = "0.2.9";
      sha256 = "08ldzr5292y3hvi6l6v8l4i6v95lm1aysmnfln65h10sqrfh6iw7";
      inherit dependencies buildDependencies features release verbose;
    };
    libc_0_2_33_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "libc";
      version = "0.2.33";
      sha256 = "1l7synziccnvarsq2kk22vps720ih6chmn016bhr2bq54hblbnl1";
      inherit dependencies buildDependencies features release verbose;
    };
    libsqlite3_sys_0_8_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "libsqlite3-sys";
      version = "0.8.1";
      sha256 = "131bjlxzni2aw3048p7sj8cs3v0jpkb3fxdpc5i7ndyhvpz3gdza";
      buildInputs = [ pkgs.sqlite pkgs.pkgconfig ];
      build = "build.rs";
      inherit dependencies buildDependencies features release verbose;
    };
    linked_hash_map_0_4_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "linked-hash-map";
      version = "0.4.2";
      sha256 = "04da208h6jb69f46j37jnvsw2i1wqplglp4d61csqcrhh83avbgl";
      inherit dependencies buildDependencies features release verbose;
    };
    log_0_3_8_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "log";
      version = "0.3.8";
      sha256 = "1c43z4z85sxrsgir4s1hi84558ab5ic7jrn5qgmsiqcv90vvn006";
      inherit dependencies buildDependencies features release verbose;
    };
    lru_cache_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "lru-cache";
      version = "0.1.1";
      sha256 = "1hl6kii1g54sq649gnscv858mmw7a02xj081l4vcgvrswdi2z8fw";
      inherit dependencies buildDependencies features release verbose;
    };
    memchr_1_0_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "memchr";
      version = "1.0.2";
      sha256 = "0dfb8ifl9nrc9kzgd5z91q6qg87sh285q1ih7xgrsglmqfav9lg7";
      inherit dependencies buildDependencies features release verbose;
    };
    nom_3_2_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "nom";
      version = "3.2.1";
      sha256 = "1vcllxrz9hdw6j25kn020ka3psz1vkaqh1hm3yfak2240zrxgi07";
      inherit dependencies buildDependencies features release verbose;
    };
    num_traits_0_1_40_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "num-traits";
      version = "0.1.40";
      sha256 = "1fr8ghp4i97q3agki54i0hpmqxv3s65i2mqd1pinc7w7arc3fplw";
      inherit dependencies buildDependencies features release verbose;
    };
    pkg_config_0_3_9_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "pkg-config";
      version = "0.3.9";
      sha256 = "06k8fxgrsrxj8mjpjcq1n7mn2p1shpxif4zg9y5h09c7vy20s146";
      inherit dependencies buildDependencies features release verbose;
    };
    quote_0_3_15_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "quote";
      version = "0.3.15";
      sha256 = "09il61jv4kd1360spaj46qwyl21fv1qz18fsv2jra8wdnlgl5jsg";
      inherit dependencies buildDependencies features release verbose;
    };
    rand_0_3_18_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "rand";
      version = "0.3.18";
      sha256 = "15d7c3myn968dzjs0a2pgv58hzdavxnq6swgj032lw2v966ir4xv";
      inherit dependencies buildDependencies features release verbose;
    };
    redox_syscall_0_1_31_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "redox_syscall";
      version = "0.1.31";
      sha256 = "0kipd9qslzin4fgj4jrxv6yz5l3l71gnbd7fq1jhk2j7f2sq33j4";
      libName = "syscall";
      inherit dependencies buildDependencies features release verbose;
    };
    redox_termios_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "redox_termios";
      version = "0.1.1";
      sha256 = "04s6yyzjca552hdaqlvqhp3vw0zqbc304md5czyd3axh56iry8wh";
      libPath = "src/lib.rs";
      inherit dependencies buildDependencies features release verbose;
    };
    regex_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "regex";
      version = "0.2.2";
      sha256 = "1f1zrrynfylg0vcfyfp60bybq4rp5g1yk2k7lc7fyz7mmc7k2qr7";
      inherit dependencies buildDependencies features release verbose;
    };
    regex_syntax_0_4_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "regex-syntax";
      version = "0.4.1";
      sha256 = "01yrsm68lj86ad1whgg1z95c2pfsvv58fz8qjcgw7mlszc0c08ls";
      inherit dependencies buildDependencies features release verbose;
    };
    rusqlite_0_12_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "rusqlite";
      version = "0.12.0";
      sha256 = "18fybr7bd012j7axf4gzpphx0iil2amksdlab4dhhipjl6hyam6j";
      inherit dependencies buildDependencies features release verbose;
    };
    rustc_demangle_0_1_5_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "rustc-demangle";
      version = "0.1.5";
      sha256 = "096kkcx9j747700fhxj1s4rlwkj21pqjmvj64psdj6bakb2q13nc";
      inherit dependencies buildDependencies features release verbose;
    };
    serde_1_0_19_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "serde";
      version = "1.0.19";
      sha256 = "0dfhkkbrpr0vr1b2hhbddizb8bq4phi5ck0jhy3yx31bc2byb1l1";
      inherit dependencies buildDependencies features release verbose;
    };
    serde_derive_1_0_19_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "serde_derive";
      version = "1.0.19";
      sha256 = "1fbr1zi25fgwy49mvpjq8g611mnv3vcd4n0mgca2lfdsp5n2nw5v";
      procMacro = true;
      inherit dependencies buildDependencies features release verbose;
    };
    serde_derive_internals_0_17_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "serde_derive_internals";
      version = "0.17.0";
      sha256 = "1g1j3v6pj9wbcz3v3w4smjpwrcdwjicmf6yd5cbai04as9iwhw74";
      inherit dependencies buildDependencies features release verbose;
    };
    serde_json_1_0_5_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "serde_json";
      version = "1.0.5";
      sha256 = "1yka3aa2gfi30415jpf0935k54r08jhyw6r7rjz2nv1kqgbw2brs";
      inherit dependencies buildDependencies features release verbose;
    };
    strsim_0_6_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "strsim";
      version = "0.6.0";
      sha256 = "1lz85l6y68hr62lv4baww29yy7g8pg20dlr0lbaswxmmcb0wl7gd";
      inherit dependencies buildDependencies features release verbose;
    };
    syn_0_11_11_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "syn";
      version = "0.11.11";
      sha256 = "0yw8ng7x1dn5a6ykg0ib49y7r9nhzgpiq2989rqdp7rdz3n85502";
      inherit dependencies buildDependencies features release verbose;
    };
    synom_0_11_3_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "synom";
      version = "0.11.3";
      sha256 = "1l6d1s9qjfp6ng2s2z8219igvlv7gyk8gby97sdykqc1r93d8rhc";
      inherit dependencies buildDependencies features release verbose;
    };
    tempdir_0_3_5_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "tempdir";
      version = "0.3.5";
      sha256 = "0rirc5prqppzgd15fm8ayan349lgk2k5iqdkrbwrwrv5pm4znsnz";
      inherit dependencies buildDependencies features release verbose;
    };
    termion_1_5_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "termion";
      version = "1.5.1";
      sha256 = "02gq4vd8iws1f3gjrgrgpajsk2bk43nds5acbbb4s8dvrdvr8nf1";
      inherit dependencies buildDependencies features release verbose;
    };
    textwrap_0_9_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "textwrap";
      version = "0.9.0";
      sha256 = "18jg79ndjlwndz01mlbh82kkr2arqm658yn5kwp65l5n1hz8w4yb";
      inherit dependencies buildDependencies features release verbose;
    };
    thread_local_0_3_4_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "thread_local";
      version = "0.3.4";
      sha256 = "1y6cwyhhx2nkz4b3dziwhqdvgq830z8wjp32b40pjd8r0hxqv2jr";
      inherit dependencies buildDependencies features release verbose;
    };
    time_0_1_38_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "time";
      version = "0.1.38";
      sha256 = "1ws283vvz7c6jfiwn53rmc6kybapr4pjaahfxxrz232b0qzw7gcp";
      inherit dependencies buildDependencies features release verbose;
    };
    toml_0_4_5_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "toml";
      version = "0.4.5";
      sha256 = "06zxqhn3y58yzjfaykhcrvlf7p2dnn54kn3g4apmja3cn5b18lkk";
      inherit dependencies buildDependencies features release verbose;
    };
    unicode_width_0_1_4_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "unicode-width";
      version = "0.1.4";
      sha256 = "1rp7a04icn9y5c0lm74nrd4py0rdl0af8bhdwq7g478n1xifpifl";
      inherit dependencies buildDependencies features release verbose;
    };
    unicode_xid_0_0_4_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "unicode-xid";
      version = "0.0.4";
      sha256 = "1dc8wkkcd3s6534s5aw4lbjn8m67flkkbnajp5bl8408wdg8rh9v";
      inherit dependencies buildDependencies features release verbose;
    };
    unreachable_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "unreachable";
      version = "1.0.0";
      sha256 = "1am8czbk5wwr25gbp2zr007744fxjshhdqjz9liz7wl4pnv3whcf";
      inherit dependencies buildDependencies features release verbose;
    };
    utf8_ranges_1_0_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "utf8-ranges";
      version = "1.0.0";
      sha256 = "0rzmqprwjv9yp1n0qqgahgm24872x6c0xddfym5pfndy7a36vkn0";
      inherit dependencies buildDependencies features release verbose;
    };
    vcpkg_0_2_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "vcpkg";
      version = "0.2.2";
      sha256 = "1fl5j0ksnwrnsrf1b1a9lqbjgnajdipq0030vsbhx81mb7d9478a";
      inherit dependencies buildDependencies features release verbose;
    };
    vec_map_0_8_0_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "vec_map";
      version = "0.8.0";
      sha256 = "07sgxp3cf1a4cxm9n3r27fcvqmld32bl2576mrcahnvm34j11xay";
      inherit dependencies buildDependencies features release verbose;
    };
    void_1_0_2_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "void";
      version = "1.0.2";
      sha256 = "0h1dm0dx8dhf56a83k68mijyxigqhizpskwxfdrs1drwv2cdclv3";
      inherit dependencies buildDependencies features release verbose;
    };
    winapi_0_2_8_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "winapi";
      version = "0.2.8";
      sha256 = "0a45b58ywf12vb7gvj6h3j264nydynmzyqz8d8rqxsj6icqv82as";
      inherit dependencies buildDependencies features release verbose;
    };
    winapi_build_0_1_1_ = { dependencies?[], buildDependencies?[], features?[] }: mkRustCrate {
      crateName = "winapi-build";
      version = "0.1.1";
      sha256 = "1lxlpi87rkhxcwp2ykf1ldw3p108hwm24nywf3jfrvmff4rjhqga";
      libName = "build";
      inherit dependencies buildDependencies features release verbose;
    };

in
rec {
  aho_corasick_0_6_3 = aho_corasick_0_6_3_ {
    dependencies = [ memchr_1_0_2 ];
  };
  ansi_term_0_9_0 = ansi_term_0_9_0_ {};
  atty_0_2_3 = atty_0_2_3_ {
    dependencies = (if buildPlatform.parsed.kernel.name == "redox" then [ termion_1_5_1 ] else [])
      ++ (if (buildPlatform.parsed.kernel.name == "linux" || buildPlatform.parsed.kernel.name == "darwin") then [ libc_0_2_33 ] else [])
      ++ (if buildPlatform.parsed.kernel.name == "windows" then [ kernel32_sys_0_2_2 winapi_0_2_8 ] else []);
  };
  backtrace_0_3_3 = backtrace_0_3_3_ {
    dependencies = [ cfg_if_0_1_2 rustc_demangle_0_1_5 ]
      ++ (if (buildPlatform.parsed.kernel.name == "linux" || buildPlatform.parsed.kernel.name == "darwin") && !(buildPlatform.parsed.kernel.name == "emscripten") && !(buildPlatform.parsed.kernel.name == "darwin") && !(buildPlatform.parsed.kernel.name == "ios") then [ backtrace_sys_0_1_16 ] else [])
      ++ (if (buildPlatform.parsed.kernel.name == "linux" || buildPlatform.parsed.kernel.name == "darwin") then [ libc_0_2_33 ] else [])
      ++ (if buildPlatform.parsed.kernel.name == "windows" then [ dbghelp_sys_0_2_0 kernel32_sys_0_2_2 winapi_0_2_8 ] else []);
    features = [ "backtrace-sys" "coresymbolication" "dbghelp" "dbghelp-sys" "dladdr" "kernel32-sys" "libbacktrace" "libunwind" "winapi" ];
  };
  backtrace_sys_0_1_16 = backtrace_sys_0_1_16_ {
    dependencies = [ libc_0_2_33 ];
    buildDependencies = [ cc_1_0_3 ];
  };
  bitflags_0_7_0 = bitflags_0_7_0_ {};
  bitflags_0_9_1 = bitflags_0_9_1_ {
    features = [ "example_generated" ];
  };
  carnix_0_4_2 = carnix_0_4_2_ {
    dependencies = [ clap_2_27_1 env_logger_0_4_3 error_chain_0_11_0 log_0_3_8 nom_3_2_1 regex_0_2_2 rusqlite_0_12_0 serde_1_0_19 serde_derive_1_0_19 serde_json_1_0_5 tempdir_0_3_5 toml_0_4_5 ];
  };
  cc_1_0_3 = cc_1_0_3_ {
    dependencies = [];
  };
  cfg_if_0_1_2 = cfg_if_0_1_2_ {};
  clap_2_27_1 = clap_2_27_1_ {
    dependencies = [ ansi_term_0_9_0 atty_0_2_3 bitflags_0_9_1 strsim_0_6_0 textwrap_0_9_0 unicode_width_0_1_4 vec_map_0_8_0 ];
    features = [ "ansi_term" "atty" "color" "strsim" "suggestions" "vec_map" ];
  };
  dbghelp_sys_0_2_0 = dbghelp_sys_0_2_0_ {
    dependencies = [ winapi_0_2_8 ];
    buildDependencies = [ winapi_build_0_1_1 ];
  };
  dtoa_0_4_2 = dtoa_0_4_2_ {};
  env_logger_0_4_3 = env_logger_0_4_3_ {
    dependencies = [ log_0_3_8 regex_0_2_2 ];
    features = [ "regex" ];
  };
  error_chain_0_11_0 = error_chain_0_11_0_ {
    dependencies = [ backtrace_0_3_3 ];
    features = [ "backtrace" "example_generated" ];
  };
  fuchsia_zircon_0_2_1 = fuchsia_zircon_0_2_1_ {
    dependencies = [ fuchsia_zircon_sys_0_2_0 ];
  };
  fuchsia_zircon_sys_0_2_0 = fuchsia_zircon_sys_0_2_0_ {
    dependencies = [ bitflags_0_7_0 ];
  };
  itoa_0_3_4 = itoa_0_3_4_ {};
  kernel32_sys_0_2_2 = kernel32_sys_0_2_2_ {
    dependencies = [ winapi_0_2_8 ];
    buildDependencies = [ winapi_build_0_1_1 ];
  };
  lazy_static_0_2_9 = lazy_static_0_2_9_ {};
  libc_0_2_33 = libc_0_2_33_ {
    features = [ "use_std" ];
  };
  libsqlite3_sys_0_8_1 = libsqlite3_sys_0_8_1_ {
    dependencies = (if buildPlatform.parsed.abi.name == "msvc" then [] else []);
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
      ++ (if buildPlatform.parsed.kernel.name == "fuchsia" then [ fuchsia_zircon_0_2_1 ] else []);
  };
  redox_syscall_0_1_31 = redox_syscall_0_1_31_ {};
  redox_termios_0_1_1 = redox_termios_0_1_1_ {
    dependencies = [ redox_syscall_0_1_31 ];
  };
  regex_0_2_2 = regex_0_2_2_ {
    dependencies = [ aho_corasick_0_6_3 memchr_1_0_2 regex_syntax_0_4_1 thread_local_0_3_4 utf8_ranges_1_0_0 ];
  };
  regex_syntax_0_4_1 = regex_syntax_0_4_1_ {};
  rusqlite_0_12_0 = rusqlite_0_12_0_ {
    dependencies = [ bitflags_0_9_1 libsqlite3_sys_0_8_1 lru_cache_0_1_1 time_0_1_38 ];
  };
  rustc_demangle_0_1_5 = rustc_demangle_0_1_5_ {};
  serde_1_0_19 = serde_1_0_19_ {
    features = [ "std" ];
  };
  serde_derive_1_0_19 = serde_derive_1_0_19_ {
    dependencies = [ quote_0_3_15 serde_derive_internals_0_17_0 syn_0_11_11 ];
  };
  serde_derive_internals_0_17_0 = serde_derive_internals_0_17_0_ {
    dependencies = [ syn_0_11_11 synom_0_11_3 ];
  };
  serde_json_1_0_5 = serde_json_1_0_5_ {
    dependencies = [ dtoa_0_4_2 itoa_0_3_4 num_traits_0_1_40 serde_1_0_19 ];
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
    dependencies = (if !(buildPlatform.parsed.kernel.name == "redox") then [ libc_0_2_33 ] else [])
      ++ (if buildPlatform.parsed.kernel.name == "redox" then [ redox_syscall_0_1_31 redox_termios_0_1_1 ] else []);
  };
  textwrap_0_9_0 = textwrap_0_9_0_ {
    dependencies = [ unicode_width_0_1_4 ];
  };
  thread_local_0_3_4 = thread_local_0_3_4_ {
    dependencies = [ lazy_static_0_2_9 unreachable_1_0_0 ];
  };
  time_0_1_38 = time_0_1_38_ {
    dependencies = [ libc_0_2_33 ]
      ++ (if buildPlatform.parsed.kernel.name == "redox" then [ redox_syscall_0_1_31 ] else [])
      ++ (if buildPlatform.parsed.kernel.name == "windows" then [ kernel32_sys_0_2_2 winapi_0_2_8 ] else []);
  };
  toml_0_4_5 = toml_0_4_5_ {
    dependencies = [ serde_1_0_19 ];
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

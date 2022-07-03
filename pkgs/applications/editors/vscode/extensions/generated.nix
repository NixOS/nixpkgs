{ buildVscodeMarketplaceExtension, lib }:
{
  attilabuti.brainfuck-syntax = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "attilabuti";
      name = "brainfuck-syntax";
      version = "0.0.1";
      sha256 = "10dif892p04f2nqxv6cnmhzfqlbw412ns5p3msg80smnhqg6bik5";
    };
    meta.license = [ lib.licenses.mit ];
  };
  oderwat.indent-rainbow = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "oderwat";
      name = "indent-rainbow";
      version = "8.3.1";
      sha256 = "0iwd6y2x2nx52hd3bsav3rrhr7dnl4n79ln09picmnh1mp4rrs3l";
    };
    meta.license = [ lib.licenses.mit ];
  };
  phoenixframework.phoenix = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "phoenixframework";
      name = "phoenix";
      version = "0.1.1";
      sha256 = "0pd1s6f1lm96y1q9d9aj7sa8n0vc0cjrggiyyh1azwa5h59v1w01";
    };
    meta.license = [ lib.licenses.mit ];
  };
  redhat.java = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "redhat";
      name = "java";
      version = "1.9.2022070104";
      sha256 = "182dr8rziddkmmiv5jvgr7ybilrh83wrfqj8ykwzgsybymks1a2b";
    };
    meta.license = [ lib.licenses.epl20 ];
  };
  redhat.vscode-yaml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "redhat";
      name = "vscode-yaml";
      version = "1.8.0";
      sha256 = "1djd4mxnfrrlgiyrqjrrchza3q229sy57d71dggvf6f5k2wnj1qv";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rioj7.commandOnAllFiles = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rioj7";
      name = "commandOnAllFiles";
      version = "0.3.0";
      sha256 = "04f1sb5rxjwkmidpymhqanv8wvp04pnw66098836dns906p4gldl";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rubymaniac.vscode-paste-and-indent = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rubymaniac";
      name = "vscode-paste-and-indent";
      version = "0.0.8";
      sha256 = "0fqwcvwq37ndms6vky8jjv0zliy6fpfkh8d9raq8hkinfxq6klgl";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rust-lang.rust-analyzer = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rust-lang";
      name = "rust-analyzer";
      version = "0.4.1113";
      sha256 = "0gsr58iy6m4gl6xz8s7nyj0jbmprv8hzw1xda2nal4yanh75395v";
    };
    meta.license = [ lib.licenses.mit lib.licenses.asl20 ];
  };
  ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ocamllabs";
      name = "ocaml-platform";
      version = "1.10.7";
      sha256 = "1vbazbgdk5g3sa72wk0vd4i354bw3kagdmp0bzr56v4jwspnw587";
    };
    meta.license = [ lib.licenses.mit ];
  };
  pkief.material-icon-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "pkief";
      name = "material-icon-theme";
      version = "4.19.0";
      sha256 = "1azkkp4bnd7n8v0m4325hfrr6p6ikid88xbxaanypji25pnyq5a4";
    };
  };
  pkief.material-product-icons = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "pkief";
      name = "material-product-icons";
      version = "1.3.0";
      sha256 = "1my2rvyvvrn61jl1g2hnjgpsma1c7czr6ip4y1006d9ghqsc9h3k";
    };
  };
  prisma.prisma = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "prisma";
      name = "prisma";
      version = "4.0.0";
      sha256 = "14w7ikqannkxg3ck690ix8pdzrbggiq75vgy8ag97dqkvm0lvg8l";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  richie5um2.snake-trail = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "richie5um2";
      name = "snake-trail";
      version = "0.6.0";
      sha256 = "0wkpq9f48hplrgabb0v1ij6fc4sb8h4a93dagw4biprhnnm3qx49";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ritwickdey.liveserver = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ritwickdey";
      name = "liveserver";
      version = "5.7.5";
      sha256 = "0afjp8jr1s0f3ag0q8kw5d8cyd5fh6vzkfx2wdqq4pihm7ivp9xc";
    };
    meta.license = [ lib.licenses.mit ];
  };
  roman.ayu-next = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "roman";
      name = "ayu-next";
      version = "1.2.9";
      sha256 = "10kb9i86f6pl6q9aqjzdqf1kiwpagd6rskxg6spcm66iy6m6f1mg";
    };
    meta.license = [ lib.licenses.mit ];
  };
  rubbersheep.gi = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "rubbersheep";
      name = "gi";
      version = "0.2.11";
      sha256 = "0j9k6wm959sziky7fh55awspzidxrrxsdbpz1d79s5lr5r19rs6j";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ryu1kn.partial-diff = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ryu1kn";
      name = "partial-diff";
      version = "1.4.3";
      sha256 = "0x3lkvna4dagr7s99yykji3x517cxk5kp7ydmqa6jb4bzzsv1s6h";
    };
  };
  scala-lang.scala = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "scala-lang";
      name = "scala";
      version = "0.5.5";
      sha256 = "1gqgamm97sq09za8iyb06jf7hpqa2mlkycbx6zpqwvlwd3a92qr1";
    };
  };
  scalameta.metals = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "scalameta";
      name = "metals";
      version = "1.17.10";
      sha256 = "0vi51l1g26y027g0ag989ygb4rcn11kmxmgb2b9kwbc328s31n3x";
    };
    meta.license = [ lib.licenses.asl20 ];
  };
  serayuzgur.crates = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "serayuzgur";
      name = "crates";
      version = "0.5.10";
      sha256 = "1dbhd6xbawbnf9p090lpmn8i5gg1f7y8xk2whc9zhg4432kdv3vd";
    };
  };
  shardulm94.trailing-spaces = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "shardulm94";
      name = "trailing-spaces";
      version = "0.3.1";
      sha256 = "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8";
    };
    meta.license = [ lib.licenses.mit ];
  };
  shyykoserhiy.vscode-spotify = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "shyykoserhiy";
      name = "vscode-spotify";
      version = "3.2.1";
      sha256 = "14d68rcnjx4a20r0ps9g2aycv5myyhks5lpfz0syr2rxr4kd1vh6";
    };
    meta.license = [ lib.licenses.mit ];
  };
  silvenon.mdx = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "silvenon";
      name = "mdx";
      version = "0.1.0";
      sha256 = "1mzsqgv0zdlj886kh1yx1zr966yc8hqwmiqrb1532xbmgyy6adz3";
    };
  };
  skellock.just = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "skellock";
      name = "just";
      version = "2.0.0";
      sha256 = "1ph869zl757a11f8iq643f79h8gry7650a9i03mlxyxlqmspzshl";
    };
    meta.license = [ lib.licenses.mit ];
  };
  skyapps.fish-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "skyapps";
      name = "fish-vscode";
      version = "0.2.1";
      sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
    };
  };
  slevesque.vscode-multiclip = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "slevesque";
      name = "vscode-multiclip";
      version = "0.1.5";
      sha256 = "1cg8dqj7f10fj9i0g6mi3jbyk61rs6rvg9aq28575rr52yfjc9f9";
    };
  };
  spywhere.guides = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "spywhere";
      name = "guides";
      version = "0.9.3";
      sha256 = "1kvsj085w1xax6fg0kvsj1cizqh86i0pkzpwi0sbfvmcq21i6ghn";
    };
    meta.license = [ lib.licenses.mit ];
  };
  stefanjarina.vscode-eex-snippets = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "stefanjarina";
      name = "vscode-eex-snippets";
      version = "0.0.8";
      sha256 = "0j8pmrs1lk138vhqx594pzxvrma4yl3jh7ihqm2kgh0cwnkbj36m";
    };
    meta.license = [ lib.licenses.mit ];
  };
  stephlin.vscode-tmux-keybinding = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "stephlin";
      name = "vscode-tmux-keybinding";
      version = "0.0.7";
      sha256 = "01ma6f1sk4xmp92n3p4mqzm96arghd410r6av9a0hy7hi76b9d9j";
    };
  };
  stkb.rewrap = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "stkb";
      name = "rewrap";
      version = "17.8.0";
      sha256 = "1y168ar01zxdd2x73ddsckbzqq0iinax2zv3d95nhwp9asjnbpgn";
    };
  };
  streetsidesoftware.code-spell-checker = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "streetsidesoftware";
      name = "code-spell-checker";
      version = "2.2.5";
      sha256 = "0ayhlzh3b2mcdx6mdj00y4qxvv6mirfpnp8q5zvidm6sv3vwlcj0";
    };
    meta.license = [ lib.licenses.gpl3Plus ];
  };
  svelte.svelte-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "svelte";
      name = "svelte-vscode";
      version = "105.18.1";
      sha256 = "0fa9k4j73n76fx06xr6003pn7mfapvpjjqddl5pn9i02m5q975aj";
    };
    meta.license = [ lib.licenses.mit ];
  };
  svsool.markdown-memo = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "svsool";
      name = "markdown-memo";
      version = "0.3.18";
      sha256 = "024v54qqv8kgxv2bm8wfi64aci5xm4cry2b0z8xr322mgma2m5na";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tabnine.tabnine-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tabnine";
      name = "tabnine-vscode";
      version = "3.5.60";
      sha256 = "082dv68axp5pspf539jjvxfy16fk1smwjlai1w7kfk36yhhs97s8";
    };
  };
  takayama.vscode-qq = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "takayama";
      name = "vscode-qq";
      version = "1.4.2";
      sha256 = "1n6hxf604nws5569zw3m8hjbnsgblqy0v4b022ygh8q5flas51wj";
    };
    meta.license = [ lib.licenses.mpl20 ];
  };
  tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tamasfe";
      name = "even-better-toml";
      version = "0.16.4";
      sha256 = "0pxrky5v9d9zxbfya7cyv8m2y260x9dmlinm4ybpxnw9j9v5xvfh";
    };
  };
  theangryepicbanana.language-pascal = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "theangryepicbanana";
      name = "language-pascal";
      version = "0.1.6";
      sha256 = "096wwmwpas21f03pbbz40rvc792xzpl5qqddzbry41glxpzywy6b";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tiehuis.zig = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tiehuis";
      name = "zig";
      version = "0.2.5";
      sha256 = "1vmng7h7fwwgak32djlkxxdr5br0dx9w97bvgr9whxdd8fkrxi1z";
    };
    meta.license = [ lib.licenses.mit ];
  };
  timonwong.shellcheck = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "timonwong";
      name = "shellcheck";
      version = "0.19.5";
      sha256 = "1v6z0qzcqhb458pf6dwx35xk2iw3j3swx8dhys4qpzi3cpqvd6p1";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tobiasalthoff.atom-material-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tobiasalthoff";
      name = "atom-material-theme";
      version = "1.10.8";
      sha256 = "0i31a0id7f48qm7gypspcrasm6d4rfy7r2yl04qvg2kpwp858fs4";
    };
  };
  tomoki1207.pdf = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tomoki1207";
      name = "pdf";
      version = "1.2.0";
      sha256 = "1bcj546bp0w4yndd0qxwr8grhiwjd1jvf33jgmpm0j96y34vcszz";
    };
  };
  tuttieee.emacs-mcx = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tuttieee";
      name = "emacs-mcx";
      version = "0.44.0";
      sha256 = "08xm6csswkwmv652sjvy623rbkhks1xc4vd7v69g2vy3ydcgjn73";
    };
    meta.license = [ lib.licenses.mit ];
  };
  tyriar.sort-lines = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "tyriar";
      name = "sort-lines";
      version = "1.9.1";
      sha256 = "0dds99j6awdxb0ipm15g543a5b6f0hr00q9rz961n0zkyawgdlcb";
    };
    meta.license = [ lib.licenses.mit ];
  };
  usernamehw.errorlens = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "usernamehw";
      name = "errorlens";
      version = "3.5.1";
      sha256 = "17xbbr5hjrs67yazicb9qillbkp3wnaccjpnl1jlp07s0n7q4f8f";
    };
    meta.license = [ lib.licenses.mit ];
  };
  vadimcn.vscode-lldb = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vadimcn";
      name = "vscode-lldb";
      version = "1.7.0";
      sha256 = "0sdy261fkccff13i0s6kiykkwisinasxy1n23m0xmw72i9w31rhf";
    };
    meta.license = [ lib.licenses.mit ];
  };
  valentjn.vscode-ltex = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "valentjn";
      name = "vscode-ltex";
      version = "13.1.0";
      sha256 = "15qm97i9l65v3x0zxl1895ilazz2jk2wmizbj7kmds613jz7d46c";
    };
    meta.license = [ lib.licenses.mpl20 ];
  };
  viktorqvarfordt.vscode-pitch-black-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "viktorqvarfordt";
      name = "vscode-pitch-black-theme";
      version = "1.3.0";
      sha256 = "124bnbr8x929gx0fiyqfgf6ym2qc7y1iqv03srd0qnwdqpyyd46l";
    };
  };
  vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vincaslt";
      name = "highlight-matching-tag";
      version = "0.10.1";
      sha256 = "0b9jpwiyxax783gyr9zhx7sgrdl9wffq34fi7y67vd68q9183jw1";
    };
    meta.license = [ lib.licenses.mit ];
  };
  ms-vsliveshare.vsliveshare = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "ms-vsliveshare";
      name = "vsliveshare";
      version = "1.0.5625";
      sha256 = "09dwcrfjxpsx7sclmn5fkgm89g6l6z2ik9wp1acaffsfkay4cg05";
    };
  };
  vscodevim.vim = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vscodevim";
      name = "vim";
      version = "1.23.1";
      sha256 = "131fnicsknw4kkz299l9mdq1b0lx05ssr8sszk1apgmxxngzfz4k";
    };
    meta.license = [ lib.licenses.mit ];
  };
  vspacecode.vspacecode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vspacecode";
      name = "vspacecode";
      version = "0.10.9";
      sha256 = "01d43dcd5293nlp6vskdv85h0qr8xlq8j9vdzn0vjqr133c05anp";
    };
  };
  vspacecode.whichkey = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "vspacecode";
      name = "whichkey";
      version = "0.11.3";
      sha256 = "0zix87vl2rig8wn3f6f3n6zdi0c61za3lw7xgm28sjhwwb08wxiy";
    };
  };
  wix.vscode-import-cost = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "wix";
      name = "vscode-import-cost";
      version = "3.3.0";
      sha256 = "0wl8vl8n0avd6nbfmis0lnlqlyh4yp3cca6kvjzgw5xxdc5bl38r";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xadillax.viml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xadillax";
      name = "viml";
      version = "2.1.2";
      sha256 = "0w4br37fb2w4aqlfgvrg2ffzad7ssm3bfr3phbxvi9v9aj7m3pcz";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xaver.clang-format = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xaver";
      name = "clang-format";
      version = "1.9.0";
      sha256 = "0bwc4lpcjq1x73kwd6kxr674v3rb0d2cjj65g3r69y7gfs8yzl5b";
    };
    meta.license = [ lib.licenses.mit ];
  };
  xyz.local-history = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "xyz";
      name = "local-history";
      version = "1.8.1";
      sha256 = "1mfmnbdv76nvwg4xs3rgsqbxk8hw9zr1b61har9c3pbk9r4cay7v";
    };
  };
  yzhang.markdown-all-in-one = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "yzhang";
      name = "markdown-all-in-one";
      version = "3.4.3";
      sha256 = "0z0sdb5vmx1waln5k9fk6s6lj1pzpcm3hwm4xc47jz62iq8930m3";
    };
    meta.license = [ lib.licenses.mit ];
  };
  zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "zhuangtongfa";
      name = "material-theme";
      version = "3.15.2";
      sha256 = "058md25509l9nlgicab59rv13alyksbnf6gm55b8yhkbxx6pm079";
    };
    meta.license = [ lib.licenses.mit ];
  };
  WakaTime.vscode-wakatime = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "WakaTime";
      name = "vscode-wakatime";
      version = "18.1.6";
      sha256 = "15ldc9774jgwqlw5qfrdmpmgdyvps2rkn2lh7v2f0w457x9h52lx";
    };
    meta.license = [ lib.licenses.bsd3 ];
  };
  wholroyd.jinja = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "wholroyd";
      name = "jinja";
      version = "0.0.8";
      sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
    };
    meta.license = [ lib.licenses.mit ];
  };
  zxh404.vscode-proto3 = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "zxh404";
      name = "vscode-proto3";
      version = "0.5.5";
      sha256 = "08gjq2ww7pjr3ck9pyp5kdr0q6hxxjy3gg87aklplbc9bkfb0vqj";
    };
  };
}

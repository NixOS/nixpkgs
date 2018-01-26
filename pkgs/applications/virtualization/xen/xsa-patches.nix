{ fetchpatch }:

let
  xsaPatch = { name , sha256 }: (fetchpatch {
    url = "https://xenbits.xen.org/xsa/xsa${name}.patch";
    inherit sha256;
  });
in rec {
  # 4.5
  XSA_190 = (xsaPatch {
    name = "190-4.5";
    sha256 = "0f8pw38kkxky89ny3ic5h26v9zsjj9id89lygx896zc3w1klafqm";
  });

  # 4.5
  XSA_191 = (xsaPatch {
    name = "191-4.6";
    sha256 = "1wl1ndli8rflmc44pkp8cw4642gi8z7j7gipac8mmlavmn3wdqhg";
  });

  # 4.5
  XSA_192 = (xsaPatch {
    name = "192-4.5";
    sha256 = "0m8cv0xqvx5pdk7fcmaw2vv43xhl62plyx33xqj48y66x5z9lxpm";
  });

  # 4.5
  XSA_193 = (xsaPatch {
    name = "193-4.5";
    sha256 = "0k9mykhrpm4rbjkhv067f6s05lqmgnldcyb3vi8cl0ndlyh66lvr";
  });

  # 4.5
  XSA_195 = (xsaPatch {
    name = "195";
    sha256 = "0m0g953qnjy2knd9qnkdagpvkkgjbk3ydgajia6kzs499dyqpdl7";
  });

  # 4.5
  XSA_196 = [
    (xsaPatch {
      name = "196-0001-x86-emul-Correct-the-IDT-entry-calculation-in-inject";
      sha256 = "0z53nzrjvc745y26z1qc8jlg3blxp7brawvji1hx3s74n346ssl6";
    })
    (xsaPatch {
      name = "196-0002-x86-svm-Fix-injection-of-software-interrupts";
      sha256 = "11cqvr5jn2s92wsshpilx9qnfczrd9hnyb5aim6qwmz3fq3hrrkz";
    })
  ];

  # 4.5
  XSA_198 = (xsaPatch {
    name = "198";
    sha256 = "0d1nndn4p520c9xa87ixnyks3mrvzcri7c702d6mm22m8ansx6d9";
  });

  # 4.5
  XSA_200 = (xsaPatch {
    name = "200-4.6";
    sha256 = "0k918ja83470iz5k4vqi15293zjvz2dipdhgc9sy9rrhg4mqncl7";
  });

  # 4.5
  XSA_202_45 = (xsaPatch {
    name = "202-4.6";
    sha256 = "0nnznkrvfbbc8z64dr9wvbdijd4qbpc0wz2j5vpmx6b32sm7932f";
  });

  # 4.8
  XSA_202 = (xsaPatch {
    name = "202";
    sha256 = "0j1d5akcjgx8w2c6w6p9znv77fkmps0880m2xgpbgs1ra9grshm1";
  });

  # 4.8
  XSA_203 = (xsaPatch {
    name = "203";
    sha256 = "1s1q7xskvpg87ivwfaiqr0cj3ajdkhkhpmpikfkvq127h8hhmd8j";
  });

  # 4.5
  XSA_204_45 = (xsaPatch {
    name = "204-4.5";
    sha256 = "083z9pbdz3f532fnzg7n2d5wzv6rmqc0f4mvc3mnmkd0rzqw8vcp";
  });

  # 4.8
  XSA_204 = (xsaPatch {
    name = "204-4.8";
    sha256 = "0rs498s4w2alz3h6jhlr2y0ni630vhggmxbrd1p1p3gcv8p6zzrr";
  });

  # 4.5
  XSA_206_45 = [
    (xsaPatch {
      name = "206-4.5/0001-xenstored-apply-a-write-transaction-rate-limit";
      sha256 = "07vsm8mlbxh2s01ny2xywnm1bqhhxas1az31fzwb6f1g14vkzwm4";
    })
    (xsaPatch {
      name = "206-4.5/0002-xenstored-Log-when-the-write-transaction-rate-limit-";
      sha256 = "17pnvxjmhny22abwwivacfig4vfsy5bqlki07z236whc2y7yzbsx";
    })
    (xsaPatch {
      name = "206-4.5/0003-oxenstored-refactor-putting-response-on-wire";
      sha256 = "0xf566yicnisliy82cydb2s9k27l3bxc43qgmv6yr2ir3ixxlw5s";
    })
    (xsaPatch {
      name = "206-4.5/0004-oxenstored-remove-some-unused-parameters";
      sha256 = "16cqx9i0w4w3x06qqdk9rbw4z96yhm0kbc32j40spfgxl82d1zlk";
    })
    (xsaPatch {
      name = "206-4.5/0005-oxenstored-refactor-request-processing";
      sha256 = "1g2hzlv7w03sqnifbzda85mwlz3bw37rk80l248180sv3k7k6bgv";
    })
    (xsaPatch {
      name = "206-4.5/0006-oxenstored-keep-track-of-each-transaction-s-operatio";
      sha256 = "0n65yfxvpfd4cz95dpbwqj3nablyzq5g7a0klvi2y9zybhch9cmg";
    })
    (xsaPatch {
      name = "206-4.5/0007-oxenstored-move-functions-that-process-simple-operat";
      sha256 = "0qllvbc9rnj7jhhlslxxs35gvphvih0ywz52jszj4irm23ka5vnz";
    })
    (xsaPatch {
      name = "206-4.5/0008-oxenstored-replay-transaction-upon-conflict";
      sha256 = "0lixkxjfzciy9l0f980cmkr8mcsx14c289kg0mn5w1cscg0hb46g";
    })
    (xsaPatch {
      name = "206-4.5/0009-oxenstored-log-request-and-response-during-transacti";
      sha256 = "09ph8ddcx0k7rndd6hx6kszxh3fhxnvdjsq13p97n996xrpl1x7b";
    })
    (xsaPatch {
      name = "206-4.5/0010-oxenstored-allow-compilation-prior-to-OCaml-3.12.0";
      sha256 = "1y0m7sqdz89z2vs4dfr45cyvxxas323rxar0xdvvvivgkgxawvxj";
    })
    (xsaPatch {
      name = "206-4.5/0011-oxenstored-comments-explaining-some-variables";
      sha256 = "1d3n0y9syya4kaavrvqn01d3wsn85gmw7qrbylkclznqgkwdsr2p";
    })
    (xsaPatch {
      name = "206-4.5/0012-oxenstored-handling-of-domain-conflict-credit";
      sha256 = "12zgid5y9vrhhpk2syxp0x01lzzr6447fa76n6rjmzi1xgdzpaf8";
    })
    (xsaPatch {
      name = "206-4.5/0013-oxenstored-ignore-domains-with-no-conflict-credit";
      sha256 = "0v3g9pm60w6qi360hdqjcw838s0qcyywz9qpl8gzmhrg7a35avxl";
    })
    (xsaPatch {
      name = "206-4.5/0014-oxenstored-add-transaction-info-relevant-to-history-";
      sha256 = "0vv3w0h5xh554i9v2vbc8gzm8wabjf2vzya3dyv5yzvly6ygv0sb";
    })
    (xsaPatch {
      name = "206-4.5/0015-oxenstored-support-commit-history-tracking";
      sha256 = "1iv2vy29g437vj73x9p33rdcr5ln2q0kx1b3pgxq202ghbc1x1zj";
    })
    (xsaPatch {
      name = "206-4.5/0016-oxenstored-only-record-operations-with-side-effects-";
      sha256 = "1cjkw5ganbg6lq78qsg0igjqvbgph3j349faxgk1p5d6nr492zzy";
    })
    (xsaPatch {
      name = "206-4.5/0017-oxenstored-discard-old-commit-history-on-txn-end";
      sha256 = "0lm15lq77403qqwpwcqvxlzgirp6ffh301any9g401hs98f9y4ps";
    })
    (xsaPatch {
      name = "206-4.5/0018-oxenstored-track-commit-history";
      sha256 = "1jh92p6vjhkm3bn5vz260npvsjji63g2imsxflxs4f3r69sz1nkd";
    })
    (xsaPatch {
      name = "206-4.5/0019-oxenstored-blame-the-connection-that-caused-a-transa";
      sha256 = "17k264pk0fvsamj85578msgpx97mw63nmj0j9v5hbj4bgfazvj4h";
    })
    (xsaPatch {
      name = "206-4.5/0020-oxenstored-allow-self-conflicts";
      sha256 = "15z3rd49q0pa72si0s8wjsy2zvbm613d0hjswp4ikc6nzsnsh4qy";
    })
    (xsaPatch {
      name = "206-4.5/0021-oxenstored-do-not-commit-read-only-transactions";
      sha256 = "04wpzazhv90lg3228z5i6vnh1z4lzd08z0d0fvc4br6pkd0w4va8";
    })
    (xsaPatch {
      name = "206-4.5/0022-oxenstored-don-t-wake-to-issue-no-conflict-credit";
      sha256 = "1shbrn0w68rlywcc633zcgykfccck1a77igmg8ydzwjsbwxsmsjy";
    })
    (xsaPatch {
      name = "206-4.5/0023-oxenstored-transaction-conflicts-improve-logging";
      sha256 = "1086y268yh8047k1vxnxs2nhp6izp7lfmq01f1gq5n7jiy1sxcq7";
    })
    (xsaPatch {
      name = "206-4.5/0024-oxenstored-trim-history-in-the-frequent_ops-function";
      sha256 = "014zs6i4gzrimn814k5i7gz66vbb0adkzr2qyai7i4fxc9h9r7w8";
    })
  ];

  # 4.8
  XSA_206 = [
    (xsaPatch {
      name = "206-4.8/0001-xenstored-apply-a-write-transaction-rate-limit";
      sha256 = "1c81d93i3qx7l38f9af0sd84w5x51zvn262mzl25ilcklql4kzl6";
    })
    (xsaPatch {
      name = "206-4.8/0002-xenstored-Log-when-the-write-transaction-rate-limit-";
      sha256 = "0b8iw409wi1x6p0swpnr51lcdlla1lgxjv5f910sj4wl96bca84q";
    })
    (xsaPatch {
      name = "206-4.8/0003-oxenstored-comments-explaining-some-variables";
      sha256 = "1d3n0y9syya4kaavrvqn01d3wsn85gmw7qrbylkclznqgkwdsr2p";
    })
    (xsaPatch {
      name = "206-4.8/0004-oxenstored-handling-of-domain-conflict-credit";
      sha256 = "020rw7hgc0dmhr4admz91kd99b4z1bdpji47nsy1255bjgvwc01k";
    })
    (xsaPatch {
      name = "206-4.8/0005-oxenstored-ignore-domains-with-no-conflict-credit";
      sha256 = "1ilhcgyn803bxvfbqv0ihfrh9jfpp0lidkv7i4613f9v9vjm8q0h";
    })
    (xsaPatch {
      name = "206-4.8/0006-oxenstored-add-transaction-info-relevant-to-history-";
      sha256 = "1dbd9pzda6hn9wj9pck44dlgz9nxvch3bzgrpaivanww8llxdfzz";
    })
    (xsaPatch {
      name = "206-4.8/0007-oxenstored-support-commit-history-tracking";
      sha256 = "1jfr56c22fqkhj6fnv1ha7zsid86zm9l0nihpb8m932xgc4a6h9h";
    })
    (xsaPatch {
      name = "206-4.8/0008-oxenstored-only-record-operations-with-side-effects-";
      sha256 = "1y845hj8krjdrirbd2jx4jqgnylwjv7bxnk7474lkld5kdnlbjyf";
    })
    (xsaPatch {
      name = "206-4.8/0009-oxenstored-discard-old-commit-history-on-txn-end";
      sha256 = "1lcr9gz2b77x74sr1flfymyyz4xzs04iv88rc1633ibyqxmvk0lx";
    })
    (xsaPatch {
      name = "206-4.8/0010-oxenstored-track-commit-history";
      sha256 = "1qwnivak4y038mpby75aaz0y70r0l3yc3hsz6wl5x0b74q6yy0ja";
    })
    (xsaPatch {
      name = "206-4.8/0011-oxenstored-blame-the-connection-that-caused-a-transa";
      sha256 = "0p2w5ddyhc6d95dnlxzc5k77j063p02d53ab7m7ijfm7m6gknq8y";
    })
    (xsaPatch {
      name = "206-4.8/0012-oxenstored-allow-self-conflicts";
      sha256 = "1571l81m30cbmqm4pk33q33p3dy58sfy2lnkl2wbgl2b3mkk657l";
    })
    (xsaPatch {
      name = "206-4.8/0013-oxenstored-do-not-commit-read-only-transactions";
      sha256 = "15985wl635w22dddjyx5l97b5p6m55mzv5ygk7xr0jx7mi192f9x";
    })
    (xsaPatch {
      name = "206-4.8/0014-oxenstored-don-t-wake-to-issue-no-conflict-credit";
      sha256 = "08672w4gaf2n3r8xy09h874gh5lg2vnrkjzq6xzvzdhdl092mipw";
    })
    (xsaPatch {
      name = "206-4.8/0015-oxenstored-transaction-conflicts-improve-logging";
      sha256 = "0ck98ms0py8wjsc38pbx6222x7n6l90zckfa7m7nnszsyc0sxxad";
    })
    (xsaPatch {
      name = "206-4.8/0016-oxenstored-trim-history-in-the-frequent_ops-function";
      sha256 = "014zs6i4gzrimn814k5i7gz66vbb0adkzr2qyai7i4fxc9h9r7w8";
    })
  ];

  # 4.5 - 4.8
  XSA_207 = (xsaPatch {
    name = "207";
    sha256 = "0wdlhijmw9mdj6a82pyw1rwwiz605dwzjc392zr3fpb2jklrvibc";
  });

  # 4.8
  XSA_210 = (xsaPatch {
    name = "210";
    sha256 = "02mykxqxnsrd0sr4ij022j8y7618wzi2a6j6j761vx8qgmh11xai";
  });

  # 4.5 - 4.8
  XSA_212 = (xsaPatch {
    name = "212";
    sha256 = "1ggjbbym5irq534a3zc86md9jg8imlpc9wx8xsadb9akgjrr1r8d";
  });

  # 4.5
  XSA_213_45 = (xsaPatch {
    name = "213-4.5";
    sha256 = "1vnqf89ydacr5bq3d6z2r33xb2sn5vsd934rncyc28ybc9rvj6wm";
  });

  # 4.8
  XSA_213 = (xsaPatch {
    name = "213-4.8";
    sha256 = "0ia3zr6r3bqy2h48fdy7p0iz423lniy3i0qkdvzgv5a8m80darr2";
  });

  # 4.5 - 4.8
  XSA_214 = (xsaPatch {
    name = "214";
    sha256 = "0qapzx63z0yl84phnpnglpkxp6b9sy1y7cilhwjhxyigpfnm2rrk";
  });

  # 4.5
  XSA_215 = (xsaPatch {
    name = "215";
    sha256 = "0sv8ccc5xp09f1w1gj5a9n3mlsdsh96sdb1n560vh31f4kkd61xs";
  });

  # 4.5
  XSA_217_45 = (xsaPatch {
    name = "217-4.5";
    sha256 = "067pgsfrb9py2dhm1pk9g8f6fs40vyfrcxhj8c12vzamb6svzmn4";
  });

  # 4.6 - 4.8
  XSA_217 = (xsaPatch {
    name = "217";
    sha256 = "1khs5ilif14dzcm7lmikjzkwsrfzlmir1rgrgzkc411gf18ylzmj";
  });

  # 4.5
  XSA_218_45 = [
    (xsaPatch {
      name = "218-4.5/0001-IOMMU-handle-IOMMU-mapping-and-unmapping-failures";
      sha256 = "00y6j3yjxw0igpldsavikmhlxw711k2jsj1qx0s05w2k608gadkq";
    })
    (xsaPatch {
      name = "218-4.5/0002-gnttab-fix-unmap-pin-accounting-race";
      sha256 = "0qbbfnnjlpdcd29mzmacfmi859k92c213l91q7w1rg2k6pzx928k";
    })
    (xsaPatch {
      name = "218-4.5/0003-gnttab-Avoid-potential-double-put-of-maptrack-entry";
      sha256 = "1cndzvyhf41mk4my6vh3bk9jvh2y4gpmqdhvl9zhxhmppszslqkc";
    })
    (xsaPatch {
      name = "218-4.5/0004-gnttab-correct-maptrack-table-accesses";
      sha256 = "02zpb0ffigijacqvyyjylwx3qpgibwslrka7mbxwnclf4s9c03a2";
    })
  ];

  # 4.8
  XSA_218 = [
    (xsaPatch {
      name = "218-4.8/0001-gnttab-fix-unmap-pin-accounting-race";
      sha256 = "0r363frai239r2wmwxi48kcr50gbk5l64nja0h9lppi3z2y3dkdd";
    })
    (xsaPatch {
      name = "218-4.8/0002-gnttab-Avoid-potential-double-put-of-maptrack-entry";
      sha256 = "07wm06i7frv7bsaykakx3g9h0hfqv96zcadvwf6wv194dggq1plc";
    })
    (xsaPatch {
      name = "218-4.8/0003-gnttab-correct-maptrack-table-accesses";
      sha256 = "0ad0irc3p4dmla8sp3frxbh2qciji1dipkslh0xqvy2hyf9p80y9";
    })
  ];

  # 4.5
  XSA_219_45 = (xsaPatch {
    name = "219-4.5";
    sha256 = "003msr5vhsc66scmdpgn0lp3p01g4zfw5vj86y5lw9ajkbaywdsm";
  });

  # 4.8
  XSA_219 = (xsaPatch {
    name = "219-4.8";
    sha256 = "16q7kiamy86x8qdvls74wmq5j72kgzgdilryig4q1b21mp0ij1jq";
  });

  # 4.5
  XSA_220_45 = (xsaPatch {
    name = "220-4.5";
    sha256 = "1dj9nn6lzxlipjb3nb7b9m4337fl6yn2bd7ap1lqrjn8h9zkk1pp";
  });

  # 4.8
  XSA_220 = (xsaPatch {
    name = "220-4.8";
    sha256 = "0214qyqx7qap5y1pdi9fm0vz4y2fbyg71gaq36fisknj35dv2mh5";
  });

  # 4.5 - 4.8
  XSA_221 = (xsaPatch {
    name = "221";
    sha256 = "1mcr1nqgxyjrkywdg7qhlfwgz7vj2if1dhic425vgd41p9cdgl26";
  });

  # 4.5
  XSA_222_45 = [
    (xsaPatch {
      name = "222-1-4.6";
      sha256 = "1g4dqm5qx4wqlv1520jpfiscph95vllcp4gqp1rdfailk8xi0mcf";
    })
    (xsaPatch {
      name = "222-2-4.5";
      sha256 = "1hw8rhc7q4v309f4w11gxfsn5x1pirvxkg7s4kr711fnmvp9hkzd";
    })
  ];

  # 4.8
  XSA_222 = [
    (xsaPatch {
      name = "222-1";
      sha256 = "0x02x4kqwfw255638fh2zcxwig1dy6kadlmqim1jgnjgmrvvqas2";
    })
    (xsaPatch {
      name = "222-2-4.8";
      sha256 = "1xhyp6q3c5l8djh965g1i8201m2wvhms8k886h4sn30hks38giin";
    })
  ];

  # 4.5 - 4.8
  XSA_223 = (xsaPatch {
    name = "223";
    sha256 = "0803gjgcbq9vaz2mq0v5finf1fq8iik1g4hqsjqhjxvspn8l70c5";
  });

  # 4.5
  XSA_224_45 = [
    (xsaPatch {
      name = "224-4.5/0001-gnttab-Fix-handling-of-dev_bus_addr-during-unmap";
      sha256 = "1aislj66ss4cb3v2bh12mrqsyrf288d4h54rj94jjq7h1hnycw7h";
    })
    (xsaPatch {
      name = "224-4.5/0002-gnttab-never-create-host-mapping-unless-asked-to";
      sha256 = "1j6fgm1ccb07gg0mi5qmdr0vqwwc3n12z433g1jrija2gbk1x8aq";
    })
    (xsaPatch {
      name = "224-4.5/0003-gnttab-correct-logic-to-get-page-references-during-m";
      sha256 = "166kmicwx280fjqjvgigbmhabjksa0hhvqx5h4v6kjlcjpmxqy08";
    })
    (xsaPatch {
      name = "224-4.5/0004-gnttab-__gnttab_unmap_common_complete-is-all-or-noth";
      sha256 = "1skc0yj1zsn8xgyq1y57bdc0scvvlmd0ynrjwwf1zkias1wlilav";
    })
  ];

  # 4.8
  XSA_224 = [
    (xsaPatch {
      name = "224-4.8/0001-gnttab-Fix-handling-of-dev_bus_addr-during-unmap";
      sha256 = "1k326yan5811qzyvpdfkv801a19nyd09nsqayi8gyh58xx9c21m4";
    })
    (xsaPatch {
      name = "224-4.8/0002-gnttab-never-create-host-mapping-unless-asked-to";
      sha256 = "06nj1x59bbx9hrj26xmvbw8z805lfqhld9hm0ld0fs6dmcpqzcck";
    })
    (xsaPatch {
      name = "224-4.8/0003-gnttab-correct-logic-to-get-page-references-during-m";
      sha256 = "0kmag6fdsskgplcvzqp341yfi6pgc14wvjj58bp7ydb9hdk53qx2";
    })
    (xsaPatch {
      name = "224-4.8/0004-gnttab-__gnttab_unmap_common_complete-is-all-or-noth";
      sha256 = "1ww80pi7jr4gjpymkcw8qxmr5as18b2asdqv35527nqprylsff9f";
    })
  ];

  # 4.6 - 4.8
  XSA_225 = (xsaPatch {
    name = "225";
    sha256 = "0lcp2bs0r849xnvhrdf8s821v36cqdbzk8lwz6chrjhjalk6ha2g";
  });

  # 4.5
  XSA_226_45 = [
    (xsaPatch {
      name = "226-4.5/0001-gnttab-dont-use-possibly-unbounded-tail-calls";
      sha256 = "1hx47ppv5q33cw4dwp82lgvv4fp28gx7rxijw0iaczsv8bvb8vcg";
    })
    (xsaPatch {
      name = "226-4.5/0002-gnttab-fix-transitive-grant-handling";
      sha256 = "1gzp8m2zfihwlk71c3lqyd0ajh9h11pvkhzhw0mawckxy0qksvlc";
    })
  ];

  # 4.8 - 4.9
  XSA_226 = [
    (xsaPatch {
      name = "226-4.9/0001-gnttab-dont-use-possibly-unbounded-tail-calls";
      sha256 = "1hx47ppv5q33cw4dwp82lgvv4fp28gx7rxijw0iaczsv8bvb8vcg";
    })
    (xsaPatch {
      name = "226-4.9/0002-gnttab-fix-transitive-grant-handling";
      sha256 = "1gzp8m2zfihwlk71c3lqyd0ajh9h11pvkhzhw0mawckxy0qksvlc";
    })
  ];

  # 4.5
  XSA_227_45 = (xsaPatch {
    name = "227-4.5";
    sha256 = "1qfjfisgqm4x98qw54x2qrvgjnvvzizx9p1pjhcnsps9q6g1y3x8";
  });

  # 4.8 - 4.9
  XSA_227 = (xsaPatch {
    name = "227";
    sha256 = "0zdcm43i5n08rh7rrnb0fcssvd4fgawwmizsa16w2ak7pzvgmg94";
  });

  # 4.8
  XSA_228_48 = (xsaPatch {
    name = "228-4.8";
    sha256 = "085pnzwyv0rdb51hv5vhbhwfyxl0wg8sxcm912gjq8z7da5cv10n";
  });

  # 4.9
  XSA_228 = (xsaPatch {
    name = "228";
    sha256 = "0c9nvfpnr5ira7ha3fszhvvh71nsxrvmzrab56xwjhl2dbw2yy23";
  });

  # 4.5 - 4.9
  XSA_230 = (xsaPatch {
    name = "230";
    sha256 = "10x0j7wmzkrwycs1ng89fgjzvzh8vsdd4c5nb68b3j1azdx4ld83";
  });

  # 4.5
  XSA_231_45 = (xsaPatch {
    name = "231-4.5";
    sha256 = "06gwx2f1lg51dfk2b4zxp7wv9c4pxdi87pg2asvmxqc78ir7l5s6";
  });

  # 4.8 - 4.9
  XSA_231 = (xsaPatch {
    name = "231-4.9";
    sha256 = "09r8xxq2fd52wrk6i0y0sk3nbidfg6pzzrkx327hfmdjj76iyz3b";
  });

  # 4.5 - 4.9
  XSA_232 = (xsaPatch {
    name = "232";
    sha256 = "0n6irjpmraa3hbxxm64a1cplc6y6g07x7v2fmlpvn70ql3fs0220";
  });

  # 4.5 - 4.9
  XSA_233 = (xsaPatch {
    name = "233";
    sha256 = "1w3m8349cqav56av63w6jzvlsv4jw5rimwvskr9pq2rcbk2dx8kf";
  });

  # 4.5
  XSA_234_45 = (xsaPatch {
    name = "234-4.5";
    sha256 = "1ji6hbgybb4gbgz5l5fis9midnvjbddzam8d63377rkzdyb3yz9f";
  });

  # 4.8
  XSA_234_48 = (xsaPatch {
    name = "234-4.8";
    sha256 = "08n1pf7z5y67dmay1ap39bi81clgkx82fpmfn7jsh8k4aw94jrsa";
  });

  # 4.9
  XSA_234 = (xsaPatch {
    name = "234-4.9";
    sha256 = "1znmxg432is0virw8321gax8zqq2zcmi2pc5p2j31sixylixsvzx";
  });

  # 4.5
  XSA_235_45 = (xsaPatch {
    name = "235-4.5";
    sha256 = "0hhgnql2gji111020z4wiyzg23wqs6ymanb67rg11p4qad1fp3ff";
  });

  # 4.8 - 4.9
  XSA_235 = (xsaPatch {
    name = "235-4.9";
    sha256 = "1rj4jkmh79wm30jq9f8x65qv3al8l91zc3m5s23q0x6abn3pfb9z";
  });

  # 4.5
  XSA_236_45 = (xsaPatch {
    name = "236-4.5";
    sha256 = "0hcla86x81wykssd2967gblp7fzx61290p4ls4v0hcyxdg2bs2yz";
  });

  # 4.8 - 4.9
  XSA_236 = (xsaPatch {
    name = "236-4.9";
    sha256 = "0vqxy7mgflga05l33j3488fwxmdw3p9yxj4ylhk9n3nw8id72ghq";
  });

  # 4.5
  XSA_237_45 = [
    (xsaPatch {
      name = "237-4.5/0001-x86-dont-allow-MSI-pIRQ-mapping-on-unowned-device";
      sha256 = "0hjxs20jhls4i0iph45a0qpw4znkm04gv74jmwhw84gy4hrhzq3b";
    })
    (xsaPatch {
      name = "237-4.5/0002-x86-enforce-proper-privilege-when-mapping-pIRQ-s";
      sha256 = "0ki8nmbc2g1l9wnqsph45a2k4c6dk5s7jvdlxg3zznyiyxjcv8yn";
    })
    (xsaPatch {
      name = "237-4.5/0003-x86-MSI-disallow-redundant-enabling";
      sha256 = "1hdz83qrjaqnihz8ji186dypxiblbfpgyb01j9m5alhk4whjqvp1";
    })
    (xsaPatch {
      name = "237-4.5/0004-x86-IRQ-conditionally-preserve-irq-pirq-mapping-on-error";
      sha256 = "0csdfn9kzn1k94pg3fcwsgqw14wcd4myi1jkcq5alj1fmkhw4wmk";
    })
    (xsaPatch {
      name = "237-4.5/0005-x86-FLASK-fix-unmap-domain-IRQ-XSM-hook";
      sha256 = "14b73rkvbkd1a2gh9kp0zrvv2d3kfwkiv24fg9agh4hrf2w3nx7y";
    })
  ];

  # 4.8
  XSA_237_48 = [
    (xsaPatch {
      name = "237-4.8/0001-x86-dont-allow-MSI-pIRQ-mapping-on-unowned-device";
      sha256 = "0qjisp37lwi2611mp7fbbm1s7m0bx726rrg79dnxs2mj0skw59iv";
    })
    (xsaPatch {
      name = "237-4.8/0002-x86-enforce-proper-privilege-when-mapping-pIRQ-s";
      sha256 = "05q1dny13jrqhjfwak7r635mqp9chpibjvn8b7d90japc1nzpq62";
    })
    (xsaPatch {
      name = "237-4.8/0003-x86-MSI-disallow-redundant-enabling";
      sha256 = "1907lv8nb2zhpb6k6jlw4m0hm0n0lyd69vfr3wpzbc56dn0w7jqd";
    })
    (xsaPatch {
      name = "237-4.8/0004-x86-IRQ-conditionally-preserve-irq-pirq-mapping-on-error";
      sha256 = "06nrq0bx3p9ipab2r1why6qm4g32dj0x5q24hfkwc6ih0l9xwf8h";
    })
    (xsaPatch {
      name = "237-4.8/0005-x86-FLASK-fix-unmap-domain-IRQ-XSM-hook";
      sha256 = "1nbg7bjw2hv55gnkhf6chkh35va6brs08acq1d5jxncl6kv0amc1";
    })
  ];

  # 4.9
  XSA_237 = [
    (xsaPatch {
      name = "237-4.9/0001-x86-dont-allow-MSI-pIRQ-mapping-on-unowned-device";
      sha256 = "1cbl24mqxa62h0wgsnrpcs6y6vs53znzj7g8dfsbmf74xwrd4px6";
    })
    (xsaPatch {
      name = "237-4.9/0002-x86-enforce-proper-privilege-when-mapping-pIRQ-s";
      sha256 = "0p60148j18b78pxz0dx5ymh1gyrhg2cgmxq0jxmbk090bc4jql35";
    })
    (xsaPatch {
      name = "237-4.9/0003-x86-MSI-disallow-redundant-enabling";
      sha256 = "1907lv8nb2zhpb6k6jlw4m0hm0n0lyd69vfr3wpzbc56dn0w7jqd";
    })
    (xsaPatch {
      name = "237-4.9/0004-x86-IRQ-conditionally-preserve-irq-pirq-mapping-on-error";
      sha256 = "0q95z5641amni53agimnzbspva53p0hz5wl16zaz2yhnjasj5pzr";
    })
    (xsaPatch {
      name = "237-4.9/0005-x86-FLASK-fix-unmap-domain-IRQ-XSM-hook";
      sha256 = "0bnqx9w7ppgx8wxj2zw09z0rkv1jzn3r0bd76cz0r22wz29fsdp2";
    })
  ];

  # 4.5
  XSA_238_45 = (xsaPatch {
    name = "238-4.5";
    sha256 = "1x2fg5vfv5jc084h5gjm6fq0nxjpzvi96px3sqzz4pvsvy4y4i1z";
  });

  # 4.8 - 4.9
  XSA_238 = (xsaPatch {
    name = "238";
    sha256 = "1cbmg1bi5ajh7qbwsl92ynaxw2c3p7i24p3wds81r4n93r0y5dxk";
  });

  # 4.5
  XSA_239_45 = (xsaPatch {
    name = "239-4.5";
    sha256 = "06bi8q3973yajxsdj7pcqarvb56q2gisxdiy0cpbyffbmpkfv3h6";
  });

  # 4.8 - 4.9
  XSA_239 = (xsaPatch {
    name = "239";
    sha256 = "1a9r8j7167s43ds5i7v7mm4y970vjnbhhkrjzpmzlcx8kcz96vh3";
  });

  # 4.5
  XSA_240_45 = [
    (xsaPatch {
      name = "240-4.5/0001-x86-limit-linear-page-table-use-to-a-single-level";
      sha256 = "0pmf10mbnmb88y7mly8s2l0j88cg0ayhkcnmj1zbjrkjmpccv395";
    })
    (xsaPatch {
      name = "240-4.5/0002-x86-mm-Disable-PV-linear-pagetables-by-default";
      sha256 = "19f096ra3xndvzkjjasx73p2g25hfkm905px0p3yakwll0qzd029";
    })
  ];

  # 4.8
  XSA_240_48 = [
    (xsaPatch {
      name = "240-4.8/0001-x86-limit-linear-page-table-use-to-a-single-level";
      sha256 = "0m44qhhqk2pdwqg8g28pypqrylq6iw00k9qrzf6qd0iza2y42kgj";
    })
    (xsaPatch {
      name = "240-4.8/0002-x86-mm-Disable-PV-linear-pagetables-by-default";
      sha256 = "1jd720wvngj9wq3fprdhakxvqlff0jd8zcx2pd3vsn2qvjbvr2gf";
    })
  ];

  # 4.9
  XSA_240 = [
    (xsaPatch {
      name = "240-4.9/0001-x86-limit-linear-page-table-use-to-a-single-level";
      sha256 = "1759ni80aifakm44g4cc6pnmbcn1xjic8j66fvj0vibm0wqk6xck";
    })
    (xsaPatch {
      name = "240-4.9/0002-x86-mm-Disable-PV-linear-pagetables-by-default";
      sha256 = "0g6dpi006p5cjxw5d8h33p0429fdmdm6nqzj0m63ralpqvns3ib5";
    })
  ];

  # 4.5 - 4.8
  XSA_241 = (xsaPatch {
    name = "241-4.8";
    sha256 = "16zb75kzs98f4mdxhbyczk5mbh9dvn6j3yhfafki34x1dfdnq4pj";
  });

  # 4.9
  XSA_241_49 = (xsaPatch {
    name = "241-4.9";
    sha256 = "0xlhin7wkhmlnbp9mqcbq3q4drdwb5la482ja9nwkhi8i867p6wc";
  });

  # 4.5 - 4.9
  XSA_242 = (xsaPatch {
    name = "242-4.9";
    sha256 = "0yx3x0i2wybsm7lzdffxa2mm866bjl4ipbb9vipnw77dyg705zpr";
  });

  # 4.5
  XSA_243_45 = [
    (xsaPatch {
      name = "243-4.6-1";
      sha256 = "1cqanpyysa7px0j645z4jw9yqsvv6cbh7yq1b86ap134axfifcan";
    })
    (xsaPatch {
      name = "243-4.5-2";
      sha256 = "0wbcgw4m0nzm2902jnda2020l7bd5adkq8j5myi1zmsfzbq03hwn";
    })
  ];

  # 4.8
  XSA_243_48 = (xsaPatch {
    name = "243-4.8";
    sha256 = "1q60zn55l9wpq45nrxh0av59sjz0jg8pkjm1gkyywkdsgg4fg5z4";
  });

  # 4.9
  XSA_243 = (xsaPatch {
    name = "243";
    sha256 = "06fnbnh9zlsbkqih9ipnb7a8gly54m7lp17d854j1r370ad3c4yg";
  });

  # 4.5
  XSA_244_45 = (xsaPatch {
    name = "244-4.5";
    sha256 = "05ci3vdl1ywfjpzcvsy1k52whxjk8pxzj7dh3r94yqasr56i5v2l";
  });

  # 4.8 - 4.9
  XSA_244 = (xsaPatch {
    name = "244";
    sha256 = "10308xsgmhb0vg6fk0ql8v94zifv6dcv6vkaicryfp405yj2rzkm";
  });

  # 4.5 - 4.9
  XSA_245 = [
    (xsaPatch {
      name = "245/0001-xen-page_alloc-Cover-memory-unreserved-after-boot-in";
      sha256 = "12brsgbn7xwakalsn10afykgqmx119mqg6vjj3v2b1pnmf4ss0w8";
    })
    (xsaPatch {
      name = "245/0002-xen-arm-Correctly-report-the-memory-region-in-the-du";
      sha256 = "1k6z5r7wnrswsczn2j3a1mc4nvxqm4ydj6n6rvgqizk2pszdkqg8";
    })
  ];

  # 4.5 - 4.7
  XSA_246_45 = [
    (xsaPatch {
      name = "246-4.7";
      sha256 = "13rad4k8z3bq15d67dhgy96kdbrjiq9sy8px0jskbpx9ygjdahkn";
    })
  ];

  # 4.8 - 4.9
  XSA_246 = [
    (xsaPatch {
      name = "246-4.9";
      sha256 = "0z68vm0z5zvv9gm06pxs9kxq2q9fdbl0l0cm71ggzdplg1vw0snz";
    })
  ];

  # 4.8
  XSA_247_48 = [
    (xsaPatch {
      name = "247-4.8/0001-p2m-Always-check-to-see-if-removing-a-p2m-entry-actu";
      sha256 = "0kvjrk90n69s721c2qj2df5raml3pjk6bg80aig353p620w6s3xh";
    })
    (xsaPatch {
      name = "247-4.8/0002-p2m-Check-return-value-of-p2m_set_entry-when-decreas";
      sha256 = "1s9kv6h6dd8psi5qf5l5gpk9qhq8blckwhl76cjbldcgi6imb3nr";
    })
  ];

  # 4.5
  XSA_247_45 = [
    (xsaPatch {
      name = "247-4.5/0001-p2m-Always-check-to-see-if-removing-a-p2m-entry-actu";
      sha256 = "0h1mp5s9si8aw2gipds317f27h9pi7bgnhj0bcmw11p0ch98sg1m";
    })
    (xsaPatch {
      name = "247-4.5/0002-p2m-Check-return-value-of-p2m_set_entry-when-decreas";
      sha256 = "0vjjybxbcm4xl26wbqvcqfiyvvlayswm4f98i1fr5a9abmljn5sb";
    })
  ];

	# 4.5
  XSA_248_45 = [
    (xsaPatch {
      name = "248-4.5";
      sha256 = "0csxg6h492ddsa210b45av28iqf7cn2dfdqk4zx10zwf1pv2shyn";
    })
  ];

  # 4.8
  XSA_248_48 = [
    (xsaPatch {
      name = "248-4.8";
      sha256 = "1ycw29q22ymxg18kxpr5p7vhpmp8klssbp5gq77hspxzz2mb96q1";
    })
  ];

  # 4.5 .. 4.9
  XSA_249 = [
   (xsaPatch {
      name = "249";
      sha256 = "0v6ngzqhkz7yv4n83xlpxfbkr2qyg5b1cds7ikkinm86hiqy6agl";
    })
  ];
  # 4.5
  XSA_250_45 = [
   (xsaPatch {
      name = "250-4.5";
      sha256 = "0pqldl6qnl834gvfp90z247q9xcjh3835s2iffnajz7jhjb2145d";
    })
  ];
  # 4.8 ...
  XSA_250 = [
   (xsaPatch {
      name = "250";
      sha256 = "1wpigg8kmha57sspqqln3ih9nbczsw6rx3v72mc62lh62qvwd7x8";
    })
  ];
  # 4.5
  XSA_251_45 = [
   (xsaPatch {
      name = "251-4.5";
      sha256 = "0lc94cx271z09r0mhxaypyd9d4740051p28idf5calx5228dqjgm";
    })
  ];
  # 4.8
  XSA_251_48 = [
   (xsaPatch {
      name = "251-4.8";
      sha256 = "079wi0j6iydid2zj7k584w2c393kgh588w7sjz2nn4039qn8k9mq";
    })
  ];

}

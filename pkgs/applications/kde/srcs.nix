# DO NOT EDIT! This file is generated automatically.
<<<<<<< HEAD
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/applications/kde/fetch.sh
=======
# Command: ./maintainers/scripts/fetch-kde-qt.sh pkgs/applications/kde
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
{ fetchurl, mirror }:

{
  akonadi = {
<<<<<<< HEAD
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-23.08.0.tar.xz";
      sha256 = "1qv1fwjmqxwwfp4xvrvv60jyy1vvayc9x320jgmr78rp2cizi602";
      name = "akonadi-23.08.0.tar.xz";
    };
  };
  akonadi-calendar = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-calendar-23.08.0.tar.xz";
      sha256 = "1a7s5rd2h50i1wxl0fl99139c4alday69j13gdmw87v5swn0lskf";
      name = "akonadi-calendar-23.08.0.tar.xz";
    };
  };
  akonadi-calendar-tools = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-calendar-tools-23.08.0.tar.xz";
      sha256 = "02mjbncx66bw64i0n2kmfk7b3w5ki7b54jhc3wvqlk8bd8rbswx4";
      name = "akonadi-calendar-tools-23.08.0.tar.xz";
    };
  };
  akonadi-contacts = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-contacts-23.08.0.tar.xz";
      sha256 = "01r7h5dxqjq4lzjf5lw52hcli6gapvnixhksj8igl279pm33p4kp";
      name = "akonadi-contacts-23.08.0.tar.xz";
    };
  };
  akonadi-import-wizard = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-import-wizard-23.08.0.tar.xz";
      sha256 = "01rsc25vfm4iwiyan27780lim0jiqfrszkkh0a14cg93kmakndsm";
      name = "akonadi-import-wizard-23.08.0.tar.xz";
    };
  };
  akonadi-mime = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-mime-23.08.0.tar.xz";
      sha256 = "0lbkygq2hrpb2yz5mwchnxzzr09m7lvl4y115bg33yp4iqb1bvwa";
      name = "akonadi-mime-23.08.0.tar.xz";
    };
  };
  akonadi-notes = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-notes-23.08.0.tar.xz";
      sha256 = "0gb8pydmh484n7ds6vwb3pblhjbbwip747vflnsf749c21vhqn5c";
      name = "akonadi-notes-23.08.0.tar.xz";
    };
  };
  akonadi-search = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadi-search-23.08.0.tar.xz";
      sha256 = "1vvb65a290zarhb7jzga9d0xyg1xpz52ln83ygf95m6awwjprl59";
      name = "akonadi-search-23.08.0.tar.xz";
    };
  };
  akonadiconsole = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akonadiconsole-23.08.0.tar.xz";
      sha256 = "1af0s3jwn5vgl88rvavqgnzx7mbqxdp3kxraqhhi8h3ngxdf0l6y";
      name = "akonadiconsole-23.08.0.tar.xz";
    };
  };
  akregator = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/akregator-23.08.0.tar.xz";
      sha256 = "0l6ycd8dygy46s1g0cy5harj4wqll1pklcp8zb3bc751jfcrajr8";
      name = "akregator-23.08.0.tar.xz";
    };
  };
  alligator = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/alligator-23.08.0.tar.xz";
      sha256 = "014d43ivaql21mz6jxdbyg1j2gccpv2d39cmn55dm08djv22xk1d";
      name = "alligator-23.08.0.tar.xz";
    };
  };
  analitza = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/analitza-23.08.0.tar.xz";
      sha256 = "00b2cgksy1whn42li6ky3jdznwkxaa9ndncw1rfydg220db6zi6v";
      name = "analitza-23.08.0.tar.xz";
    };
  };
  angelfish = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/angelfish-23.08.0.tar.xz";
      sha256 = "00xvpi3jba8gxp3hzlm1rb4m3qf1fx2ixz1lyvamkyvm8rp6b9pj";
      name = "angelfish-23.08.0.tar.xz";
    };
  };
  arianna = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/arianna-23.08.0.tar.xz";
      sha256 = "1iyzsa10750dyw5l4mhsz11la6i2217kzj7alkz258nai3bj69s4";
      name = "arianna-23.08.0.tar.xz";
    };
  };
  ark = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ark-23.08.0.tar.xz";
      sha256 = "09i58hzn83g30zln3wgwcjp2k0ygkgabnfq4izhsvgkkm4bgkz21";
      name = "ark-23.08.0.tar.xz";
    };
  };
  artikulate = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/artikulate-23.08.0.tar.xz";
      sha256 = "1rwyxg7h4bfmd3mb9ddv818sq78k84clb0kdz4jacs0601vycp89";
      name = "artikulate-23.08.0.tar.xz";
    };
  };
  audiocd-kio = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/audiocd-kio-23.08.0.tar.xz";
      sha256 = "1kkcny6dqd7a64j60znbadx6s6wa6jriah8a7dggr4kzr9p6fbx2";
      name = "audiocd-kio-23.08.0.tar.xz";
    };
  };
  audiotube = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/audiotube-23.08.0.tar.xz";
      sha256 = "1y06c0qyl1amll2dwjwaffnjag6lz9fypwl20rzwd1k2ivsssv0v";
      name = "audiotube-23.08.0.tar.xz";
    };
  };
  baloo-widgets = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/baloo-widgets-23.08.0.tar.xz";
      sha256 = "0p6n05v92rb8dnss3zx08xqhadg8vf2cd0n80xq169flvvf6syzl";
      name = "baloo-widgets-23.08.0.tar.xz";
    };
  };
  blinken = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/blinken-23.08.0.tar.xz";
      sha256 = "1wlyybv1x2qcffiq0hx9pcsc8zc4iiswa8390apcr415shrfd334";
      name = "blinken-23.08.0.tar.xz";
    };
  };
  bomber = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/bomber-23.08.0.tar.xz";
      sha256 = "19n0n4m4jr9x5jf35w5ylhh2ip7ax3vymjsma868z27kidpkssc2";
      name = "bomber-23.08.0.tar.xz";
    };
  };
  bovo = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/bovo-23.08.0.tar.xz";
      sha256 = "01glqz3qfd4mpq6wmhqwr0gx2dxbgzsi9jwfqvzwp3ch3snpri38";
      name = "bovo-23.08.0.tar.xz";
    };
  };
  calendarsupport = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/calendarsupport-23.08.0.tar.xz";
      sha256 = "0cqjmq1v9g87z0qmjwk5k32i0kg2dzr1dsvpyhkgr022gd02qxdr";
      name = "calendarsupport-23.08.0.tar.xz";
    };
  };
  calindori = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/calindori-23.08.0.tar.xz";
      sha256 = "17dzlgs3n5404iaq6c6ghyvh8pp0myxmjzwwqk9l0k10wq8zr3df";
      name = "calindori-23.08.0.tar.xz";
    };
  };
  cantor = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/cantor-23.08.0.tar.xz";
      sha256 = "04yzh8i61nj0s1qpiry0qhjpjj5z1qqv6vpslyw365sx737mklz5";
      name = "cantor-23.08.0.tar.xz";
    };
  };
  cervisia = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/cervisia-23.08.0.tar.xz";
      sha256 = "0qiv9klnkrxf5vrcjxz4b29hyi52w1dgb1fvw22p0sqpkc8gph68";
      name = "cervisia-23.08.0.tar.xz";
    };
  };
  colord-kde = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/colord-kde-23.08.0.tar.xz";
      sha256 = "0nz76ikygvwvjjjx3sc3abq2aafq8fr5hhfb7gmcjpcz6w8vgw7z";
      name = "colord-kde-23.08.0.tar.xz";
    };
  };
  dolphin = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/dolphin-23.08.0.tar.xz";
      sha256 = "1pjrzzj0hrzsmlzxxhl5clph1m2pdba805q38rrjzin0hgpg7c2a";
      name = "dolphin-23.08.0.tar.xz";
    };
  };
  dolphin-plugins = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/dolphin-plugins-23.08.0.tar.xz";
      sha256 = "1piz4jqxz2smn3fkyaqg48jbk76s4vsrgnhskvib515cfr4hhhy4";
      name = "dolphin-plugins-23.08.0.tar.xz";
    };
  };
  dragon = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/dragon-23.08.0.tar.xz";
      sha256 = "185rwi0l49spnbrzcafv4z90zj10c38r5li53aba3pqsk6ff6n0p";
      name = "dragon-23.08.0.tar.xz";
    };
  };
  elisa = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/elisa-23.08.0.tar.xz";
      sha256 = "19kdchfcw3pvcyaib2fac46zsfa6gnj2sw5wjm7wwbks5af7kck4";
      name = "elisa-23.08.0.tar.xz";
    };
  };
  eventviews = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/eventviews-23.08.0.tar.xz";
      sha256 = "0ghilcv9m8q2k0myc6l14nz5rg1nkvp2aypb58lma6fi8x8111b2";
      name = "eventviews-23.08.0.tar.xz";
    };
  };
  falkon = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/falkon-23.08.0.tar.xz";
      sha256 = "0wg5n53si1ybajzh5nnsfx9z9dkhrzl05l1q19004m62z3l8d9b2";
      name = "falkon-23.08.0.tar.xz";
    };
  };
  ffmpegthumbs = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ffmpegthumbs-23.08.0.tar.xz";
      sha256 = "1vdywm5r21ag287xihhzzrybni9p3kcy45d0a1nn65ll2285mqnh";
      name = "ffmpegthumbs-23.08.0.tar.xz";
    };
  };
  filelight = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/filelight-23.08.0.tar.xz";
      sha256 = "1qknny5jivzm9ac7r4z957hprnj1qq08ghi42l395lmqfpwwy5ic";
      name = "filelight-23.08.0.tar.xz";
    };
  };
  ghostwriter = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ghostwriter-23.08.0.tar.xz";
      sha256 = "1bxcb1dx3xf0lv13wk3qkzq071gwl9p1npmkmdbjx2q6vrrfzxy4";
      name = "ghostwriter-23.08.0.tar.xz";
    };
  };
  granatier = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/granatier-23.08.0.tar.xz";
      sha256 = "0hyv3jv0bcmilmd28bhpah0lm0si34n27lmwm4fm80wkcr3n7jwr";
      name = "granatier-23.08.0.tar.xz";
    };
  };
  grantlee-editor = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/grantlee-editor-23.08.0.tar.xz";
      sha256 = "0pbdl2n1ym1cksv5j5ifhi10p5hhnmrismrrhq8v9xpw7bpc627b";
      name = "grantlee-editor-23.08.0.tar.xz";
    };
  };
  grantleetheme = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/grantleetheme-23.08.0.tar.xz";
      sha256 = "1mq0afzqgid2vkpdskkdbcx1ylfmcrbw4m9gzkfaa7c8ffmlp57s";
      name = "grantleetheme-23.08.0.tar.xz";
    };
  };
  gwenview = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/gwenview-23.08.0.tar.xz";
      sha256 = "19wa33r1vk45dbnr64l3nlixr5vppypk2h11limvm2ndhwzxwzq2";
      name = "gwenview-23.08.0.tar.xz";
    };
  };
  incidenceeditor = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/incidenceeditor-23.08.0.tar.xz";
      sha256 = "1p1v65qglrwf0q4brwvmq4328i9dfnjspv001ip56bnxrps2kfpn";
      name = "incidenceeditor-23.08.0.tar.xz";
    };
  };
  itinerary = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/itinerary-23.08.0.tar.xz";
      sha256 = "0y87md72yd6f9yn31kj09ibfril5pj3cyds5cq3j3z59yhhgd665";
      name = "itinerary-23.08.0.tar.xz";
    };
  };
  juk = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/juk-23.08.0.tar.xz";
      sha256 = "04dppr21vj4nnb0jmbnc9afk4jwhfj3dj0cf375l1kdglxa4ncc1";
      name = "juk-23.08.0.tar.xz";
    };
  };
  k3b = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/k3b-23.08.0.tar.xz";
      sha256 = "1zvwlxf3k63b29d0xzq4bgi206g0wnp5j0z00lxy9rnm275gwhz6";
      name = "k3b-23.08.0.tar.xz";
    };
  };
  kaccounts-integration = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kaccounts-integration-23.08.0.tar.xz";
      sha256 = "1by9pjjd6zpjjd9j5w8h8aqhzib5d0l3xp9dgvlw4afhbp5dv73g";
      name = "kaccounts-integration-23.08.0.tar.xz";
    };
  };
  kaccounts-providers = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kaccounts-providers-23.08.0.tar.xz";
      sha256 = "08jv0z1586rfwrd9jrs7fk2xwjfmkmia1kaz904linxmmhv97zsh";
      name = "kaccounts-providers-23.08.0.tar.xz";
    };
  };
  kaddressbook = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kaddressbook-23.08.0.tar.xz";
      sha256 = "1aw3zwjxyml6bvsld1qndkarvr11y43dif296qr21cplns48d5r1";
      name = "kaddressbook-23.08.0.tar.xz";
    };
  };
  kajongg = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kajongg-23.08.0.tar.xz";
      sha256 = "1x7gx6fg1irdrwp7lbgm5m2vair2zyijcj1bbabvm4kl28d3r85j";
      name = "kajongg-23.08.0.tar.xz";
    };
  };
  kalarm = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kalarm-23.08.0.tar.xz";
      sha256 = "0wghnj5g3sq7vg9r328dqkqzl0hizxs93l9kma8h85hnf5ns9any";
      name = "kalarm-23.08.0.tar.xz";
    };
  };
  kalgebra = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kalgebra-23.08.0.tar.xz";
      sha256 = "0rrzhnrjmc0fjgbpbw3mpfbspbyfa4gr6pqkhgy3sb313wamvk9r";
      name = "kalgebra-23.08.0.tar.xz";
    };
  };
  kalk = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kalk-23.08.0.tar.xz";
      sha256 = "15jig1y7s21aiv3dg2702qvdxy6k6k5yrrz9nhq5n839kgy3jn8g";
      name = "kalk-23.08.0.tar.xz";
    };
  };
  kalzium = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kalzium-23.08.0.tar.xz";
      sha256 = "0vj69kc4svw3c0l7j7kasrcn8dj7ky5qryg6aydmbbckbikj778y";
      name = "kalzium-23.08.0.tar.xz";
    };
  };
  kamera = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kamera-23.08.0.tar.xz";
      sha256 = "1i4rchmj188acavi9yx7w8pmpqsdkz0iza60w2p3x32p5saw5arq";
      name = "kamera-23.08.0.tar.xz";
    };
  };
  kamoso = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kamoso-23.08.0.tar.xz";
      sha256 = "1izvgzsxy680cqz1j9j9haj5lfr9nas7xzjlwj1p7zfhawrqb75j";
      name = "kamoso-23.08.0.tar.xz";
    };
  };
  kanagram = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kanagram-23.08.0.tar.xz";
      sha256 = "18yajg5mx9frab79amgxdf096kkn91hcfh04b0bipbn6k36kkl9n";
      name = "kanagram-23.08.0.tar.xz";
    };
  };
  kapman = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kapman-23.08.0.tar.xz";
      sha256 = "027c2w72ljy8xlb3gqpab818j23qf7qsldxssflzlj0mh7igvgwh";
      name = "kapman-23.08.0.tar.xz";
    };
  };
  kapptemplate = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kapptemplate-23.08.0.tar.xz";
      sha256 = "1r2kbh9r1b0nhzsipsnp2ppa817g324p39pwpnrsc0zyi52mdack";
      name = "kapptemplate-23.08.0.tar.xz";
    };
  };
  kasts = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kasts-23.08.0.tar.xz";
      sha256 = "0sayr85lwj2xwmcx8r1kdmf7isjdn5a5shn58n930sishpcplhjn";
      name = "kasts-23.08.0.tar.xz";
    };
  };
  kate = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kate-23.08.0.tar.xz";
      sha256 = "1cb8il661x9s7cn5dzc8az073s30s119mlnwglisglawzqn0v4ry";
      name = "kate-23.08.0.tar.xz";
    };
  };
  katomic = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/katomic-23.08.0.tar.xz";
      sha256 = "0arryssaaw5m5mhq6hym8zjzxx0zr45jyh07ya1cmcx5r2505xl8";
      name = "katomic-23.08.0.tar.xz";
    };
  };
  kbackup = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kbackup-23.08.0.tar.xz";
      sha256 = "0i91rr2sh8qs4gxwv1bmfarjppyvbba1pv7i0wcvj6lmaz6h3yna";
      name = "kbackup-23.08.0.tar.xz";
    };
  };
  kblackbox = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kblackbox-23.08.0.tar.xz";
      sha256 = "1axyzchy4cv5gci01w2kj7vg0sddafcx4zvwy07m2nb46niahcvy";
      name = "kblackbox-23.08.0.tar.xz";
    };
  };
  kblocks = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kblocks-23.08.0.tar.xz";
      sha256 = "1fr54i2jw058pxsrba8vy48yyzqcipb3aw40zw3093bglmiig1ql";
      name = "kblocks-23.08.0.tar.xz";
    };
  };
  kbounce = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kbounce-23.08.0.tar.xz";
      sha256 = "13lwykx2dvjqa8qviwpr5w3dvprb6p5mf1ygqvw7476mdp8709jx";
      name = "kbounce-23.08.0.tar.xz";
    };
  };
  kbreakout = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kbreakout-23.08.0.tar.xz";
      sha256 = "1mwdajfaxfawswk0c9r5b78q1rhh6q1v3wbfbllg4k2lnmp40b4x";
      name = "kbreakout-23.08.0.tar.xz";
    };
  };
  kbruch = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kbruch-23.08.0.tar.xz";
      sha256 = "0ipmbzy9iqb5mng80vv8hcj8ay7v9yj762xzsscf444dhdy78vad";
      name = "kbruch-23.08.0.tar.xz";
    };
  };
  kcachegrind = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kcachegrind-23.08.0.tar.xz";
      sha256 = "1087a4mwq3a2fqii0kcxl4i94wcni491n3x53i3c25bi5qypsmvw";
      name = "kcachegrind-23.08.0.tar.xz";
    };
  };
  kcalc = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kcalc-23.08.0.tar.xz";
      sha256 = "1q7c7v2m84c7kbgfjgsm0qy8jyz19l0plk6rff1qmfqx3y20glny";
      name = "kcalc-23.08.0.tar.xz";
    };
  };
  kcalutils = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kcalutils-23.08.0.tar.xz";
      sha256 = "1wqp0d40pqn1vaqhv7x5qzp9nx43a96l9yk9vyh3yg9q8jfgajgy";
      name = "kcalutils-23.08.0.tar.xz";
    };
  };
  kcharselect = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kcharselect-23.08.0.tar.xz";
      sha256 = "0b4ay70rc0wzz05ld3rm8yf2wq2gkmxgysnak34nj62iadz52rf5";
      name = "kcharselect-23.08.0.tar.xz";
    };
  };
  kclock = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kclock-23.08.0.tar.xz";
      sha256 = "08v180yl7da7i8q5ll0i3dqlh6pqnirsrcq5lfbb2mvczxsr1frw";
      name = "kclock-23.08.0.tar.xz";
    };
  };
  kcolorchooser = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kcolorchooser-23.08.0.tar.xz";
      sha256 = "15vxyd8xwg8m1jbmag5897094hs8a7ipsa04ss3yd4zd9g4bx0fp";
      name = "kcolorchooser-23.08.0.tar.xz";
    };
  };
  kcron = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kcron-23.08.0.tar.xz";
      sha256 = "1y9zga7mniadnzkqpyqy61hiznzib5p0ycfv8bbx1q5bx7cnkslh";
      name = "kcron-23.08.0.tar.xz";
    };
  };
  kde-dev-scripts = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kde-dev-scripts-23.08.0.tar.xz";
      sha256 = "0mdi1jpx6lxg7g8jfz8z5sdyv7kf6yfk8mhr3xv3mmmnb3qpkkx0";
      name = "kde-dev-scripts-23.08.0.tar.xz";
    };
  };
  kde-dev-utils = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kde-dev-utils-23.08.0.tar.xz";
      sha256 = "0x03czwbr134kp9b6bgm91jqyja6wh5mkfs95afirb0h4v7xmr0i";
      name = "kde-dev-utils-23.08.0.tar.xz";
    };
  };
  kde-inotify-survey = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kde-inotify-survey-23.08.0.tar.xz";
      sha256 = "1hc8rlbrb7k5m3j3cwbxi5a51c15ax1lv593il5bbbz6yr36dhiq";
      name = "kde-inotify-survey-23.08.0.tar.xz";
    };
  };
  kdebugsettings = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdebugsettings-23.08.0.tar.xz";
      sha256 = "1a8h8fn55jsyf56l5s6y3cag1v4wm1cwk2hdfrjl3zi5j0vqln4d";
      name = "kdebugsettings-23.08.0.tar.xz";
    };
  };
  kdeconnect-kde = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdeconnect-kde-23.08.0.tar.xz";
      sha256 = "1sfm04k81992skb5s1n968nj8zd07yyk0p5qqnhyyacrz5scchcb";
      name = "kdeconnect-kde-23.08.0.tar.xz";
    };
  };
  kdeedu-data = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdeedu-data-23.08.0.tar.xz";
      sha256 = "1322hc5iavnv181i5kydvfvfdap3j6a5m9q2id7g6il5iwvpq04d";
      name = "kdeedu-data-23.08.0.tar.xz";
    };
  };
  kdegraphics-mobipocket = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdegraphics-mobipocket-23.08.0.tar.xz";
      sha256 = "1yvrg6z9gjicqnr64la5k3acb8p1x0d9mc1xrhy8gsxpj67wdb8m";
      name = "kdegraphics-mobipocket-23.08.0.tar.xz";
    };
  };
  kdegraphics-thumbnailers = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdegraphics-thumbnailers-23.08.0.tar.xz";
      sha256 = "0csl6kh2j6sdsq812an10vlrg6cirm5v195dxgc3na1y6ncjk250";
      name = "kdegraphics-thumbnailers-23.08.0.tar.xz";
    };
  };
  kdenetwork-filesharing = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdenetwork-filesharing-23.08.0.tar.xz";
      sha256 = "0airv4vgb6ivl74hhhsm26f6isjkrr7222l01kqcxv4dwf0jkmyf";
      name = "kdenetwork-filesharing-23.08.0.tar.xz";
    };
  };
  kdenlive = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdenlive-23.08.0.tar.xz";
      sha256 = "01yjwikvjs75khr12s86sw2ly9c51vrb7zgh9q0phxbz3p6gcqsz";
      name = "kdenlive-23.08.0.tar.xz";
    };
  };
  kdepim-addons = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdepim-addons-23.08.0.tar.xz";
      sha256 = "189fmzgvshnld3j7y98g70z9qyrkizk0nfl5im5wamrcn77vwpv1";
      name = "kdepim-addons-23.08.0.tar.xz";
    };
  };
  kdepim-runtime = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdepim-runtime-23.08.0.tar.xz";
      sha256 = "16i2sbqzvmsjb20xjlbp92jaig66bg9ws52dk7d45r2j8ppb9qli";
      name = "kdepim-runtime-23.08.0.tar.xz";
    };
  };
  kdesdk-kio = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdesdk-kio-23.08.0.tar.xz";
      sha256 = "17wmzkbmq6p60dabnb3bkx7f6z04wkj271fpyhlijj5ma3w6dl88";
      name = "kdesdk-kio-23.08.0.tar.xz";
    };
  };
  kdesdk-thumbnailers = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdesdk-thumbnailers-23.08.0.tar.xz";
      sha256 = "1add5r1vaqp1r5m37636pzvik15imz7k3qnskyrw60jzyk9fyq9m";
      name = "kdesdk-thumbnailers-23.08.0.tar.xz";
    };
  };
  kdev-php = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdev-php-23.08.0.tar.xz";
      sha256 = "0dwxczpbxn3in08cmyf393k7xh83qmj95kbm0fbxigpadxy76ykg";
      name = "kdev-php-23.08.0.tar.xz";
    };
  };
  kdev-python = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdev-python-23.08.0.tar.xz";
      sha256 = "1s0zw2b8kb16nii2da8sx2vx1x4s130nlc9fwvc63jin8f01ynmx";
      name = "kdev-python-23.08.0.tar.xz";
    };
  };
  kdevelop = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdevelop-23.08.0.tar.xz";
      sha256 = "0spfg8a4carrdl9fmf60qr85dzxah2g6vy3zxhqaadd4kcsrjz1h";
      name = "kdevelop-23.08.0.tar.xz";
    };
  };
  kdf = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdf-23.08.0.tar.xz";
      sha256 = "1x5gfa7bs8fyq2pqvnriswwlak78pq61np2whsmh07njq8s6frdq";
      name = "kdf-23.08.0.tar.xz";
    };
  };
  kdialog = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdialog-23.08.0.tar.xz";
      sha256 = "1h4mid01v732iw8gd86r88l8n9yq55dwlixk9lz239i17hzr8l0n";
      name = "kdialog-23.08.0.tar.xz";
    };
  };
  kdiamond = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kdiamond-23.08.0.tar.xz";
      sha256 = "0ps4wf3gz7zrkplsqa9b5a0523f55a5m2b41vnfmkcg3fkdpn4n0";
      name = "kdiamond-23.08.0.tar.xz";
    };
  };
  keditbookmarks = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/keditbookmarks-23.08.0.tar.xz";
      sha256 = "1fvi81qpf3nvgp0lqyqgbk1mhwf6s4m6k6ivd1d4zhlcq93wwjf6";
      name = "keditbookmarks-23.08.0.tar.xz";
    };
  };
  keysmith = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/keysmith-23.08.0.tar.xz";
      sha256 = "1xa0r9c28m87chk90kaxs1xs73s6y6m6a9na1j6p15zad1lxjn81";
      name = "keysmith-23.08.0.tar.xz";
    };
  };
  kfind = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kfind-23.08.0.tar.xz";
      sha256 = "0wsym0gi32fr35dr0c2ib6h7pgm5h9cbibgm5knrs18fsncqkj5i";
      name = "kfind-23.08.0.tar.xz";
    };
  };
  kfourinline = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kfourinline-23.08.0.tar.xz";
      sha256 = "17xx3yraiarkll24yxw0n7vg1ygsix8kjiwk3w2dc8xlgg36smhh";
      name = "kfourinline-23.08.0.tar.xz";
    };
  };
  kgeography = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kgeography-23.08.0.tar.xz";
      sha256 = "1rz973mlc5jiyn0xgxpwvvk015g68mmk71xwgdhd785al1hi0nwi";
      name = "kgeography-23.08.0.tar.xz";
    };
  };
  kget = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kget-23.08.0.tar.xz";
      sha256 = "1w5y5cphzjz2j9vfc9qnzxn6wcbp2gw9i30jxchnvrp0lzzfi30n";
      name = "kget-23.08.0.tar.xz";
    };
  };
  kgoldrunner = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kgoldrunner-23.08.0.tar.xz";
      sha256 = "1sn5h0ng1ixislq010x6yv6npby19i9abg4swk3dadij52fgm4yd";
      name = "kgoldrunner-23.08.0.tar.xz";
    };
  };
  kgpg = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kgpg-23.08.0.tar.xz";
      sha256 = "14qqv67vp16v3i9bhyhjvbgpr4c7xsfmn4pzcdwpjrqscy54713a";
      name = "kgpg-23.08.0.tar.xz";
    };
  };
  khangman = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/khangman-23.08.0.tar.xz";
      sha256 = "1xjsmf161z0xlaxpxm9p7n1477qcka8fzvcdj7gsrk55p519idsl";
      name = "khangman-23.08.0.tar.xz";
    };
  };
  khelpcenter = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/khelpcenter-23.08.0.tar.xz";
      sha256 = "1g1y4hcxcd2aw7f5wymsdma1zjpmkhqvsnwn8yj1yj9gzh35wwcn";
      name = "khelpcenter-23.08.0.tar.xz";
    };
  };
  kidentitymanagement = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kidentitymanagement-23.08.0.tar.xz";
      sha256 = "10hnbnc2iwa73m2nk4b2vj1r1g6y29cqijkx0ldqxim3q6f2pqi6";
      name = "kidentitymanagement-23.08.0.tar.xz";
    };
  };
  kig = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kig-23.08.0.tar.xz";
      sha256 = "1gf5ffxaxz26pbawc0j2ymkasg7r55dinp9n267x31ljfk96vl16";
      name = "kig-23.08.0.tar.xz";
    };
  };
  kigo = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kigo-23.08.0.tar.xz";
      sha256 = "1klhc1lyl32av1bzrd0j6y3n2vjf3ng1jkx6pr95w0mys3nz3z0w";
      name = "kigo-23.08.0.tar.xz";
    };
  };
  killbots = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/killbots-23.08.0.tar.xz";
      sha256 = "0ihrrb1zngr1b9xwl65b631cb5d7w3na9f7k0dhih32j2rd1mc6z";
      name = "killbots-23.08.0.tar.xz";
    };
  };
  kimagemapeditor = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kimagemapeditor-23.08.0.tar.xz";
      sha256 = "1lj7pbccghniakbxcb4dyffb2q5s62r880cls08pw1hmnih558cq";
      name = "kimagemapeditor-23.08.0.tar.xz";
    };
  };
  kimap = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kimap-23.08.0.tar.xz";
      sha256 = "0rn2xg6nrnr33d6lljfqdvc65dn2rmglv6j03cqml5cqck1cm0l7";
      name = "kimap-23.08.0.tar.xz";
    };
  };
  kio-admin = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kio-admin-23.08.0.tar.xz";
      sha256 = "157l499087gcw70wmdiaapqf5yipknsbqvpv2jjbb8p2vgp8q1pc";
      name = "kio-admin-23.08.0.tar.xz";
    };
  };
  kio-extras = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kio-extras-23.08.0.tar.xz";
      sha256 = "02a84v4d9d2rns65j4yq1dspmifbh5h0mr1v14i9znffz3pfn72s";
      name = "kio-extras-23.08.0.tar.xz";
    };
  };
  kio-gdrive = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kio-gdrive-23.08.0.tar.xz";
      sha256 = "1cngw7hyyryr0d1yj8r7l5ijdx9xxjw43c426m8rxm8w6x640mcz";
      name = "kio-gdrive-23.08.0.tar.xz";
    };
  };
  kio-zeroconf = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kio-zeroconf-23.08.0.tar.xz";
      sha256 = "1920kl6r8jm8zp0q9c5civ7gx0a3kj13i9hlingjp042lwbww9z2";
      name = "kio-zeroconf-23.08.0.tar.xz";
    };
  };
  kipi-plugins = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kipi-plugins-23.08.0.tar.xz";
      sha256 = "0v9sm5c4d8g5ih9wbsmbfvxgjk7divjklfbwkv3pyhzvbqspai0p";
      name = "kipi-plugins-23.08.0.tar.xz";
    };
  };
  kirigami-gallery = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kirigami-gallery-23.08.0.tar.xz";
      sha256 = "06l6izavxlsgdkmi798ynk9b1sfw74cwhhdga4q92qvy3ick311x";
      name = "kirigami-gallery-23.08.0.tar.xz";
    };
  };
  kiriki = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kiriki-23.08.0.tar.xz";
      sha256 = "030nw63s8xmvmgngb6w04yv6h0yj6cqvl7qybwhrrahxr3906jzs";
      name = "kiriki-23.08.0.tar.xz";
    };
  };
  kiten = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kiten-23.08.0.tar.xz";
      sha256 = "1fhx9hbciw622wpqj5lhdb9vws4p2l6zrbmzmxkx7djxdym41hra";
      name = "kiten-23.08.0.tar.xz";
    };
  };
  kitinerary = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kitinerary-23.08.0.tar.xz";
      sha256 = "1m7yhm4yrvhbpggigfrm2xd41rg91zwvs0rbnfsrpnhr2wm8qb1r";
      name = "kitinerary-23.08.0.tar.xz";
    };
  };
  kjournald = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kjournald-23.08.0.tar.xz";
      sha256 = "19mcj53gxlipd6ny6dzyqxq0i6v1838wxl79dj9gwgvmqrr1vd4i";
      name = "kjournald-23.08.0.tar.xz";
    };
  };
  kjumpingcube = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kjumpingcube-23.08.0.tar.xz";
      sha256 = "0grzrw3mi94fc00flq8alrf1z2pksk0r0xafazi1i9ibv789d899";
      name = "kjumpingcube-23.08.0.tar.xz";
    };
  };
  kldap = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kldap-23.08.0.tar.xz";
      sha256 = "14457ld8rdvs2s2nrbpnvf7vcqrpbxxnzbqbxg8z7swpn695w235";
      name = "kldap-23.08.0.tar.xz";
    };
  };
  kleopatra = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kleopatra-23.08.0.tar.xz";
      sha256 = "0pr56q1cb26453zxxya8lxhchp2v05631ic4v9fqbwfmgchj13xq";
      name = "kleopatra-23.08.0.tar.xz";
    };
  };
  klettres = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/klettres-23.08.0.tar.xz";
      sha256 = "1wqnmpl9ilv4bl8cp55kqbcnbqm9k2g93z0ilv313k8wlx79djld";
      name = "klettres-23.08.0.tar.xz";
    };
  };
  klickety = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/klickety-23.08.0.tar.xz";
      sha256 = "118pf0zj4a0q1hca0ym70q85ac5fsjkki2g04x1hjrzkcv51q8zz";
      name = "klickety-23.08.0.tar.xz";
    };
  };
  klines = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/klines-23.08.0.tar.xz";
      sha256 = "0al1ri7g20r8w7ijk1pdgpvn32z9nfrr19rj2hrm2wg2349kvqdq";
      name = "klines-23.08.0.tar.xz";
    };
  };
  kmag = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmag-23.08.0.tar.xz";
      sha256 = "0swj9zaamrv8jp38hmd8fisnaljjr1i1vplrbvipxr2sg2f3zlip";
      name = "kmag-23.08.0.tar.xz";
    };
  };
  kmahjongg = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmahjongg-23.08.0.tar.xz";
      sha256 = "1i20mxciwvgb5d0zg7via8rk4yzx7n35c8gphd0lyf27s8rc0kpr";
      name = "kmahjongg-23.08.0.tar.xz";
    };
  };
  kmail = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmail-23.08.0.tar.xz";
      sha256 = "052pz9rhb2s0cf86ms1br8sl3f7iwb6k864d64b3wd5xvhbcsf55";
      name = "kmail-23.08.0.tar.xz";
    };
  };
  kmail-account-wizard = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmail-account-wizard-23.08.0.tar.xz";
      sha256 = "14y0q8xm0m59pqh783y9iji5ngf7ckhyfrh9kmj2i972m3dzh2db";
      name = "kmail-account-wizard-23.08.0.tar.xz";
    };
  };
  kmailtransport = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmailtransport-23.08.0.tar.xz";
      sha256 = "0ifaqbjpfmislngl92qssnssjd9maz44lzlihp8cnnn2kd1xw3pg";
      name = "kmailtransport-23.08.0.tar.xz";
    };
  };
  kmbox = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmbox-23.08.0.tar.xz";
      sha256 = "1v5s0vs2n316qk0kr737i9kcmx15b7z1yhgbdwhmllyb2cybn6s4";
      name = "kmbox-23.08.0.tar.xz";
    };
  };
  kmime = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmime-23.08.0.tar.xz";
      sha256 = "0z7zk9q0j0i4ddcnlgqb8p82vnwwxqw5l9hpmlyd8bsdxghd8wp4";
      name = "kmime-23.08.0.tar.xz";
    };
  };
  kmines = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmines-23.08.0.tar.xz";
      sha256 = "10wrx0xlnx3d27hyb3j33cdrqis8lvmd8h0x6vm7xrw9pbfnhfzk";
      name = "kmines-23.08.0.tar.xz";
    };
  };
  kmix = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmix-23.08.0.tar.xz";
      sha256 = "013jwxd0l3vdfqjqd3g52p5jpql67f50qhnfnr2vygmz5xb65p8k";
      name = "kmix-23.08.0.tar.xz";
    };
  };
  kmousetool = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmousetool-23.08.0.tar.xz";
      sha256 = "1nijq9d2chvil677npx9pj155v6xl5iklyi2696jndfw9v30hsy1";
      name = "kmousetool-23.08.0.tar.xz";
    };
  };
  kmouth = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmouth-23.08.0.tar.xz";
      sha256 = "031kj9n1p9x927z373b1yhfnhi2r8spp5lb4gxfngfxnh41cadrx";
      name = "kmouth-23.08.0.tar.xz";
    };
  };
  kmplot = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kmplot-23.08.0.tar.xz";
      sha256 = "0if00w89a4zjsbjxagz49jkqbir9l4fqn7rzrxx3ji6pgk5817yf";
      name = "kmplot-23.08.0.tar.xz";
    };
  };
  knavalbattle = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/knavalbattle-23.08.0.tar.xz";
      sha256 = "0vfzp4bcmxgz1llza7vigffa2zcgs2k2qmxahqbb076fy6qmqgqr";
      name = "knavalbattle-23.08.0.tar.xz";
    };
  };
  knetwalk = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/knetwalk-23.08.0.tar.xz";
      sha256 = "0wh746q4hnyf4zq2rh1i8y22b3a8a5qwrp3rwl1b8aq6fwhfwypl";
      name = "knetwalk-23.08.0.tar.xz";
    };
  };
  knights = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/knights-23.08.0.tar.xz";
      sha256 = "1qjlssvdiri6y4grl4w1dzg65gnkwdpvlamhz7q8fbrbifr10im6";
      name = "knights-23.08.0.tar.xz";
    };
  };
  knotes = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/knotes-23.08.0.tar.xz";
      sha256 = "03mvz47c8arjzmjlmr91gw9gnad6f6smspbzr0niwhsgns7brcqq";
      name = "knotes-23.08.0.tar.xz";
    };
  };
  koko = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/koko-23.08.0.tar.xz";
      sha256 = "18i7kw8x6wg1ak1l0qn83kdfkq5p7fc0zkf71jyzbs30jgx3lird";
      name = "koko-23.08.0.tar.xz";
    };
  };
  kolf = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kolf-23.08.0.tar.xz";
      sha256 = "1k6zv6lgld5cvv73bkr1sb50hihvrjhwf8irw11wing808fcg1w9";
      name = "kolf-23.08.0.tar.xz";
    };
  };
  kollision = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kollision-23.08.0.tar.xz";
      sha256 = "0j8fyh0k48wh3rhbv0vid4lh9a439cyiqg7d0kpz5v93271vj99b";
      name = "kollision-23.08.0.tar.xz";
    };
  };
  kolourpaint = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kolourpaint-23.08.0.tar.xz";
      sha256 = "1d53m63nmphd81vv5a75kaqx75z8sdfgasbi8yrppgp423157j8v";
      name = "kolourpaint-23.08.0.tar.xz";
    };
  };
  kompare = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kompare-23.08.0.tar.xz";
      sha256 = "1fkhb3ap3xmyjy8ixybdgbllq4948zsjxqypxczjxjalc3mpijz1";
      name = "kompare-23.08.0.tar.xz";
    };
  };
  kongress = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kongress-23.08.0.tar.xz";
      sha256 = "1773qavz9g4jxwxb5qvj64pcfr0j4yd3r9wqb3a291p3fspi5flk";
      name = "kongress-23.08.0.tar.xz";
    };
  };
  konqueror = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/konqueror-23.08.0.tar.xz";
      sha256 = "1xgrmag0x9hhhxwih1zzcf89jm2f60cbih5sc291daayfjb907x3";
      name = "konqueror-23.08.0.tar.xz";
    };
  };
  konquest = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/konquest-23.08.0.tar.xz";
      sha256 = "090ksydgn56f1hym1s3sv58n5l3n990idl9149xpf7q33zfvwnlp";
      name = "konquest-23.08.0.tar.xz";
    };
  };
  konsole = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/konsole-23.08.0.tar.xz";
      sha256 = "177sfgs5jpaih6zpk4wfax6ic9qh3zlq6bi2h7mr7jsd8pcnplii";
      name = "konsole-23.08.0.tar.xz";
    };
  };
  kontact = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kontact-23.08.0.tar.xz";
      sha256 = "116dmf6pkcix00dwj7rajxbb3jjfp7xiwd6w2g08w6ir9n2fgncr";
      name = "kontact-23.08.0.tar.xz";
    };
  };
  kontactinterface = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kontactinterface-23.08.0.tar.xz";
      sha256 = "1q4yc240hzmdqg2y384cg8gfqbq0hf93fn2y8ihq02chn1iqyxp3";
      name = "kontactinterface-23.08.0.tar.xz";
    };
  };
  kontrast = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kontrast-23.08.0.tar.xz";
      sha256 = "018p2k8b332pgc0lc0jrhpajy6wdz3va77g59x6yjq16qkm3njxa";
      name = "kontrast-23.08.0.tar.xz";
    };
  };
  konversation = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/konversation-23.08.0.tar.xz";
      sha256 = "1zjl9fppl8k53i5f5fpgnnxqg7dmfh8kv0a19x9dm5wrxv4rf60x";
      name = "konversation-23.08.0.tar.xz";
    };
  };
  kopeninghours = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kopeninghours-23.08.0.tar.xz";
      sha256 = "15vx9qq93vbq9lpynmvysbqa5cdr83547mrs6zhjzz9s0xm05qy9";
      name = "kopeninghours-23.08.0.tar.xz";
    };
  };
  kopete = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kopete-23.08.0.tar.xz";
      sha256 = "13sygr3bq7ynwijcw7mjv8b9vsvhk0fsz5jzl9zlpg7z8mv9wf89";
      name = "kopete-23.08.0.tar.xz";
    };
  };
  korganizer = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/korganizer-23.08.0.tar.xz";
      sha256 = "18213j807nbmyjr2583pcmvp7mql35fgwg2ngn4la30q2b1av4l8";
      name = "korganizer-23.08.0.tar.xz";
    };
  };
  kosmindoormap = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kosmindoormap-23.08.0.tar.xz";
      sha256 = "1w9h7rbsb4dwxbbp0jx5cp1fvnzaj0bl2bqpvcyc6n2203v6dkad";
      name = "kosmindoormap-23.08.0.tar.xz";
    };
  };
  kpat = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kpat-23.08.0.tar.xz";
      sha256 = "1q7lygdzklh6gqlm0hjd4qyw6bfglaq0d04r9yqw2ihy5dyn7wcp";
      name = "kpat-23.08.0.tar.xz";
    };
  };
  kpimtextedit = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kpimtextedit-23.08.0.tar.xz";
      sha256 = "15xq92d0ximnln1yk0s4fa4byhkbbgm3m0c6f4dsjdim2x57ldk3";
      name = "kpimtextedit-23.08.0.tar.xz";
    };
  };
  kpkpass = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kpkpass-23.08.0.tar.xz";
      sha256 = "02s6gzq4qny9n5k5jcrvlpsjf6ac0wla9q24cgn52cvf85z704wp";
      name = "kpkpass-23.08.0.tar.xz";
    };
  };
  kpmcore = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kpmcore-23.08.0.tar.xz";
      sha256 = "11wkcwf8971v37pz678lcx04darh5x6pzr8qdxdgf00sfv27lcld";
      name = "kpmcore-23.08.0.tar.xz";
    };
  };
  kpublictransport = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kpublictransport-23.08.0.tar.xz";
      sha256 = "0lzjczj9lpxq00ady02xmdnclqg6sdhw08smhxa59pzj50m5qffg";
      name = "kpublictransport-23.08.0.tar.xz";
    };
  };
  kqtquickcharts = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kqtquickcharts-23.08.0.tar.xz";
      sha256 = "0x9j2xggc7rw1nqyy66qx61fksqcrmzgns90an7yrcckmgivllfl";
      name = "kqtquickcharts-23.08.0.tar.xz";
    };
  };
  krdc = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/krdc-23.08.0.tar.xz";
      sha256 = "1ii828489kijdfnc4ac5i9mj89mcq2zw8qmf965yalagxphjp3sx";
      name = "krdc-23.08.0.tar.xz";
    };
  };
  krecorder = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/krecorder-23.08.0.tar.xz";
      sha256 = "078nq5y0vrvzpqpbh10yg6p3w8g82z69xqlysc6vy8nvkcs3ghm6";
      name = "krecorder-23.08.0.tar.xz";
    };
  };
  kreversi = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kreversi-23.08.0.tar.xz";
      sha256 = "1b4i74i7fvkscxp2i8jjdm5f0rnggilcl8l75xvrjz3h06h0576s";
      name = "kreversi-23.08.0.tar.xz";
    };
  };
  krfb = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/krfb-23.08.0.tar.xz";
      sha256 = "0j5qz5yb0xvlzyy6sm3v1xk4m9h1aqb4xx0k2mxpcy4m23lhyi60";
      name = "krfb-23.08.0.tar.xz";
    };
  };
  kross-interpreters = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kross-interpreters-23.08.0.tar.xz";
      sha256 = "09dl86ll5v8k19sfg4jhvzl4g9f2ypnq6v9wiads41051bgx987h";
      name = "kross-interpreters-23.08.0.tar.xz";
    };
  };
  kruler = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kruler-23.08.0.tar.xz";
      sha256 = "010yifsv5mcg9idsvfjziy2qdfqhzna2nwpzc22kfpxc3fgcfnha";
      name = "kruler-23.08.0.tar.xz";
    };
  };
  ksanecore = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksanecore-23.08.0.tar.xz";
      sha256 = "1nmx6490yr49lm39jwh941b25y5i3p7f4j66v0zbg7mq3752ggsn";
      name = "ksanecore-23.08.0.tar.xz";
    };
  };
  kshisen = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kshisen-23.08.0.tar.xz";
      sha256 = "1p4c4k3qzs6mpf53fr7crnif0l1gs4f5licd715fbv2ral874w5n";
      name = "kshisen-23.08.0.tar.xz";
    };
  };
  ksirk = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksirk-23.08.0.tar.xz";
      sha256 = "0xrbjbbscab83vvxldbfwr3aspwfyima27a5ry65clf86r40g8fi";
      name = "ksirk-23.08.0.tar.xz";
    };
  };
  ksmtp = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksmtp-23.08.0.tar.xz";
      sha256 = "0kfl1zrbh9114bmvby387cgqd616i21hrhbbih6diklr2xk0ramr";
      name = "ksmtp-23.08.0.tar.xz";
    };
  };
  ksnakeduel = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksnakeduel-23.08.0.tar.xz";
      sha256 = "1qhplpq4ybk4zlmh92b7v5rxki4i0j7azngc2pn8awabblylhc8j";
      name = "ksnakeduel-23.08.0.tar.xz";
    };
  };
  kspaceduel = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kspaceduel-23.08.0.tar.xz";
      sha256 = "01fis8xzbslvwgk7f4mdf4rijjcdkiq2zza99d4qgn3zldjznxyw";
      name = "kspaceduel-23.08.0.tar.xz";
    };
  };
  ksquares = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksquares-23.08.0.tar.xz";
      sha256 = "1yng38zvgs91qb2w4nnmyhv8adnwq4zipqpbm4nr7ipysq7acm10";
      name = "ksquares-23.08.0.tar.xz";
    };
  };
  ksudoku = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksudoku-23.08.0.tar.xz";
      sha256 = "0cz2rjwvyg062cjx9fik75ic782i0xqcs4cvcska6m1slhv93w9m";
      name = "ksudoku-23.08.0.tar.xz";
    };
  };
  ksystemlog = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ksystemlog-23.08.0.tar.xz";
      sha256 = "0k8cncpp27l7n6s7aq3iwacf41jjskxs03204y2i877nv9xg6j3x";
      name = "ksystemlog-23.08.0.tar.xz";
    };
  };
  kteatime = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kteatime-23.08.0.tar.xz";
      sha256 = "0nw9ly0jvkl9m3fr7cgmycg28379vl2n547n9k2sh8p5va545dj1";
      name = "kteatime-23.08.0.tar.xz";
    };
  };
  ktimer = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ktimer-23.08.0.tar.xz";
      sha256 = "06dlhfxr3amrvbdrdq3k85i477i7qan913dqp577nlbf3wlblvsc";
      name = "ktimer-23.08.0.tar.xz";
    };
  };
  ktnef = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ktnef-23.08.0.tar.xz";
      sha256 = "00ybqdbz5g6392yzc725pgspx8mf4123iv7pd4x7qnfzf5by91l1";
      name = "ktnef-23.08.0.tar.xz";
    };
  };
  ktorrent = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ktorrent-23.08.0.tar.xz";
      sha256 = "048p6lir9kk1pllpgwc5nr0laywlgd5namp70h22lmiwgaymh20r";
      name = "ktorrent-23.08.0.tar.xz";
    };
  };
  ktouch = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ktouch-23.08.0.tar.xz";
      sha256 = "0y550h945fk1jfqfyc5fyd6hfi9g7awr7ag596jjrbw552xy8ynq";
      name = "ktouch-23.08.0.tar.xz";
    };
  };
  ktrip = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ktrip-23.08.0.tar.xz";
      sha256 = "1y3xkkjh8ip4mcx5y6396axbylpql1iyfz9y115r7s7n8hb1qrfp";
      name = "ktrip-23.08.0.tar.xz";
    };
  };
  ktuberling = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/ktuberling-23.08.0.tar.xz";
      sha256 = "1wc74cpvalp0xpnhsqkbqyk3gjnzmi95hqdsj4wpqj60mh78zzy7";
      name = "ktuberling-23.08.0.tar.xz";
    };
  };
  kturtle = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kturtle-23.08.0.tar.xz";
      sha256 = "064kf6apwxnv7zmpv1mal3y4i7y46rd939dfa9dk4x41d3la2mlv";
      name = "kturtle-23.08.0.tar.xz";
    };
  };
  kubrick = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kubrick-23.08.0.tar.xz";
      sha256 = "0y0h7l3mpijm08r13hlfy1dmx34kafndx0cr7vll0wb3b9xhlpqv";
      name = "kubrick-23.08.0.tar.xz";
    };
  };
  kwalletmanager = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kwalletmanager-23.08.0.tar.xz";
      sha256 = "0hf3288bhyr8864k0fm6kw77rx13fbkhxlspisl4l7algc9z5qfq";
      name = "kwalletmanager-23.08.0.tar.xz";
    };
  };
  kwave = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kwave-23.08.0.tar.xz";
      sha256 = "0a278cq9ya3cvvzllminkiw1ac8g0g5qs5ay59xh6h4mn6lxn0y4";
      name = "kwave-23.08.0.tar.xz";
    };
  };
  kweather = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kweather-23.08.0.tar.xz";
      sha256 = "00ympmljkp8xvl8gg86dbmyd5mxasg6wfx17jgyrvwh0fdq150q5";
      name = "kweather-23.08.0.tar.xz";
    };
  };
  kwordquiz = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/kwordquiz-23.08.0.tar.xz";
      sha256 = "1n7lh8xyp5w0r3d4dijsl8lnv2az6vvkbnlywbhjcs28lc1s392g";
      name = "kwordquiz-23.08.0.tar.xz";
    };
  };
  libgravatar = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libgravatar-23.08.0.tar.xz";
      sha256 = "1v8lljgawzdrfv2dcbrxkih6as67q3p2id093nxks6x3j81li223";
      name = "libgravatar-23.08.0.tar.xz";
    };
  };
  libkcddb = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkcddb-23.08.0.tar.xz";
      sha256 = "0pkiy5qfmy58s6zvss1zx837jg6nv696m2z99vyj5nshz7926gv4";
      name = "libkcddb-23.08.0.tar.xz";
    };
  };
  libkcompactdisc = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkcompactdisc-23.08.0.tar.xz";
      sha256 = "0m677c12hxd7n7vf887x8pp29i3y42kvvj9ah3rgza7qr7w5bnpf";
      name = "libkcompactdisc-23.08.0.tar.xz";
    };
  };
  libkdcraw = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkdcraw-23.08.0.tar.xz";
      sha256 = "0iyq01ql0v0vvcca2qa7vi02kby76446qja7vg6h70524pgvdjx3";
      name = "libkdcraw-23.08.0.tar.xz";
    };
  };
  libkdegames = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkdegames-23.08.0.tar.xz";
      sha256 = "12nb3gj8capcajb9s5qga3i58b57vv3fqn000wsqg3bb4l2wg6c7";
      name = "libkdegames-23.08.0.tar.xz";
    };
  };
  libkdepim = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkdepim-23.08.0.tar.xz";
      sha256 = "1vhcd0r8lqwm09i95c8x913ld4f6mqm6r83d3s67m0s0gm3zhf10";
      name = "libkdepim-23.08.0.tar.xz";
    };
  };
  libkeduvocdocument = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkeduvocdocument-23.08.0.tar.xz";
      sha256 = "0ibjacd0nqgkjfn9dhr2pibh10fzmd601lp7ycr0nafn11k8fdyn";
      name = "libkeduvocdocument-23.08.0.tar.xz";
    };
  };
  libkexiv2 = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkexiv2-23.08.0.tar.xz";
      sha256 = "0rkb7zfzn0m67fjcy5qmzz1hvwjrhf1ylk0rjddyvpyn7ndnnisy";
      name = "libkexiv2-23.08.0.tar.xz";
    };
  };
  libkgapi = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkgapi-23.08.0.tar.xz";
      sha256 = "0rnzf2g66kf7krv1ab7ipz2cgzbcd87c7rkmd67q73ia3nw8r6lp";
      name = "libkgapi-23.08.0.tar.xz";
    };
  };
  libkipi = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkipi-23.08.0.tar.xz";
      sha256 = "0bz0fhwish0ry2hxljkzj5vqv2rbapprvyv6hsvwnc9j6bzf72lj";
      name = "libkipi-23.08.0.tar.xz";
    };
  };
  libkleo = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkleo-23.08.0.tar.xz";
      sha256 = "0087mhn5h8zg696dwkpinvfjyn0scss7ggh2avm00qf1m5z8pbyc";
      name = "libkleo-23.08.0.tar.xz";
    };
  };
  libkmahjongg = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkmahjongg-23.08.0.tar.xz";
      sha256 = "1r5qwgx5qdmb0lzbw1jbid8lyms3flr51swljbv8vd0ivyj8vh88";
      name = "libkmahjongg-23.08.0.tar.xz";
    };
  };
  libkomparediff2 = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libkomparediff2-23.08.0.tar.xz";
      sha256 = "1qg5hjga7za1j2an2qgbfg1gnngz7bbimhasaabxp1dah81z7j2l";
      name = "libkomparediff2-23.08.0.tar.xz";
    };
  };
  libksane = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libksane-23.08.0.tar.xz";
      sha256 = "1q3acb4iyqqwwkhi12xiajc4094ckkrf62s463hk8xqn1z7chm9i";
      name = "libksane-23.08.0.tar.xz";
    };
  };
  libksieve = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libksieve-23.08.0.tar.xz";
      sha256 = "0yz2539lcnhsyxq997rs25dn6djwbbmc2syhkysny3ar088drwj9";
      name = "libksieve-23.08.0.tar.xz";
    };
  };
  libktorrent = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/libktorrent-23.08.0.tar.xz";
      sha256 = "1xi66zrdigxw61psg8j1y1jm2qz9acynbjdiz497gq125n6cmh0g";
      name = "libktorrent-23.08.0.tar.xz";
    };
  };
  lokalize = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/lokalize-23.08.0.tar.xz";
      sha256 = "12xhla3kcwd6qg1f2ihwzdssv922vnzmiyldbzxxbyyd51dkqwsa";
      name = "lokalize-23.08.0.tar.xz";
    };
  };
  lskat = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/lskat-23.08.0.tar.xz";
      sha256 = "11sxz0lzcc9vw1xcs5gw4as0wn9y90ibcagadq3h078awp8n2vl5";
      name = "lskat-23.08.0.tar.xz";
    };
  };
  mailcommon = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/mailcommon-23.08.0.tar.xz";
      sha256 = "0xm9qlxcjf07p086w7ajqj7ksih2v61ycajxp1qxjhjmbl5wsbd4";
      name = "mailcommon-23.08.0.tar.xz";
    };
  };
  mailimporter = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/mailimporter-23.08.0.tar.xz";
      sha256 = "00m3ibqyghxfh6bdq4h60b10snzgaijfss5dbyfqzd5a2c08070m";
      name = "mailimporter-23.08.0.tar.xz";
    };
  };
  marble = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/marble-23.08.0.tar.xz";
      sha256 = "1djvylddhpvqyr6h7kq9y215a4m5fxgdz5y9yzrsr1yf16fzj6x1";
      name = "marble-23.08.0.tar.xz";
    };
  };
  markdownpart = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/markdownpart-23.08.0.tar.xz";
      sha256 = "0ddjgvnljhng71xdv6zpi0csi6q0xigwc28fv1by70x035f0z5yn";
      name = "markdownpart-23.08.0.tar.xz";
    };
  };
  mbox-importer = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/mbox-importer-23.08.0.tar.xz";
      sha256 = "1qq945m0rmrf37rnwp8a7dqchzwwhqnrsliiqz40y6qsblzigvlj";
      name = "mbox-importer-23.08.0.tar.xz";
    };
  };
  merkuro = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/merkuro-23.08.0.tar.xz";
      sha256 = "0xrrjx592vw0qxgsna08rhsj8yhq5kmg9gl138aqhaib9x05dsia";
      name = "merkuro-23.08.0.tar.xz";
    };
  };
  messagelib = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/messagelib-23.08.0.tar.xz";
      sha256 = "1dqzsm6i0nm565xi4nhvslkmyxcsycg36x4m3jr1njwlphpg86jy";
      name = "messagelib-23.08.0.tar.xz";
    };
  };
  minuet = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/minuet-23.08.0.tar.xz";
      sha256 = "0g4a7r6av4bczd4ra18axlhdl25xpi7liq76bg863x4vkvcxwq86";
      name = "minuet-23.08.0.tar.xz";
    };
  };
  neochat = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/neochat-23.08.0.tar.xz";
      sha256 = "1ywbfmiv37bxq046l85xchryv04mqmsl0x4s49rk3r88lfgimbaf";
      name = "neochat-23.08.0.tar.xz";
    };
  };
  okular = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/okular-23.08.0.tar.xz";
      sha256 = "0f38k4jvbhlg0fyns6k128x91307sd9day3rxsc5423mz52cailv";
      name = "okular-23.08.0.tar.xz";
    };
  };
  palapeli = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/palapeli-23.08.0.tar.xz";
      sha256 = "19cxxcj2vzy7bd27lgvx1jlhchmn5dr9i3x13zhyqhq7fgash31l";
      name = "palapeli-23.08.0.tar.xz";
    };
  };
  parley = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/parley-23.08.0.tar.xz";
      sha256 = "19w4mmi0pn167mwg49k9ldd7827vs2crg3p00lvcxbiywxc3n88w";
      name = "parley-23.08.0.tar.xz";
    };
  };
  partitionmanager = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/partitionmanager-23.08.0.tar.xz";
      sha256 = "01pjka3mc0lh5s3mc8w73mjrn89yxfrzq5fyyam13dglyxcy0z3w";
      name = "partitionmanager-23.08.0.tar.xz";
    };
  };
  picmi = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/picmi-23.08.0.tar.xz";
      sha256 = "1z6rv7zi5ywsiz9l7snrw3f79m0w7pfhf5qnp7qlz5pj6k9f3b9y";
      name = "picmi-23.08.0.tar.xz";
    };
  };
  pim-data-exporter = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/pim-data-exporter-23.08.0.tar.xz";
      sha256 = "03rnrinkadvxgh4h75vs8aq4r7jf9vyhk14l4ixfzqbsxc6jllmf";
      name = "pim-data-exporter-23.08.0.tar.xz";
    };
  };
  pim-sieve-editor = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/pim-sieve-editor-23.08.0.tar.xz";
      sha256 = "1i750958l16jp8gikv0rxy4hzrl2dpfda069mr68ih4l1dndj6am";
      name = "pim-sieve-editor-23.08.0.tar.xz";
    };
  };
  pimcommon = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/pimcommon-23.08.0.tar.xz";
      sha256 = "1q14yjaa51mkc5x1dccln82cw2kdkr1g5601s0pkxfy13dnqb0dv";
      name = "pimcommon-23.08.0.tar.xz";
    };
  };
  plasmatube = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/plasmatube-23.08.0.tar.xz";
      sha256 = "1k8xzmsg34b8xjb16mlcrq9y87b3f8pwk971dvjng1b1ml425m5c";
      name = "plasmatube-23.08.0.tar.xz";
    };
  };
  poxml = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/poxml-23.08.0.tar.xz";
      sha256 = "10qn0bz0k5sdrxd0mp75ri1dafh6djdpmypkg4y6lc27q2ghfi8p";
      name = "poxml-23.08.0.tar.xz";
    };
  };
  print-manager = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/print-manager-23.08.0.tar.xz";
      sha256 = "09p4bwgqg1wzns37wig4wc5304pnab1n77zs3nv55k7kqk2b58cv";
      name = "print-manager-23.08.0.tar.xz";
    };
  };
  qmlkonsole = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/qmlkonsole-23.08.0.tar.xz";
      sha256 = "0xyzdhb0r3wilc44h7mw6bg5axw7n5pbmlq4wf1k1pjd1m910ilg";
      name = "qmlkonsole-23.08.0.tar.xz";
    };
  };
  rocs = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/rocs-23.08.0.tar.xz";
      sha256 = "15havvabqzwbqapz5lkw9wq0yl9bskya87yb0sgg3ing658i1kxq";
      name = "rocs-23.08.0.tar.xz";
    };
  };
  signon-kwallet-extension = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/signon-kwallet-extension-23.08.0.tar.xz";
      sha256 = "0hyp9mn52qh88dn9cf223nw917xxrzdfilxpjyxzpffsbdv7kf51";
      name = "signon-kwallet-extension-23.08.0.tar.xz";
    };
  };
  skanlite = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/skanlite-23.08.0.tar.xz";
      sha256 = "126l8va5kyxsa78gsj1y7d85449rwm6ccrnrpd4p9cmaxz4vld26";
      name = "skanlite-23.08.0.tar.xz";
    };
  };
  skanpage = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/skanpage-23.08.0.tar.xz";
      sha256 = "1wgjp10yp7siklqbssxq9fm0c7bqw6fihhn0q1khn5c42dr2xbh1";
      name = "skanpage-23.08.0.tar.xz";
    };
  };
  spectacle = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/spectacle-23.08.0.tar.xz";
      sha256 = "1vn1w9ywkf5f4d1i02hf3qha6647cx3nwaj5cv70rxyp71x1wfrq";
      name = "spectacle-23.08.0.tar.xz";
    };
  };
  step = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/step-23.08.0.tar.xz";
      sha256 = "138b5l79zzhi0yms4h4nimyfhkr4pnpn0p7xhhl0jhyqmgjpyyqv";
      name = "step-23.08.0.tar.xz";
    };
  };
  svgpart = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/svgpart-23.08.0.tar.xz";
      sha256 = "0ljys7hi2drz6bmk4h62d07j4jrgv6pla8aqvsxs6fckb88knsjm";
      name = "svgpart-23.08.0.tar.xz";
    };
  };
  sweeper = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/sweeper-23.08.0.tar.xz";
      sha256 = "1g3k249zf077d6w2264szih2gvhvd2p5pbx6xvxb685p7bg0kiva";
      name = "sweeper-23.08.0.tar.xz";
    };
  };
  telly-skout = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/telly-skout-23.08.0.tar.xz";
      sha256 = "1d102ldb9ycprz2x2iv7f835w4az9bi9cgsdmx2pglizi0sk7azm";
      name = "telly-skout-23.08.0.tar.xz";
    };
  };
  tokodon = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/tokodon-23.08.0.tar.xz";
      sha256 = "1dwbx6v95pmid0pl77l798kmazjh5bmwscp15wql3nvz9p1wdj2h";
      name = "tokodon-23.08.0.tar.xz";
    };
  };
  umbrello = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/umbrello-23.08.0.tar.xz";
      sha256 = "0bjaz0lig3n5vjyarydjlgc934jg35g74br5cdmn8xlmm5y73ffb";
      name = "umbrello-23.08.0.tar.xz";
    };
  };
  yakuake = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/yakuake-23.08.0.tar.xz";
      sha256 = "1q72rcwjrrjdwx9sy4w020ydgnqg4myi6icv0vr2fkfcsxr6r0q5";
      name = "yakuake-23.08.0.tar.xz";
    };
  };
  zanshin = {
    version = "23.08.0";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.08.0/src/zanshin-23.08.0.tar.xz";
      sha256 = "01w4m27pw6nrf5m8xfxwhfmvgr24jlbys9h3byfl1ddr9l6f3l6x";
      name = "zanshin-23.08.0.tar.xz";
=======
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-23.04.1.tar.xz";
      sha256 = "0khfg1pdz9kr7wyzq6n1b93v75x04nn6qz35yrx5h8ap5m384r9q";
      name = "akonadi-23.04.1.tar.xz";
    };
  };
  akonadi-calendar = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-calendar-23.04.1.tar.xz";
      sha256 = "1wblc53xv0dyaqxfqz234f47rd9fv3pfxdk4jzw07sz3vq2vc0cf";
      name = "akonadi-calendar-23.04.1.tar.xz";
    };
  };
  akonadi-calendar-tools = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-calendar-tools-23.04.1.tar.xz";
      sha256 = "1641sc6xr3pbsj47b62blz0gxqj1s1im9180jw1kd2zqsn86fpcx";
      name = "akonadi-calendar-tools-23.04.1.tar.xz";
    };
  };
  akonadi-contacts = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-contacts-23.04.1.tar.xz";
      sha256 = "02d7c9zmgrxwx1b7m8xdg64r85r1mf7yrr2qa5qv68h9fyz0df10";
      name = "akonadi-contacts-23.04.1.tar.xz";
    };
  };
  akonadi-import-wizard = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-import-wizard-23.04.1.tar.xz";
      sha256 = "1xmv75b2hj761bi891ww6dmax0xcwjbzmmkvz9w3yvw1v90a5jjm";
      name = "akonadi-import-wizard-23.04.1.tar.xz";
    };
  };
  akonadi-mime = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-mime-23.04.1.tar.xz";
      sha256 = "1yc5nk3cxc94rzjy9q70i4nrwx43lfkcp0p86akjqzkf0yp7cjyc";
      name = "akonadi-mime-23.04.1.tar.xz";
    };
  };
  akonadi-notes = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-notes-23.04.1.tar.xz";
      sha256 = "0f0qp7a93bvnfzjnfsz2r0jl794kb4wbdgmzwyd7k4a64s2pzlj4";
      name = "akonadi-notes-23.04.1.tar.xz";
    };
  };
  akonadi-search = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadi-search-23.04.1.tar.xz";
      sha256 = "0lcwshcgy0mnq75kcf172sdniq0smjzqy46icqh7dfd98p9rwd68";
      name = "akonadi-search-23.04.1.tar.xz";
    };
  };
  akonadiconsole = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akonadiconsole-23.04.1.tar.xz";
      sha256 = "1zy7lzha0fnj307h2im42lyp916cpb1nd1ixlag2n16zx01ibg6y";
      name = "akonadiconsole-23.04.1.tar.xz";
    };
  };
  akregator = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/akregator-23.04.1.tar.xz";
      sha256 = "1m86sk5wjffyvzqzb86c7bvj6v7glmpkib4dvwrv6dyf80jgb9fl";
      name = "akregator-23.04.1.tar.xz";
    };
  };
  alligator = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/alligator-23.04.1.tar.xz";
      sha256 = "08mc0kdkgkff7ksvwjrmy7h571qy0r48i7hi256z6yysvn31mj3h";
      name = "alligator-23.04.1.tar.xz";
    };
  };
  analitza = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/analitza-23.04.1.tar.xz";
      sha256 = "1c3liydmpwr64d1iv7m3mrq7v4xkcvl5w60mhw4z2mpzs0pqncpr";
      name = "analitza-23.04.1.tar.xz";
    };
  };
  angelfish = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/angelfish-23.04.1.tar.xz";
      sha256 = "1x5fqa6i0043lyhh1pz34qmk8dnck43g0ikqcxwa0w4z279fdk46";
      name = "angelfish-23.04.1.tar.xz";
    };
  };
  ark = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ark-23.04.1.tar.xz";
      sha256 = "1d154gqnkg1rvmcwzzdcs3fca6al3rx5qjaqpy638cv7nafijlj8";
      name = "ark-23.04.1.tar.xz";
    };
  };
  artikulate = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/artikulate-23.04.1.tar.xz";
      sha256 = "1gwgywam39bzfcnrc2z4q4j0flilzhjvb6lm6aanx6zjhfhqr4ni";
      name = "artikulate-23.04.1.tar.xz";
    };
  };
  audiocd-kio = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/audiocd-kio-23.04.1.tar.xz";
      sha256 = "1ipkc5dajk9qbjf1awk9dgs5hqibbnhkzja9n4z66g5zslhhwa6n";
      name = "audiocd-kio-23.04.1.tar.xz";
    };
  };
  audiotube = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/audiotube-23.04.1.tar.xz";
      sha256 = "0plvvia88ac1kfp9rmlgpcviknfvymk4v61455pxd0pzn768iik0";
      name = "audiotube-23.04.1.tar.xz";
    };
  };
  baloo-widgets = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/baloo-widgets-23.04.1.tar.xz";
      sha256 = "0iypxszifvy2agqk0mv9w7ss7fm8dpqjaw65ckqpgfj6lyf1wih0";
      name = "baloo-widgets-23.04.1.tar.xz";
    };
  };
  blinken = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/blinken-23.04.1.tar.xz";
      sha256 = "1h86w9ds9dzkj9blx0ksrcyrnj8rwljdk25gw8fgxjp9xim2k370";
      name = "blinken-23.04.1.tar.xz";
    };
  };
  bomber = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/bomber-23.04.1.tar.xz";
      sha256 = "0z5fiqz6fr6pkxnck0q8xsmd66cd5a5s8967gy47xh88i4w75iq3";
      name = "bomber-23.04.1.tar.xz";
    };
  };
  bovo = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/bovo-23.04.1.tar.xz";
      sha256 = "0a3ixz5c1rlndxfmickpb3wmg8m25hnxina8h9mvbbp11zx5694v";
      name = "bovo-23.04.1.tar.xz";
    };
  };
  calendarsupport = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/calendarsupport-23.04.1.tar.xz";
      sha256 = "1h4m85fk5kah2nn91irs35nmf3zmgfq99ql3q7qzcbcbnyci0a12";
      name = "calendarsupport-23.04.1.tar.xz";
    };
  };
  calindori = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/calindori-23.04.1.tar.xz";
      sha256 = "1ki06m1l0vrszsk4dqfsx7g97id4wjk1ak5n8xpkr0kny82zkqjs";
      name = "calindori-23.04.1.tar.xz";
    };
  };
  cantor = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/cantor-23.04.1.tar.xz";
      sha256 = "0m7c2lhwyl6p4ajcy4lmv5wqqy6p3xn2phdav12qb953k5y0nh63";
      name = "cantor-23.04.1.tar.xz";
    };
  };
  cervisia = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/cervisia-23.04.1.tar.xz";
      sha256 = "1q3266ql16krhm46y729kn8m67i336bknyi54b8ax9n00pgsrsh7";
      name = "cervisia-23.04.1.tar.xz";
    };
  };
  colord-kde = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/colord-kde-23.04.1.tar.xz";
      sha256 = "03va1w2gdh42jnwpscb7660lmgxgpc913bz3kincpp0gzq269siw";
      name = "colord-kde-23.04.1.tar.xz";
    };
  };
  dolphin = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/dolphin-23.04.1.tar.xz";
      sha256 = "1p856qfjfpaz6fxb8d0lvn4sd0qz6v558rkikq2glbfn0vxx04rq";
      name = "dolphin-23.04.1.tar.xz";
    };
  };
  dolphin-plugins = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/dolphin-plugins-23.04.1.tar.xz";
      sha256 = "1dfx7k82xh9wa5y6rv0i956nr1nz9rnwpjxgr8vxmg6h51fn08jr";
      name = "dolphin-plugins-23.04.1.tar.xz";
    };
  };
  dragon = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/dragon-23.04.1.tar.xz";
      sha256 = "1xn8mxqkm56dx9qizphvkd0xjg9xjbkhqpn50x26yvym6gsmz93w";
      name = "dragon-23.04.1.tar.xz";
    };
  };
  elisa = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/elisa-23.04.1.tar.xz";
      sha256 = "0fjkb057zm23rafv5zv0faj73538dm8ldq78rdxg3nm4hf72kaq3";
      name = "elisa-23.04.1.tar.xz";
    };
  };
  eventviews = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/eventviews-23.04.1.tar.xz";
      sha256 = "04i24i2d95gmjhar5r8zpyff02615s2rvz2z5688d1lwjfdhkxnj";
      name = "eventviews-23.04.1.tar.xz";
    };
  };
  falkon = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/falkon-23.04.1.tar.xz";
      sha256 = "00lz04vr54yj35r0q12j4kdp1xayzqfyi3lsjplhmybd9lic0sy5";
      name = "falkon-23.04.1.tar.xz";
    };
  };
  ffmpegthumbs = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ffmpegthumbs-23.04.1.tar.xz";
      sha256 = "0bza8md28d5gy0ykibr0zfhgq6fpkparb0z2axp40s1vk6h769fq";
      name = "ffmpegthumbs-23.04.1.tar.xz";
    };
  };
  filelight = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/filelight-23.04.1.tar.xz";
      sha256 = "0j73bbhqgy8ahjqy9pm0haqxalfpcb0w09kghvsyjvrxf7d0kh3q";
      name = "filelight-23.04.1.tar.xz";
    };
  };
  ghostwriter = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ghostwriter-23.04.1.tar.xz";
      sha256 = "0b4gpkh8k57fr8yawlcl5v1bbpfhbwkgk7cn747h3q54lfkq4wdc";
      name = "ghostwriter-23.04.1.tar.xz";
    };
  };
  granatier = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/granatier-23.04.1.tar.xz";
      sha256 = "1r1vn88kkcrbjd8h81zwpwgxms8pxz8rcqdjv485yaa69lrph97h";
      name = "granatier-23.04.1.tar.xz";
    };
  };
  grantlee-editor = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/grantlee-editor-23.04.1.tar.xz";
      sha256 = "0gykv9mf4z5kam03chwmhja58zm09w4fk7kk447bk9ssdn0psiaq";
      name = "grantlee-editor-23.04.1.tar.xz";
    };
  };
  grantleetheme = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/grantleetheme-23.04.1.tar.xz";
      sha256 = "1qg11pq5gaw896si8hka0lpqq0a29xhhs6n7scav8mrb725rd2mz";
      name = "grantleetheme-23.04.1.tar.xz";
    };
  };
  gwenview = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/gwenview-23.04.1.tar.xz";
      sha256 = "1mdhr3z10lhscpd7d4bs1vy2ibvp78323ll5ijhsl3pjk5cp875i";
      name = "gwenview-23.04.1.tar.xz";
    };
  };
  incidenceeditor = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/incidenceeditor-23.04.1.tar.xz";
      sha256 = "1l0ipc4vdyri1c72ybmcind6vcsm8gmwsy0s4mh8xgqs52m0w94z";
      name = "incidenceeditor-23.04.1.tar.xz";
    };
  };
  itinerary = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/itinerary-23.04.1.tar.xz";
      sha256 = "1l0ab5vc9780fc5mk8sk44ryhd6mj8f314x262mgm5b9y5283wj9";
      name = "itinerary-23.04.1.tar.xz";
    };
  };
  juk = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/juk-23.04.1.tar.xz";
      sha256 = "1z38kf7jiwm19qzi662q5l23g86afq61wyvjlfawny851iqxb283";
      name = "juk-23.04.1.tar.xz";
    };
  };
  k3b = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/k3b-23.04.1.tar.xz";
      sha256 = "0s4rbcvqrpjni03nd3njldsyhpvg5pypryjc9blqmr3id5fnkw9q";
      name = "k3b-23.04.1.tar.xz";
    };
  };
  kaccounts-integration = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kaccounts-integration-23.04.1.tar.xz";
      sha256 = "0lhfqcqvnw6vaszd1iyifljxx4fzwgikrhpwgavgx4nlkrrc9p05";
      name = "kaccounts-integration-23.04.1.tar.xz";
    };
  };
  kaccounts-providers = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kaccounts-providers-23.04.1.tar.xz";
      sha256 = "1vrzd924fl9sdr3kyr88mhr5dsk8avjg00h6jvq91cxl8n94r6wn";
      name = "kaccounts-providers-23.04.1.tar.xz";
    };
  };
  kaddressbook = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kaddressbook-23.04.1.tar.xz";
      sha256 = "1qmzz94q17ljrqm6qmm7jvgbi5ipw4y5s84cya4c2gw78yc0f323";
      name = "kaddressbook-23.04.1.tar.xz";
    };
  };
  kajongg = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kajongg-23.04.1.tar.xz";
      sha256 = "1jpigjsy4k59kyvmn65qkcv2h5j3jrijjiv7ikxpmpj6fa4babvq";
      name = "kajongg-23.04.1.tar.xz";
    };
  };
  kalarm = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kalarm-23.04.1.tar.xz";
      sha256 = "1skziiw85jizg5k1l0b0hq3l8kcasqmz1b7yi1zmw3n9jj36n11k";
      name = "kalarm-23.04.1.tar.xz";
    };
  };
  kalendar = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kalendar-23.04.1.tar.xz";
      sha256 = "1c5afrmfaci03wzrxv60mwsapcdn17sxqhhp07hfcv5xa6p7cf3p";
      name = "kalendar-23.04.1.tar.xz";
    };
  };
  kalgebra = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kalgebra-23.04.1.tar.xz";
      sha256 = "0661g7nyv7hmjdmhf2xmslsx5iw7361ih7bavd9w22kpms18nqa6";
      name = "kalgebra-23.04.1.tar.xz";
    };
  };
  kalk = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kalk-23.04.1.tar.xz";
      sha256 = "19lwd1q92h8km1fijgz4xk4vy57zaviylbhr5raxlp8ibfasnj4p";
      name = "kalk-23.04.1.tar.xz";
    };
  };
  kalzium = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kalzium-23.04.1.tar.xz";
      sha256 = "1s8vifs56viiyghc7kvlmbjznwf9brq0q20qjavy9aiq4hnkffc3";
      name = "kalzium-23.04.1.tar.xz";
    };
  };
  kamera = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kamera-23.04.1.tar.xz";
      sha256 = "1z2sdh03hv22rva6v9csm3x54vajlg1p70r8y24fzj75hg83jlwa";
      name = "kamera-23.04.1.tar.xz";
    };
  };
  kamoso = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kamoso-23.04.1.tar.xz";
      sha256 = "06hwnashqnq6zag4ymwfk3ll3f7j7xxjqgqpvrvfxfag7fnzgar3";
      name = "kamoso-23.04.1.tar.xz";
    };
  };
  kanagram = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kanagram-23.04.1.tar.xz";
      sha256 = "0w830lhqpmi86n37gkg53j57l1ybwrgknginnyd19qlkajxx8v6d";
      name = "kanagram-23.04.1.tar.xz";
    };
  };
  kapman = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kapman-23.04.1.tar.xz";
      sha256 = "1w2hfd1g1mncwzv3xmgl48flcpp2g42vw9r57rdncrslipincqm6";
      name = "kapman-23.04.1.tar.xz";
    };
  };
  kapptemplate = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kapptemplate-23.04.1.tar.xz";
      sha256 = "1as8nwpxfcaz4sf8l6mb4bbns1m2qja4aqvkplzz1avwhq3pw4p0";
      name = "kapptemplate-23.04.1.tar.xz";
    };
  };
  kasts = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kasts-23.04.1.tar.xz";
      sha256 = "0ih7mjgbvf8z68sn6ifnhdrmaccsgr9gff61901xwl14rpkqy46m";
      name = "kasts-23.04.1.tar.xz";
    };
  };
  kate = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kate-23.04.1.tar.xz";
      sha256 = "1w0piqxrbmcxpzga5gqiii2a03dqd58a8wac0vj40s3hx47lnf2w";
      name = "kate-23.04.1.tar.xz";
    };
  };
  katomic = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/katomic-23.04.1.tar.xz";
      sha256 = "1a639yq1v2glhjmdcwb79mr36pdc12mjfraxzm1lijb8wz0pbxjz";
      name = "katomic-23.04.1.tar.xz";
    };
  };
  kbackup = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kbackup-23.04.1.tar.xz";
      sha256 = "08zb8hj5b1m0kvx82nz9dsaxzv6a1l7r3fhgbpbyzlrdlhlz79n8";
      name = "kbackup-23.04.1.tar.xz";
    };
  };
  kblackbox = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kblackbox-23.04.1.tar.xz";
      sha256 = "0n98wisc0qz7jz7jx5vi20wjap5zxb119ppyfhvwv80z8z3ilcp4";
      name = "kblackbox-23.04.1.tar.xz";
    };
  };
  kblocks = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kblocks-23.04.1.tar.xz";
      sha256 = "10555jr2vgp3vgib1088w5sc2nv4wsfd986xylrgpd60gqkqz15k";
      name = "kblocks-23.04.1.tar.xz";
    };
  };
  kbounce = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kbounce-23.04.1.tar.xz";
      sha256 = "0mj4jl69xf51y3rvz6w1srqk9v3ykbqfyk15aiavpaj9zlqwy7nv";
      name = "kbounce-23.04.1.tar.xz";
    };
  };
  kbreakout = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kbreakout-23.04.1.tar.xz";
      sha256 = "158h4j5jfadm5j15a56hh430idds5ys1mmsnwih7d848xd7migks";
      name = "kbreakout-23.04.1.tar.xz";
    };
  };
  kbruch = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kbruch-23.04.1.tar.xz";
      sha256 = "1vdw66qxn1q93w9ji5qiyl26ixdwc1pfvrr94jzblyyh4n7ynp5j";
      name = "kbruch-23.04.1.tar.xz";
    };
  };
  kcachegrind = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kcachegrind-23.04.1.tar.xz";
      sha256 = "1sklcai026ai8kqrmw6zf442zflsc8zkrcmylfibzwcvn6gngm4i";
      name = "kcachegrind-23.04.1.tar.xz";
    };
  };
  kcalc = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kcalc-23.04.1.tar.xz";
      sha256 = "0crnh0b9zksflrywjnq6ch7qbmch6nqwdiy5ixkhv89pbrmkajly";
      name = "kcalc-23.04.1.tar.xz";
    };
  };
  kcalutils = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kcalutils-23.04.1.tar.xz";
      sha256 = "0bf09sdfxp6k538086yfqg9c9093jszqnwv56d67gqa2w6wi5by6";
      name = "kcalutils-23.04.1.tar.xz";
    };
  };
  kcharselect = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kcharselect-23.04.1.tar.xz";
      sha256 = "00p19r9ybbdbg7mj9jldjb003p1hv2v60xkpsy2r33q68sqjmgj2";
      name = "kcharselect-23.04.1.tar.xz";
    };
  };
  kclock = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kclock-23.04.1.tar.xz";
      sha256 = "0sxs434slvkc93n46n7sgmcahf5yr2ci00v5wj6hfmqwbkb8c795";
      name = "kclock-23.04.1.tar.xz";
    };
  };
  kcolorchooser = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kcolorchooser-23.04.1.tar.xz";
      sha256 = "0agk945vmp0b7ywlyhrcjszspipr8j0s93pr5p8kvyw1ldl3z6pz";
      name = "kcolorchooser-23.04.1.tar.xz";
    };
  };
  kcron = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kcron-23.04.1.tar.xz";
      sha256 = "0nazn3656nqwlk6gzqvl5bhfxilqd0xa8mg2xwx8kn9lm7jn79i0";
      name = "kcron-23.04.1.tar.xz";
    };
  };
  kde-dev-scripts = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kde-dev-scripts-23.04.1.tar.xz";
      sha256 = "01p5dc55ap54gfz6p7q579pz0sbcmr6xqc41dr1dc46fy4wrd9in";
      name = "kde-dev-scripts-23.04.1.tar.xz";
    };
  };
  kde-dev-utils = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kde-dev-utils-23.04.1.tar.xz";
      sha256 = "06a8avax50lb8y65jsbfk6bmnby6cihswfx3g8jkq2k6jw8ksa81";
      name = "kde-dev-utils-23.04.1.tar.xz";
    };
  };
  kde-inotify-survey = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kde-inotify-survey-23.04.1.tar.xz";
      sha256 = "1m5x2v8b2wr74bmcga27dc51r3n8r4j27zc0z9nvgbm9baj902qf";
      name = "kde-inotify-survey-23.04.1.tar.xz";
    };
  };
  kdebugsettings = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdebugsettings-23.04.1.tar.xz";
      sha256 = "18pqzrjp8yi874v5arkbr9rw0bg72mh54mlzinyyrjplrv783ihr";
      name = "kdebugsettings-23.04.1.tar.xz";
    };
  };
  kdeconnect-kde = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdeconnect-kde-23.04.1.tar.xz";
      sha256 = "1i09gnbq74y1c7qcqgjzpa5ns4zai7wxsxggikz6ak58pvh382q7";
      name = "kdeconnect-kde-23.04.1.tar.xz";
    };
  };
  kdeedu-data = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdeedu-data-23.04.1.tar.xz";
      sha256 = "17n33lbq1hw6dhrwlwv82a3wynz0g8asza16xi398bayavjlsndg";
      name = "kdeedu-data-23.04.1.tar.xz";
    };
  };
  kdegraphics-mobipocket = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdegraphics-mobipocket-23.04.1.tar.xz";
      sha256 = "0hb9rhibh093gff3df58c6xwqd4s35rn75mqxmz3jikwnszsgpa8";
      name = "kdegraphics-mobipocket-23.04.1.tar.xz";
    };
  };
  kdegraphics-thumbnailers = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdegraphics-thumbnailers-23.04.1.tar.xz";
      sha256 = "1bp3dgg3kjhksnrjvp6i3nm73fkldn6j0fqa99s8zfbavdyx64a5";
      name = "kdegraphics-thumbnailers-23.04.1.tar.xz";
    };
  };
  kdenetwork-filesharing = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdenetwork-filesharing-23.04.1.tar.xz";
      sha256 = "1hggmk79k1mfsf7l3sx05dh7iahdlfsgq6spidkl026ngmd21nwi";
      name = "kdenetwork-filesharing-23.04.1.tar.xz";
    };
  };
  kdenlive = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdenlive-23.04.1.tar.xz";
      sha256 = "0jyhwyc1f2fnh2jn0hvhniav87mrda2y2zni1mlm1s0p038g2z4m";
      name = "kdenlive-23.04.1.tar.xz";
    };
  };
  kdepim-addons = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdepim-addons-23.04.1.tar.xz";
      sha256 = "0k0hsj9a234hcy66ppj4alfdn4hnfsd4gfqj2533hh5jkkkki39d";
      name = "kdepim-addons-23.04.1.tar.xz";
    };
  };
  kdepim-runtime = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdepim-runtime-23.04.1.tar.xz";
      sha256 = "0wws45pi3n45jq67svmhwfxqqlr640dmya7jg83md08vsgvg1svl";
      name = "kdepim-runtime-23.04.1.tar.xz";
    };
  };
  kdesdk-kio = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdesdk-kio-23.04.1.tar.xz";
      sha256 = "1qrffia117vrrb4fpg5s39yjdfjjz6iyjybrr2hh8pc9w10q6rkp";
      name = "kdesdk-kio-23.04.1.tar.xz";
    };
  };
  kdesdk-thumbnailers = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdesdk-thumbnailers-23.04.1.tar.xz";
      sha256 = "18p5h0nmpj1ip8ccfm6hajs3b992ara6k1g0dh1wx14hcd1cxvib";
      name = "kdesdk-thumbnailers-23.04.1.tar.xz";
    };
  };
  kdev-php = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdev-php-23.04.1.tar.xz";
      sha256 = "1v4zkzsm9ikq1x3z90mc24243aqjmfr7gmnnbj1warvagm26fv5x";
      name = "kdev-php-23.04.1.tar.xz";
    };
  };
  kdev-python = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdev-python-23.04.1.tar.xz";
      sha256 = "0kn8bdb6sgcgp48rm1sgzbjrhvr6kiy4jpckp3qmrlnijl6hkl18";
      name = "kdev-python-23.04.1.tar.xz";
    };
  };
  kdevelop = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdevelop-23.04.1.tar.xz";
      sha256 = "15rjcp9yzzh1ls8bzylcvy25rl38zbxv3dckvhyl9njg4sqdklv3";
      name = "kdevelop-23.04.1.tar.xz";
    };
  };
  kdf = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdf-23.04.1.tar.xz";
      sha256 = "1b43izzasbw4nmin314ayrbs0cl0ha1mbmc8hp0vjiic7m33i679";
      name = "kdf-23.04.1.tar.xz";
    };
  };
  kdialog = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdialog-23.04.1.tar.xz";
      sha256 = "0gypmx95df4xdshdlfvcaxhrryf41kym1aq1jrvg3grkmqdyxmw8";
      name = "kdialog-23.04.1.tar.xz";
    };
  };
  kdiamond = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kdiamond-23.04.1.tar.xz";
      sha256 = "021m71m1vfkmy93kj5pg8q8yxwicgfxqsbvdw5r8g1igmd54db82";
      name = "kdiamond-23.04.1.tar.xz";
    };
  };
  keditbookmarks = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/keditbookmarks-23.04.1.tar.xz";
      sha256 = "0cc2fnin1i70ldhl6g2xv36n80s02dl99ga18ykhx4dx4c37q26d";
      name = "keditbookmarks-23.04.1.tar.xz";
    };
  };
  keysmith = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/keysmith-23.04.1.tar.xz";
      sha256 = "06qmp1qgv5axaf3fc5ir5yfpjxpdv0aqd5p78pwsqn3k2h3262cf";
      name = "keysmith-23.04.1.tar.xz";
    };
  };
  kfind = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kfind-23.04.1.tar.xz";
      sha256 = "07ar25hk4ah29ljq3q3mdbxmqiks80z9yjq5hc6fbjw6yy3gbzb1";
      name = "kfind-23.04.1.tar.xz";
    };
  };
  kfloppy = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kfloppy-23.04.1.tar.xz";
      sha256 = "0cydxyfj6nz4mm9qq9igx542dr3z37mzl0hw7l35sdryr8j9qhif";
      name = "kfloppy-23.04.1.tar.xz";
    };
  };
  kfourinline = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kfourinline-23.04.1.tar.xz";
      sha256 = "0wdsxklk9ijwma81h89n0sgzgcg6sbbm33d3ylq9gvjfzbzm5857";
      name = "kfourinline-23.04.1.tar.xz";
    };
  };
  kgeography = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kgeography-23.04.1.tar.xz";
      sha256 = "10fngaassp6z9v14zmcl757lq77nrr51ax09sa3g0fihgdv5nwf5";
      name = "kgeography-23.04.1.tar.xz";
    };
  };
  kget = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kget-23.04.1.tar.xz";
      sha256 = "0vmns0z3319di8ymjl1cswl99kaym8rbsdc2hvzf0mwkhkj987vq";
      name = "kget-23.04.1.tar.xz";
    };
  };
  kgoldrunner = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kgoldrunner-23.04.1.tar.xz";
      sha256 = "14xzqlx5v7r47mkrf8c23aa4lldqs6zi4xyfh97hy2v0n7kxlc5n";
      name = "kgoldrunner-23.04.1.tar.xz";
    };
  };
  kgpg = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kgpg-23.04.1.tar.xz";
      sha256 = "02k8x8q8s77yz2f54b9zag0nvi5c2xkjk70nvblg45rn01sqj03i";
      name = "kgpg-23.04.1.tar.xz";
    };
  };
  khangman = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/khangman-23.04.1.tar.xz";
      sha256 = "1ir693gr8606p3hj4a81f0pzs98k3hdxwhh6pmq8hprvwl2rpdgj";
      name = "khangman-23.04.1.tar.xz";
    };
  };
  khelpcenter = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/khelpcenter-23.04.1.tar.xz";
      sha256 = "15f8d55jx9xvxg46z5z6lq913c8afz6djy6vv0hqa5fqzkjw23gz";
      name = "khelpcenter-23.04.1.tar.xz";
    };
  };
  kidentitymanagement = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kidentitymanagement-23.04.1.tar.xz";
      sha256 = "0fp2316b26hhhc5y92h08kqcdnmg46h885mcimv4nmk3dq3sirp4";
      name = "kidentitymanagement-23.04.1.tar.xz";
    };
  };
  kig = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kig-23.04.1.tar.xz";
      sha256 = "0m30zvcmx3ay9ac0zypfzsq95dasam58lipxb3y7wisrf3qpgvqf";
      name = "kig-23.04.1.tar.xz";
    };
  };
  kigo = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kigo-23.04.1.tar.xz";
      sha256 = "1kk05hzvgp2bzlqkc92kigr21yxl908pys17dmjpll5rriprfrmc";
      name = "kigo-23.04.1.tar.xz";
    };
  };
  killbots = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/killbots-23.04.1.tar.xz";
      sha256 = "0c3lqyw919gpihvx4k9irn4c1kin08glqpqwqkgy34vafyp0661b";
      name = "killbots-23.04.1.tar.xz";
    };
  };
  kimagemapeditor = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kimagemapeditor-23.04.1.tar.xz";
      sha256 = "0dnd2dsisid19jq36nh57a508m6208z4s14ij50y760pd80ikzqq";
      name = "kimagemapeditor-23.04.1.tar.xz";
    };
  };
  kimap = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kimap-23.04.1.tar.xz";
      sha256 = "0rhnhh7wdzai81xic1fx2jk8mcb3n9mmlrxv2hin3zrn7a6v2qh5";
      name = "kimap-23.04.1.tar.xz";
    };
  };
  kio-admin = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kio-admin-23.04.1.tar.xz";
      sha256 = "15bcl2idcd42sbhj5w1dp4z3p205y1d8x9z3rbwsbgaxzdr3hv6x";
      name = "kio-admin-23.04.1.tar.xz";
    };
  };
  kio-extras = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kio-extras-23.04.1.tar.xz";
      sha256 = "1n9a33zma7n5sljwmb7jfgl5xwq5k6773x17bjw6fmx9z626nw6q";
      name = "kio-extras-23.04.1.tar.xz";
    };
  };
  kio-gdrive = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kio-gdrive-23.04.1.tar.xz";
      sha256 = "0019bw8bhm9h787q87lhjw6b8bib7p59cww16d7ibiixkrmzkcx9";
      name = "kio-gdrive-23.04.1.tar.xz";
    };
  };
  kio-zeroconf = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kio-zeroconf-23.04.1.tar.xz";
      sha256 = "0i5mvm2ps28jn395ldjj8ff36nybvlzwkximrjbwh5ydy9y4psf6";
      name = "kio-zeroconf-23.04.1.tar.xz";
    };
  };
  kipi-plugins = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kipi-plugins-23.04.1.tar.xz";
      sha256 = "1alqjm95xsd0413icrgkg33wm9gvwvnrv8qpmpw999dyaa6fkfm1";
      name = "kipi-plugins-23.04.1.tar.xz";
    };
  };
  kirigami-gallery = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kirigami-gallery-23.04.1.tar.xz";
      sha256 = "06x6zv87qvcw71a8vfan5v663s9g68y6gpck6a9hij5dyvvdbv6x";
      name = "kirigami-gallery-23.04.1.tar.xz";
    };
  };
  kiriki = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kiriki-23.04.1.tar.xz";
      sha256 = "1ldpmpvkrapwxhky274hr6liycgm06izr96adgv1xizal704p79m";
      name = "kiriki-23.04.1.tar.xz";
    };
  };
  kiten = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kiten-23.04.1.tar.xz";
      sha256 = "12cfm6nxdrwyvms66lmxmz2l60ipbr1x48hapiyvmyyipcz5vwqa";
      name = "kiten-23.04.1.tar.xz";
    };
  };
  kitinerary = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kitinerary-23.04.1.tar.xz";
      sha256 = "0gr53w1jzrlyjllfg6d0bv0x7g3d2fvqgsgbnhnfafm9ipmapmpz";
      name = "kitinerary-23.04.1.tar.xz";
    };
  };
  kjournald = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kjournald-23.04.1.tar.xz";
      sha256 = "0mkrnflkavbsr0kk1chnkd3y91fp49s6dd518akmgsic24ggsayb";
      name = "kjournald-23.04.1.tar.xz";
    };
  };
  kjumpingcube = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kjumpingcube-23.04.1.tar.xz";
      sha256 = "07prv17v8p9cxl0akq5gd8g6ld4mypdij91cqd3gd18kmm97wmqv";
      name = "kjumpingcube-23.04.1.tar.xz";
    };
  };
  kldap = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kldap-23.04.1.tar.xz";
      sha256 = "1kk4mg9z1b9mg8h0zipma6l7apya2yg64ng3ki8xm3lr7w165200";
      name = "kldap-23.04.1.tar.xz";
    };
  };
  kleopatra = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kleopatra-23.04.1.tar.xz";
      sha256 = "0agqn8pylc4n62hxxfl8r8imr25n2wbxg29msn3k0yk0fnjsj2gc";
      name = "kleopatra-23.04.1.tar.xz";
    };
  };
  klettres = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/klettres-23.04.1.tar.xz";
      sha256 = "06618wznl891gbvjwz4gj3y2bgvqb7px46zka8yn70ripdzcdsyx";
      name = "klettres-23.04.1.tar.xz";
    };
  };
  klickety = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/klickety-23.04.1.tar.xz";
      sha256 = "1vc8vp29gg8g57dpy0mg2l0g8sx21v8v4mpmyrndvd7azm268xjv";
      name = "klickety-23.04.1.tar.xz";
    };
  };
  klines = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/klines-23.04.1.tar.xz";
      sha256 = "0sxm5nmq7inwbc40zi5lwc5i5ykh33l5lyjljd5vcs26av00yplp";
      name = "klines-23.04.1.tar.xz";
    };
  };
  kmag = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmag-23.04.1.tar.xz";
      sha256 = "16aazm0czvqbq20jdkxrpizl9yipd0jhaghrqrgps35vkrvksy08";
      name = "kmag-23.04.1.tar.xz";
    };
  };
  kmahjongg = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmahjongg-23.04.1.tar.xz";
      sha256 = "00ihfbvf0k5ralkykj8522nhmd7kyr0n47xpdx77f19w9wf464rw";
      name = "kmahjongg-23.04.1.tar.xz";
    };
  };
  kmail = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmail-23.04.1.tar.xz";
      sha256 = "0bwrlh5i5zxgqji0fk41r59r67aw7nppv1ypk8dkg2k1hmiqgckg";
      name = "kmail-23.04.1.tar.xz";
    };
  };
  kmail-account-wizard = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmail-account-wizard-23.04.1.tar.xz";
      sha256 = "1g46wpxy2d7s5y38y5vfy71bwrscgr675wbyj040qaqs5jn5wh1y";
      name = "kmail-account-wizard-23.04.1.tar.xz";
    };
  };
  kmailtransport = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmailtransport-23.04.1.tar.xz";
      sha256 = "0c6qlaxcmj5iyyvz8zw5829pp81jamfg2rpsp7pgzclwd5p9ry3j";
      name = "kmailtransport-23.04.1.tar.xz";
    };
  };
  kmbox = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmbox-23.04.1.tar.xz";
      sha256 = "0cml2bm1k18lnhf92x755xn9pbxgy4z7nr0gqqf8zxjym3p3169j";
      name = "kmbox-23.04.1.tar.xz";
    };
  };
  kmime = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmime-23.04.1.tar.xz";
      sha256 = "1mmvzl8w9jkxga7mlj3c3qzmcj3v152bc5rqd9va2bp1lyxvivx0";
      name = "kmime-23.04.1.tar.xz";
    };
  };
  kmines = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmines-23.04.1.tar.xz";
      sha256 = "0m1k4nh9wh9qd5xirvv0af5z4fl9klp2j2q2wsr6cxymczlspz9a";
      name = "kmines-23.04.1.tar.xz";
    };
  };
  kmix = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmix-23.04.1.tar.xz";
      sha256 = "1paln4yynbk97jwld88cdqa6wj3alqqvs1c49c0n2mscnl691j4j";
      name = "kmix-23.04.1.tar.xz";
    };
  };
  kmousetool = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmousetool-23.04.1.tar.xz";
      sha256 = "1qxbazh14i2w6ll1c980b7qsfj1ls5lj7hjdd0krzxskf999q23a";
      name = "kmousetool-23.04.1.tar.xz";
    };
  };
  kmouth = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmouth-23.04.1.tar.xz";
      sha256 = "03ppsfac560az572mv5y18bkfxbbaa6nxrssc5l982fjvc3xngw6";
      name = "kmouth-23.04.1.tar.xz";
    };
  };
  kmplot = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kmplot-23.04.1.tar.xz";
      sha256 = "1y3kyd02ksm6hjpyzal5nq4sj8yipnrp0hfdfhqlv79xyyjk200s";
      name = "kmplot-23.04.1.tar.xz";
    };
  };
  knavalbattle = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/knavalbattle-23.04.1.tar.xz";
      sha256 = "10h6jhrk676fq7v178hsqmk5yq5sbppm69bh27n2915abm9w5ssd";
      name = "knavalbattle-23.04.1.tar.xz";
    };
  };
  knetwalk = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/knetwalk-23.04.1.tar.xz";
      sha256 = "1vr9cgp6pm344s7syhxdyl9pgjkyh9h5nh8dsk8mbqs5gbnn3dds";
      name = "knetwalk-23.04.1.tar.xz";
    };
  };
  knights = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/knights-23.04.1.tar.xz";
      sha256 = "0yng5vr3g6lalpjkfaxwrihn9x8vs78n6firbvw2hmjlvj4ycybg";
      name = "knights-23.04.1.tar.xz";
    };
  };
  knotes = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/knotes-23.04.1.tar.xz";
      sha256 = "0r30qln0hdib5sd6x8qy3r1fn2im55wnim07zvp5wy9a4pynwzzl";
      name = "knotes-23.04.1.tar.xz";
    };
  };
  koko = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/koko-23.04.1.tar.xz";
      sha256 = "0vdhrw5b20zcp3d83wvk9mcvn04c45v4hpirm01kw5yx998ak9gp";
      name = "koko-23.04.1.tar.xz";
    };
  };
  kolf = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kolf-23.04.1.tar.xz";
      sha256 = "1cknqhlrnqv4wq1kz6sv5r4xsxk5ndi2izajifixi4n75dq135ad";
      name = "kolf-23.04.1.tar.xz";
    };
  };
  kollision = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kollision-23.04.1.tar.xz";
      sha256 = "0ay1lxpzkrdj0jax0q8nkb49snb9sffrh2gg4fshzblk18b7kzff";
      name = "kollision-23.04.1.tar.xz";
    };
  };
  kolourpaint = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kolourpaint-23.04.1.tar.xz";
      sha256 = "1mpj1dvxjimr43dpblg76bml70dw5z8rs6f8gp71k1i117bvw617";
      name = "kolourpaint-23.04.1.tar.xz";
    };
  };
  kompare = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kompare-23.04.1.tar.xz";
      sha256 = "0vfikmyin566y2jg4b3iajsywdcl5653g7bai7f619751vhfx4a8";
      name = "kompare-23.04.1.tar.xz";
    };
  };
  kongress = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kongress-23.04.1.tar.xz";
      sha256 = "0dl6xz4wvbfq2war9vsagl4jscp1db59inhf45iixqy09qkkrfij";
      name = "kongress-23.04.1.tar.xz";
    };
  };
  konqueror = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/konqueror-23.04.1.tar.xz";
      sha256 = "10f7j11bmalcp14r27a0f04jlsjmxjksygccls5ls89avzwm2l8d";
      name = "konqueror-23.04.1.tar.xz";
    };
  };
  konquest = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/konquest-23.04.1.tar.xz";
      sha256 = "1l4lcdhwxcrxbqn0cmw7c6yfyi6q1ncpw8qphnj0hff55wgr5942";
      name = "konquest-23.04.1.tar.xz";
    };
  };
  konsole = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/konsole-23.04.1.tar.xz";
      sha256 = "165n0idnpwdxsf8757wj1pkxawf824an8nvwqp1aqg7rzfd19ldr";
      name = "konsole-23.04.1.tar.xz";
    };
  };
  kontact = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kontact-23.04.1.tar.xz";
      sha256 = "1l433smhldzryphcqyvxy6hmwxdbb3c9077nwni01phfsj2lbiaf";
      name = "kontact-23.04.1.tar.xz";
    };
  };
  kontactinterface = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kontactinterface-23.04.1.tar.xz";
      sha256 = "1l3xjylf1s12gcmda0cjxwni16mw7v6bcn6rxv19wlq6wcnk5y42";
      name = "kontactinterface-23.04.1.tar.xz";
    };
  };
  kontrast = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kontrast-23.04.1.tar.xz";
      sha256 = "0ls661kzc8c7h95j6wpb7alqqgdb03b8pw2p4prk26fvallhsypv";
      name = "kontrast-23.04.1.tar.xz";
    };
  };
  konversation = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/konversation-23.04.1.tar.xz";
      sha256 = "13500cr5vlcydsfh891xh6pm0fviwwsgsi03xy06sdrspxp78l1p";
      name = "konversation-23.04.1.tar.xz";
    };
  };
  kopeninghours = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kopeninghours-23.04.1.tar.xz";
      sha256 = "1ny8v6wmxd4sh25bpr0pyjrcfa225i0qvm2hpr696vffcg3dsz9y";
      name = "kopeninghours-23.04.1.tar.xz";
    };
  };
  kopete = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kopete-23.04.1.tar.xz";
      sha256 = "1v76y2n0vgksk5shzymsciy05qsfbv7k2h5gj8rpd9ia5k7m0gdr";
      name = "kopete-23.04.1.tar.xz";
    };
  };
  korganizer = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/korganizer-23.04.1.tar.xz";
      sha256 = "1shvd8gghnml7md9sjgicmy8lpza4l0mvkm4nj811hpc1wzkbia6";
      name = "korganizer-23.04.1.tar.xz";
    };
  };
  kosmindoormap = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kosmindoormap-23.04.1.tar.xz";
      sha256 = "169c97lcj7h25hwkfkgiklb363f8z93bn9azmcndshlqyi4brwhf";
      name = "kosmindoormap-23.04.1.tar.xz";
    };
  };
  kpat = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kpat-23.04.1.tar.xz";
      sha256 = "1061rgiq5iz4f54483svwv6cz1cll36d9pw4hsmdq9rv7fs223v5";
      name = "kpat-23.04.1.tar.xz";
    };
  };
  kpimtextedit = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kpimtextedit-23.04.1.tar.xz";
      sha256 = "1akasv0b8m60242r171f76yhx4hp2saf4l0dz3kyyq2zvns2rw4r";
      name = "kpimtextedit-23.04.1.tar.xz";
    };
  };
  kpkpass = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kpkpass-23.04.1.tar.xz";
      sha256 = "0lqfml6ibbx8k2hpsf07rxypkpl0s2fck5kfwq26gjizlisxr77v";
      name = "kpkpass-23.04.1.tar.xz";
    };
  };
  kpmcore = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kpmcore-23.04.1.tar.xz";
      sha256 = "07q80cx7axs02rwzvjgcsdy60rx0d982x6731imglqkh4vq2llil";
      name = "kpmcore-23.04.1.tar.xz";
    };
  };
  kpublictransport = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kpublictransport-23.04.1.tar.xz";
      sha256 = "1slmix7yyh3xmzaxals71yn40mckzxmqb5qjhs0j7cffm2h152yl";
      name = "kpublictransport-23.04.1.tar.xz";
    };
  };
  kqtquickcharts = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kqtquickcharts-23.04.1.tar.xz";
      sha256 = "0xmxz15f2w2xcr3821rkckwph6p59anak24lnc9khcg3qzlzszys";
      name = "kqtquickcharts-23.04.1.tar.xz";
    };
  };
  krdc = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/krdc-23.04.1.tar.xz";
      sha256 = "0yc8i595bw2bmmc9dy1vscnankrcx9h7k99v727w3gbwnm7yby0i";
      name = "krdc-23.04.1.tar.xz";
    };
  };
  krecorder = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/krecorder-23.04.1.tar.xz";
      sha256 = "177sj65i8vlkrkzfbd4rk2gsn6iqrrwiwlhr4p7r3sm0s8zsgg2h";
      name = "krecorder-23.04.1.tar.xz";
    };
  };
  kreversi = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kreversi-23.04.1.tar.xz";
      sha256 = "0ipnz7bil5cqihk7pmig5bh0852yzbik7cawm78229bx434ihihj";
      name = "kreversi-23.04.1.tar.xz";
    };
  };
  krfb = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/krfb-23.04.1.tar.xz";
      sha256 = "0b8r00sfnly0raxqcw724fv9llim188s7k6k799g7ibirql9lgvg";
      name = "krfb-23.04.1.tar.xz";
    };
  };
  kross-interpreters = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kross-interpreters-23.04.1.tar.xz";
      sha256 = "03s27hswcgxgmsjv26g2099az8i7hikdb9axf5kmmxlr0yshmfx5";
      name = "kross-interpreters-23.04.1.tar.xz";
    };
  };
  kruler = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kruler-23.04.1.tar.xz";
      sha256 = "11npnymar2r2h1hij2yxxqbjcvxvf4l6a8sif4hx0n1svb0i4v0l";
      name = "kruler-23.04.1.tar.xz";
    };
  };
  ksanecore = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksanecore-23.04.1.tar.xz";
      sha256 = "13844jarjnsrc99hnh4mw5rkqivhwaqbhp2nb6j8wc0pr8sfs5lj";
      name = "ksanecore-23.04.1.tar.xz";
    };
  };
  kshisen = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kshisen-23.04.1.tar.xz";
      sha256 = "0xid1019gzjq0sdrh8shln6zxwyqciczwcng0ipj783fi2rsq7n9";
      name = "kshisen-23.04.1.tar.xz";
    };
  };
  ksirk = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksirk-23.04.1.tar.xz";
      sha256 = "1n02fw6ajdf1649pi246851y8hmx876jzz6624gidablk9715y2v";
      name = "ksirk-23.04.1.tar.xz";
    };
  };
  ksmtp = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksmtp-23.04.1.tar.xz";
      sha256 = "1x5w3p5acnhyiykrn8d8m27dp268nwrwziqjnmcac0s3irv8fl4q";
      name = "ksmtp-23.04.1.tar.xz";
    };
  };
  ksnakeduel = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksnakeduel-23.04.1.tar.xz";
      sha256 = "1hz0h4n470b8mj34jr7j5wjasbkmr46vxygszblc5cmfzj1vj4j6";
      name = "ksnakeduel-23.04.1.tar.xz";
    };
  };
  kspaceduel = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kspaceduel-23.04.1.tar.xz";
      sha256 = "1dlyil8w1ry6kn7wsf33fzq3jjylp6lrqvnycsr5rxzfgvgdf2rl";
      name = "kspaceduel-23.04.1.tar.xz";
    };
  };
  ksquares = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksquares-23.04.1.tar.xz";
      sha256 = "0gp5bnhz06c1v6xxw0fdab2kswwmlxlcwd33lhmp4iy9h610cmih";
      name = "ksquares-23.04.1.tar.xz";
    };
  };
  ksudoku = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksudoku-23.04.1.tar.xz";
      sha256 = "1rji3hhxxvcxjjndcnn2wfw2d51ypdwl22frgksn9b5962yndbyh";
      name = "ksudoku-23.04.1.tar.xz";
    };
  };
  ksystemlog = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ksystemlog-23.04.1.tar.xz";
      sha256 = "1jpp0fklg1cn5m8pmch2lrzayijirsg07b3yg3kd73b4p17x5aqm";
      name = "ksystemlog-23.04.1.tar.xz";
    };
  };
  kteatime = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kteatime-23.04.1.tar.xz";
      sha256 = "0iib2rcw42h6vdzb2l8s33qy618l9a3x05f10kzkw0wq8afvb20v";
      name = "kteatime-23.04.1.tar.xz";
    };
  };
  ktimer = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktimer-23.04.1.tar.xz";
      sha256 = "15x88gp3y89iwmi01c20alr8nr164g96lr5xx3gs4rxq2jqa1yyg";
      name = "ktimer-23.04.1.tar.xz";
    };
  };
  ktnef = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktnef-23.04.1.tar.xz";
      sha256 = "0mipghpbncr0pk30yv100y4d12gy513jvvbd5fs4s3xg622lnzib";
      name = "ktnef-23.04.1.tar.xz";
    };
  };
  ktorrent = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktorrent-23.04.1.tar.xz";
      sha256 = "1n156r080mxy7dxfixfc2zld9msqa1f4gy847dazisvag4cv73w4";
      name = "ktorrent-23.04.1.tar.xz";
    };
  };
  ktouch = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktouch-23.04.1.tar.xz";
      sha256 = "1dawydacvmivqxffr24gp96n2fl8666fm3y1v0iw3wvs3qy2z8z4";
      name = "ktouch-23.04.1.tar.xz";
    };
  };
  ktp-accounts-kcm = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-accounts-kcm-23.04.1.tar.xz";
      sha256 = "1d2386r1qfrpzkh9cakzwf131casdmygsn48kwra3ikxjk0zkqqy";
      name = "ktp-accounts-kcm-23.04.1.tar.xz";
    };
  };
  ktp-approver = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-approver-23.04.1.tar.xz";
      sha256 = "10dj5ylw7z83c5ix9r8al64gkr1dwhac5zz84993pj69przp4ycr";
      name = "ktp-approver-23.04.1.tar.xz";
    };
  };
  ktp-auth-handler = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-auth-handler-23.04.1.tar.xz";
      sha256 = "1009d90aadli3hqwwjskaslk5z36i9i97z0qqpb8zcsd8a04jyj4";
      name = "ktp-auth-handler-23.04.1.tar.xz";
    };
  };
  ktp-call-ui = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-call-ui-23.04.1.tar.xz";
      sha256 = "03z0j5kf7bvcb2z8700f43c067y2awy24cypakla7r3n1syy81gd";
      name = "ktp-call-ui-23.04.1.tar.xz";
    };
  };
  ktp-common-internals = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-common-internals-23.04.1.tar.xz";
      sha256 = "13ndn88pk3jqnz90dqmh2zx0qbrcbfvgzww4pf122j7lpmigxyhk";
      name = "ktp-common-internals-23.04.1.tar.xz";
    };
  };
  ktp-contact-list = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-contact-list-23.04.1.tar.xz";
      sha256 = "022d33v1h5pxmz1k8knvdfrfg6jqmfsxkvmi4c2xny1ink5857bv";
      name = "ktp-contact-list-23.04.1.tar.xz";
    };
  };
  ktp-contact-runner = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-contact-runner-23.04.1.tar.xz";
      sha256 = "0dgf68y0z53fz9h2mrhrijfn0c50f7z72d3p799rfm6kg2p83yx8";
      name = "ktp-contact-runner-23.04.1.tar.xz";
    };
  };
  ktp-desktop-applets = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-desktop-applets-23.04.1.tar.xz";
      sha256 = "0kp5r55gi88jgl9lpyi1bczrl1i6dpd4ry6923f4f0l5gv7pjhzh";
      name = "ktp-desktop-applets-23.04.1.tar.xz";
    };
  };
  ktp-filetransfer-handler = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-filetransfer-handler-23.04.1.tar.xz";
      sha256 = "1jaflk4n56pz7x92906lpksl289dxpk6kik3ncr2dm4sc3131c2c";
      name = "ktp-filetransfer-handler-23.04.1.tar.xz";
    };
  };
  ktp-kded-module = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-kded-module-23.04.1.tar.xz";
      sha256 = "133rz5ywpd090wgsg45ply21qf3i0vbgimf5zl9irllmjb9wkibp";
      name = "ktp-kded-module-23.04.1.tar.xz";
    };
  };
  ktp-send-file = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-send-file-23.04.1.tar.xz";
      sha256 = "048mjrj0gx4q9cxc5ysnccdag1bji020p838qc8ax8csqcj2znw6";
      name = "ktp-send-file-23.04.1.tar.xz";
    };
  };
  ktp-text-ui = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktp-text-ui-23.04.1.tar.xz";
      sha256 = "1nvj3c7kvd44w67nq74j2w0nh9idzmxfr8b67jv6m8zbm6yihj2h";
      name = "ktp-text-ui-23.04.1.tar.xz";
    };
  };
  ktrip = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktrip-23.04.1.tar.xz";
      sha256 = "05gwhkcwp5mv0iqf8kp0xaikfc7zihqq729jjx7hgwhq30nkg2wm";
      name = "ktrip-23.04.1.tar.xz";
    };
  };
  ktuberling = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/ktuberling-23.04.1.tar.xz";
      sha256 = "0rpb00ag2v8v7cy75vkb5silk84qiqzf6by8dm5fppzbpg4l690n";
      name = "ktuberling-23.04.1.tar.xz";
    };
  };
  kturtle = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kturtle-23.04.1.tar.xz";
      sha256 = "0pd8560b5x8x2b760x2jljkz9sq54p2lgrfnsn1x67lh9a66yz8g";
      name = "kturtle-23.04.1.tar.xz";
    };
  };
  kubrick = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kubrick-23.04.1.tar.xz";
      sha256 = "18s35p7mf3ds3b53miyygix9yj60v6f715ji6lw1c736xv67cnwg";
      name = "kubrick-23.04.1.tar.xz";
    };
  };
  kwalletmanager = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kwalletmanager-23.04.1.tar.xz";
      sha256 = "0jrw4fyg2r4cfl0wfggxxm66xjdmjs5h79b1x60rd7sw8xxdw23h";
      name = "kwalletmanager-23.04.1.tar.xz";
    };
  };
  kwave = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kwave-23.04.1.tar.xz";
      sha256 = "19xfiyrp4ls8qsazm2csh05xg2rqbah1z57bplrfiw61kkn8g26x";
      name = "kwave-23.04.1.tar.xz";
    };
  };
  kweather = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kweather-23.04.1.tar.xz";
      sha256 = "1p16k0fjxyw2vc5sgcy6c940p841m0g8s44s6sr3lcyp2rbdhfra";
      name = "kweather-23.04.1.tar.xz";
    };
  };
  kwordquiz = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/kwordquiz-23.04.1.tar.xz";
      sha256 = "0b2iq844kcwz6cis5v63lvmd2cfkpqpb848va18c1l07bl61ilmr";
      name = "kwordquiz-23.04.1.tar.xz";
    };
  };
  libgravatar = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libgravatar-23.04.1.tar.xz";
      sha256 = "17bwsr7ia3rjiwxcs6b8vrxqm32h5hbw43xc2z0b27bf17x0f4cz";
      name = "libgravatar-23.04.1.tar.xz";
    };
  };
  libkcddb = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkcddb-23.04.1.tar.xz";
      sha256 = "0hp20s9jxxywj6722kr3ys2pv7f8v4qgdxbx3xpf513jyqdglfh9";
      name = "libkcddb-23.04.1.tar.xz";
    };
  };
  libkcompactdisc = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkcompactdisc-23.04.1.tar.xz";
      sha256 = "0vg5nmxd2c6x4ii68ykff41ky4anzw3489zcv6r5p09zpyzrn5j8";
      name = "libkcompactdisc-23.04.1.tar.xz";
    };
  };
  libkdcraw = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkdcraw-23.04.1.tar.xz";
      sha256 = "008pwmyi7p92qfqa8f9v4app3vbq28agdrb6clx8pzs3hj01p9hl";
      name = "libkdcraw-23.04.1.tar.xz";
    };
  };
  libkdegames = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkdegames-23.04.1.tar.xz";
      sha256 = "0q9fg90f2d6108ai2fgnvv9viqjawpzbrk98iiya6qidl9syr2w9";
      name = "libkdegames-23.04.1.tar.xz";
    };
  };
  libkdepim = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkdepim-23.04.1.tar.xz";
      sha256 = "0a5fv8bnjswx5mfr7a70ipmzrhzzzr43dfmk5kls2jf54854lr6h";
      name = "libkdepim-23.04.1.tar.xz";
    };
  };
  libkeduvocdocument = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkeduvocdocument-23.04.1.tar.xz";
      sha256 = "1bzh0scr51xfiifgx42ywbb5sm653myqw5k9jgczw7jjlqmww8mf";
      name = "libkeduvocdocument-23.04.1.tar.xz";
    };
  };
  libkexiv2 = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkexiv2-23.04.1.tar.xz";
      sha256 = "0xg236xgdpr9dh82za37a4migs4pim2798hgraqb78xf1q74259s";
      name = "libkexiv2-23.04.1.tar.xz";
    };
  };
  libkgapi = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkgapi-23.04.1.tar.xz";
      sha256 = "10gqvi9bq55sfv5z2a2bqbjchs72xdxhrbqc52gzzyxqyy7w006x";
      name = "libkgapi-23.04.1.tar.xz";
    };
  };
  libkipi = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkipi-23.04.1.tar.xz";
      sha256 = "15hly8gcvja7g1wyhmlz1rkfy9vb5sncklppvh5vijycpg5183vb";
      name = "libkipi-23.04.1.tar.xz";
    };
  };
  libkleo = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkleo-23.04.1.tar.xz";
      sha256 = "16c4dmlqbxkbs8w855s95hggi559y5g7niw2fc8hw0iry9f3j7xm";
      name = "libkleo-23.04.1.tar.xz";
    };
  };
  libkmahjongg = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkmahjongg-23.04.1.tar.xz";
      sha256 = "1624sqwbqsvwdsz5rglbjp4p25xl7im02hgdqmq758r2yrwcrvdw";
      name = "libkmahjongg-23.04.1.tar.xz";
    };
  };
  libkomparediff2 = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libkomparediff2-23.04.1.tar.xz";
      sha256 = "1w4bk4an4jcirn37w12yjgfm7yv3p5g39qhhnh9afw7j5ilwif5h";
      name = "libkomparediff2-23.04.1.tar.xz";
    };
  };
  libksane = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libksane-23.04.1.tar.xz";
      sha256 = "1zx1kskj624cad1qgk35q8kbkav59xrnxcfkw6dixciznadxpbxf";
      name = "libksane-23.04.1.tar.xz";
    };
  };
  libksieve = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libksieve-23.04.1.tar.xz";
      sha256 = "1f91vs0wn32a38qmlf55d0jsgxpszpw233g1zdy1z1samk7yx9n4";
      name = "libksieve-23.04.1.tar.xz";
    };
  };
  libktorrent = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/libktorrent-23.04.1.tar.xz";
      sha256 = "1kim80vxar57q4zwm6jbik3bh3pq6ndlaxn1ilnnnb1rchl1bjv3";
      name = "libktorrent-23.04.1.tar.xz";
    };
  };
  lokalize = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/lokalize-23.04.1.tar.xz";
      sha256 = "1a7w1vm3mf5wdsq76h8br42a8h11d2hpkxsvnv98lzkxv56rb5dz";
      name = "lokalize-23.04.1.tar.xz";
    };
  };
  lskat = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/lskat-23.04.1.tar.xz";
      sha256 = "1p36gmhv9whxn01ia3fip269qibpi75qq0nrs402pq1hz4kh3433";
      name = "lskat-23.04.1.tar.xz";
    };
  };
  mailcommon = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/mailcommon-23.04.1.tar.xz";
      sha256 = "0xypbxknbwivdfnd7315n5dyp1n6yc4lbbkqw2kxxm0k8db8v8qd";
      name = "mailcommon-23.04.1.tar.xz";
    };
  };
  mailimporter = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/mailimporter-23.04.1.tar.xz";
      sha256 = "0p0plgzlzv5khxc4vwq94xmsq02djwp81wdbvphmamfg6nmkqsb8";
      name = "mailimporter-23.04.1.tar.xz";
    };
  };
  marble = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/marble-23.04.1.tar.xz";
      sha256 = "1lll89zy8cnbb48vvbg31z03ixxwrh5af9wisd3gvh9awy9if7nl";
      name = "marble-23.04.1.tar.xz";
    };
  };
  markdownpart = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/markdownpart-23.04.1.tar.xz";
      sha256 = "1r8qrq7i0rnl8z3g9j53cqq6r83ybr389vr4m2arprc8c7lkfv3y";
      name = "markdownpart-23.04.1.tar.xz";
    };
  };
  mbox-importer = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/mbox-importer-23.04.1.tar.xz";
      sha256 = "08pih979gwz7bmas9c652apjriqib0kajxfdv7563wwm56fh0yyb";
      name = "mbox-importer-23.04.1.tar.xz";
    };
  };
  messagelib = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/messagelib-23.04.1.tar.xz";
      sha256 = "1cgvr23p2iwnllbk1a951sv5kl9dv5dqj63xwv4accply7602zib";
      name = "messagelib-23.04.1.tar.xz";
    };
  };
  minuet = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/minuet-23.04.1.tar.xz";
      sha256 = "07s6ncs1b4a27djv3qh6dd424rzvfmpmiq9465nlr4jkc2hy5kj8";
      name = "minuet-23.04.1.tar.xz";
    };
  };
  neochat = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/neochat-23.04.1.tar.xz";
      sha256 = "1ym5q7gy6h86m50ikn1bdnpcqiaghpw285cgic5h71qdw2jbs067";
      name = "neochat-23.04.1.tar.xz";
    };
  };
  okular = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/okular-23.04.1.tar.xz";
      sha256 = "1dqxkhqd6ih9rmb69yvpvw9yivw5i2vsh6h7ccqwb6jxd7w71i0w";
      name = "okular-23.04.1.tar.xz";
    };
  };
  palapeli = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/palapeli-23.04.1.tar.xz";
      sha256 = "0adj99yas78jkzacyxaafqbzl7fn4jb9ryjsanx00y02l9hz8fs0";
      name = "palapeli-23.04.1.tar.xz";
    };
  };
  parley = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/parley-23.04.1.tar.xz";
      sha256 = "0lfx5akl1y7na3jyi94hgshv932amk9pgbl0v3hnd8vsfza3xqan";
      name = "parley-23.04.1.tar.xz";
    };
  };
  partitionmanager = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/partitionmanager-23.04.1.tar.xz";
      sha256 = "0prj4p56dc95f25msqibgi0g8rg0n9vq60hb3k5388490gyzmiw8";
      name = "partitionmanager-23.04.1.tar.xz";
    };
  };
  picmi = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/picmi-23.04.1.tar.xz";
      sha256 = "0c8axjwv6bd04adm64iazy23hpxfv1rq3lnqbarzrr54wfhvaqcf";
      name = "picmi-23.04.1.tar.xz";
    };
  };
  pim-data-exporter = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/pim-data-exporter-23.04.1.tar.xz";
      sha256 = "1i367m1n7l7xxp9yk6dcjzhdizl54qamba4mw75nrn97dq59fcdk";
      name = "pim-data-exporter-23.04.1.tar.xz";
    };
  };
  pim-sieve-editor = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/pim-sieve-editor-23.04.1.tar.xz";
      sha256 = "02kmfd97k70wcg967zwvli8fz2pp9i34mjdgj59as0mnmzq9crzc";
      name = "pim-sieve-editor-23.04.1.tar.xz";
    };
  };
  pimcommon = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/pimcommon-23.04.1.tar.xz";
      sha256 = "1lrabkiqqm4g46w1awqll5a0sikhm318i14aszxpiy1vn8kqn12k";
      name = "pimcommon-23.04.1.tar.xz";
    };
  };
  plasmatube = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/plasmatube-23.04.1.tar.xz";
      sha256 = "0c69909my3a7pgvv5vh1c1l57cymvs937lsf0xj3s0ab4bkdkmh2";
      name = "plasmatube-23.04.1.tar.xz";
    };
  };
  poxml = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/poxml-23.04.1.tar.xz";
      sha256 = "17jhv0n5mr56ghcdhc6a5qhpxx18c4gkr04nn7qv6c5hr0djfd72";
      name = "poxml-23.04.1.tar.xz";
    };
  };
  print-manager = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/print-manager-23.04.1.tar.xz";
      sha256 = "1xqvslqsqn39hdmw2dyfs7nd5n57zb3xas5lwbqf5na3zswl5h60";
      name = "print-manager-23.04.1.tar.xz";
    };
  };
  qmlkonsole = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/qmlkonsole-23.04.1.tar.xz";
      sha256 = "1n01xikav041wwcgqq3g9i1k5xfqjafk54jfn68lkn00ykrbh2bi";
      name = "qmlkonsole-23.04.1.tar.xz";
    };
  };
  rocs = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/rocs-23.04.1.tar.xz";
      sha256 = "0g2zwhjkjbl8hj9bm8k5xglmcxb87nw04c2hiznh43s5l4clm7sb";
      name = "rocs-23.04.1.tar.xz";
    };
  };
  signon-kwallet-extension = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/signon-kwallet-extension-23.04.1.tar.xz";
      sha256 = "03bzb4h1dwbkcs1k09w2gj2ddklplgnamhyrdczn69qrk3qyx73r";
      name = "signon-kwallet-extension-23.04.1.tar.xz";
    };
  };
  skanlite = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/skanlite-23.04.1.tar.xz";
      sha256 = "0vng8vfk2vfccqqhpw2j16f6dd1wpln4pizrw1hzrvrwfga7aaz6";
      name = "skanlite-23.04.1.tar.xz";
    };
  };
  skanpage = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/skanpage-23.04.1.tar.xz";
      sha256 = "1zc52n24f9c9wyh8ndh4l7y7a1nh2fqi8gi97y0a6q32pkwbnshi";
      name = "skanpage-23.04.1.tar.xz";
    };
  };
  spectacle = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/spectacle-23.04.1.tar.xz";
      sha256 = "0kc24wxsr1q1clzjssqi36afdsbqdl3fcvw2plnaald4cr1jwk06";
      name = "spectacle-23.04.1.tar.xz";
    };
  };
  step = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/step-23.04.1.tar.xz";
      sha256 = "1gcfrk33d3101l8ib9fk121wi8bhj0hgd9w3r8l4nj6s5gx5nj9f";
      name = "step-23.04.1.tar.xz";
    };
  };
  svgpart = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/svgpart-23.04.1.tar.xz";
      sha256 = "1d31sd00ffjrbsfnmylcr69w84nzag31h65kpjhbymm23mvyl1w1";
      name = "svgpart-23.04.1.tar.xz";
    };
  };
  sweeper = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/sweeper-23.04.1.tar.xz";
      sha256 = "1bg573plp9h8lfx65vbwwv3v7hypd9p43v2ivpvlkkvkhgzggigh";
      name = "sweeper-23.04.1.tar.xz";
    };
  };
  telly-skout = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/telly-skout-23.04.1.tar.xz";
      sha256 = "0638bxqdwd2hchz4jfxg7cp5k35sqq5yjh0w4qn0335g0dakcarq";
      name = "telly-skout-23.04.1.tar.xz";
    };
  };
  tokodon = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/tokodon-23.04.1.tar.xz";
      sha256 = "1v4h0zfafsgirkvvqdsmz63kbds68s1m6y1695qk48ld620p9qc1";
      name = "tokodon-23.04.1.tar.xz";
    };
  };
  umbrello = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/umbrello-23.04.1.tar.xz";
      sha256 = "16ccl3cx66gmcc4kvfhwnjmxdvdwkwmkb28jzmda1jfx408hasnw";
      name = "umbrello-23.04.1.tar.xz";
    };
  };
  yakuake = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/yakuake-23.04.1.tar.xz";
      sha256 = "08fx90f46vsn2s1zr6g78fnd7cqpqjshb87i4i9401g0l73f5dw9";
      name = "yakuake-23.04.1.tar.xz";
    };
  };
  zanshin = {
    version = "23.04.1";
    src = fetchurl {
      url = "${mirror}/stable/release-service/23.04.1/src/zanshin-23.04.1.tar.xz";
      sha256 = "08a1mbrw1rr774s57i44b0x0flw27hj8g1qvnva96rpyab7zzrbi";
      name = "zanshin-23.04.1.tar.xz";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };
}

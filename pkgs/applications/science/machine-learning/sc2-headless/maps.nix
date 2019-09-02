{ fetchzip, unzip
}:
let
  fetchzip' = args: (fetchzip args).overrideAttrs (old: { UNZIP = "-j -P iagreetotheeula"; });
in
{
  minigames = fetchzip {
    url = "https://github.com/deepmind/pysc2/releases/download/v1.2/mini_games.zip";
    sha256 = "19f873ilcdsf50g2v0s2zzmxil1bqncsk8nq99bzy87h0i7khkla";
    stripRoot = false;
  };
  
  melee = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Melee.zip";
    sha256 = "0z44pgy10jklsvgpr0kcn4c2mz3hw7nlcmvsy6a6lzpi3dvzf33i";
    stripRoot = false;
  };
  ladder2017season1 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season1.zip";
    sha256 = "0ngg4g74s2ryhylny93fm8yq9rlrhphwnjg2s6f3qr85a2b3zdpd";
    stripRoot = false;
  };
  ladder2017season2 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season2.zip";
    sha256 = "01kycnvqagql9pkjkcgngfcnry2pc4kcygdkk511m0qr34909za5";
    stripRoot = false;
  };
  ladder2017season3 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season3_Updated.zip";
    sha256 = "0wix3lwmbyxfgh8ldg0n66i21p0dbavk2dxjngz79rx708m8qvld";
    stripRoot = false;
  };
  ladder2017season4 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season4.zip";
    sha256 = "1sidnmk2rc9j5fd3a4623pvaika1mm1rwhznb2qklsqsq1x2qckp";
    stripRoot = false;
  };
  ladder2018season1 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season1.zip";
    sha256 = "0mp0ilcq0gmd7ahahc5i8c7bdr3ivk6skx0b2cgb1z89l5d76irq";
    stripRoot = false;
  };
  ladder2018season2 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season2_Updated.zip";
    sha256 = "176rs848cx5src7qbr6dnn81bv1i86i381fidk3v81q9bxlmc2rv";
    stripRoot = false;
  };
  ladder2018season3 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season3.zip";
    sha256 = "1r3wv4w53g9zq6073ajgv74prbdsd1x3zfpyhv1kpxbffyr0x0zp";
    stripRoot = false;
  };
  ladder2018season4 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season4.zip";
    sha256 = "0k47rr6pzxbanlqnhliwywkvf0w04c8hxmbanksbz6aj5wpkcn1s";
    stripRoot = false;
  };
  ladder2019season1 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2019Season1.zip";
    sha256 = "1dlk9zza8h70lbjvg2ykc5wr9vsvvdk02szwrkgdw26mkssl2rg9";
    stripRoot = false;
  };
}

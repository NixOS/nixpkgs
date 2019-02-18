{ fetchzip
}:
let
  fetchzip' = args: (fetchzip args).overrideAttrs (old: { UNZIP = "-P iagreetotheeula"; });
in
{
  minigames = fetchzip {
    url = "https://github.com/deepmind/pysc2/releases/download/v1.2/mini_games.zip";
    sha256 = "19f873ilcdsf50g2v0s2zzmxil1bqncsk8nq99bzy87h0i7khkla";
    stripRoot = false;
  };
  
  melee = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Melee.zip";
    sha256 = "0w050yah5rybx3m5zvpr09jv01r0xsazpyrc76338b2sd8pdxv3y";
    stripRoot = false;
  };
  ladder2017season1 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season1.zip";
    sha256 = "194p0mb0bh63sjy84q21x4v5pb6d7hidivfi28aalr2gkwhwqfvh";
    stripRoot = false;
  };
  ladder2017season2 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season2.zip";
    sha256 = "1pvp7zi16326x3l45mk7s959ggnkg2j1w9rfmaxxa8mawr9c6i39";
    stripRoot = false;
  };
  ladder2017season3 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season3_Updated.zip";
    sha256 = "1sjskfp6spmh7l2za1z55v7binx005qxw3w11xdvjpn20cyhkh8a";
    stripRoot = false;
  };
  ladder2017season4 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2017Season4.zip";
    sha256 = "1zf4mfq6r1ylf8bmd0qpv134dcrfgrsi4afxfqwnf39ijdq4z26g";
    stripRoot = false;
  };
  ladder2018season1 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season1.zip";
    sha256 = "0p51xj98qg816qm9ywv9zar5llqvqs6bcyns6d5fp2j39fg08v6f";
    stripRoot = false;
  };
  ladder2018season2 = fetchzip' {
    url = "http://blzdistsc2-a.akamaihd.net/MapPacks/Ladder2018Season2_Updated.zip";
    sha256 = "1wjn6vpbymjvjxqf10h7az34fnmhb5dpi878nsydlax25v9lgzqx";
    stripRoot = false;
  };
}

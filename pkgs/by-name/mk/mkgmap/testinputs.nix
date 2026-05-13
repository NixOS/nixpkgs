{ fetchurl }:
let
  fetchTestInput =
    { res, hash }:
    fetchurl {
      inherit hash;
      url = "https://www.mkgmap.org.uk/testinput/${res}";
      name = builtins.replaceStrings [ "/" ] [ "__" ] res;
    };
in
[
  (fetchTestInput {
    res = "osm/lon1.osm.gz";
    hash = "sha256-Oze0loYeIZQ3w1cB2HeXFPDgzuU4s+T78k96BY+hGuU=";
  })
  (fetchTestInput {
    res = "osm/uk-test-1.osm.gz";
    hash = "sha256-0zVSP5yTmJUxYbXxFqBAn0pb08L3Z3gwilsKYeV8tkk=";
  })
  (fetchTestInput {
    res = "osm/uk-test-2.osm.gz";
    hash = "sha256-ROMgljyxYD7bwH1nXqoUZ1H8gM9e9dpoKCHO1xgGvBY=";
  })
  (fetchTestInput {
    res = "osm/is-in-samples.osm";
    hash = "sha256-Ay7o1w2TpOpIqPGrLuIcMYtK8MDN0GbkSkX7IvByeKM=";
  })
  (fetchTestInput {
    res = "mp/test1.mp";
    hash = "sha256-Ql5tdz3TMcRl/8k20Jek6g3W92/itpnqw24wgj7I07c=";
  })
  (fetchTestInput {
    res = "img/63240001.img";
    hash = "sha256-mBxOZyJlHZJ/hEmqqO4eVfoORGzoF8S/2jpgQJJ/uPI=";
  })
  (fetchTestInput {
    res = "img/63240002.img";
    hash = "sha256-Lijc6+JKaYq1xL64wcAnEnPhXOmWMjA9fZkaHif3O4o=";
  })
  (fetchTestInput {
    res = "img/63240003.img";
    hash = "sha256-4Wu1svN474O145ONM45pMR3GjtQpII00VGjiaTbur6Y=";
  })
  (fetchTestInput {
    res = "hgt/N00W090.hgt.zip";
    hash = "sha256-9nU9oczkWS1Cqc8SyQmo1QaYK+6jr+Wq+PoQ95YBC5o=";
  })
  (fetchTestInput {
    res = "hgt/N00W091.hgt.zip";
    hash = "sha256-PeT2PcbuPr+E4dzAme0TJqufbjNZn2wDkhiccCQncpQ=";
  })
  (fetchTestInput {
    res = "hgt/S01W090.hgt.zip";
    hash = "sha256-UqPnJmY51YamU/EGbCQVFdoh890HpFN//XadC3PS7zM=";
  })
  (fetchTestInput {
    res = "hgt/S01W091.hgt.zip";
    hash = "sha256-dvHxDgjKhmkQSmPPW8CtbsQWYtoYYuk6dTUlEtXAqHw=";
  })
  (fetchTestInput {
    res = "hgt/S02W090.hgt.zip";
    hash = "sha256-tjjYMxW6lWvWONoWFwTjHn+EhJ7OmcjGwVvM3t4J6GA=";
  })
  (fetchTestInput {
    res = "hgt/S02W091.hgt.zip";
    hash = "sha256-uVUKhM5eIS/STGxwgzDcXITRTqvILtHrS8mmXVB7l9c=";
  })
]

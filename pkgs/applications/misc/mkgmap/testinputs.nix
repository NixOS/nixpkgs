{ fetchurl }:
let
  fetchTestInput =
    { res, sha256 }:
    fetchurl {
      inherit sha256;
      url = "https://www.mkgmap.org.uk/testinput/${res}";
      name = builtins.replaceStrings [ "/" ] [ "__" ] res;
    };
in
[
  (fetchTestInput {
    res = "osm/lon1.osm.gz";
    sha256 = "1r8sl67hayjgybxy9crqwp7f1w0ljxvxh0apqcvr888yhsbb8drv";
  })
  (fetchTestInput {
    res = "osm/uk-test-1.osm.gz";
    sha256 = "0jdngkjn22jvi8q7hrzpqb9mnjlz82h1dwdmc4qrb64kkhzm4dfk";
  })
  (fetchTestInput {
    res = "osm/uk-test-2.osm.gz";
    sha256 = "05mw0qcdgki151ldmxayry0gqlb72jm5wrvxq3dkwq5i7jb21qs4";
  })
  (fetchTestInput {
    res = "osm/is-in-samples.osm";
    sha256 = "18vqfbq25ys59bj6dl6dq3q4m2ri3ki2xazim14fm94k1pbyhbh3";
  })
  (fetchTestInput {
    res = "mp/test1.mp";
    sha256 = "1dykr0z84c3fqgm9kdp2dzvxc3galjbx0dn9zxjw8cfk7mvnspj2";
  })
  (fetchTestInput {
    res = "img/63240001.img";
    sha256 = "1wmqgy940q1svazw85z8di20xyjm3vpaiaj9hizr47b549klw74q";
  })
  (fetchTestInput {
    res = "img/63240002.img";
    sha256 = "12ivywkiw6lrglyk0clnx5ff2wqj4z0c3f5yqjsqlsaawbmxqa1f";
  })
  (fetchTestInput {
    res = "img/63240003.img";
    sha256 = "19mgxqv6kqk8ahs8s819sj7cc79id67373ckwfsq7vvqyfrbasz1";
  })
  (fetchTestInput {
    res = "hgt/N00W090.hgt.zip";
    sha256 = "16hb06bgf47sz2mfbbx3xqmrh1nmm04wj4ngm512sng4rjhksxgn";
  })
  (fetchTestInput {
    res = "hgt/N00W091.hgt.zip";
    sha256 = "153j4wj7170qj81nr7sr6dp9zar62gnrkh6ww62bygpfqqyzdr1x";
  })
  (fetchTestInput {
    res = "hgt/S01W090.hgt.zip";
    sha256 = "0czgs9rhp7bnzmzm7907vprj3nhm2lj6q1piafk8dm9rcqkfg8sj";
  })
  (fetchTestInput {
    res = "hgt/S01W091.hgt.zip";
    sha256 = "0z58q3ai499mflxfjqhqv9i1di3fmp05pkv39886k1na107g3wbn";
  })
  (fetchTestInput {
    res = "hgt/S02W090.hgt.zip";
    sha256 = "0q7817gdxk2vq73ci6ffks288zqywc21f5ns73b6p5ds2lrxhf5n";
  })
  (fetchTestInput {
    res = "hgt/S02W091.hgt.zip";
    sha256 = "1mwpgd85v9n99gmx2bn8md7d312wvhq86w3c9k92y8ayrs20lmdr";
  })
]

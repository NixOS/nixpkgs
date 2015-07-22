{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."CSSselect"."~0.4.0" =
    self.by-version."CSSselect"."0.4.1";
  by-version."CSSselect"."0.4.1" = self.buildNodePackage {
    name = "CSSselect-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.4.1.tgz";
      name = "CSSselect-0.4.1.tgz";
      sha1 = "f8ab7e1f8418ce63cda6eb7bd778a85d7ec492b2";
    };
    deps = {
      "CSSwhat-0.4.7" = self.by-version."CSSwhat"."0.4.7";
      "domutils-1.4.3" = self.by-version."domutils"."1.4.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."CSSwhat"."0.4" =
    self.by-version."CSSwhat"."0.4.7";
  by-version."CSSwhat"."0.4.7" = self.buildNodePackage {
    name = "CSSwhat-0.4.7";
    version = "0.4.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.7.tgz";
      name = "CSSwhat-0.4.7.tgz";
      sha1 = "867da0ff39f778613242c44cfea83f0aa4ebdf9b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^1.0.0" =
    self.by-version."ansi-regex"."1.1.1";
  by-version."ansi-regex"."1.1.1" = self.buildNodePackage {
    name = "ansi-regex-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-1.1.1.tgz";
      name = "ansi-regex-1.1.1.tgz";
      sha1 = "41c847194646375e6a1a5d10c3ca054ef9fc980d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^1.1.0" =
    self.by-version."ansi-regex"."1.1.1";
  by-spec."ansi-styles"."^2.0.1" =
    self.by-version."ansi-styles"."2.0.1";
  by-version."ansi-styles"."2.0.1" = self.buildNodePackage {
    name = "ansi-styles-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.0.1.tgz";
      name = "ansi-styles-2.0.1.tgz";
      sha1 = "b033f57f93e2d28adeb8bc11138fa13da0fd20a3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."argparse"."0.1.15" =
    self.by-version."argparse"."0.1.15";
  by-version."argparse"."0.1.15" = self.buildNodePackage {
    name = "argparse-0.1.15";
    version = "0.1.15";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/argparse/-/argparse-0.1.15.tgz";
      name = "argparse-0.1.15.tgz";
      sha1 = "28a1f72c43113e763220e5708414301c8840f0a1";
    };
    deps = {
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "underscore.string-2.3.3" = self.by-version."underscore.string"."2.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "argparse" = self.by-version."argparse"."0.1.15";
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = self.buildNodePackage {
    name = "asn1-0.1.11";
    version = "0.1.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
      name = "asn1-0.1.11.tgz";
      sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."^0.1.5" =
    self.by-version."assert-plus"."0.1.5";
  by-version."assert-plus"."0.1.5" = self.buildNodePackage {
    name = "assert-plus-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
      name = "assert-plus-0.1.5.tgz";
      sha1 = "ee74009413002d84cec7219c6ac811812e723160";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = self.buildNodePackage {
    name = "async-0.2.10";
    version = "0.2.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
      name = "async-0.2.10.tgz";
      sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-version."async"."0.9.0" = self.buildNodePackage {
    name = "async-0.9.0";
    version = "0.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
      name = "async-0.9.0.tgz";
      sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = self.buildNodePackage {
    name = "aws-sign2-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
      name = "aws-sign2-0.5.0.tgz";
      sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."badnode"."^1.0.1" =
    self.by-version."badnode"."1.0.1";
  by-version."badnode"."1.0.1" = self.buildNodePackage {
    name = "badnode-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/badnode/-/badnode-1.0.1.tgz";
      name = "badnode-1.0.1.tgz";
      sha1 = "3f14123363badf4bed1acc8ed839ee99b27ad7e0";
    };
    deps = {
      "semver-4.3.3" = self.by-version."semver"."4.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "badnode" = self.by-version."badnode"."1.0.1";
  by-spec."balanced-match"."^0.2.0" =
    self.by-version."balanced-match"."0.2.0";
  by-version."balanced-match"."0.2.0" = self.buildNodePackage {
    name = "balanced-match-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.2.0.tgz";
      name = "balanced-match-0.2.0.tgz";
      sha1 = "38f6730c03aab6d5edbb52bd934885e756d71674";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bitcoyne".">=0.0.6" =
    self.by-version."bitcoyne"."1.0.1";
  by-version."bitcoyne"."1.0.1" = self.buildNodePackage {
    name = "bitcoyne-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bitcoyne/-/bitcoyne-1.0.1.tgz";
      name = "bitcoyne-1.0.1.tgz";
      sha1 = "5a775f93ccb8c4b7b26d4c2a44c25916783cf40e";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "kbpgp-2.0.9" = self.by-version."kbpgp"."2.0.9";
      "pgp-utils-0.0.27" = self.by-version."pgp-utils"."0.0.27";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bitcoyne" = self.by-version."bitcoyne"."1.0.1";
  by-spec."bl"."~0.9.0" =
    self.by-version."bl"."0.9.4";
  by-version."bl"."0.9.4" = self.buildNodePackage {
    name = "bl-0.9.4";
    version = "0.9.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bl/-/bl-0.9.4.tgz";
      name = "bl-0.9.4.tgz";
      sha1 = "4702ddf72fbe0ecd82787c00c113aea1935ad0e7";
    };
    deps = {
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."^2.9.21" =
    self.by-version."bluebird"."2.9.24";
  by-version."bluebird"."2.9.24" = self.buildNodePackage {
    name = "bluebird-2.9.24";
    version = "2.9.24";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.24.tgz";
      name = "bluebird-2.9.24.tgz";
      sha1 = "14a2e75f0548323dc35aa440d92007ca154e967c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bn"."^1.0.0" =
    self.by-version."bn"."1.0.1";
  by-version."bn"."1.0.1" = self.buildNodePackage {
    name = "bn-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bn/-/bn-1.0.1.tgz";
      name = "bn-1.0.1.tgz";
      sha1 = "a153825e6b1eb2c2db7726149b047a07ce0a3bb3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bn"."^1.0.1" =
    self.by-version."bn"."1.0.1";
  "bn" = self.by-version."bn"."1.0.1";
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.7.1";
  by-version."boom"."2.7.1" = self.buildNodePackage {
    name = "boom-2.7.1";
    version = "2.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-2.7.1.tgz";
      name = "boom-2.7.1.tgz";
      sha1 = "fb165c348d337977c61d4363c21e9e1abf526705";
    };
    deps = {
      "hoek-2.12.0" = self.by-version."hoek"."2.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.0";
  by-version."brace-expansion"."1.1.0" = self.buildNodePackage {
    name = "brace-expansion-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.0.tgz";
      name = "brace-expansion-1.1.0.tgz";
      sha1 = "c9b7d03c03f37bc704be100e522b40db8f6cfcd9";
    };
    deps = {
      "balanced-match-0.2.0" = self.by-version."balanced-match"."0.2.0";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.9.0" =
    self.by-version."caseless"."0.9.0";
  by-version."caseless"."0.9.0" = self.buildNodePackage {
    name = "caseless-0.9.0";
    version = "0.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.9.0.tgz";
      name = "caseless-0.9.0.tgz";
      sha1 = "b7b65ce6bf1413886539cfd533f0b30effa9cf88";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."^1.0.0" =
    self.by-version."chalk"."1.0.0";
  by-version."chalk"."1.0.0" = self.buildNodePackage {
    name = "chalk-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-1.0.0.tgz";
      name = "chalk-1.0.0.tgz";
      sha1 = "b3cf4ed0ff5397c99c75b8f679db2f52831f96dc";
    };
    deps = {
      "ansi-styles-2.0.1" = self.by-version."ansi-styles"."2.0.1";
      "escape-string-regexp-1.0.3" = self.by-version."escape-string-regexp"."1.0.3";
      "has-ansi-1.0.3" = self.by-version."has-ansi"."1.0.3";
      "strip-ansi-2.0.1" = self.by-version."strip-ansi"."2.0.1";
      "supports-color-1.3.1" = self.by-version."supports-color"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cheerio"."0.13.0" =
    self.by-version."cheerio"."0.13.0";
  by-version."cheerio"."0.13.0" = self.buildNodePackage {
    name = "cheerio-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cheerio/-/cheerio-0.13.0.tgz";
      name = "cheerio-0.13.0.tgz";
      sha1 = "44f5112044e0e0148300dd16bf8bbd7755ce65f1";
    };
    deps = {
      "htmlparser2-3.4.0" = self.by-version."htmlparser2"."3.4.0";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
      "entities-0.5.0" = self.by-version."entities"."0.5.0";
      "CSSselect-0.4.1" = self.by-version."CSSselect"."0.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cheerio" = self.by-version."cheerio"."0.13.0";
  by-spec."cli"."0.4.x" =
    self.by-version."cli"."0.4.5";
  by-version."cli"."0.4.5" = self.buildNodePackage {
    name = "cli-0.4.5";
    version = "0.4.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cli/-/cli-0.4.5.tgz";
      name = "cli-0.4.5.tgz";
      sha1 = "78f9485cd161b566e9a6c72d7170c4270e81db61";
    };
    deps = {
      "glob-5.0.5" = self.by-version."glob"."5.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cliff"."0.1.x" =
    self.by-version."cliff"."0.1.10";
  by-version."cliff"."0.1.10" = self.buildNodePackage {
    name = "cliff-0.1.10";
    version = "0.1.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cliff/-/cliff-0.1.10.tgz";
      name = "cliff-0.1.10.tgz";
      sha1 = "53be33ea9f59bec85609ee300ac4207603e52013";
    };
    deps = {
      "colors-1.0.3" = self.by-version."colors"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "winston-0.8.3" = self.by-version."winston"."0.8.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."codesign"."0.0.9" =
    self.by-version."codesign"."0.0.9";
  by-version."codesign"."0.0.9" = self.buildNodePackage {
    name = "codesign-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/codesign/-/codesign-0.0.9.tgz";
      name = "codesign-0.0.9.tgz";
      sha1 = "2da6b703f1d1cf2a76e8b1d48f44fa922e21b55f";
    };
    deps = {
      "argparse-0.1.15" = self.by-version."argparse"."0.1.15";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-logger-0.0.6" = self.by-version."iced-logger"."0.0.6";
      "glob-to-regexp-0.0.2" = self.by-version."glob-to-regexp"."0.0.2";
      "tablify-0.1.5" = self.by-version."tablify"."0.1.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "codesign" = self.by-version."codesign"."0.0.9";
  by-spec."colors"."0.6.2" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = self.buildNodePackage {
    name = "colors-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
      name = "colors-0.6.2.tgz";
      sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "colors" = self.by-version."colors"."0.6.2";
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-spec."colors".">=0.6.2" =
    self.by-version."colors"."1.0.3";
  by-version."colors"."1.0.3" = self.buildNodePackage {
    name = "colors-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
      name = "colors-1.0.3.tgz";
      sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."colors"."~0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."~1.0.3" =
    self.by-version."colors"."1.0.3";
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.7";
  by-version."combined-stream"."0.0.7" = self.buildNodePackage {
    name = "combined-stream-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
      name = "combined-stream-0.0.7.tgz";
      sha1 = "0137e657baa5a7541c57ac37ac5fc07d73b4dc1f";
    };
    deps = {
      "delayed-stream-0.0.5" = self.by-version."delayed-stream"."0.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."~0.0.5" =
    self.by-version."combined-stream"."0.0.7";
  by-spec."commander".">= 0.5.2" =
    self.by-version."commander"."2.8.1";
  by-version."commander"."2.8.1" = self.buildNodePackage {
    name = "commander-2.8.1";
    version = "2.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.8.1.tgz";
      name = "commander-2.8.1.tgz";
      sha1 = "06be367febfda0c330aa1e2a072d3dc9762425d4";
    };
    deps = {
      "graceful-readlink-1.0.1" = self.by-version."graceful-readlink"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."^2.7.1" =
    self.by-version."commander"."2.8.1";
  by-spec."commander"."~2.1.0" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = self.buildNodePackage {
    name = "commander-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
      name = "commander-2.1.0.tgz";
      sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-map"."0.0.1" =
    self.by-version."concat-map"."0.0.1";
  by-version."concat-map"."0.0.1" = self.buildNodePackage {
    name = "concat-map-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
      name = "concat-map-0.0.1.tgz";
      sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = self.buildNodePackage {
    name = "core-util-is-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
      name = "core-util-is-1.0.1.tgz";
      sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."2.x.x" =
    self.by-version."cryptiles"."2.0.4";
  by-version."cryptiles"."2.0.4" = self.buildNodePackage {
    name = "cryptiles-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.4.tgz";
      name = "cryptiles-2.0.4.tgz";
      sha1 = "09ea1775b9e1c7de7e60a99d42ab6f08ce1a1285";
    };
    deps = {
      "boom-2.7.1" = self.by-version."boom"."2.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ctype"."0.5.3" =
    self.by-version."ctype"."0.5.3";
  by-version."ctype"."0.5.3" = self.buildNodePackage {
    name = "ctype-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
      name = "ctype-0.5.3.tgz";
      sha1 = "82c18c2461f74114ef16c135224ad0b9144ca12f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = self.buildNodePackage {
    name = "cycle-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
      name = "cycle-1.0.3.tgz";
      sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-equal"."0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-version."deep-equal"."0.2.1" = self.buildNodePackage {
    name = "deep-equal-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.1.tgz";
      name = "deep-equal-0.2.1.tgz";
      sha1 = "fad7a793224cbf0c3c7786f92ef780e4fc8cc878";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "deep-equal" = self.by-version."deep-equal"."0.2.1";
  by-spec."deep-equal".">=0.2.1" =
    self.by-version."deep-equal"."1.0.0";
  by-version."deep-equal"."1.0.0" = self.buildNodePackage {
    name = "deep-equal-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-1.0.0.tgz";
      name = "deep-equal-1.0.0.tgz";
      sha1 = "d4564f07d2f0ab3e46110bec16592abd7dc2e326";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-equal"."~0.2.1" =
    self.by-version."deep-equal"."0.2.2";
  by-version."deep-equal"."0.2.2" = self.buildNodePackage {
    name = "deep-equal-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.2.tgz";
      name = "deep-equal-0.2.2.tgz";
      sha1 = "84b745896f34c684e98f2ce0e42abaf43bba017d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = self.buildNodePackage {
    name = "delayed-stream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
      name = "delayed-stream-0.0.5.tgz";
      sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."docco"."~0.6.2" =
    self.by-version."docco"."0.6.3";
  by-version."docco"."0.6.3" = self.buildNodePackage {
    name = "docco-0.6.3";
    version = "0.6.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/docco/-/docco-0.6.3.tgz";
      name = "docco-0.6.3.tgz";
      sha1 = "c47b5823d79563d6fc3abd49f3de48986e5522ee";
    };
    deps = {
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "marked-0.3.3" = self.by-version."marked"."0.3.3";
      "fs-extra-0.18.2" = self.by-version."fs-extra"."0.18.2";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "highlight.js-8.5.0" = self.by-version."highlight.js"."8.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.3.0";
  by-version."domelementtype"."1.3.0" = self.buildNodePackage {
    name = "domelementtype-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.3.0.tgz";
      name = "domelementtype-1.3.0.tgz";
      sha1 = "b17aed82e8ab59e52dd9c19b1756e0fc187204c2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domhandler"."2.2" =
    self.by-version."domhandler"."2.2.1";
  by-version."domhandler"."2.2.1" = self.buildNodePackage {
    name = "domhandler-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domhandler/-/domhandler-2.2.1.tgz";
      name = "domhandler-2.2.1.tgz";
      sha1 = "59df9dcd227e808b365ae73e1f6684ac3d946fc2";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domutils"."1.3" =
    self.by-version."domutils"."1.3.0";
  by-version."domutils"."1.3.0" = self.buildNodePackage {
    name = "domutils-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domutils/-/domutils-1.3.0.tgz";
      name = "domutils-1.3.0.tgz";
      sha1 = "9ad4d59b5af6ca684c62fe6d768ef170e70df192";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domutils"."1.4" =
    self.by-version."domutils"."1.4.3";
  by-version."domutils"."1.4.3" = self.buildNodePackage {
    name = "domutils-1.4.3";
    version = "1.4.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domutils/-/domutils-1.4.3.tgz";
      name = "domutils-1.4.3.tgz";
      sha1 = "0865513796c6b306031850e175516baf80b72a6f";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."entities"."0.x" =
    self.by-version."entities"."0.5.0";
  by-version."entities"."0.5.0" = self.buildNodePackage {
    name = "entities-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/entities/-/entities-0.5.0.tgz";
      name = "entities-0.5.0.tgz";
      sha1 = "f611cb5ae221050e0012c66979503fd7ae19cc49";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."^1.0.2" =
    self.by-version."escape-string-regexp"."1.0.3";
  by-version."escape-string-regexp"."1.0.3" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.3.tgz";
      name = "escape-string-regexp-1.0.3.tgz";
      sha1 = "9e2d8b25bc2555c3336723750e03f099c2735bb5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = self.buildNodePackage {
    name = "eyes-0.1.8";
    version = "0.1.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
      name = "eyes-0.1.8.tgz";
      sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eyes"."~0.1.8" =
    self.by-version."eyes"."0.1.8";
  by-spec."forever-agent"."~0.6.0" =
    self.by-version."forever-agent"."0.6.1";
  by-version."forever-agent"."0.6.1" = self.buildNodePackage {
    name = "forever-agent-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
      name = "forever-agent-0.6.1.tgz";
      sha1 = "fbc71f0c41adeb37f96c577ad1ed42d8fdacca91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."form-data"."~0.2.0" =
    self.by-version."form-data"."0.2.0";
  by-version."form-data"."0.2.0" = self.buildNodePackage {
    name = "form-data-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.2.0.tgz";
      name = "form-data-0.2.0.tgz";
      sha1 = "26f8bc26da6440e299cbdcfb69035c4f77a6e466";
    };
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."framed-msgpack-rpc"."1.1.4" =
    self.by-version."framed-msgpack-rpc"."1.1.4";
  by-version."framed-msgpack-rpc"."1.1.4" = self.buildNodePackage {
    name = "framed-msgpack-rpc-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/framed-msgpack-rpc/-/framed-msgpack-rpc-1.1.4.tgz";
      name = "framed-msgpack-rpc-1.1.4.tgz";
      sha1 = "54bfc5fbdf0c7c1b7691f20ffb31ef955c185db2";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "purepack-1.0.1" = self.by-version."purepack"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "framed-msgpack-rpc" = self.by-version."framed-msgpack-rpc"."1.1.4";
  by-spec."fs-extra".">= 0.6.0" =
    self.by-version."fs-extra"."0.18.2";
  by-version."fs-extra"."0.18.2" = self.buildNodePackage {
    name = "fs-extra-0.18.2";
    version = "0.18.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.18.2.tgz";
      name = "fs-extra-0.18.2.tgz";
      sha1 = "af05ca702b0b6dfa7de803a1f7ab479ec5c21525";
    };
    deps = {
      "graceful-fs-3.0.6" = self.by-version."graceful-fs"."3.0.6";
      "jsonfile-2.0.0" = self.by-version."jsonfile"."2.0.0";
      "rimraf-2.3.2" = self.by-version."rimraf"."2.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-function"."^2.0.0" =
    self.by-version."generate-function"."2.0.0";
  by-version."generate-function"."2.0.0" = self.buildNodePackage {
    name = "generate-function-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
      name = "generate-function-2.0.0.tgz";
      sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."generate-object-property"."^1.1.0" =
    self.by-version."generate-object-property"."1.1.1";
  by-version."generate-object-property"."1.1.1" = self.buildNodePackage {
    name = "generate-object-property-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.1.1.tgz";
      name = "generate-object-property-1.1.1.tgz";
      sha1 = "8fda6b4cb69b34a189a6cebee7c4c268af47cc93";
    };
    deps = {
      "is-property-1.0.2" = self.by-version."is-property"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."get-stdin"."^4.0.1" =
    self.by-version."get-stdin"."4.0.1";
  by-version."get-stdin"."4.0.1" = self.buildNodePackage {
    name = "get-stdin-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz";
      name = "get-stdin-4.0.1.tgz";
      sha1 = "b968c6b0a04384324902e8bf1a5df32579a450fe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob".">= 3.1.4" =
    self.by-version."glob"."5.0.5";
  by-version."glob"."5.0.5" = self.buildNodePackage {
    name = "glob-5.0.5";
    version = "5.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-5.0.5.tgz";
      name = "glob-5.0.5.tgz";
      sha1 = "784431e4e29a900ae0d47fba6aa1c7f16a8e7df7";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.4" = self.by-version."minimatch"."2.0.4";
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^4.4.2" =
    self.by-version."glob"."4.5.3";
  by-version."glob"."4.5.3" = self.buildNodePackage {
    name = "glob-4.5.3";
    version = "4.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-4.5.3.tgz";
      name = "glob-4.5.3.tgz";
      sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.4" = self.by-version."minimatch"."2.0.4";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob-to-regexp".">=0.0.1" =
    self.by-version."glob-to-regexp"."0.0.2";
  by-version."glob-to-regexp"."0.0.2" = self.buildNodePackage {
    name = "glob-to-regexp-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.0.2.tgz";
      name = "glob-to-regexp-0.0.2.tgz";
      sha1 = "82cb3c797594b47890f180f015c1773601374b91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gpg-wrapper".">=1.0.0" =
    self.by-version."gpg-wrapper"."1.0.4";
  by-version."gpg-wrapper"."1.0.4" = self.buildNodePackage {
    name = "gpg-wrapper-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gpg-wrapper/-/gpg-wrapper-1.0.4.tgz";
      name = "gpg-wrapper-1.0.4.tgz";
      sha1 = "0f26586bb9408e5c47201a45661bac1093e0d0ff";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "iced-spawn-1.0.0" = self.by-version."iced-spawn"."1.0.0";
      "iced-utils-0.1.22" = self.by-version."iced-utils"."0.1.22";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "spotty-1.0.0" = self.by-version."spotty"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gpg-wrapper".">=1.0.4" =
    self.by-version."gpg-wrapper"."1.0.4";
  "gpg-wrapper" = self.by-version."gpg-wrapper"."1.0.4";
  by-spec."graceful-fs"."^3.0.5" =
    self.by-version."graceful-fs"."3.0.6";
  by-version."graceful-fs"."3.0.6" = self.buildNodePackage {
    name = "graceful-fs-3.0.6";
    version = "3.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.6.tgz";
      name = "graceful-fs-3.0.6.tgz";
      sha1 = "dce3a18351cb94cdc82e688b2e3dd2842d1b09bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-readlink".">= 1.0.0" =
    self.by-version."graceful-readlink"."1.0.1";
  by-version."graceful-readlink"."1.0.1" = self.buildNodePackage {
    name = "graceful-readlink-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
      name = "graceful-readlink-1.0.1.tgz";
      sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."^1.4.0" =
    self.by-version."har-validator"."1.6.1";
  by-version."har-validator"."1.6.1" = self.buildNodePackage {
    name = "har-validator-1.6.1";
    version = "1.6.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/har-validator/-/har-validator-1.6.1.tgz";
      name = "har-validator-1.6.1.tgz";
      sha1 = "baef452cde645eff7d26562e8e749d7fd000b7fd";
    };
    deps = {
      "bluebird-2.9.24" = self.by-version."bluebird"."2.9.24";
      "chalk-1.0.0" = self.by-version."chalk"."1.0.0";
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "is-my-json-valid-2.10.1" = self.by-version."is-my-json-valid"."2.10.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-ansi"."^1.0.3" =
    self.by-version."has-ansi"."1.0.3";
  by-version."has-ansi"."1.0.3" = self.buildNodePackage {
    name = "has-ansi-1.0.3";
    version = "1.0.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-ansi/-/has-ansi-1.0.3.tgz";
      name = "has-ansi-1.0.3.tgz";
      sha1 = "c0b5b1615d9e382b0ff67169d967b425e48ca538";
    };
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~2.3.0" =
    self.by-version."hawk"."2.3.1";
  by-version."hawk"."2.3.1" = self.buildNodePackage {
    name = "hawk-2.3.1";
    version = "2.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-2.3.1.tgz";
      name = "hawk-2.3.1.tgz";
      sha1 = "1e731ce39447fa1d0f6d707f7bceebec0fd1ec1f";
    };
    deps = {
      "hoek-2.12.0" = self.by-version."hoek"."2.12.0";
      "boom-2.7.1" = self.by-version."boom"."2.7.1";
      "cryptiles-2.0.4" = self.by-version."cryptiles"."2.0.4";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."highlight.js".">= 8.0.x" =
    self.by-version."highlight.js"."8.5.0";
  by-version."highlight.js"."8.5.0" = self.buildNodePackage {
    name = "highlight.js-8.5.0";
    version = "8.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/highlight.js/-/highlight.js-8.5.0.tgz";
      name = "highlight.js-8.5.0.tgz";
      sha1 = "6473d5099edb9f82fa50286b9178c8583ad7d652";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."2.x.x" =
    self.by-version."hoek"."2.12.0";
  by-version."hoek"."2.12.0" = self.buildNodePackage {
    name = "hoek-2.12.0";
    version = "2.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-2.12.0.tgz";
      name = "hoek-2.12.0.tgz";
      sha1 = "5d1196e0bf20c5cec957e8927101164effdaf1c9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."htmlparser2"."~3.4.0" =
    self.by-version."htmlparser2"."3.4.0";
  by-version."htmlparser2"."3.4.0" = self.buildNodePackage {
    name = "htmlparser2-3.4.0";
    version = "3.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.4.0.tgz";
      name = "htmlparser2-3.4.0.tgz";
      sha1 = "a1cd65f5823ad285e19d63b085ad722d0a51eae7";
    };
    deps = {
      "domhandler-2.2.1" = self.by-version."domhandler"."2.2.1";
      "domutils-1.3.0" = self.by-version."domutils"."1.3.0";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.1";
  by-version."http-signature"."0.10.1" = self.buildNodePackage {
    name = "http-signature-0.10.1";
    version = "0.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.1.tgz";
      name = "http-signature-0.10.1.tgz";
      sha1 = "4fbdac132559aa8323121e540779c0a012b27e66";
    };
    deps = {
      "assert-plus-0.1.5" = self.by-version."assert-plus"."0.1.5";
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.3" = self.by-version."ctype"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iced-coffee-script"."~1.7.1-c" =
    self.by-version."iced-coffee-script"."1.7.1-g";
  by-version."iced-coffee-script"."1.7.1-g" = self.buildNodePackage {
    name = "iced-coffee-script-1.7.1-g";
    version = "1.7.1-g";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-coffee-script/-/iced-coffee-script-1.7.1-g.tgz";
      name = "iced-coffee-script-1.7.1-g.tgz";
      sha1 = "41f9ccabe113bade608d519c10a41406a62c170b";
    };
    deps = {
      "docco-0.6.3" = self.by-version."docco"."0.6.3";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-coffee-script" = self.by-version."iced-coffee-script"."1.7.1-g";
  by-spec."iced-data-structures"."0.0.5" =
    self.by-version."iced-data-structures"."0.0.5";
  by-version."iced-data-structures"."0.0.5" = self.buildNodePackage {
    name = "iced-data-structures-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-data-structures/-/iced-data-structures-0.0.5.tgz";
      name = "iced-data-structures-0.0.5.tgz";
      sha1 = "21de124f847fdeeb88f32cf232d3e3e600e05db4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-data-structures" = self.by-version."iced-data-structures"."0.0.5";
  by-spec."iced-data-structures"."~0.0.5" =
    self.by-version."iced-data-structures"."0.0.5";
  by-spec."iced-db"."0.0.4" =
    self.by-version."iced-db"."0.0.4";
  by-version."iced-db"."0.0.4" = self.buildNodePackage {
    name = "iced-db-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-db/-/iced-db-0.0.4.tgz";
      name = "iced-db-0.0.4.tgz";
      sha1 = "355bf9808998076013a0850ee33c6905dfb85a00";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "iced-utils-0.1.22" = self.by-version."iced-utils"."0.1.22";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-db" = self.by-version."iced-db"."0.0.4";
  by-spec."iced-error"."0.0.9" =
    self.by-version."iced-error"."0.0.9";
  by-version."iced-error"."0.0.9" = self.buildNodePackage {
    name = "iced-error-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-error/-/iced-error-0.0.9.tgz";
      name = "iced-error-0.0.9.tgz";
      sha1 = "c7c3057614c0a187d96b3d18c6d520e6b872ed37";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-error" = self.by-version."iced-error"."0.0.9";
  by-spec."iced-error".">=0.0.8" =
    self.by-version."iced-error"."0.0.9";
  by-spec."iced-error".">=0.0.9" =
    self.by-version."iced-error"."0.0.9";
  by-spec."iced-error"."~0.0.8" =
    self.by-version."iced-error"."0.0.9";
  by-spec."iced-expect"."0.0.3" =
    self.by-version."iced-expect"."0.0.3";
  by-version."iced-expect"."0.0.3" = self.buildNodePackage {
    name = "iced-expect-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-expect/-/iced-expect-0.0.3.tgz";
      name = "iced-expect-0.0.3.tgz";
      sha1 = "206f271f27b200b9b538e2c0ca66a70209be1238";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-expect" = self.by-version."iced-expect"."0.0.3";
  by-spec."iced-lock"."^1.0.1" =
    self.by-version."iced-lock"."1.0.1";
  by-version."iced-lock"."1.0.1" = self.buildNodePackage {
    name = "iced-lock-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-lock/-/iced-lock-1.0.1.tgz";
      name = "iced-lock-1.0.1.tgz";
      sha1 = "0914a61a4d3dec69db8f871ef40f95417fa38986";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-lock" = self.by-version."iced-lock"."1.0.1";
  by-spec."iced-logger"."0.0.5" =
    self.by-version."iced-logger"."0.0.5";
  by-version."iced-logger"."0.0.5" = self.buildNodePackage {
    name = "iced-logger-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-logger/-/iced-logger-0.0.5.tgz";
      name = "iced-logger-0.0.5.tgz";
      sha1 = "501852a410691cf7e9542598e04dfbfdadc51486";
    };
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-logger" = self.by-version."iced-logger"."0.0.5";
  by-spec."iced-logger".">=0.0.3" =
    self.by-version."iced-logger"."0.0.6";
  by-version."iced-logger"."0.0.6" = self.buildNodePackage {
    name = "iced-logger-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-logger/-/iced-logger-0.0.6.tgz";
      name = "iced-logger-0.0.6.tgz";
      sha1 = "3f38081e4df4742aab09b86bb0adf8ea6c12de82";
    };
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iced-logger"."~0.0.1" =
    self.by-version."iced-logger"."0.0.6";
  by-spec."iced-runtime".">=0.0.1" =
    self.by-version."iced-runtime"."1.0.2";
  by-version."iced-runtime"."1.0.2" = self.buildNodePackage {
    name = "iced-runtime-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-runtime/-/iced-runtime-1.0.2.tgz";
      name = "iced-runtime-1.0.2.tgz";
      sha1 = "a949a7cf49451175d3f6168d84997da27c4e6b70";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-runtime" = self.by-version."iced-runtime"."1.0.2";
  by-spec."iced-runtime".">=0.0.1 <2.0.0-0" =
    self.by-version."iced-runtime"."1.0.2";
  by-spec."iced-runtime"."^1.0.0" =
    self.by-version."iced-runtime"."1.0.2";
  by-spec."iced-runtime"."^1.0.1" =
    self.by-version."iced-runtime"."1.0.2";
  by-spec."iced-runtime"."^1.0.2" =
    self.by-version."iced-runtime"."1.0.2";
  by-spec."iced-spawn".">=0.0.3" =
    self.by-version."iced-spawn"."1.0.0";
  by-version."iced-spawn"."1.0.0" = self.buildNodePackage {
    name = "iced-spawn-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-spawn/-/iced-spawn-1.0.0.tgz";
      name = "iced-spawn-1.0.0.tgz";
      sha1 = "dab91968cb46f9c05baadd126a5abb53c5d7d1df";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "semver-4.3.3" = self.by-version."semver"."4.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iced-spawn".">=0.0.8" =
    self.by-version."iced-spawn"."1.0.0";
  by-spec."iced-spawn".">=1.0.0" =
    self.by-version."iced-spawn"."1.0.0";
  "iced-spawn" = self.by-version."iced-spawn"."1.0.0";
  by-spec."iced-test".">=0.0.16" =
    self.by-version."iced-test"."0.0.21";
  by-version."iced-test"."0.0.21" = self.buildNodePackage {
    name = "iced-test-0.0.21";
    version = "0.0.21";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-test/-/iced-test-0.0.21.tgz";
      name = "iced-test-0.0.21.tgz";
      sha1 = "8e7c347aa744eb4dddd786fcd430913be8bd83c7";
    };
    deps = {
      "colors-1.0.3" = self.by-version."colors"."1.0.3";
      "deep-equal-1.0.0" = self.by-version."deep-equal"."1.0.0";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-test" = self.by-version."iced-test"."0.0.21";
  by-spec."iced-utils"."0.1.20" =
    self.by-version."iced-utils"."0.1.20";
  by-version."iced-utils"."0.1.20" = self.buildNodePackage {
    name = "iced-utils-0.1.20";
    version = "0.1.20";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-utils/-/iced-utils-0.1.20.tgz";
      name = "iced-utils-0.1.20.tgz";
      sha1 = "923cbc3c080511cb6cc8e3ccde6609548d2db3e8";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-utils" = self.by-version."iced-utils"."0.1.20";
  by-spec."iced-utils".">=0.1.11" =
    self.by-version."iced-utils"."0.1.22";
  by-version."iced-utils"."0.1.22" = self.buildNodePackage {
    name = "iced-utils-0.1.22";
    version = "0.1.22";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-utils/-/iced-utils-0.1.22.tgz";
      name = "iced-utils-0.1.22.tgz";
      sha1 = "931925d9d39655a392fd337cefb2e111f503bb15";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iced-utils".">=0.1.16" =
    self.by-version."iced-utils"."0.1.22";
  by-spec."iced-utils".">=0.1.18" =
    self.by-version."iced-utils"."0.1.22";
  by-spec."iced-utils".">=0.1.22" =
    self.by-version."iced-utils"."0.1.22";
  by-spec."inflight"."^1.0.4" =
    self.by-version."inflight"."1.0.4";
  by-version."inflight"."1.0.4" = self.buildNodePackage {
    name = "inflight-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
      name = "inflight-1.0.4.tgz";
      sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
    };
    deps = {
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = self.buildNodePackage {
    name = "inherits-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
      name = "inherits-2.0.1.tgz";
      sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ipv6"."~3.1.1" =
    self.by-version."ipv6"."3.1.1";
  by-version."ipv6"."3.1.1" = self.buildNodePackage {
    name = "ipv6-3.1.1";
    version = "3.1.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/ipv6/-/ipv6-3.1.1.tgz";
      name = "ipv6-3.1.1.tgz";
      sha1 = "46da0e260af36fd9beb41297c987b7c21a2d9e1c";
    };
    deps = {
      "sprintf-0.1.5" = self.by-version."sprintf"."0.1.5";
      "cli-0.4.5" = self.by-version."cli"."0.4.5";
      "cliff-0.1.10" = self.by-version."cliff"."0.1.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.10.0" =
    self.by-version."is-my-json-valid"."2.10.1";
  by-version."is-my-json-valid"."2.10.1" = self.buildNodePackage {
    name = "is-my-json-valid-2.10.1";
    version = "2.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.10.1.tgz";
      name = "is-my-json-valid-2.10.1.tgz";
      sha1 = "bf20ca7e71116302f8660ac812659f71e22ea2d0";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.1.1" = self.by-version."generate-object-property"."1.1.1";
      "jsonpointer-1.1.0" = self.by-version."jsonpointer"."1.1.0";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-property"."^1.0.0" =
    self.by-version."is-property"."1.0.2";
  by-version."is-property"."1.0.2" = self.buildNodePackage {
    name = "is-property-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
      name = "is-property-1.0.2.tgz";
      sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = self.buildNodePackage {
    name = "isarray-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
      name = "isarray-0.0.1.tgz";
      sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isstream"."0.1.x" =
    self.by-version."isstream"."0.1.2";
  by-version."isstream"."0.1.2" = self.buildNodePackage {
    name = "isstream-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
      name = "isstream-0.1.2.tgz";
      sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isstream"."~0.1.1" =
    self.by-version."isstream"."0.1.2";
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.0";
    version = "5.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
      name = "json-stringify-safe-5.0.0.tgz";
      sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonfile"."^2.0.0" =
    self.by-version."jsonfile"."2.0.0";
  by-version."jsonfile"."2.0.0" = self.buildNodePackage {
    name = "jsonfile-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonfile/-/jsonfile-2.0.0.tgz";
      name = "jsonfile-2.0.0.tgz";
      sha1 = "c3944f350bd3c078b392e0aa1633b44662fcf06b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonpointer"."^1.1.0" =
    self.by-version."jsonpointer"."1.1.0";
  by-version."jsonpointer"."1.1.0" = self.buildNodePackage {
    name = "jsonpointer-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-1.1.0.tgz";
      name = "jsonpointer-1.1.0.tgz";
      sha1 = "c3c72efaed3b97154163dc01dd349e1cfe0f80fc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kbpgp".">=2.0.9" =
    self.by-version."kbpgp"."2.0.9";
  by-version."kbpgp"."2.0.9" = self.buildNodePackage {
    name = "kbpgp-2.0.9";
    version = "2.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/kbpgp/-/kbpgp-2.0.9.tgz";
      name = "kbpgp-2.0.9.tgz";
      sha1 = "b4f8686abde8689a1d4abb36e070af78632ceb59";
    };
    deps = {
      "bn-1.0.1" = self.by-version."bn"."1.0.1";
      "deep-equal-1.0.0" = self.by-version."deep-equal"."1.0.0";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "keybase-compressjs-1.0.1-c" = self.by-version."keybase-compressjs"."1.0.1-c";
      "keybase-ecurve-1.0.0" = self.by-version."keybase-ecurve"."1.0.0";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "purepack-1.0.1" = self.by-version."purepack"."1.0.1";
      "triplesec-3.0.19" = self.by-version."triplesec"."3.0.19";
      "tweetnacl-0.12.2" = self.by-version."tweetnacl"."0.12.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "kbpgp" = self.by-version."kbpgp"."2.0.9";
  by-spec."kbpgp"."^2.0.0" =
    self.by-version."kbpgp"."2.0.9";
  by-spec."keybase-compressjs"."^1.0.1-c" =
    self.by-version."keybase-compressjs"."1.0.1-c";
  by-version."keybase-compressjs"."1.0.1-c" = self.buildNodePackage {
    name = "keybase-compressjs-1.0.1-c";
    version = "1.0.1-c";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-compressjs/-/keybase-compressjs-1.0.1-c.tgz";
      name = "keybase-compressjs-1.0.1-c.tgz";
      sha1 = "dc664a7f5d95584a534622a260297532f3ce9f9f";
    };
    deps = {
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keybase-ecurve"."^1.0.0" =
    self.by-version."keybase-ecurve"."1.0.0";
  by-version."keybase-ecurve"."1.0.0" = self.buildNodePackage {
    name = "keybase-ecurve-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-ecurve/-/keybase-ecurve-1.0.0.tgz";
      name = "keybase-ecurve-1.0.0.tgz";
      sha1 = "c6bc72adda4603fd3184fee7e99694ed8fd69ad2";
    };
    deps = {
      "bn-1.0.1" = self.by-version."bn"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keybase-installer"."1.0.1" =
    self.by-version."keybase-installer"."1.0.1";
  by-version."keybase-installer"."1.0.1" = self.buildNodePackage {
    name = "keybase-installer-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-installer/-/keybase-installer-1.0.1.tgz";
      name = "keybase-installer-1.0.1.tgz";
      sha1 = "31ca46388833665225e8113bdd79ded9b04e0862";
    };
    deps = {
      "badnode-1.0.1" = self.by-version."badnode"."1.0.1";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "gpg-wrapper-1.0.4" = self.by-version."gpg-wrapper"."1.0.4";
      "iced-data-structures-0.0.5" = self.by-version."iced-data-structures"."0.0.5";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-logger-0.0.6" = self.by-version."iced-logger"."0.0.6";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "iced-spawn-1.0.0" = self.by-version."iced-spawn"."1.0.0";
      "iced-utils-0.1.22" = self.by-version."iced-utils"."0.1.22";
      "keybase-path-0.0.15" = self.by-version."keybase-path"."0.0.15";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "progress-1.1.3" = self.by-version."progress"."1.1.3";
      "request-2.55.0" = self.by-version."request"."2.55.0";
      "semver-4.3.3" = self.by-version."semver"."4.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "keybase-installer" = self.by-version."keybase-installer"."1.0.1";
  by-spec."keybase-path"."0.0.16" =
    self.by-version."keybase-path"."0.0.16";
  by-version."keybase-path"."0.0.16" = self.buildNodePackage {
    name = "keybase-path-0.0.16";
    version = "0.0.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-path/-/keybase-path-0.0.16.tgz";
      name = "keybase-path-0.0.16.tgz";
      sha1 = "3d60804aa48274b628d802a212f5e0dfcc13acaa";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "keybase-path" = self.by-version."keybase-path"."0.0.16";
  by-spec."keybase-path"."^0.0.15" =
    self.by-version."keybase-path"."0.0.15";
  by-version."keybase-path"."0.0.15" = self.buildNodePackage {
    name = "keybase-path-0.0.15";
    version = "0.0.15";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-path/-/keybase-path-0.0.15.tgz";
      name = "keybase-path-0.0.15.tgz";
      sha1 = "94b95448fc4edf73e096366279bd28a469d5f72f";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keybase-proofs"."^2.0.13" =
    self.by-version."keybase-proofs"."2.0.20";
  by-version."keybase-proofs"."2.0.20" = self.buildNodePackage {
    name = "keybase-proofs-2.0.20";
    version = "2.0.20";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-proofs/-/keybase-proofs-2.0.20.tgz";
      name = "keybase-proofs-2.0.20.tgz";
      sha1 = "bb8f76f51cd04ee3a2de8b7e786c717e718ec2c7";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "triplesec-3.0.19" = self.by-version."triplesec"."3.0.19";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "keybase-proofs" = self.by-version."keybase-proofs"."2.0.20";
  by-spec."libkeybase"."^1.0.2" =
    self.by-version."libkeybase"."1.0.2";
  by-version."libkeybase"."1.0.2" = self.buildNodePackage {
    name = "libkeybase-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/libkeybase/-/libkeybase-1.0.2.tgz";
      name = "libkeybase-1.0.2.tgz";
      sha1 = "742e4f5138faa8f912a70e126f0eda414bf8fc51";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-logger-0.0.5" = self.by-version."iced-logger"."0.0.5";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "kbpgp-2.0.9" = self.by-version."kbpgp"."2.0.9";
      "tweetnacl-0.12.2" = self.by-version."tweetnacl"."0.12.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "libkeybase" = self.by-version."libkeybase"."1.0.2";
  by-spec."marked".">= 0.2.7" =
    self.by-version."marked"."0.3.3";
  by-version."marked"."0.3.3" = self.buildNodePackage {
    name = "marked-0.3.3";
    version = "0.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/marked/-/marked-0.3.3.tgz";
      name = "marked-0.3.3.tgz";
      sha1 = "08bad9cac13736f6cceddc202344f1b0bf255390";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."merkle-tree"."0.0.12" =
    self.by-version."merkle-tree"."0.0.12";
  by-version."merkle-tree"."0.0.12" = self.buildNodePackage {
    name = "merkle-tree-0.0.12";
    version = "0.0.12";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/merkle-tree/-/merkle-tree-0.0.12.tgz";
      name = "merkle-tree-0.0.12.tgz";
      sha1 = "c8d6f0e9489b828c1d02942b24514311bac5e30f";
    };
    deps = {
      "deep-equal-0.2.2" = self.by-version."deep-equal"."0.2.2";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "iced-utils-0.1.22" = self.by-version."iced-utils"."0.1.22";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "merkle-tree" = self.by-version."merkle-tree"."0.0.12";
  by-spec."mime-db"."~1.8.0" =
    self.by-version."mime-db"."1.8.0";
  by-version."mime-db"."1.8.0" = self.buildNodePackage {
    name = "mime-db-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.8.0.tgz";
      name = "mime-db-1.8.0.tgz";
      sha1 = "82a9b385f22b0f5954dec4d445faba0722c4ad25";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.1" =
    self.by-version."mime-types"."2.0.10";
  by-version."mime-types"."2.0.10" = self.buildNodePackage {
    name = "mime-types-2.0.10";
    version = "2.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.10.tgz";
      name = "mime-types-2.0.10.tgz";
      sha1 = "eacd81bb73cab2a77447549a078d4f2018c67b4d";
    };
    deps = {
      "mime-db-1.8.0" = self.by-version."mime-db"."1.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.10";
  by-spec."minimatch"."^2.0.1" =
    self.by-version."minimatch"."2.0.4";
  by-version."minimatch"."2.0.4" = self.buildNodePackage {
    name = "minimatch-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-2.0.4.tgz";
      name = "minimatch-2.0.4.tgz";
      sha1 = "83bea115803e7a097a78022427287edb762fafed";
    };
    deps = {
      "brace-expansion-1.1.0" = self.by-version."brace-expansion"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist".">=0.0.8" =
    self.by-version."minimist"."1.1.1";
  by-version."minimist"."1.1.1" = self.buildNodePackage {
    name = "minimist-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-1.1.1.tgz";
      name = "minimist-1.1.1.tgz";
      sha1 = "1bc2bc71658cdca5712475684363615b0b4f695b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = self.buildNodePackage {
    name = "minimist-0.0.10";
    version = "0.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
      name = "minimist-0.0.10.tgz";
      sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = self.buildNodePackage {
    name = "mkdirp-0.3.5";
    version = "0.3.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
      name = "mkdirp-0.3.5.tgz";
      sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mkdirp" = self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."more-entropy".">=0.0.7" =
    self.by-version."more-entropy"."0.0.7";
  by-version."more-entropy"."0.0.7" = self.buildNodePackage {
    name = "more-entropy-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/more-entropy/-/more-entropy-0.0.7.tgz";
      name = "more-entropy-0.0.7.tgz";
      sha1 = "67bfc6f7a86f26fbc37aac83fd46d88c61d109b5";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = self.buildNodePackage {
    name = "mute-stream-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
      name = "mute-stream-0.0.4.tgz";
      sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."network-byte-order"."~0.2.0" =
    self.by-version."network-byte-order"."0.2.0";
  by-version."network-byte-order"."0.2.0" = self.buildNodePackage {
    name = "network-byte-order-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/network-byte-order/-/network-byte-order-0.2.0.tgz";
      name = "network-byte-order-0.2.0.tgz";
      sha1 = "6ac11bf44bf610daeddbe90a09a5c817c6e0d2b3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.3";
  by-version."node-uuid"."1.4.3" = self.buildNodePackage {
    name = "node-uuid-1.4.3";
    version = "1.4.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.3.tgz";
      name = "node-uuid-1.4.3.tgz";
      sha1 = "319bb7a56e7cb63f00b5c0cd7851cd4b4ddf1df9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.6.0" =
    self.by-version."oauth-sign"."0.6.0";
  by-version."oauth-sign"."0.6.0" = self.buildNodePackage {
    name = "oauth-sign-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.6.0.tgz";
      name = "oauth-sign-0.6.0.tgz";
      sha1 = "7dbeae44f6ca454e1f168451d630746735813ce3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.1";
  by-version."once"."1.3.1" = self.buildNodePackage {
    name = "once-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/once/-/once-1.3.1.tgz";
      name = "once-1.3.1.tgz";
      sha1 = "f3f3e4da5b7d27b5c732969ee3e67e729457b31f";
    };
    deps = {
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."0.6.1" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = self.buildNodePackage {
    name = "optimist-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
      name = "optimist-0.6.1.tgz";
      sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
    };
    deps = {
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "optimist" = self.by-version."optimist"."0.6.1";
  by-spec."path-is-absolute"."^1.0.0" =
    self.by-version."path-is-absolute"."1.0.0";
  by-version."path-is-absolute"."1.0.0" = self.buildNodePackage {
    name = "path-is-absolute-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.0.tgz";
      name = "path-is-absolute-1.0.0.tgz";
      sha1 = "263dada66ab3f2fb10bf7f9d24dd8f3e570ef912";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pgp-utils"."0.0.27" =
    self.by-version."pgp-utils"."0.0.27";
  by-version."pgp-utils"."0.0.27" = self.buildNodePackage {
    name = "pgp-utils-0.0.27";
    version = "0.0.27";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pgp-utils/-/pgp-utils-0.0.27.tgz";
      name = "pgp-utils-0.0.27.tgz";
      sha1 = "3c9afdc0c5d0674bd78ed5009e2d0aec20be32b3";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pgp-utils".">=0.0.21" =
    self.by-version."pgp-utils"."0.0.28";
  by-version."pgp-utils"."0.0.28" = self.buildNodePackage {
    name = "pgp-utils-0.0.28";
    version = "0.0.28";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pgp-utils/-/pgp-utils-0.0.28.tgz";
      name = "pgp-utils-0.0.28.tgz";
      sha1 = "fe29f874cb3f32d75daac79a33661b831a2e3add";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pgp-utils".">=0.0.22" =
    self.by-version."pgp-utils"."0.0.28";
  by-spec."pgp-utils".">=0.0.28" =
    self.by-version."pgp-utils"."0.0.28";
  "pgp-utils" = self.by-version."pgp-utils"."0.0.28";
  by-spec."pgp-utils".">=0.0.8" =
    self.by-version."pgp-utils"."0.0.28";
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = self.buildNodePackage {
    name = "pkginfo-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
      name = "pkginfo-0.3.0.tgz";
      sha1 = "726411401039fe9b009eea86614295d5f3a54276";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."progress"."1.1.3" =
    self.by-version."progress"."1.1.3";
  by-version."progress"."1.1.3" = self.buildNodePackage {
    name = "progress-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/progress/-/progress-1.1.3.tgz";
      name = "progress-1.1.3.tgz";
      sha1 = "42f89c5fc3b6f0408a0bdd68993b174f96aababf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "progress" = self.by-version."progress"."1.1.3";
  by-spec."progress"."~1.1.2" =
    self.by-version."progress"."1.1.8";
  by-version."progress"."1.1.8" = self.buildNodePackage {
    name = "progress-1.1.8";
    version = "1.1.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/progress/-/progress-1.1.8.tgz";
      name = "progress-1.1.8.tgz";
      sha1 = "e260c78f6161cdd9b0e56cc3e0a85de17c7a57be";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = self.buildNodePackage {
    name = "punycode-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
      name = "punycode-1.3.2.tgz";
      sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."purepack"."1.0.1" =
    self.by-version."purepack"."1.0.1";
  by-version."purepack"."1.0.1" = self.buildNodePackage {
    name = "purepack-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/purepack/-/purepack-1.0.1.tgz";
      name = "purepack-1.0.1.tgz";
      sha1 = "9592f35bc22279a777885d3de04acc3555994f68";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "purepack" = self.by-version."purepack"."1.0.1";
  by-spec."purepack".">=1" =
    self.by-version."purepack"."1.0.1";
  by-spec."purepack".">=1.0.1" =
    self.by-version."purepack"."1.0.1";
  by-spec."qs"."~2.4.0" =
    self.by-version."qs"."2.4.1";
  by-version."qs"."2.4.1" = self.buildNodePackage {
    name = "qs-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-2.4.1.tgz";
      name = "qs-2.4.1.tgz";
      sha1 = "68cbaea971013426a80c1404fad6b1a6b1175245";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."read"."keybase/read" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = self.buildNodePackage {
    name = "read-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchgit {
      url = "git://github.com/keybase/read";
      rev = "740ae6a1a72a96984ae3527eb0ce0066c9fc8d47";
      sha256 = "927ce6e6e88c80c54b434261afb5717630568b6979afffc6828c4fc0335e22ec";
    };
    deps = {
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "read" = self.by-version."read"."1.0.5";
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-version."readable-stream"."1.1.13" = self.buildNodePackage {
    name = "readable-stream-1.1.13";
    version = "1.1.13";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.13.tgz";
      name = "readable-stream-1.1.13.tgz";
      sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
    };
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.33";
  by-version."readable-stream"."1.0.33" = self.buildNodePackage {
    name = "readable-stream-1.0.33";
    version = "1.0.33";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.33.tgz";
      name = "readable-stream-1.0.33.tgz";
      sha1 = "3a360dd66c1b1d7fd4705389860eda1d0f61126c";
    };
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.34.0" =
    self.by-version."request"."2.55.0";
  by-version."request"."2.55.0" = self.buildNodePackage {
    name = "request-2.55.0";
    version = "2.55.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.55.0.tgz";
      name = "request-2.55.0.tgz";
      sha1 = "d75c1cdf679d76bb100f9bffe1fe551b5c24e93d";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.4.1" = self.by-version."qs"."2.4.1";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.13.0" = self.by-version."tough-cookie"."0.13.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.6.1" = self.by-version."har-validator"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.55.0" =
    self.by-version."request"."2.55.0";
  "request" = self.by-version."request"."2.55.0";
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.3.2";
  by-version."rimraf"."2.3.2" = self.buildNodePackage {
    name = "rimraf-2.3.2";
    version = "2.3.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.3.2.tgz";
      name = "rimraf-2.3.2.tgz";
      sha1 = "7304bd9275c401b89103b106b3531c1ef0c02fe9";
    };
    deps = {
      "glob-4.5.3" = self.by-version."glob"."4.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver".">=1" =
    self.by-version."semver"."4.3.3";
  by-version."semver"."4.3.3" = self.buildNodePackage {
    name = "semver-4.3.3";
    version = "4.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-4.3.3.tgz";
      name = "semver-4.3.3.tgz";
      sha1 = "15466b61220bc371cd8f0e666a9f785329ea8228";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver".">=2.2.1" =
    self.by-version."semver"."4.3.3";
  by-spec."semver"."^4.0.0" =
    self.by-version."semver"."4.3.3";
  "semver" = self.by-version."semver"."4.3.3";
  by-spec."sntp"."1.x.x" =
    self.by-version."sntp"."1.0.9";
  by-version."sntp"."1.0.9" = self.buildNodePackage {
    name = "sntp-1.0.9";
    version = "1.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
      name = "sntp-1.0.9.tgz";
      sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
    };
    deps = {
      "hoek-2.12.0" = self.by-version."hoek"."2.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socks5-client"."0.x" =
    self.by-version."socks5-client"."0.3.6";
  by-version."socks5-client"."0.3.6" = self.buildNodePackage {
    name = "socks5-client-0.3.6";
    version = "0.3.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socks5-client/-/socks5-client-0.3.6.tgz";
      name = "socks5-client-0.3.6.tgz";
      sha1 = "4205b5791f2df77cf07527222558fe4e46aca2f1";
    };
    deps = {
      "ipv6-3.1.1" = self.by-version."ipv6"."3.1.1";
      "network-byte-order-0.2.0" = self.by-version."network-byte-order"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socks5-client"."^0.3.6" =
    self.by-version."socks5-client"."0.3.6";
  "socks5-client" = self.by-version."socks5-client"."0.3.6";
  by-spec."socks5-client"."~0.3.4" =
    self.by-version."socks5-client"."0.3.6";
  by-spec."socks5-http-client"."^0.1.6" =
    self.by-version."socks5-http-client"."0.1.6";
  by-version."socks5-http-client"."0.1.6" = self.buildNodePackage {
    name = "socks5-http-client-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socks5-http-client/-/socks5-http-client-0.1.6.tgz";
      name = "socks5-http-client-0.1.6.tgz";
      sha1 = "a915ba75573787876e5d3756ee4a81d60cd4b69b";
    };
    deps = {
      "socks5-client-0.3.6" = self.by-version."socks5-client"."0.3.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "socks5-http-client" = self.by-version."socks5-http-client"."0.1.6";
  by-spec."socks5-https-client"."^0.2.2" =
    self.by-version."socks5-https-client"."0.2.2";
  by-version."socks5-https-client"."0.2.2" = self.buildNodePackage {
    name = "socks5-https-client-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socks5-https-client/-/socks5-https-client-0.2.2.tgz";
      name = "socks5-https-client-0.2.2.tgz";
      sha1 = "b855e950e97c4fa6bca72a108f00278d33ac91d1";
    };
    deps = {
      "socks5-client-0.3.6" = self.by-version."socks5-client"."0.3.6";
      "starttls-0.2.1" = self.by-version."starttls"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "socks5-https-client" = self.by-version."socks5-https-client"."0.2.2";
  by-spec."spotty"."^1.0.0" =
    self.by-version."spotty"."1.0.0";
  by-version."spotty"."1.0.0" = self.buildNodePackage {
    name = "spotty-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/spotty/-/spotty-1.0.0.tgz";
      name = "spotty-1.0.0.tgz";
      sha1 = "05bb5152b3dd0744a341764db5fcf8e47943e678";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "spotty" = self.by-version."spotty"."1.0.0";
  by-spec."sprintf"."0.1.x" =
    self.by-version."sprintf"."0.1.5";
  by-version."sprintf"."0.1.5" = self.buildNodePackage {
    name = "sprintf-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sprintf/-/sprintf-0.1.5.tgz";
      name = "sprintf-0.1.5.tgz";
      sha1 = "8f83e39a9317c1a502cb7db8050e51c679f6edcf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = self.buildNodePackage {
    name = "stack-trace-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
      name = "stack-trace-0.0.9.tgz";
      sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."starttls"."0.x" =
    self.by-version."starttls"."0.2.1";
  by-version."starttls"."0.2.1" = self.buildNodePackage {
    name = "starttls-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/starttls/-/starttls-0.2.1.tgz";
      name = "starttls-0.2.1.tgz";
      sha1 = "b98d3e5e778d46f199c843a64f889f0347c6d19a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = self.buildNodePackage {
    name = "string_decoder-0.10.31";
    version = "0.10.31";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
      name = "string_decoder-0.10.31.tgz";
      sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stringstream"."~0.0.4" =
    self.by-version."stringstream"."0.0.4";
  by-version."stringstream"."0.0.4" = self.buildNodePackage {
    name = "stringstream-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.4.tgz";
      name = "stringstream-0.0.4.tgz";
      sha1 = "0f0e3423f942960b5692ac324a57dd093bc41a92";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^2.0.1" =
    self.by-version."strip-ansi"."2.0.1";
  by-version."strip-ansi"."2.0.1" = self.buildNodePackage {
    name = "strip-ansi-2.0.1";
    version = "2.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-2.0.1.tgz";
      name = "strip-ansi-2.0.1.tgz";
      sha1 = "df62c1aa94ed2f114e1d0f21fd1d50482b79a60e";
    };
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."supports-color"."^1.3.0" =
    self.by-version."supports-color"."1.3.1";
  by-version."supports-color"."1.3.1" = self.buildNodePackage {
    name = "supports-color-1.3.1";
    version = "1.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-1.3.1.tgz";
      name = "supports-color-1.3.1.tgz";
      sha1 = "15758df09d8ff3b4acc307539fabe27095e1042d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tablify"."0.1.5" =
    self.by-version."tablify"."0.1.5";
  by-version."tablify"."0.1.5" = self.buildNodePackage {
    name = "tablify-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tablify/-/tablify-0.1.5.tgz";
      name = "tablify-0.1.5.tgz";
      sha1 = "47160ce2918be291d63cecceddb5254dd72982c7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "tablify" = self.by-version."tablify"."0.1.5";
  by-spec."tablify".">=0.1.5" =
    self.by-version."tablify"."0.1.5";
  by-spec."timeago"."0.1.0" =
    self.by-version."timeago"."0.1.0";
  by-version."timeago"."0.1.0" = self.buildNodePackage {
    name = "timeago-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/timeago/-/timeago-0.1.0.tgz";
      name = "timeago-0.1.0.tgz";
      sha1 = "21176a84d469be35ee431c5c48c0b6aba1f72464";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "timeago" = self.by-version."timeago"."0.1.0";
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."0.13.0";
  by-version."tough-cookie"."0.13.0" = self.buildNodePackage {
    name = "tough-cookie-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.13.0.tgz";
      name = "tough-cookie-0.13.0.tgz";
      sha1 = "34531cfefeba2dc050fb8e9a3310f876cdcc24f4";
    };
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."triplesec".">=3.0.16" =
    self.by-version."triplesec"."3.0.19";
  by-version."triplesec"."3.0.19" = self.buildNodePackage {
    name = "triplesec-3.0.19";
    version = "3.0.19";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/triplesec/-/triplesec-3.0.19.tgz";
      name = "triplesec-3.0.19.tgz";
      sha1 = "1cf858ccfcc133a3e884ff7d37aedf3b306c32f9";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "more-entropy-0.0.7" = self.by-version."more-entropy"."0.0.7";
      "progress-1.1.8" = self.by-version."progress"."1.1.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "triplesec" = self.by-version."triplesec"."3.0.19";
  by-spec."triplesec".">=3.0.19" =
    self.by-version."triplesec"."3.0.19";
  by-spec."tunnel-agent"."~0.4.0" =
    self.by-version."tunnel-agent"."0.4.0";
  by-version."tunnel-agent"."0.4.0" = self.buildNodePackage {
    name = "tunnel-agent-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.0.tgz";
      name = "tunnel-agent-0.4.0.tgz";
      sha1 = "b1184e312ffbcf70b3b4c78e8c219de7ebb1c550";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."^0.12.0" =
    self.by-version."tweetnacl"."0.12.2";
  by-version."tweetnacl"."0.12.2" = self.buildNodePackage {
    name = "tweetnacl-0.12.2";
    version = "0.12.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tweetnacl/-/tweetnacl-0.12.2.tgz";
      name = "tweetnacl-0.12.2.tgz";
      sha1 = "bd59f890507856fb0a1136acc3a8b44547e29ddb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."^0.12.2" =
    self.by-version."tweetnacl"."0.12.2";
  by-spec."underscore".">= 1.0.0" =
    self.by-version."underscore"."1.8.3";
  by-version."underscore"."1.8.3" = self.buildNodePackage {
    name = "underscore-1.8.3";
    version = "1.8.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.8.3.tgz";
      name = "underscore-1.8.3.tgz";
      sha1 = "4f3fb53b106e6097fcf9cb4109f2a5e9bdfa5022";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."~1.4" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = self.buildNodePackage {
    name = "underscore-1.4.4";
    version = "1.4.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
      name = "underscore-1.4.4.tgz";
      sha1 = "61a6a32010622afa07963bf325203cf12239d604";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."~1.4.3" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore.string"."~2.3.1" =
    self.by-version."underscore.string"."2.3.3";
  by-version."underscore.string"."2.3.3" = self.buildNodePackage {
    name = "underscore.string-2.3.3";
    version = "2.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz";
      name = "underscore.string-2.3.3.tgz";
      sha1 = "71c08bf6b428b1133f37e78fa3a21c82f7329b0d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."winston"."0.8.x" =
    self.by-version."winston"."0.8.3";
  by-version."winston"."0.8.3" = self.buildNodePackage {
    name = "winston-0.8.3";
    version = "0.8.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/winston/-/winston-0.8.3.tgz";
      name = "winston-0.8.3.tgz";
      sha1 = "64b6abf4cd01adcaefd5009393b1d8e8bec19db0";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = self.buildNodePackage {
    name = "wordwrap-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
      name = "wordwrap-0.0.2.tgz";
      sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = self.buildNodePackage {
    name = "wrappy-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
      name = "wrappy-1.0.1.tgz";
      sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."^4.0.0" =
    self.by-version."xtend"."4.0.0";
  by-version."xtend"."4.0.0" = self.buildNodePackage {
    name = "xtend-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xtend/-/xtend-4.0.0.tgz";
      name = "xtend-4.0.0.tgz";
      sha1 = "8bc36ff87aedbe7ce9eaf0bca36b2354a743840f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}

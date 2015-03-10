{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."CSSselect"."~0.4.0" =
    self.by-version."CSSselect"."0.4.1";
  by-version."CSSselect"."0.4.1" = self.buildNodePackage {
    name = "CSSselect-0.4.1";
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
    peerDependencies = [];
  };
  by-spec."CSSwhat"."0.4" =
    self.by-version."CSSwhat"."0.4.7";
  by-version."CSSwhat"."0.4.7" = self.buildNodePackage {
    name = "CSSwhat-0.4.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.7.tgz";
      name = "CSSwhat-0.4.7.tgz";
      sha1 = "867da0ff39f778613242c44cfea83f0aa4ebdf9b";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."argparse"."0.1.15" =
    self.by-version."argparse"."0.1.15";
  by-version."argparse"."0.1.15" = self.buildNodePackage {
    name = "argparse-0.1.15";
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
    peerDependencies = [];
  };
  "argparse" = self.by-version."argparse"."0.1.15";
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = self.buildNodePackage {
    name = "asn1-0.1.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
      name = "asn1-0.1.11.tgz";
      sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."assert-plus"."^0.1.5" =
    self.by-version."assert-plus"."0.1.5";
  by-version."assert-plus"."0.1.5" = self.buildNodePackage {
    name = "assert-plus-0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
      name = "assert-plus-0.1.5.tgz";
      sha1 = "ee74009413002d84cec7219c6ac811812e723160";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = self.buildNodePackage {
    name = "async-0.2.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
      name = "async-0.2.10.tgz";
      sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-version."async"."0.9.0" = self.buildNodePackage {
    name = "async-0.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
      name = "async-0.9.0.tgz";
      sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = self.buildNodePackage {
    name = "aws-sign2-0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
      name = "aws-sign2-0.5.0.tgz";
      sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."badnode"."^1.0.1" =
    self.by-version."badnode"."1.0.1";
  by-version."badnode"."1.0.1" = self.buildNodePackage {
    name = "badnode-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/badnode/-/badnode-1.0.1.tgz";
      name = "badnode-1.0.1.tgz";
      sha1 = "3f14123363badf4bed1acc8ed839ee99b27ad7e0";
    };
    deps = {
      "semver-4.3.1" = self.by-version."semver"."4.3.1";
    };
    peerDependencies = [];
  };
  "badnode" = self.by-version."badnode"."1.0.1";
  by-spec."balanced-match"."^0.2.0" =
    self.by-version."balanced-match"."0.2.0";
  by-version."balanced-match"."0.2.0" = self.buildNodePackage {
    name = "balanced-match-0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.2.0.tgz";
      name = "balanced-match-0.2.0.tgz";
      sha1 = "38f6730c03aab6d5edbb52bd934885e756d71674";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."bitcoyne".">=0.0.6" =
    self.by-version."bitcoyne"."1.0.1";
  by-version."bitcoyne"."1.0.1" = self.buildNodePackage {
    name = "bitcoyne-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bitcoyne/-/bitcoyne-1.0.1.tgz";
      name = "bitcoyne-1.0.1.tgz";
      sha1 = "5a775f93ccb8c4b7b26d4c2a44c25916783cf40e";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "kbpgp-2.0.8" = self.by-version."kbpgp"."2.0.8";
      "pgp-utils-0.0.27" = self.by-version."pgp-utils"."0.0.27";
    };
    peerDependencies = [];
  };
  "bitcoyne" = self.by-version."bitcoyne"."1.0.1";
  by-spec."bn"."^1.0.0" =
    self.by-version."bn"."1.0.1";
  by-version."bn"."1.0.1" = self.buildNodePackage {
    name = "bn-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bn/-/bn-1.0.1.tgz";
      name = "bn-1.0.1.tgz";
      sha1 = "a153825e6b1eb2c2db7726149b047a07ce0a3bb3";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."bn"."^1.0.1" =
    self.by-version."bn"."1.0.1";
  "bn" = self.by-version."bn"."1.0.1";
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = self.buildNodePackage {
    name = "boom-0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
      name = "boom-0.4.2.tgz";
      sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    peerDependencies = [];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.0";
  by-version."brace-expansion"."1.1.0" = self.buildNodePackage {
    name = "brace-expansion-1.1.0";
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
    peerDependencies = [];
  };
  by-spec."cheerio"."0.13.0" =
    self.by-version."cheerio"."0.13.0";
  by-version."cheerio"."0.13.0" = self.buildNodePackage {
    name = "cheerio-0.13.0";
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
    peerDependencies = [];
  };
  "cheerio" = self.by-version."cheerio"."0.13.0";
  by-spec."cli"."0.4.x" =
    self.by-version."cli"."0.4.5";
  by-version."cli"."0.4.5" = self.buildNodePackage {
    name = "cli-0.4.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cli/-/cli-0.4.5.tgz";
      name = "cli-0.4.5.tgz";
      sha1 = "78f9485cd161b566e9a6c72d7170c4270e81db61";
    };
    deps = {
      "glob-5.0.0" = self.by-version."glob"."5.0.0";
    };
    peerDependencies = [];
  };
  by-spec."cliff"."0.1.x" =
    self.by-version."cliff"."0.1.10";
  by-version."cliff"."0.1.10" = self.buildNodePackage {
    name = "cliff-0.1.10";
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
    peerDependencies = [];
  };
  by-spec."codesign"."0.0.9" =
    self.by-version."codesign"."0.0.9";
  by-version."codesign"."0.0.9" = self.buildNodePackage {
    name = "codesign-0.0.9";
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
    peerDependencies = [];
  };
  "codesign" = self.by-version."codesign"."0.0.9";
  by-spec."colors"."0.6.2" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = self.buildNodePackage {
    name = "colors-0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
      name = "colors-0.6.2.tgz";
      sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "colors" = self.by-version."colors"."0.6.2";
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-spec."colors".">=0.6.2" =
    self.by-version."colors"."1.0.3";
  by-version."colors"."1.0.3" = self.buildNodePackage {
    name = "colors-1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-1.0.3.tgz";
      name = "colors-1.0.3.tgz";
      sha1 = "0433f44d809680fdeb60ed260f1b0c262e82a40b";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."colors"."~0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."~1.0.3" =
    self.by-version."colors"."1.0.3";
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.7";
  by-version."combined-stream"."0.0.7" = self.buildNodePackage {
    name = "combined-stream-0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
      name = "combined-stream-0.0.7.tgz";
      sha1 = "0137e657baa5a7541c57ac37ac5fc07d73b4dc1f";
    };
    deps = {
      "delayed-stream-0.0.5" = self.by-version."delayed-stream"."0.0.5";
    };
    peerDependencies = [];
  };
  by-spec."commander".">= 0.5.2" =
    self.by-version."commander"."2.6.0";
  by-version."commander"."2.6.0" = self.buildNodePackage {
    name = "commander-2.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.6.0.tgz";
      name = "commander-2.6.0.tgz";
      sha1 = "9df7e52fb2a0cb0fb89058ee80c3104225f37e1d";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."commander"."~2.1.0" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = self.buildNodePackage {
    name = "commander-2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
      name = "commander-2.1.0.tgz";
      sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."concat-map"."0.0.1" =
    self.by-version."concat-map"."0.0.1";
  by-version."concat-map"."0.0.1" = self.buildNodePackage {
    name = "concat-map-0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
      name = "concat-map-0.0.1.tgz";
      sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = self.buildNodePackage {
    name = "core-util-is-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
      name = "core-util-is-1.0.1.tgz";
      sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = self.buildNodePackage {
    name = "cryptiles-0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
      name = "cryptiles-0.2.2.tgz";
      sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
    };
    deps = {
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
    };
    peerDependencies = [];
  };
  by-spec."ctype"."0.5.3" =
    self.by-version."ctype"."0.5.3";
  by-version."ctype"."0.5.3" = self.buildNodePackage {
    name = "ctype-0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
      name = "ctype-0.5.3.tgz";
      sha1 = "82c18c2461f74114ef16c135224ad0b9144ca12f";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = self.buildNodePackage {
    name = "cycle-1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
      name = "cycle-1.0.3.tgz";
      sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."deep-equal"."0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-version."deep-equal"."0.2.1" = self.buildNodePackage {
    name = "deep-equal-0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.1.tgz";
      name = "deep-equal-0.2.1.tgz";
      sha1 = "fad7a793224cbf0c3c7786f92ef780e4fc8cc878";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "deep-equal" = self.by-version."deep-equal"."0.2.1";
  by-spec."deep-equal".">=0.2.1" =
    self.by-version."deep-equal"."1.0.0";
  by-version."deep-equal"."1.0.0" = self.buildNodePackage {
    name = "deep-equal-1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-1.0.0.tgz";
      name = "deep-equal-1.0.0.tgz";
      sha1 = "d4564f07d2f0ab3e46110bec16592abd7dc2e326";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."deep-equal"."~0.2.1" =
    self.by-version."deep-equal"."0.2.2";
  by-version."deep-equal"."0.2.2" = self.buildNodePackage {
    name = "deep-equal-0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.2.tgz";
      name = "deep-equal-0.2.2.tgz";
      sha1 = "84b745896f34c684e98f2ce0e42abaf43bba017d";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = self.buildNodePackage {
    name = "delayed-stream-0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
      name = "delayed-stream-0.0.5.tgz";
      sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."docco"."~0.6.2" =
    self.by-version."docco"."0.6.3";
  by-version."docco"."0.6.3" = self.buildNodePackage {
    name = "docco-0.6.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/docco/-/docco-0.6.3.tgz";
      name = "docco-0.6.3.tgz";
      sha1 = "c47b5823d79563d6fc3abd49f3de48986e5522ee";
    };
    deps = {
      "commander-2.6.0" = self.by-version."commander"."2.6.0";
      "marked-0.3.3" = self.by-version."marked"."0.3.3";
      "fs-extra-0.16.4" = self.by-version."fs-extra"."0.16.4";
      "underscore-1.8.2" = self.by-version."underscore"."1.8.2";
      "highlight.js-8.4.0" = self.by-version."highlight.js"."8.4.0";
    };
    peerDependencies = [];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.3.0";
  by-version."domelementtype"."1.3.0" = self.buildNodePackage {
    name = "domelementtype-1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.3.0.tgz";
      name = "domelementtype-1.3.0.tgz";
      sha1 = "b17aed82e8ab59e52dd9c19b1756e0fc187204c2";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."domhandler"."2.2" =
    self.by-version."domhandler"."2.2.1";
  by-version."domhandler"."2.2.1" = self.buildNodePackage {
    name = "domhandler-2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domhandler/-/domhandler-2.2.1.tgz";
      name = "domhandler-2.2.1.tgz";
      sha1 = "59df9dcd227e808b365ae73e1f6684ac3d946fc2";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    peerDependencies = [];
  };
  by-spec."domutils"."1.3" =
    self.by-version."domutils"."1.3.0";
  by-version."domutils"."1.3.0" = self.buildNodePackage {
    name = "domutils-1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domutils/-/domutils-1.3.0.tgz";
      name = "domutils-1.3.0.tgz";
      sha1 = "9ad4d59b5af6ca684c62fe6d768ef170e70df192";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    peerDependencies = [];
  };
  by-spec."domutils"."1.4" =
    self.by-version."domutils"."1.4.3";
  by-version."domutils"."1.4.3" = self.buildNodePackage {
    name = "domutils-1.4.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domutils/-/domutils-1.4.3.tgz";
      name = "domutils-1.4.3.tgz";
      sha1 = "0865513796c6b306031850e175516baf80b72a6f";
    };
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    peerDependencies = [];
  };
  by-spec."entities"."0.x" =
    self.by-version."entities"."0.5.0";
  by-version."entities"."0.5.0" = self.buildNodePackage {
    name = "entities-0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/entities/-/entities-0.5.0.tgz";
      name = "entities-0.5.0.tgz";
      sha1 = "f611cb5ae221050e0012c66979503fd7ae19cc49";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = self.buildNodePackage {
    name = "eyes-0.1.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
      name = "eyes-0.1.8.tgz";
      sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."eyes"."~0.1.8" =
    self.by-version."eyes"."0.1.8";
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = self.buildNodePackage {
    name = "forever-agent-0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
      name = "forever-agent-0.5.2.tgz";
      sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.4";
  by-version."form-data"."0.1.4" = self.buildNodePackage {
    name = "form-data-0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-0.1.4.tgz";
      name = "form-data-0.1.4.tgz";
      sha1 = "91abd788aba9702b1aabfa8bc01031a2ac9e3b12";
    };
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [];
  };
  by-spec."framed-msgpack-rpc"."1.1.4" =
    self.by-version."framed-msgpack-rpc"."1.1.4";
  by-version."framed-msgpack-rpc"."1.1.4" = self.buildNodePackage {
    name = "framed-msgpack-rpc-1.1.4";
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
    peerDependencies = [];
  };
  "framed-msgpack-rpc" = self.by-version."framed-msgpack-rpc"."1.1.4";
  by-spec."fs-extra".">= 0.6.0" =
    self.by-version."fs-extra"."0.16.4";
  by-version."fs-extra"."0.16.4" = self.buildNodePackage {
    name = "fs-extra-0.16.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.16.4.tgz";
      name = "fs-extra-0.16.4.tgz";
      sha1 = "3e3d3cd6f388e2acbc0fc2e0202f0533ec0507b1";
    };
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "jsonfile-2.0.0" = self.by-version."jsonfile"."2.0.0";
      "rimraf-2.3.1" = self.by-version."rimraf"."2.3.1";
    };
    peerDependencies = [];
  };
  by-spec."glob".">= 3.1.4" =
    self.by-version."glob"."5.0.0";
  by-version."glob"."5.0.0" = self.buildNodePackage {
    name = "glob-5.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-5.0.0.tgz";
      name = "glob-5.0.0.tgz";
      sha1 = "bb00d4e340932eb101dc2a30e4127ddd51ed15ed";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.1" = self.by-version."minimatch"."2.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [];
  };
  by-spec."glob"."^4.4.2" =
    self.by-version."glob"."4.5.0";
  by-version."glob"."4.5.0" = self.buildNodePackage {
    name = "glob-4.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-4.5.0.tgz";
      name = "glob-4.5.0.tgz";
      sha1 = "d6511322e9d5c9bc689f20eb7348f00489723882";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.1" = self.by-version."minimatch"."2.0.1";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [];
  };
  by-spec."glob-to-regexp".">=0.0.1" =
    self.by-version."glob-to-regexp"."0.0.2";
  by-version."glob-to-regexp"."0.0.2" = self.buildNodePackage {
    name = "glob-to-regexp-0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.0.2.tgz";
      name = "glob-to-regexp-0.0.2.tgz";
      sha1 = "82cb3c797594b47890f180f015c1773601374b91";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."gpg-wrapper".">=1.0.3" =
    self.by-version."gpg-wrapper"."1.0.3";
  by-version."gpg-wrapper"."1.0.3" = self.buildNodePackage {
    name = "gpg-wrapper-1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gpg-wrapper/-/gpg-wrapper-1.0.3.tgz";
      name = "gpg-wrapper-1.0.3.tgz";
      sha1 = "826260e7ae53932f80574e04240bbb8999227cd1";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "iced-spawn-1.0.0" = self.by-version."iced-spawn"."1.0.0";
      "iced-utils-0.1.22" = self.by-version."iced-utils"."0.1.22";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "spotty-1.0.0" = self.by-version."spotty"."1.0.0";
    };
    peerDependencies = [];
  };
  "gpg-wrapper" = self.by-version."gpg-wrapper"."1.0.3";
  by-spec."graceful-fs"."^3.0.5" =
    self.by-version."graceful-fs"."3.0.5";
  by-version."graceful-fs"."3.0.5" = self.buildNodePackage {
    name = "graceful-fs-3.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.5.tgz";
      name = "graceful-fs-3.0.5.tgz";
      sha1 = "4a880474bdeb716fe3278cf29792dec38dfac418";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."hawk"."~1.0.0" =
    self.by-version."hawk"."1.0.0";
  by-version."hawk"."1.0.0" = self.buildNodePackage {
    name = "hawk-1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-1.0.0.tgz";
      name = "hawk-1.0.0.tgz";
      sha1 = "b90bb169807285411da7ffcb8dd2598502d3b52d";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
    };
    peerDependencies = [];
  };
  by-spec."highlight.js".">= 8.0.x" =
    self.by-version."highlight.js"."8.4.0";
  by-version."highlight.js"."8.4.0" = self.buildNodePackage {
    name = "highlight.js-8.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/highlight.js/-/highlight.js-8.4.0.tgz";
      name = "highlight.js-8.4.0.tgz";
      sha1 = "dc0d05b8dc9b110f13bce52cb96fd1e0c6bc791c";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = self.buildNodePackage {
    name = "hoek-0.9.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
      name = "hoek-0.9.1.tgz";
      sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."htmlparser2"."~3.4.0" =
    self.by-version."htmlparser2"."3.4.0";
  by-version."htmlparser2"."3.4.0" = self.buildNodePackage {
    name = "htmlparser2-3.4.0";
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
    peerDependencies = [];
  };
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.1";
  by-version."http-signature"."0.10.1" = self.buildNodePackage {
    name = "http-signature-0.10.1";
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
    peerDependencies = [];
  };
  by-spec."iced-coffee-script"."~1.7.1-c" =
    self.by-version."iced-coffee-script"."1.7.1-g";
  by-version."iced-coffee-script"."1.7.1-g" = self.buildNodePackage {
    name = "iced-coffee-script-1.7.1-g";
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
    peerDependencies = [];
  };
  "iced-coffee-script" = self.by-version."iced-coffee-script"."1.7.1-g";
  by-spec."iced-data-structures"."0.0.5" =
    self.by-version."iced-data-structures"."0.0.5";
  by-version."iced-data-structures"."0.0.5" = self.buildNodePackage {
    name = "iced-data-structures-0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-data-structures/-/iced-data-structures-0.0.5.tgz";
      name = "iced-data-structures-0.0.5.tgz";
      sha1 = "21de124f847fdeeb88f32cf232d3e3e600e05db4";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "iced-data-structures" = self.by-version."iced-data-structures"."0.0.5";
  by-spec."iced-db"."0.0.4" =
    self.by-version."iced-db"."0.0.4";
  by-version."iced-db"."0.0.4" = self.buildNodePackage {
    name = "iced-db-0.0.4";
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
    peerDependencies = [];
  };
  "iced-db" = self.by-version."iced-db"."0.0.4";
  by-spec."iced-error"."0.0.9" =
    self.by-version."iced-error"."0.0.9";
  by-version."iced-error"."0.0.9" = self.buildNodePackage {
    name = "iced-error-0.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-error/-/iced-error-0.0.9.tgz";
      name = "iced-error-0.0.9.tgz";
      sha1 = "c7c3057614c0a187d96b3d18c6d520e6b872ed37";
    };
    deps = {
    };
    peerDependencies = [];
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
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-expect/-/iced-expect-0.0.3.tgz";
      name = "iced-expect-0.0.3.tgz";
      sha1 = "206f271f27b200b9b538e2c0ca66a70209be1238";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "iced-expect" = self.by-version."iced-expect"."0.0.3";
  by-spec."iced-lock"."^1.0.1" =
    self.by-version."iced-lock"."1.0.1";
  by-version."iced-lock"."1.0.1" = self.buildNodePackage {
    name = "iced-lock-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-lock/-/iced-lock-1.0.1.tgz";
      name = "iced-lock-1.0.1.tgz";
      sha1 = "0914a61a4d3dec69db8f871ef40f95417fa38986";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    peerDependencies = [];
  };
  "iced-lock" = self.by-version."iced-lock"."1.0.1";
  by-spec."iced-logger"."0.0.5" =
    self.by-version."iced-logger"."0.0.5";
  by-version."iced-logger"."0.0.5" = self.buildNodePackage {
    name = "iced-logger-0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-logger/-/iced-logger-0.0.5.tgz";
      name = "iced-logger-0.0.5.tgz";
      sha1 = "501852a410691cf7e9542598e04dfbfdadc51486";
    };
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
    };
    peerDependencies = [];
  };
  "iced-logger" = self.by-version."iced-logger"."0.0.5";
  by-spec."iced-logger".">=0.0.3" =
    self.by-version."iced-logger"."0.0.6";
  by-version."iced-logger"."0.0.6" = self.buildNodePackage {
    name = "iced-logger-0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-logger/-/iced-logger-0.0.6.tgz";
      name = "iced-logger-0.0.6.tgz";
      sha1 = "3f38081e4df4742aab09b86bb0adf8ea6c12de82";
    };
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
    };
    peerDependencies = [];
  };
  by-spec."iced-runtime".">=0.0.1" =
    self.by-version."iced-runtime"."1.0.2";
  by-version."iced-runtime"."1.0.2" = self.buildNodePackage {
    name = "iced-runtime-1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-runtime/-/iced-runtime-1.0.2.tgz";
      name = "iced-runtime-1.0.2.tgz";
      sha1 = "a949a7cf49451175d3f6168d84997da27c4e6b70";
    };
    deps = {
    };
    peerDependencies = [];
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
  by-spec."iced-spawn".">=0.0.8" =
    self.by-version."iced-spawn"."1.0.0";
  by-version."iced-spawn"."1.0.0" = self.buildNodePackage {
    name = "iced-spawn-1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-spawn/-/iced-spawn-1.0.0.tgz";
      name = "iced-spawn-1.0.0.tgz";
      sha1 = "dab91968cb46f9c05baadd126a5abb53c5d7d1df";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "semver-4.3.1" = self.by-version."semver"."4.3.1";
    };
    peerDependencies = [];
  };
  by-spec."iced-spawn".">=1.0.0" =
    self.by-version."iced-spawn"."1.0.0";
  "iced-spawn" = self.by-version."iced-spawn"."1.0.0";
  by-spec."iced-test".">=0.0.16" =
    self.by-version."iced-test"."0.0.21";
  by-version."iced-test"."0.0.21" = self.buildNodePackage {
    name = "iced-test-0.0.21";
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
      "minimist-1.1.0" = self.by-version."minimist"."1.1.0";
    };
    peerDependencies = [];
  };
  "iced-test" = self.by-version."iced-test"."0.0.21";
  by-spec."iced-utils"."0.1.20" =
    self.by-version."iced-utils"."0.1.20";
  by-version."iced-utils"."0.1.20" = self.buildNodePackage {
    name = "iced-utils-0.1.20";
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
    peerDependencies = [];
  };
  "iced-utils" = self.by-version."iced-utils"."0.1.20";
  by-spec."iced-utils".">=0.1.11" =
    self.by-version."iced-utils"."0.1.22";
  by-version."iced-utils"."0.1.22" = self.buildNodePackage {
    name = "iced-utils-0.1.22";
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
    peerDependencies = [];
  };
  by-spec."iced-utils".">=0.1.16" =
    self.by-version."iced-utils"."0.1.22";
  by-spec."iced-utils".">=0.1.18" =
    self.by-version."iced-utils"."0.1.22";
  by-spec."inflight"."^1.0.4" =
    self.by-version."inflight"."1.0.4";
  by-version."inflight"."1.0.4" = self.buildNodePackage {
    name = "inflight-1.0.4";
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
    peerDependencies = [];
  };
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = self.buildNodePackage {
    name = "inherits-2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
      name = "inherits-2.0.1.tgz";
      sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ipv6"."~3.1.1" =
    self.by-version."ipv6"."3.1.1";
  by-version."ipv6"."3.1.1" = self.buildNodePackage {
    name = "ipv6-3.1.1";
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
    peerDependencies = [];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = self.buildNodePackage {
    name = "isarray-0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
      name = "isarray-0.0.1.tgz";
      sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."isstream"."0.1.x" =
    self.by-version."isstream"."0.1.1";
  by-version."isstream"."0.1.1" = self.buildNodePackage {
    name = "isstream-0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/isstream/-/isstream-0.1.1.tgz";
      name = "isstream-0.1.1.tgz";
      sha1 = "48332c5999893996ba253c81c7bd6e7ae0905c4f";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
      name = "json-stringify-safe-5.0.0.tgz";
      sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."jsonfile"."^2.0.0" =
    self.by-version."jsonfile"."2.0.0";
  by-version."jsonfile"."2.0.0" = self.buildNodePackage {
    name = "jsonfile-2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonfile/-/jsonfile-2.0.0.tgz";
      name = "jsonfile-2.0.0.tgz";
      sha1 = "c3944f350bd3c078b392e0aa1633b44662fcf06b";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."kbpgp".">=1.0.2" =
    self.by-version."kbpgp"."2.0.8";
  by-version."kbpgp"."2.0.8" = self.buildNodePackage {
    name = "kbpgp-2.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/kbpgp/-/kbpgp-2.0.8.tgz";
      name = "kbpgp-2.0.8.tgz";
      sha1 = "5ede9539bce3564a53f8be72a75c7619414b6e08";
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
    peerDependencies = [];
  };
  "kbpgp" = self.by-version."kbpgp"."2.0.8";
  by-spec."kbpgp"."^1.0.2" =
    self.by-version."kbpgp"."1.2.0";
  by-version."kbpgp"."1.2.0" = self.buildNodePackage {
    name = "kbpgp-1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/kbpgp/-/kbpgp-1.2.0.tgz";
      name = "kbpgp-1.2.0.tgz";
      sha1 = "4305a67a740fb31843b4313b60a6137f2b93ddba";
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
    peerDependencies = [];
  };
  by-spec."kbpgp"."^2.0.0" =
    self.by-version."kbpgp"."2.0.8";
  by-spec."keybase-compressjs"."^1.0.1-c" =
    self.by-version."keybase-compressjs"."1.0.1-c";
  by-version."keybase-compressjs"."1.0.1-c" = self.buildNodePackage {
    name = "keybase-compressjs-1.0.1-c";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-compressjs/-/keybase-compressjs-1.0.1-c.tgz";
      name = "keybase-compressjs-1.0.1-c.tgz";
      sha1 = "dc664a7f5d95584a534622a260297532f3ce9f9f";
    };
    deps = {
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
    };
    peerDependencies = [];
  };
  by-spec."keybase-ecurve"."^1.0.0" =
    self.by-version."keybase-ecurve"."1.0.0";
  by-version."keybase-ecurve"."1.0.0" = self.buildNodePackage {
    name = "keybase-ecurve-1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-ecurve/-/keybase-ecurve-1.0.0.tgz";
      name = "keybase-ecurve-1.0.0.tgz";
      sha1 = "c6bc72adda4603fd3184fee7e99694ed8fd69ad2";
    };
    deps = {
      "bn-1.0.1" = self.by-version."bn"."1.0.1";
    };
    peerDependencies = [];
  };
  by-spec."keybase-path"."0.0.15" =
    self.by-version."keybase-path"."0.0.15";
  by-version."keybase-path"."0.0.15" = self.buildNodePackage {
    name = "keybase-path-0.0.15";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-path/-/keybase-path-0.0.15.tgz";
      name = "keybase-path-0.0.15.tgz";
      sha1 = "94b95448fc4edf73e096366279bd28a469d5f72f";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    peerDependencies = [];
  };
  "keybase-path" = self.by-version."keybase-path"."0.0.15";
  by-spec."keybase-proofs"."^2.0.13" =
    self.by-version."keybase-proofs"."2.0.15";
  by-version."keybase-proofs"."2.0.15" = self.buildNodePackage {
    name = "keybase-proofs-2.0.15";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-proofs/-/keybase-proofs-2.0.15.tgz";
      name = "keybase-proofs-2.0.15.tgz";
      sha1 = "d9e0c265e005095f749058825a7f0db3ab5bcedc";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "triplesec-3.0.19" = self.by-version."triplesec"."3.0.19";
    };
    peerDependencies = [];
  };
  "keybase-proofs" = self.by-version."keybase-proofs"."2.0.15";
  by-spec."libkeybase"."^0.0.6" =
    self.by-version."libkeybase"."0.0.6";
  by-version."libkeybase"."0.0.6" = self.buildNodePackage {
    name = "libkeybase-0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/libkeybase/-/libkeybase-0.0.6.tgz";
      name = "libkeybase-0.0.6.tgz";
      sha1 = "03d19afe7ca48ca041d962f0885d373faca2e90e";
    };
    deps = {
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-logger-0.0.5" = self.by-version."iced-logger"."0.0.5";
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
      "kbpgp-1.2.0" = self.by-version."kbpgp"."1.2.0";
      "tweetnacl-0.12.2" = self.by-version."tweetnacl"."0.12.2";
    };
    peerDependencies = [];
  };
  "libkeybase" = self.by-version."libkeybase"."0.0.6";
  by-spec."marked".">= 0.2.7" =
    self.by-version."marked"."0.3.3";
  by-version."marked"."0.3.3" = self.buildNodePackage {
    name = "marked-0.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/marked/-/marked-0.3.3.tgz";
      name = "marked-0.3.3.tgz";
      sha1 = "08bad9cac13736f6cceddc202344f1b0bf255390";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."merkle-tree"."0.0.12" =
    self.by-version."merkle-tree"."0.0.12";
  by-version."merkle-tree"."0.0.12" = self.buildNodePackage {
    name = "merkle-tree-0.0.12";
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
    peerDependencies = [];
  };
  "merkle-tree" = self.by-version."merkle-tree"."0.0.12";
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = self.buildNodePackage {
    name = "mime-1.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
      name = "mime-1.2.11.tgz";
      sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."mime"."~1.2.9" =
    self.by-version."mime"."1.2.11";
  by-spec."minimatch"."^2.0.1" =
    self.by-version."minimatch"."2.0.1";
  by-version."minimatch"."2.0.1" = self.buildNodePackage {
    name = "minimatch-2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-2.0.1.tgz";
      name = "minimatch-2.0.1.tgz";
      sha1 = "6c3760b45f66ed1cd5803143ee8d372488f02c37";
    };
    deps = {
      "brace-expansion-1.1.0" = self.by-version."brace-expansion"."1.1.0";
    };
    peerDependencies = [];
  };
  by-spec."minimist".">=0.0.8" =
    self.by-version."minimist"."1.1.0";
  by-version."minimist"."1.1.0" = self.buildNodePackage {
    name = "minimist-1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-1.1.0.tgz";
      name = "minimist-1.1.0.tgz";
      sha1 = "cdf225e8898f840a258ded44fc91776770afdc93";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = self.buildNodePackage {
    name = "minimist-0.0.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
      name = "minimist-0.0.10.tgz";
      sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."mkdirp"."0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = self.buildNodePackage {
    name = "mkdirp-0.3.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
      name = "mkdirp-0.3.5.tgz";
      sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "mkdirp" = self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."more-entropy".">=0.0.7" =
    self.by-version."more-entropy"."0.0.7";
  by-version."more-entropy"."0.0.7" = self.buildNodePackage {
    name = "more-entropy-0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/more-entropy/-/more-entropy-0.0.7.tgz";
      name = "more-entropy-0.0.7.tgz";
      sha1 = "67bfc6f7a86f26fbc37aac83fd46d88c61d109b5";
    };
    deps = {
      "iced-runtime-1.0.2" = self.by-version."iced-runtime"."1.0.2";
    };
    peerDependencies = [];
  };
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = self.buildNodePackage {
    name = "mute-stream-0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
      name = "mute-stream-0.0.4.tgz";
      sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."network-byte-order"."~0.2.0" =
    self.by-version."network-byte-order"."0.2.0";
  by-version."network-byte-order"."0.2.0" = self.buildNodePackage {
    name = "network-byte-order-0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/network-byte-order/-/network-byte-order-0.2.0.tgz";
      name = "network-byte-order-0.2.0.tgz";
      sha1 = "6ac11bf44bf610daeddbe90a09a5c817c6e0d2b3";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.3";
  by-version."node-uuid"."1.4.3" = self.buildNodePackage {
    name = "node-uuid-1.4.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.3.tgz";
      name = "node-uuid-1.4.3.tgz";
      sha1 = "319bb7a56e7cb63f00b5c0cd7851cd4b4ddf1df9";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."oauth-sign"."~0.3.0" =
    self.by-version."oauth-sign"."0.3.0";
  by-version."oauth-sign"."0.3.0" = self.buildNodePackage {
    name = "oauth-sign-0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
      name = "oauth-sign-0.3.0.tgz";
      sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.1";
  by-version."once"."1.3.1" = self.buildNodePackage {
    name = "once-1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/once/-/once-1.3.1.tgz";
      name = "once-1.3.1.tgz";
      sha1 = "f3f3e4da5b7d27b5c732969ee3e67e729457b31f";
    };
    deps = {
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    peerDependencies = [];
  };
  by-spec."optimist"."0.6.1" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = self.buildNodePackage {
    name = "optimist-0.6.1";
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
    peerDependencies = [];
  };
  "optimist" = self.by-version."optimist"."0.6.1";
  by-spec."pgp-utils"."0.0.27" =
    self.by-version."pgp-utils"."0.0.27";
  by-version."pgp-utils"."0.0.27" = self.buildNodePackage {
    name = "pgp-utils-0.0.27";
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
    peerDependencies = [];
  };
  by-spec."pgp-utils".">=0.0.21" =
    self.by-version."pgp-utils"."0.0.28";
  by-version."pgp-utils"."0.0.28" = self.buildNodePackage {
    name = "pgp-utils-0.0.28";
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
    peerDependencies = [];
  };
  by-spec."pgp-utils".">=0.0.22" =
    self.by-version."pgp-utils"."0.0.28";
  "pgp-utils" = self.by-version."pgp-utils"."0.0.28";
  by-spec."pgp-utils".">=0.0.25" =
    self.by-version."pgp-utils"."0.0.28";
  by-spec."pgp-utils".">=0.0.28" =
    self.by-version."pgp-utils"."0.0.28";
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = self.buildNodePackage {
    name = "pkginfo-0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
      name = "pkginfo-0.3.0.tgz";
      sha1 = "726411401039fe9b009eea86614295d5f3a54276";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."progress"."1.1.3" =
    self.by-version."progress"."1.1.3";
  by-version."progress"."1.1.3" = self.buildNodePackage {
    name = "progress-1.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/progress/-/progress-1.1.3.tgz";
      name = "progress-1.1.3.tgz";
      sha1 = "42f89c5fc3b6f0408a0bdd68993b174f96aababf";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "progress" = self.by-version."progress"."1.1.3";
  by-spec."progress"."~1.1.2" =
    self.by-version."progress"."1.1.8";
  by-version."progress"."1.1.8" = self.buildNodePackage {
    name = "progress-1.1.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/progress/-/progress-1.1.8.tgz";
      name = "progress-1.1.8.tgz";
      sha1 = "e260c78f6161cdd9b0e56cc3e0a85de17c7a57be";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = self.buildNodePackage {
    name = "punycode-1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
      name = "punycode-1.3.2.tgz";
      sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."purepack"."1.0.1" =
    self.by-version."purepack"."1.0.1";
  by-version."purepack"."1.0.1" = self.buildNodePackage {
    name = "purepack-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/purepack/-/purepack-1.0.1.tgz";
      name = "purepack-1.0.1.tgz";
      sha1 = "9592f35bc22279a777885d3de04acc3555994f68";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "purepack" = self.by-version."purepack"."1.0.1";
  by-spec."purepack".">=1" =
    self.by-version."purepack"."1.0.1";
  by-spec."purepack".">=1.0.1" =
    self.by-version."purepack"."1.0.1";
  by-spec."qs"."~0.6.0" =
    self.by-version."qs"."0.6.6";
  by-version."qs"."0.6.6" = self.buildNodePackage {
    name = "qs-0.6.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
      name = "qs-0.6.6.tgz";
      sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."read"."keybase/read" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = self.buildNodePackage {
    name = "read-1.0.5";
    bin = false;
    src = fetchgit {
      url = "git://github.com/keybase/read";
      rev = "740ae6a1a72a96984ae3527eb0ce0066c9fc8d47";
      sha256 = "927ce6e6e88c80c54b434261afb5717630568b6979afffc6828c4fc0335e22ec";
    };
    deps = {
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
    };
    peerDependencies = [];
  };
  "read" = self.by-version."read"."1.0.5";
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-version."readable-stream"."1.1.13" = self.buildNodePackage {
    name = "readable-stream-1.1.13";
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
    peerDependencies = [];
  };
  by-spec."request"."2.30.0" =
    self.by-version."request"."2.30.0";
  by-version."request"."2.30.0" = self.buildNodePackage {
    name = "request-2.30.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.30.0.tgz";
      name = "request-2.30.0.tgz";
      sha1 = "8e0d36f0806e8911524b072b64c5ee535a09d861";
    };
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "tough-cookie-0.9.15" = self.by-version."tough-cookie"."0.9.15";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tunnel-agent-0.3.0" = self.by-version."tunnel-agent"."0.3.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "hawk-1.0.0" = self.by-version."hawk"."1.0.0";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
    };
    peerDependencies = [];
  };
  "request" = self.by-version."request"."2.30.0";
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.3.1";
  by-version."rimraf"."2.3.1" = self.buildNodePackage {
    name = "rimraf-2.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.3.1.tgz";
      name = "rimraf-2.3.1.tgz";
      sha1 = "f83df78c168d5daf9f021e8e092e7a165898ee75";
    };
    deps = {
      "glob-4.5.0" = self.by-version."glob"."4.5.0";
    };
    peerDependencies = [];
  };
  by-spec."semver".">=2.2.1" =
    self.by-version."semver"."4.3.1";
  by-version."semver"."4.3.1" = self.buildNodePackage {
    name = "semver-4.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-4.3.1.tgz";
      name = "semver-4.3.1.tgz";
      sha1 = "beb0129575b95f76110b29af08d370fd9eeb34bf";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."semver"."^4.0.0" =
    self.by-version."semver"."4.3.1";
  "semver" = self.by-version."semver"."4.3.1";
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = self.buildNodePackage {
    name = "sntp-0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
      name = "sntp-0.2.4.tgz";
      sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    peerDependencies = [];
  };
  by-spec."socks5-client"."0.x" =
    self.by-version."socks5-client"."0.3.6";
  by-version."socks5-client"."0.3.6" = self.buildNodePackage {
    name = "socks5-client-0.3.6";
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
    peerDependencies = [];
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
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socks5-http-client/-/socks5-http-client-0.1.6.tgz";
      name = "socks5-http-client-0.1.6.tgz";
      sha1 = "a915ba75573787876e5d3756ee4a81d60cd4b69b";
    };
    deps = {
      "socks5-client-0.3.6" = self.by-version."socks5-client"."0.3.6";
    };
    peerDependencies = [];
  };
  "socks5-http-client" = self.by-version."socks5-http-client"."0.1.6";
  by-spec."socks5-https-client"."^0.2.2" =
    self.by-version."socks5-https-client"."0.2.2";
  by-version."socks5-https-client"."0.2.2" = self.buildNodePackage {
    name = "socks5-https-client-0.2.2";
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
    peerDependencies = [];
  };
  "socks5-https-client" = self.by-version."socks5-https-client"."0.2.2";
  by-spec."spotty"."^1.0.0" =
    self.by-version."spotty"."1.0.0";
  by-version."spotty"."1.0.0" = self.buildNodePackage {
    name = "spotty-1.0.0";
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
    peerDependencies = [];
  };
  "spotty" = self.by-version."spotty"."1.0.0";
  by-spec."sprintf"."0.1.x" =
    self.by-version."sprintf"."0.1.5";
  by-version."sprintf"."0.1.5" = self.buildNodePackage {
    name = "sprintf-0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sprintf/-/sprintf-0.1.5.tgz";
      name = "sprintf-0.1.5.tgz";
      sha1 = "8f83e39a9317c1a502cb7db8050e51c679f6edcf";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = self.buildNodePackage {
    name = "stack-trace-0.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
      name = "stack-trace-0.0.9.tgz";
      sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."starttls"."0.x" =
    self.by-version."starttls"."0.2.1";
  by-version."starttls"."0.2.1" = self.buildNodePackage {
    name = "starttls-0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/starttls/-/starttls-0.2.1.tgz";
      name = "starttls-0.2.1.tgz";
      sha1 = "b98d3e5e778d46f199c843a64f889f0347c6d19a";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = self.buildNodePackage {
    name = "string_decoder-0.10.31";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
      name = "string_decoder-0.10.31.tgz";
      sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."tablify"."0.1.5" =
    self.by-version."tablify"."0.1.5";
  by-version."tablify"."0.1.5" = self.buildNodePackage {
    name = "tablify-0.1.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tablify/-/tablify-0.1.5.tgz";
      name = "tablify-0.1.5.tgz";
      sha1 = "47160ce2918be291d63cecceddb5254dd72982c7";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "tablify" = self.by-version."tablify"."0.1.5";
  by-spec."tablify".">=0.1.5" =
    self.by-version."tablify"."0.1.5";
  by-spec."timeago"."0.1.0" =
    self.by-version."timeago"."0.1.0";
  by-version."timeago"."0.1.0" = self.buildNodePackage {
    name = "timeago-0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/timeago/-/timeago-0.1.0.tgz";
      name = "timeago-0.1.0.tgz";
      sha1 = "21176a84d469be35ee431c5c48c0b6aba1f72464";
    };
    deps = {
    };
    peerDependencies = [];
  };
  "timeago" = self.by-version."timeago"."0.1.0";
  by-spec."tough-cookie"."~0.9.15" =
    self.by-version."tough-cookie"."0.9.15";
  by-version."tough-cookie"."0.9.15" = self.buildNodePackage {
    name = "tough-cookie-0.9.15";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.9.15.tgz";
      name = "tough-cookie-0.9.15.tgz";
      sha1 = "75617ac347e3659052b0350131885829677399f6";
    };
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
    };
    peerDependencies = [];
  };
  by-spec."triplesec".">=3.0.16" =
    self.by-version."triplesec"."3.0.19";
  by-version."triplesec"."3.0.19" = self.buildNodePackage {
    name = "triplesec-3.0.19";
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
    peerDependencies = [];
  };
  "triplesec" = self.by-version."triplesec"."3.0.19";
  by-spec."triplesec".">=3.0.19" =
    self.by-version."triplesec"."3.0.19";
  by-spec."tunnel-agent"."~0.3.0" =
    self.by-version."tunnel-agent"."0.3.0";
  by-version."tunnel-agent"."0.3.0" = self.buildNodePackage {
    name = "tunnel-agent-0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.3.0.tgz";
      name = "tunnel-agent-0.3.0.tgz";
      sha1 = "ad681b68f5321ad2827c4cfb1b7d5df2cfe942ee";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."tweetnacl"."^0.12.0" =
    self.by-version."tweetnacl"."0.12.2";
  by-version."tweetnacl"."0.12.2" = self.buildNodePackage {
    name = "tweetnacl-0.12.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tweetnacl/-/tweetnacl-0.12.2.tgz";
      name = "tweetnacl-0.12.2.tgz";
      sha1 = "bd59f890507856fb0a1136acc3a8b44547e29ddb";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."tweetnacl"."^0.12.2" =
    self.by-version."tweetnacl"."0.12.2";
  by-spec."underscore".">= 1.0.0" =
    self.by-version."underscore"."1.8.2";
  by-version."underscore"."1.8.2" = self.buildNodePackage {
    name = "underscore-1.8.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.8.2.tgz";
      name = "underscore-1.8.2.tgz";
      sha1 = "64df2eb590899de950782f3735190ba42ebf311d";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."underscore"."~1.4" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = self.buildNodePackage {
    name = "underscore-1.4.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
      name = "underscore-1.4.4.tgz";
      sha1 = "61a6a32010622afa07963bf325203cf12239d604";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."underscore"."~1.4.3" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore.string"."~2.3.1" =
    self.by-version."underscore.string"."2.3.3";
  by-version."underscore.string"."2.3.3" = self.buildNodePackage {
    name = "underscore.string-2.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz";
      name = "underscore.string-2.3.3.tgz";
      sha1 = "71c08bf6b428b1133f37e78fa3a21c82f7329b0d";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."winston"."0.8.x" =
    self.by-version."winston"."0.8.3";
  by-version."winston"."0.8.3" = self.buildNodePackage {
    name = "winston-0.8.3";
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
      "isstream-0.1.1" = self.by-version."isstream"."0.1.1";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [];
  };
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = self.buildNodePackage {
    name = "wordwrap-0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
      name = "wordwrap-0.0.2.tgz";
      sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
    };
    deps = {
    };
    peerDependencies = [];
  };
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = self.buildNodePackage {
    name = "wrappy-1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
      name = "wrappy-1.0.1.tgz";
      sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
    };
    deps = {
    };
    peerDependencies = [];
  };
}

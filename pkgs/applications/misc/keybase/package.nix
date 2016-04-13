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
  by-spec."ansi-regex"."^2.0.0" =
    self.by-version."ansi-regex"."2.0.0";
  by-version."ansi-regex"."2.0.0" = self.buildNodePackage {
    name = "ansi-regex-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
      name = "ansi-regex-2.0.0.tgz";
      sha1 = "c5061b6e0ef8a81775e50f5d66151bf6bf371107";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-styles"."^2.1.0" =
    self.by-version."ansi-styles"."2.1.0";
  by-version."ansi-styles"."2.1.0" = self.buildNodePackage {
    name = "ansi-styles-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.1.0.tgz";
      name = "ansi-styles-2.1.0.tgz";
      sha1 = "990f747146927b559a932bf92959163d60c0d0e2";
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
  by-spec."asn1".">=0.2.3 <0.3.0" =
    self.by-version."asn1"."0.2.3";
  by-version."asn1"."0.2.3" = self.buildNodePackage {
    name = "asn1-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz";
      name = "asn1-0.2.3.tgz";
      sha1 = "dac8787713c9966849fc8180777ebe9c1ddf3b86";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus".">=0.2.0 <0.3.0" =
    self.by-version."assert-plus"."0.2.0";
  by-version."assert-plus"."0.2.0" = self.buildNodePackage {
    name = "assert-plus-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.2.0.tgz";
      name = "assert-plus-0.2.0.tgz";
      sha1 = "d74e1b87e7affc0db8aadb7021f3fe48101ab234";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."assert-plus"."^0.2.0" =
    self.by-version."assert-plus"."0.2.0";
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
  by-spec."async"."^1.4.0" =
    self.by-version."async"."1.5.2";
  by-version."async"."1.5.2" = self.buildNodePackage {
    name = "async-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-1.5.2.tgz";
      name = "async-1.5.2.tgz";
      sha1 = "ec6a61ae56480c0c3cb241c95618e20892f9672a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws-sign2"."~0.6.0" =
    self.by-version."aws-sign2"."0.6.0";
  by-version."aws-sign2"."0.6.0" = self.buildNodePackage {
    name = "aws-sign2-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz";
      name = "aws-sign2-0.6.0.tgz";
      sha1 = "14342dd38dbcc94d0e5b87d763cd63612c0e794f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aws4"."^1.2.1" =
    self.by-version."aws4"."1.2.1";
  by-version."aws4"."1.2.1" = self.buildNodePackage {
    name = "aws4-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/aws4/-/aws4-1.2.1.tgz";
      name = "aws4-1.2.1.tgz";
      sha1 = "52b5659a4d32583d405f65e1124ac436d07fe5ac";
    };
    deps = {
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
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
      "semver-4.3.6" = self.by-version."semver"."4.3.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "badnode" = self.by-version."badnode"."1.0.1";
  by-spec."balanced-match"."^0.3.0" =
    self.by-version."balanced-match"."0.3.0";
  by-version."balanced-match"."0.3.0" = self.buildNodePackage {
    name = "balanced-match-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.3.0.tgz";
      name = "balanced-match-0.3.0.tgz";
      sha1 = "a91cdd1ebef1a86659e70ff4def01625fc2d6756";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "kbpgp-2.0.50" = self.by-version."kbpgp"."2.0.50";
      "pgp-utils-0.0.27" = self.by-version."pgp-utils"."0.0.27";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bitcoyne" = self.by-version."bitcoyne"."1.0.1";
  by-spec."bl"."~1.0.0" =
    self.by-version."bl"."1.0.2";
  by-version."bl"."1.0.2" = self.buildNodePackage {
    name = "bl-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bl/-/bl-1.0.2.tgz";
      name = "bl-1.0.2.tgz";
      sha1 = "8c66490d825ba84d560de1f62196a29555b3a0c4";
    };
    deps = {
      "readable-stream-2.0.5" = self.by-version."readable-stream"."2.0.5";
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
    self.by-version."boom"."2.10.1";
  by-version."boom"."2.10.1" = self.buildNodePackage {
    name = "boom-2.10.1";
    version = "2.10.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-2.10.1.tgz";
      name = "boom-2.10.1.tgz";
      sha1 = "39c8918ceff5799f83f9492a848f625add0c766f";
    };
    deps = {
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.2";
  by-version."brace-expansion"."1.1.2" = self.buildNodePackage {
    name = "brace-expansion-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.2.tgz";
      name = "brace-expansion-1.1.2.tgz";
      sha1 = "f21445d0488b658e2771efd870eff51df29f04ef";
    };
    deps = {
      "balanced-match-0.3.0" = self.by-version."balanced-match"."0.3.0";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bzip-deflate"."^1.0.0" =
    self.by-version."bzip-deflate"."1.0.0";
  by-version."bzip-deflate"."1.0.0" = self.buildNodePackage {
    name = "bzip-deflate-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bzip-deflate/-/bzip-deflate-1.0.0.tgz";
      name = "bzip-deflate-1.0.0.tgz";
      sha1 = "b02db007ef37bebcc29384a4b2c6f4f0f4c796c9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.11.0" =
    self.by-version."caseless"."0.11.0";
  by-version."caseless"."0.11.0" = self.buildNodePackage {
    name = "caseless-0.11.0";
    version = "0.11.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
      name = "caseless-0.11.0.tgz";
      sha1 = "715b96ea9841593cc33067923f5ec60ebda4f7d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."^1.1.1" =
    self.by-version."chalk"."1.1.1";
  by-version."chalk"."1.1.1" = self.buildNodePackage {
    name = "chalk-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-1.1.1.tgz";
      name = "chalk-1.1.1.tgz";
      sha1 = "509afb67066e7499f7eb3535c77445772ae2d019";
    };
    deps = {
      "ansi-styles-2.1.0" = self.by-version."ansi-styles"."2.1.0";
      "escape-string-regexp-1.0.4" = self.by-version."escape-string-regexp"."1.0.4";
      "has-ansi-2.0.0" = self.by-version."has-ansi"."2.0.0";
      "strip-ansi-3.0.0" = self.by-version."strip-ansi"."3.0.0";
      "supports-color-2.0.0" = self.by-version."supports-color"."2.0.0";
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
      "glob-6.0.4" = self.by-version."glob"."6.0.4";
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
      "glob-to-regexp-0.1.0" = self.by-version."glob-to-regexp"."0.1.0";
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
    self.by-version."colors"."1.1.2";
  by-version."colors"."1.1.2" = self.buildNodePackage {
    name = "colors-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/colors/-/colors-1.1.2.tgz";
      name = "colors-1.1.2.tgz";
      sha1 = "168a4701756b6a7f51a12ce0c97bfa28c084ed63";
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
  by-spec."combined-stream"."^1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-version."combined-stream"."1.0.5" = self.buildNodePackage {
    name = "combined-stream-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
      name = "combined-stream-1.0.5.tgz";
      sha1 = "938370a57b4a51dea2c77c15d5c5fdf895164009";
    };
    deps = {
      "delayed-stream-1.0.0" = self.by-version."delayed-stream"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."combined-stream"."~1.0.5" =
    self.by-version."combined-stream"."1.0.5";
  by-spec."commander".">= 0.5.2" =
    self.by-version."commander"."2.9.0";
  by-version."commander"."2.9.0" = self.buildNodePackage {
    name = "commander-2.9.0";
    version = "2.9.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
      name = "commander-2.9.0.tgz";
      sha1 = "9c99094176e12240cb22d6c5146098400fe0f7d4";
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
  by-spec."commander"."^2.9.0" =
    self.by-version."commander"."2.9.0";
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
    self.by-version."core-util-is"."1.0.2";
  by-version."core-util-is"."1.0.2" = self.buildNodePackage {
    name = "core-util-is-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
      name = "core-util-is-1.0.2.tgz";
      sha1 = "b5fd54220aa2bc5ab57aab7140c940754503c1a7";
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
    self.by-version."cryptiles"."2.0.5";
  by-version."cryptiles"."2.0.5" = self.buildNodePackage {
    name = "cryptiles-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
      name = "cryptiles-2.0.5.tgz";
      sha1 = "3bdfecdc608147c1c67202fa291e7dca59eaa3b8";
    };
    deps = {
      "boom-2.10.1" = self.by-version."boom"."2.10.1";
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
  by-spec."dashdash".">=1.10.1 <2.0.0" =
    self.by-version."dashdash"."1.12.2";
  by-version."dashdash"."1.12.2" = self.buildNodePackage {
    name = "dashdash-1.12.2";
    version = "1.12.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dashdash/-/dashdash-1.12.2.tgz";
      name = "dashdash-1.12.2.tgz";
      sha1 = "1c6f70588498d047b8cd5777b32ba85a5e25be36";
    };
    deps = {
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
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
    self.by-version."deep-equal"."1.0.1";
  by-version."deep-equal"."1.0.1" = self.buildNodePackage {
    name = "deep-equal-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-1.0.1.tgz";
      name = "deep-equal-1.0.1.tgz";
      sha1 = "f5d260292b660e084eff4cdbc9f08ad3247448b5";
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
  by-spec."delayed-stream"."~1.0.0" =
    self.by-version."delayed-stream"."1.0.0";
  by-version."delayed-stream"."1.0.0" = self.buildNodePackage {
    name = "delayed-stream-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
      name = "delayed-stream-1.0.0.tgz";
      sha1 = "df3ae199acadfb7d440aaae0b29e2272b24ec619";
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
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "marked-0.3.5" = self.by-version."marked"."0.3.5";
      "fs-extra-0.26.5" = self.by-version."fs-extra"."0.26.5";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
      "highlight.js-9.1.0" = self.by-version."highlight.js"."9.1.0";
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
  by-spec."ecc-jsbn".">=0.0.1 <1.0.0" =
    self.by-version."ecc-jsbn"."0.1.1";
  by-version."ecc-jsbn"."0.1.1" = self.buildNodePackage {
    name = "ecc-jsbn-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
      name = "ecc-jsbn-0.1.1.tgz";
      sha1 = "0fc73a9ed5f0d53c38193398523ef7e543777505";
    };
    deps = {
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
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
    self.by-version."escape-string-regexp"."1.0.4";
  by-version."escape-string-regexp"."1.0.4" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.4.tgz";
      name = "escape-string-regexp-1.0.4.tgz";
      sha1 = "b85e679b46f72d03fbbe8a3bf7259d535c21b62f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extend"."~3.0.0" =
    self.by-version."extend"."3.0.0";
  by-version."extend"."3.0.0" = self.buildNodePackage {
    name = "extend-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
      name = "extend-3.0.0.tgz";
      sha1 = "5a474353b9f3353ddd8176dfd37b91c83a46f1d4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extsprintf"."1.0.2" =
    self.by-version."extsprintf"."1.0.2";
  by-version."extsprintf"."1.0.2" = self.buildNodePackage {
    name = "extsprintf-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
      name = "extsprintf-1.0.2.tgz";
      sha1 = "e1080e0658e300b06294990cc70e1502235fd550";
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
  by-spec."forever-agent"."~0.6.1" =
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
  by-spec."form-data"."~1.0.0-rc3" =
    self.by-version."form-data"."1.0.0-rc3";
  by-version."form-data"."1.0.0-rc3" = self.buildNodePackage {
    name = "form-data-1.0.0-rc3";
    version = "1.0.0-rc3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc3.tgz";
      name = "form-data-1.0.0-rc3.tgz";
      sha1 = "d35bc62e7fbc2937ae78f948aaa0d38d90607577";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.9" = self.by-version."mime-types"."2.1.9";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "purepack-1.0.4" = self.by-version."purepack"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "framed-msgpack-rpc" = self.by-version."framed-msgpack-rpc"."1.1.4";
  by-spec."fs-extra".">= 0.6.0" =
    self.by-version."fs-extra"."0.26.5";
  by-version."fs-extra"."0.26.5" = self.buildNodePackage {
    name = "fs-extra-0.26.5";
    version = "0.26.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.26.5.tgz";
      name = "fs-extra-0.26.5.tgz";
      sha1 = "53ac74667ca083fd2dc1712c813039ca32d69a7f";
    };
    deps = {
      "graceful-fs-4.1.3" = self.by-version."graceful-fs"."4.1.3";
      "jsonfile-2.2.3" = self.by-version."jsonfile"."2.2.3";
      "klaw-1.1.3" = self.by-version."klaw"."1.1.3";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
      "rimraf-2.5.1" = self.by-version."rimraf"."2.5.1";
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
    self.by-version."generate-object-property"."1.2.0";
  by-version."generate-object-property"."1.2.0" = self.buildNodePackage {
    name = "generate-object-property-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
      name = "generate-object-property-1.2.0.tgz";
      sha1 = "9c0e1c40308ce804f4783618b937fa88f99d50d0";
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
  by-spec."glob".">= 3.1.4" =
    self.by-version."glob"."6.0.4";
  by-version."glob"."6.0.4" = self.buildNodePackage {
    name = "glob-6.0.4";
    version = "6.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-6.0.4.tgz";
      name = "glob-6.0.4.tgz";
      sha1 = "0f08860f6a155127b2fadd4f9ce24b1aab6e4d22";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-3.0.0" = self.by-version."minimatch"."3.0.0";
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "path-is-absolute-1.0.0" = self.by-version."path-is-absolute"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^6.0.1" =
    self.by-version."glob"."6.0.4";
  by-spec."glob-to-regexp".">=0.0.1" =
    self.by-version."glob-to-regexp"."0.1.0";
  by-version."glob-to-regexp"."0.1.0" = self.buildNodePackage {
    name = "glob-to-regexp-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.1.0.tgz";
      name = "glob-to-regexp-0.1.0.tgz";
      sha1 = "e0369d426578fd456d47dc23b09de05c1da9ea5d";
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
    self.by-version."gpg-wrapper"."1.0.5";
  by-version."gpg-wrapper"."1.0.5" = self.buildNodePackage {
    name = "gpg-wrapper-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gpg-wrapper/-/gpg-wrapper-1.0.5.tgz";
      name = "gpg-wrapper-1.0.5.tgz";
      sha1 = "e3b9197c5e2dc7b0273cf59601430c18f17b3e51";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "iced-spawn-1.0.0" = self.by-version."iced-spawn"."1.0.0";
      "iced-utils-0.1.23" = self.by-version."iced-utils"."0.1.23";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "spotty-1.0.0" = self.by-version."spotty"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gpg-wrapper".">=1.0.5" =
    self.by-version."gpg-wrapper"."1.0.5";
  "gpg-wrapper" = self.by-version."gpg-wrapper"."1.0.5";
  by-spec."graceful-fs"."^4.1.2" =
    self.by-version."graceful-fs"."4.1.3";
  by-version."graceful-fs"."4.1.3" = self.buildNodePackage {
    name = "graceful-fs-4.1.3";
    version = "4.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.3.tgz";
      name = "graceful-fs-4.1.3.tgz";
      sha1 = "92033ce11113c41e2628d61fdfa40bc10dc0155c";
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
  by-spec."har-validator"."~2.0.6" =
    self.by-version."har-validator"."2.0.6";
  by-version."har-validator"."2.0.6" = self.buildNodePackage {
    name = "har-validator-2.0.6";
    version = "2.0.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/har-validator/-/har-validator-2.0.6.tgz";
      name = "har-validator-2.0.6.tgz";
      sha1 = "cdcbc08188265ad119b6a5a7c8ab70eecfb5d27d";
    };
    deps = {
      "chalk-1.1.1" = self.by-version."chalk"."1.1.1";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "is-my-json-valid-2.12.4" = self.by-version."is-my-json-valid"."2.12.4";
      "pinkie-promise-2.0.0" = self.by-version."pinkie-promise"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-ansi"."^2.0.0" =
    self.by-version."has-ansi"."2.0.0";
  by-version."has-ansi"."2.0.0" = self.buildNodePackage {
    name = "has-ansi-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
      name = "has-ansi-2.0.0.tgz";
      sha1 = "34f5049ce1ecdf2b0649af3ef24e45ed35416d91";
    };
    deps = {
      "ansi-regex-2.0.0" = self.by-version."ansi-regex"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~3.1.0" =
    self.by-version."hawk"."3.1.3";
  by-version."hawk"."3.1.3" = self.buildNodePackage {
    name = "hawk-3.1.3";
    version = "3.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-3.1.3.tgz";
      name = "hawk-3.1.3.tgz";
      sha1 = "078444bd7c1640b0fe540d2c9b73d59678e8e1c4";
    };
    deps = {
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
      "boom-2.10.1" = self.by-version."boom"."2.10.1";
      "cryptiles-2.0.5" = self.by-version."cryptiles"."2.0.5";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."highlight.js".">= 8.0.x" =
    self.by-version."highlight.js"."9.1.0";
  by-version."highlight.js"."9.1.0" = self.buildNodePackage {
    name = "highlight.js-9.1.0";
    version = "9.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/highlight.js/-/highlight.js-9.1.0.tgz";
      name = "highlight.js-9.1.0.tgz";
      sha1 = "eb94c125f52bbd25dc893551b45c37c5093f1c5c";
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
    self.by-version."hoek"."2.16.3";
  by-version."hoek"."2.16.3" = self.buildNodePackage {
    name = "hoek-2.16.3";
    version = "2.16.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
      name = "hoek-2.16.3.tgz";
      sha1 = "20bb7403d3cea398e91dc4710a8ff1b8274a25ed";
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
  by-spec."http-signature"."~1.1.0" =
    self.by-version."http-signature"."1.1.1";
  by-version."http-signature"."1.1.1" = self.buildNodePackage {
    name = "http-signature-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-signature/-/http-signature-1.1.1.tgz";
      name = "http-signature-1.1.1.tgz";
      sha1 = "df72e267066cd0ac67fb76adf8e134a8fbcf91bf";
    };
    deps = {
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
      "jsprim-1.2.2" = self.by-version."jsprim"."1.2.2";
      "sshpk-1.7.3" = self.by-version."sshpk"."1.7.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "iced-utils-0.1.23" = self.by-version."iced-utils"."0.1.23";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
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
    self.by-version."iced-runtime"."1.0.3";
  by-version."iced-runtime"."1.0.3" = self.buildNodePackage {
    name = "iced-runtime-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-runtime/-/iced-runtime-1.0.3.tgz";
      name = "iced-runtime-1.0.3.tgz";
      sha1 = "2d4f4fb999ab7aa5430b193c77a7fce4118319ce";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iced-runtime".">=0.0.1 <2.0.0-0" =
    self.by-version."iced-runtime"."1.0.3";
  by-spec."iced-runtime".">=1.0.3" =
    self.by-version."iced-runtime"."1.0.3";
  "iced-runtime" = self.by-version."iced-runtime"."1.0.3";
  by-spec."iced-runtime"."^1.0.0" =
    self.by-version."iced-runtime"."1.0.3";
  by-spec."iced-runtime"."^1.0.1" =
    self.by-version."iced-runtime"."1.0.3";
  by-spec."iced-runtime"."^1.0.2" =
    self.by-version."iced-runtime"."1.0.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "semver-5.1.0" = self.by-version."semver"."5.1.0";
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
    self.by-version."iced-test"."0.0.22";
  by-version."iced-test"."0.0.22" = self.buildNodePackage {
    name = "iced-test-0.0.22";
    version = "0.0.22";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-test/-/iced-test-0.0.22.tgz";
      name = "iced-test-0.0.22.tgz";
      sha1 = "61e7149f443fe5c87ff402cbc2214a42d558af2b";
    };
    deps = {
      "colors-1.1.2" = self.by-version."colors"."1.1.2";
      "deep-equal-1.0.1" = self.by-version."deep-equal"."1.0.1";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-test" = self.by-version."iced-test"."0.0.22";
  by-spec."iced-utils"."0.1.22" =
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "iced-utils" = self.by-version."iced-utils"."0.1.22";
  by-spec."iced-utils".">=0.1.11" =
    self.by-version."iced-utils"."0.1.23";
  by-version."iced-utils"."0.1.23" = self.buildNodePackage {
    name = "iced-utils-0.1.23";
    version = "0.1.23";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iced-utils/-/iced-utils-0.1.23.tgz";
      name = "iced-utils-0.1.23.tgz";
      sha1 = "2b999eb6e34d84e10f449bca1f47ca3b556ea197";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iced-utils".">=0.1.16" =
    self.by-version."iced-utils"."0.1.23";
  by-spec."iced-utils".">=0.1.18" =
    self.by-version."iced-utils"."0.1.23";
  by-spec."iced-utils".">=0.1.22" =
    self.by-version."iced-utils"."0.1.23";
  by-spec."iced-utils"."^0.1.22" =
    self.by-version."iced-utils"."0.1.23";
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
      "once-1.3.3" = self.by-version."once"."1.3.3";
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
    self.by-version."ipv6"."3.1.3";
  by-version."ipv6"."3.1.3" = self.buildNodePackage {
    name = "ipv6-3.1.3";
    version = "3.1.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/ipv6/-/ipv6-3.1.3.tgz";
      name = "ipv6-3.1.3.tgz";
      sha1 = "4d9064f9c2dafa0dd10b8b7d76ffca4aad31b3b9";
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
  by-spec."is-my-json-valid"."^2.12.4" =
    self.by-version."is-my-json-valid"."2.12.4";
  by-version."is-my-json-valid"."2.12.4" = self.buildNodePackage {
    name = "is-my-json-valid-2.12.4";
    version = "2.12.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.12.4.tgz";
      name = "is-my-json-valid-2.12.4.tgz";
      sha1 = "d4ed2bc1d7f88daf8d0f763b3e3e39a69bd37880";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.2.0" = self.by-version."generate-object-property"."1.2.0";
      "jsonpointer-2.0.0" = self.by-version."jsonpointer"."2.0.0";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
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
  by-spec."is-typedarray"."~1.0.0" =
    self.by-version."is-typedarray"."1.0.0";
  by-version."is-typedarray"."1.0.0" = self.buildNodePackage {
    name = "is-typedarray-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz";
      name = "is-typedarray-1.0.0.tgz";
      sha1 = "e479c80858df0c1b11ddda6940f96011fcda4a9a";
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
  by-spec."isstream"."~0.1.2" =
    self.by-version."isstream"."0.1.2";
  by-spec."jodid25519".">=1.0.0 <2.0.0" =
    self.by-version."jodid25519"."1.0.2";
  by-version."jodid25519"."1.0.2" = self.buildNodePackage {
    name = "jodid25519-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jodid25519/-/jodid25519-1.0.2.tgz";
      name = "jodid25519-1.0.2.tgz";
      sha1 = "06d4912255093419477d425633606e0e90782967";
    };
    deps = {
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsbn".">=0.1.0 <0.2.0" =
    self.by-version."jsbn"."0.1.0";
  by-version."jsbn"."0.1.0" = self.buildNodePackage {
    name = "jsbn-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsbn/-/jsbn-0.1.0.tgz";
      name = "jsbn-0.1.0.tgz";
      sha1 = "650987da0dd74f4ebf5a11377a2aa2d273e97dfd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsbn"."~0.1.0" =
    self.by-version."jsbn"."0.1.0";
  by-spec."json-schema"."0.2.2" =
    self.by-version."json-schema"."0.2.2";
  by-version."json-schema"."0.2.2" = self.buildNodePackage {
    name = "json-schema-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-schema/-/json-schema-0.2.2.tgz";
      name = "json-schema-0.2.2.tgz";
      sha1 = "50354f19f603917c695f70b85afa77c3b0f23506";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."~5.0.1" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-version."json-stringify-safe"."5.0.1" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.1";
    version = "5.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
      name = "json-stringify-safe-5.0.1.tgz";
      sha1 = "1296a2d58fd45f19a0f6ce01d65701e2c735b6eb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonfile"."^2.1.0" =
    self.by-version."jsonfile"."2.2.3";
  by-version."jsonfile"."2.2.3" = self.buildNodePackage {
    name = "jsonfile-2.2.3";
    version = "2.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonfile/-/jsonfile-2.2.3.tgz";
      name = "jsonfile-2.2.3.tgz";
      sha1 = "e252b99a6af901d3ec41f332589c90509a7bc605";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonpointer"."2.0.0" =
    self.by-version."jsonpointer"."2.0.0";
  by-version."jsonpointer"."2.0.0" = self.buildNodePackage {
    name = "jsonpointer-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-2.0.0.tgz";
      name = "jsonpointer-2.0.0.tgz";
      sha1 = "3af1dd20fe85463910d469a385e33017d2a030d9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsprim"."^1.2.2" =
    self.by-version."jsprim"."1.2.2";
  by-version."jsprim"."1.2.2" = self.buildNodePackage {
    name = "jsprim-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsprim/-/jsprim-1.2.2.tgz";
      name = "jsprim-1.2.2.tgz";
      sha1 = "f20c906ac92abd58e3b79ac8bc70a48832512da1";
    };
    deps = {
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
      "json-schema-0.2.2" = self.by-version."json-schema"."0.2.2";
      "verror-1.3.6" = self.by-version."verror"."1.3.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kbpgp".">=2.0.41" =
    self.by-version."kbpgp"."2.0.50";
  by-version."kbpgp"."2.0.50" = self.buildNodePackage {
    name = "kbpgp-2.0.50";
    version = "2.0.50";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/kbpgp/-/kbpgp-2.0.50.tgz";
      name = "kbpgp-2.0.50.tgz";
      sha1 = "b060d0e00f965001ea1dd59d64e597f8e060e10c";
    };
    deps = {
      "bn-1.0.1" = self.by-version."bn"."1.0.1";
      "bzip-deflate-1.0.0" = self.by-version."bzip-deflate"."1.0.0";
      "deep-equal-1.0.1" = self.by-version."deep-equal"."1.0.1";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "keybase-ecurve-1.0.0" = self.by-version."keybase-ecurve"."1.0.0";
      "keybase-nacl-1.0.1" = self.by-version."keybase-nacl"."1.0.1";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "purepack-1.0.4" = self.by-version."purepack"."1.0.4";
      "triplesec-3.0.25" = self.by-version."triplesec"."3.0.25";
      "tweetnacl-0.13.3" = self.by-version."tweetnacl"."0.13.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kbpgp".">=2.0.46" =
    self.by-version."kbpgp"."2.0.50";
  "kbpgp" = self.by-version."kbpgp"."2.0.50";
  by-spec."kbpgp"."^2.0.0" =
    self.by-version."kbpgp"."2.0.50";
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
  by-spec."keybase-installer"."1.0.2" =
    self.by-version."keybase-installer"."1.0.2";
  by-version."keybase-installer"."1.0.2" = self.buildNodePackage {
    name = "keybase-installer-1.0.2";
    version = "1.0.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-installer/-/keybase-installer-1.0.2.tgz";
      name = "keybase-installer-1.0.2.tgz";
      sha1 = "19a68b29ef7981daf8531a8f6fcfaffc885f7e6b";
    };
    deps = {
      "badnode-1.0.1" = self.by-version."badnode"."1.0.1";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "gpg-wrapper-1.0.5" = self.by-version."gpg-wrapper"."1.0.5";
      "iced-data-structures-0.0.5" = self.by-version."iced-data-structures"."0.0.5";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-logger-0.0.6" = self.by-version."iced-logger"."0.0.6";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "iced-spawn-1.0.0" = self.by-version."iced-spawn"."1.0.0";
      "iced-utils-0.1.23" = self.by-version."iced-utils"."0.1.23";
      "keybase-path-0.0.15" = self.by-version."keybase-path"."0.0.15";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "progress-1.1.3" = self.by-version."progress"."1.1.3";
      "request-2.69.0" = self.by-version."request"."2.69.0";
      "semver-5.1.0" = self.by-version."semver"."5.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "keybase-installer" = self.by-version."keybase-installer"."1.0.2";
  by-spec."keybase-nacl"."^1.0.0" =
    self.by-version."keybase-nacl"."1.0.1";
  by-version."keybase-nacl"."1.0.1" = self.buildNodePackage {
    name = "keybase-nacl-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-nacl/-/keybase-nacl-1.0.1.tgz";
      name = "keybase-nacl-1.0.1.tgz";
      sha1 = "6047edb7baf241ac5c60cfc32e86512d69d652d3";
    };
    deps = {
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "tweetnacl-0.13.3" = self.by-version."tweetnacl"."0.13.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keybase-proofs"."^2.0.23" =
    self.by-version."keybase-proofs"."2.0.47";
  by-version."keybase-proofs"."2.0.47" = self.buildNodePackage {
    name = "keybase-proofs-2.0.47";
    version = "2.0.47";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keybase-proofs/-/keybase-proofs-2.0.47.tgz";
      name = "keybase-proofs-2.0.47.tgz";
      sha1 = "27c4d9936b8740bc782038f9087d462a1e89b6e4";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "kbpgp-2.0.50" = self.by-version."kbpgp"."2.0.50";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "triplesec-3.0.25" = self.by-version."triplesec"."3.0.25";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."keybase-proofs"."^2.0.46" =
    self.by-version."keybase-proofs"."2.0.47";
  "keybase-proofs" = self.by-version."keybase-proofs"."2.0.47";
  by-spec."klaw"."^1.0.0" =
    self.by-version."klaw"."1.1.3";
  by-version."klaw"."1.1.3" = self.buildNodePackage {
    name = "klaw-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/klaw/-/klaw-1.1.3.tgz";
      name = "klaw-1.1.3.tgz";
      sha1 = "7da33c6b42f9b3dc9cec00d17f13af017fcc2721";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."libkeybase".">=1.2.19" =
    self.by-version."libkeybase"."1.2.24";
  by-version."libkeybase"."1.2.24" = self.buildNodePackage {
    name = "libkeybase-1.2.24";
    version = "1.2.24";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/libkeybase/-/libkeybase-1.2.24.tgz";
      name = "libkeybase-1.2.24.tgz";
      sha1 = "01bd5900eebad304c6ee906dad552ecc211ec989";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-logger-0.0.5" = self.by-version."iced-logger"."0.0.5";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "iced-utils-0.1.23" = self.by-version."iced-utils"."0.1.23";
      "kbpgp-2.0.50" = self.by-version."kbpgp"."2.0.50";
      "keybase-proofs-2.0.47" = self.by-version."keybase-proofs"."2.0.47";
      "merkle-tree-0.0.14" = self.by-version."merkle-tree"."0.0.14";
      "pgp-utils-0.0.28" = self.by-version."pgp-utils"."0.0.28";
      "triplesec-3.0.25" = self.by-version."triplesec"."3.0.25";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "libkeybase" = self.by-version."libkeybase"."1.2.24";
  by-spec."lru-cache"."^2.6.5" =
    self.by-version."lru-cache"."2.7.3";
  by-version."lru-cache"."2.7.3" = self.buildNodePackage {
    name = "lru-cache-2.7.3";
    version = "2.7.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.7.3.tgz";
      name = "lru-cache-2.7.3.tgz";
      sha1 = "6d4524e8b955f95d4f5b58851ce21dd72fb4e952";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."marked".">= 0.2.7" =
    self.by-version."marked"."0.3.5";
  by-version."marked"."0.3.5" = self.buildNodePackage {
    name = "marked-0.3.5";
    version = "0.3.5";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/marked/-/marked-0.3.5.tgz";
      name = "marked-0.3.5.tgz";
      sha1 = "4113a15ac5d7bca158a5aae07224587b9fa15b94";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."merkle-tree"."0.0.14" =
    self.by-version."merkle-tree"."0.0.14";
  by-version."merkle-tree"."0.0.14" = self.buildNodePackage {
    name = "merkle-tree-0.0.14";
    version = "0.0.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/merkle-tree/-/merkle-tree-0.0.14.tgz";
      name = "merkle-tree-0.0.14.tgz";
      sha1 = "584c3b05beaf7d482fbd4c6a868e8c35a581a7ef";
    };
    deps = {
      "deep-equal-0.2.2" = self.by-version."deep-equal"."0.2.2";
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "iced-utils-0.1.23" = self.by-version."iced-utils"."0.1.23";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "merkle-tree" = self.by-version."merkle-tree"."0.0.14";
  by-spec."mime-db"."~1.21.0" =
    self.by-version."mime-db"."1.21.0";
  by-version."mime-db"."1.21.0" = self.buildNodePackage {
    name = "mime-db-1.21.0";
    version = "1.21.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.21.0.tgz";
      name = "mime-db-1.21.0.tgz";
      sha1 = "9b5239e3353cf6eb015a00d890261027c36d4bac";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.3" =
    self.by-version."mime-types"."2.1.9";
  by-version."mime-types"."2.1.9" = self.buildNodePackage {
    name = "mime-types-2.1.9";
    version = "2.1.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.9.tgz";
      name = "mime-types-2.1.9.tgz";
      sha1 = "dfb396764b5fdf75be34b1f4104bc3687fb635f8";
    };
    deps = {
      "mime-db-1.21.0" = self.by-version."mime-db"."1.21.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.1.7" =
    self.by-version."mime-types"."2.1.9";
  by-spec."minimatch"."2 || 3" =
    self.by-version."minimatch"."3.0.0";
  by-version."minimatch"."3.0.0" = self.buildNodePackage {
    name = "minimatch-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-3.0.0.tgz";
      name = "minimatch-3.0.0.tgz";
      sha1 = "5236157a51e4f004c177fb3c527ff7dd78f0ef83";
    };
    deps = {
      "brace-expansion-1.1.2" = self.by-version."brace-expansion"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist".">=0.0.8" =
    self.by-version."minimist"."1.2.0";
  by-version."minimist"."1.2.0" = self.buildNodePackage {
    name = "minimist-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz";
      name = "minimist-1.2.0.tgz";
      sha1 = "a35008b20f41383eec1fb914f4cd5df79a264284";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.5";
  by-version."mute-stream"."0.0.5" = self.buildNodePackage {
    name = "mute-stream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.5.tgz";
      name = "mute-stream-0.0.5.tgz";
      sha1 = "8fbfabb0a98a253d3184331f9e8deb7372fac6c0";
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
  by-spec."node-uuid"."~1.4.7" =
    self.by-version."node-uuid"."1.4.7";
  by-version."node-uuid"."1.4.7" = self.buildNodePackage {
    name = "node-uuid-1.4.7";
    version = "1.4.7";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.7.tgz";
      name = "node-uuid-1.4.7.tgz";
      sha1 = "6da5a17668c4b3dd59623bda11cf7fa4c1f60a6f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.8.0" =
    self.by-version."oauth-sign"."0.8.1";
  by-version."oauth-sign"."0.8.1" = self.buildNodePackage {
    name = "oauth-sign-0.8.1";
    version = "0.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.1.tgz";
      name = "oauth-sign-0.8.1.tgz";
      sha1 = "182439bdb91378bf7460e75c64ea43e6448def06";
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
    self.by-version."once"."1.3.3";
  by-version."once"."1.3.3" = self.buildNodePackage {
    name = "once-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/once/-/once-1.3.3.tgz";
      name = "once-1.3.3.tgz";
      sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
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
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
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
  by-spec."pinkie"."^2.0.0" =
    self.by-version."pinkie"."2.0.4";
  by-version."pinkie"."2.0.4" = self.buildNodePackage {
    name = "pinkie-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz";
      name = "pinkie-2.0.4.tgz";
      sha1 = "72556b80cfa0d48a974e80e77248e80ed4f7f870";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie-promise"."^2.0.0" =
    self.by-version."pinkie-promise"."2.0.0";
  by-version."pinkie-promise"."2.0.0" = self.buildNodePackage {
    name = "pinkie-promise-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.0.tgz";
      name = "pinkie-promise-2.0.0.tgz";
      sha1 = "4c83538de1f6e660c29e0a13446844f7a7e88259";
    };
    deps = {
      "pinkie-2.0.4" = self.by-version."pinkie"."2.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.1";
  by-version."pkginfo"."0.3.1" = self.buildNodePackage {
    name = "pkginfo-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.1.tgz";
      name = "pkginfo-0.3.1.tgz";
      sha1 = "5b29f6a81f70717142e09e765bbeab97b4f81e21";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."process-nextick-args"."~1.0.6" =
    self.by-version."process-nextick-args"."1.0.6";
  by-version."process-nextick-args"."1.0.6" = self.buildNodePackage {
    name = "process-nextick-args-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.6.tgz";
      name = "process-nextick-args-1.0.6.tgz";
      sha1 = "0f96b001cea90b12592ce566edb97ec11e69bd05";
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
    self.by-version."purepack"."1.0.4";
  by-version."purepack"."1.0.4" = self.buildNodePackage {
    name = "purepack-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/purepack/-/purepack-1.0.4.tgz";
      name = "purepack-1.0.4.tgz";
      sha1 = "086282fd939285f58664ba9a9bba31cdb165ccd2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."purepack".">=1.0.4" =
    self.by-version."purepack"."1.0.4";
  by-spec."qs"."~6.0.2" =
    self.by-version."qs"."6.0.2";
  by-version."qs"."6.0.2" = self.buildNodePackage {
    name = "qs-6.0.2";
    version = "6.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-6.0.2.tgz";
      name = "qs-6.0.2.tgz";
      sha1 = "88c68d590e8ed56c76c79f352c17b982466abfcd";
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
      "mute-stream-0.0.5" = self.by-version."mute-stream"."0.0.5";
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
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
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
  by-spec."readable-stream"."~2.0.5" =
    self.by-version."readable-stream"."2.0.5";
  by-version."readable-stream"."2.0.5" = self.buildNodePackage {
    name = "readable-stream-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-2.0.5.tgz";
      name = "readable-stream-2.0.5.tgz";
      sha1 = "a2426f8dcd4551c77a33f96edf2886a23c829669";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "process-nextick-args-1.0.6" = self.by-version."process-nextick-args"."1.0.6";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.58.0" =
    self.by-version."request"."2.69.0";
  by-version."request"."2.69.0" = self.buildNodePackage {
    name = "request-2.69.0";
    version = "2.69.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.69.0.tgz";
      name = "request-2.69.0.tgz";
      sha1 = "cf91d2e000752b1217155c005241911991a2346a";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.2.1" = self.by-version."aws4"."1.2.1";
      "bl-1.0.2" = self.by-version."bl"."1.0.2";
      "caseless-0.11.0" = self.by-version."caseless"."0.11.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-1.0.0-rc3" = self.by-version."form-data"."1.0.0-rc3";
      "har-validator-2.0.6" = self.by-version."har-validator"."2.0.6";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.9" = self.by-version."mime-types"."2.1.9";
      "node-uuid-1.4.7" = self.by-version."node-uuid"."1.4.7";
      "oauth-sign-0.8.1" = self.by-version."oauth-sign"."0.8.1";
      "qs-6.0.2" = self.by-version."qs"."6.0.2";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.2.1" = self.by-version."tough-cookie"."2.2.1";
      "tunnel-agent-0.4.2" = self.by-version."tunnel-agent"."0.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "request" = self.by-version."request"."2.69.0";
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.5.1";
  by-version."rimraf"."2.5.1" = self.buildNodePackage {
    name = "rimraf-2.5.1";
    version = "2.5.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.5.1.tgz";
      name = "rimraf-2.5.1.tgz";
      sha1 = "52e1e946f3f9b9b0d5d8988ba3191aaf2a2dbd43";
    };
    deps = {
      "glob-6.0.4" = self.by-version."glob"."6.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver".">=1" =
    self.by-version."semver"."5.1.0";
  by-version."semver"."5.1.0" = self.buildNodePackage {
    name = "semver-5.1.0";
    version = "5.1.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-5.1.0.tgz";
      name = "semver-5.1.0.tgz";
      sha1 = "85f2cf8550465c4df000cf7d86f6b054106ab9e5";
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
    self.by-version."semver"."5.1.0";
  by-spec."semver"."^4.0.0" =
    self.by-version."semver"."4.3.6";
  by-version."semver"."4.3.6" = self.buildNodePackage {
    name = "semver-4.3.6";
    version = "4.3.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-4.3.6.tgz";
      name = "semver-4.3.6.tgz";
      sha1 = "300bc6e0e86374f7ba61068b5b1ecd57fc6532da";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "semver" = self.by-version."semver"."4.3.6";
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
      "hoek-2.16.3" = self.by-version."hoek"."2.16.3";
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
      "ipv6-3.1.3" = self.by-version."ipv6"."3.1.3";
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
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
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
  by-spec."sshpk"."^1.7.0" =
    self.by-version."sshpk"."1.7.3";
  by-version."sshpk"."1.7.3" = self.buildNodePackage {
    name = "sshpk-1.7.3";
    version = "1.7.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/sshpk/-/sshpk-1.7.3.tgz";
      name = "sshpk-1.7.3.tgz";
      sha1 = "caa8ef95e30765d856698b7025f9f211ab65962f";
    };
    deps = {
      "asn1-0.2.3" = self.by-version."asn1"."0.2.3";
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
      "dashdash-1.12.2" = self.by-version."dashdash"."1.12.2";
    };
    optionalDependencies = {
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
      "tweetnacl-0.13.3" = self.by-version."tweetnacl"."0.13.3";
      "jodid25519-1.0.2" = self.by-version."jodid25519"."1.0.2";
      "ecc-jsbn-0.1.1" = self.by-version."ecc-jsbn"."0.1.1";
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
    self.by-version."stringstream"."0.0.5";
  by-version."stringstream"."0.0.5" = self.buildNodePackage {
    name = "stringstream-0.0.5";
    version = "0.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
      name = "stringstream-0.0.5.tgz";
      sha1 = "4e484cd4de5a0bbbee18e46307710a8a81621878";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^3.0.0" =
    self.by-version."strip-ansi"."3.0.0";
  by-version."strip-ansi"."3.0.0" = self.buildNodePackage {
    name = "strip-ansi-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.0.tgz";
      name = "strip-ansi-3.0.0.tgz";
      sha1 = "7510b665567ca914ccb5d7e072763ac968be3724";
    };
    deps = {
      "ansi-regex-2.0.0" = self.by-version."ansi-regex"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."supports-color"."^2.0.0" =
    self.by-version."supports-color"."2.0.0";
  by-version."supports-color"."2.0.0" = self.buildNodePackage {
    name = "supports-color-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
      name = "supports-color-2.0.0.tgz";
      sha1 = "535d045ce6b6363fa40117084629995e9df324c7";
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
  by-spec."tough-cookie"."~2.2.0" =
    self.by-version."tough-cookie"."2.2.1";
  by-version."tough-cookie"."2.2.1" = self.buildNodePackage {
    name = "tough-cookie-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-2.2.1.tgz";
      name = "tough-cookie-2.2.1.tgz";
      sha1 = "3b0516b799e70e8164436a1446e7e5877fda118e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."triplesec".">=3.0.16" =
    self.by-version."triplesec"."3.0.25";
  by-version."triplesec"."3.0.25" = self.buildNodePackage {
    name = "triplesec-3.0.25";
    version = "3.0.25";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/triplesec/-/triplesec-3.0.25.tgz";
      name = "triplesec-3.0.25.tgz";
      sha1 = "c66833548646effbd031de01dde4ed0721aaad58";
    };
    deps = {
      "iced-error-0.0.9" = self.by-version."iced-error"."0.0.9";
      "iced-lock-1.0.1" = self.by-version."iced-lock"."1.0.1";
      "iced-runtime-1.0.3" = self.by-version."iced-runtime"."1.0.3";
      "more-entropy-0.0.7" = self.by-version."more-entropy"."0.0.7";
      "progress-1.1.8" = self.by-version."progress"."1.1.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "triplesec" = self.by-version."triplesec"."3.0.25";
  by-spec."triplesec".">=3.0.19" =
    self.by-version."triplesec"."3.0.25";
  by-spec."triplesec"."^3.0.19" =
    self.by-version."triplesec"."3.0.25";
  by-spec."tunnel-agent"."~0.4.1" =
    self.by-version."tunnel-agent"."0.4.2";
  by-version."tunnel-agent"."0.4.2" = self.buildNodePackage {
    name = "tunnel-agent-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.2.tgz";
      name = "tunnel-agent-0.4.2.tgz";
      sha1 = "1104e3f36ac87125c287270067d582d18133bfee";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl".">=0.13.0 <1.0.0" =
    self.by-version."tweetnacl"."0.13.3";
  by-version."tweetnacl"."0.13.3" = self.buildNodePackage {
    name = "tweetnacl-0.13.3";
    version = "0.13.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tweetnacl/-/tweetnacl-0.13.3.tgz";
      name = "tweetnacl-0.13.3.tgz";
      sha1 = "d628b56f3bcc3d5ae74ba9d4c1a704def5ab4b56";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."^0.13.1" =
    self.by-version."tweetnacl"."0.13.3";
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
  by-spec."util-deprecate"."~1.0.1" =
    self.by-version."util-deprecate"."1.0.2";
  by-version."util-deprecate"."1.0.2" = self.buildNodePackage {
    name = "util-deprecate-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
      name = "util-deprecate-1.0.2.tgz";
      sha1 = "450d4dc9fa70de732762fbd2d4a28981419a0ccf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."verror"."1.3.6" =
    self.by-version."verror"."1.3.6";
  by-version."verror"."1.3.6" = self.buildNodePackage {
    name = "verror-1.3.6";
    version = "1.3.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
      name = "verror-1.3.6.tgz";
      sha1 = "cff5df12946d297d2baaefaa2689e25be01c005c";
    };
    deps = {
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
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
      "pkginfo-0.3.1" = self.by-version."pkginfo"."0.3.1";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.3";
  by-version."wordwrap"."0.0.3" = self.buildNodePackage {
    name = "wordwrap-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.3.tgz";
      name = "wordwrap-0.0.3.tgz";
      sha1 = "a3d5da6cd5c0bc0008d37234bbaf1bed63059107";
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
    self.by-version."xtend"."4.0.1";
  by-version."xtend"."4.0.1" = self.buildNodePackage {
    name = "xtend-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
      name = "xtend-4.0.1.tgz";
      sha1 = "a5c6d532be656e23db820efb943a1f04998d63af";
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

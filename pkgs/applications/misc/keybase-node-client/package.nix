{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."CSSselect"."~0.4.0" =
    self.by-version."CSSselect"."0.4.1";
  by-version."CSSselect"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-CSSselect-0.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.4.1.tgz";
        name = "CSSselect-0.4.1.tgz";
        sha1 = "f8ab7e1f8418ce63cda6eb7bd778a85d7ec492b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSselect" or []);
    deps = [
      self.by-version."CSSwhat"."0.4.7"
      self.by-version."domutils"."1.4.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSselect" ];
  };
  by-spec."CSSwhat"."0.4" =
    self.by-version."CSSwhat"."0.4.7";
  by-version."CSSwhat"."0.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-CSSwhat-0.4.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.7.tgz";
        name = "CSSwhat-0.4.7.tgz";
        sha1 = "867da0ff39f778613242c44cfea83f0aa4ebdf9b";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSwhat" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "CSSwhat" ];
  };
  by-spec."argparse"."0.1.15" =
    self.by-version."argparse"."0.1.15";
  by-version."argparse"."0.1.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-argparse-0.1.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/argparse/-/argparse-0.1.15.tgz";
        name = "argparse-0.1.15.tgz";
        sha1 = "28a1f72c43113e763220e5708414301c8840f0a1";
      })
    ];
    buildInputs =
      (self.nativeDeps."argparse" or []);
    deps = [
      self.by-version."underscore"."1.4.4"
      self.by-version."underscore.string"."2.3.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "argparse" ];
  };
  "argparse" = self.by-version."argparse"."0.1.15";
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-asn1-0.1.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        name = "asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "asn1" ];
  };
  by-spec."assert-plus"."0.1.2" =
    self.by-version."assert-plus"."0.1.2";
  by-version."assert-plus"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-assert-plus-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.2.tgz";
        name = "assert-plus-0.1.2.tgz";
        sha1 = "d93ffdbb67ac5507779be316a7d65146417beef8";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert-plus" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "assert-plus" ];
  };
  by-spec."async"."0.2.x" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-async-0.2.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
        name = "async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-version."async"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-async-0.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
        name = "async-0.9.0.tgz";
        sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-aws-sign2-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
        name = "aws-sign2-0.5.0.tgz";
        sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign2" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign2" ];
  };
  by-spec."bitcoyne".">=0.0.6" =
    self.by-version."bitcoyne"."0.0.6";
  by-version."bitcoyne"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-bitcoyne-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bitcoyne/-/bitcoyne-0.0.6.tgz";
        name = "bitcoyne-0.0.6.tgz";
        sha1 = "a309d1afe7554f2b380782428cd6f67a82183d2f";
      })
    ];
    buildInputs =
      (self.nativeDeps."bitcoyne" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."kbpgp"."1.0.5"
      self.by-version."pgp-utils"."0.0.27"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bitcoyne" ];
  };
  "bitcoyne" = self.by-version."bitcoyne"."0.0.6";
  by-spec."bn"."^1.0.0" =
    self.by-version."bn"."1.0.1";
  by-version."bn"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-bn-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bn/-/bn-1.0.1.tgz";
        name = "bn-1.0.1.tgz";
        sha1 = "a153825e6b1eb2c2db7726149b047a07ce0a3bb3";
      })
    ];
    buildInputs =
      (self.nativeDeps."bn" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bn" ];
  };
  by-spec."bn"."^1.0.1" =
    self.by-version."bn"."1.0.1";
  "bn" = self.by-version."bn"."1.0.1";
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-boom-0.4.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
        name = "boom-0.4.2.tgz";
        sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = [
      self.by-version."hoek"."0.9.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."cheerio"."0.13.0" =
    self.by-version."cheerio"."0.13.0";
  by-version."cheerio"."0.13.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-cheerio-0.13.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.13.0.tgz";
        name = "cheerio-0.13.0.tgz";
        sha1 = "44f5112044e0e0148300dd16bf8bbd7755ce65f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio" or []);
    deps = [
      self.by-version."htmlparser2"."3.4.0"
      self.by-version."underscore"."1.4.4"
      self.by-version."entities"."0.5.0"
      self.by-version."CSSselect"."0.4.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  "cheerio" = self.by-version."cheerio"."0.13.0";
  by-spec."cli"."0.4.x" =
    self.by-version."cli"."0.4.5";
  by-version."cli"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-cli-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli/-/cli-0.4.5.tgz";
        name = "cli-0.4.5.tgz";
        sha1 = "78f9485cd161b566e9a6c72d7170c4270e81db61";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli" or []);
    deps = [
      self.by-version."glob"."4.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cli" ];
  };
  by-spec."cliff"."0.1.x" =
    self.by-version."cliff"."0.1.9";
  by-version."cliff"."0.1.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-cliff-0.1.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cliff/-/cliff-0.1.9.tgz";
        name = "cliff-0.1.9.tgz";
        sha1 = "a211e09c6a3de3ba1af27d049d301250d18812bc";
      })
    ];
    buildInputs =
      (self.nativeDeps."cliff" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."eyes"."0.1.8"
      self.by-version."winston"."0.8.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cliff" ];
  };
  by-spec."codesign"."0.0.9" =
    self.by-version."codesign"."0.0.9";
  by-version."codesign"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-codesign-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/codesign/-/codesign-0.0.9.tgz";
        name = "codesign-0.0.9.tgz";
        sha1 = "2da6b703f1d1cf2a76e8b1d48f44fa922e21b55f";
      })
    ];
    buildInputs =
      (self.nativeDeps."codesign" or []);
    deps = [
      self.by-version."argparse"."0.1.15"
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-logger"."0.0.5"
      self.by-version."glob-to-regexp"."0.0.1"
      self.by-version."tablify"."0.1.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "codesign" ];
  };
  "codesign" = self.by-version."codesign"."0.0.9";
  by-spec."colors"."0.6.2" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-colors-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        name = "colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
  };
  "colors" = self.by-version."colors"."0.6.2";
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."0.x.x" =
    self.by-version."colors"."0.6.2";
  by-spec."colors".">=0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."colors"."~0.6.2" =
    self.by-version."colors"."0.6.2";
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.5";
  by-version."combined-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-combined-stream-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.5.tgz";
        name = "combined-stream-0.0.5.tgz";
        sha1 = "29ed76e5c9aad07c4acf9ca3d32601cce28697a2";
      })
    ];
    buildInputs =
      (self.nativeDeps."combined-stream" or []);
    deps = [
      self.by-version."delayed-stream"."0.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "combined-stream" ];
  };
  by-spec."commander".">= 0.5.2" =
    self.by-version."commander"."2.3.0";
  by-version."commander"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-2.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.3.0.tgz";
        name = "commander-2.3.0.tgz";
        sha1 = "fd430e889832ec353b9acd1de217c11cb3eef873";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."~2.1.0" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-commander-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
        name = "commander-2.1.0.tgz";
        sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-core-util-is-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
        name = "core-util-is-1.0.1.tgz";
        sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
      })
    ];
    buildInputs =
      (self.nativeDeps."core-util-is" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "core-util-is" ];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-cryptiles-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
        name = "cryptiles-0.2.2.tgz";
        sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = [
      self.by-version."boom"."0.4.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."ctype"."0.5.2" =
    self.by-version."ctype"."0.5.2";
  by-version."ctype"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-ctype-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
        name = "ctype-0.5.2.tgz";
        sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-cycle-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
        name = "cycle-1.0.3.tgz";
        sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
      })
    ];
    buildInputs =
      (self.nativeDeps."cycle" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cycle" ];
  };
  by-spec."deep-equal"."0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-version."deep-equal"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-deep-equal-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.1.tgz";
        name = "deep-equal-0.2.1.tgz";
        sha1 = "fad7a793224cbf0c3c7786f92ef780e4fc8cc878";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  "deep-equal" = self.by-version."deep-equal"."0.2.1";
  by-spec."deep-equal".">=0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-spec."deep-equal"."~0.2.1" =
    self.by-version."deep-equal"."0.2.1";
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-delayed-stream-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
        name = "delayed-stream-0.0.5.tgz";
        sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
      })
    ];
    buildInputs =
      (self.nativeDeps."delayed-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "delayed-stream" ];
  };
  by-spec."docco"."~0.6.2" =
    self.by-version."docco"."0.6.3";
  by-version."docco"."0.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "docco-0.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/docco/-/docco-0.6.3.tgz";
        name = "docco-0.6.3.tgz";
        sha1 = "c47b5823d79563d6fc3abd49f3de48986e5522ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."docco" or []);
    deps = [
      self.by-version."commander"."2.3.0"
      self.by-version."marked"."0.3.2"
      self.by-version."fs-extra"."0.12.0"
      self.by-version."underscore"."1.7.0"
      self.by-version."highlight.js"."8.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "docco" ];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.1.1";
  by-version."domelementtype"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-domelementtype-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.1.tgz";
        name = "domelementtype-1.1.1.tgz";
        sha1 = "7887acbda7614bb0a3dbe1b5e394f77a8ed297cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."domelementtype" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domelementtype" ];
  };
  by-spec."domhandler"."2.2" =
    self.by-version."domhandler"."2.2.0";
  by-version."domhandler"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-domhandler-2.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.2.0.tgz";
        name = "domhandler-2.2.0.tgz";
        sha1 = "ac9febfa988034b43f78ba056ebf7bd373416476";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domutils"."1.3" =
    self.by-version."domutils"."1.3.0";
  by-version."domutils"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-domutils-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.3.0.tgz";
        name = "domutils-1.3.0.tgz";
        sha1 = "9ad4d59b5af6ca684c62fe6d768ef170e70df192";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."domutils"."1.4" =
    self.by-version."domutils"."1.4.3";
  by-version."domutils"."1.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-domutils-1.4.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.4.3.tgz";
        name = "domutils-1.4.3.tgz";
        sha1 = "0865513796c6b306031850e175516baf80b72a6f";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = [
      self.by-version."domelementtype"."1.1.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."entities"."0.x" =
    self.by-version."entities"."0.5.0";
  by-version."entities"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-entities-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-0.5.0.tgz";
        name = "entities-0.5.0.tgz";
        sha1 = "f611cb5ae221050e0012c66979503fd7ae19cc49";
      })
    ];
    buildInputs =
      (self.nativeDeps."entities" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "entities" ];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-eyes-0.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        name = "eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eyes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "eyes" ];
  };
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-forever-agent-0.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
        name = "forever-agent-0.5.2.tgz";
        sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.4";
  by-version."form-data"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-form-data-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.4.tgz";
        name = "form-data-0.1.4.tgz";
        sha1 = "91abd788aba9702b1aabfa8bc01031a2ac9e3b12";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = [
      self.by-version."combined-stream"."0.0.5"
      self.by-version."mime"."1.2.11"
      self.by-version."async"."0.9.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."framed-msgpack-rpc"."1.1.4" =
    self.by-version."framed-msgpack-rpc"."1.1.4";
  by-version."framed-msgpack-rpc"."1.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-framed-msgpack-rpc-1.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/framed-msgpack-rpc/-/framed-msgpack-rpc-1.1.4.tgz";
        name = "framed-msgpack-rpc-1.1.4.tgz";
        sha1 = "54bfc5fbdf0c7c1b7691f20ffb31ef955c185db2";
      })
    ];
    buildInputs =
      (self.nativeDeps."framed-msgpack-rpc" or []);
    deps = [
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."purepack"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "framed-msgpack-rpc" ];
  };
  "framed-msgpack-rpc" = self.by-version."framed-msgpack-rpc"."1.1.4";
  by-spec."fs-extra".">= 0.6.0" =
    self.by-version."fs-extra"."0.12.0";
  by-version."fs-extra"."0.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-fs-extra-0.12.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-extra/-/fs-extra-0.12.0.tgz";
        name = "fs-extra-0.12.0.tgz";
        sha1 = "407cf6e11321e440d66f9486fba1cc9eb4c21868";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-extra" or []);
    deps = [
      self.by-version."ncp"."0.6.0"
      self.by-version."mkdirp"."0.5.0"
      self.by-version."jsonfile"."2.0.0"
      self.by-version."rimraf"."2.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fs-extra" ];
  };
  by-spec."glob".">= 3.1.4" =
    self.by-version."glob"."4.0.6";
  by-version."glob"."4.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-glob-4.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-4.0.6.tgz";
        name = "glob-4.0.6.tgz";
        sha1 = "695c50bdd4e2fb5c5d370b091f388d3707e291a7";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = [
      self.by-version."graceful-fs"."3.0.2"
      self.by-version."inherits"."2.0.1"
      self.by-version."minimatch"."1.0.0"
      self.by-version."once"."1.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob-to-regexp".">=0.0.1" =
    self.by-version."glob-to-regexp"."0.0.1";
  by-version."glob-to-regexp"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-glob-to-regexp-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob-to-regexp/-/glob-to-regexp-0.0.1.tgz";
        name = "glob-to-regexp-0.0.1.tgz";
        sha1 = "2a5f79f2ed3233d4ee9ea7b6412547000c3f9d75";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob-to-regexp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "glob-to-regexp" ];
  };
  by-spec."gpg-wrapper"."0.0.47" =
    self.by-version."gpg-wrapper"."0.0.47";
  by-version."gpg-wrapper"."0.0.47" = lib.makeOverridable self.buildNodePackage {
    name = "node-gpg-wrapper-0.0.47";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gpg-wrapper/-/gpg-wrapper-0.0.47.tgz";
        name = "gpg-wrapper-0.0.47.tgz";
        sha1 = "5de253269cb999e3e928a375971c7613bcb29d36";
      })
    ];
    buildInputs =
      (self.nativeDeps."gpg-wrapper" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."iced-spawn"."0.0.10"
      self.by-version."iced-utils"."0.1.21"
      self.by-version."pgp-utils"."0.0.27"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "gpg-wrapper" ];
  };
  "gpg-wrapper" = self.by-version."gpg-wrapper"."0.0.47";
  by-spec."graceful-fs"."^3.0.2" =
    self.by-version."graceful-fs"."3.0.2";
  by-version."graceful-fs"."3.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-graceful-fs-3.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.2.tgz";
        name = "graceful-fs-3.0.2.tgz";
        sha1 = "2cb5bf7f742bea8ad47c754caeee032b7e71a577";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."hawk"."~1.0.0" =
    self.by-version."hawk"."1.0.0";
  by-version."hawk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-hawk-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.0.0.tgz";
        name = "hawk-1.0.0.tgz";
        sha1 = "b90bb169807285411da7ffcb8dd2598502d3b52d";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = [
      self.by-version."hoek"."0.9.1"
      self.by-version."boom"."0.4.2"
      self.by-version."cryptiles"."0.2.2"
      self.by-version."sntp"."0.2.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."highlight.js".">= 8.0.x" =
    self.by-version."highlight.js"."8.2.0";
  by-version."highlight.js"."8.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-highlight.js-8.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/highlight.js/-/highlight.js-8.2.0.tgz";
        name = "highlight.js-8.2.0.tgz";
        sha1 = "31ac0ea5d20f88f562948e7e8eb5a62e9e8c5e43";
      })
    ];
    buildInputs =
      (self.nativeDeps."highlight.js" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "highlight.js" ];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-hoek-0.9.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
        name = "hoek-0.9.1.tgz";
        sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."htmlparser2"."~3.4.0" =
    self.by-version."htmlparser2"."3.4.0";
  by-version."htmlparser2"."3.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-htmlparser2-3.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.4.0.tgz";
        name = "htmlparser2-3.4.0.tgz";
        sha1 = "a1cd65f5823ad285e19d63b085ad722d0a51eae7";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = [
      self.by-version."domhandler"."2.2.0"
      self.by-version."domutils"."1.3.0"
      self.by-version."domelementtype"."1.1.1"
      self.by-version."readable-stream"."1.1.13"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.0";
  by-version."http-signature"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-http-signature-0.10.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.0.tgz";
        name = "http-signature-0.10.0.tgz";
        sha1 = "1494e4f5000a83c0f11bcc12d6007c530cb99582";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = [
      self.by-version."assert-plus"."0.1.2"
      self.by-version."asn1"."0.1.11"
      self.by-version."ctype"."0.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."iced-coffee-script"."~1.7.1-c" =
    self.by-version."iced-coffee-script"."1.7.1-g";
  by-version."iced-coffee-script"."1.7.1-g" = lib.makeOverridable self.buildNodePackage {
    name = "iced-coffee-script-1.7.1-g";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-coffee-script/-/iced-coffee-script-1.7.1-g.tgz";
        name = "iced-coffee-script-1.7.1-g.tgz";
        sha1 = "41f9ccabe113bade608d519c10a41406a62c170b";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-coffee-script" or []);
    deps = [
      self.by-version."docco"."0.6.3"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."mkdirp"."0.3.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-coffee-script" ];
  };
  "iced-coffee-script" = self.by-version."iced-coffee-script"."1.7.1-g";
  by-spec."iced-data-structures"."0.0.5" =
    self.by-version."iced-data-structures"."0.0.5";
  by-version."iced-data-structures"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-data-structures-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-data-structures/-/iced-data-structures-0.0.5.tgz";
        name = "iced-data-structures-0.0.5.tgz";
        sha1 = "21de124f847fdeeb88f32cf232d3e3e600e05db4";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-data-structures" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-data-structures" ];
  };
  "iced-data-structures" = self.by-version."iced-data-structures"."0.0.5";
  by-spec."iced-db"."0.0.4" =
    self.by-version."iced-db"."0.0.4";
  by-version."iced-db"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-db-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-db/-/iced-db-0.0.4.tgz";
        name = "iced-db-0.0.4.tgz";
        sha1 = "355bf9808998076013a0850ee33c6905dfb85a00";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-db" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."iced-utils"."0.1.21"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-db" ];
  };
  "iced-db" = self.by-version."iced-db"."0.0.4";
  by-spec."iced-error"."0.0.9" =
    self.by-version."iced-error"."0.0.9";
  by-version."iced-error"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-error-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-error/-/iced-error-0.0.9.tgz";
        name = "iced-error-0.0.9.tgz";
        sha1 = "c7c3057614c0a187d96b3d18c6d520e6b872ed37";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-error" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-error" ];
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
  by-version."iced-expect"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-expect-0.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-expect/-/iced-expect-0.0.3.tgz";
        name = "iced-expect-0.0.3.tgz";
        sha1 = "206f271f27b200b9b538e2c0ca66a70209be1238";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-expect" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-expect" ];
  };
  "iced-expect" = self.by-version."iced-expect"."0.0.3";
  by-spec."iced-lock"."^1.0.1" =
    self.by-version."iced-lock"."1.0.1";
  by-version."iced-lock"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-lock-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-lock/-/iced-lock-1.0.1.tgz";
        name = "iced-lock-1.0.1.tgz";
        sha1 = "0914a61a4d3dec69db8f871ef40f95417fa38986";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-lock" or []);
    deps = [
      self.by-version."iced-runtime"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-lock" ];
  };
  "iced-lock" = self.by-version."iced-lock"."1.0.1";
  by-spec."iced-logger"."0.0.5" =
    self.by-version."iced-logger"."0.0.5";
  by-version."iced-logger"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-logger-0.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-logger/-/iced-logger-0.0.5.tgz";
        name = "iced-logger-0.0.5.tgz";
        sha1 = "501852a410691cf7e9542598e04dfbfdadc51486";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-logger" or []);
    deps = [
      self.by-version."colors"."0.6.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-logger" ];
  };
  "iced-logger" = self.by-version."iced-logger"."0.0.5";
  by-spec."iced-logger".">=0.0.3" =
    self.by-version."iced-logger"."0.0.5";
  by-spec."iced-runtime".">=0.0.1" =
    self.by-version."iced-runtime"."1.0.1";
  by-version."iced-runtime"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-runtime-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-runtime/-/iced-runtime-1.0.1.tgz";
        name = "iced-runtime-1.0.1.tgz";
        sha1 = "b2a8f4544241408d076c581ffa97c67d32e3d49b";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-runtime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-runtime" ];
  };
  "iced-runtime" = self.by-version."iced-runtime"."1.0.1";
  by-spec."iced-runtime".">=0.0.1 <2.0.0-0" =
    self.by-version."iced-runtime"."1.0.1";
  by-spec."iced-runtime"."^1.0.0" =
    self.by-version."iced-runtime"."1.0.1";
  by-spec."iced-runtime"."^1.0.1" =
    self.by-version."iced-runtime"."1.0.1";
  by-spec."iced-spawn"."0.0.10" =
    self.by-version."iced-spawn"."0.0.10";
  by-version."iced-spawn"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-spawn-0.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-spawn/-/iced-spawn-0.0.10.tgz";
        name = "iced-spawn-0.0.10.tgz";
        sha1 = "bef06e4fd98b73a519e6781bc3a4bdf2e78054f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-spawn" or []);
    deps = [
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."semver"."2.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-spawn" ];
  };
  "iced-spawn" = self.by-version."iced-spawn"."0.0.10";
  by-spec."iced-spawn".">=0.0.8" =
    self.by-version."iced-spawn"."0.0.10";
  by-spec."iced-test".">=0.0.16" =
    self.by-version."iced-test"."0.0.19";
  by-version."iced-test"."0.0.19" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-test-0.0.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-test/-/iced-test-0.0.19.tgz";
        name = "iced-test-0.0.19.tgz";
        sha1 = "0aff4cfa5170a0ebf9d888695b233e68cf60c634";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-test" or []);
    deps = [
      self.by-version."colors"."0.6.2"
      self.by-version."deep-equal"."0.2.1"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."minimist"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-test" ];
  };
  "iced-test" = self.by-version."iced-test"."0.0.19";
  by-spec."iced-utils"."0.1.20" =
    self.by-version."iced-utils"."0.1.20";
  by-version."iced-utils"."0.1.20" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-utils-0.1.20";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-utils/-/iced-utils-0.1.20.tgz";
        name = "iced-utils-0.1.20.tgz";
        sha1 = "923cbc3c080511cb6cc8e3ccde6609548d2db3e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-utils" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-utils" ];
  };
  "iced-utils" = self.by-version."iced-utils"."0.1.20";
  by-spec."iced-utils".">=0.1.11" =
    self.by-version."iced-utils"."0.1.21";
  by-version."iced-utils"."0.1.21" = lib.makeOverridable self.buildNodePackage {
    name = "node-iced-utils-0.1.21";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iced-utils/-/iced-utils-0.1.21.tgz";
        name = "iced-utils-0.1.21.tgz";
        sha1 = "6f9fb61232c75f365340151794082a718ace436b";
      })
    ];
    buildInputs =
      (self.nativeDeps."iced-utils" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iced-utils" ];
  };
  by-spec."iced-utils".">=0.1.16" =
    self.by-version."iced-utils"."0.1.21";
  by-spec."iced-utils".">=0.1.18" =
    self.by-version."iced-utils"."0.1.21";
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-inherits-2.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        name = "inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ipv6"."~3.1.1" =
    self.by-version."ipv6"."3.1.1";
  by-version."ipv6"."3.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "ipv6-3.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipv6/-/ipv6-3.1.1.tgz";
        name = "ipv6-3.1.1.tgz";
        sha1 = "46da0e260af36fd9beb41297c987b7c21a2d9e1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."ipv6" or []);
    deps = [
      self.by-version."sprintf"."0.1.4"
      self.by-version."cli"."0.4.5"
      self.by-version."cliff"."0.1.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ipv6" ];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-isarray-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
        name = "isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      })
    ];
    buildInputs =
      (self.nativeDeps."isarray" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "isarray" ];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-json-stringify-safe-5.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
        name = "json-stringify-safe-5.0.0.tgz";
        sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  by-spec."jsonfile"."^2.0.0" =
    self.by-version."jsonfile"."2.0.0";
  by-version."jsonfile"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-jsonfile-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonfile/-/jsonfile-2.0.0.tgz";
        name = "jsonfile-2.0.0.tgz";
        sha1 = "c3944f350bd3c078b392e0aa1633b44662fcf06b";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonfile" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "jsonfile" ];
  };
  by-spec."kbpgp".">=1.0.2" =
    self.by-version."kbpgp"."1.0.5";
  by-version."kbpgp"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-kbpgp-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/kbpgp/-/kbpgp-1.0.5.tgz";
        name = "kbpgp-1.0.5.tgz";
        sha1 = "5dea54ffbe648494bd4afcdadae1323e1de909fa";
      })
    ];
    buildInputs =
      (self.nativeDeps."kbpgp" or []);
    deps = [
      self.by-version."bn"."1.0.1"
      self.by-version."deep-equal"."0.2.1"
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."keybase-compressjs"."1.0.1-c"
      self.by-version."keybase-ecurve"."1.0.0"
      self.by-version."pgp-utils"."0.0.27"
      self.by-version."purepack"."1.0.1"
      self.by-version."triplesec"."3.0.19"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "kbpgp" ];
  };
  "kbpgp" = self.by-version."kbpgp"."1.0.5";
  by-spec."kbpgp"."^1.0.2" =
    self.by-version."kbpgp"."1.0.5";
  by-spec."keybase-compressjs"."^1.0.1-c" =
    self.by-version."keybase-compressjs"."1.0.1-c";
  by-version."keybase-compressjs"."1.0.1-c" = lib.makeOverridable self.buildNodePackage {
    name = "node-keybase-compressjs-1.0.1-c";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keybase-compressjs/-/keybase-compressjs-1.0.1-c.tgz";
        name = "keybase-compressjs-1.0.1-c.tgz";
        sha1 = "dc664a7f5d95584a534622a260297532f3ce9f9f";
      })
    ];
    buildInputs =
      (self.nativeDeps."keybase-compressjs" or []);
    deps = [
      self.by-version."commander"."2.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keybase-compressjs" ];
  };
  by-spec."keybase-ecurve"."^1.0.0" =
    self.by-version."keybase-ecurve"."1.0.0";
  by-version."keybase-ecurve"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-keybase-ecurve-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keybase-ecurve/-/keybase-ecurve-1.0.0.tgz";
        name = "keybase-ecurve-1.0.0.tgz";
        sha1 = "c6bc72adda4603fd3184fee7e99694ed8fd69ad2";
      })
    ];
    buildInputs =
      (self.nativeDeps."keybase-ecurve" or []);
    deps = [
      self.by-version."bn"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keybase-ecurve" ];
  };
  by-spec."keybase-path"."0.0.15" =
    self.by-version."keybase-path"."0.0.15";
  by-version."keybase-path"."0.0.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-keybase-path-0.0.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keybase-path/-/keybase-path-0.0.15.tgz";
        name = "keybase-path-0.0.15.tgz";
        sha1 = "94b95448fc4edf73e096366279bd28a469d5f72f";
      })
    ];
    buildInputs =
      (self.nativeDeps."keybase-path" or []);
    deps = [
      self.by-version."iced-runtime"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keybase-path" ];
  };
  "keybase-path" = self.by-version."keybase-path"."0.0.15";
  by-spec."keybase-proofs"."^1.1.3" =
    self.by-version."keybase-proofs"."1.1.3";
  by-version."keybase-proofs"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-keybase-proofs-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keybase-proofs/-/keybase-proofs-1.1.3.tgz";
        name = "keybase-proofs-1.1.3.tgz";
        sha1 = "f2a1a77c7e978a70480fb6ef4fb236f413f729da";
      })
    ];
    buildInputs =
      (self.nativeDeps."keybase-proofs" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-lock"."1.0.1"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."pgp-utils"."0.0.27"
      self.by-version."triplesec"."3.0.19"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "keybase-proofs" ];
  };
  "keybase-proofs" = self.by-version."keybase-proofs"."1.1.3";
  by-spec."libkeybase"."^0.0.6" =
    self.by-version."libkeybase"."0.0.6";
  by-version."libkeybase"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-libkeybase-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/libkeybase/-/libkeybase-0.0.6.tgz";
        name = "libkeybase-0.0.6.tgz";
        sha1 = "03d19afe7ca48ca041d962f0885d373faca2e90e";
      })
    ];
    buildInputs =
      (self.nativeDeps."libkeybase" or []);
    deps = [
      self.by-version."iced-lock"."1.0.1"
      self.by-version."iced-logger"."0.0.5"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."kbpgp"."1.0.5"
      self.by-version."tweetnacl"."0.12.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "libkeybase" ];
  };
  "libkeybase" = self.by-version."libkeybase"."0.0.6";
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.5.0";
  by-version."lru-cache"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-lru-cache-2.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.0.tgz";
        name = "lru-cache-2.5.0.tgz";
        sha1 = "d82388ae9c960becbea0c73bb9eb79b6c6ce9aeb";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."marked".">= 0.2.7" =
    self.by-version."marked"."0.3.2";
  by-version."marked"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "marked-0.3.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/marked/-/marked-0.3.2.tgz";
        name = "marked-0.3.2.tgz";
        sha1 = "015db158864438f24a64bdd61a0428b418706d09";
      })
    ];
    buildInputs =
      (self.nativeDeps."marked" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "marked" ];
  };
  by-spec."merkle-tree"."0.0.12" =
    self.by-version."merkle-tree"."0.0.12";
  by-version."merkle-tree"."0.0.12" = lib.makeOverridable self.buildNodePackage {
    name = "node-merkle-tree-0.0.12";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/merkle-tree/-/merkle-tree-0.0.12.tgz";
        name = "merkle-tree-0.0.12.tgz";
        sha1 = "c8d6f0e9489b828c1d02942b24514311bac5e30f";
      })
    ];
    buildInputs =
      (self.nativeDeps."merkle-tree" or []);
    deps = [
      self.by-version."deep-equal"."0.2.1"
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."iced-utils"."0.1.21"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "merkle-tree" ];
  };
  "merkle-tree" = self.by-version."merkle-tree"."0.0.12";
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-1.2.11";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        name = "mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."~1.2.9" =
    self.by-version."mime"."1.2.11";
  by-spec."minimatch"."^1.0.0" =
    self.by-version."minimatch"."1.0.0";
  by-version."minimatch"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimatch-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-1.0.0.tgz";
        name = "minimatch-1.0.0.tgz";
        sha1 = "e0dd2120b49e1b724ce8d714c520822a9438576d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = [
      self.by-version."lru-cache"."2.5.0"
      self.by-version."sigmund"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimist-0.0.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        name = "minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist".">=0.0.8" =
    self.by-version."minimist"."1.1.0";
  by-version."minimist"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimist-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-1.1.0.tgz";
        name = "minimist-1.1.0.tgz";
        sha1 = "cdf225e8898f840a258ded44fc91776770afdc93";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."~0.0.1" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "node-minimist-0.0.10";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
        name = "minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."mkdirp"."0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-mkdirp-0.3.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        name = "mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  "mkdirp" = self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."^0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-version."mkdirp"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.5.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
        name = "mkdirp-0.5.0.tgz";
        sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = [
      self.by-version."minimist"."0.0.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."more-entropy".">=0.0.7" =
    self.by-version."more-entropy"."0.0.7";
  by-version."more-entropy"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-more-entropy-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/more-entropy/-/more-entropy-0.0.7.tgz";
        name = "more-entropy-0.0.7.tgz";
        sha1 = "67bfc6f7a86f26fbc37aac83fd46d88c61d109b5";
      })
    ];
    buildInputs =
      (self.nativeDeps."more-entropy" or []);
    deps = [
      self.by-version."iced-runtime"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "more-entropy" ];
  };
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-mute-stream-0.0.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
        name = "mute-stream-0.0.4.tgz";
        sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  by-spec."ncp"."^0.6.0" =
    self.by-version."ncp"."0.6.0";
  by-version."ncp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "ncp-0.6.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ncp/-/ncp-0.6.0.tgz";
        name = "ncp-0.6.0.tgz";
        sha1 = "df8ce021e262be21b52feb3d3e5cfaab12491f0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ncp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ncp" ];
  };
  by-spec."network-byte-order"."~0.2.0" =
    self.by-version."network-byte-order"."0.2.0";
  by-version."network-byte-order"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-network-byte-order-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/network-byte-order/-/network-byte-order-0.2.0.tgz";
        name = "network-byte-order-0.2.0.tgz";
        sha1 = "6ac11bf44bf610daeddbe90a09a5c817c6e0d2b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."network-byte-order" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "network-byte-order" ];
  };
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.1";
  by-version."node-uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-node-uuid-1.4.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        name = "node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  by-spec."oauth-sign"."~0.3.0" =
    self.by-version."oauth-sign"."0.3.0";
  by-version."oauth-sign"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-oauth-sign-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
        name = "oauth-sign-0.3.0.tgz";
        sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.1";
  by-version."once"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-once-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.1.tgz";
        name = "once-1.3.1.tgz";
        sha1 = "f3f3e4da5b7d27b5c732969ee3e67e729457b31f";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = [
      self.by-version."wrappy"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."optimist"."0.6.1" =
    self.by-version."optimist"."0.6.1";
  by-version."optimist"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-optimist-0.6.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.6.1.tgz";
        name = "optimist-0.6.1.tgz";
        sha1 = "da3ea74686fa21a19a111c326e90eb15a0196686";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = [
      self.by-version."wordwrap"."0.0.2"
      self.by-version."minimist"."0.0.10"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  "optimist" = self.by-version."optimist"."0.6.1";
  by-spec."pgp-utils".">=0.0.21" =
    self.by-version."pgp-utils"."0.0.27";
  by-version."pgp-utils"."0.0.27" = lib.makeOverridable self.buildNodePackage {
    name = "node-pgp-utils-0.0.27";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pgp-utils/-/pgp-utils-0.0.27.tgz";
        name = "pgp-utils-0.0.27.tgz";
        sha1 = "3c9afdc0c5d0674bd78ed5009e2d0aec20be32b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."pgp-utils" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-runtime"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pgp-utils" ];
  };
  by-spec."pgp-utils".">=0.0.22" =
    self.by-version."pgp-utils"."0.0.27";
  "pgp-utils" = self.by-version."pgp-utils"."0.0.27";
  by-spec."pgp-utils".">=0.0.25" =
    self.by-version."pgp-utils"."0.0.27";
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-pkginfo-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        name = "pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  by-spec."progress"."1.1.3" =
    self.by-version."progress"."1.1.3";
  by-version."progress"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-progress-1.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/progress/-/progress-1.1.3.tgz";
        name = "progress-1.1.3.tgz";
        sha1 = "42f89c5fc3b6f0408a0bdd68993b174f96aababf";
      })
    ];
    buildInputs =
      (self.nativeDeps."progress" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "progress" ];
  };
  "progress" = self.by-version."progress"."1.1.3";
  by-spec."progress"."~1.1.2" =
    self.by-version."progress"."1.1.8";
  by-version."progress"."1.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-progress-1.1.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/progress/-/progress-1.1.8.tgz";
        name = "progress-1.1.8.tgz";
        sha1 = "e260c78f6161cdd9b0e56cc3e0a85de17c7a57be";
      })
    ];
    buildInputs =
      (self.nativeDeps."progress" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "progress" ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.1";
  by-version."punycode"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-punycode-1.3.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.3.1.tgz";
        name = "punycode-1.3.1.tgz";
        sha1 = "710afe5123c20a1530b712e3e682b9118fe8058e";
      })
    ];
    buildInputs =
      (self.nativeDeps."punycode" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "punycode" ];
  };
  by-spec."purepack"."1.0.1" =
    self.by-version."purepack"."1.0.1";
  by-version."purepack"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-purepack-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/purepack/-/purepack-1.0.1.tgz";
        name = "purepack-1.0.1.tgz";
        sha1 = "9592f35bc22279a777885d3de04acc3555994f68";
      })
    ];
    buildInputs =
      (self.nativeDeps."purepack" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "purepack" ];
  };
  "purepack" = self.by-version."purepack"."1.0.1";
  by-spec."purepack".">=1" =
    self.by-version."purepack"."1.0.1";
  by-spec."purepack".">=1.0.1" =
    self.by-version."purepack"."1.0.1";
  by-spec."qs"."~0.6.0" =
    self.by-version."qs"."0.6.6";
  by-version."qs"."0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-0.6.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
        name = "qs-0.6.6.tgz";
        sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."read"."~1.0.5" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-read-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        name = "read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read" or []);
    deps = [
      self.by-version."mute-stream"."0.0.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  "read" = self.by-version."read"."1.0.5";
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-version."readable-stream"."1.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "node-readable-stream-1.1.13";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.13.tgz";
        name = "readable-stream-1.1.13.tgz";
        sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = [
      self.by-version."core-util-is"."1.0.1"
      self.by-version."isarray"."0.0.1"
      self.by-version."string_decoder"."0.10.31"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."request"."2.30.0" =
    self.by-version."request"."2.30.0";
  by-version."request"."2.30.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.30.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.30.0.tgz";
        name = "request-2.30.0.tgz";
        sha1 = "8e0d36f0806e8911524b072b64c5ee535a09d861";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = [
      self.by-version."qs"."0.6.6"
      self.by-version."json-stringify-safe"."5.0.0"
      self.by-version."forever-agent"."0.5.2"
      self.by-version."node-uuid"."1.4.1"
      self.by-version."mime"."1.2.11"
      self.by-version."tough-cookie"."0.9.15"
      self.by-version."form-data"."0.1.4"
      self.by-version."tunnel-agent"."0.3.0"
      self.by-version."http-signature"."0.10.0"
      self.by-version."oauth-sign"."0.3.0"
      self.by-version."hawk"."1.0.0"
      self.by-version."aws-sign2"."0.5.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  "request" = self.by-version."request"."2.30.0";
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.2.8";
  by-version."rimraf"."2.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        name = "rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."semver"."2.2.1" =
    self.by-version."semver"."2.2.1";
  by-version."semver"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.2.1.tgz";
        name = "semver-2.2.1.tgz";
        sha1 = "7941182b3ffcc580bff1c17942acdf7951c0d213";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  "semver" = self.by-version."semver"."2.2.1";
  by-spec."semver"."~2.2.1" =
    self.by-version."semver"."2.2.1";
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.0";
  by-version."sigmund"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-sigmund-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.0.tgz";
        name = "sigmund-1.0.0.tgz";
        sha1 = "66a2b3a749ae8b5fb89efd4fcc01dc94fbe02296";
      })
    ];
    buildInputs =
      (self.nativeDeps."sigmund" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sigmund" ];
  };
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-sntp-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
        name = "sntp-0.2.4.tgz";
        sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = [
      self.by-version."hoek"."0.9.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."socks5-client"."0.x" =
    self.by-version."socks5-client"."0.3.6";
  by-version."socks5-client"."0.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-socks5-client-0.3.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socks5-client/-/socks5-client-0.3.6.tgz";
        name = "socks5-client-0.3.6.tgz";
        sha1 = "4205b5791f2df77cf07527222558fe4e46aca2f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."socks5-client" or []);
    deps = [
      self.by-version."ipv6"."3.1.1"
      self.by-version."network-byte-order"."0.2.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socks5-client" ];
  };
  by-spec."socks5-client"."^0.3.6" =
    self.by-version."socks5-client"."0.3.6";
  "socks5-client" = self.by-version."socks5-client"."0.3.6";
  by-spec."socks5-client"."~0.3.4" =
    self.by-version."socks5-client"."0.3.6";
  by-spec."socks5-http-client"."^0.1.6" =
    self.by-version."socks5-http-client"."0.1.6";
  by-version."socks5-http-client"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-socks5-http-client-0.1.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socks5-http-client/-/socks5-http-client-0.1.6.tgz";
        name = "socks5-http-client-0.1.6.tgz";
        sha1 = "a915ba75573787876e5d3756ee4a81d60cd4b69b";
      })
    ];
    buildInputs =
      (self.nativeDeps."socks5-http-client" or []);
    deps = [
      self.by-version."socks5-client"."0.3.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socks5-http-client" ];
  };
  "socks5-http-client" = self.by-version."socks5-http-client"."0.1.6";
  by-spec."socks5-https-client"."^0.2.2" =
    self.by-version."socks5-https-client"."0.2.2";
  by-version."socks5-https-client"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-socks5-https-client-0.2.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/socks5-https-client/-/socks5-https-client-0.2.2.tgz";
        name = "socks5-https-client-0.2.2.tgz";
        sha1 = "b855e950e97c4fa6bca72a108f00278d33ac91d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."socks5-https-client" or []);
    deps = [
      self.by-version."socks5-client"."0.3.6"
      self.by-version."starttls"."0.2.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "socks5-https-client" ];
  };
  "socks5-https-client" = self.by-version."socks5-https-client"."0.2.2";
  by-spec."sprintf"."0.1.x" =
    self.by-version."sprintf"."0.1.4";
  by-version."sprintf"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-sprintf-0.1.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sprintf/-/sprintf-0.1.4.tgz";
        name = "sprintf-0.1.4.tgz";
        sha1 = "6f870a8f4aae1c7fe53eee02b6ca31aa2d78863b";
      })
    ];
    buildInputs =
      (self.nativeDeps."sprintf" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "sprintf" ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "node-stack-trace-0.0.9";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
        name = "stack-trace-0.0.9.tgz";
        sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  by-spec."starttls"."0.x" =
    self.by-version."starttls"."0.2.1";
  by-version."starttls"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-starttls-0.2.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/starttls/-/starttls-0.2.1.tgz";
        name = "starttls-0.2.1.tgz";
        sha1 = "b98d3e5e778d46f199c843a64f889f0347c6d19a";
      })
    ];
    buildInputs =
      (self.nativeDeps."starttls" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "starttls" ];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = lib.makeOverridable self.buildNodePackage {
    name = "node-string_decoder-0.10.31";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
        name = "string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      })
    ];
    buildInputs =
      (self.nativeDeps."string_decoder" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "string_decoder" ];
  };
  by-spec."tablify"."0.1.5" =
    self.by-version."tablify"."0.1.5";
  by-version."tablify"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-tablify-0.1.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tablify/-/tablify-0.1.5.tgz";
        name = "tablify-0.1.5.tgz";
        sha1 = "47160ce2918be291d63cecceddb5254dd72982c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."tablify" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tablify" ];
  };
  "tablify" = self.by-version."tablify"."0.1.5";
  by-spec."tablify".">=0.1.5" =
    self.by-version."tablify"."0.1.5";
  by-spec."timeago"."0.1.0" =
    self.by-version."timeago"."0.1.0";
  by-version."timeago"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-timeago-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/timeago/-/timeago-0.1.0.tgz";
        name = "timeago-0.1.0.tgz";
        sha1 = "21176a84d469be35ee431c5c48c0b6aba1f72464";
      })
    ];
    buildInputs =
      (self.nativeDeps."timeago" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "timeago" ];
  };
  "timeago" = self.by-version."timeago"."0.1.0";
  by-spec."tough-cookie"."~0.9.15" =
    self.by-version."tough-cookie"."0.9.15";
  by-version."tough-cookie"."0.9.15" = lib.makeOverridable self.buildNodePackage {
    name = "node-tough-cookie-0.9.15";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.9.15.tgz";
        name = "tough-cookie-0.9.15.tgz";
        sha1 = "75617ac347e3659052b0350131885829677399f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."tough-cookie" or []);
    deps = [
      self.by-version."punycode"."1.3.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
  };
  by-spec."triplesec".">=3.0.16" =
    self.by-version."triplesec"."3.0.19";
  by-version."triplesec"."3.0.19" = lib.makeOverridable self.buildNodePackage {
    name = "node-triplesec-3.0.19";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/triplesec/-/triplesec-3.0.19.tgz";
        name = "triplesec-3.0.19.tgz";
        sha1 = "1cf858ccfcc133a3e884ff7d37aedf3b306c32f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."triplesec" or []);
    deps = [
      self.by-version."iced-error"."0.0.9"
      self.by-version."iced-lock"."1.0.1"
      self.by-version."iced-runtime"."1.0.1"
      self.by-version."more-entropy"."0.0.7"
      self.by-version."progress"."1.1.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "triplesec" ];
  };
  "triplesec" = self.by-version."triplesec"."3.0.19";
  by-spec."triplesec".">=3.0.19" =
    self.by-version."triplesec"."3.0.19";
  by-spec."tunnel-agent"."~0.3.0" =
    self.by-version."tunnel-agent"."0.3.0";
  by-version."tunnel-agent"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-tunnel-agent-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.3.0.tgz";
        name = "tunnel-agent-0.3.0.tgz";
        sha1 = "ad681b68f5321ad2827c4cfb1b7d5df2cfe942ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."tweetnacl"."^0.12.0" =
    self.by-version."tweetnacl"."0.12.2";
  by-version."tweetnacl"."0.12.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-tweetnacl-0.12.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tweetnacl/-/tweetnacl-0.12.2.tgz";
        name = "tweetnacl-0.12.2.tgz";
        sha1 = "bd59f890507856fb0a1136acc3a8b44547e29ddb";
      })
    ];
    buildInputs =
      (self.nativeDeps."tweetnacl" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tweetnacl" ];
  };
  by-spec."underscore".">= 1.0.0" =
    self.by-version."underscore"."1.7.0";
  by-version."underscore"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore-1.7.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.7.0.tgz";
        name = "underscore-1.7.0.tgz";
        sha1 = "6bbaf0877500d36be34ecaa584e0db9fef035209";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore"."~1.4" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore-1.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        name = "underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."underscore"."~1.4.3" =
    self.by-version."underscore"."1.4.4";
  by-spec."underscore.string"."~2.3.1" =
    self.by-version."underscore.string"."2.3.3";
  by-version."underscore.string"."2.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-underscore.string-2.3.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.3.3.tgz";
        name = "underscore.string-2.3.3.tgz";
        sha1 = "71c08bf6b428b1133f37e78fa3a21c82f7329b0d";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  by-spec."winston"."0.8.x" =
    self.by-version."winston"."0.8.0";
  by-version."winston"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-winston-0.8.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.8.0.tgz";
        name = "winston-0.8.0.tgz";
        sha1 = "61d0830fa699706212206b0a2b5ca69a93043668";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = [
      self.by-version."async"."0.2.10"
      self.by-version."colors"."0.6.2"
      self.by-version."cycle"."1.0.3"
      self.by-version."eyes"."0.1.8"
      self.by-version."pkginfo"."0.3.0"
      self.by-version."stack-trace"."0.0.9"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-wordwrap-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        name = "wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-wrappy-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
        name = "wrappy-1.0.1.tgz";
        sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
      })
    ];
    buildInputs =
      (self.nativeDeps."wrappy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "wrappy" ];
  };
}

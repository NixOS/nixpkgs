{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.0.5";
  by-version."abbrev"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "abbrev-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.5.tgz";
        name = "abbrev-1.0.5.tgz";
        sha1 = "5d8257bd9ebe435e698b2fa431afde4fe7b10b03";
      })
    ];
    buildInputs =
      (self.nativeDeps."abbrev" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "abbrev" ];
  };
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."0.1.0";
  by-version."amdefine"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "amdefine-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/amdefine/-/amdefine-0.1.0.tgz";
        name = "amdefine-0.1.0.tgz";
        sha1 = "3ca9735cf1dde0edf7a4bf6641709c8024f9b227";
      })
    ];
    buildInputs =
      (self.nativeDeps."amdefine" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "amdefine" ];
  };
  by-spec."ansi-regex"."^1.0.0" =
    self.by-version."ansi-regex"."1.1.1";
  by-version."ansi-regex"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-regex-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-1.1.1.tgz";
        name = "ansi-regex-1.1.1.tgz";
        sha1 = "41c847194646375e6a1a5d10c3ca054ef9fc980d";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-regex" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-regex" ];
  };
  by-spec."ansi-regex"."^1.1.0" =
    self.by-version."ansi-regex"."1.1.1";
  by-spec."ansi-styles"."^2.0.1" =
    self.by-version."ansi-styles"."2.0.1";
  by-version."ansi-styles"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-styles-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-2.0.1.tgz";
        name = "ansi-styles-2.0.1.tgz";
        sha1 = "b033f57f93e2d28adeb8bc11138fa13da0fd20a3";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi-styles" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi-styles" ];
  };
  by-spec."array-differ"."^0.1.0" =
    self.by-version."array-differ"."0.1.0";
  by-version."array-differ"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "array-differ-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-differ/-/array-differ-0.1.0.tgz";
        name = "array-differ-0.1.0.tgz";
        sha1 = "12e2c9b706bed47c8b483b57e487473fb0861f3a";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-differ" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "array-differ" ];
  };
  by-spec."array-union"."^0.1.0" =
    self.by-version."array-union"."0.1.0";
  by-version."array-union"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "array-union-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-union/-/array-union-0.1.0.tgz";
        name = "array-union-0.1.0.tgz";
        sha1 = "ede98088330665e699e1ebf0227cbc6034e627db";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-union" or []);
    deps = {
      "array-uniq-0.1.1" = self.by-version."array-uniq"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "array-union" ];
  };
  by-spec."array-uniq"."^0.1.0" =
    self.by-version."array-uniq"."0.1.1";
  by-version."array-uniq"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "array-uniq-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/array-uniq/-/array-uniq-0.1.1.tgz";
        name = "array-uniq-0.1.1.tgz";
        sha1 = "5861f3ed4e4bb6175597a4e078e8aa78ebe958c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."array-uniq" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "array-uniq" ];
  };
  by-spec."asn1"."0.1.11" =
    self.by-version."asn1"."0.1.11";
  by-version."asn1"."0.1.11" = lib.makeOverridable self.buildNodePackage {
    name = "asn1-0.1.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/asn1/-/asn1-0.1.11.tgz";
        name = "asn1-0.1.11.tgz";
        sha1 = "559be18376d08a4ec4dbe80877d27818639b2df7";
      })
    ];
    buildInputs =
      (self.nativeDeps."asn1" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "asn1" ];
  };
  by-spec."assert-plus"."^0.1.5" =
    self.by-version."assert-plus"."0.1.5";
  by-version."assert-plus"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "assert-plus-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.5.tgz";
        name = "assert-plus-0.1.5.tgz";
        sha1 = "ee74009413002d84cec7219c6ac811812e723160";
      })
    ];
    buildInputs =
      (self.nativeDeps."assert-plus" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "assert-plus" ];
  };
  by-spec."async"."0.8.x" =
    self.by-version."async"."0.8.0";
  by-version."async"."0.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.8.0.tgz";
        name = "async-0.8.0.tgz";
        sha1 = "ee65ec77298c2ff1456bc4418a052d0f06435112";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."^0.9.0" =
    self.by-version."async"."0.9.0";
  by-version."async"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.9.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.9.0.tgz";
        name = "async-0.9.0.tgz";
        sha1 = "ac3613b1da9bed1b47510bb4651b8931e47146c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."~0.2.6" =
    self.by-version."async"."0.2.10";
  by-version."async"."0.2.10" = lib.makeOverridable self.buildNodePackage {
    name = "async-0.2.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/async/-/async-0.2.10.tgz";
        name = "async-0.2.10.tgz";
        sha1 = "b6bbe0b0674b9d719708ca38de8c237cb526c3d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."async" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "async" ];
  };
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-spec."aws-sign2"."~0.5.0" =
    self.by-version."aws-sign2"."0.5.0";
  by-version."aws-sign2"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign2-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign2/-/aws-sign2-0.5.0.tgz";
        name = "aws-sign2-0.5.0.tgz";
        sha1 = "c57103f7a17fc037f02d7c2e64b602ea223f7d63";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign2" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign2" ];
  };
  by-spec."balanced-match"."^0.2.0" =
    self.by-version."balanced-match"."0.2.0";
  by-version."balanced-match"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "balanced-match-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.2.0.tgz";
        name = "balanced-match-0.2.0.tgz";
        sha1 = "38f6730c03aab6d5edbb52bd934885e756d71674";
      })
    ];
    buildInputs =
      (self.nativeDeps."balanced-match" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "balanced-match" ];
  };
  by-spec."bindings"."*" =
    self.by-version."bindings"."1.2.1";
  by-version."bindings"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-1.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings/-/bindings-1.2.1.tgz";
        name = "bindings-1.2.1.tgz";
        sha1 = "14ad6113812d2d37d72e67b4cacb4bb726505f11";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bindings" ];
  };
  by-spec."bl"."~0.9.0" =
    self.by-version."bl"."0.9.4";
  by-version."bl"."0.9.4" = lib.makeOverridable self.buildNodePackage {
    name = "bl-0.9.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bl/-/bl-0.9.4.tgz";
        name = "bl-0.9.4.tgz";
        sha1 = "4702ddf72fbe0ecd82787c00c113aea1935ad0e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."bl" or []);
    deps = {
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bl" ];
  };
  by-spec."bluebird"."^2.9.21" =
    self.by-version."bluebird"."2.9.24";
  by-version."bluebird"."2.9.24" = lib.makeOverridable self.buildNodePackage {
    name = "bluebird-2.9.24";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.24.tgz";
        name = "bluebird-2.9.24.tgz";
        sha1 = "14a2e75f0548323dc35aa440d92007ca154e967c";
      })
    ];
    buildInputs =
      (self.nativeDeps."bluebird" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bluebird" ];
  };
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.4.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
        name = "boom-0.4.2.tgz";
        sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.7.0";
  by-version."boom"."2.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "boom-2.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-2.7.0.tgz";
        name = "boom-2.7.0.tgz";
        sha1 = "47c6c7f62dc6d68742a75c4010b035c62615d265";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = {
      "hoek-2.12.0" = self.by-version."hoek"."2.12.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.0";
  by-version."brace-expansion"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "brace-expansion-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.0.tgz";
        name = "brace-expansion-1.1.0.tgz";
        sha1 = "c9b7d03c03f37bc704be100e522b40db8f6cfcd9";
      })
    ];
    buildInputs =
      (self.nativeDeps."brace-expansion" or []);
    deps = {
      "balanced-match-0.2.0" = self.by-version."balanced-match"."0.2.0";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "brace-expansion" ];
  };
  by-spec."browser-request".">= 0.3.1 < 0.4.0" =
    self.by-version."browser-request"."0.3.3";
  by-version."browser-request"."0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "browser-request-0.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/browser-request/-/browser-request-0.3.3.tgz";
        name = "browser-request-0.3.3.tgz";
        sha1 = "9ece5b5aca89a29932242e18bf933def9876cc17";
      })
    ];
    buildInputs =
      (self.nativeDeps."browser-request" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "browser-request" ];
  };
  by-spec."camelcase"."^1.0.2" =
    self.by-version."camelcase"."1.0.2";
  by-version."camelcase"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "camelcase-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/camelcase/-/camelcase-1.0.2.tgz";
        name = "camelcase-1.0.2.tgz";
        sha1 = "7912eac1d496836782c976c2d73e874dc54f2eaf";
      })
    ];
    buildInputs =
      (self.nativeDeps."camelcase" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "camelcase" ];
  };
  by-spec."caseless"."~0.9.0" =
    self.by-version."caseless"."0.9.0";
  by-version."caseless"."0.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "caseless-0.9.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/caseless/-/caseless-0.9.0.tgz";
        name = "caseless-0.9.0.tgz";
        sha1 = "b7b65ce6bf1413886539cfd533f0b30effa9cf88";
      })
    ];
    buildInputs =
      (self.nativeDeps."caseless" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "caseless" ];
  };
  by-spec."chalk"."^1.0.0" =
    self.by-version."chalk"."1.0.0";
  by-version."chalk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-1.0.0.tgz";
        name = "chalk-1.0.0.tgz";
        sha1 = "b3cf4ed0ff5397c99c75b8f679db2f52831f96dc";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = {
      "ansi-styles-2.0.1" = self.by-version."ansi-styles"."2.0.1";
      "escape-string-regexp-1.0.3" = self.by-version."escape-string-regexp"."1.0.3";
      "has-ansi-1.0.3" = self.by-version."has-ansi"."1.0.3";
      "strip-ansi-2.0.1" = self.by-version."strip-ansi"."2.0.1";
      "supports-color-1.3.1" = self.by-version."supports-color"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."clean-css"."2.2.x" =
    self.by-version."clean-css"."2.2.23";
  by-version."clean-css"."2.2.23" = lib.makeOverridable self.buildNodePackage {
    name = "clean-css-2.2.23";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/clean-css/-/clean-css-2.2.23.tgz";
        name = "clean-css-2.2.23.tgz";
        sha1 = "0590b5478b516c4903edc2d89bd3fdbdd286328c";
      })
    ];
    buildInputs =
      (self.nativeDeps."clean-css" or []);
    deps = {
      "commander-2.2.0" = self.by-version."commander"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "clean-css" ];
  };
  by-spec."cli"."0.6.x" =
    self.by-version."cli"."0.6.6";
  by-version."cli"."0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "cli-0.6.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cli/-/cli-0.6.6.tgz";
        name = "cli-0.6.6.tgz";
        sha1 = "02ad44a380abf27adac5e6f0cdd7b043d74c53e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."cli" or []);
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cli" ];
  };
  by-spec."combined-stream"."~0.0.4" =
    self.by-version."combined-stream"."0.0.7";
  by-version."combined-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "combined-stream-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/combined-stream/-/combined-stream-0.0.7.tgz";
        name = "combined-stream-0.0.7.tgz";
        sha1 = "0137e657baa5a7541c57ac37ac5fc07d73b4dc1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."combined-stream" or []);
    deps = {
      "delayed-stream-0.0.5" = self.by-version."delayed-stream"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "combined-stream" ];
  };
  by-spec."combined-stream"."~0.0.5" =
    self.by-version."combined-stream"."0.0.7";
  by-spec."commander"."0.6.1" =
    self.by-version."commander"."0.6.1";
  by-version."commander"."0.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-0.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
        name = "commander-0.6.1.tgz";
        sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.2.x" =
    self.by-version."commander"."2.2.0";
  by-version."commander"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.2.0.tgz";
        name = "commander-2.2.0.tgz";
        sha1 = "175ad4b9317f3ff615f201c1e57224f55a3e91df";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."2.3.0" =
    self.by-version."commander"."2.3.0";
  by-version."commander"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.3.0.tgz";
        name = "commander-2.3.0.tgz";
        sha1 = "fd430e889832ec353b9acd1de217c11cb3eef873";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  by-spec."commander"."^2.3.0" =
    self.by-version."commander"."2.7.1";
  by-version."commander"."2.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.7.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.7.1.tgz";
        name = "commander-2.7.1.tgz";
        sha1 = "5d419a2bbed2c32ee3e4dca9bb45ab83ecc3065a";
      })
    ];
    buildInputs =
      (self.nativeDeps."commander" or []);
    deps = {
      "graceful-readlink-1.0.1" = self.by-version."graceful-readlink"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "commander" ];
  };
  "commander" = self.by-version."commander"."2.7.1";
  by-spec."commander"."^2.7.1" =
    self.by-version."commander"."2.7.1";
  by-spec."concat-map"."0.0.1" =
    self.by-version."concat-map"."0.0.1";
  by-version."concat-map"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "concat-map-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
        name = "concat-map-0.0.1.tgz";
        sha1 = "d8a96bd77fd68df7793a73036a3ba0d5405d477b";
      })
    ];
    buildInputs =
      (self.nativeDeps."concat-map" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "concat-map" ];
  };
  by-spec."console-browserify"."1.1.x" =
    self.by-version."console-browserify"."1.1.0";
  by-version."console-browserify"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "console-browserify-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/console-browserify/-/console-browserify-1.1.0.tgz";
        name = "console-browserify-1.1.0.tgz";
        sha1 = "f0241c45730a9fc6323b206dbf38edc741d0bb10";
      })
    ];
    buildInputs =
      (self.nativeDeps."console-browserify" or []);
    deps = {
      "date-now-0.1.4" = self.by-version."date-now"."0.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "console-browserify" ];
  };
  by-spec."contextify".">= 0.1.9 < 0.2.0" =
    self.by-version."contextify"."0.1.13";
  by-version."contextify"."0.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "contextify-0.1.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/contextify/-/contextify-0.1.13.tgz";
        name = "contextify-0.1.13.tgz";
        sha1 = "4ecac6abf6fd266aff1a7b5c4fcc902932cb4efe";
      })
    ];
    buildInputs =
      (self.nativeDeps."contextify" or []);
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.5.3" = self.by-version."nan"."1.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "contextify" ];
  };
  by-spec."core-util-is"."~1.0.0" =
    self.by-version."core-util-is"."1.0.1";
  by-version."core-util-is"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "core-util-is-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/core-util-is/-/core-util-is-1.0.1.tgz";
        name = "core-util-is-1.0.1.tgz";
        sha1 = "6b07085aef9a3ccac6ee53bf9d3df0c1521a5538";
      })
    ];
    buildInputs =
      (self.nativeDeps."core-util-is" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "core-util-is" ];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
        name = "cryptiles-0.2.2.tgz";
        sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = {
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."cryptiles"."2.x.x" =
    self.by-version."cryptiles"."2.0.4";
  by-version."cryptiles"."2.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-2.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-2.0.4.tgz";
        name = "cryptiles-2.0.4.tgz";
        sha1 = "09ea1775b9e1c7de7e60a99d42ab6f08ce1a1285";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = {
      "boom-2.7.0" = self.by-version."boom"."2.7.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
  };
  by-spec."csslint"."0.10.x" =
    self.by-version."csslint"."0.10.0";
  by-version."csslint"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "csslint-0.10.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/csslint/-/csslint-0.10.0.tgz";
        name = "csslint-0.10.0.tgz";
        sha1 = "3a6a04e7565c8e9d19beb49767c7ec96e8365805";
      })
    ];
    buildInputs =
      (self.nativeDeps."csslint" or []);
    deps = {
      "parserlib-0.2.5" = self.by-version."parserlib"."0.2.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "csslint" ];
  };
  by-spec."cssom"."0.3.x" =
    self.by-version."cssom"."0.3.0";
  by-version."cssom"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "cssom-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cssom/-/cssom-0.3.0.tgz";
        name = "cssom-0.3.0.tgz";
        sha1 = "386d5135528fe65c1ee1bc7c4e55a38854dbcf7a";
      })
    ];
    buildInputs =
      (self.nativeDeps."cssom" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cssom" ];
  };
  by-spec."cssom".">= 0.3.0 < 0.4.0" =
    self.by-version."cssom"."0.3.0";
  by-spec."cssstyle".">= 0.2.21 < 0.3.0" =
    self.by-version."cssstyle"."0.2.23";
  by-version."cssstyle"."0.2.23" = lib.makeOverridable self.buildNodePackage {
    name = "cssstyle-0.2.23";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cssstyle/-/cssstyle-0.2.23.tgz";
        name = "cssstyle-0.2.23.tgz";
        sha1 = "34af29a8e9d82ffa031573cbce4309ca27a899f6";
      })
    ];
    buildInputs =
      (self.nativeDeps."cssstyle" or []);
    deps = {
      "cssom-0.3.0" = self.by-version."cssom"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cssstyle" ];
  };
  by-spec."ctype"."0.5.3" =
    self.by-version."ctype"."0.5.3";
  by-version."ctype"."0.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.3.tgz";
        name = "ctype-0.5.3.tgz";
        sha1 = "82c18c2461f74114ef16c135224ad0b9144ca12f";
      })
    ];
    buildInputs =
      (self.nativeDeps."ctype" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ctype" ];
  };
  by-spec."date-now"."^0.1.4" =
    self.by-version."date-now"."0.1.4";
  by-version."date-now"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "date-now-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/date-now/-/date-now-0.1.4.tgz";
        name = "date-now-0.1.4.tgz";
        sha1 = "eaf439fd4d4848ad74e5cc7dbef200672b9e345b";
      })
    ];
    buildInputs =
      (self.nativeDeps."date-now" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "date-now" ];
  };
  by-spec."debug"."2.0.0" =
    self.by-version."debug"."2.0.0";
  by-version."debug"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "debug-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-2.0.0.tgz";
        name = "debug-2.0.0.tgz";
        sha1 = "89bd9df6732b51256bc6705342bba02ed12131ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."debug"."~0.7.0" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.7.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
        name = "debug-0.7.4.tgz";
        sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
  by-spec."decamelize"."^1.0.0" =
    self.by-version."decamelize"."1.0.0";
  by-version."decamelize"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "decamelize-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/decamelize/-/decamelize-1.0.0.tgz";
        name = "decamelize-1.0.0.tgz";
        sha1 = "5287122f71691d4505b18ff2258dc400a5b23847";
      })
    ];
    buildInputs =
      (self.nativeDeps."decamelize" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "decamelize" ];
  };
  by-spec."del"."^0.1.2" =
    self.by-version."del"."0.1.3";
  by-version."del"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "del-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/del/-/del-0.1.3.tgz";
        name = "del-0.1.3.tgz";
        sha1 = "2d724a719b5acf5c0b840b4224715e838406a419";
      })
    ];
    buildInputs =
      (self.nativeDeps."del" or []);
    deps = {
      "each-async-1.1.1" = self.by-version."each-async"."1.1.1";
      "globby-0.1.1" = self.by-version."globby"."0.1.1";
      "is-path-cwd-1.0.0" = self.by-version."is-path-cwd"."1.0.0";
      "is-path-in-cwd-1.0.0" = self.by-version."is-path-in-cwd"."1.0.0";
      "rimraf-2.3.2" = self.by-version."rimraf"."2.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "del" ];
  };
  "del" = self.by-version."del"."0.1.3";
  by-spec."delayed-stream"."0.0.5" =
    self.by-version."delayed-stream"."0.0.5";
  by-version."delayed-stream"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "delayed-stream-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/delayed-stream/-/delayed-stream-0.0.5.tgz";
        name = "delayed-stream-0.0.5.tgz";
        sha1 = "d4b1f43a93e8296dfe02694f4680bc37a313c73f";
      })
    ];
    buildInputs =
      (self.nativeDeps."delayed-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "delayed-stream" ];
  };
  by-spec."diff"."1.0.8" =
    self.by-version."diff"."1.0.8";
  by-version."diff"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "diff-1.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/diff/-/diff-1.0.8.tgz";
        name = "diff-1.0.8.tgz";
        sha1 = "343276308ec991b7bc82267ed55bc1411f971666";
      })
    ];
    buildInputs =
      (self.nativeDeps."diff" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "diff" ];
  };
  by-spec."dom-serializer"."0" =
    self.by-version."dom-serializer"."0.1.0";
  by-version."dom-serializer"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "dom-serializer-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dom-serializer/-/dom-serializer-0.1.0.tgz";
        name = "dom-serializer-0.1.0.tgz";
        sha1 = "073c697546ce0780ce23be4a28e293e40bc30c82";
      })
    ];
    buildInputs =
      (self.nativeDeps."dom-serializer" or []);
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dom-serializer" ];
  };
  by-spec."domelementtype"."1" =
    self.by-version."domelementtype"."1.3.0";
  by-version."domelementtype"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "domelementtype-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.3.0.tgz";
        name = "domelementtype-1.3.0.tgz";
        sha1 = "b17aed82e8ab59e52dd9c19b1756e0fc187204c2";
      })
    ];
    buildInputs =
      (self.nativeDeps."domelementtype" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "domelementtype" ];
  };
  by-spec."domelementtype"."~1.1.1" =
    self.by-version."domelementtype"."1.1.3";
  by-version."domelementtype"."1.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "domelementtype-1.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.3.tgz";
        name = "domelementtype-1.1.3.tgz";
        sha1 = "bd28773e2642881aec51544924299c5cd822185b";
      })
    ];
    buildInputs =
      (self.nativeDeps."domelementtype" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "domelementtype" ];
  };
  by-spec."domhandler"."2.3" =
    self.by-version."domhandler"."2.3.0";
  by-version."domhandler"."2.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "domhandler-2.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.3.0.tgz";
        name = "domhandler-2.3.0.tgz";
        sha1 = "2de59a0822d5027fabff6f032c2b25a2a8abe738";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = {
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domutils"."1.5" =
    self.by-version."domutils"."1.5.1";
  by-version."domutils"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.5.1.tgz";
        name = "domutils-1.5.1.tgz";
        sha1 = "dcd8488a26f563d61079e48c9f7b7e32373682cf";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = {
      "dom-serializer-0.1.0" = self.by-version."dom-serializer"."0.1.0";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."each-async"."^1.0.0" =
    self.by-version."each-async"."1.1.1";
  by-version."each-async"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "each-async-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/each-async/-/each-async-1.1.1.tgz";
        name = "each-async-1.1.1.tgz";
        sha1 = "dee5229bdf0ab6ba2012a395e1b869abf8813473";
      })
    ];
    buildInputs =
      (self.nativeDeps."each-async" or []);
    deps = {
      "onetime-1.0.0" = self.by-version."onetime"."1.0.0";
      "set-immediate-shim-1.0.1" = self.by-version."set-immediate-shim"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "each-async" ];
  };
  by-spec."entities"."1.0" =
    self.by-version."entities"."1.0.0";
  by-version."entities"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "entities-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-1.0.0.tgz";
        name = "entities-1.0.0.tgz";
        sha1 = "b2987aa3821347fcde642b24fdfc9e4fb712bf26";
      })
    ];
    buildInputs =
      (self.nativeDeps."entities" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "entities" ];
  };
  by-spec."entities"."~1.1.1" =
    self.by-version."entities"."1.1.1";
  by-version."entities"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "entities-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/entities/-/entities-1.1.1.tgz";
        name = "entities-1.1.1.tgz";
        sha1 = "6e5c2d0a5621b5dadaecef80b90edfb5cd7772f0";
      })
    ];
    buildInputs =
      (self.nativeDeps."entities" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "entities" ];
  };
  by-spec."escape-string-regexp"."1.0.2" =
    self.by-version."escape-string-regexp"."1.0.2";
  by-version."escape-string-regexp"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "escape-string-regexp-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.2.tgz";
        name = "escape-string-regexp-1.0.2.tgz";
        sha1 = "4dbc2fe674e71949caf3fb2695ce7f2dc1d9a8d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-string-regexp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "escape-string-regexp" ];
  };
  by-spec."escape-string-regexp"."^1.0.2" =
    self.by-version."escape-string-regexp"."1.0.3";
  by-version."escape-string-regexp"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "escape-string-regexp-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.3.tgz";
        name = "escape-string-regexp-1.0.3.tgz";
        sha1 = "9e2d8b25bc2555c3336723750e03f099c2735bb5";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-string-regexp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "escape-string-regexp" ];
  };
  by-spec."exit"."0.1.2" =
    self.by-version."exit"."0.1.2";
  by-version."exit"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "exit-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/exit/-/exit-0.1.2.tgz";
        name = "exit-0.1.2.tgz";
        sha1 = "0632638f8d877cc82107d30a0fff1a17cba1cd0c";
      })
    ];
    buildInputs =
      (self.nativeDeps."exit" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "exit" ];
  };
  by-spec."exit"."0.1.x" =
    self.by-version."exit"."0.1.2";
  by-spec."extend"."~2.0.0" =
    self.by-version."extend"."2.0.0";
  by-version."extend"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "extend-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/extend/-/extend-2.0.0.tgz";
        name = "extend-2.0.0.tgz";
        sha1 = "cc3c1e238521df4c28e3f30868b7324bb5898a5c";
      })
    ];
    buildInputs =
      (self.nativeDeps."extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "extend" ];
  };
  by-spec."findup-sync"."~0.2.0" =
    self.by-version."findup-sync"."0.2.1";
  by-version."findup-sync"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "findup-sync-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.2.1.tgz";
        name = "findup-sync-0.2.1.tgz";
        sha1 = "e0a90a450075c49466ee513732057514b81e878c";
      })
    ];
    buildInputs =
      (self.nativeDeps."findup-sync" or []);
    deps = {
      "glob-4.3.5" = self.by-version."glob"."4.3.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "findup-sync" ];
  };
  by-spec."flagged-respawn"."~0.3.0" =
    self.by-version."flagged-respawn"."0.3.1";
  by-version."flagged-respawn"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "flagged-respawn-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flagged-respawn/-/flagged-respawn-0.3.1.tgz";
        name = "flagged-respawn-0.3.1.tgz";
        sha1 = "397700925df6e12452202a71e89d89545fbbbe9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."flagged-respawn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "flagged-respawn" ];
  };
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
        name = "forever-agent-0.5.2.tgz";
        sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."forever-agent"."~0.6.0" =
    self.by-version."forever-agent"."0.6.0";
  by-version."forever-agent"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.6.0.tgz";
        name = "forever-agent-0.6.0.tgz";
        sha1 = "1f9b9aff11eddb1c789c751f974ba7b15454ac5d";
      })
    ];
    buildInputs =
      (self.nativeDeps."forever-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "forever-agent" ];
  };
  by-spec."form-data"."~0.1.0" =
    self.by-version."form-data"."0.1.4";
  by-version."form-data"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.1.4.tgz";
        name = "form-data-0.1.4.tgz";
        sha1 = "91abd788aba9702b1aabfa8bc01031a2ac9e3b12";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.9.0" = self.by-version."async"."0.9.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."form-data"."~0.2.0" =
    self.by-version."form-data"."0.2.0";
  by-version."form-data"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.2.0.tgz";
        name = "form-data-0.2.0.tgz";
        sha1 = "26f8bc26da6440e299cbdcfb69035c4f77a6e466";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."gear".">= 0.8.x" =
    self.by-version."gear"."0.9.7";
  by-version."gear"."0.9.7" = lib.makeOverridable self.buildNodePackage {
    name = "gear-0.9.7";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gear/-/gear-0.9.7.tgz";
        name = "gear-0.9.7.tgz";
        sha1 = "1ead19eee639319d8e2e655494c61bd8956e777f";
      })
    ];
    buildInputs =
      (self.nativeDeps."gear" or []);
    deps = {
      "async-0.8.0" = self.by-version."async"."0.8.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "liftoff-2.0.3" = self.by-version."liftoff"."2.0.3";
      "minimist-0.1.0" = self.by-version."minimist"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gear" ];
  };
  by-spec."gear"."^0.9.4" =
    self.by-version."gear"."0.9.7";
  "gear" = self.by-version."gear"."0.9.7";
  by-spec."gear-lib"."^0.9.2" =
    self.by-version."gear-lib"."0.9.2";
  by-version."gear-lib"."0.9.2" = lib.makeOverridable self.buildNodePackage {
    name = "gear-lib-0.9.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/gear-lib/-/gear-lib-0.9.2.tgz";
        name = "gear-lib-0.9.2.tgz";
        sha1 = "bc8d461ebc81ecaffe99c1da82abe0f56eb93540";
      })
    ];
    buildInputs =
      (self.nativeDeps."gear-lib" or []);
    deps = {
      "gear-0.9.7" = self.by-version."gear"."0.9.7";
      "jslint-0.3.4" = self.by-version."jslint"."0.3.4";
      "jshint-2.5.11" = self.by-version."jshint"."2.5.11";
      "uglify-js-2.4.19" = self.by-version."uglify-js"."2.4.19";
      "csslint-0.10.0" = self.by-version."csslint"."0.10.0";
      "less-1.7.5" = self.by-version."less"."1.7.5";
      "handlebars-2.0.0" = self.by-version."handlebars"."2.0.0";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "knox-0.8.10" = self.by-version."knox"."0.8.10";
      "async-0.8.0" = self.by-version."async"."0.8.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "gear-lib" ];
  };
  "gear-lib" = self.by-version."gear-lib"."0.9.2";
  by-spec."generate-function"."^2.0.0" =
    self.by-version."generate-function"."2.0.0";
  by-version."generate-function"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "generate-function-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
        name = "generate-function-2.0.0.tgz";
        sha1 = "6858fe7c0969b7d4e9093337647ac79f60dfbe74";
      })
    ];
    buildInputs =
      (self.nativeDeps."generate-function" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "generate-function" ];
  };
  by-spec."generate-object-property"."^1.1.0" =
    self.by-version."generate-object-property"."1.1.1";
  by-version."generate-object-property"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "generate-object-property-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/generate-object-property/-/generate-object-property-1.1.1.tgz";
        name = "generate-object-property-1.1.1.tgz";
        sha1 = "8fda6b4cb69b34a189a6cebee7c4c268af47cc93";
      })
    ];
    buildInputs =
      (self.nativeDeps."generate-object-property" or []);
    deps = {
      "is-property-1.0.2" = self.by-version."is-property"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "generate-object-property" ];
  };
  by-spec."get-stdin"."^4.0.1" =
    self.by-version."get-stdin"."4.0.1";
  by-version."get-stdin"."4.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "get-stdin-4.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz";
        name = "get-stdin-4.0.1.tgz";
        sha1 = "b968c6b0a04384324902e8bf1a5df32579a450fe";
      })
    ];
    buildInputs =
      (self.nativeDeps."get-stdin" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "get-stdin" ];
  };
  by-spec."glob"."3.2.3" =
    self.by-version."glob"."3.2.3";
  by-version."glob"."3.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.3.tgz";
        name = "glob-3.2.3.tgz";
        sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."3.2.x" =
    self.by-version."glob"."3.2.11";
  by-version."glob"."3.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "glob-3.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-3.2.11.tgz";
        name = "glob-3.2.11.tgz";
        sha1 = "4a973f635b9190f715d10987d5c00fd2815ebe3d";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."^4.0.2" =
    self.by-version."glob"."4.5.3";
  by-version."glob"."4.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "glob-4.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-4.5.3.tgz";
        name = "glob-4.5.3.tgz";
        sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.4" = self.by-version."minimatch"."2.0.4";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."glob"."^4.0.5" =
    self.by-version."glob"."4.5.3";
  "glob" = self.by-version."glob"."4.5.3";
  by-spec."glob"."^4.4.2" =
    self.by-version."glob"."4.5.3";
  by-spec."glob"."~ 3.2.1" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~3.2.8" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."~4.3.0" =
    self.by-version."glob"."4.3.5";
  by-version."glob"."4.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "glob-4.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/glob/-/glob-4.3.5.tgz";
        name = "glob-4.3.5.tgz";
        sha1 = "80fbb08ca540f238acce5d11d1e9bc41e75173d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."glob" or []);
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.4" = self.by-version."minimatch"."2.0.4";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "glob" ];
  };
  by-spec."globby"."^0.1.1" =
    self.by-version."globby"."0.1.1";
  by-version."globby"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "globby-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/globby/-/globby-0.1.1.tgz";
        name = "globby-0.1.1.tgz";
        sha1 = "cbec63df724b4bea458b79a16cc0e3b1f2ca8620";
      })
    ];
    buildInputs =
      (self.nativeDeps."globby" or []);
    deps = {
      "array-differ-0.1.0" = self.by-version."array-differ"."0.1.0";
      "array-union-0.1.0" = self.by-version."array-union"."0.1.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "glob-4.5.3" = self.by-version."glob"."4.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "globby" ];
  };
  by-spec."graceful-fs"."~2.0.0" =
    self.by-version."graceful-fs"."2.0.3";
  by-version."graceful-fs"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-2.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.3.tgz";
        name = "graceful-fs-2.0.3.tgz";
        sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-fs"."~3.0.2" =
    self.by-version."graceful-fs"."3.0.6";
  by-version."graceful-fs"."3.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-3.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.6.tgz";
        name = "graceful-fs-3.0.6.tgz";
        sha1 = "dce3a18351cb94cdc82e688b2e3dd2842d1b09bb";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-fs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "graceful-fs" ];
  };
  by-spec."graceful-readlink".">= 1.0.0" =
    self.by-version."graceful-readlink"."1.0.1";
  by-version."graceful-readlink"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-readlink-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
        name = "graceful-readlink-1.0.1.tgz";
        sha1 = "4cafad76bc62f02fa039b2f94e9a3dd3a391a725";
      })
    ];
    buildInputs =
      (self.nativeDeps."graceful-readlink" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "graceful-readlink" ];
  };
  by-spec."growl"."1.8.1" =
    self.by-version."growl"."1.8.1";
  by-version."growl"."1.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "growl-1.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/growl/-/growl-1.8.1.tgz";
        name = "growl-1.8.1.tgz";
        sha1 = "4b2dec8d907e93db336624dcec0183502f8c9428";
      })
    ];
    buildInputs =
      (self.nativeDeps."growl" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "growl" ];
  };
  by-spec."handlebars"."2.0.x" =
    self.by-version."handlebars"."2.0.0";
  by-version."handlebars"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-2.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-2.0.0.tgz";
        name = "handlebars-2.0.0.tgz";
        sha1 = "6e9d7f8514a3467fa5e9f82cc158ecfc1d5ac76f";
      })
    ];
    buildInputs =
      (self.nativeDeps."handlebars" or []);
    deps = {
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
      "uglify-js-2.3.6" = self.by-version."uglify-js"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "handlebars" ];
  };
  by-spec."har-validator"."^1.4.0" =
    self.by-version."har-validator"."1.6.1";
  by-version."har-validator"."1.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "har-validator-1.6.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/har-validator/-/har-validator-1.6.1.tgz";
        name = "har-validator-1.6.1.tgz";
        sha1 = "baef452cde645eff7d26562e8e749d7fd000b7fd";
      })
    ];
    buildInputs =
      (self.nativeDeps."har-validator" or []);
    deps = {
      "bluebird-2.9.24" = self.by-version."bluebird"."2.9.24";
      "chalk-1.0.0" = self.by-version."chalk"."1.0.0";
      "commander-2.7.1" = self.by-version."commander"."2.7.1";
      "is-my-json-valid-2.10.0" = self.by-version."is-my-json-valid"."2.10.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "har-validator" ];
  };
  by-spec."has-ansi"."^1.0.3" =
    self.by-version."has-ansi"."1.0.3";
  by-version."has-ansi"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "has-ansi-1.0.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-ansi/-/has-ansi-1.0.3.tgz";
        name = "has-ansi-1.0.3.tgz";
        sha1 = "c0b5b1615d9e382b0ff67169d967b425e48ca538";
      })
    ];
    buildInputs =
      (self.nativeDeps."has-ansi" or []);
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "has-ansi" ];
  };
  by-spec."hawk"."1.1.1" =
    self.by-version."hawk"."1.1.1";
  by-version."hawk"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.1.1.tgz";
        name = "hawk-1.1.1.tgz";
        sha1 = "87cd491f9b46e4e2aeaca335416766885d2d1ed9";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."hawk"."~2.3.0" =
    self.by-version."hawk"."2.3.1";
  by-version."hawk"."2.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-2.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-2.3.1.tgz";
        name = "hawk-2.3.1.tgz";
        sha1 = "1e731ce39447fa1d0f6d707f7bceebec0fd1ec1f";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-2.12.0" = self.by-version."hoek"."2.12.0";
      "boom-2.7.0" = self.by-version."boom"."2.7.0";
      "cryptiles-2.0.4" = self.by-version."cryptiles"."2.0.4";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.9.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
        name = "hoek-0.9.1.tgz";
        sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."hoek"."2.x.x" =
    self.by-version."hoek"."2.12.0";
  by-version."hoek"."2.12.0" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-2.12.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-2.12.0.tgz";
        name = "hoek-2.12.0.tgz";
        sha1 = "5d1196e0bf20c5cec957e8927101164effdaf1c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."hoek" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "hoek" ];
  };
  by-spec."htmlparser2"."3.8.x" =
    self.by-version."htmlparser2"."3.8.2";
  by-version."htmlparser2"."3.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-3.8.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.8.2.tgz";
        name = "htmlparser2-3.8.2.tgz";
        sha1 = "0d6bc3471d01e9766fc2c274cbac1d55b36c009c";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = {
      "domhandler-2.3.0" = self.by-version."domhandler"."2.3.0";
      "domutils-1.5.1" = self.by-version."domutils"."1.5.1";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "entities-1.0.0" = self.by-version."entities"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
  by-spec."htmlparser2".">= 3.7.3 < 4.0.0" =
    self.by-version."htmlparser2"."3.8.2";
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.1";
  by-version."http-signature"."0.10.1" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.10.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.1.tgz";
        name = "http-signature-0.10.1.tgz";
        sha1 = "4fbdac132559aa8323121e540779c0a012b27e66";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = {
      "assert-plus-0.1.5" = self.by-version."assert-plus"."0.1.5";
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.3" = self.by-version."ctype"."0.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."inflight"."^1.0.4" =
    self.by-version."inflight"."1.0.4";
  by-version."inflight"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "inflight-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inflight/-/inflight-1.0.4.tgz";
        name = "inflight-1.0.4.tgz";
        sha1 = "6cbb4521ebd51ce0ec0a936bfd7657ef7e9b172a";
      })
    ];
    buildInputs =
      (self.nativeDeps."inflight" or []);
    deps = {
      "once-1.3.1" = self.by-version."once"."1.3.1";
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "inflight" ];
  };
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-version."inherits"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "inherits-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/inherits/-/inherits-2.0.1.tgz";
        name = "inherits-2.0.1.tgz";
        sha1 = "b17d08d326b4423e568eff719f91b0b1cbdf69f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."inherits" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "inherits" ];
  };
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."is-my-json-valid"."^2.10.0" =
    self.by-version."is-my-json-valid"."2.10.0";
  by-version."is-my-json-valid"."2.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-my-json-valid-2.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.10.0.tgz";
        name = "is-my-json-valid-2.10.0.tgz";
        sha1 = "49755a8ecb2fe90baf922243cbaa245f910d2483";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-my-json-valid" or []);
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.1.1" = self.by-version."generate-object-property"."1.1.1";
      "jsonpointer-1.1.0" = self.by-version."jsonpointer"."1.1.0";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-my-json-valid" ];
  };
  by-spec."is-path-cwd"."^1.0.0" =
    self.by-version."is-path-cwd"."1.0.0";
  by-version."is-path-cwd"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-path-cwd-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-path-cwd/-/is-path-cwd-1.0.0.tgz";
        name = "is-path-cwd-1.0.0.tgz";
        sha1 = "d225ec23132e89edd38fda767472e62e65f1106d";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-path-cwd" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-path-cwd" ];
  };
  by-spec."is-path-in-cwd"."^1.0.0" =
    self.by-version."is-path-in-cwd"."1.0.0";
  by-version."is-path-in-cwd"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-path-in-cwd-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-path-in-cwd/-/is-path-in-cwd-1.0.0.tgz";
        name = "is-path-in-cwd-1.0.0.tgz";
        sha1 = "6477582b8214d602346094567003be8a9eac04dc";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-path-in-cwd" or []);
    deps = {
      "is-path-inside-1.0.0" = self.by-version."is-path-inside"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-path-in-cwd" ];
  };
  by-spec."is-path-inside"."^1.0.0" =
    self.by-version."is-path-inside"."1.0.0";
  by-version."is-path-inside"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-path-inside-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-path-inside/-/is-path-inside-1.0.0.tgz";
        name = "is-path-inside-1.0.0.tgz";
        sha1 = "fc06e5a1683fbda13de667aff717bbc10a48f37f";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-path-inside" or []);
    deps = {
      "path-is-inside-1.0.1" = self.by-version."path-is-inside"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-path-inside" ];
  };
  by-spec."is-property"."^1.0.0" =
    self.by-version."is-property"."1.0.2";
  by-version."is-property"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "is-property-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
        name = "is-property-1.0.2.tgz";
        sha1 = "57fe1c4e48474edd65b09911f26b1cd4095dda84";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-property" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-property" ];
  };
  by-spec."isarray"."0.0.1" =
    self.by-version."isarray"."0.0.1";
  by-version."isarray"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "isarray-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
        name = "isarray-0.0.1.tgz";
        sha1 = "8a18acfca9a8f4177e09abfc6038939b05d1eedf";
      })
    ];
    buildInputs =
      (self.nativeDeps."isarray" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "isarray" ];
  };
  by-spec."isstream"."~0.1.1" =
    self.by-version."isstream"."0.1.2";
  by-version."isstream"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "isstream-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
        name = "isstream-0.1.2.tgz";
        sha1 = "47e63f7af55afa6f92e1500e690eb8b8529c099a";
      })
    ];
    buildInputs =
      (self.nativeDeps."isstream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "isstream" ];
  };
  by-spec."jade"."0.26.3" =
    self.by-version."jade"."0.26.3";
  by-version."jade"."0.26.3" = lib.makeOverridable self.buildNodePackage {
    name = "jade-0.26.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jade/-/jade-0.26.3.tgz";
        name = "jade-0.26.3.tgz";
        sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
      })
    ];
    buildInputs =
      (self.nativeDeps."jade" or []);
    deps = {
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jade" ];
  };
  by-spec."jsdom"."^1.0.3" =
    self.by-version."jsdom"."1.5.0";
  by-version."jsdom"."1.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "jsdom-1.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsdom/-/jsdom-1.5.0.tgz";
        name = "jsdom-1.5.0.tgz";
        sha1 = "043492605b42ecd1fb35e19b8386336872632e91";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsdom" or []);
    deps = {
      "contextify-0.1.13" = self.by-version."contextify"."0.1.13";
      "cssom-0.3.0" = self.by-version."cssom"."0.3.0";
      "cssstyle-0.2.23" = self.by-version."cssstyle"."0.2.23";
      "htmlparser2-3.8.2" = self.by-version."htmlparser2"."3.8.2";
      "nwmatcher-1.3.4" = self.by-version."nwmatcher"."1.3.4";
      "parse5-1.4.1" = self.by-version."parse5"."1.4.1";
      "request-2.54.0" = self.by-version."request"."2.54.0";
      "xmlhttprequest-1.7.0" = self.by-version."xmlhttprequest"."1.7.0";
      "browser-request-0.3.3" = self.by-version."browser-request"."0.3.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsdom" ];
  };
  "jsdom" = self.by-version."jsdom"."1.5.0";
  by-spec."jshint"."2.5.x" =
    self.by-version."jshint"."2.5.11";
  by-version."jshint"."2.5.11" = lib.makeOverridable self.buildNodePackage {
    name = "jshint-2.5.11";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jshint/-/jshint-2.5.11.tgz";
        name = "jshint-2.5.11.tgz";
        sha1 = "e2d95858bbb1aa78300108a2e81099fb095622e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."jshint" or []);
    deps = {
      "cli-0.6.6" = self.by-version."cli"."0.6.6";
      "console-browserify-1.1.0" = self.by-version."console-browserify"."1.1.0";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "htmlparser2-3.8.2" = self.by-version."htmlparser2"."3.8.2";
      "minimatch-1.0.0" = self.by-version."minimatch"."1.0.0";
      "shelljs-0.3.0" = self.by-version."shelljs"."0.3.0";
      "strip-json-comments-1.0.2" = self.by-version."strip-json-comments"."1.0.2";
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jshint" ];
  };
  by-spec."jslint"."0.3.x" =
    self.by-version."jslint"."0.3.4";
  by-version."jslint"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "jslint-0.3.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jslint/-/jslint-0.3.4.tgz";
        name = "jslint-0.3.4.tgz";
        sha1 = "fb768ac8de0641fcc570c87ca1fbd28e293c8d75";
      })
    ];
    buildInputs =
      (self.nativeDeps."jslint" or []);
    deps = {
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "jslint" ];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.0";
  by-version."json-stringify-safe"."5.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-5.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.0.tgz";
        name = "json-stringify-safe-5.0.0.tgz";
        sha1 = "4c1f228b5050837eba9d21f50c2e6e320624566e";
      })
    ];
    buildInputs =
      (self.nativeDeps."json-stringify-safe" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "json-stringify-safe" ];
  };
  by-spec."jsonpointer"."^1.1.0" =
    self.by-version."jsonpointer"."1.1.0";
  by-version."jsonpointer"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "jsonpointer-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/jsonpointer/-/jsonpointer-1.1.0.tgz";
        name = "jsonpointer-1.1.0.tgz";
        sha1 = "c3c72efaed3b97154163dc01dd349e1cfe0f80fc";
      })
    ];
    buildInputs =
      (self.nativeDeps."jsonpointer" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "jsonpointer" ];
  };
  by-spec."knox"."0.8.x" =
    self.by-version."knox"."0.8.10";
  by-version."knox"."0.8.10" = lib.makeOverridable self.buildNodePackage {
    name = "knox-0.8.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/knox/-/knox-0.8.10.tgz";
        name = "knox-0.8.10.tgz";
        sha1 = "6a2edcdac1d2ae379d1e1994d559b95c283b2588";
      })
    ];
    buildInputs =
      (self.nativeDeps."knox" or []);
    deps = {
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "xml2js-0.2.8" = self.by-version."xml2js"."0.2.8";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "stream-counter-0.1.0" = self.by-version."stream-counter"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "knox" ];
  };
  by-spec."less"."1.7.x" =
    self.by-version."less"."1.7.5";
  by-version."less"."1.7.5" = lib.makeOverridable self.buildNodePackage {
    name = "less-1.7.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/less/-/less-1.7.5.tgz";
        name = "less-1.7.5.tgz";
        sha1 = "4f220cf7288a27eaca739df6e4808a2d4c0d5756";
      })
    ];
    buildInputs =
      (self.nativeDeps."less" or []);
    deps = {
      "graceful-fs-3.0.6" = self.by-version."graceful-fs"."3.0.6";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "request-2.40.0" = self.by-version."request"."2.40.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "clean-css-2.2.23" = self.by-version."clean-css"."2.2.23";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
    };
    peerDependencies = [
    ];
    passthru.names = [ "less" ];
  };
  by-spec."liftoff"."2.0.x" =
    self.by-version."liftoff"."2.0.3";
  by-version."liftoff"."2.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "liftoff-2.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/liftoff/-/liftoff-2.0.3.tgz";
        name = "liftoff-2.0.3.tgz";
        sha1 = "fbab25362a506ac28a3db0c55cde9562fbd70456";
      })
    ];
    buildInputs =
      (self.nativeDeps."liftoff" or []);
    deps = {
      "extend-2.0.0" = self.by-version."extend"."2.0.0";
      "findup-sync-0.2.1" = self.by-version."findup-sync"."0.2.1";
      "flagged-respawn-0.3.1" = self.by-version."flagged-respawn"."0.3.1";
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
      "resolve-1.1.6" = self.by-version."resolve"."1.1.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "liftoff" ];
  };
  by-spec."lodash"."^3.3.1" =
    self.by-version."lodash"."3.6.0";
  by-version."lodash"."3.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-3.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-3.6.0.tgz";
        name = "lodash-3.6.0.tgz";
        sha1 = "5266a8f49dd989be4f9f681b6f2a0c55285d0d9a";
      })
    ];
    buildInputs =
      (self.nativeDeps."lodash" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lodash" ];
  };
  "lodash" = self.by-version."lodash"."3.6.0";
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.5.0";
  by-version."lru-cache"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "lru-cache-2.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.5.0.tgz";
        name = "lru-cache-2.5.0.tgz";
        sha1 = "d82388ae9c960becbea0c73bb9eb79b6c6ce9aeb";
      })
    ];
    buildInputs =
      (self.nativeDeps."lru-cache" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lru-cache" ];
  };
  by-spec."mime"."*" =
    self.by-version."mime"."1.3.4";
  by-version."mime"."1.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.3.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.3.4.tgz";
        name = "mime-1.3.4.tgz";
        sha1 = "115f9e3b6b3daf2959983cb38f149a2d40eb5d53";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."1.2.x" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "mime-1.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
        name = "mime-1.2.11.tgz";
        sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime" ];
  };
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-spec."mime-db"."~1.8.0" =
    self.by-version."mime-db"."1.8.0";
  by-version."mime-db"."1.8.0" = lib.makeOverridable self.buildNodePackage {
    name = "mime-db-1.8.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.8.0.tgz";
        name = "mime-db-1.8.0.tgz";
        sha1 = "82a9b385f22b0f5954dec4d445faba0722c4ad25";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-db" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-db" ];
  };
  by-spec."mime-types"."~1.0.1" =
    self.by-version."mime-types"."1.0.2";
  by-version."mime-types"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "mime-types-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-1.0.2.tgz";
        name = "mime-types-1.0.2.tgz";
        sha1 = "995ae1392ab8affcbfcb2641dd054e943c0d5dce";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
  };
  by-spec."mime-types"."~2.0.1" =
    self.by-version."mime-types"."2.0.10";
  by-version."mime-types"."2.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "mime-types-2.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.10.tgz";
        name = "mime-types-2.0.10.tgz";
        sha1 = "eacd81bb73cab2a77447549a078d4f2018c67b4d";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = {
      "mime-db-1.8.0" = self.by-version."mime-db"."1.8.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
  };
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.10";
  by-spec."minimatch"."0.3" =
    self.by-version."minimatch"."0.3.0";
  by-version."minimatch"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz";
        name = "minimatch-0.3.0.tgz";
        sha1 = "275d8edaac4f1bb3326472089e7949c8394699dd";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."1.0.x" =
    self.by-version."minimatch"."1.0.0";
  by-version."minimatch"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-1.0.0.tgz";
        name = "minimatch-1.0.0.tgz";
        sha1 = "e0dd2120b49e1b724ce8d714c520822a9438576d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."^2.0.1" =
    self.by-version."minimatch"."2.0.4";
  by-version."minimatch"."2.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-2.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-2.0.4.tgz";
        name = "minimatch-2.0.4.tgz";
        sha1 = "83bea115803e7a097a78022427287edb762fafed";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "brace-expansion-1.1.0" = self.by-version."brace-expansion"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimatch"."~0.2.11" =
    self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.2.14";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
        name = "minimatch-0.2.14.tgz";
        sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimatch" or []);
    deps = {
      "lru-cache-2.5.0" = self.by-version."lru-cache"."2.5.0";
      "sigmund-1.0.0" = self.by-version."sigmund"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimatch" ];
  };
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
        name = "minimist-0.0.8.tgz";
        sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."0.1.x" =
    self.by-version."minimist"."0.1.0";
  by-version."minimist"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.1.0.tgz";
        name = "minimist-0.1.0.tgz";
        sha1 = "99df657a52574c21c9057497df742790b2b4c0de";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."minimist"."~1.1.0" =
    self.by-version."minimist"."1.1.1";
  by-version."minimist"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-1.1.1.tgz";
        name = "minimist-1.1.1.tgz";
        sha1 = "1bc2bc71658cdca5712475684363615b0b4f695b";
      })
    ];
    buildInputs =
      (self.nativeDeps."minimist" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "minimist" ];
  };
  by-spec."mkdirp"."0.3.0" =
    self.by-version."mkdirp"."0.3.0";
  by-version."mkdirp"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
        name = "mkdirp-0.3.0.tgz";
        sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  by-spec."mkdirp"."0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-version."mkdirp"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.5.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
        name = "mkdirp-0.5.0.tgz";
        sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
      })
    ];
    buildInputs =
      (self.nativeDeps."mkdirp" or []);
    deps = {
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mkdirp" ];
  };
  by-spec."mkdirp"."0.5.x" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."~0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mocha"."^2.0.1" =
    self.by-version."mocha"."2.2.1";
  by-version."mocha"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "mocha-2.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mocha/-/mocha-2.2.1.tgz";
        name = "mocha-2.2.1.tgz";
        sha1 = "04a2f8aeb149fe50177e00a7ef5d08c639e9126b";
      })
    ];
    buildInputs =
      (self.nativeDeps."mocha" or []);
    deps = {
      "commander-2.3.0" = self.by-version."commander"."2.3.0";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "glob-3.2.3" = self.by-version."glob"."3.2.3";
      "growl-1.8.1" = self.by-version."growl"."1.8.1";
      "jade-0.26.3" = self.by-version."jade"."0.26.3";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "supports-color-1.2.1" = self.by-version."supports-color"."1.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mocha" ];
  };
  "mocha" = self.by-version."mocha"."2.2.1";
  by-spec."ms"."0.6.2" =
    self.by-version."ms"."0.6.2";
  by-version."ms"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "ms-0.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.6.2.tgz";
        name = "ms-0.6.2.tgz";
        sha1 = "d89c2124c6fdc1353d65a8b77bf1aac4b193708c";
      })
    ];
    buildInputs =
      (self.nativeDeps."ms" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ms" ];
  };
  by-spec."nan"."~1.5.0" =
    self.by-version."nan"."1.5.3";
  by-version."nan"."1.5.3" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.5.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.5.3.tgz";
        name = "nan-1.5.3.tgz";
        sha1 = "4cd0ecc133b7b0700a492a646add427ae8a318eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.3";
  by-version."node-uuid"."1.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.3.tgz";
        name = "node-uuid-1.4.3.tgz";
        sha1 = "319bb7a56e7cb63f00b5c0cd7851cd4b4ddf1df9";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-uuid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-uuid" ];
  };
  by-spec."nopt"."~1.0.0" =
    self.by-version."nopt"."1.0.10";
  by-version."nopt"."1.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-1.0.10";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-1.0.10.tgz";
        name = "nopt-1.0.10.tgz";
        sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
      })
    ];
    buildInputs =
      (self.nativeDeps."nopt" or []);
    deps = {
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nopt" ];
  };
  by-spec."nwmatcher".">= 1.3.3 < 2.0.0" =
    self.by-version."nwmatcher"."1.3.4";
  by-version."nwmatcher"."1.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "nwmatcher-1.3.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nwmatcher/-/nwmatcher-1.3.4.tgz";
        name = "nwmatcher-1.3.4.tgz";
        sha1 = "965aa05fc3bc9de0a6438c8c07169866092fdaed";
      })
    ];
    buildInputs =
      (self.nativeDeps."nwmatcher" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "nwmatcher" ];
  };
  by-spec."oauth-sign"."~0.3.0" =
    self.by-version."oauth-sign"."0.3.0";
  by-version."oauth-sign"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.3.0.tgz";
        name = "oauth-sign-0.3.0.tgz";
        sha1 = "cb540f93bb2b22a7d5941691a288d60e8ea9386e";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."oauth-sign"."~0.6.0" =
    self.by-version."oauth-sign"."0.6.0";
  by-version."oauth-sign"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.6.0.tgz";
        name = "oauth-sign-0.6.0.tgz";
        sha1 = "7dbeae44f6ca454e1f168451d630746735813ce3";
      })
    ];
    buildInputs =
      (self.nativeDeps."oauth-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "oauth-sign" ];
  };
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.3.1";
  by-version."once"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.3.1.tgz";
        name = "once-1.3.1.tgz";
        sha1 = "f3f3e4da5b7d27b5c732969ee3e67e729457b31f";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = {
      "wrappy-1.0.1" = self.by-version."wrappy"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."onetime"."^1.0.0" =
    self.by-version."onetime"."1.0.0";
  by-version."onetime"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "onetime-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/onetime/-/onetime-1.0.0.tgz";
        name = "onetime-1.0.0.tgz";
        sha1 = "3a08a8e39d7816df52d34886374fb8ed8b651f62";
      })
    ];
    buildInputs =
      (self.nativeDeps."onetime" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "onetime" ];
  };
  by-spec."optimist"."~0.3" =
    self.by-version."optimist"."0.3.7";
  by-version."optimist"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.3.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
        name = "optimist-0.3.7.tgz";
        sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."optimist" or []);
    deps = {
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "optimist" ];
  };
  by-spec."optimist"."~0.3.5" =
    self.by-version."optimist"."0.3.7";
  by-spec."parse5".">= 1.2.0 < 2.0.0" =
    self.by-version."parse5"."1.4.1";
  by-version."parse5"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "parse5-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parse5/-/parse5-1.4.1.tgz";
        name = "parse5-1.4.1.tgz";
        sha1 = "fbfe11c8bbe9fbdc581f646dc0e783a069350ea8";
      })
    ];
    buildInputs =
      (self.nativeDeps."parse5" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "parse5" ];
  };
  by-spec."parserlib"."~0.2.2" =
    self.by-version."parserlib"."0.2.5";
  by-version."parserlib"."0.2.5" = lib.makeOverridable self.buildNodePackage {
    name = "parserlib-0.2.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parserlib/-/parserlib-0.2.5.tgz";
        name = "parserlib-0.2.5.tgz";
        sha1 = "85907dd8605aa06abb3dd295d50bb2b8fa4dd117";
      })
    ];
    buildInputs =
      (self.nativeDeps."parserlib" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "parserlib" ];
  };
  by-spec."path-is-inside"."^1.0.1" =
    self.by-version."path-is-inside"."1.0.1";
  by-version."path-is-inside"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "path-is-inside-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-is-inside/-/path-is-inside-1.0.1.tgz";
        name = "path-is-inside-1.0.1.tgz";
        sha1 = "98d8f1d030bf04bd7aeee4a1ba5485d40318fd89";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-is-inside" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-is-inside" ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "punycode-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
        name = "punycode-1.3.2.tgz";
        sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
      })
    ];
    buildInputs =
      (self.nativeDeps."punycode" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "punycode" ];
  };
  by-spec."qs"."~1.0.0" =
    self.by-version."qs"."1.0.2";
  by-version."qs"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "qs-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-1.0.2.tgz";
        name = "qs-1.0.2.tgz";
        sha1 = "50a93e2b5af6691c31bcea5dae78ee6ea1903768";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."qs"."~2.4.0" =
    self.by-version."qs"."2.4.1";
  by-version."qs"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "qs-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.4.1.tgz";
        name = "qs-2.4.1.tgz";
        sha1 = "68cbaea971013426a80c1404fad6b1a6b1175245";
      })
    ];
    buildInputs =
      (self.nativeDeps."qs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "qs" ];
  };
  by-spec."readable-stream"."1.1" =
    self.by-version."readable-stream"."1.1.13";
  by-version."readable-stream"."1.1.13" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.1.13";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.1.13.tgz";
        name = "readable-stream-1.1.13.tgz";
        sha1 = "f6eef764f514c89e2b9e23146a75ba106756d23e";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."~1.0.2" =
    self.by-version."readable-stream"."1.0.33";
  by-version."readable-stream"."1.0.33" = lib.makeOverridable self.buildNodePackage {
    name = "readable-stream-1.0.33";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/readable-stream/-/readable-stream-1.0.33.tgz";
        name = "readable-stream-1.0.33.tgz";
        sha1 = "3a360dd66c1b1d7fd4705389860eda1d0f61126c";
      })
    ];
    buildInputs =
      (self.nativeDeps."readable-stream" or []);
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "readable-stream" ];
  };
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.33";
  by-spec."request".">= 2.44.0 < 3.0.0" =
    self.by-version."request"."2.54.0";
  by-version."request"."2.54.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.54.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.54.0.tgz";
        name = "request-2.54.0.tgz";
        sha1 = "a13917cd8e8fa73332da0bf2f84a30181def1953";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.6.0" = self.by-version."forever-agent"."0.6.0";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-2.0.10" = self.by-version."mime-types"."2.0.10";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.4.1" = self.by-version."qs"."2.4.1";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.6.1" = self.by-version."har-validator"."1.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."~2.40.0" =
    self.by-version."request"."2.40.0";
  by-version."request"."2.40.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.40.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.40.0.tgz";
        name = "request-2.40.0.tgz";
        sha1 = "4dd670f696f1e6e842e66b4b5e839301ab9beb67";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "qs-1.0.2" = self.by-version."qs"."1.0.2";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."resolve"."~1.1.0" =
    self.by-version."resolve"."1.1.6";
  by-version."resolve"."1.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-1.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-1.1.6.tgz";
        name = "resolve-1.1.6.tgz";
        sha1 = "d3492ad054ca800f5befa612e61beac1eec98f8f";
      })
    ];
    buildInputs =
      (self.nativeDeps."resolve" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "resolve" ];
  };
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.3.2";
  by-version."rimraf"."2.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.3.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.3.2.tgz";
        name = "rimraf-2.3.2.tgz";
        sha1 = "7304bd9275c401b89103b106b3531c1ef0c02fe9";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
      "glob-4.5.3" = self.by-version."glob"."4.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."sax"."0.5.x" =
    self.by-version."sax"."0.5.8";
  by-version."sax"."0.5.8" = lib.makeOverridable self.buildNodePackage {
    name = "sax-0.5.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sax/-/sax-0.5.8.tgz";
        name = "sax-0.5.8.tgz";
        sha1 = "d472db228eb331c2506b0e8c15524adb939d12c1";
      })
    ];
    buildInputs =
      (self.nativeDeps."sax" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sax" ];
  };
  by-spec."set-immediate-shim"."^1.0.0" =
    self.by-version."set-immediate-shim"."1.0.1";
  by-version."set-immediate-shim"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "set-immediate-shim-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
        name = "set-immediate-shim-1.0.1.tgz";
        sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
      })
    ];
    buildInputs =
      (self.nativeDeps."set-immediate-shim" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "set-immediate-shim" ];
  };
  by-spec."shelljs"."0.3.x" =
    self.by-version."shelljs"."0.3.0";
  by-version."shelljs"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "shelljs-0.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/shelljs/-/shelljs-0.3.0.tgz";
        name = "shelljs-0.3.0.tgz";
        sha1 = "3596e6307a781544f591f37da618360f31db57b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."shelljs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "shelljs" ];
  };
  by-spec."should"."^4.0.4" =
    self.by-version."should"."4.6.5";
  by-version."should"."4.6.5" = lib.makeOverridable self.buildNodePackage {
    name = "should-4.6.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should/-/should-4.6.5.tgz";
        name = "should-4.6.5.tgz";
        sha1 = "0d12346dbbd1b028f9f4bb7a9d547364fc36a87f";
      })
    ];
    buildInputs =
      (self.nativeDeps."should" or []);
    deps = {
      "should-equal-0.3.1" = self.by-version."should-equal"."0.3.1";
      "should-format-0.0.7" = self.by-version."should-format"."0.0.7";
      "should-type-0.0.4" = self.by-version."should-type"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should" ];
  };
  "should" = self.by-version."should"."4.6.5";
  by-spec."should-equal"."0.3.1" =
    self.by-version."should-equal"."0.3.1";
  by-version."should-equal"."0.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "should-equal-0.3.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-equal/-/should-equal-0.3.1.tgz";
        name = "should-equal-0.3.1.tgz";
        sha1 = "bd8ea97a6748e39fad476a3be6fd72ebc2e72bf0";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-equal" or []);
    deps = {
      "should-type-0.0.4" = self.by-version."should-type"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-equal" ];
  };
  by-spec."should-format"."0.0.7" =
    self.by-version."should-format"."0.0.7";
  by-version."should-format"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "should-format-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-format/-/should-format-0.0.7.tgz";
        name = "should-format-0.0.7.tgz";
        sha1 = "1e2ef86bd91da9c2e0412335b56ababd9a2fde12";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-format" or []);
    deps = {
      "should-type-0.0.4" = self.by-version."should-type"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-format" ];
  };
  by-spec."should-type"."0.0.4" =
    self.by-version."should-type"."0.0.4";
  by-version."should-type"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "should-type-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/should-type/-/should-type-0.0.4.tgz";
        name = "should-type-0.0.4.tgz";
        sha1 = "0132a05417a6126866426acf116f1ed5623a5cd0";
      })
    ];
    buildInputs =
      (self.nativeDeps."should-type" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "should-type" ];
  };
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.0";
  by-version."sigmund"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "sigmund-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.0.tgz";
        name = "sigmund-1.0.0.tgz";
        sha1 = "66a2b3a749ae8b5fb89efd4fcc01dc94fbe02296";
      })
    ];
    buildInputs =
      (self.nativeDeps."sigmund" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "sigmund" ];
  };
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
        name = "sntp-0.2.4.tgz";
        sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."sntp"."1.x.x" =
    self.by-version."sntp"."1.0.9";
  by-version."sntp"."1.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-1.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
        name = "sntp-1.0.9.tgz";
        sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = {
      "hoek-2.12.0" = self.by-version."hoek"."2.12.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."source-map"."0.1.34" =
    self.by-version."source-map"."0.1.34";
  by-version."source-map"."0.1.34" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.34";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.34.tgz";
        name = "source-map-0.1.34.tgz";
        sha1 = "a7cfe89aec7b1682c3b198d0acfb47d7d090566b";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  by-spec."source-map"."0.1.x" =
    self.by-version."source-map"."0.1.43";
  by-version."source-map"."0.1.43" = lib.makeOverridable self.buildNodePackage {
    name = "source-map-0.1.43";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/source-map/-/source-map-0.1.43.tgz";
        name = "source-map-0.1.43.tgz";
        sha1 = "c24bc146ca517c1471f5dacbe2571b2b7f9e3346";
      })
    ];
    buildInputs =
      (self.nativeDeps."source-map" or []);
    deps = {
      "amdefine-0.1.0" = self.by-version."amdefine"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "source-map" ];
  };
  by-spec."source-map"."~0.1.7" =
    self.by-version."source-map"."0.1.43";
  by-spec."stream-counter"."~0.1.0" =
    self.by-version."stream-counter"."0.1.0";
  by-version."stream-counter"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "stream-counter-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stream-counter/-/stream-counter-0.1.0.tgz";
        name = "stream-counter-0.1.0.tgz";
        sha1 = "a035e429361fb57f361606e17fcd8a8b9677327b";
      })
    ];
    buildInputs =
      (self.nativeDeps."stream-counter" or []);
    deps = {
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
    };
    peerDependencies = [
    ];
    passthru.names = [ "stream-counter" ];
  };
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = lib.makeOverridable self.buildNodePackage {
    name = "string_decoder-0.10.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
        name = "string_decoder-0.10.31.tgz";
        sha1 = "62e203bc41766c6c28c9fc84301dab1c5310fa94";
      })
    ];
    buildInputs =
      (self.nativeDeps."string_decoder" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "string_decoder" ];
  };
  by-spec."stringstream"."~0.0.4" =
    self.by-version."stringstream"."0.0.4";
  by-version."stringstream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "stringstream-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stringstream/-/stringstream-0.0.4.tgz";
        name = "stringstream-0.0.4.tgz";
        sha1 = "0f0e3423f942960b5692ac324a57dd093bc41a92";
      })
    ];
    buildInputs =
      (self.nativeDeps."stringstream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stringstream" ];
  };
  by-spec."strip-ansi"."^2.0.1" =
    self.by-version."strip-ansi"."2.0.1";
  by-version."strip-ansi"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-2.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-2.0.1.tgz";
        name = "strip-ansi-2.0.1.tgz";
        sha1 = "df62c1aa94ed2f114e1d0f21fd1d50482b79a60e";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-json-comments"."1.0.x" =
    self.by-version."strip-json-comments"."1.0.2";
  by-version."strip-json-comments"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "strip-json-comments-1.0.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-json-comments/-/strip-json-comments-1.0.2.tgz";
        name = "strip-json-comments-1.0.2.tgz";
        sha1 = "5a48ab96023dbac1b7b8d0ffabf6f63f1677be9f";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-json-comments" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-json-comments" ];
  };
  by-spec."supports-color"."^1.3.0" =
    self.by-version."supports-color"."1.3.1";
  by-version."supports-color"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "supports-color-1.3.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-1.3.1.tgz";
        name = "supports-color-1.3.1.tgz";
        sha1 = "15758df09d8ff3b4acc307539fabe27095e1042d";
      })
    ];
    buildInputs =
      (self.nativeDeps."supports-color" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "supports-color" ];
  };
  by-spec."supports-color"."~1.2.0" =
    self.by-version."supports-color"."1.2.1";
  by-version."supports-color"."1.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "supports-color-1.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-1.2.1.tgz";
        name = "supports-color-1.2.1.tgz";
        sha1 = "12ee21507086cd98c1058d9ec0f4ac476b7af3b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."supports-color" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "supports-color" ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."0.12.1";
  by-version."tough-cookie"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "tough-cookie-0.12.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
        name = "tough-cookie-0.12.1.tgz";
        sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
      })
    ];
    buildInputs =
      (self.nativeDeps."tough-cookie" or []);
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tough-cookie" ];
  };
  by-spec."tunnel-agent"."~0.4.0" =
    self.by-version."tunnel-agent"."0.4.0";
  by-version."tunnel-agent"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.0.tgz";
        name = "tunnel-agent-0.4.0.tgz";
        sha1 = "b1184e312ffbcf70b3b4c78e8c219de7ebb1c550";
      })
    ];
    buildInputs =
      (self.nativeDeps."tunnel-agent" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tunnel-agent" ];
  };
  by-spec."uglify-js"."2.4.x" =
    self.by-version."uglify-js"."2.4.19";
  by-version."uglify-js"."2.4.19" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.4.19";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.19.tgz";
        name = "uglify-js-2.4.19.tgz";
        sha1 = "a43d7828f32ecec7fc3a14dfc0f9466feda4dfce";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.34" = self.by-version."source-map"."0.1.34";
      "yargs-3.5.4" = self.by-version."yargs"."3.5.4";
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-js"."~2.3" =
    self.by-version."uglify-js"."2.3.6";
  by-version."uglify-js"."2.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-2.3.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.3.6.tgz";
        name = "uglify-js-2.3.6.tgz";
        sha1 = "fa0984770b428b7a9b2a8058f46355d14fef211a";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."uglify-to-browserify"."~1.0.0" =
    self.by-version."uglify-to-browserify"."1.0.2";
  by-version."uglify-to-browserify"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-to-browserify-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
        name = "uglify-to-browserify-1.0.2.tgz";
        sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-to-browserify" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-to-browserify" ];
  };
  by-spec."underscore"."1.6.x" =
    self.by-version."underscore"."1.6.0";
  by-version."underscore"."1.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.6.0.tgz";
        name = "underscore-1.6.0.tgz";
        sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore" ];
  };
  by-spec."window-size"."0.1.0" =
    self.by-version."window-size"."0.1.0";
  by-version."window-size"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "window-size-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz";
        name = "window-size-0.1.0.tgz";
        sha1 = "5438cd2ea93b202efa3a19fe8887aee7c94f9c9d";
      })
    ];
    buildInputs =
      (self.nativeDeps."window-size" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "window-size" ];
  };
  by-spec."wordwrap"."0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-version."wordwrap"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "wordwrap-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
        name = "wordwrap-0.0.2.tgz";
        sha1 = "b79669bb42ecb409f83d583cad52ca17eaa1643f";
      })
    ];
    buildInputs =
      (self.nativeDeps."wordwrap" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "wordwrap" ];
  };
  by-spec."wordwrap"."~0.0.2" =
    self.by-version."wordwrap"."0.0.2";
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.1";
  by-version."wrappy"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "wrappy-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/wrappy/-/wrappy-1.0.1.tgz";
        name = "wrappy-1.0.1.tgz";
        sha1 = "1e65969965ccbc2db4548c6b84a6f2c5aedd4739";
      })
    ];
    buildInputs =
      (self.nativeDeps."wrappy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "wrappy" ];
  };
  by-spec."xml2js"."0.2.x" =
    self.by-version."xml2js"."0.2.8";
  by-version."xml2js"."0.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "xml2js-0.2.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xml2js/-/xml2js-0.2.8.tgz";
        name = "xml2js-0.2.8.tgz";
        sha1 = "9b81690931631ff09d1957549faf54f4f980b3c2";
      })
    ];
    buildInputs =
      (self.nativeDeps."xml2js" or []);
    deps = {
      "sax-0.5.8" = self.by-version."sax"."0.5.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xml2js" ];
  };
  by-spec."xmlhttprequest".">= 1.6.0 < 2.0.0" =
    self.by-version."xmlhttprequest"."1.7.0";
  by-version."xmlhttprequest"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "xmlhttprequest-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xmlhttprequest/-/xmlhttprequest-1.7.0.tgz";
        name = "xmlhttprequest-1.7.0.tgz";
        sha1 = "dc697a8df0258afacad526c1c296b1bdd12c4ab3";
      })
    ];
    buildInputs =
      (self.nativeDeps."xmlhttprequest" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xmlhttprequest" ];
  };
  by-spec."xtend"."^4.0.0" =
    self.by-version."xtend"."4.0.0";
  by-version."xtend"."4.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "xtend-4.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-4.0.0.tgz";
        name = "xtend-4.0.0.tgz";
        sha1 = "8bc36ff87aedbe7ce9eaf0bca36b2354a743840f";
      })
    ];
    buildInputs =
      (self.nativeDeps."xtend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "xtend" ];
  };
  by-spec."yargs"."~3.5.4" =
    self.by-version."yargs"."3.5.4";
  by-version."yargs"."3.5.4" = lib.makeOverridable self.buildNodePackage {
    name = "yargs-3.5.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yargs/-/yargs-3.5.4.tgz";
        name = "yargs-3.5.4.tgz";
        sha1 = "d8aff8f665e94c34bd259bdebd1bfaf0ddd35361";
      })
    ];
    buildInputs =
      (self.nativeDeps."yargs" or []);
    deps = {
      "camelcase-1.0.2" = self.by-version."camelcase"."1.0.2";
      "decamelize-1.0.0" = self.by-version."decamelize"."1.0.0";
      "window-size-0.1.0" = self.by-version."window-size"."0.1.0";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "yargs" ];
  };
}

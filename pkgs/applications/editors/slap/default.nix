{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."CSSselect"."~0.4.0" =
    self.by-version."CSSselect"."0.4.1";
  by-version."CSSselect"."0.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "CSSselect-0.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSselect/-/CSSselect-0.4.1.tgz";
        name = "CSSselect-0.4.1.tgz";
        sha1 = "f8ab7e1f8418ce63cda6eb7bd778a85d7ec492b2";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSselect" or []);
    deps = {
      "CSSwhat-0.4.7" = self.by-version."CSSwhat"."0.4.7";
      "domutils-1.4.3" = self.by-version."domutils"."1.4.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "CSSselect" ];
  };
  by-spec."CSSwhat"."0.4" =
    self.by-version."CSSwhat"."0.4.7";
  by-version."CSSwhat"."0.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "CSSwhat-0.4.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/CSSwhat/-/CSSwhat-0.4.7.tgz";
        name = "CSSwhat-0.4.7.tgz";
        sha1 = "867da0ff39f778613242c44cfea83f0aa4ebdf9b";
      })
    ];
    buildInputs =
      (self.nativeDeps."CSSwhat" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "CSSwhat" ];
  };
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
  by-spec."abbrev"."1.0.x" =
    self.by-version."abbrev"."1.0.5";
  by-spec."accepts"."~1.2.3" =
    self.by-version."accepts"."1.2.3";
  by-version."accepts"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "accepts-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.2.3.tgz";
        name = "accepts-1.2.3.tgz";
        sha1 = "2cb8b306cce2aa70e73ab39cc750061526c0778f";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = {
      "mime-types-2.0.8" = self.by-version."mime-types"."2.0.8";
      "negotiator-0.5.0" = self.by-version."negotiator"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
  by-spec."alt"."^0.12.0" =
    self.by-version."alt"."0.12.2";
  by-version."alt"."0.12.2" = lib.makeOverridable self.buildNodePackage {
    name = "alt-0.12.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/alt/-/alt-0.12.2.tgz";
        name = "alt-0.12.2.tgz";
        sha1 = "197e046ad46f1808c05cdfd0fd7486c5198b7787";
      })
    ];
    buildInputs =
      (self.nativeDeps."alt" or []);
    deps = {
      "es-symbol-1.0.1" = self.by-version."es-symbol"."1.0.1";
      "eventemitter3-0.1.6" = self.by-version."eventemitter3"."0.1.6";
      "flux-2.0.1" = self.by-version."flux"."2.0.1";
      "object-assign-2.0.0" = self.by-version."object-assign"."2.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "alt" ];
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
  by-spec."ansi"."~0.3.0" =
    self.by-version."ansi"."0.3.0";
  by-version."ansi"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi/-/ansi-0.3.0.tgz";
        name = "ansi-0.3.0.tgz";
        sha1 = "74b2f1f187c8553c7f95015bcb76009fb43d38e0";
      })
    ];
    buildInputs =
      (self.nativeDeps."ansi" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ansi" ];
  };
  by-spec."ansi-regex"."^0.2.0" =
    self.by-version."ansi-regex"."0.2.1";
  by-version."ansi-regex"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-regex-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-0.2.1.tgz";
        name = "ansi-regex-0.2.1.tgz";
        sha1 = "0d8e946967a3d8143f93e24e298525fc1b2235f9";
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
  by-spec."ansi-regex"."^0.2.1" =
    self.by-version."ansi-regex"."0.2.1";
  by-spec."ansi-regex"."^1.0.0" =
    self.by-version."ansi-regex"."1.1.0";
  by-version."ansi-regex"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-regex-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-1.1.0.tgz";
        name = "ansi-regex-1.1.0.tgz";
        sha1 = "67792c5d6ad05c792d6cd6057ac8f5e69ebf4357";
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
  by-spec."ansi-styles"."^1.1.0" =
    self.by-version."ansi-styles"."1.1.0";
  by-version."ansi-styles"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ansi-styles-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-1.1.0.tgz";
        name = "ansi-styles-1.1.0.tgz";
        sha1 = "eaecbf66cd706882760b2f4691582b8f55d7a7de";
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
  by-spec."argparse"."~ 0.1.11" =
    self.by-version."argparse"."0.1.16";
  by-version."argparse"."0.1.16" = lib.makeOverridable self.buildNodePackage {
    name = "argparse-0.1.16";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/argparse/-/argparse-0.1.16.tgz";
        name = "argparse-0.1.16.tgz";
        sha1 = "cfd01e0fbba3d6caed049fbd758d40f65196f57c";
      })
    ];
    buildInputs =
      (self.nativeDeps."argparse" or []);
    deps = {
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
      "underscore.string-2.4.0" = self.by-version."underscore.string"."2.4.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "argparse" ];
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
  by-spec."async"."0.2.x" =
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
  by-spec."async"."0.9.x" =
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
  by-spec."async"."~0.2.10" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.6" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.7" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.2.9" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.9" =
    self.by-version."async"."0.9.0";
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.0";
  by-spec."atom-diff"."^2" =
    self.by-version."atom-diff"."2.0.0";
  by-version."atom-diff"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "atom-diff-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/atom-diff/-/atom-diff-2.0.0.tgz";
        name = "atom-diff-2.0.0.tgz";
        sha1 = "c02d2cc8a04ad95f5308651cac8809b91115f28f";
      })
    ];
    buildInputs =
      (self.nativeDeps."atom-diff" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "atom-diff" ];
  };
  by-spec."aws-sign"."~0.2.0" =
    self.by-version."aws-sign"."0.2.0";
  by-version."aws-sign"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "aws-sign-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/aws-sign/-/aws-sign-0.2.0.tgz";
        name = "aws-sign-0.2.0.tgz";
        sha1 = "c55013856c8194ec854a0cbec90aab5a04ce3ac5";
      })
    ];
    buildInputs =
      (self.nativeDeps."aws-sign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "aws-sign" ];
  };
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
  by-spec."blessed"."slap-editor/blessed" =
    self.by-version."blessed"."0.0.37";
  by-version."blessed"."0.0.37" = lib.makeOverridable self.buildNodePackage {
    name = "blessed-0.0.37";
    bin = true;
    src = [
      (fetchgit {
        url = "git://github.com/slap-editor/blessed";
        rev = "5300702e345f256ee104704b47be864d8d5a48f2";
        sha256 = "12f082ee2e8ae075408ae5a7b9bb3e0788c5fbc14a3cd5c02a96b5a403fddc11";
      })
    ];
    buildInputs =
      (self.nativeDeps."blessed" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "blessed" ];
  };
  "blessed" = self.by-version."blessed"."0.0.37";
  by-spec."block-stream"."*" =
    self.by-version."block-stream"."0.0.7";
  by-version."block-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "block-stream-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        name = "block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
      })
    ];
    buildInputs =
      (self.nativeDeps."block-stream" or []);
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "block-stream" ];
  };
  by-spec."bluebird"."^2.3.6" =
    self.by-version."bluebird"."2.9.7";
  by-version."bluebird"."2.9.7" = lib.makeOverridable self.buildNodePackage {
    name = "bluebird-2.9.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.7.tgz";
        name = "bluebird-2.9.7.tgz";
        sha1 = "8b9bba0fdd200cfcda6f56772f46ef6715184103";
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
  "bluebird" = self.by-version."bluebird"."2.9.7";
  by-spec."bluebird"."^2.9.3" =
    self.by-version."bluebird"."2.9.7";
  by-spec."boom"."0.3.x" =
    self.by-version."boom"."0.3.8";
  by-version."boom"."0.3.8" = lib.makeOverridable self.buildNodePackage {
    name = "boom-0.3.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-0.3.8.tgz";
        name = "boom-0.3.8.tgz";
        sha1 = "c8cdb041435912741628c044ecc732d1d17c09ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
  };
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.6.1";
  by-version."boom"."2.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "boom-2.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/boom/-/boom-2.6.1.tgz";
        name = "boom-2.6.1.tgz";
        sha1 = "4dc8ef9b6dfad9c43bbbfbe71fa4c21419f22753";
      })
    ];
    buildInputs =
      (self.nativeDeps."boom" or []);
    deps = {
      "hoek-2.11.0" = self.by-version."hoek"."2.11.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "boom" ];
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
  by-spec."chalk"."^0.5.1" =
    self.by-version."chalk"."0.5.1";
  by-version."chalk"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "chalk-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chalk/-/chalk-0.5.1.tgz";
        name = "chalk-0.5.1.tgz";
        sha1 = "663b3a648b68b55d04690d49167aa837858f2174";
      })
    ];
    buildInputs =
      (self.nativeDeps."chalk" or []);
    deps = {
      "ansi-styles-1.1.0" = self.by-version."ansi-styles"."1.1.0";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "has-ansi-0.1.0" = self.by-version."has-ansi"."0.1.0";
      "strip-ansi-0.3.0" = self.by-version."strip-ansi"."0.3.0";
      "supports-color-0.2.0" = self.by-version."supports-color"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "chalk" ];
  };
  by-spec."chardet"."^0.0.8" =
    self.by-version."chardet"."0.0.8";
  by-version."chardet"."0.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "chardet-0.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/chardet/-/chardet-0.0.8.tgz";
        name = "chardet-0.0.8.tgz";
        sha1 = "a0100b5cefe47dcd50136d1c0ba5beb893d98452";
      })
    ];
    buildInputs =
      (self.nativeDeps."chardet" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "chardet" ];
  };
  "chardet" = self.by-version."chardet"."0.0.8";
  by-spec."cheerio"."^0.15.0" =
    self.by-version."cheerio"."0.15.0";
  by-version."cheerio"."0.15.0" = lib.makeOverridable self.buildNodePackage {
    name = "cheerio-0.15.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cheerio/-/cheerio-0.15.0.tgz";
        name = "cheerio-0.15.0.tgz";
        sha1 = "8775ec3ab16f4c66195b9cc6797e0c82b51e6b34";
      })
    ];
    buildInputs =
      (self.nativeDeps."cheerio" or []);
    deps = {
      "htmlparser2-3.7.3" = self.by-version."htmlparser2"."3.7.3";
      "entities-1.0.0" = self.by-version."entities"."1.0.0";
      "CSSselect-0.4.1" = self.by-version."CSSselect"."0.4.1";
      "lodash-2.4.1" = self.by-version."lodash"."2.4.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cheerio" ];
  };
  "cheerio" = self.by-version."cheerio"."0.15.0";
  by-spec."coffee-script"."~1.7.0" =
    self.by-version."coffee-script"."1.7.1";
  by-version."coffee-script"."1.7.1" = lib.makeOverridable self.buildNodePackage {
    name = "coffee-script-1.7.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.7.1.tgz";
        name = "coffee-script-1.7.1.tgz";
        sha1 = "62996a861780c75e6d5069d13822723b73404bfc";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffee-script" or []);
    deps = {
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "coffee-script" ];
  };
  by-spec."coffeestack"."^0.7.0" =
    self.by-version."coffeestack"."0.7.0";
  by-version."coffeestack"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "coffeestack-0.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/coffeestack/-/coffeestack-0.7.0.tgz";
        name = "coffeestack-0.7.0.tgz";
        sha1 = "7ea4b801c43a04237db22cee7bc2bd7670f12171";
      })
    ];
    buildInputs =
      (self.nativeDeps."coffeestack" or []);
    deps = {
      "coffee-script-1.7.1" = self.by-version."coffee-script"."1.7.1";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
    };
    peerDependencies = [
    ];
    passthru.names = [ "coffeestack" ];
  };
  by-spec."colors"."0.6.x" =
    self.by-version."colors"."0.6.2";
  by-version."colors"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.6.2.tgz";
        name = "colors-0.6.2.tgz";
        sha1 = "2423fe6678ac0c5dae8852e5d0e5be08c997abcc";
      })
    ];
    buildInputs =
      (self.nativeDeps."colors" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colors" ];
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
  by-spec."commander"."~2.1.0" =
    self.by-version."commander"."2.1.0";
  by-version."commander"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "commander-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/commander/-/commander-2.1.0.tgz";
        name = "commander-2.1.0.tgz";
        sha1 = "d121bbae860d9992a3d517ba96f56588e47c6781";
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
  by-spec."configstore"."^0.3.1" =
    self.by-version."configstore"."0.3.2";
  by-version."configstore"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "configstore-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/configstore/-/configstore-0.3.2.tgz";
        name = "configstore-0.3.2.tgz";
        sha1 = "25e4c16c3768abf75c5a65bc61761f495055b459";
      })
    ];
    buildInputs =
      (self.nativeDeps."configstore" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "js-yaml-3.2.6" = self.by-version."js-yaml"."3.2.6";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "object-assign-2.0.0" = self.by-version."object-assign"."2.0.0";
      "osenv-0.1.0" = self.by-version."osenv"."0.1.0";
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
      "uuid-2.0.1" = self.by-version."uuid"."2.0.1";
      "xdg-basedir-1.0.1" = self.by-version."xdg-basedir"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "configstore" ];
  };
  by-spec."content-disposition"."0.5.0" =
    self.by-version."content-disposition"."0.5.0";
  by-version."content-disposition"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "content-disposition-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/content-disposition/-/content-disposition-0.5.0.tgz";
        name = "content-disposition-0.5.0.tgz";
        sha1 = "4284fe6ae0630874639e44e80a418c2934135e9e";
      })
    ];
    buildInputs =
      (self.nativeDeps."content-disposition" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "content-disposition" ];
  };
  by-spec."cookie"."0.1.2" =
    self.by-version."cookie"."0.1.2";
  by-version."cookie"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.2.tgz";
        name = "cookie-0.1.2.tgz";
        sha1 = "72fec3d24e48a3432073d90c12642005061004b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie-jar"."~0.2.0" =
    self.by-version."cookie-jar"."0.2.0";
  by-version."cookie-jar"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-jar-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-jar/-/cookie-jar-0.2.0.tgz";
        name = "cookie-jar-0.2.0.tgz";
        sha1 = "64ecc06ac978db795e4b5290cbe48ba3781400fa";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-jar" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-jar" ];
  };
  by-spec."cookie-signature"."1.0.5" =
    self.by-version."cookie-signature"."1.0.5";
  by-version."cookie-signature"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "cookie-signature-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.5.tgz";
        name = "cookie-signature-1.0.5.tgz";
        sha1 = "a122e3f1503eca0f5355795b0711bb2368d450f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."copy-paste"."^1.0.1" =
    self.by-version."copy-paste"."1.0.1";
  by-version."copy-paste"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "copy-paste-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/copy-paste/-/copy-paste-1.0.1.tgz";
        name = "copy-paste-1.0.1.tgz";
        sha1 = "93763409cd674dcafc55bb5231239579fd38db02";
      })
    ];
    buildInputs =
      (self.nativeDeps."copy-paste" or []);
    deps = {
      "execSync-1.0.2" = self.by-version."execSync"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "copy-paste" ];
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
  by-spec."crc"."3.2.1" =
    self.by-version."crc"."3.2.1";
  by-version."crc"."3.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "crc-3.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc/-/crc-3.2.1.tgz";
        name = "crc-3.2.1.tgz";
        sha1 = "5d9c8fb77a245cd5eca291e5d2d005334bab0082";
      })
    ];
    buildInputs =
      (self.nativeDeps."crc" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "crc" ];
  };
  by-spec."cryptiles"."0.1.x" =
    self.by-version."cryptiles"."0.1.3";
  by-version."cryptiles"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "cryptiles-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.1.3.tgz";
        name = "cryptiles-0.1.3.tgz";
        sha1 = "1a556734f06d24ba34862ae9cb9e709a3afbff1c";
      })
    ];
    buildInputs =
      (self.nativeDeps."cryptiles" or []);
    deps = {
      "boom-0.3.8" = self.by-version."boom"."0.3.8";
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
      "boom-2.6.1" = self.by-version."boom"."2.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "cryptiles" ];
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
  by-spec."cycle"."1.0.x" =
    self.by-version."cycle"."1.0.3";
  by-version."cycle"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "cycle-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cycle/-/cycle-1.0.3.tgz";
        name = "cycle-1.0.3.tgz";
        sha1 = "21e80b2be8580f98b468f379430662b046c34ad2";
      })
    ];
    buildInputs =
      (self.nativeDeps."cycle" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "cycle" ];
  };
  by-spec."debug"."^1.0" =
    self.by-version."debug"."1.0.4";
  by-version."debug"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "debug-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-1.0.4.tgz";
        name = "debug-1.0.4.tgz";
        sha1 = "5b9c256bd54b6ec02283176fa8a0ede6d154cbf8";
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
  by-spec."debug"."~0.7.2" =
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
  by-spec."debug"."~2.1.1" =
    self.by-version."debug"."2.1.1";
  by-version."debug"."2.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "debug-2.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-2.1.1.tgz";
        name = "debug-2.1.1.tgz";
        sha1 = "e0c548cc607adc22b537540dc3639c4236fdf90c";
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
  by-spec."deep-equal"."~0.2.0" =
    self.by-version."deep-equal"."0.2.2";
  by-version."deep-equal"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.2.tgz";
        name = "deep-equal-0.2.2.tgz";
        sha1 = "84b745896f34c684e98f2ce0e42abaf43bba017d";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-equal" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-equal" ];
  };
  by-spec."deep-extend"."~0.2.5" =
    self.by-version."deep-extend"."0.2.11";
  by-version."deep-extend"."0.2.11" = lib.makeOverridable self.buildNodePackage {
    name = "deep-extend-0.2.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.11.tgz";
        name = "deep-extend-0.2.11.tgz";
        sha1 = "7a16ba69729132340506170494bc83f7076fe08f";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-extend" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-extend" ];
  };
  by-spec."defined"."~0.0.0" =
    self.by-version."defined"."0.0.0";
  by-version."defined"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "defined-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/defined/-/defined-0.0.0.tgz";
        name = "defined-0.0.0.tgz";
        sha1 = "f35eea7d705e933baf13b2f03b3f83d921403b3e";
      })
    ];
    buildInputs =
      (self.nativeDeps."defined" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "defined" ];
  };
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
  by-spec."delegato"."^1.0.0" =
    self.by-version."delegato"."1.0.0";
  by-version."delegato"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "delegato-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/delegato/-/delegato-1.0.0.tgz";
        name = "delegato-1.0.0.tgz";
        sha1 = "c7324adbf31fa3d96d1fd60bf368c5fcca269510";
      })
    ];
    buildInputs =
      (self.nativeDeps."delegato" or []);
    deps = {
      "mixto-1.0.0" = self.by-version."mixto"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "delegato" ];
  };
  by-spec."depd"."~1.0.0" =
    self.by-version."depd"."1.0.0";
  by-version."depd"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "depd-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/depd/-/depd-1.0.0.tgz";
        name = "depd-1.0.0.tgz";
        sha1 = "2fda0d00e98aae2845d4991ab1bf1f2a199073d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."depd" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "depd" ];
  };
  by-spec."dependency-injector"."~0.0.5" =
    self.by-version."dependency-injector"."0.0.5";
  by-version."dependency-injector"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "dependency-injector-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dependency-injector/-/dependency-injector-0.0.5.tgz";
        name = "dependency-injector-0.0.5.tgz";
        sha1 = "998824c39d74209962c0d43ded4dd03549a67472";
      })
    ];
    buildInputs =
      (self.nativeDeps."dependency-injector" or []);
    deps = {
      "get-parameter-names-0.2.0" = self.by-version."get-parameter-names"."0.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "dependency-injector" ];
  };
  by-spec."destroy"."1.0.3" =
    self.by-version."destroy"."1.0.3";
  by-version."destroy"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "destroy-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
        name = "destroy-1.0.3.tgz";
        sha1 = "b433b4724e71fd8551d9885174851c5fc377e2c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."destroy" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "destroy" ];
  };
  by-spec."dom-serializer"."0" =
    self.by-version."dom-serializer"."0.0.1";
  by-version."dom-serializer"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "dom-serializer-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/dom-serializer/-/dom-serializer-0.0.1.tgz";
        name = "dom-serializer-0.0.1.tgz";
        sha1 = "9589827f1e32d22c37c829adabd59b3247af8eaf";
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
  by-spec."domelementtype"."~1.1.1" =
    self.by-version."domelementtype"."1.1.3";
  by-spec."domhandler"."2.2" =
    self.by-version."domhandler"."2.2.1";
  by-version."domhandler"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "domhandler-2.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domhandler/-/domhandler-2.2.1.tgz";
        name = "domhandler-2.2.1.tgz";
        sha1 = "59df9dcd227e808b365ae73e1f6684ac3d946fc2";
      })
    ];
    buildInputs =
      (self.nativeDeps."domhandler" or []);
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domhandler" ];
  };
  by-spec."domutils"."1.4" =
    self.by-version."domutils"."1.4.3";
  by-version."domutils"."1.4.3" = lib.makeOverridable self.buildNodePackage {
    name = "domutils-1.4.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/domutils/-/domutils-1.4.3.tgz";
        name = "domutils-1.4.3.tgz";
        sha1 = "0865513796c6b306031850e175516baf80b72a6f";
      })
    ];
    buildInputs =
      (self.nativeDeps."domutils" or []);
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
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
      "dom-serializer-0.0.1" = self.by-version."dom-serializer"."0.0.1";
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "domutils" ];
  };
  by-spec."ee-first"."1.1.0" =
    self.by-version."ee-first"."1.1.0";
  by-version."ee-first"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ee-first-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ee-first/-/ee-first-1.1.0.tgz";
        name = "ee-first-1.1.0.tgz";
        sha1 = "6a0d7c6221e490feefd92ec3f441c9ce8cd097f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."ee-first" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ee-first" ];
  };
  by-spec."emissary"."^1.0.0" =
    self.by-version."emissary"."1.3.1";
  by-version."emissary"."1.3.1" = lib.makeOverridable self.buildNodePackage {
    name = "emissary-1.3.1";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/emissary/-/emissary-1.3.1.tgz";
        name = "emissary-1.3.1.tgz";
        sha1 = "8de1cf811462a5974ec5dce39e6e4cbc7412f06f";
      })
    ];
    buildInputs =
      (self.nativeDeps."emissary" or []);
    deps = {
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
      "mixto-1.0.0" = self.by-version."mixto"."1.0.0";
      "property-accessors-1.1.0" = self.by-version."property-accessors"."1.1.0";
      "harmony-collections-0.3.7" = self.by-version."harmony-collections"."0.3.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "emissary" ];
  };
  by-spec."emissary"."^1.1.0" =
    self.by-version."emissary"."1.3.1";
  by-spec."emissary"."^1.2.0" =
    self.by-version."emissary"."1.3.1";
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
  by-spec."entities"."^1.1.1" =
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
  "entities" = self.by-version."entities"."1.1.1";
  by-spec."entities"."~1.0.0" =
    self.by-version."entities"."1.0.0";
  by-spec."entities"."~1.1.1" =
    self.by-version."entities"."1.1.1";
  by-spec."es-symbol"."^1.0.1" =
    self.by-version."es-symbol"."1.0.1";
  by-version."es-symbol"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "es-symbol-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/es-symbol/-/es-symbol-1.0.1.tgz";
        name = "es-symbol-1.0.1.tgz";
        sha1 = "0d04b468c0633a84b346defbe746b22886eb79d3";
      })
    ];
    buildInputs =
      (self.nativeDeps."es-symbol" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "es-symbol" ];
  };
  by-spec."escape-html"."1.0.1" =
    self.by-version."escape-html"."1.0.1";
  by-version."escape-html"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "escape-html-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
        name = "escape-html-1.0.1.tgz";
        sha1 = "181a286ead397a39a92857cfb1d43052e356bff0";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-html" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "escape-html" ];
  };
  by-spec."escape-string-regexp"."^1.0.0" =
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
  by-spec."escodegen"."1.3.x" =
    self.by-version."escodegen"."1.3.3";
  by-version."escodegen"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "escodegen-1.3.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escodegen/-/escodegen-1.3.3.tgz";
        name = "escodegen-1.3.3.tgz";
        sha1 = "f024016f5a88e046fd12005055e939802e6c5f23";
      })
    ];
    buildInputs =
      (self.nativeDeps."escodegen" or []);
    deps = {
      "esutils-1.0.0" = self.by-version."esutils"."1.0.0";
      "estraverse-1.5.1" = self.by-version."estraverse"."1.5.1";
      "esprima-1.1.1" = self.by-version."esprima"."1.1.1";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
    };
    peerDependencies = [
    ];
    passthru.names = [ "escodegen" ];
  };
  by-spec."esprima"."1.2.x" =
    self.by-version."esprima"."1.2.4";
  by-version."esprima"."1.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.2.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.2.4.tgz";
        name = "esprima-1.2.4.tgz";
        sha1 = "835a0cfc8a628a7117da654bfaced8408a91dba7";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."esprima"."~ 1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-version."esprima"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.0.4";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
        name = "esprima-1.0.4.tgz";
        sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."esprima"."~1.1.1" =
    self.by-version."esprima"."1.1.1";
  by-version."esprima"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "esprima-1.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esprima/-/esprima-1.1.1.tgz";
        name = "esprima-1.1.1.tgz";
        sha1 = "5b6f1547f4d102e670e140c509be6771d6aeb549";
      })
    ];
    buildInputs =
      (self.nativeDeps."esprima" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esprima" ];
  };
  by-spec."estraverse"."~1.5.0" =
    self.by-version."estraverse"."1.5.1";
  by-version."estraverse"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "estraverse-1.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/estraverse/-/estraverse-1.5.1.tgz";
        name = "estraverse-1.5.1.tgz";
        sha1 = "867a3e8e58a9f84618afb6c2ddbcd916b7cbaf71";
      })
    ];
    buildInputs =
      (self.nativeDeps."estraverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "estraverse" ];
  };
  by-spec."esutils"."~1.0.0" =
    self.by-version."esutils"."1.0.0";
  by-version."esutils"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "esutils-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/esutils/-/esutils-1.0.0.tgz";
        name = "esutils-1.0.0.tgz";
        sha1 = "8151d358e20c8acc7fb745e7472c0025fe496570";
      })
    ];
    buildInputs =
      (self.nativeDeps."esutils" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "esutils" ];
  };
  by-spec."etag"."~1.5.1" =
    self.by-version."etag"."1.5.1";
  by-version."etag"."1.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "etag-1.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/etag/-/etag-1.5.1.tgz";
        name = "etag-1.5.1.tgz";
        sha1 = "54c50de04ee42695562925ac566588291be7e9ea";
      })
    ];
    buildInputs =
      (self.nativeDeps."etag" or []);
    deps = {
      "crc-3.2.1" = self.by-version."crc"."3.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "etag" ];
  };
  by-spec."event-kit"."^0.8.1" =
    self.by-version."event-kit"."0.8.2";
  by-version."event-kit"."0.8.2" = lib.makeOverridable self.buildNodePackage {
    name = "event-kit-0.8.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-kit/-/event-kit-0.8.2.tgz";
        name = "event-kit-0.8.2.tgz";
        sha1 = "42f327fb7fa16fa93a6b893c753cf5b5476a5fca";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-kit" or []);
    deps = {
      "grim-1.1.0" = self.by-version."grim"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "event-kit" ];
  };
  by-spec."event-kit"."^1.0.0" =
    self.by-version."event-kit"."1.0.2";
  by-version."event-kit"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "event-kit-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/event-kit/-/event-kit-1.0.2.tgz";
        name = "event-kit-1.0.2.tgz";
        sha1 = "20ab5dd4f637830b0f4e77c38a86de2754dc37d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."event-kit" or []);
    deps = {
      "grim-1.1.0" = self.by-version."grim"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "event-kit" ];
  };
  by-spec."eventemitter3"."^0.1.6" =
    self.by-version."eventemitter3"."0.1.6";
  by-version."eventemitter3"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "eventemitter3-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eventemitter3/-/eventemitter3-0.1.6.tgz";
        name = "eventemitter3-0.1.6.tgz";
        sha1 = "8c7ac44b87baab55cd50c828dc38778eac052ea5";
      })
    ];
    buildInputs =
      (self.nativeDeps."eventemitter3" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "eventemitter3" ];
  };
  by-spec."execSync"."~1.0.0" =
    self.by-version."execSync"."1.0.2";
  by-version."execSync"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "execSync-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/execSync/-/execSync-1.0.2.tgz";
        name = "execSync-1.0.2.tgz";
        sha1 = "1f42eda582225180053224ecdd3fd1960fdb3139";
      })
    ];
    buildInputs =
      (self.nativeDeps."execSync" or []);
    deps = {
      "temp-0.5.1" = self.by-version."temp"."0.5.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "execSync" ];
  };
  by-spec."express"."^4.0" =
    self.by-version."express"."4.11.2";
  by-version."express"."4.11.2" = lib.makeOverridable self.buildNodePackage {
    name = "express-4.11.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.11.2.tgz";
        name = "express-4.11.2.tgz";
        sha1 = "8df3d5a9ac848585f00a0777601823faecd3b148";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = {
      "accepts-1.2.3" = self.by-version."accepts"."1.2.3";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "cookie-signature-1.0.5" = self.by-version."cookie-signature"."1.0.5";
      "debug-2.1.1" = self.by-version."debug"."2.1.1";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "finalhandler-0.3.3" = self.by-version."finalhandler"."0.3.3";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.6" = self.by-version."proxy-addr"."1.0.6";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.11.1" = self.by-version."send"."0.11.1";
      "serve-static-1.8.1" = self.by-version."serve-static"."1.8.1";
      "type-is-1.5.6" = self.by-version."type-is"."1.5.6";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "merge-descriptors-0.0.2" = self.by-version."merge-descriptors"."0.0.2";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  by-spec."eyes"."0.1.x" =
    self.by-version."eyes"."0.1.8";
  by-version."eyes"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "eyes-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/eyes/-/eyes-0.1.8.tgz";
        name = "eyes-0.1.8.tgz";
        sha1 = "62cf120234c683785d902348a800ef3e0cc20bc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."eyes" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "eyes" ];
  };
  by-spec."fantasy-promises"."^0.1.0" =
    self.by-version."fantasy-promises"."0.1.0";
  by-version."fantasy-promises"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "fantasy-promises-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fantasy-promises/-/fantasy-promises-0.1.0.tgz";
        name = "fantasy-promises-0.1.0.tgz";
        sha1 = "2b44c4fa0589b559212ced2b399de383a7104020";
      })
    ];
    buildInputs =
      (self.nativeDeps."fantasy-promises" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fantasy-promises" ];
  };
  by-spec."fileset"."0.1.x" =
    self.by-version."fileset"."0.1.5";
  by-version."fileset"."0.1.5" = lib.makeOverridable self.buildNodePackage {
    name = "fileset-0.1.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fileset/-/fileset-0.1.5.tgz";
        name = "fileset-0.1.5.tgz";
        sha1 = "acc423bfaf92843385c66bf75822264d11b7bd94";
      })
    ];
    buildInputs =
      (self.nativeDeps."fileset" or []);
    deps = {
      "minimatch-0.4.0" = self.by-version."minimatch"."0.4.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fileset" ];
  };
  by-spec."finalhandler"."0.3.3" =
    self.by-version."finalhandler"."0.3.3";
  by-version."finalhandler"."0.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "finalhandler-0.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.3.3.tgz";
        name = "finalhandler-0.3.3.tgz";
        sha1 = "b1a09aa1e6a607b3541669b09bcb727f460cd426";
      })
    ];
    buildInputs =
      (self.nativeDeps."finalhandler" or []);
    deps = {
      "debug-2.1.1" = self.by-version."debug"."2.1.1";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "finalhandler" ];
  };
  by-spec."flux"."^2.0.1" =
    self.by-version."flux"."2.0.1";
  by-version."flux"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "flux-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/flux/-/flux-2.0.1.tgz";
        name = "flux-2.0.1.tgz";
        sha1 = "e19f53113a762b6a7a28ada1745701558a255c63";
      })
    ];
    buildInputs =
      (self.nativeDeps."flux" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "flux" ];
  };
  by-spec."forever-agent"."~0.2.0" =
    self.by-version."forever-agent"."0.2.0";
  by-version."forever-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "forever-agent-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.2.0.tgz";
        name = "forever-agent-0.2.0.tgz";
        sha1 = "e1c25c7ad44e09c38f233876c76fcc24ff843b1f";
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
  by-spec."form-data"."~0.0.3" =
    self.by-version."form-data"."0.0.10";
  by-version."form-data"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "form-data-0.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/form-data/-/form-data-0.0.10.tgz";
        name = "form-data-0.0.10.tgz";
        sha1 = "db345a5378d86aeeb1ed5d553b869ac192d2f5ed";
      })
    ];
    buildInputs =
      (self.nativeDeps."form-data" or []);
    deps = {
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "async-0.2.10" = self.by-version."async"."0.2.10";
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
      "mime-types-2.0.8" = self.by-version."mime-types"."2.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "form-data" ];
  };
  by-spec."forwarded"."~0.1.0" =
    self.by-version."forwarded"."0.1.0";
  by-version."forwarded"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "forwarded-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
        name = "forwarded-0.1.0.tgz";
        sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
      })
    ];
    buildInputs =
      (self.nativeDeps."forwarded" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "forwarded" ];
  };
  by-spec."fresh"."0.2.4" =
    self.by-version."fresh"."0.2.4";
  by-version."fresh"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "fresh-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.4.tgz";
        name = "fresh-0.2.4.tgz";
        sha1 = "3582499206c9723714190edd74b4604feb4a614c";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fs-plus"."^2.0.0" =
    self.by-version."fs-plus"."2.5.0";
  by-version."fs-plus"."2.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "fs-plus-2.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fs-plus/-/fs-plus-2.5.0.tgz";
        name = "fs-plus-2.5.0.tgz";
        sha1 = "b6b1b75ce241ff730a2b7ada4225b2393053a906";
      })
    ];
    buildInputs =
      (self.nativeDeps."fs-plus" or []);
    deps = {
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "async-0.2.10" = self.by-version."async"."0.2.10";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fs-plus" ];
  };
  by-spec."fs-plus"."^2.1" =
    self.by-version."fs-plus"."2.5.0";
  by-spec."fstream"."^1.0.2" =
    self.by-version."fstream"."1.0.4";
  by-version."fstream"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-1.0.4.tgz";
        name = "fstream-1.0.4.tgz";
        sha1 = "6c52298473fd6351fd22fc4bf9254fcfebe80f2b";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."~0.1.17" =
    self.by-version."fstream"."0.1.31";
  by-version."fstream"."0.1.31" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-0.1.31";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.31.tgz";
        name = "fstream-0.1.31.tgz";
        sha1 = "7337f058fbbbbefa8c9f561a28cab0849202c988";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = {
      "graceful-fs-3.0.5" = self.by-version."graceful-fs"."3.0.5";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."fstream"."~0.1.22" =
    self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~0.1.28" =
    self.by-version."fstream"."0.1.31";
  by-spec."fstream-ignore"."0.0.7" =
    self.by-version."fstream-ignore"."0.0.7";
  by-version."fstream-ignore"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "fstream-ignore-0.0.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-0.0.7.tgz";
        name = "fstream-ignore-0.0.7.tgz";
        sha1 = "eea3033f0c3728139de7b57ab1b0d6d89c353c63";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream-ignore" or []);
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream-ignore" ];
  };
  by-spec."get-parameter-names"."*" =
    self.by-version."get-parameter-names"."0.2.0";
  by-version."get-parameter-names"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "get-parameter-names-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/get-parameter-names/-/get-parameter-names-0.2.0.tgz";
        name = "get-parameter-names-0.2.0.tgz";
        sha1 = "a2163ad092e350d94bee2958974fcece1bc53c99";
      })
    ];
    buildInputs =
      (self.nativeDeps."get-parameter-names" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "get-parameter-names" ];
  };
  by-spec."get-parameter-names"."~0.1.2" =
    self.by-version."get-parameter-names"."0.1.2";
  by-version."get-parameter-names"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "get-parameter-names-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/get-parameter-names/-/get-parameter-names-0.1.2.tgz";
        name = "get-parameter-names-0.1.2.tgz";
        sha1 = "0927f9a7f317221aaecb5daf766b8c28c5fac881";
      })
    ];
    buildInputs =
      (self.nativeDeps."get-parameter-names" or []);
    deps = {
      "testla-0.1.2" = self.by-version."testla"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "get-parameter-names" ];
  };
  by-spec."get-random-port"."0.0.1" =
    self.by-version."get-random-port"."0.0.1";
  by-version."get-random-port"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "get-random-port-0.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/get-random-port/-/get-random-port-0.0.1.tgz";
        name = "get-random-port-0.0.1.tgz";
        sha1 = "4b589f779676838d0264e29234e671a37ccab1b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."get-random-port" or []);
    deps = {
      "bluebird-2.9.7" = self.by-version."bluebird"."2.9.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "get-random-port" ];
  };
  "get-random-port" = self.by-version."get-random-port"."0.0.1";
  by-spec."glob"."3.x" =
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
  by-spec."glob"."^3.2.1" =
    self.by-version."glob"."3.2.11";
  by-spec."glob"."^3.2.9" =
    self.by-version."glob"."3.2.11";
  by-spec."got"."^1.0.1" =
    self.by-version."got"."1.2.2";
  by-version."got"."1.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "got-1.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/got/-/got-1.2.2.tgz";
        name = "got-1.2.2.tgz";
        sha1 = "d9430ba32f6a30218243884418767340aafc0400";
      })
    ];
    buildInputs =
      (self.nativeDeps."got" or []);
    deps = {
      "object-assign-1.0.0" = self.by-version."object-assign"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "got" ];
  };
  by-spec."graceful-fs"."1.2" =
    self.by-version."graceful-fs"."1.2.3";
  by-version."graceful-fs"."1.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
        name = "graceful-fs-1.2.3.tgz";
        sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
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
  by-spec."graceful-fs"."3" =
    self.by-version."graceful-fs"."3.0.5";
  by-version."graceful-fs"."3.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-3.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.5.tgz";
        name = "graceful-fs-3.0.5.tgz";
        sha1 = "4a880474bdeb716fe3278cf29792dec38dfac418";
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
  by-spec."graceful-fs"."^3.0.1" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."graceful-fs"."~1" =
    self.by-version."graceful-fs"."1.2.3";
  by-spec."graceful-fs"."~3.0.2" =
    self.by-version."graceful-fs"."3.0.5";
  by-spec."grim"."1.0.0" =
    self.by-version."grim"."1.0.0";
  by-version."grim"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "grim-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grim/-/grim-1.0.0.tgz";
        name = "grim-1.0.0.tgz";
        sha1 = "70281a77942fcf217b1aac3a7db90cbe9d1ceecf";
      })
    ];
    buildInputs =
      (self.nativeDeps."grim" or []);
    deps = {
      "coffeestack-0.7.0" = self.by-version."coffeestack"."0.7.0";
      "emissary-1.3.1" = self.by-version."emissary"."1.3.1";
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "grim" ];
  };
  by-spec."grim"."^1.0.0" =
    self.by-version."grim"."1.1.0";
  by-version."grim"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "grim-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/grim/-/grim-1.1.0.tgz";
        name = "grim-1.1.0.tgz";
        sha1 = "10d9518f9b48f73d358917dd7d21cf11d614c47c";
      })
    ];
    buildInputs =
      (self.nativeDeps."grim" or []);
    deps = {
      "coffeestack-0.7.0" = self.by-version."coffeestack"."0.7.0";
      "emissary-1.3.1" = self.by-version."emissary"."1.3.1";
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "grim" ];
  };
  by-spec."handlebars"."1.3.x" =
    self.by-version."handlebars"."1.3.0";
  by-version."handlebars"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "handlebars-1.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/handlebars/-/handlebars-1.3.0.tgz";
        name = "handlebars-1.3.0.tgz";
        sha1 = "9e9b130a93e389491322d975cf3ec1818c37ce34";
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
  by-spec."harmony-collections"."git+https://github.com/Benvie/harmony-collections.git#e81b4b808359e2def9eeeabfdee69c2989e1fe96" =
    self.by-version."harmony-collections"."0.3.7";
  by-version."harmony-collections"."0.3.7" = lib.makeOverridable self.buildNodePackage {
    name = "harmony-collections-0.3.7";
    bin = false;
    src = [
      (fetchgit {
        url = "https://github.com/Benvie/harmony-collections.git";
        rev = "e81b4b808359e2def9eeeabfdee69c2989e1fe96";
        sha256 = "538698c28387c02cd9a35abd76c7885458d05a8b17075f75b911331608ea03d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."harmony-collections" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "harmony-collections" ];
  };
  by-spec."has"."~0.0.1" =
    self.by-version."has"."0.0.1";
  by-version."has"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "has-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has/-/has-0.0.1.tgz";
        name = "has-0.0.1.tgz";
        sha1 = "66639c14eaf559f139da2be0e438910ef3fd5b1b";
      })
    ];
    buildInputs =
      (self.nativeDeps."has" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "has" ];
  };
  by-spec."has-ansi"."^0.1.0" =
    self.by-version."has-ansi"."0.1.0";
  by-version."has-ansi"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "has-ansi-0.1.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/has-ansi/-/has-ansi-0.1.0.tgz";
        name = "has-ansi-0.1.0.tgz";
        sha1 = "84f265aae8c0e6a88a12d7022894b7568894c62e";
      })
    ];
    buildInputs =
      (self.nativeDeps."has-ansi" or []);
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "has-ansi" ];
  };
  by-spec."hawk"."~0.10.2" =
    self.by-version."hawk"."0.10.2";
  by-version."hawk"."0.10.2" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-0.10.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-0.10.2.tgz";
        name = "hawk-0.10.2.tgz";
        sha1 = "9b361dee95a931640e6d504e05609a8fc3ac45d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."hawk" or []);
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
      "boom-0.3.8" = self.by-version."boom"."0.3.8";
      "cryptiles-0.1.3" = self.by-version."cryptiles"."0.1.3";
      "sntp-0.1.4" = self.by-version."sntp"."0.1.4";
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
      "hoek-2.11.0" = self.by-version."hoek"."2.11.0";
      "boom-2.6.1" = self.by-version."boom"."2.6.1";
      "cryptiles-2.0.4" = self.by-version."cryptiles"."2.0.4";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hawk" ];
  };
  by-spec."highlight.js"."^8.2.0" =
    self.by-version."highlight.js"."8.4.0";
  by-version."highlight.js"."8.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "highlight.js-8.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/highlight.js/-/highlight.js-8.4.0.tgz";
        name = "highlight.js-8.4.0.tgz";
        sha1 = "dc0d05b8dc9b110f13bce52cb96fd1e0c6bc791c";
      })
    ];
    buildInputs =
      (self.nativeDeps."highlight.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "highlight.js" ];
  };
  "highlight.js" = self.by-version."highlight.js"."8.4.0";
  by-spec."hoek"."0.7.x" =
    self.by-version."hoek"."0.7.6";
  by-version."hoek"."0.7.6" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-0.7.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-0.7.6.tgz";
        name = "hoek-0.7.6.tgz";
        sha1 = "60fbd904557541cd2b8795abf308a1b3770e155a";
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
    self.by-version."hoek"."2.11.0";
  by-version."hoek"."2.11.0" = lib.makeOverridable self.buildNodePackage {
    name = "hoek-2.11.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hoek/-/hoek-2.11.0.tgz";
        name = "hoek-2.11.0.tgz";
        sha1 = "e588ec66a6b405b0e7140308720e1e1cd4f035b7";
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
  by-spec."htmlparser2"."~3.7.0" =
    self.by-version."htmlparser2"."3.7.3";
  by-version."htmlparser2"."3.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "htmlparser2-3.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.7.3.tgz";
        name = "htmlparser2-3.7.3.tgz";
        sha1 = "6a64c77637c08c6f30ec2a8157a53333be7cb05e";
      })
    ];
    buildInputs =
      (self.nativeDeps."htmlparser2" or []);
    deps = {
      "domhandler-2.2.1" = self.by-version."domhandler"."2.2.1";
      "domutils-1.5.1" = self.by-version."domutils"."1.5.1";
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "entities-1.0.0" = self.by-version."entities"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "htmlparser2" ];
  };
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
  by-spec."iconv-lite"."^0.4.4" =
    self.by-version."iconv-lite"."0.4.7";
  by-version."iconv-lite"."0.4.7" = lib.makeOverridable self.buildNodePackage {
    name = "iconv-lite-0.4.7";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.7.tgz";
        name = "iconv-lite-0.4.7.tgz";
        sha1 = "89d32fec821bf8597f44609b4bc09bed5c209a23";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
  "iconv-lite" = self.by-version."iconv-lite"."0.4.7";
  by-spec."iconv-lite"."~0.4.4" =
    self.by-version."iconv-lite"."0.4.7";
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
  by-spec."inherits"."^2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ini"."~1.1.0" =
    self.by-version."ini"."1.1.0";
  by-version."ini"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.1.0.tgz";
        name = "ini-1.1.0.tgz";
        sha1 = "4e808c2ce144c6c1788918e034d6797bc6cf6281";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  by-spec."ini"."~1.3.0" =
    self.by-version."ini"."1.3.2";
  by-version."ini"."1.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "ini-1.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ini/-/ini-1.3.2.tgz";
        name = "ini-1.3.2.tgz";
        sha1 = "9ebf4a44daf9d89acd07aab9f89a083d887f6dec";
      })
    ];
    buildInputs =
      (self.nativeDeps."ini" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ini" ];
  };
  by-spec."interval-skip-list"."^2.0.0" =
    self.by-version."interval-skip-list"."2.0.0";
  by-version."interval-skip-list"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "interval-skip-list-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/interval-skip-list/-/interval-skip-list-2.0.0.tgz";
        name = "interval-skip-list-2.0.0.tgz";
        sha1 = "694cdcb23608116e1dde2da10d319f5f165ae223";
      })
    ];
    buildInputs =
      (self.nativeDeps."interval-skip-list" or []);
    deps = {
      "underscore-1.5.2" = self.by-version."underscore"."1.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "interval-skip-list" ];
  };
  by-spec."ipaddr.js"."0.1.8" =
    self.by-version."ipaddr.js"."0.1.8";
  by-version."ipaddr.js"."0.1.8" = lib.makeOverridable self.buildNodePackage {
    name = "ipaddr.js-0.1.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.8.tgz";
        name = "ipaddr.js-0.1.8.tgz";
        sha1 = "27442eda77b626c44724b4aa8a1867e8410579ee";
      })
    ];
    buildInputs =
      (self.nativeDeps."ipaddr.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "ipaddr.js" ];
  };
  by-spec."is-npm"."^1.0.0" =
    self.by-version."is-npm"."1.0.0";
  by-version."is-npm"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "is-npm-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/is-npm/-/is-npm-1.0.0.tgz";
        name = "is-npm-1.0.0.tgz";
        sha1 = "f2fb63a65e4905b406c86072765a1a4dc793b9f4";
      })
    ];
    buildInputs =
      (self.nativeDeps."is-npm" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "is-npm" ];
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
    self.by-version."isstream"."0.1.1";
  by-version."isstream"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "isstream-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/isstream/-/isstream-0.1.1.tgz";
        name = "isstream-0.1.1.tgz";
        sha1 = "48332c5999893996ba253c81c7bd6e7ae0905c4f";
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
  by-spec."istanbul"."^0.3.5" =
    self.by-version."istanbul"."0.3.5";
  by-version."istanbul"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "istanbul-0.3.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/istanbul/-/istanbul-0.3.5.tgz";
        name = "istanbul-0.3.5.tgz";
        sha1 = "ef9ca4c1d5e6a5deac2245842051b59763a2de37";
      })
    ];
    buildInputs =
      (self.nativeDeps."istanbul" or []);
    deps = {
      "esprima-1.2.4" = self.by-version."esprima"."1.2.4";
      "escodegen-1.3.3" = self.by-version."escodegen"."1.3.3";
      "handlebars-1.3.0" = self.by-version."handlebars"."1.3.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "fileset-0.1.5" = self.by-version."fileset"."0.1.5";
      "which-1.0.8" = self.by-version."which"."1.0.8";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "abbrev-1.0.5" = self.by-version."abbrev"."1.0.5";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
      "resolve-0.7.4" = self.by-version."resolve"."0.7.4";
      "js-yaml-3.2.6" = self.by-version."js-yaml"."3.2.6";
      "once-1.3.1" = self.by-version."once"."1.3.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "istanbul" ];
  };
  "istanbul" = self.by-version."istanbul"."0.3.5";
  by-spec."js-yaml"."3.x" =
    self.by-version."js-yaml"."3.2.6";
  by-version."js-yaml"."3.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "js-yaml-3.2.6";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.2.6.tgz";
        name = "js-yaml-3.2.6.tgz";
        sha1 = "dde1ffbe2726e3fff97efb65fd02dbd6647b8309";
      })
    ];
    buildInputs =
      (self.nativeDeps."js-yaml" or []);
    deps = {
      "argparse-0.1.16" = self.by-version."argparse"."0.1.16";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "js-yaml" ];
  };
  by-spec."js-yaml"."^3.1.0" =
    self.by-version."js-yaml"."3.2.6";
  by-spec."json-stringify-safe"."~3.0.0" =
    self.by-version."json-stringify-safe"."3.0.0";
  by-version."json-stringify-safe"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "json-stringify-safe-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-3.0.0.tgz";
        name = "json-stringify-safe-3.0.0.tgz";
        sha1 = "9db7b0e530c7f289c5e8c8432af191c2ff75a5b3";
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
  by-spec."latest-version"."^1.0.0" =
    self.by-version."latest-version"."1.0.0";
  by-version."latest-version"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "latest-version-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/latest-version/-/latest-version-1.0.0.tgz";
        name = "latest-version-1.0.0.tgz";
        sha1 = "84f40e5c90745c7e4f7811624d6152c381d931d9";
      })
    ];
    buildInputs =
      (self.nativeDeps."latest-version" or []);
    deps = {
      "package-json-1.0.1" = self.by-version."package-json"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "latest-version" ];
  };
  by-spec."lazy.js"."^0.3.2" =
    self.by-version."lazy.js"."0.3.2";
  by-version."lazy.js"."0.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "lazy.js-0.3.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lazy.js/-/lazy.js-0.3.2.tgz";
        name = "lazy.js-0.3.2.tgz";
        sha1 = "7cc1107e5f809ae70498f511dd180e1f80b4efa9";
      })
    ];
    buildInputs =
      (self.nativeDeps."lazy.js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lazy.js" ];
  };
  "lazy.js" = self.by-version."lazy.js"."0.3.2";
  by-spec."lex"."^1.7.5" =
    self.by-version."lex"."1.7.8";
  by-version."lex"."1.7.8" = lib.makeOverridable self.buildNodePackage {
    name = "lex-1.7.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lex/-/lex-1.7.8.tgz";
        name = "lex-1.7.8.tgz";
        sha1 = "ab1e7baed788491760de3045fd537639a45d1501";
      })
    ];
    buildInputs =
      (self.nativeDeps."lex" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "lex" ];
  };
  "lex" = self.by-version."lex"."1.7.8";
  by-spec."lodash"."^2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-version."lodash"."2.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "lodash-2.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/lodash/-/lodash-2.4.1.tgz";
        name = "lodash-2.4.1.tgz";
        sha1 = "5b7723034dda4d262e5a46fb2c58d7cc22f71420";
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
  "lodash" = self.by-version."lodash"."2.4.1";
  by-spec."lodash"."~2.4.1" =
    self.by-version."lodash"."2.4.1";
  by-spec."longjohn"."^0.2.4" =
    self.by-version."longjohn"."0.2.4";
  by-version."longjohn"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "longjohn-0.2.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/longjohn/-/longjohn-0.2.4.tgz";
        name = "longjohn-0.2.4.tgz";
        sha1 = "48436a1f359e7666f678e2170ee1f43bba8f8b4c";
      })
    ];
    buildInputs =
      (self.nativeDeps."longjohn" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "longjohn" ];
  };
  "longjohn" = self.by-version."longjohn"."0.2.4";
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
  by-spec."media-typer"."0.3.0" =
    self.by-version."media-typer"."0.3.0";
  by-version."media-typer"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "media-typer-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
        name = "media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      })
    ];
    buildInputs =
      (self.nativeDeps."media-typer" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "media-typer" ];
  };
  by-spec."merge-descriptors"."0.0.2" =
    self.by-version."merge-descriptors"."0.0.2";
  by-version."merge-descriptors"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "merge-descriptors-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-0.0.2.tgz";
        name = "merge-descriptors-0.0.2.tgz";
        sha1 = "c36a52a781437513c57275f39dd9d317514ac8c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."merge-descriptors" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "merge-descriptors" ];
  };
  by-spec."methods"."~1.1.1" =
    self.by-version."methods"."1.1.1";
  by-version."methods"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "methods-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-1.1.1.tgz";
        name = "methods-1.1.1.tgz";
        sha1 = "17ea6366066d00c58e375b8ec7dfd0453c89822a";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."mime"."1.2.11" =
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
  by-spec."mime"."~1.2.2" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.7" =
    self.by-version."mime"."1.2.11";
  by-spec."mime-db"."~1.6.0" =
    self.by-version."mime-db"."1.6.1";
  by-version."mime-db"."1.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "mime-db-1.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.6.1.tgz";
        name = "mime-db-1.6.1.tgz";
        sha1 = "6e85cd87c961d130d6ebd37efdfc2c0e06fdfcd3";
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
  by-spec."mime-types"."~2.0.1" =
    self.by-version."mime-types"."2.0.8";
  by-version."mime-types"."2.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "mime-types-2.0.8";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.8.tgz";
        name = "mime-types-2.0.8.tgz";
        sha1 = "5612bf6b9ec8a1285a81184fa4237fbfdbb89a7e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = {
      "mime-db-1.6.1" = self.by-version."mime-db"."1.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
  };
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.8";
  by-spec."mime-types"."~2.0.8" =
    self.by-version."mime-types"."2.0.8";
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
  by-spec."minimatch"."0.x" =
    self.by-version."minimatch"."0.4.0";
  by-version."minimatch"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "minimatch-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimatch/-/minimatch-0.4.0.tgz";
        name = "minimatch-0.4.0.tgz";
        sha1 = "bd2c7d060d2c8c8fd7cde7f1f2ed2d5b270fdb1b";
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
  by-spec."minimatch"."~0.2.0" =
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
  by-spec."minimist"."~0.0.7" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = lib.makeOverridable self.buildNodePackage {
    name = "minimist-0.0.10";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
        name = "minimist-0.0.10.tgz";
        sha1 = "de3f98543dbf96082be48ad1a0c7cda836301dcf";
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
  by-spec."mixto"."1.x" =
    self.by-version."mixto"."1.0.0";
  by-version."mixto"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "mixto-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mixto/-/mixto-1.0.0.tgz";
        name = "mixto-1.0.0.tgz";
        sha1 = "c320ef61b52f2898f522e17d8bbc6d506d8425b6";
      })
    ];
    buildInputs =
      (self.nativeDeps."mixto" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mixto" ];
  };
  by-spec."mkdirp"."0.5" =
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
  by-spec."mkdirp".">=0.5 0" =
    self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."^0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  "mkdirp" = self.by-version."mkdirp"."0.5.0";
  by-spec."mkdirp"."~0.3.5" =
    self.by-version."mkdirp"."0.3.5";
  by-version."mkdirp"."0.3.5" = lib.makeOverridable self.buildNodePackage {
    name = "mkdirp-0.3.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.5.tgz";
        name = "mkdirp-0.3.5.tgz";
        sha1 = "de3e5f8961c88c787ee1368df849ac4413eca8d7";
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
  by-spec."mkdirp"."~0.5.0" =
    self.by-version."mkdirp"."0.5.0";
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
  by-spec."ms"."0.7.0" =
    self.by-version."ms"."0.7.0";
  by-version."ms"."0.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "ms-0.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.7.0.tgz";
        name = "ms-0.7.0.tgz";
        sha1 = "865be94c2e7397ad8a57da6a633a6e2f30798b83";
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
  by-spec."nan"."https://atom.io/download/atom-shell/nan-1.6.1.tgz" =
    self.by-version."nan"."1.6.1";
  by-version."nan"."1.6.1" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.6.1";
    bin = false;
    src = [
      (fetchurl {
        url = "https://atom.io/download/atom-shell/nan-1.6.1.tgz";
        name = "nan-1.6.1.tgz";
        sha256 = "bb29e72def8aabbc1ecef82feba47a1de354fe4ce3ab476a91ea7c73bd787f2b";
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
  by-spec."nan"."~1.0.0" =
    self.by-version."nan"."1.0.0";
  by-version."nan"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "nan-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.0.0.tgz";
        name = "nan-1.0.0.tgz";
        sha1 = "ae24f8850818d662fcab5acf7f3b95bfaa2ccf38";
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
  by-spec."nan"."~1.5.3" =
    self.by-version."nan"."1.5.3";
  by-spec."negotiator"."0.5.0" =
    self.by-version."negotiator"."0.5.0";
  by-version."negotiator"."0.5.0" = lib.makeOverridable self.buildNodePackage {
    name = "negotiator-0.5.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.5.0.tgz";
        name = "negotiator-0.5.0.tgz";
        sha1 = "bb77b3139d80d9b1ee8c913520a18b0d475b1b90";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
  };
  by-spec."node-inspector"."^0.8.3" =
    self.by-version."node-inspector"."0.8.3";
  by-version."node-inspector"."0.8.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-inspector-0.8.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-inspector/-/node-inspector-0.8.3.tgz";
        name = "node-inspector-0.8.3.tgz";
        sha1 = "2eac57771973c6eb49100ef4c9caa6ae0bcd8911";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-inspector" or []);
    deps = {
      "express-4.11.2" = self.by-version."express"."4.11.2";
      "serve-favicon-2.2.0" = self.by-version."serve-favicon"."2.2.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "rc-0.5.5" = self.by-version."rc"."0.5.5";
      "strong-data-uri-0.1.1" = self.by-version."strong-data-uri"."0.1.1";
      "debug-1.0.4" = self.by-version."debug"."1.0.4";
      "ws-0.4.32" = self.by-version."ws"."0.4.32";
      "opener-1.4.0" = self.by-version."opener"."1.4.0";
      "yargs-1.3.3" = self.by-version."yargs"."1.3.3";
      "which-1.0.8" = self.by-version."which"."1.0.8";
      "v8-debug-0.3.4" = self.by-version."v8-debug"."0.3.4";
      "v8-profiler-5.2.3" = self.by-version."v8-profiler"."5.2.3";
      "semver-3.0.1" = self.by-version."semver"."3.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-inspector" ];
  };
  "node-inspector" = self.by-version."node-inspector"."0.8.3";
  by-spec."node-pre-gyp"."^0.6.0" =
    self.by-version."node-pre-gyp"."0.6.2";
  by-version."node-pre-gyp"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-pre-gyp-0.6.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-pre-gyp/-/node-pre-gyp-0.6.2.tgz";
        name = "node-pre-gyp-0.6.2.tgz";
        sha1 = "cd902db6db1c80b1da497a493bf950558a8ffa1b";
      })
    ];
    buildInputs =
      (self.nativeDeps."node-pre-gyp" or []);
    deps = {
      "nopt-3.0.1" = self.by-version."nopt"."3.0.1";
      "npmlog-0.1.1" = self.by-version."npmlog"."0.1.1";
      "request-2.53.0" = self.by-version."request"."2.53.0";
      "semver-4.2.0" = self.by-version."semver"."4.2.0";
      "tar-1.0.3" = self.by-version."tar"."1.0.3";
      "tar-pack-2.0.0" = self.by-version."tar-pack"."2.0.0";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rc-0.5.5" = self.by-version."rc"."0.5.5";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "node-pre-gyp" ];
  };
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.2";
  by-version."node-uuid"."1.4.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.2.tgz";
        name = "node-uuid-1.4.2.tgz";
        sha1 = "907db3d11b7b6a2cf4f905fb7199f14ae7379ba0";
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
  by-spec."nopt"."3.x" =
    self.by-version."nopt"."3.0.1";
  by-version."nopt"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-3.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-3.0.1.tgz";
        name = "nopt-3.0.1.tgz";
        sha1 = "bce5c42446a3291f47622a370abbf158fbbacbfd";
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
  by-spec."nopt"."~3.0.1" =
    self.by-version."nopt"."3.0.1";
  by-spec."npmlog"."~0.1.1" =
    self.by-version."npmlog"."0.1.1";
  by-version."npmlog"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "npmlog-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/npmlog/-/npmlog-0.1.1.tgz";
        name = "npmlog-0.1.1.tgz";
        sha1 = "8b9b9e4405d7ec48c31c2346965aadc7abaecaa5";
      })
    ];
    buildInputs =
      (self.nativeDeps."npmlog" or []);
    deps = {
      "ansi-0.3.0" = self.by-version."ansi"."0.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "npmlog" ];
  };
  by-spec."oauth-sign"."~0.2.0" =
    self.by-version."oauth-sign"."0.2.0";
  by-version."oauth-sign"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "oauth-sign-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.2.0.tgz";
        name = "oauth-sign-0.2.0.tgz";
        sha1 = "a0e6a1715daed062f322b622b7fe5afd1035b6e2";
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
  by-spec."object-assign"."^1.0.0" =
    self.by-version."object-assign"."1.0.0";
  by-version."object-assign"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-assign-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-assign/-/object-assign-1.0.0.tgz";
        name = "object-assign-1.0.0.tgz";
        sha1 = "e65dc8766d3b47b4b8307465c8311da030b070a6";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-assign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-assign" ];
  };
  by-spec."object-assign"."^2.0.0" =
    self.by-version."object-assign"."2.0.0";
  by-version."object-assign"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-assign-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-assign/-/object-assign-2.0.0.tgz";
        name = "object-assign-2.0.0.tgz";
        sha1 = "f8309b09083b01261ece3ef7373f2b57b8dd7042";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-assign" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-assign" ];
  };
  by-spec."object-inspect"."^1.0.0" =
    self.by-version."object-inspect"."1.0.0";
  by-version."object-inspect"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-inspect-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-inspect/-/object-inspect-1.0.0.tgz";
        name = "object-inspect-1.0.0.tgz";
        sha1 = "df6c525311b57a7d70186915e87b81eb33748468";
      })
    ];
    buildInputs =
      (self.nativeDeps."object-inspect" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "object-inspect" ];
  };
  by-spec."on-finished"."~2.2.0" =
    self.by-version."on-finished"."2.2.0";
  by-version."on-finished"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "on-finished-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/on-finished/-/on-finished-2.2.0.tgz";
        name = "on-finished-2.2.0.tgz";
        sha1 = "e6ba6a09a3482d6b7969bc3da92c86f0a967605e";
      })
    ];
    buildInputs =
      (self.nativeDeps."on-finished" or []);
    deps = {
      "ee-first-1.1.0" = self.by-version."ee-first"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "on-finished" ];
  };
  by-spec."once"."1.x" =
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
  by-spec."once"."~1.1.1" =
    self.by-version."once"."1.1.1";
  by-version."once"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "once-1.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/once/-/once-1.1.1.tgz";
        name = "once-1.1.1.tgz";
        sha1 = "9db574933ccb08c3a7614d154032c09ea6f339e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."once" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "once" ];
  };
  by-spec."opener"."^1.3.0" =
    self.by-version."opener"."1.4.0";
  by-version."opener"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "opener-1.4.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/opener/-/opener-1.4.0.tgz";
        name = "opener-1.4.0.tgz";
        sha1 = "d11f86eeeb076883735c9d509f538fe82d10b941";
      })
    ];
    buildInputs =
      (self.nativeDeps."opener" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "opener" ];
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
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "options-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/options/-/options-0.0.6.tgz";
        name = "options-0.0.6.tgz";
        sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
      })
    ];
    buildInputs =
      (self.nativeDeps."options" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "options" ];
  };
  by-spec."osenv"."^0.1.0" =
    self.by-version."osenv"."0.1.0";
  by-version."osenv"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.1.0.tgz";
        name = "osenv-0.1.0.tgz";
        sha1 = "61668121eec584955030b9f470b1d2309504bfcb";
      })
    ];
    buildInputs =
      (self.nativeDeps."osenv" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "osenv" ];
  };
  by-spec."package-json"."^1.0.0" =
    self.by-version."package-json"."1.0.1";
  by-version."package-json"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "package-json-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/package-json/-/package-json-1.0.1.tgz";
        name = "package-json-1.0.1.tgz";
        sha1 = "89cc831317c4d17922413d5318b23c904e5cf43e";
      })
    ];
    buildInputs =
      (self.nativeDeps."package-json" or []);
    deps = {
      "got-1.2.2" = self.by-version."got"."1.2.2";
      "registry-url-2.1.0" = self.by-version."registry-url"."2.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "package-json" ];
  };
  by-spec."parseurl"."~1.3.0" =
    self.by-version."parseurl"."1.3.0";
  by-version."parseurl"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "parseurl-1.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parseurl/-/parseurl-1.3.0.tgz";
        name = "parseurl-1.3.0.tgz";
        sha1 = "b58046db4223e145afa76009e61bac87cc2281b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."parseurl" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "parseurl" ];
  };
  by-spec."path-to-regexp"."0.1.3" =
    self.by-version."path-to-regexp"."0.1.3";
  by-version."path-to-regexp"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "path-to-regexp-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.3.tgz";
        name = "path-to-regexp-0.1.3.tgz";
        sha1 = "21b9ab82274279de25b156ea08fd12ca51b8aecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-to-regexp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "path-to-regexp" ];
  };
  by-spec."pathwatcher"."^3.0.0" =
    self.by-version."pathwatcher"."3.1.0";
  by-version."pathwatcher"."3.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "pathwatcher-3.1.0";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/pathwatcher/-/pathwatcher-3.1.0.tgz";
        name = "pathwatcher-3.1.0.tgz";
        sha1 = "1c5c5582edcac6c0b2a5a3be9cceb9b6579c52d0";
      })
    ];
    buildInputs =
      (self.nativeDeps."pathwatcher" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "emissary-1.3.1" = self.by-version."emissary"."1.3.1";
      "event-kit-1.0.2" = self.by-version."event-kit"."1.0.2";
      "fs-plus-2.5.0" = self.by-version."fs-plus"."2.5.0";
      "grim-1.1.0" = self.by-version."grim"."1.1.0";
      "iconv-lite-0.4.7" = self.by-version."iconv-lite"."0.4.7";
      "nan-1.6.1" = self.by-version."nan"."1.6.1";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "runas-2.0.0" = self.by-version."runas"."2.0.0";
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "pathwatcher" ];
  };
  by-spec."pkginfo"."0.3.x" =
    self.by-version."pkginfo"."0.3.0";
  by-version."pkginfo"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "pkginfo-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/pkginfo/-/pkginfo-0.3.0.tgz";
        name = "pkginfo-0.3.0.tgz";
        sha1 = "726411401039fe9b009eea86614295d5f3a54276";
      })
    ];
    buildInputs =
      (self.nativeDeps."pkginfo" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "pkginfo" ];
  };
  by-spec."property-accessors"."^1.1" =
    self.by-version."property-accessors"."1.1.0";
  by-version."property-accessors"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "property-accessors-1.1.0";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/property-accessors/-/property-accessors-1.1.0.tgz";
        name = "property-accessors-1.1.0.tgz";
        sha1 = "ce1672797473eef1384d95a054a630ebcd539fbf";
      })
    ];
    buildInputs =
      (self.nativeDeps."property-accessors" or []);
    deps = {
      "mixto-1.0.0" = self.by-version."mixto"."1.0.0";
      "harmony-collections-0.3.7" = self.by-version."harmony-collections"."0.3.7";
    };
    peerDependencies = [
    ];
    passthru.names = [ "property-accessors" ];
  };
  by-spec."proxy-addr"."~1.0.6" =
    self.by-version."proxy-addr"."1.0.6";
  by-version."proxy-addr"."1.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "proxy-addr-1.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.6.tgz";
        name = "proxy-addr-1.0.6.tgz";
        sha1 = "fce3a4c486bf2e188ad1e76e18399a79d02c0e72";
      })
    ];
    buildInputs =
      (self.nativeDeps."proxy-addr" or []);
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-0.1.8" = self.by-version."ipaddr.js"."0.1.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "proxy-addr" ];
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
  by-spec."q"."~1.0.1" =
    self.by-version."q"."1.0.1";
  by-version."q"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "q-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/q/-/q-1.0.1.tgz";
        name = "q-1.0.1.tgz";
        sha1 = "11872aeedee89268110b10a718448ffb10112a14";
      })
    ];
    buildInputs =
      (self.nativeDeps."q" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "q" ];
  };
  by-spec."qs"."2.3.3" =
    self.by-version."qs"."2.3.3";
  by-version."qs"."2.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "qs-2.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.3.3.tgz";
        name = "qs-2.3.3.tgz";
        sha1 = "e9e85adbe75da0bbe4c8e0476a086290f863b404";
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
  by-spec."qs"."~0.5.4" =
    self.by-version."qs"."0.5.6";
  by-version."qs"."0.5.6" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.5.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
        name = "qs-0.5.6.tgz";
        sha1 = "31b1ad058567651c526921506b9a8793911a0384";
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
  by-spec."qs"."~2.3.1" =
    self.by-version."qs"."2.3.3";
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.2";
  by-version."range-parser"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "range-parser-1.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.2.tgz";
        name = "range-parser-1.0.2.tgz";
        sha1 = "06a12a42e5131ba8e457cd892044867f2344e549";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."rc"."^0.5.1" =
    self.by-version."rc"."0.5.5";
  by-version."rc"."0.5.5" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.5.5";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rc/-/rc-0.5.5.tgz";
        name = "rc-0.5.5.tgz";
        sha1 = "541cc3300f464b6dfe6432d756f0f2dd3e9eb199";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc" or []);
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "strip-json-comments-0.1.3" = self.by-version."strip-json-comments"."0.1.3";
      "ini-1.3.2" = self.by-version."ini"."1.3.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  by-spec."rc"."slap-editor/rc" =
    self.by-version."rc"."0.5.4";
  by-version."rc"."0.5.4" = lib.makeOverridable self.buildNodePackage {
    name = "rc-0.5.4";
    bin = true;
    src = [
      (fetchgit {
        url = "git://github.com/slap-editor/rc";
        rev = "61dbb79f17956a62a1b26785ef1a176feafe0e7b";
        sha256 = "d70bd8cec8698a541b67a207bacce56df239f3ab4b9bf3dbfbd9e924e45dedbd";
      })
    ];
    buildInputs =
      (self.nativeDeps."rc" or []);
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "strip-json-comments-0.1.3" = self.by-version."strip-json-comments"."0.1.3";
      "ini-1.1.0" = self.by-version."ini"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rc" ];
  };
  "rc" = self.by-version."rc"."0.5.4";
  by-spec."rc"."~0.5.0" =
    self.by-version."rc"."0.5.5";
  by-spec."rc"."~0.5.1" =
    self.by-version."rc"."0.5.5";
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
  by-spec."registry-url"."^2.0.0" =
    self.by-version."registry-url"."2.1.0";
  by-version."registry-url"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "registry-url-2.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/registry-url/-/registry-url-2.1.0.tgz";
        name = "registry-url-2.1.0.tgz";
        sha1 = "f9624c877b43946af540849ba772ed704d606f7a";
      })
    ];
    buildInputs =
      (self.nativeDeps."registry-url" or []);
    deps = {
      "rc-0.5.5" = self.by-version."rc"."0.5.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "registry-url" ];
  };
  by-spec."request"."2.16.x" =
    self.by-version."request"."2.16.6";
  by-version."request"."2.16.6" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.16.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.16.6.tgz";
        name = "request-2.16.6.tgz";
        sha1 = "872fe445ae72de266b37879d6ad7dc948fa01cad";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "form-data-0.0.10" = self.by-version."form-data"."0.0.10";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "hawk-0.10.2" = self.by-version."hawk"."0.10.2";
      "node-uuid-1.4.2" = self.by-version."node-uuid"."1.4.2";
      "cookie-jar-0.2.0" = self.by-version."cookie-jar"."0.2.0";
      "aws-sign-0.2.0" = self.by-version."aws-sign"."0.2.0";
      "oauth-sign-0.2.0" = self.by-version."oauth-sign"."0.2.0";
      "forever-agent-0.2.0" = self.by-version."forever-agent"."0.2.0";
      "tunnel-agent-0.2.0" = self.by-version."tunnel-agent"."0.2.0";
      "json-stringify-safe-3.0.0" = self.by-version."json-stringify-safe"."3.0.0";
      "qs-0.5.6" = self.by-version."qs"."0.5.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."request"."2.x" =
    self.by-version."request"."2.53.0";
  by-version."request"."2.53.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.53.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.53.0.tgz";
        name = "request-2.53.0.tgz";
        sha1 = "180a3ae92b7b639802e4f9545dd8fcdeb71d760c";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "mime-types-2.0.8" = self.by-version."mime-types"."2.0.8";
      "node-uuid-1.4.2" = self.by-version."node-uuid"."1.4.2";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.1" = self.by-version."isstream"."0.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  by-spec."resolve"."0.7.x" =
    self.by-version."resolve"."0.7.4";
  by-version."resolve"."0.7.4" = lib.makeOverridable self.buildNodePackage {
    name = "resolve-0.7.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resolve/-/resolve-0.7.4.tgz";
        name = "resolve-0.7.4.tgz";
        sha1 = "395a9ef9e873fbfe12bd14408bd91bb936003d69";
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
  by-spec."resumer"."~0.0.0" =
    self.by-version."resumer"."0.0.0";
  by-version."resumer"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "resumer-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/resumer/-/resumer-0.0.0.tgz";
        name = "resumer-0.0.0.tgz";
        sha1 = "f1e8f461e4064ba39e82af3cdc2a8c893d076759";
      })
    ];
    buildInputs =
      (self.nativeDeps."resumer" or []);
    deps = {
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "resumer" ];
  };
  by-spec."rimraf"."2" =
    self.by-version."rimraf"."2.2.8";
  by-version."rimraf"."2.2.8" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.2.8";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
        name = "rimraf-2.2.8.tgz";
        sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."~2.1.4" =
    self.by-version."rimraf"."2.1.4";
  by-version."rimraf"."2.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "rimraf-2.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/rimraf/-/rimraf-2.1.4.tgz";
        name = "rimraf-2.1.4.tgz";
        sha1 = "5a6eb62eeda068f51ede50f29b3e5cd22f3d9bb2";
      })
    ];
    buildInputs =
      (self.nativeDeps."rimraf" or []);
    deps = {
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "rimraf" ];
  };
  by-spec."rimraf"."~2.2.0" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2.2.2" =
    self.by-version."rimraf"."2.2.8";
  by-spec."rimraf"."~2.2.8" =
    self.by-version."rimraf"."2.2.8";
  by-spec."runas"."^2.0.0" =
    self.by-version."runas"."2.0.0";
  by-version."runas"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "runas-2.0.0";
    bin = false;
    src = [
      (self.patchSource fetchurl {
        url = "http://registry.npmjs.org/runas/-/runas-2.0.0.tgz";
        name = "runas-2.0.0.tgz";
        sha1 = "943d74dc6d250b90606721acde43347eb148efbb";
      })
    ];
    buildInputs =
      (self.nativeDeps."runas" or []);
    deps = {
      "nan-1.6.1" = self.by-version."nan"."1.6.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "runas" ];
  };
  by-spec."semver"."^3.0.1" =
    self.by-version."semver"."3.0.1";
  by-version."semver"."3.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "semver-3.0.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-3.0.1.tgz";
        name = "semver-3.0.1.tgz";
        sha1 = "720ac012515a252f91fb0dd2e99a56a70d6cf078";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."^4.0.0" =
    self.by-version."semver"."4.2.0";
  by-version."semver"."4.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-4.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-4.2.0.tgz";
        name = "semver-4.2.0.tgz";
        sha1 = "a571fd4adbe974fe32bd9cb4c5e249606f498423";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver" ];
  };
  by-spec."semver"."~4.2.0" =
    self.by-version."semver"."4.2.0";
  by-spec."semver-diff"."^2.0.0" =
    self.by-version."semver-diff"."2.0.0";
  by-version."semver-diff"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "semver-diff-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver-diff/-/semver-diff-2.0.0.tgz";
        name = "semver-diff-2.0.0.tgz";
        sha1 = "d43024f91aa7843937dc1379002766809f7480d2";
      })
    ];
    buildInputs =
      (self.nativeDeps."semver-diff" or []);
    deps = {
      "semver-4.2.0" = self.by-version."semver"."4.2.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "semver-diff" ];
  };
  by-spec."send"."0.11.1" =
    self.by-version."send"."0.11.1";
  by-version."send"."0.11.1" = lib.makeOverridable self.buildNodePackage {
    name = "send-0.11.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.11.1.tgz";
        name = "send-0.11.1.tgz";
        sha1 = "1beabfd42f9e2709f99028af3078ac12b47092d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = {
      "debug-2.1.1" = self.by-version."debug"."2.1.1";
      "depd-1.0.0" = self.by-version."depd"."1.0.0";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "on-finished-2.2.0" = self.by-version."on-finished"."2.2.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."serializable"."^1.0.0" =
    self.by-version."serializable"."1.0.0";
  by-version."serializable"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "serializable-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serializable/-/serializable-1.0.0.tgz";
        name = "serializable-1.0.0.tgz";
        sha1 = "cbb321be943f432e56b2b106455ba7be79f04d42";
      })
    ];
    buildInputs =
      (self.nativeDeps."serializable" or []);
    deps = {
      "mixto-1.0.0" = self.by-version."mixto"."1.0.0";
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
      "get-parameter-names-0.1.2" = self.by-version."get-parameter-names"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serializable" ];
  };
  by-spec."serve-favicon"."^2.1.1" =
    self.by-version."serve-favicon"."2.2.0";
  by-version."serve-favicon"."2.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "serve-favicon-2.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-favicon/-/serve-favicon-2.2.0.tgz";
        name = "serve-favicon-2.2.0.tgz";
        sha1 = "a0c25ee8a652e1a638a67db46269cd52a8705858";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-favicon" or []);
    deps = {
      "etag-1.5.1" = self.by-version."etag"."1.5.1";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "ms-0.7.0" = self.by-version."ms"."0.7.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-favicon" ];
  };
  by-spec."serve-static"."~1.8.1" =
    self.by-version."serve-static"."1.8.1";
  by-version."serve-static"."1.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "serve-static-1.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.8.1.tgz";
        name = "serve-static-1.8.1.tgz";
        sha1 = "08fabd39999f050fc311443f46d5888a77ecfc7c";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.11.1" = self.by-version."send"."0.11.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
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
  by-spec."slap-clipboard-plugin"."^0.0.5" =
    self.by-version."slap-clipboard-plugin"."0.0.5";
  by-version."slap-clipboard-plugin"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "slap-clipboard-plugin-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slap-clipboard-plugin/-/slap-clipboard-plugin-0.0.5.tgz";
        name = "slap-clipboard-plugin-0.0.5.tgz";
        sha1 = "464c48f7acc8deba9e8f50759be1c240cde37ab7";
      })
    ];
    buildInputs =
      (self.nativeDeps."slap-clipboard-plugin" or []);
    deps = {
      "copy-paste-1.0.1" = self.by-version."copy-paste"."1.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "slap-clipboard-plugin" ];
  };
  "slap-clipboard-plugin" = self.by-version."slap-clipboard-plugin"."0.0.5";
  by-spec."sntp"."0.1.x" =
    self.by-version."sntp"."0.1.4";
  by-version."sntp"."0.1.4" = lib.makeOverridable self.buildNodePackage {
    name = "sntp-0.1.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/sntp/-/sntp-0.1.4.tgz";
        name = "sntp-0.1.4.tgz";
        sha1 = "5ef481b951a7b29affdf4afd7f26838fc1120f84";
      })
    ];
    buildInputs =
      (self.nativeDeps."sntp" or []);
    deps = {
      "hoek-0.7.6" = self.by-version."hoek"."0.7.6";
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
      "hoek-2.11.0" = self.by-version."hoek"."2.11.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "sntp" ];
  };
  by-spec."source-map"."~0.1.31" =
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
  by-spec."source-map"."~0.1.33" =
    self.by-version."source-map"."0.1.43";
  by-spec."source-map"."~0.1.7" =
    self.by-version."source-map"."0.1.43";
  by-spec."span-skip-list"."~0.1.1" =
    self.by-version."span-skip-list"."0.1.1";
  by-version."span-skip-list"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "span-skip-list-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/span-skip-list/-/span-skip-list-0.1.1.tgz";
        name = "span-skip-list-0.1.1.tgz";
        sha1 = "66914ac0b041e7ba45abc9290102888e2f15499a";
      })
    ];
    buildInputs =
      (self.nativeDeps."span-skip-list" or []);
    deps = {
      "underscore-1.5.2" = self.by-version."underscore"."1.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "span-skip-list" ];
  };
  by-spec."stack-trace"."0.0.x" =
    self.by-version."stack-trace"."0.0.9";
  by-version."stack-trace"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "stack-trace-0.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/stack-trace/-/stack-trace-0.0.9.tgz";
        name = "stack-trace-0.0.9.tgz";
        sha1 = "a8f6eaeca90674c333e7c43953f275b451510695";
      })
    ];
    buildInputs =
      (self.nativeDeps."stack-trace" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "stack-trace" ];
  };
  by-spec."string-length"."^1.0.0" =
    self.by-version."string-length"."1.0.0";
  by-version."string-length"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "string-length-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/string-length/-/string-length-1.0.0.tgz";
        name = "string-length-1.0.0.tgz";
        sha1 = "5f0564b174feb299595a763da71513266370d3a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."string-length" or []);
    deps = {
      "strip-ansi-2.0.1" = self.by-version."strip-ansi"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "string-length" ];
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
  by-spec."strip-ansi"."^0.3.0" =
    self.by-version."strip-ansi"."0.3.0";
  by-version."strip-ansi"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "strip-ansi-0.3.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.3.0.tgz";
        name = "strip-ansi-0.3.0.tgz";
        sha1 = "25f48ea22ca79187f3174a4db8759347bb126220";
      })
    ];
    buildInputs =
      (self.nativeDeps."strip-ansi" or []);
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-ansi"."^2.0.0" =
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
      "ansi-regex-1.1.0" = self.by-version."ansi-regex"."1.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strip-ansi" ];
  };
  by-spec."strip-json-comments"."0.1.x" =
    self.by-version."strip-json-comments"."0.1.3";
  by-version."strip-json-comments"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "strip-json-comments-0.1.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strip-json-comments/-/strip-json-comments-0.1.3.tgz";
        name = "strip-json-comments-0.1.3.tgz";
        sha1 = "164c64e370a8a3cc00c9e01b539e569823f0ee54";
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
  by-spec."strong-data-uri"."~0.1.0" =
    self.by-version."strong-data-uri"."0.1.1";
  by-version."strong-data-uri"."0.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "strong-data-uri-0.1.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/strong-data-uri/-/strong-data-uri-0.1.1.tgz";
        name = "strong-data-uri-0.1.1.tgz";
        sha1 = "8660241807461d1d2dd247c70563f2f33e66c8ab";
      })
    ];
    buildInputs =
      (self.nativeDeps."strong-data-uri" or []);
    deps = {
      "truncate-1.0.4" = self.by-version."truncate"."1.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "strong-data-uri" ];
  };
  by-spec."supports-color"."^0.2.0" =
    self.by-version."supports-color"."0.2.0";
  by-version."supports-color"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "supports-color-0.2.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/supports-color/-/supports-color-0.2.0.tgz";
        name = "supports-color-0.2.0.tgz";
        sha1 = "d92de2694eb3f67323973d7ae3d8b55b4c22190a";
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
  by-spec."tape"."^2.12.3" =
    self.by-version."tape"."2.14.0";
  by-version."tape"."2.14.0" = lib.makeOverridable self.buildNodePackage {
    name = "tape-2.14.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tape/-/tape-2.14.0.tgz";
        name = "tape-2.14.0.tgz";
        sha1 = "c460a6f53674cbc17c73480203b0d8f357696b6a";
      })
    ];
    buildInputs =
      (self.nativeDeps."tape" or []);
    deps = {
      "deep-equal-0.2.2" = self.by-version."deep-equal"."0.2.2";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "object-inspect-1.0.0" = self.by-version."object-inspect"."1.0.0";
      "resumer-0.0.0" = self.by-version."resumer"."0.0.0";
      "through-2.3.6" = self.by-version."through"."2.3.6";
      "has-0.0.1" = self.by-version."has"."0.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tape" ];
  };
  "tape" = self.by-version."tape"."2.14.0";
  by-spec."tar"."~0.1.17" =
    self.by-version."tar"."0.1.20";
  by-version."tar"."0.1.20" = lib.makeOverridable self.buildNodePackage {
    name = "tar-0.1.20";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.20.tgz";
        name = "tar-0.1.20.tgz";
        sha1 = "42940bae5b5f22c74483699126f9f3f27449cb13";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  by-spec."tar"."~1.0.2" =
    self.by-version."tar"."1.0.3";
  by-version."tar"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "tar-1.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-1.0.3.tgz";
        name = "tar-1.0.3.tgz";
        sha1 = "15bcdab244fa4add44e4244a0176edb8aa9a2b44";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = {
      "block-stream-0.0.7" = self.by-version."block-stream"."0.0.7";
      "fstream-1.0.4" = self.by-version."fstream"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  by-spec."tar-pack"."~2.0.0" =
    self.by-version."tar-pack"."2.0.0";
  by-version."tar-pack"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "tar-pack-2.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar-pack/-/tar-pack-2.0.0.tgz";
        name = "tar-pack-2.0.0.tgz";
        sha1 = "c2c401c02dd366138645e917b3a6baa256a9dcab";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar-pack" or []);
    deps = {
      "uid-number-0.0.3" = self.by-version."uid-number"."0.0.3";
      "once-1.1.1" = self.by-version."once"."1.1.1";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "fstream-0.1.31" = self.by-version."fstream"."0.1.31";
      "tar-0.1.20" = self.by-version."tar"."0.1.20";
      "fstream-ignore-0.0.7" = self.by-version."fstream-ignore"."0.0.7";
      "readable-stream-1.0.33" = self.by-version."readable-stream"."1.0.33";
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tar-pack" ];
  };
  by-spec."temp"."~0.5.1" =
    self.by-version."temp"."0.5.1";
  by-version."temp"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.5.1.tgz";
        name = "temp-0.5.1.tgz";
        sha1 = "77ab19c79aa7b593cbe4fac2441768cad987b8df";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = {
      "rimraf-2.1.4" = self.by-version."rimraf"."2.1.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  by-spec."testla"."*" =
    self.by-version."testla"."0.1.2";
  by-version."testla"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "testla-0.1.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/testla/-/testla-0.1.2.tgz";
        name = "testla-0.1.2.tgz";
        sha1 = "2bd399cb65bf2d23783d6c4a340daa7d8ba9ce16";
      })
    ];
    buildInputs =
      (self.nativeDeps."testla" or []);
    deps = {
      "alt-0.12.2" = self.by-version."alt"."0.12.2";
      "dependency-injector-0.0.5" = self.by-version."dependency-injector"."0.0.5";
      "fantasy-promises-0.1.0" = self.by-version."fantasy-promises"."0.1.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "testla" ];
  };
  by-spec."text-buffer"."^4.1.0" =
    self.by-version."text-buffer"."4.1.0";
  by-version."text-buffer"."4.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "text-buffer-4.1.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/text-buffer/-/text-buffer-4.1.0.tgz";
        name = "text-buffer-4.1.0.tgz";
        sha1 = "3d3317d8946b9e4e9e4c0a32aa2f98d250aa67eb";
      })
    ];
    buildInputs =
      (self.nativeDeps."text-buffer" or []);
    deps = {
      "delegato-1.0.0" = self.by-version."delegato"."1.0.0";
      "atom-diff-2.0.0" = self.by-version."atom-diff"."2.0.0";
      "emissary-1.3.1" = self.by-version."emissary"."1.3.1";
      "event-kit-0.8.2" = self.by-version."event-kit"."0.8.2";
      "fs-plus-2.5.0" = self.by-version."fs-plus"."2.5.0";
      "grim-1.0.0" = self.by-version."grim"."1.0.0";
      "interval-skip-list-2.0.0" = self.by-version."interval-skip-list"."2.0.0";
      "pathwatcher-3.1.0" = self.by-version."pathwatcher"."3.1.0";
      "q-1.0.1" = self.by-version."q"."1.0.1";
      "serializable-1.0.0" = self.by-version."serializable"."1.0.0";
      "span-skip-list-0.1.1" = self.by-version."span-skip-list"."0.1.1";
      "underscore-plus-1.6.6" = self.by-version."underscore-plus"."1.6.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "text-buffer" ];
  };
  "text-buffer" = self.by-version."text-buffer"."4.1.0";
  by-spec."through"."^2.3.4" =
    self.by-version."through"."2.3.6";
  by-version."through"."2.3.6" = lib.makeOverridable self.buildNodePackage {
    name = "through-2.3.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/through/-/through-2.3.6.tgz";
        name = "through-2.3.6.tgz";
        sha1 = "26681c0f524671021d4e29df7c36bce2d0ecf2e8";
      })
    ];
    buildInputs =
      (self.nativeDeps."through" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "through" ];
  };
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.6";
  by-spec."tinycolor"."0.x" =
    self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "tinycolor-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
        name = "tinycolor-0.0.1.tgz";
        sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
      })
    ];
    buildInputs =
      (self.nativeDeps."tinycolor" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "tinycolor" ];
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
  by-spec."traverse"."^0.6.6" =
    self.by-version."traverse"."0.6.6";
  by-version."traverse"."0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "traverse-0.6.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traverse/-/traverse-0.6.6.tgz";
        name = "traverse-0.6.6.tgz";
        sha1 = "cbdf560fd7b9af632502fed40f918c157ea97137";
      })
    ];
    buildInputs =
      (self.nativeDeps."traverse" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "traverse" ];
  };
  "traverse" = self.by-version."traverse"."0.6.6";
  by-spec."truncate"."~1.0.2" =
    self.by-version."truncate"."1.0.4";
  by-version."truncate"."1.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "truncate-1.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/truncate/-/truncate-1.0.4.tgz";
        name = "truncate-1.0.4.tgz";
        sha1 = "2bcfbbff4a97b9089b693c1ae37c5105ec8775aa";
      })
    ];
    buildInputs =
      (self.nativeDeps."truncate" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "truncate" ];
  };
  by-spec."tunnel-agent"."~0.2.0" =
    self.by-version."tunnel-agent"."0.2.0";
  by-version."tunnel-agent"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.2.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.2.0.tgz";
        name = "tunnel-agent-0.2.0.tgz";
        sha1 = "6853c2afb1b2109e45629e492bde35f459ea69e8";
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
  by-spec."type-is"."~1.5.6" =
    self.by-version."type-is"."1.5.6";
  by-version."type-is"."1.5.6" = lib.makeOverridable self.buildNodePackage {
    name = "type-is-1.5.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.5.6.tgz";
        name = "type-is-1.5.6.tgz";
        sha1 = "5be39670ac699b4d0f59df84264cb05be1c9998b";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.0.8" = self.by-version."mime-types"."2.0.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
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
  by-spec."uid-number"."0.0.3" =
    self.by-version."uid-number"."0.0.3";
  by-version."uid-number"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "uid-number-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uid-number/-/uid-number-0.0.3.tgz";
        name = "uid-number-0.0.3.tgz";
        sha1 = "cefb0fa138d8d8098da71a40a0d04a8327d6e1cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."uid-number" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uid-number" ];
  };
  by-spec."underscore"."~1.5.1" =
    self.by-version."underscore"."1.5.2";
  by-version."underscore"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.5.2.tgz";
        name = "underscore-1.5.2.tgz";
        sha1 = "1335c5e4f5e6d33bbb4b006ba8c86a00f556de08";
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
  by-spec."underscore"."~1.6.0" =
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
  by-spec."underscore"."~1.7.0" =
    self.by-version."underscore"."1.7.0";
  by-version."underscore"."1.7.0" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.7.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.7.0.tgz";
        name = "underscore-1.7.0.tgz";
        sha1 = "6bbaf0877500d36be34ecaa584e0db9fef035209";
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
  by-spec."underscore-plus"."1.x" =
    self.by-version."underscore-plus"."1.6.6";
  by-version."underscore-plus"."1.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-plus-1.6.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore-plus/-/underscore-plus-1.6.6.tgz";
        name = "underscore-plus-1.6.6.tgz";
        sha1 = "65ecde1bdc441a35d89e650fd70dcf13ae439a7d";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore-plus" or []);
    deps = {
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore-plus" ];
  };
  by-spec."underscore-plus"."^1.0.0" =
    self.by-version."underscore-plus"."1.6.6";
  by-spec."underscore-plus"."~1.x" =
    self.by-version."underscore-plus"."1.6.6";
  by-spec."underscore.string"."~2.4.0" =
    self.by-version."underscore.string"."2.4.0";
  by-version."underscore.string"."2.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "underscore.string-2.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.4.0.tgz";
        name = "underscore.string-2.4.0.tgz";
        sha1 = "8cdd8fbac4e2d2ea1e7e2e8097c42f442280f85b";
      })
    ];
    buildInputs =
      (self.nativeDeps."underscore.string" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "underscore.string" ];
  };
  by-spec."update-notifier"."^0.3.0" =
    self.by-version."update-notifier"."0.3.0";
  by-version."update-notifier"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "update-notifier-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.3.0.tgz";
        name = "update-notifier-0.3.0.tgz";
        sha1 = "972b1b6def843d546f93736dbed346a7c10230e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."update-notifier" or []);
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "configstore-0.3.2" = self.by-version."configstore"."0.3.2";
      "is-npm-1.0.0" = self.by-version."is-npm"."1.0.0";
      "latest-version-1.0.0" = self.by-version."latest-version"."1.0.0";
      "semver-diff-2.0.0" = self.by-version."semver-diff"."2.0.0";
      "string-length-1.0.0" = self.by-version."string-length"."1.0.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "update-notifier" ];
  };
  "update-notifier" = self.by-version."update-notifier"."0.3.0";
  by-spec."user-home"."^1.0.0" =
    self.by-version."user-home"."1.1.1";
  by-version."user-home"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "user-home-1.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/user-home/-/user-home-1.1.1.tgz";
        name = "user-home-1.1.1.tgz";
        sha1 = "2b5be23a32b63a7c9deb8d0f28d485724a3df190";
      })
    ];
    buildInputs =
      (self.nativeDeps."user-home" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "user-home" ];
  };
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "utils-merge-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
        name = "utils-merge-1.0.0.tgz";
        sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
      })
    ];
    buildInputs =
      (self.nativeDeps."utils-merge" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "utils-merge" ];
  };
  by-spec."uuid"."^2.0.1" =
    self.by-version."uuid"."2.0.1";
  by-version."uuid"."2.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "uuid-2.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uuid/-/uuid-2.0.1.tgz";
        name = "uuid-2.0.1.tgz";
        sha1 = "c2a30dedb3e535d72ccf82e343941a50ba8533ac";
      })
    ];
    buildInputs =
      (self.nativeDeps."uuid" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uuid" ];
  };
  by-spec."v8-debug"."~0.3.0" =
    self.by-version."v8-debug"."0.3.4";
  by-version."v8-debug"."0.3.4" = lib.makeOverridable self.buildNodePackage {
    name = "v8-debug-0.3.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/v8-debug/-/v8-debug-0.3.4.tgz";
        name = "v8-debug-0.3.4.tgz";
        sha1 = "18776b617bc1aad6d49e7bfe610693d6c032286c";
      })
    ];
    buildInputs =
      (self.nativeDeps."v8-debug" or []);
    deps = {
      "node-pre-gyp-0.6.2" = self.by-version."node-pre-gyp"."0.6.2";
      "nan-1.5.3" = self.by-version."nan"."1.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "v8-debug" ];
  };
  by-spec."v8-profiler"."~5.2.0" =
    self.by-version."v8-profiler"."5.2.3";
  by-version."v8-profiler"."5.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "v8-profiler-5.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/v8-profiler/-/v8-profiler-5.2.3.tgz";
        name = "v8-profiler-5.2.3.tgz";
        sha1 = "6030cc6ec3bf8679e27b3cded3713a584799895f";
      })
    ];
    buildInputs =
      (self.nativeDeps."v8-profiler" or []);
    deps = {
      "node-pre-gyp-0.6.2" = self.by-version."node-pre-gyp"."0.6.2";
      "nan-1.5.3" = self.by-version."nan"."1.5.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "v8-profiler" ];
  };
  by-spec."vary"."~1.0.0" =
    self.by-version."vary"."1.0.0";
  by-version."vary"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "vary-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vary/-/vary-1.0.0.tgz";
        name = "vary-1.0.0.tgz";
        sha1 = "c5e76cec20d3820d8f2a96e7bee38731c34da1e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."vary" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "vary" ];
  };
  by-spec."which"."1.0.x" =
    self.by-version."which"."1.0.8";
  by-version."which"."1.0.8" = lib.makeOverridable self.buildNodePackage {
    name = "which-1.0.8";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/which/-/which-1.0.8.tgz";
        name = "which-1.0.8.tgz";
        sha1 = "c2ff319534ac4a1fa45df2221b56c36279903ded";
      })
    ];
    buildInputs =
      (self.nativeDeps."which" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "which" ];
  };
  by-spec."which"."^1.0.5" =
    self.by-version."which"."1.0.8";
  by-spec."winston"."^0.7.3" =
    self.by-version."winston"."0.7.3";
  by-version."winston"."0.7.3" = lib.makeOverridable self.buildNodePackage {
    name = "winston-0.7.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/winston/-/winston-0.7.3.tgz";
        name = "winston-0.7.3.tgz";
        sha1 = "7ae313ba73fcdc2ecb4aa2f9cd446e8298677266";
      })
    ];
    buildInputs =
      (self.nativeDeps."winston" or []);
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "cycle-1.0.3" = self.by-version."cycle"."1.0.3";
      "eyes-0.1.8" = self.by-version."eyes"."0.1.8";
      "pkginfo-0.3.0" = self.by-version."pkginfo"."0.3.0";
      "request-2.16.6" = self.by-version."request"."2.16.6";
      "stack-trace-0.0.9" = self.by-version."stack-trace"."0.0.9";
    };
    peerDependencies = [
    ];
    passthru.names = [ "winston" ];
  };
  "winston" = self.by-version."winston"."0.7.3";
  by-spec."wordwrap"."0.0.x" =
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
  by-spec."ws"."~0.4.31" =
    self.by-version."ws"."0.4.32";
  by-version."ws"."0.4.32" = lib.makeOverridable self.buildNodePackage {
    name = "ws-0.4.32";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ws/-/ws-0.4.32.tgz";
        name = "ws-0.4.32.tgz";
        sha1 = "787a6154414f3c99ed83c5772153b20feb0cec32";
      })
    ];
    buildInputs =
      (self.nativeDeps."ws" or []);
    deps = {
      "commander-2.1.0" = self.by-version."commander"."2.1.0";
      "nan-1.0.0" = self.by-version."nan"."1.0.0";
      "tinycolor-0.0.1" = self.by-version."tinycolor"."0.0.1";
      "options-0.0.6" = self.by-version."options"."0.0.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "ws" ];
  };
  by-spec."xdg-basedir"."^1.0.0" =
    self.by-version."xdg-basedir"."1.0.1";
  by-version."xdg-basedir"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "xdg-basedir-1.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xdg-basedir/-/xdg-basedir-1.0.1.tgz";
        name = "xdg-basedir-1.0.1.tgz";
        sha1 = "14ff8f63a4fdbcb05d5b6eea22b36f3033b9f04e";
      })
    ];
    buildInputs =
      (self.nativeDeps."xdg-basedir" or []);
    deps = {
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "xdg-basedir" ];
  };
  by-spec."xtend"."^3.0.0" =
    self.by-version."xtend"."3.0.0";
  by-version."xtend"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "xtend-3.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/xtend/-/xtend-3.0.0.tgz";
        name = "xtend-3.0.0.tgz";
        sha1 = "5cce7407baf642cba7becda568111c493f59665a";
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
  "xtend" = self.by-version."xtend"."3.0.0";
  by-spec."yargs"."^1.2.1" =
    self.by-version."yargs"."1.3.3";
  by-version."yargs"."1.3.3" = lib.makeOverridable self.buildNodePackage {
    name = "yargs-1.3.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yargs/-/yargs-1.3.3.tgz";
        name = "yargs-1.3.3.tgz";
        sha1 = "054de8b61f22eefdb7207059eaef9d6b83fb931a";
      })
    ];
    buildInputs =
      (self.nativeDeps."yargs" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "yargs" ];
  };
}

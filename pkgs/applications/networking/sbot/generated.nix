{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."JSONStream"."^1.0.3" =
    self.by-version."JSONStream"."1.3.0";
  by-version."JSONStream"."1.3.0" = self.buildNodePackage {
    name = "JSONStream-1.3.0";
    version = "1.3.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/JSONStream/-/JSONStream-1.3.0.tgz";
      name = "JSONStream-1.3.0.tgz";
      sha1 = "680ab9ac6572a8a1a207e0b38721db1c77b215e5";
    };
    deps = {
      "jsonparse-1.2.0" = self.by-version."jsonparse"."1.2.0";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.0.9";
  by-version."abbrev"."1.0.9" = self.buildNodePackage {
    name = "abbrev-1.0.9";
    version = "1.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abbrev/-/abbrev-1.0.9.tgz";
      name = "abbrev-1.0.9.tgz";
      sha1 = "91b4792588a7738c25f35dd6f63752a2f8776135";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abstract-leveldown"."^2.0.3" =
    self.by-version."abstract-leveldown"."2.6.1";
  by-version."abstract-leveldown"."2.6.1" = self.buildNodePackage {
    name = "abstract-leveldown-2.6.1";
    version = "2.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abstract-leveldown/-/abstract-leveldown-2.6.1.tgz";
      name = "abstract-leveldown-2.6.1.tgz";
      sha1 = "f9014a5669b746418e145168dea49a044ae15900";
    };
    deps = {
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abstract-leveldown"."~0.12.0" =
    self.by-version."abstract-leveldown"."0.12.4";
  by-version."abstract-leveldown"."0.12.4" = self.buildNodePackage {
    name = "abstract-leveldown-0.12.4";
    version = "0.12.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abstract-leveldown/-/abstract-leveldown-0.12.4.tgz";
      name = "abstract-leveldown-0.12.4.tgz";
      sha1 = "29e18e632e60e4e221d5810247852a63d7b2e410";
    };
    deps = {
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abstract-leveldown"."~0.12.1" =
    self.by-version."abstract-leveldown"."0.12.4";
  by-spec."abstract-leveldown"."~2.1.2" =
    self.by-version."abstract-leveldown"."2.1.4";
  by-version."abstract-leveldown"."2.1.4" = self.buildNodePackage {
    name = "abstract-leveldown-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abstract-leveldown/-/abstract-leveldown-2.1.4.tgz";
      name = "abstract-leveldown-2.1.4.tgz";
      sha1 = "cbba7797dad64caf4676c81e69ecdcbbcf760ac7";
    };
    deps = {
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abstract-leveldown"."~2.4.0" =
    self.by-version."abstract-leveldown"."2.4.1";
  by-version."abstract-leveldown"."2.4.1" = self.buildNodePackage {
    name = "abstract-leveldown-2.4.1";
    version = "2.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/abstract-leveldown/-/abstract-leveldown-2.4.1.tgz";
      name = "abstract-leveldown-2.4.1.tgz";
      sha1 = "b3bfedb884eb693a12775f0c55e9f0a420ccee64";
    };
    deps = {
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abstract-leveldown"."~2.6.1" =
    self.by-version."abstract-leveldown"."2.6.1";
  by-spec."acorn"."^3.1.0" =
    self.by-version."acorn"."3.3.0";
  by-version."acorn"."3.3.0" = self.buildNodePackage {
    name = "acorn-3.3.0";
    version = "3.3.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/acorn/-/acorn-3.3.0.tgz";
      name = "acorn-3.3.0.tgz";
      sha1 = "45e37fb39e8da3f25baee3ff5369e2bb5f22017a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."after"."~0.8.1" =
    self.by-version."after"."0.8.2";
  by-version."after"."0.8.2" = self.buildNodePackage {
    name = "after-0.8.2";
    version = "0.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/after/-/after-0.8.2.tgz";
      name = "after-0.8.2.tgz";
      sha1 = "fedb394f9f0e02aa9768e702bda23b505fae7e1f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi"."^0.3.0" =
    self.by-version."ansi"."0.3.1";
  by-version."ansi"."0.3.1" = self.buildNodePackage {
    name = "ansi-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi/-/ansi-0.3.1.tgz";
      name = "ansi-0.3.1.tgz";
      sha1 = "0c42d4fb17160d5a9af1e484bace1c66922c1b21";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi"."~0.3.1" =
    self.by-version."ansi"."0.3.1";
  by-spec."ansi-escapes"."^1.0.0" =
    self.by-version."ansi-escapes"."1.4.0";
  by-version."ansi-escapes"."1.4.0" = self.buildNodePackage {
    name = "ansi-escapes-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-escapes/-/ansi-escapes-1.4.0.tgz";
      name = "ansi-escapes-1.4.0.tgz";
      sha1 = "d3a8a83b319aa67793662b13e761c7911422306e";
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
      url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.0.0.tgz";
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
  by-spec."ansi-styles"."^2.2.1" =
    self.by-version."ansi-styles"."2.2.1";
  by-version."ansi-styles"."2.2.1" = self.buildNodePackage {
    name = "ansi-styles-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-styles/-/ansi-styles-2.2.1.tgz";
      name = "ansi-styles-2.2.1.tgz";
      sha1 = "b432dd3358b634cf75e1e4664368240533c1ddbe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."anymatch"."^1.3.0" =
    self.by-version."anymatch"."1.3.0";
  by-version."anymatch"."1.3.0" = self.buildNodePackage {
    name = "anymatch-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/anymatch/-/anymatch-1.3.0.tgz";
      name = "anymatch-1.3.0.tgz";
      sha1 = "a3e52fa39168c825ff57b0248126ce5a8ff95507";
    };
    deps = {
      "arrify-1.0.1" = self.by-version."arrify"."1.0.1";
      "micromatch-2.3.11" = self.by-version."micromatch"."2.3.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aproba"."^1.0.3" =
    self.by-version."aproba"."1.0.4";
  by-version."aproba"."1.0.4" = self.buildNodePackage {
    name = "aproba-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aproba/-/aproba-1.0.4.tgz";
      name = "aproba-1.0.4.tgz";
      sha1 = "2713680775e7614c8ba186c065d4e2e52d1072c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."are-we-there-yet"."~1.1.2" =
    self.by-version."are-we-there-yet"."1.1.2";
  by-version."are-we-there-yet"."1.1.2" = self.buildNodePackage {
    name = "are-we-there-yet-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/are-we-there-yet/-/are-we-there-yet-1.1.2.tgz";
      name = "are-we-there-yet-1.1.2.tgz";
      sha1 = "80e470e95a084794fe1899262c5667c6e88de1b3";
    };
    deps = {
      "delegates-1.0.0" = self.by-version."delegates"."1.0.0";
      "readable-stream-2.2.2" = self.by-version."readable-stream"."2.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arr-diff"."^2.0.0" =
    self.by-version."arr-diff"."2.0.0";
  by-version."arr-diff"."2.0.0" = self.buildNodePackage {
    name = "arr-diff-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arr-diff/-/arr-diff-2.0.0.tgz";
      name = "arr-diff-2.0.0.tgz";
      sha1 = "8f3b827f955a8bd669697e4a4256ac3ceae356cf";
    };
    deps = {
      "arr-flatten-1.0.1" = self.by-version."arr-flatten"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arr-flatten"."^1.0.1" =
    self.by-version."arr-flatten"."1.0.1";
  by-version."arr-flatten"."1.0.1" = self.buildNodePackage {
    name = "arr-flatten-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arr-flatten/-/arr-flatten-1.0.1.tgz";
      name = "arr-flatten-1.0.1.tgz";
      sha1 = "e5ffe54d45e19f32f216e91eb99c8ce892bb604b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-find-index"."^1.0.1" =
    self.by-version."array-find-index"."1.0.2";
  by-version."array-find-index"."1.0.2" = self.buildNodePackage {
    name = "array-find-index-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-find-index/-/array-find-index-1.0.2.tgz";
      name = "array-find-index-1.0.2.tgz";
      sha1 = "df010aa1287e164bbda6f9723b0a96a1ec4187a1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-index"."^1.0.0" =
    self.by-version."array-index"."1.0.0";
  by-version."array-index"."1.0.0" = self.buildNodePackage {
    name = "array-index-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-index/-/array-index-1.0.0.tgz";
      name = "array-index-1.0.0.tgz";
      sha1 = "ec56a749ee103e4e08c790b9c353df16055b97f9";
    };
    deps = {
      "debug-2.6.0" = self.by-version."debug"."2.6.0";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-union"."^1.0.1" =
    self.by-version."array-union"."1.0.2";
  by-version."array-union"."1.0.2" = self.buildNodePackage {
    name = "array-union-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-union/-/array-union-1.0.2.tgz";
      name = "array-union-1.0.2.tgz";
      sha1 = "9a34410e4f4e3da23dea375be5be70f24778ec39";
    };
    deps = {
      "array-uniq-1.0.3" = self.by-version."array-uniq"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-uniq"."^1.0.1" =
    self.by-version."array-uniq"."1.0.3";
  by-version."array-uniq"."1.0.3" = self.buildNodePackage {
    name = "array-uniq-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-uniq/-/array-uniq-1.0.3.tgz";
      name = "array-uniq-1.0.3.tgz";
      sha1 = "af6ac877a25cc7f74e058894753858dfdb24fdb6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-unique"."^0.2.1" =
    self.by-version."array-unique"."0.2.1";
  by-version."array-unique"."0.2.1" = self.buildNodePackage {
    name = "array-unique-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-unique/-/array-unique-0.2.1.tgz";
      name = "array-unique-0.2.1.tgz";
      sha1 = "a1d97ccafcbc2625cc70fadceb36a50c58b01a53";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arraybuffer-base64"."^1.0.0" =
    self.by-version."arraybuffer-base64"."1.0.0";
  by-version."arraybuffer-base64"."1.0.0" = self.buildNodePackage {
    name = "arraybuffer-base64-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arraybuffer-base64/-/arraybuffer-base64-1.0.0.tgz";
      name = "arraybuffer-base64-1.0.0.tgz";
      sha1 = "fd0217ba2ba8d48633663fa43a8093768029da30";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arrify"."^1.0.0" =
    self.by-version."arrify"."1.0.1";
  by-version."arrify"."1.0.1" = self.buildNodePackage {
    name = "arrify-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/arrify/-/arrify-1.0.1.tgz";
      name = "arrify-1.0.1.tgz";
      sha1 = "898508da2226f380df904728456849c1501a4b0d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asn1"."~0.2.3" =
    self.by-version."asn1"."0.2.3";
  by-version."asn1"."0.2.3" = self.buildNodePackage {
    name = "asn1-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/asn1/-/asn1-0.2.3.tgz";
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
  by-spec."assert-plus"."^0.2.0" =
    self.by-version."assert-plus"."0.2.0";
  by-version."assert-plus"."0.2.0" = self.buildNodePackage {
    name = "assert-plus-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/assert-plus/-/assert-plus-0.2.0.tgz";
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
  by-spec."assert-plus"."^1.0.0" =
    self.by-version."assert-plus"."1.0.0";
  by-version."assert-plus"."1.0.0" = self.buildNodePackage {
    name = "assert-plus-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/assert-plus/-/assert-plus-1.0.0.tgz";
      name = "assert-plus-1.0.0.tgz";
      sha1 = "f12e0f3c5d77b0b1cdd9146942e4e96c1e4dd525";
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
      url = "https://registry.npmjs.org/async/-/async-1.5.2.tgz";
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
  by-spec."async"."^2.1.4" =
    self.by-version."async"."2.1.4";
  by-version."async"."2.1.4" = self.buildNodePackage {
    name = "async-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async/-/async-2.1.4.tgz";
      name = "async-2.1.4.tgz";
      sha1 = "2d2160c7788032e4dd6cbe2502f1f9a2c8f6cde4";
    };
    deps = {
      "lodash-4.17.4" = self.by-version."lodash"."4.17.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async-each"."^1.0.0" =
    self.by-version."async-each"."1.0.1";
  by-version."async-each"."1.0.1" = self.buildNodePackage {
    name = "async-each-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/async-each/-/async-each-1.0.1.tgz";
      name = "async-each-1.0.1.tgz";
      sha1 = "19d386a1d9edc6e7c1c85d388aedbcc56d33602d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asynckit"."^0.4.0" =
    self.by-version."asynckit"."0.4.0";
  by-version."asynckit"."0.4.0" = self.buildNodePackage {
    name = "asynckit-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/asynckit/-/asynckit-0.4.0.tgz";
      name = "asynckit-0.4.0.tgz";
      sha1 = "c79ed97f7f34cb8f2ba1bc9790bcc366474b4b79";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."atomic-file"."0.0.1" =
    self.by-version."atomic-file"."0.0.1";
  by-version."atomic-file"."0.0.1" = self.buildNodePackage {
    name = "atomic-file-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/atomic-file/-/atomic-file-0.0.1.tgz";
      name = "atomic-file-0.0.1.tgz";
      sha1 = "6c36658f6c4ece33fba3877731e7c25fc82999bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "atomic-file" = self.by-version."atomic-file"."0.0.1";
  by-spec."attach-ware"."^1.0.0" =
    self.by-version."attach-ware"."1.1.1";
  by-version."attach-ware"."1.1.1" = self.buildNodePackage {
    name = "attach-ware-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/attach-ware/-/attach-ware-1.1.1.tgz";
      name = "attach-ware-1.1.1.tgz";
      sha1 = "28f51393dd8bb8bdaad972342519bf09621a35a3";
    };
    deps = {
      "unherit-1.1.0" = self.by-version."unherit"."1.1.0";
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
      url = "https://registry.npmjs.org/aws-sign2/-/aws-sign2-0.6.0.tgz";
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
    self.by-version."aws4"."1.5.0";
  by-version."aws4"."1.5.0" = self.buildNodePackage {
    name = "aws4-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws4/-/aws4-1.5.0.tgz";
      name = "aws4-1.5.0.tgz";
      sha1 = "0a29ffb79c31c9e712eeb087e8e7a64b4a56d755";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bail"."^1.0.0" =
    self.by-version."bail"."1.0.1";
  by-version."bail"."1.0.1" = self.buildNodePackage {
    name = "bail-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bail/-/bail-1.0.1.tgz";
      name = "bail-1.0.1.tgz";
      sha1 = "912579de8b391aadf3c5fdf4cd2a0fc225df3bc2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."balanced-match"."^0.4.1" =
    self.by-version."balanced-match"."0.4.2";
  by-version."balanced-match"."0.4.2" = self.buildNodePackage {
    name = "balanced-match-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/balanced-match/-/balanced-match-0.4.2.tgz";
      name = "balanced-match-0.4.2.tgz";
      sha1 = "cb3f3e3c732dc0f01ee70b403f302e61d7709838";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64-js"."0.0.2" =
    self.by-version."base64-js"."0.0.2";
  by-version."base64-js"."0.0.2" = self.buildNodePackage {
    name = "base64-js-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/base64-js/-/base64-js-0.0.2.tgz";
      name = "base64-js-0.0.2.tgz";
      sha1 = "024f0f72afa25b75f9c0ee73cd4f55ec1bed9784";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bash-color"."~0.0.3" =
    self.by-version."bash-color"."0.0.4";
  by-version."bash-color"."0.0.4" = self.buildNodePackage {
    name = "bash-color-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bash-color/-/bash-color-0.0.4.tgz";
      name = "bash-color-0.0.4.tgz";
      sha1 = "e9be8ce33540cada4881768c59bd63865736e913";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bash-color" = self.by-version."bash-color"."0.0.4";
  by-spec."bcrypt-pbkdf"."^1.0.0" =
    self.by-version."bcrypt-pbkdf"."1.0.0";
  by-version."bcrypt-pbkdf"."1.0.0" = self.buildNodePackage {
    name = "bcrypt-pbkdf-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.0.tgz";
      name = "bcrypt-pbkdf-1.0.0.tgz";
      sha1 = "3ca76b85241c7170bf7d9703e7b9aa74630040d4";
    };
    deps = {
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."binary-extensions"."^1.0.0" =
    self.by-version."binary-extensions"."1.8.0";
  by-version."binary-extensions"."1.8.0" = self.buildNodePackage {
    name = "binary-extensions-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/binary-extensions/-/binary-extensions-1.8.0.tgz";
      name = "binary-extensions-1.8.0.tgz";
      sha1 = "48ec8d16df4377eae5fa5884682480af4d95c774";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."binary-xhr"."0.0.2" =
    self.by-version."binary-xhr"."0.0.2";
  by-version."binary-xhr"."0.0.2" = self.buildNodePackage {
    name = "binary-xhr-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/binary-xhr/-/binary-xhr-0.0.2.tgz";
      name = "binary-xhr-0.0.2.tgz";
      sha1 = "210cb075ad177aa448a6efa288c10a899c3b3987";
    };
    deps = {
      "inherits-1.0.0" = self.by-version."inherits"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bindings"."~1.2.1" =
    self.by-version."bindings"."1.2.1";
  by-version."bindings"."1.2.1" = self.buildNodePackage {
    name = "bindings-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bindings/-/bindings-1.2.1.tgz";
      name = "bindings-1.2.1.tgz";
      sha1 = "14ad6113812d2d37d72e67b4cacb4bb726505f11";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."^1.0.0" =
    self.by-version."bl"."1.2.0";
  by-version."bl"."1.2.0" = self.buildNodePackage {
    name = "bl-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bl/-/bl-1.2.0.tgz";
      name = "bl-1.2.0.tgz";
      sha1 = "1397e7ec42c5f5dc387470c500e34a9f6be9ea98";
    };
    deps = {
      "readable-stream-2.2.2" = self.by-version."readable-stream"."2.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."~0.8.1" =
    self.by-version."bl"."0.8.2";
  by-version."bl"."0.8.2" = self.buildNodePackage {
    name = "bl-0.8.2";
    version = "0.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bl/-/bl-0.8.2.tgz";
      name = "bl-0.8.2.tgz";
      sha1 = "c9b6bca08d1bc2ea00fc8afb4f1a5fd1e1c66e4e";
    };
    deps = {
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."~1.0.0" =
    self.by-version."bl"."1.0.3";
  by-version."bl"."1.0.3" = self.buildNodePackage {
    name = "bl-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bl/-/bl-1.0.3.tgz";
      name = "bl-1.0.3.tgz";
      sha1 = "fc5421a28fd4226036c3b3891a66a25bc64d226e";
    };
    deps = {
      "readable-stream-2.0.6" = self.by-version."readable-stream"."2.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."blake2s"."~1.0.0" =
    self.by-version."blake2s"."1.0.1";
  by-version."blake2s"."1.0.1" = self.buildNodePackage {
    name = "blake2s-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/blake2s/-/blake2s-1.0.1.tgz";
      name = "blake2s-1.0.1.tgz";
      sha1 = "1598822a320ece6aa401ba982954f82f61b0cd7b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."blake2s"."~1.0.1" =
    self.by-version."blake2s"."1.0.1";
  by-spec."block-stream"."*" =
    self.by-version."block-stream"."0.0.9";
  by-version."block-stream"."0.0.9" = self.buildNodePackage {
    name = "block-stream-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/block-stream/-/block-stream-0.0.9.tgz";
      name = "block-stream-0.0.9.tgz";
      sha1 = "13ebfe778a03205cfe03751481ebb4b3300c126a";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.10.1";
  by-version."boom"."2.10.1" = self.buildNodePackage {
    name = "boom-2.10.1";
    version = "2.10.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/boom/-/boom-2.10.1.tgz";
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
  by-spec."bops"."~0.1.0" =
    self.by-version."bops"."0.1.1";
  by-version."bops"."0.1.1" = self.buildNodePackage {
    name = "bops-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bops/-/bops-0.1.1.tgz";
      name = "bops-0.1.1.tgz";
      sha1 = "062e02a8daa801fa10f2e5dbe6740cff801fe17e";
    };
    deps = {
      "base64-js-0.0.2" = self.by-version."base64-js"."0.0.2";
      "to-utf8-0.0.1" = self.by-version."to-utf8"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.6";
  by-version."brace-expansion"."1.1.6" = self.buildNodePackage {
    name = "brace-expansion-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.6.tgz";
      name = "brace-expansion-1.1.6.tgz";
      sha1 = "7197d7eaa9b87e648390ea61fc66c84427420df9";
    };
    deps = {
      "balanced-match-0.4.2" = self.by-version."balanced-match"."0.4.2";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."braces"."^1.8.2" =
    self.by-version."braces"."1.8.5";
  by-version."braces"."1.8.5" = self.buildNodePackage {
    name = "braces-1.8.5";
    version = "1.8.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/braces/-/braces-1.8.5.tgz";
      name = "braces-1.8.5.tgz";
      sha1 = "ba77962e12dff969d6b76711e914b737857bf6a7";
    };
    deps = {
      "expand-range-1.8.2" = self.by-version."expand-range"."1.8.2";
      "preserve-0.2.0" = self.by-version."preserve"."0.2.0";
      "repeat-element-1.1.2" = self.by-version."repeat-element"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."broadcast-stream"."~0.0.0" =
    self.by-version."broadcast-stream"."0.0.0";
  by-version."broadcast-stream"."0.0.0" = self.buildNodePackage {
    name = "broadcast-stream-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/broadcast-stream/-/broadcast-stream-0.0.0.tgz";
      name = "broadcast-stream-0.0.0.tgz";
      sha1 = "dcb3f0612296fe72096e25fe8665aec99865e1bf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "broadcast-stream" = self.by-version."broadcast-stream"."0.0.0";
  by-spec."browser-resolve"."^1.7.0" =
    self.by-version."browser-resolve"."1.11.2";
  by-version."browser-resolve"."1.11.2" = self.buildNodePackage {
    name = "browser-resolve-1.11.2";
    version = "1.11.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browser-resolve/-/browser-resolve-1.11.2.tgz";
      name = "browser-resolve-1.11.2.tgz";
      sha1 = "8ff09b0a2c421718a1051c260b32e48f442938ce";
    };
    deps = {
      "resolve-1.1.7" = self.by-version."resolve"."1.1.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browser-split"."0.0.0" =
    self.by-version."browser-split"."0.0.0";
  by-version."browser-split"."0.0.0" = self.buildNodePackage {
    name = "browser-split-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/browser-split/-/browser-split-0.0.0.tgz";
      name = "browser-split-0.0.0.tgz";
      sha1 = "41419caef769755929dd518967d3eec0a6262771";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-shims"."^1.0.0" =
    self.by-version."buffer-shims"."1.0.0";
  by-version."buffer-shims"."1.0.0" = self.buildNodePackage {
    name = "buffer-shims-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/buffer-shims/-/buffer-shims-1.0.0.tgz";
      name = "buffer-shims-1.0.0.tgz";
      sha1 = "9978ce317388c649ad8793028c3477ef044a8b51";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."builtin-modules"."^1.0.0" =
    self.by-version."builtin-modules"."1.1.1";
  by-version."builtin-modules"."1.1.1" = self.buildNodePackage {
    name = "builtin-modules-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/builtin-modules/-/builtin-modules-1.1.1.tgz";
      name = "builtin-modules-1.1.1.tgz";
      sha1 = "270f076c5a72c02f5b65a47df94c5fe3a278892f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytewise"."^1.1.0" =
    self.by-version."bytewise"."1.1.0";
  by-version."bytewise"."1.1.0" = self.buildNodePackage {
    name = "bytewise-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytewise/-/bytewise-1.1.0.tgz";
      name = "bytewise-1.1.0.tgz";
      sha1 = "1d13cbff717ae7158094aa881b35d081b387253e";
    };
    deps = {
      "bytewise-core-1.2.3" = self.by-version."bytewise-core"."1.2.3";
      "typewise-1.0.3" = self.by-version."typewise"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytewise"."~0.7.1" =
    self.by-version."bytewise"."0.7.1";
  by-version."bytewise"."0.7.1" = self.buildNodePackage {
    name = "bytewise-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytewise/-/bytewise-0.7.1.tgz";
      name = "bytewise-0.7.1.tgz";
      sha1 = "43a479d763c85256d5467c8fe05a734f4f2eac2e";
    };
    deps = {
      "bops-0.1.1" = self.by-version."bops"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytewise"."~1.1.0" =
    self.by-version."bytewise"."1.1.0";
  by-spec."bytewise-core"."^1.2.2" =
    self.by-version."bytewise-core"."1.2.3";
  by-version."bytewise-core"."1.2.3" = self.buildNodePackage {
    name = "bytewise-core-1.2.3";
    version = "1.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytewise-core/-/bytewise-core-1.2.3.tgz";
      name = "bytewise-core-1.2.3.tgz";
      sha1 = "3fb410c7e91558eb1ab22a82834577aa6bd61d42";
    };
    deps = {
      "typewise-core-1.2.0" = self.by-version."typewise-core"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase"."^2.0.0" =
    self.by-version."camelcase"."2.1.1";
  by-version."camelcase"."2.1.1" = self.buildNodePackage {
    name = "camelcase-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/camelcase/-/camelcase-2.1.1.tgz";
      name = "camelcase-2.1.1.tgz";
      sha1 = "7c1d16d679a1bbe59ca02cacecfb011e201f5a1f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase-keys"."^2.0.0" =
    self.by-version."camelcase-keys"."2.1.0";
  by-version."camelcase-keys"."2.1.0" = self.buildNodePackage {
    name = "camelcase-keys-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/camelcase-keys/-/camelcase-keys-2.1.0.tgz";
      name = "camelcase-keys-2.1.0.tgz";
      sha1 = "308beeaffdf28119051efa1d932213c91b8f92e7";
    };
    deps = {
      "camelcase-2.1.1" = self.by-version."camelcase"."2.1.1";
      "map-obj-1.0.1" = self.by-version."map-obj"."1.0.1";
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
      url = "https://registry.npmjs.org/caseless/-/caseless-0.11.0.tgz";
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
  by-spec."cat-names"."~1.0.2" =
    self.by-version."cat-names"."1.0.2";
  by-version."cat-names"."1.0.2" = self.buildNodePackage {
    name = "cat-names-1.0.2";
    version = "1.0.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/cat-names/-/cat-names-1.0.2.tgz";
      name = "cat-names-1.0.2.tgz";
      sha1 = "6d09d12a65f9db79d706f3ab3cc455ed4f1adadd";
    };
    deps = {
      "meow-3.7.0" = self.by-version."meow"."3.7.0";
      "unique-random-array-1.0.0" = self.by-version."unique-random-array"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cat-names" = self.by-version."cat-names"."1.0.2";
  by-spec."ccount"."^1.0.0" =
    self.by-version."ccount"."1.0.1";
  by-version."ccount"."1.0.1" = self.buildNodePackage {
    name = "ccount-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ccount/-/ccount-1.0.1.tgz";
      name = "ccount-1.0.1.tgz";
      sha1 = "665687945168c218ec77ff61a4155ae00227a96c";
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
    self.by-version."chalk"."1.1.3";
  by-version."chalk"."1.1.3" = self.buildNodePackage {
    name = "chalk-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chalk/-/chalk-1.1.3.tgz";
      name = "chalk-1.1.3.tgz";
      sha1 = "a8115c55e4a702fe4d150abd3872822a7e09fc98";
    };
    deps = {
      "ansi-styles-2.2.1" = self.by-version."ansi-styles"."2.2.1";
      "escape-string-regexp-1.0.5" = self.by-version."escape-string-regexp"."1.0.5";
      "has-ansi-2.0.0" = self.by-version."has-ansi"."2.0.0";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "supports-color-2.0.0" = self.by-version."supports-color"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."^1.1.0" =
    self.by-version."chalk"."1.1.3";
  by-spec."chalk"."^1.1.1" =
    self.by-version."chalk"."1.1.3";
  by-spec."character-entities"."^1.0.0" =
    self.by-version."character-entities"."1.2.0";
  by-version."character-entities"."1.2.0" = self.buildNodePackage {
    name = "character-entities-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/character-entities/-/character-entities-1.2.0.tgz";
      name = "character-entities-1.2.0.tgz";
      sha1 = "a683e2cf75dbe8b171963531364e58e18a1b155f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."character-entities-html4"."^1.0.0" =
    self.by-version."character-entities-html4"."1.1.0";
  by-version."character-entities-html4"."1.1.0" = self.buildNodePackage {
    name = "character-entities-html4-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/character-entities-html4/-/character-entities-html4-1.1.0.tgz";
      name = "character-entities-html4-1.1.0.tgz";
      sha1 = "1ab08551d3ce1fa1df08d00fb9ca1defb147a06c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."character-entities-legacy"."^1.0.0" =
    self.by-version."character-entities-legacy"."1.1.0";
  by-version."character-entities-legacy"."1.1.0" = self.buildNodePackage {
    name = "character-entities-legacy-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/character-entities-legacy/-/character-entities-legacy-1.1.0.tgz";
      name = "character-entities-legacy-1.1.0.tgz";
      sha1 = "b18aad98f6b7bcc646c1e4c81f9f1956376a561a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."character-reference-invalid"."^1.0.0" =
    self.by-version."character-reference-invalid"."1.1.0";
  by-version."character-reference-invalid"."1.1.0" = self.buildNodePackage {
    name = "character-reference-invalid-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/character-reference-invalid/-/character-reference-invalid-1.1.0.tgz";
      name = "character-reference-invalid-1.1.0.tgz";
      sha1 = "dec9ad1dfb9f8d06b4fcdaa2adc3c4fd97af1e68";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chloride"."^2.0.1" =
    self.by-version."chloride"."2.2.4";
  by-version."chloride"."2.2.4" = self.buildNodePackage {
    name = "chloride-2.2.4";
    version = "2.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chloride/-/chloride-2.2.4.tgz";
      name = "chloride-2.2.4.tgz";
      sha1 = "620b141c6ea66cc897de560e3ebb801b6677ca0b";
    };
    deps = {
      "is-electron-2.0.0" = self.by-version."is-electron"."2.0.0";
      "sodium-browserify-1.2.1" = self.by-version."sodium-browserify"."1.2.1";
      "sodium-browserify-tweetnacl-0.2.2" = self.by-version."sodium-browserify-tweetnacl"."0.2.2";
    };
    optionalDependencies = {
      "sodium-prebuilt-1.0.22" = self.by-version."sodium-prebuilt"."1.0.22";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chloride"."^2.1.1" =
    self.by-version."chloride"."2.2.4";
  by-spec."chloride"."^2.2.0" =
    self.by-version."chloride"."2.2.4";
  by-spec."chloride"."^2.2.1" =
    self.by-version."chloride"."2.2.4";
  by-spec."chloride-test"."^1.1.0" =
    self.by-version."chloride-test"."1.1.1";
  by-version."chloride-test"."1.1.1" = self.buildNodePackage {
    name = "chloride-test-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chloride-test/-/chloride-test-1.1.1.tgz";
      name = "chloride-test-1.1.1.tgz";
      sha1 = "9b87a2ccc9ab5982868cddaf9bf373f9b001e4df";
    };
    deps = {
      "json-buffer-2.0.11" = self.by-version."json-buffer"."2.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chokidar"."^1.0.5" =
    self.by-version."chokidar"."1.6.1";
  by-version."chokidar"."1.6.1" = self.buildNodePackage {
    name = "chokidar-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chokidar/-/chokidar-1.6.1.tgz";
      name = "chokidar-1.6.1.tgz";
      sha1 = "2f4447ab5e96e50fb3d789fd90d4c72e0e4c70c2";
    };
    deps = {
      "anymatch-1.3.0" = self.by-version."anymatch"."1.3.0";
      "async-each-1.0.1" = self.by-version."async-each"."1.0.1";
      "glob-parent-2.0.0" = self.by-version."glob-parent"."2.0.0";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "is-binary-path-1.0.1" = self.by-version."is-binary-path"."1.0.1";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
      "readdirp-2.1.0" = self.by-version."readdirp"."2.1.0";
    };
    optionalDependencies = {
      "fsevents-1.0.17" = self.by-version."fsevents"."1.0.17";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."class-list"."~0.1.0" =
    self.by-version."class-list"."0.1.1";
  by-version."class-list"."0.1.1" = self.buildNodePackage {
    name = "class-list-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/class-list/-/class-list-0.1.1.tgz";
      name = "class-list-0.1.1.tgz";
      sha1 = "9b9745192c4179b5da0a0d7633658e3c70d796cb";
    };
    deps = {
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."class-list"."~0.1.1" =
    self.by-version."class-list"."0.1.1";
  by-spec."cli-cursor"."^1.0.2" =
    self.by-version."cli-cursor"."1.0.2";
  by-version."cli-cursor"."1.0.2" = self.buildNodePackage {
    name = "cli-cursor-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cli-cursor/-/cli-cursor-1.0.2.tgz";
      name = "cli-cursor-1.0.2.tgz";
      sha1 = "64da3f7d56a54412e59794bd62dc35295e8f2987";
    };
    deps = {
      "restore-cursor-1.0.1" = self.by-version."restore-cursor"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."co"."3.1.0" =
    self.by-version."co"."3.1.0";
  by-version."co"."3.1.0" = self.buildNodePackage {
    name = "co-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/co/-/co-3.1.0.tgz";
      name = "co-3.1.0.tgz";
      sha1 = "4ea54ea5a08938153185e15210c68d9092bc1b78";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."code-point-at"."^1.0.0" =
    self.by-version."code-point-at"."1.1.0";
  by-version."code-point-at"."1.1.0" = self.buildNodePackage {
    name = "code-point-at-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/code-point-at/-/code-point-at-1.1.0.tgz";
      name = "code-point-at-1.1.0.tgz";
      sha1 = "0d070b4d043a5bea33a2f1a40e2edb3d9a4ccf77";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."collapse-white-space"."^1.0.0" =
    self.by-version."collapse-white-space"."1.0.2";
  by-version."collapse-white-space"."1.0.2" = self.buildNodePackage {
    name = "collapse-white-space-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/collapse-white-space/-/collapse-white-space-1.0.2.tgz";
      name = "collapse-white-space-1.0.2.tgz";
      sha1 = "9c463fb9c6d190d2dcae21a356a01bcae9eeef6d";
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
      url = "https://registry.npmjs.org/combined-stream/-/combined-stream-1.0.5.tgz";
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
  by-spec."commander"."^2.0.0" =
    self.by-version."commander"."2.9.0";
  by-version."commander"."2.9.0" = self.buildNodePackage {
    name = "commander-2.9.0";
    version = "2.9.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/commander/-/commander-2.9.0.tgz";
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
      url = "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz";
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
  by-spec."concat-stream"."^1.0.0" =
    self.by-version."concat-stream"."1.6.0";
  by-version."concat-stream"."1.6.0" = self.buildNodePackage {
    name = "concat-stream-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.6.0.tgz";
      name = "concat-stream-1.6.0.tgz";
      sha1 = "0aac662fd52be78964d5532f694784e70110acf7";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-2.2.2" = self.by-version."readable-stream"."2.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."~1.4.5" =
    self.by-version."concat-stream"."1.4.10";
  by-version."concat-stream"."1.4.10" = self.buildNodePackage {
    name = "concat-stream-1.4.10";
    version = "1.4.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/concat-stream/-/concat-stream-1.4.10.tgz";
      name = "concat-stream-1.4.10.tgz";
      sha1 = "acc3bbf5602cb8cc980c6ac840fa7d8603e3ef36";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."console-control-strings"."^1.0.0" =
    self.by-version."console-control-strings"."1.1.0";
  by-version."console-control-strings"."1.1.0" = self.buildNodePackage {
    name = "console-control-strings-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/console-control-strings/-/console-control-strings-1.1.0.tgz";
      name = "console-control-strings-1.1.0.tgz";
      sha1 = "3d7cf4464db6446ea644bf4b39507f9851008e8e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."console-control-strings"."~1.1.0" =
    self.by-version."console-control-strings"."1.1.0";
  by-spec."cont"."^1.0.3" =
    self.by-version."cont"."1.0.3";
  by-version."cont"."1.0.3" = self.buildNodePackage {
    name = "cont-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cont/-/cont-1.0.3.tgz";
      name = "cont-1.0.3.tgz";
      sha1 = "6874f1e935fca99d048caeaaad9a0aeb020bcce0";
    };
    deps = {
      "continuable-series-1.2.0" = self.by-version."continuable-series"."1.2.0";
      "continuable-1.2.0" = self.by-version."continuable"."1.2.0";
      "continuable-para-1.2.0" = self.by-version."continuable-para"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cont"."~1.0.0" =
    self.by-version."cont"."1.0.3";
  by-spec."cont"."~1.0.1" =
    self.by-version."cont"."1.0.3";
  by-spec."cont"."~1.0.3" =
    self.by-version."cont"."1.0.3";
  "cont" = self.by-version."cont"."1.0.3";
  by-spec."continuable"."~1.1.6" =
    self.by-version."continuable"."1.1.8";
  by-version."continuable"."1.1.8" = self.buildNodePackage {
    name = "continuable-1.1.8";
    version = "1.1.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/continuable/-/continuable-1.1.8.tgz";
      name = "continuable-1.1.8.tgz";
      sha1 = "dc877b474160870ae3bcde87336268ebe50597d5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."continuable"."~1.2.0" =
    self.by-version."continuable"."1.2.0";
  by-version."continuable"."1.2.0" = self.buildNodePackage {
    name = "continuable-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/continuable/-/continuable-1.2.0.tgz";
      name = "continuable-1.2.0.tgz";
      sha1 = "08277468d41136200074ccf87294308d169f25b6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."continuable-hash"."~0.1.4" =
    self.by-version."continuable-hash"."0.1.4";
  by-version."continuable-hash"."0.1.4" = self.buildNodePackage {
    name = "continuable-hash-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/continuable-hash/-/continuable-hash-0.1.4.tgz";
      name = "continuable-hash-0.1.4.tgz";
      sha1 = "81c74d41771d8c92783e1e00e5f11b34d6dfc78c";
    };
    deps = {
      "continuable-1.1.8" = self.by-version."continuable"."1.1.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."continuable-list"."~0.1.5" =
    self.by-version."continuable-list"."0.1.6";
  by-version."continuable-list"."0.1.6" = self.buildNodePackage {
    name = "continuable-list-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/continuable-list/-/continuable-list-0.1.6.tgz";
      name = "continuable-list-0.1.6.tgz";
      sha1 = "87cf06ec580716e10dff95fb0b84c5f0e8acac5f";
    };
    deps = {
      "continuable-1.1.8" = self.by-version."continuable"."1.1.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."continuable-para"."~1.2.0" =
    self.by-version."continuable-para"."1.2.0";
  by-version."continuable-para"."1.2.0" = self.buildNodePackage {
    name = "continuable-para-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/continuable-para/-/continuable-para-1.2.0.tgz";
      name = "continuable-para-1.2.0.tgz";
      sha1 = "445510f649459dd0fc35c872015146122731c583";
    };
    deps = {
      "continuable-hash-0.1.4" = self.by-version."continuable-hash"."0.1.4";
      "continuable-list-0.1.6" = self.by-version."continuable-list"."0.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."continuable-series"."~1.2.0" =
    self.by-version."continuable-series"."1.2.0";
  by-version."continuable-series"."1.2.0" = self.buildNodePackage {
    name = "continuable-series-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/continuable-series/-/continuable-series-1.2.0.tgz";
      name = "continuable-series-1.2.0.tgz";
      sha1 = "3243397ae93a71d655b3026834a51590b958b9e8";
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
      url = "https://registry.npmjs.org/core-util-is/-/core-util-is-1.0.2.tgz";
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
      url = "https://registry.npmjs.org/cryptiles/-/cryptiles-2.0.5.tgz";
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
  by-spec."currently-unhandled"."^0.4.1" =
    self.by-version."currently-unhandled"."0.4.1";
  by-version."currently-unhandled"."0.4.1" = self.buildNodePackage {
    name = "currently-unhandled-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/currently-unhandled/-/currently-unhandled-0.4.1.tgz";
      name = "currently-unhandled-0.4.1.tgz";
      sha1 = "988df33feab191ef799a61369dd76c17adf957ea";
    };
    deps = {
      "array-find-index-1.0.2" = self.by-version."array-find-index"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."d"."^0.1.1" =
    self.by-version."d"."0.1.1";
  by-version."d"."0.1.1" = self.buildNodePackage {
    name = "d-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/d/-/d-0.1.1.tgz";
      name = "d-0.1.1.tgz";
      sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
    };
    deps = {
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."d"."~0.1.1" =
    self.by-version."d"."0.1.1";
  by-spec."dashdash"."^1.12.0" =
    self.by-version."dashdash"."1.14.1";
  by-version."dashdash"."1.14.1" = self.buildNodePackage {
    name = "dashdash-1.14.1";
    version = "1.14.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/dashdash/-/dashdash-1.14.1.tgz";
      name = "dashdash-1.14.1.tgz";
      sha1 = "853cfa0f7cbe2fed5de20326b8dd581035f6e2f0";
    };
    deps = {
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."^2.0.0" =
    self.by-version."debug"."2.6.0";
  by-version."debug"."2.6.0" = self.buildNodePackage {
    name = "debug-2.6.0";
    version = "2.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.6.0.tgz";
      name = "debug-2.6.0.tgz";
      sha1 = "bc596bcabe7617f11d9fa15361eded5608b8499b";
    };
    deps = {
      "ms-0.7.2" = self.by-version."ms"."0.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."^2.2.0" =
    self.by-version."debug"."2.6.0";
  by-spec."debug"."~2.2.0" =
    self.by-version."debug"."2.2.0";
  by-version."debug"."2.2.0" = self.buildNodePackage {
    name = "debug-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.2.0.tgz";
      name = "debug-2.2.0.tgz";
      sha1 = "f87057e995b1a1f6ae6a4960664137bc56f039da";
    };
    deps = {
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."decamelize"."^1.1.2" =
    self.by-version."decamelize"."1.2.0";
  by-version."decamelize"."1.2.0" = self.buildNodePackage {
    name = "decamelize-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/decamelize/-/decamelize-1.2.0.tgz";
      name = "decamelize-1.2.0.tgz";
      sha1 = "f6534d15148269b20352e7bee26f501f9a191290";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-equal"."^1.0.1" =
    self.by-version."deep-equal"."1.0.1";
  by-version."deep-equal"."1.0.1" = self.buildNodePackage {
    name = "deep-equal-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-equal/-/deep-equal-1.0.1.tgz";
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
  by-spec."deep-equal"."~0.2.0" =
    self.by-version."deep-equal"."0.2.2";
  by-version."deep-equal"."0.2.2" = self.buildNodePackage {
    name = "deep-equal-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-equal/-/deep-equal-0.2.2.tgz";
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
  by-spec."deep-equal"."~0.2.1" =
    self.by-version."deep-equal"."0.2.2";
  by-spec."deep-equal"."~1.0.0" =
    self.by-version."deep-equal"."1.0.1";
  "deep-equal" = self.by-version."deep-equal"."1.0.1";
  by-spec."deep-extend"."^0.4.0" =
    self.by-version."deep-extend"."0.4.1";
  by-version."deep-extend"."0.4.1" = self.buildNodePackage {
    name = "deep-extend-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-extend/-/deep-extend-0.4.1.tgz";
      name = "deep-extend-0.4.1.tgz";
      sha1 = "efe4113d08085f4e6f9687759810f807469e2253";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-extend"."~0.2.5" =
    self.by-version."deep-extend"."0.2.11";
  by-version."deep-extend"."0.2.11" = self.buildNodePackage {
    name = "deep-extend-0.2.11";
    version = "0.2.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deep-extend/-/deep-extend-0.2.11.tgz";
      name = "deep-extend-0.2.11.tgz";
      sha1 = "7a16ba69729132340506170494bc83f7076fe08f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-extend"."~0.4.0" =
    self.by-version."deep-extend"."0.4.1";
  by-spec."deferred-leveldown"."~0.2.0" =
    self.by-version."deferred-leveldown"."0.2.0";
  by-version."deferred-leveldown"."0.2.0" = self.buildNodePackage {
    name = "deferred-leveldown-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deferred-leveldown/-/deferred-leveldown-0.2.0.tgz";
      name = "deferred-leveldown-0.2.0.tgz";
      sha1 = "2cef1f111e1c57870d8bbb8af2650e587cd2f5b4";
    };
    deps = {
      "abstract-leveldown-0.12.4" = self.by-version."abstract-leveldown"."0.12.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deferred-leveldown"."~1.0.0" =
    self.by-version."deferred-leveldown"."1.0.0";
  by-version."deferred-leveldown"."1.0.0" = self.buildNodePackage {
    name = "deferred-leveldown-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deferred-leveldown/-/deferred-leveldown-1.0.0.tgz";
      name = "deferred-leveldown-1.0.0.tgz";
      sha1 = "fdd3f47641eaa2847b9a77735ee60df41353addd";
    };
    deps = {
      "abstract-leveldown-2.1.4" = self.by-version."abstract-leveldown"."2.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deferred-leveldown"."~1.2.1" =
    self.by-version."deferred-leveldown"."1.2.1";
  by-version."deferred-leveldown"."1.2.1" = self.buildNodePackage {
    name = "deferred-leveldown-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/deferred-leveldown/-/deferred-leveldown-1.2.1.tgz";
      name = "deferred-leveldown-1.2.1.tgz";
      sha1 = "5d25c3310f5fe909946f6240dc9f90dd109a71ef";
    };
    deps = {
      "abstract-leveldown-2.4.1" = self.by-version."abstract-leveldown"."2.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."defined"."^1.0.0" =
    self.by-version."defined"."1.0.0";
  by-version."defined"."1.0.0" = self.buildNodePackage {
    name = "defined-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/defined/-/defined-1.0.0.tgz";
      name = "defined-1.0.0.tgz";
      sha1 = "c98d9bcef75674188e110969151199e39b1fa693";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."defined"."~0.0.0" =
    self.by-version."defined"."0.0.0";
  by-version."defined"."0.0.0" = self.buildNodePackage {
    name = "defined-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/defined/-/defined-0.0.0.tgz";
      name = "defined-0.0.0.tgz";
      sha1 = "f35eea7d705e933baf13b2f03b3f83d921403b3e";
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
      url = "https://registry.npmjs.org/delayed-stream/-/delayed-stream-1.0.0.tgz";
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
  by-spec."delegates"."^1.0.0" =
    self.by-version."delegates"."1.0.0";
  by-version."delegates"."1.0.0" = self.buildNodePackage {
    name = "delegates-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/delegates/-/delegates-1.0.0.tgz";
      name = "delegates-1.0.0.tgz";
      sha1 = "84c6e159b81904fdca59a0ef44cd870d31250f9a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."detab"."^1.0.0" =
    self.by-version."detab"."1.0.2";
  by-version."detab"."1.0.2" = self.buildNodePackage {
    name = "detab-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/detab/-/detab-1.0.2.tgz";
      name = "detab-1.0.2.tgz";
      sha1 = "01bc2a4abe7bc7cc67c3039808edbae47049a0ee";
    };
    deps = {
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."detective"."^4.0.0" =
    self.by-version."detective"."4.3.2";
  by-version."detective"."4.3.2" = self.buildNodePackage {
    name = "detective-4.3.2";
    version = "4.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/detective/-/detective-4.3.2.tgz";
      name = "detective-4.3.2.tgz";
      sha1 = "77697e2e7947ac3fe7c8e26a6d6f115235afa91c";
    };
    deps = {
      "acorn-3.3.0" = self.by-version."acorn"."3.3.0";
      "defined-1.0.0" = self.by-version."defined"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dog-names"."~1.0.2" =
    self.by-version."dog-names"."1.0.2";
  by-version."dog-names"."1.0.2" = self.buildNodePackage {
    name = "dog-names-1.0.2";
    version = "1.0.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/dog-names/-/dog-names-1.0.2.tgz";
      name = "dog-names-1.0.2.tgz";
      sha1 = "b9da135e4c4096cc73709efbd0af55d3b605bf48";
    };
    deps = {
      "meow-3.7.0" = self.by-version."meow"."3.7.0";
      "unique-random-array-1.0.0" = self.by-version."unique-random-array"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "dog-names" = self.by-version."dog-names"."1.0.2";
  by-spec."duplexer2"."0.0.2" =
    self.by-version."duplexer2"."0.0.2";
  by-version."duplexer2"."0.0.2" = self.buildNodePackage {
    name = "duplexer2-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/duplexer2/-/duplexer2-0.0.2.tgz";
      name = "duplexer2-0.0.2.tgz";
      sha1 = "c614dcf67e2fb14995a91711e5a617e8a60a31db";
    };
    deps = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."duplexer2"."~0.0.2" =
    self.by-version."duplexer2"."0.0.2";
  by-spec."ecc-jsbn"."~0.1.1" =
    self.by-version."ecc-jsbn"."0.1.1";
  by-version."ecc-jsbn"."0.1.1" = self.buildNodePackage {
    name = "ecc-jsbn-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ecc-jsbn/-/ecc-jsbn-0.1.1.tgz";
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
  by-spec."ed2curve"."^0.1.4" =
    self.by-version."ed2curve"."0.1.4";
  by-version."ed2curve"."0.1.4" = self.buildNodePackage {
    name = "ed2curve-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ed2curve/-/ed2curve-0.1.4.tgz";
      name = "ed2curve-0.1.4.tgz";
      sha1 = "94a44248bb87da35db0eff7af0aa576168117f59";
    };
    deps = {
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."elegant-spinner"."^1.0.0" =
    self.by-version."elegant-spinner"."1.0.1";
  by-version."elegant-spinner"."1.0.1" = self.buildNodePackage {
    name = "elegant-spinner-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/elegant-spinner/-/elegant-spinner-1.0.1.tgz";
      name = "elegant-spinner-1.0.1.tgz";
      sha1 = "db043521c95d7e303fd8f345bedc3349cfb0729e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."emoji-named-characters"."~1.0.2" =
    self.by-version."emoji-named-characters"."1.0.2";
  by-version."emoji-named-characters"."1.0.2" = self.buildNodePackage {
    name = "emoji-named-characters-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/emoji-named-characters/-/emoji-named-characters-1.0.2.tgz";
      name = "emoji-named-characters-1.0.2.tgz";
      sha1 = "cdeb36d0e66002c4b9d7bf1dfbc3a199fb7d409b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."emoji-server"."^1.0.0" =
    self.by-version."emoji-server"."1.0.0";
  by-version."emoji-server"."1.0.0" = self.buildNodePackage {
    name = "emoji-server-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/emoji-server/-/emoji-server-1.0.0.tgz";
      name = "emoji-server-1.0.0.tgz";
      sha1 = "d063cfee9af118cc5aeefbc2e9b3dd5085815c63";
    };
    deps = {
      "emoji-named-characters-1.0.2" = self.by-version."emoji-named-characters"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."^1.0.0" =
    self.by-version."end-of-stream"."1.1.0";
  by-version."end-of-stream"."1.1.0" = self.buildNodePackage {
    name = "end-of-stream-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.1.0.tgz";
      name = "end-of-stream-1.1.0.tgz";
      sha1 = "e9353258baa9108965efc41cb0ef8ade2f3cfb07";
    };
    deps = {
      "once-1.3.3" = self.by-version."once"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."^1.1.0" =
    self.by-version."end-of-stream"."1.1.0";
  by-spec."errno"."~0.1.1" =
    self.by-version."errno"."0.1.4";
  by-version."errno"."0.1.4" = self.buildNodePackage {
    name = "errno-0.1.4";
    version = "0.1.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/errno/-/errno-0.1.4.tgz";
      name = "errno-0.1.4.tgz";
      sha1 = "b896e23a9e5e8ba33871fc996abd3635fc9a1c7d";
    };
    deps = {
      "prr-0.0.0" = self.by-version."prr"."0.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."error-ex"."^1.2.0" =
    self.by-version."error-ex"."1.3.0";
  by-version."error-ex"."1.3.0" = self.buildNodePackage {
    name = "error-ex-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/error-ex/-/error-ex-1.3.0.tgz";
      name = "error-ex-1.3.0.tgz";
      sha1 = "e67b43f3e82c96ea3a584ffee0b9fc3325d802d9";
    };
    deps = {
      "is-arrayish-0.2.1" = self.by-version."is-arrayish"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."^0.10.7" =
    self.by-version."es5-ext"."0.10.12";
  by-version."es5-ext"."0.10.12" = self.buildNodePackage {
    name = "es5-ext-0.10.12";
    version = "0.10.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es5-ext/-/es5-ext-0.10.12.tgz";
      name = "es5-ext-0.10.12.tgz";
      sha1 = "aa84641d4db76b62abba5e45fd805ecbab140047";
    };
    deps = {
      "es6-iterator-2.0.0" = self.by-version."es6-iterator"."2.0.0";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."~0.10.11" =
    self.by-version."es5-ext"."0.10.12";
  by-spec."es5-ext"."~0.10.2" =
    self.by-version."es5-ext"."0.10.12";
  by-spec."es6-iterator"."2" =
    self.by-version."es6-iterator"."2.0.0";
  by-version."es6-iterator"."2.0.0" = self.buildNodePackage {
    name = "es6-iterator-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-iterator/-/es6-iterator-2.0.0.tgz";
      name = "es6-iterator-2.0.0.tgz";
      sha1 = "bd968567d61635e33c0b80727613c9cb4b096bac";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
      "es6-symbol-3.1.0" = self.by-version."es6-symbol"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."3" =
    self.by-version."es6-symbol"."3.1.0";
  by-version."es6-symbol"."3.1.0" = self.buildNodePackage {
    name = "es6-symbol-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/es6-symbol/-/es6-symbol-3.1.0.tgz";
      name = "es6-symbol-3.1.0.tgz";
      sha1 = "94481c655e7a7cad82eba832d97d5433496d7ffa";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.12" = self.by-version."es5-ext"."0.10.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."^3.0.2" =
    self.by-version."es6-symbol"."3.1.0";
  by-spec."es6-symbol"."~3.1" =
    self.by-version."es6-symbol"."3.1.0";
  by-spec."escape-string-regexp"."^1.0.2" =
    self.by-version."escape-string-regexp"."1.0.5";
  by-version."escape-string-regexp"."1.0.5" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.5.tgz";
      name = "escape-string-regexp-1.0.5.tgz";
      sha1 = "1b61c0562190a8dff6ae3bb2cf0200ca130b86d4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."execspawn"."^1.0.1" =
    self.by-version."execspawn"."1.0.1";
  by-version."execspawn"."1.0.1" = self.buildNodePackage {
    name = "execspawn-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/execspawn/-/execspawn-1.0.1.tgz";
      name = "execspawn-1.0.1.tgz";
      sha1 = "8286f9dde7cecde7905fbdc04e24f368f23f8da6";
    };
    deps = {
      "util-extend-1.0.3" = self.by-version."util-extend"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."exit-hook"."^1.0.0" =
    self.by-version."exit-hook"."1.1.1";
  by-version."exit-hook"."1.1.1" = self.buildNodePackage {
    name = "exit-hook-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/exit-hook/-/exit-hook-1.1.1.tgz";
      name = "exit-hook-1.1.1.tgz";
      sha1 = "f05ca233b48c05d54fff07765df8507e95c02ff8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-brackets"."^0.1.4" =
    self.by-version."expand-brackets"."0.1.5";
  by-version."expand-brackets"."0.1.5" = self.buildNodePackage {
    name = "expand-brackets-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/expand-brackets/-/expand-brackets-0.1.5.tgz";
      name = "expand-brackets-0.1.5.tgz";
      sha1 = "df07284e342a807cd733ac5af72411e581d1177b";
    };
    deps = {
      "is-posix-bracket-0.1.1" = self.by-version."is-posix-bracket"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-range"."^1.8.1" =
    self.by-version."expand-range"."1.8.2";
  by-version."expand-range"."1.8.2" = self.buildNodePackage {
    name = "expand-range-1.8.2";
    version = "1.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/expand-range/-/expand-range-1.8.2.tgz";
      name = "expand-range-1.8.2.tgz";
      sha1 = "a299effd335fe2721ebae8e257ec79644fc85337";
    };
    deps = {
      "fill-range-2.2.3" = self.by-version."fill-range"."2.2.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-template"."^1.0.0" =
    self.by-version."expand-template"."1.0.3";
  by-version."expand-template"."1.0.3" = self.buildNodePackage {
    name = "expand-template-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/expand-template/-/expand-template-1.0.3.tgz";
      name = "expand-template-1.0.3.tgz";
      sha1 = "6c303323177a62b1b22c070279f7861287b69b1a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."explain-error"."^1.0.1" =
    self.by-version."explain-error"."1.0.3";
  by-version."explain-error"."1.0.3" = self.buildNodePackage {
    name = "explain-error-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/explain-error/-/explain-error-1.0.3.tgz";
      name = "explain-error-1.0.3.tgz";
      sha1 = "f4e2b21152120d94db36d93bef03a5c42bfedce9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."explain-error"."~1.0.1" =
    self.by-version."explain-error"."1.0.3";
  "explain-error" = self.by-version."explain-error"."1.0.3";
  by-spec."extend"."^3.0.0" =
    self.by-version."extend"."3.0.0";
  by-version."extend"."3.0.0" = self.buildNodePackage {
    name = "extend-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extend/-/extend-3.0.0.tgz";
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
  by-spec."extend"."~3.0.0" =
    self.by-version."extend"."3.0.0";
  by-spec."extend.js"."0.0.2" =
    self.by-version."extend.js"."0.0.2";
  by-version."extend.js"."0.0.2" = self.buildNodePackage {
    name = "extend.js-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extend.js/-/extend.js-0.0.2.tgz";
      name = "extend.js-0.0.2.tgz";
      sha1 = "0f9c7a81a1f208b703eb0c3131fe5716ac6ecd15";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extglob"."^0.3.1" =
    self.by-version."extglob"."0.3.2";
  by-version."extglob"."0.3.2" = self.buildNodePackage {
    name = "extglob-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/extglob/-/extglob-0.3.2.tgz";
      name = "extglob-0.3.2.tgz";
      sha1 = "2e18ff3d2f49ab2765cec9023f011daa8d8349a1";
    };
    deps = {
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
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
      url = "https://registry.npmjs.org/extsprintf/-/extsprintf-1.0.2.tgz";
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
  by-spec."fast-future"."~1.0.2" =
    self.by-version."fast-future"."1.0.2";
  by-version."fast-future"."1.0.2" = self.buildNodePackage {
    name = "fast-future-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fast-future/-/fast-future-1.0.2.tgz";
      name = "fast-future-1.0.2.tgz";
      sha1 = "8435a9aaa02d79248d17d704e76259301d99280a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."filename-regex"."^2.0.0" =
    self.by-version."filename-regex"."2.0.0";
  by-version."filename-regex"."2.0.0" = self.buildNodePackage {
    name = "filename-regex-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/filename-regex/-/filename-regex-2.0.0.tgz";
      name = "filename-regex-2.0.0.tgz";
      sha1 = "996e3e80479b98b9897f15a8a58b3d084e926775";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fill-range"."^2.1.0" =
    self.by-version."fill-range"."2.2.3";
  by-version."fill-range"."2.2.3" = self.buildNodePackage {
    name = "fill-range-2.2.3";
    version = "2.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fill-range/-/fill-range-2.2.3.tgz";
      name = "fill-range-2.2.3.tgz";
      sha1 = "50b77dfd7e469bc7492470963699fe7a8485a723";
    };
    deps = {
      "is-number-2.1.0" = self.by-version."is-number"."2.1.0";
      "isobject-2.1.0" = self.by-version."isobject"."2.1.0";
      "randomatic-1.1.6" = self.by-version."randomatic"."1.1.6";
      "repeat-element-1.1.2" = self.by-version."repeat-element"."1.1.2";
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."find-up"."^1.0.0" =
    self.by-version."find-up"."1.1.2";
  by-version."find-up"."1.1.2" = self.buildNodePackage {
    name = "find-up-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/find-up/-/find-up-1.1.2.tgz";
      name = "find-up-1.1.2.tgz";
      sha1 = "6b2e9822b1a2ce0a60ab64d610eccad53cb24d0f";
    };
    deps = {
      "path-exists-2.1.0" = self.by-version."path-exists"."2.1.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."for-in"."^0.1.5" =
    self.by-version."for-in"."0.1.6";
  by-version."for-in"."0.1.6" = self.buildNodePackage {
    name = "for-in-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/for-in/-/for-in-0.1.6.tgz";
      name = "for-in-0.1.6.tgz";
      sha1 = "c9f96e89bfad18a545af5ec3ed352a1d9e5b4dc8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."for-own"."^0.1.4" =
    self.by-version."for-own"."0.1.4";
  by-version."for-own"."0.1.4" = self.buildNodePackage {
    name = "for-own-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/for-own/-/for-own-0.1.4.tgz";
      name = "for-own-0.1.4.tgz";
      sha1 = "0149b41a39088c7515f51ebe1c1386d45f935072";
    };
    deps = {
      "for-in-0.1.6" = self.by-version."for-in"."0.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forever-agent"."~0.6.1" =
    self.by-version."forever-agent"."0.6.1";
  by-version."forever-agent"."0.6.1" = self.buildNodePackage {
    name = "forever-agent-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/forever-agent/-/forever-agent-0.6.1.tgz";
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
  by-spec."form-data"."~2.1.1" =
    self.by-version."form-data"."2.1.2";
  by-version."form-data"."2.1.2" = self.buildNodePackage {
    name = "form-data-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/form-data/-/form-data-2.1.2.tgz";
      name = "form-data-2.1.2.tgz";
      sha1 = "89c3534008b97eada4cbb157d58f6f5df025eae4";
    };
    deps = {
      "asynckit-0.4.0" = self.by-version."asynckit"."0.4.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.13" = self.by-version."mime-types"."2.1.13";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fs.realpath"."^1.0.0" =
    self.by-version."fs.realpath"."1.0.0";
  by-version."fs.realpath"."1.0.0" = self.buildNodePackage {
    name = "fs.realpath-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fs.realpath/-/fs.realpath-1.0.0.tgz";
      name = "fs.realpath-1.0.0.tgz";
      sha1 = "1504ad2523158caa40db4a2787cb01411994ea4f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fsevents"."^1.0.0" =
    self.by-version."fsevents"."1.0.17";
  by-version."fsevents"."1.0.17" = self.buildNodePackage {
    name = "fsevents-1.0.17";
    version = "1.0.17";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fsevents/-/fsevents-1.0.17.tgz";
      name = "fsevents-1.0.17.tgz";
      sha1 = "8537f3f12272678765b4fd6528c0f1f66f8f4558";
    };
    deps = {
      "nan-2.5.0" = self.by-version."nan"."2.5.0";
      "node-pre-gyp-0.6.32" = self.by-version."node-pre-gyp"."0.6.32";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ "darwin" ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.0" =
    self.by-version."fstream"."1.0.10";
  by-version."fstream"."1.0.10" = self.buildNodePackage {
    name = "fstream-1.0.10";
    version = "1.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fstream/-/fstream-1.0.10.tgz";
      name = "fstream-1.0.10.tgz";
      sha1 = "604e8a92fe26ffd9f6fae30399d4984e1ab22822";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "rimraf-2.5.4" = self.by-version."rimraf"."2.5.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.2" =
    self.by-version."fstream"."1.0.10";
  by-spec."fstream"."~1.0.10" =
    self.by-version."fstream"."1.0.10";
  by-spec."fstream-ignore"."~1.0.5" =
    self.by-version."fstream-ignore"."1.0.5";
  by-version."fstream-ignore"."1.0.5" = self.buildNodePackage {
    name = "fstream-ignore-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fstream-ignore/-/fstream-ignore-1.0.5.tgz";
      name = "fstream-ignore-1.0.5.tgz";
      sha1 = "9c31dae34767018fe1d249b24dada67d092da105";
    };
    deps = {
      "fstream-1.0.10" = self.by-version."fstream"."1.0.10";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."function-bind"."^1.0.2" =
    self.by-version."function-bind"."1.1.0";
  by-version."function-bind"."1.1.0" = self.buildNodePackage {
    name = "function-bind-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/function-bind/-/function-bind-1.1.0.tgz";
      name = "function-bind-1.1.0.tgz";
      sha1 = "16176714c801798e4e8f2cf7f7529467bb4a5771";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."functional-red-black-tree"."^1.0.1" =
    self.by-version."functional-red-black-tree"."1.0.1";
  by-version."functional-red-black-tree"."1.0.1" = self.buildNodePackage {
    name = "functional-red-black-tree-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/functional-red-black-tree/-/functional-red-black-tree-1.0.1.tgz";
      name = "functional-red-black-tree-1.0.1.tgz";
      sha1 = "1b0ab3bd553b2a0d6399d29c0e3ea0b252078327";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gauge"."~1.2.5" =
    self.by-version."gauge"."1.2.7";
  by-version."gauge"."1.2.7" = self.buildNodePackage {
    name = "gauge-1.2.7";
    version = "1.2.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/gauge/-/gauge-1.2.7.tgz";
      name = "gauge-1.2.7.tgz";
      sha1 = "e9cec5483d3d4ee0ef44b60a7d99e4935e136d93";
    };
    deps = {
      "ansi-0.3.1" = self.by-version."ansi"."0.3.1";
      "has-unicode-2.0.1" = self.by-version."has-unicode"."2.0.1";
      "lodash.pad-4.5.1" = self.by-version."lodash.pad"."4.5.1";
      "lodash.padend-4.6.1" = self.by-version."lodash.padend"."4.6.1";
      "lodash.padstart-4.6.1" = self.by-version."lodash.padstart"."4.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gauge"."~2.7.1" =
    self.by-version."gauge"."2.7.2";
  by-version."gauge"."2.7.2" = self.buildNodePackage {
    name = "gauge-2.7.2";
    version = "2.7.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/gauge/-/gauge-2.7.2.tgz";
      name = "gauge-2.7.2.tgz";
      sha1 = "15cecc31b02d05345a5d6b0e171cdb3ad2307774";
    };
    deps = {
      "aproba-1.0.4" = self.by-version."aproba"."1.0.4";
      "console-control-strings-1.1.0" = self.by-version."console-control-strings"."1.1.0";
      "supports-color-0.2.0" = self.by-version."supports-color"."0.2.0";
      "has-unicode-2.0.1" = self.by-version."has-unicode"."2.0.1";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "signal-exit-3.0.2" = self.by-version."signal-exit"."3.0.2";
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
      "wide-align-1.1.0" = self.by-version."wide-align"."1.1.0";
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
      url = "https://registry.npmjs.org/generate-function/-/generate-function-2.0.0.tgz";
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
      url = "https://registry.npmjs.org/generate-object-property/-/generate-object-property-1.2.0.tgz";
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
  by-spec."get-stdin"."^4.0.1" =
    self.by-version."get-stdin"."4.0.1";
  by-version."get-stdin"."4.0.1" = self.buildNodePackage {
    name = "get-stdin-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/get-stdin/-/get-stdin-4.0.1.tgz";
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
  by-spec."getpass"."^0.1.1" =
    self.by-version."getpass"."0.1.6";
  by-version."getpass"."0.1.6" = self.buildNodePackage {
    name = "getpass-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/getpass/-/getpass-0.1.6.tgz";
      name = "getpass-0.1.6.tgz";
      sha1 = "283ffd9fc1256840875311c1b60e8c40187110e6";
    };
    deps = {
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ghreleases"."^1.0.2" =
    self.by-version."ghreleases"."1.0.5";
  by-version."ghreleases"."1.0.5" = self.buildNodePackage {
    name = "ghreleases-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ghreleases/-/ghreleases-1.0.5.tgz";
      name = "ghreleases-1.0.5.tgz";
      sha1 = "a20f8194074311e19d84ccba7a6e08c4b434fd80";
    };
    deps = {
      "after-0.8.2" = self.by-version."after"."0.8.2";
      "ghrepos-2.0.0" = self.by-version."ghrepos"."2.0.0";
      "ghutils-3.2.1" = self.by-version."ghutils"."3.2.1";
      "simple-mime-0.1.0" = self.by-version."simple-mime"."0.1.0";
      "url-template-2.0.8" = self.by-version."url-template"."2.0.8";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ghrepos"."~2.0.0" =
    self.by-version."ghrepos"."2.0.0";
  by-version."ghrepos"."2.0.0" = self.buildNodePackage {
    name = "ghrepos-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ghrepos/-/ghrepos-2.0.0.tgz";
      name = "ghrepos-2.0.0.tgz";
      sha1 = "d66eae9d98a3b5398e460d6db7e10a742692e81b";
    };
    deps = {
      "ghutils-3.2.1" = self.by-version."ghutils"."3.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ghutils"."~3.2.0" =
    self.by-version."ghutils"."3.2.1";
  by-version."ghutils"."3.2.1" = self.buildNodePackage {
    name = "ghutils-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ghutils/-/ghutils-3.2.1.tgz";
      name = "ghutils-3.2.1.tgz";
      sha1 = "4fcedffac935fcace06e12a17c6174e2c29ffe4f";
    };
    deps = {
      "jsonist-1.3.0" = self.by-version."jsonist"."1.3.0";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."github-from-package"."0.0.0" =
    self.by-version."github-from-package"."0.0.0";
  by-version."github-from-package"."0.0.0" = self.buildNodePackage {
    name = "github-from-package-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/github-from-package/-/github-from-package-0.0.0.tgz";
      name = "github-from-package-0.0.0.tgz";
      sha1 = "97fb5d96bfde8973313f20e8288ef9a167fa64ce";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."3 || 4 || 5 || 6 || 7" =
    self.by-version."glob"."7.1.1";
  by-version."glob"."7.1.1" = self.buildNodePackage {
    name = "glob-7.1.1";
    version = "7.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-7.1.1.tgz";
      name = "glob-7.1.1.tgz";
      sha1 = "805211df04faaf1c63a3600306cdf5ade50b2ec8";
    };
    deps = {
      "fs.realpath-1.0.0" = self.by-version."fs.realpath"."1.0.0";
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
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
      url = "https://registry.npmjs.org/glob/-/glob-4.5.3.tgz";
      name = "glob-4.5.3.tgz";
      sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
    };
    deps = {
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-2.0.10" = self.by-version."minimatch"."2.0.10";
      "once-1.4.0" = self.by-version."once"."1.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^6.0.1" =
    self.by-version."glob"."6.0.4";
  by-version."glob"."6.0.4" = self.buildNodePackage {
    name = "glob-6.0.4";
    version = "6.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-6.0.4.tgz";
      name = "glob-6.0.4.tgz";
      sha1 = "0f08860f6a155127b2fadd4f9ce24b1aab6e4d22";
    };
    deps = {
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^7.0.3" =
    self.by-version."glob"."7.1.1";
  by-spec."glob"."^7.0.5" =
    self.by-version."glob"."7.1.1";
  by-spec."glob"."~3.2.9" =
    self.by-version."glob"."3.2.11";
  by-version."glob"."3.2.11" = self.buildNodePackage {
    name = "glob-3.2.11";
    version = "3.2.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-3.2.11.tgz";
      name = "glob-3.2.11.tgz";
      sha1 = "4a973f635b9190f715d10987d5c00fd2815ebe3d";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."~5.0.3" =
    self.by-version."glob"."5.0.15";
  by-version."glob"."5.0.15" = self.buildNodePackage {
    name = "glob-5.0.15";
    version = "5.0.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob/-/glob-5.0.15.tgz";
      name = "glob-5.0.15.tgz";
      sha1 = "1bc936b9e02f4a603fcc222ecf7633d30b8b93b1";
    };
    deps = {
      "inflight-1.0.6" = self.by-version."inflight"."1.0.6";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "path-is-absolute-1.0.1" = self.by-version."path-is-absolute"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob-base"."^0.3.0" =
    self.by-version."glob-base"."0.3.0";
  by-version."glob-base"."0.3.0" = self.buildNodePackage {
    name = "glob-base-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob-base/-/glob-base-0.3.0.tgz";
      name = "glob-base-0.3.0.tgz";
      sha1 = "dbb164f6221b1c0b1ccf82aea328b497df0ea3c4";
    };
    deps = {
      "glob-parent-2.0.0" = self.by-version."glob-parent"."2.0.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob-parent"."^2.0.0" =
    self.by-version."glob-parent"."2.0.0";
  by-version."glob-parent"."2.0.0" = self.buildNodePackage {
    name = "glob-parent-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/glob-parent/-/glob-parent-2.0.0.tgz";
      name = "glob-parent-2.0.0.tgz";
      sha1 = "81383d72db054fcccf5336daa902f182f6edbb28";
    };
    deps = {
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."globby"."^4.0.0" =
    self.by-version."globby"."4.1.0";
  by-version."globby"."4.1.0" = self.buildNodePackage {
    name = "globby-4.1.0";
    version = "4.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/globby/-/globby-4.1.0.tgz";
      name = "globby-4.1.0.tgz";
      sha1 = "080f54549ec1b82a6c60e631fc82e1211dbe95f8";
    };
    deps = {
      "array-union-1.0.2" = self.by-version."array-union"."1.0.2";
      "arrify-1.0.1" = self.by-version."arrify"."1.0.1";
      "glob-6.0.4" = self.by-version."glob"."6.0.4";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."^4.1.2" =
    self.by-version."graceful-fs"."4.1.11";
  by-version."graceful-fs"."4.1.11" = self.buildNodePackage {
    name = "graceful-fs-4.1.11";
    version = "4.1.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/graceful-fs/-/graceful-fs-4.1.11.tgz";
      name = "graceful-fs-4.1.11.tgz";
      sha1 = "0e8bdfe4d1ddb8854d64e04ea7c00e2a026e5658";
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
      url = "https://registry.npmjs.org/graceful-readlink/-/graceful-readlink-1.0.1.tgz";
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
  by-spec."graphmitter"."^1.6.3" =
    self.by-version."graphmitter"."1.7.0";
  by-version."graphmitter"."1.7.0" = self.buildNodePackage {
    name = "graphmitter-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/graphmitter/-/graphmitter-1.7.0.tgz";
      name = "graphmitter-1.7.0.tgz";
      sha1 = "84d784effaf50c782363654648d1f79e379baaf5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "graphmitter" = self.by-version."graphmitter"."1.7.0";
  by-spec."har-validator"."~2.0.6" =
    self.by-version."har-validator"."2.0.6";
  by-version."har-validator"."2.0.6" = self.buildNodePackage {
    name = "har-validator-2.0.6";
    version = "2.0.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/har-validator/-/har-validator-2.0.6.tgz";
      name = "har-validator-2.0.6.tgz";
      sha1 = "cdcbc08188265ad119b6a5a7c8ab70eecfb5d27d";
    };
    deps = {
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "is-my-json-valid-2.15.0" = self.by-version."is-my-json-valid"."2.15.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has"."^1.0.1" =
    self.by-version."has"."1.0.1";
  by-version."has"."1.0.1" = self.buildNodePackage {
    name = "has-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has/-/has-1.0.1.tgz";
      name = "has-1.0.1.tgz";
      sha1 = "8461733f538b0837c9361e39a9ab9e9704dc2f28";
    };
    deps = {
      "function-bind-1.1.0" = self.by-version."function-bind"."1.1.0";
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
      url = "https://registry.npmjs.org/has-ansi/-/has-ansi-2.0.0.tgz";
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
  by-spec."has-network"."0.0.0" =
    self.by-version."has-network"."0.0.0";
  by-version."has-network"."0.0.0" = self.buildNodePackage {
    name = "has-network-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has-network/-/has-network-0.0.0.tgz";
      name = "has-network-0.0.0.tgz";
      sha1 = "3423d33806b1622e87001d96b754693c7164765e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "has-network" = self.by-version."has-network"."0.0.0";
  by-spec."has-unicode"."^2.0.0" =
    self.by-version."has-unicode"."2.0.1";
  by-version."has-unicode"."2.0.1" = self.buildNodePackage {
    name = "has-unicode-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/has-unicode/-/has-unicode-2.0.1.tgz";
      name = "has-unicode-2.0.1.tgz";
      sha1 = "e0e6fe6a28cf51138855e086d1691e771de2a8b9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~3.1.3" =
    self.by-version."hawk"."3.1.3";
  by-version."hawk"."3.1.3" = self.buildNodePackage {
    name = "hawk-3.1.3";
    version = "3.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hawk/-/hawk-3.1.3.tgz";
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
  by-spec."he"."^0.5.0" =
    self.by-version."he"."0.5.0";
  by-version."he"."0.5.0" = self.buildNodePackage {
    name = "he-0.5.0";
    version = "0.5.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/he/-/he-0.5.0.tgz";
      name = "he-0.5.0.tgz";
      sha1 = "2c05ffaef90b68e860f3fd2b54ef580989277ee2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hmac"."~1.0.1" =
    self.by-version."hmac"."1.0.1";
  by-version."hmac"."1.0.1" = self.buildNodePackage {
    name = "hmac-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hmac/-/hmac-1.0.1.tgz";
      name = "hmac-1.0.1.tgz";
      sha1 = "16bda6b8ad5ae70848a1b9ec7c6f3577dfb19b24";
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
      url = "https://registry.npmjs.org/hoek/-/hoek-2.16.3.tgz";
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
  by-spec."hoox"."0.0.1" =
    self.by-version."hoox"."0.0.1";
  by-version."hoox"."0.0.1" = self.buildNodePackage {
    name = "hoox-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hoox/-/hoox-0.0.1.tgz";
      name = "hoox-0.0.1.tgz";
      sha1 = "08a74d9272a9cc83ae8e6bbe0303f0ee76432094";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hosted-git-info"."^2.1.4" =
    self.by-version."hosted-git-info"."2.1.5";
  by-version."hosted-git-info"."2.1.5" = self.buildNodePackage {
    name = "hosted-git-info-2.1.5";
    version = "2.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hosted-git-info/-/hosted-git-info-2.1.5.tgz";
      name = "hosted-git-info-2.1.5.tgz";
      sha1 = "0ba81d90da2e25ab34a332e6ec77936e1598118b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."html-element"."~1.3.0" =
    self.by-version."html-element"."1.3.0";
  by-version."html-element"."1.3.0" = self.buildNodePackage {
    name = "html-element-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/html-element/-/html-element-1.3.0.tgz";
      name = "html-element-1.3.0.tgz";
      sha1 = "d75ecb5dae874b1de60a0bf8794bbd1984d0f209";
    };
    deps = {
      "class-list-0.1.1" = self.by-version."class-list"."0.1.1";
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
      url = "https://registry.npmjs.org/http-signature/-/http-signature-1.1.1.tgz";
      name = "http-signature-1.1.1.tgz";
      sha1 = "df72e267066cd0ac67fb76adf8e134a8fbcf91bf";
    };
    deps = {
      "assert-plus-0.2.0" = self.by-version."assert-plus"."0.2.0";
      "jsprim-1.3.1" = self.by-version."jsprim"."1.3.1";
      "sshpk-1.10.1" = self.by-version."sshpk"."1.10.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hyperfile"."^1.1.1" =
    self.by-version."hyperfile"."1.1.1";
  by-version."hyperfile"."1.1.1" = self.buildNodePackage {
    name = "hyperfile-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hyperfile/-/hyperfile-1.1.1.tgz";
      name = "hyperfile-1.1.1.tgz";
      sha1 = "733bc6c668fb9a216008c4f336531f894dbc79f3";
    };
    deps = {
      "hyperscript-1.4.7" = self.by-version."hyperscript"."1.4.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hyperprogress"."^0.1.0" =
    self.by-version."hyperprogress"."0.1.1";
  by-version."hyperprogress"."0.1.1" = self.buildNodePackage {
    name = "hyperprogress-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hyperprogress/-/hyperprogress-0.1.1.tgz";
      name = "hyperprogress-0.1.1.tgz";
      sha1 = "e530c6163aa2b1283eac192192225a762f09c344";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hyperquest"."~1.2.0" =
    self.by-version."hyperquest"."1.2.0";
  by-version."hyperquest"."1.2.0" = self.buildNodePackage {
    name = "hyperquest-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hyperquest/-/hyperquest-1.2.0.tgz";
      name = "hyperquest-1.2.0.tgz";
      sha1 = "39e1fef66888dc7ce0dec6c0dd814f6fc8944ad5";
    };
    deps = {
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "through2-0.6.5" = self.by-version."through2"."0.6.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hyperscript"."^1.4.7" =
    self.by-version."hyperscript"."1.4.7";
  by-version."hyperscript"."1.4.7" = self.buildNodePackage {
    name = "hyperscript-1.4.7";
    version = "1.4.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/hyperscript/-/hyperscript-1.4.7.tgz";
      name = "hyperscript-1.4.7.tgz";
      sha1 = "1f23d880f8436caac25b91a7ac39747b89a72618";
    };
    deps = {
      "class-list-0.1.1" = self.by-version."class-list"."0.1.1";
      "browser-split-0.0.0" = self.by-version."browser-split"."0.0.0";
      "html-element-1.3.0" = self.by-version."html-element"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."idb-wrapper"."~1.4.1" =
    self.by-version."idb-wrapper"."1.4.1";
  by-version."idb-wrapper"."1.4.1" = self.buildNodePackage {
    name = "idb-wrapper-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/idb-wrapper/-/idb-wrapper-1.4.1.tgz";
      name = "idb-wrapper-1.4.1.tgz";
      sha1 = "20ed7727d515d75befd7c380a8b96400c511456c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."increment-buffer"."~1.0.0" =
    self.by-version."increment-buffer"."1.0.1";
  by-version."increment-buffer"."1.0.1" = self.buildNodePackage {
    name = "increment-buffer-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/increment-buffer/-/increment-buffer-1.0.1.tgz";
      name = "increment-buffer-1.0.1.tgz";
      sha1 = "65076d75189d808b39ad13ab5b958e05216f9e0d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."indent-string"."^2.1.0" =
    self.by-version."indent-string"."2.1.0";
  by-version."indent-string"."2.1.0" = self.buildNodePackage {
    name = "indent-string-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/indent-string/-/indent-string-2.1.0.tgz";
      name = "indent-string-2.1.0.tgz";
      sha1 = "8e2d48348742121b4a8218b7a137e9a52049dc80";
    };
    deps = {
      "repeating-2.0.1" = self.by-version."repeating"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."indexof"."0.0.1" =
    self.by-version."indexof"."0.0.1";
  by-version."indexof"."0.0.1" = self.buildNodePackage {
    name = "indexof-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/indexof/-/indexof-0.0.1.tgz";
      name = "indexof-0.0.1.tgz";
      sha1 = "82dc336d232b9062179d05ab3293a66059fd435d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inflight"."^1.0.4" =
    self.by-version."inflight"."1.0.6";
  by-version."inflight"."1.0.6" = self.buildNodePackage {
    name = "inflight-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inflight/-/inflight-1.0.6.tgz";
      name = "inflight-1.0.6.tgz";
      sha1 = "49bd6331d7d02d0c09bc910a1075ba8165b56df9";
    };
    deps = {
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "wrappy-1.0.2" = self.by-version."wrappy"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."1.0.0" =
    self.by-version."inherits"."1.0.0";
  by-version."inherits"."1.0.0" = self.buildNodePackage {
    name = "inherits-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
      name = "inherits-1.0.0.tgz";
      sha1 = "38e1975285bf1f7ba9c84da102bb12771322ac48";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.3";
  by-version."inherits"."2.0.3" = self.buildNodePackage {
    name = "inherits-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/inherits/-/inherits-2.0.3.tgz";
      name = "inherits-2.0.3.tgz";
      sha1 = "633c2c83e3da42a502f52466022480f4208261de";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."^2.0.1" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."^2.0.3" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.3";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.3";
  by-spec."ini"."~1.3.0" =
    self.by-version."ini"."1.3.4";
  by-version."ini"."1.3.4" = self.buildNodePackage {
    name = "ini-1.3.4";
    version = "1.3.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ini/-/ini-1.3.4.tgz";
      name = "ini-1.3.4.tgz";
      sha1 = "0537cb79daf59b59a1a517dff706c86ec039162e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ip"."^0.3.3" =
    self.by-version."ip"."0.3.3";
  by-version."ip"."0.3.3" = self.buildNodePackage {
    name = "ip-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ip/-/ip-0.3.3.tgz";
      name = "ip-0.3.3.tgz";
      sha1 = "8ee8309e92f0b040d287f72efaca1a21702d3fb4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ip" = self.by-version."ip"."0.3.3";
  by-spec."ip"."^1.1.2" =
    self.by-version."ip"."1.1.4";
  by-version."ip"."1.1.4" = self.buildNodePackage {
    name = "ip-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ip/-/ip-1.1.4.tgz";
      name = "ip-1.1.4.tgz";
      sha1 = "de8247ffef940451832550fba284945e6e039bfb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ip"."^1.1.3" =
    self.by-version."ip"."1.1.4";
  by-spec."ip"."~0.3.2" =
    self.by-version."ip"."0.3.3";
  by-spec."irregular-plurals"."^1.0.0" =
    self.by-version."irregular-plurals"."1.2.0";
  by-version."irregular-plurals"."1.2.0" = self.buildNodePackage {
    name = "irregular-plurals-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/irregular-plurals/-/irregular-plurals-1.2.0.tgz";
      name = "irregular-plurals-1.2.0.tgz";
      sha1 = "38f299834ba8c00c30be9c554e137269752ff3ac";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-alphabetical"."^1.0.0" =
    self.by-version."is-alphabetical"."1.0.0";
  by-version."is-alphabetical"."1.0.0" = self.buildNodePackage {
    name = "is-alphabetical-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-alphabetical/-/is-alphabetical-1.0.0.tgz";
      name = "is-alphabetical-1.0.0.tgz";
      sha1 = "e2544c13058255f2144cb757066cd3342a1c8c46";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-alphanumerical"."^1.0.0" =
    self.by-version."is-alphanumerical"."1.0.0";
  by-version."is-alphanumerical"."1.0.0" = self.buildNodePackage {
    name = "is-alphanumerical-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-alphanumerical/-/is-alphanumerical-1.0.0.tgz";
      name = "is-alphanumerical-1.0.0.tgz";
      sha1 = "e06492e719c1bf15dec239e4f1af5f67b4d6e7bf";
    };
    deps = {
      "is-alphabetical-1.0.0" = self.by-version."is-alphabetical"."1.0.0";
      "is-decimal-1.0.0" = self.by-version."is-decimal"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-arrayish"."^0.2.1" =
    self.by-version."is-arrayish"."0.2.1";
  by-version."is-arrayish"."0.2.1" = self.buildNodePackage {
    name = "is-arrayish-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-arrayish/-/is-arrayish-0.2.1.tgz";
      name = "is-arrayish-0.2.1.tgz";
      sha1 = "77c99840527aa8ecb1a8ba697b80645a7a926a9d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-binary-path"."^1.0.0" =
    self.by-version."is-binary-path"."1.0.1";
  by-version."is-binary-path"."1.0.1" = self.buildNodePackage {
    name = "is-binary-path-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-binary-path/-/is-binary-path-1.0.1.tgz";
      name = "is-binary-path-1.0.1.tgz";
      sha1 = "75f16642b480f187a711c814161fd3a4a7655898";
    };
    deps = {
      "binary-extensions-1.8.0" = self.by-version."binary-extensions"."1.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-buffer"."^1.0.2" =
    self.by-version."is-buffer"."1.1.4";
  by-version."is-buffer"."1.1.4" = self.buildNodePackage {
    name = "is-buffer-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.4.tgz";
      name = "is-buffer-1.1.4.tgz";
      sha1 = "cfc86ccd5dc5a52fa80489111c6920c457e2d98b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-builtin-module"."^1.0.0" =
    self.by-version."is-builtin-module"."1.0.0";
  by-version."is-builtin-module"."1.0.0" = self.buildNodePackage {
    name = "is-builtin-module-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-builtin-module/-/is-builtin-module-1.0.0.tgz";
      name = "is-builtin-module-1.0.0.tgz";
      sha1 = "540572d34f7ac3119f8f76c30cbc1b1e037affbe";
    };
    deps = {
      "builtin-modules-1.1.1" = self.by-version."builtin-modules"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-decimal"."^1.0.0" =
    self.by-version."is-decimal"."1.0.0";
  by-version."is-decimal"."1.0.0" = self.buildNodePackage {
    name = "is-decimal-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-decimal/-/is-decimal-1.0.0.tgz";
      name = "is-decimal-1.0.0.tgz";
      sha1 = "940579b6ea63c628080a69e62bda88c8470b4fe0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-dotfile"."^1.0.0" =
    self.by-version."is-dotfile"."1.0.2";
  by-version."is-dotfile"."1.0.2" = self.buildNodePackage {
    name = "is-dotfile-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-dotfile/-/is-dotfile-1.0.2.tgz";
      name = "is-dotfile-1.0.2.tgz";
      sha1 = "2c132383f39199f8edc268ca01b9b007d205cc4d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-electron"."^2.0.0" =
    self.by-version."is-electron"."2.0.0";
  by-version."is-electron"."2.0.0" = self.buildNodePackage {
    name = "is-electron-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-electron/-/is-electron-2.0.0.tgz";
      name = "is-electron-2.0.0.tgz";
      sha1 = "c82d3599640f7df91c84eaaee76bc56713c6ac79";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-equal-shallow"."^0.1.3" =
    self.by-version."is-equal-shallow"."0.1.3";
  by-version."is-equal-shallow"."0.1.3" = self.buildNodePackage {
    name = "is-equal-shallow-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-equal-shallow/-/is-equal-shallow-0.1.3.tgz";
      name = "is-equal-shallow-0.1.3.tgz";
      sha1 = "2238098fc221de0bcfa5d9eac4c45d638aa1c534";
    };
    deps = {
      "is-primitive-2.0.0" = self.by-version."is-primitive"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-extendable"."^0.1.1" =
    self.by-version."is-extendable"."0.1.1";
  by-version."is-extendable"."0.1.1" = self.buildNodePackage {
    name = "is-extendable-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-extendable/-/is-extendable-0.1.1.tgz";
      name = "is-extendable-0.1.1.tgz";
      sha1 = "62b110e289a471418e3ec36a617d472e301dfc89";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-extglob"."^1.0.0" =
    self.by-version."is-extglob"."1.0.0";
  by-version."is-extglob"."1.0.0" = self.buildNodePackage {
    name = "is-extglob-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-extglob/-/is-extglob-1.0.0.tgz";
      name = "is-extglob-1.0.0.tgz";
      sha1 = "ac468177c4943405a092fc8f29760c6ffc6206c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-finite"."^1.0.0" =
    self.by-version."is-finite"."1.0.2";
  by-version."is-finite"."1.0.2" = self.buildNodePackage {
    name = "is-finite-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-finite/-/is-finite-1.0.2.tgz";
      name = "is-finite-1.0.2.tgz";
      sha1 = "cc6677695602be550ef11e8b4aa6305342b6d0aa";
    };
    deps = {
      "number-is-nan-1.0.1" = self.by-version."number-is-nan"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-fullwidth-code-point"."^1.0.0" =
    self.by-version."is-fullwidth-code-point"."1.0.0";
  by-version."is-fullwidth-code-point"."1.0.0" = self.buildNodePackage {
    name = "is-fullwidth-code-point-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-fullwidth-code-point/-/is-fullwidth-code-point-1.0.0.tgz";
      name = "is-fullwidth-code-point-1.0.0.tgz";
      sha1 = "ef9e31386f031a7f0d643af82fde50c457ef00cb";
    };
    deps = {
      "number-is-nan-1.0.1" = self.by-version."number-is-nan"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-glob"."^2.0.0" =
    self.by-version."is-glob"."2.0.1";
  by-version."is-glob"."2.0.1" = self.buildNodePackage {
    name = "is-glob-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-glob/-/is-glob-2.0.1.tgz";
      name = "is-glob-2.0.1.tgz";
      sha1 = "d096f926a3ded5600f3fdfd91198cb0888c2d863";
    };
    deps = {
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-glob"."^2.0.1" =
    self.by-version."is-glob"."2.0.1";
  by-spec."is-hexadecimal"."^1.0.0" =
    self.by-version."is-hexadecimal"."1.0.0";
  by-version."is-hexadecimal"."1.0.0" = self.buildNodePackage {
    name = "is-hexadecimal-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-hexadecimal/-/is-hexadecimal-1.0.0.tgz";
      name = "is-hexadecimal-1.0.0.tgz";
      sha1 = "5c459771d2af9a2e3952781fd54fcb1bcfe4113c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.12.4" =
    self.by-version."is-my-json-valid"."2.15.0";
  by-version."is-my-json-valid"."2.15.0" = self.buildNodePackage {
    name = "is-my-json-valid-2.15.0";
    version = "2.15.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.15.0.tgz";
      name = "is-my-json-valid-2.15.0.tgz";
      sha1 = "936edda3ca3c211fd98f3b2d3e08da43f7b2915b";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.2.0" = self.by-version."generate-object-property"."1.2.0";
      "jsonpointer-4.0.1" = self.by-version."jsonpointer"."4.0.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-number"."^2.0.2" =
    self.by-version."is-number"."2.1.0";
  by-version."is-number"."2.1.0" = self.buildNodePackage {
    name = "is-number-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-number/-/is-number-2.1.0.tgz";
      name = "is-number-2.1.0.tgz";
      sha1 = "01fcbbb393463a548f2f466cce16dece49db908f";
    };
    deps = {
      "kind-of-3.1.0" = self.by-version."kind-of"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-number"."^2.1.0" =
    self.by-version."is-number"."2.1.0";
  by-spec."is-posix-bracket"."^0.1.0" =
    self.by-version."is-posix-bracket"."0.1.1";
  by-version."is-posix-bracket"."0.1.1" = self.buildNodePackage {
    name = "is-posix-bracket-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-posix-bracket/-/is-posix-bracket-0.1.1.tgz";
      name = "is-posix-bracket-0.1.1.tgz";
      sha1 = "3334dc79774368e92f016e6fbc0a88f5cd6e6bc4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-primitive"."^2.0.0" =
    self.by-version."is-primitive"."2.0.0";
  by-version."is-primitive"."2.0.0" = self.buildNodePackage {
    name = "is-primitive-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-primitive/-/is-primitive-2.0.0.tgz";
      name = "is-primitive-2.0.0.tgz";
      sha1 = "207bab91638499c07b2adf240a41a87210034575";
    };
    deps = {
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
      url = "https://registry.npmjs.org/is-property/-/is-property-1.0.2.tgz";
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
      url = "https://registry.npmjs.org/is-typedarray/-/is-typedarray-1.0.0.tgz";
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
  by-spec."is-utf8"."^0.2.0" =
    self.by-version."is-utf8"."0.2.1";
  by-version."is-utf8"."0.2.1" = self.buildNodePackage {
    name = "is-utf8-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-utf8/-/is-utf8-0.2.1.tgz";
      name = "is-utf8-0.2.1.tgz";
      sha1 = "4b0da1442104d1b336340e80797e865cf39f7d72";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-valid-domain"."~0.0.1" =
    self.by-version."is-valid-domain"."0.0.2";
  by-version."is-valid-domain"."0.0.2" = self.buildNodePackage {
    name = "is-valid-domain-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-valid-domain/-/is-valid-domain-0.0.2.tgz";
      name = "is-valid-domain-0.0.2.tgz";
      sha1 = "3e7a9423ff7c3b2fe11663afbd6d3837a251fb77";
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
      url = "https://registry.npmjs.org/isarray/-/isarray-0.0.1.tgz";
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
  by-spec."isarray"."1.0.0" =
    self.by-version."isarray"."1.0.0";
  by-version."isarray"."1.0.0" = self.buildNodePackage {
    name = "isarray-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isarray/-/isarray-1.0.0.tgz";
      name = "isarray-1.0.0.tgz";
      sha1 = "bb935d48582cba168c06834957a54a3e07124f11";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isarray"."~1.0.0" =
    self.by-version."isarray"."1.0.0";
  by-spec."isbuffer"."~0.0.0" =
    self.by-version."isbuffer"."0.0.0";
  by-version."isbuffer"."0.0.0" = self.buildNodePackage {
    name = "isbuffer-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isbuffer/-/isbuffer-0.0.0.tgz";
      name = "isbuffer-0.0.0.tgz";
      sha1 = "38c146d9df528b8bf9b0701c3d43cf12df3fc39b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isexe"."^1.1.1" =
    self.by-version."isexe"."1.1.2";
  by-version."isexe"."1.1.2" = self.buildNodePackage {
    name = "isexe-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isexe/-/isexe-1.1.2.tgz";
      name = "isexe-1.1.2.tgz";
      sha1 = "36f3e22e60750920f5e7241a476a8c6a42275ad0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isobject"."^2.0.0" =
    self.by-version."isobject"."2.1.0";
  by-version."isobject"."2.1.0" = self.buildNodePackage {
    name = "isobject-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isobject/-/isobject-2.1.0.tgz";
      name = "isobject-2.1.0.tgz";
      sha1 = "f065561096a3f1da2ef46272f815c840d87e0c89";
    };
    deps = {
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."isstream"."~0.1.2" =
    self.by-version."isstream"."0.1.2";
  by-version."isstream"."0.1.2" = self.buildNodePackage {
    name = "isstream-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/isstream/-/isstream-0.1.2.tgz";
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
  by-spec."jodid25519"."^1.0.0" =
    self.by-version."jodid25519"."1.0.2";
  by-version."jodid25519"."1.0.2" = self.buildNodePackage {
    name = "jodid25519-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jodid25519/-/jodid25519-1.0.2.tgz";
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
  by-spec."jsbn"."~0.1.0" =
    self.by-version."jsbn"."0.1.0";
  by-version."jsbn"."0.1.0" = self.buildNodePackage {
    name = "jsbn-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsbn/-/jsbn-0.1.0.tgz";
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
  by-spec."json-buffer"."^2.0.11" =
    self.by-version."json-buffer"."2.0.11";
  by-version."json-buffer"."2.0.11" = self.buildNodePackage {
    name = "json-buffer-2.0.11";
    version = "2.0.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-buffer/-/json-buffer-2.0.11.tgz";
      name = "json-buffer-2.0.11.tgz";
      sha1 = "3e441fda3098be8d1e3171ad591bc62a33e2d55f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-schema"."0.2.3" =
    self.by-version."json-schema"."0.2.3";
  by-version."json-schema"."0.2.3" = self.buildNodePackage {
    name = "json-schema-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-schema/-/json-schema-0.2.3.tgz";
      name = "json-schema-0.2.3.tgz";
      sha1 = "b480c892e59a2f05954ce727bd3f2a4e882f9e13";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."json-stringify-safe"."~5.0.0" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-version."json-stringify-safe"."5.0.1" = self.buildNodePackage {
    name = "json-stringify-safe-5.0.1";
    version = "5.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-stringify-safe/-/json-stringify-safe-5.0.1.tgz";
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
  by-spec."json-stringify-safe"."~5.0.1" =
    self.by-version."json-stringify-safe"."5.0.1";
  by-spec."jsonist"."~1.3.0" =
    self.by-version."jsonist"."1.3.0";
  by-version."jsonist"."1.3.0" = self.buildNodePackage {
    name = "jsonist-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonist/-/jsonist-1.3.0.tgz";
      name = "jsonist-1.3.0.tgz";
      sha1 = "c0c74b95ef1c952038619b29efa520b1cc987556";
    };
    deps = {
      "bl-1.0.3" = self.by-version."bl"."1.0.3";
      "hyperquest-1.2.0" = self.by-version."hyperquest"."1.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonparse"."^1.2.0" =
    self.by-version."jsonparse"."1.2.0";
  by-version."jsonparse"."1.2.0" = self.buildNodePackage {
    name = "jsonparse-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonparse/-/jsonparse-1.2.0.tgz";
      name = "jsonparse-1.2.0.tgz";
      sha1 = "5c0c5685107160e72fe7489bddea0b44c2bc67bd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jsonpointer"."^4.0.0" =
    self.by-version."jsonpointer"."4.0.1";
  by-version."jsonpointer"."4.0.1" = self.buildNodePackage {
    name = "jsonpointer-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonpointer/-/jsonpointer-4.0.1.tgz";
      name = "jsonpointer-4.0.1.tgz";
      sha1 = "4fd92cb34e0e9db3c89c8622ecf51f9b978c6cb9";
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
    self.by-version."jsprim"."1.3.1";
  by-version."jsprim"."1.3.1" = self.buildNodePackage {
    name = "jsprim-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsprim/-/jsprim-1.3.1.tgz";
      name = "jsprim-1.3.1.tgz";
      sha1 = "2a7256f70412a29ee3670aaca625994c4dcff252";
    };
    deps = {
      "extsprintf-1.0.2" = self.by-version."extsprintf"."1.0.2";
      "json-schema-0.2.3" = self.by-version."json-schema"."0.2.3";
      "verror-1.3.6" = self.by-version."verror"."1.3.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."kind-of"."^3.0.2" =
    self.by-version."kind-of"."3.1.0";
  by-version."kind-of"."3.1.0" = self.buildNodePackage {
    name = "kind-of-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/kind-of/-/kind-of-3.1.0.tgz";
      name = "kind-of-3.1.0.tgz";
      sha1 = "475d698a5e49ff5e53d14e3e732429dc8bf4cf47";
    };
    deps = {
      "is-buffer-1.1.4" = self.by-version."is-buffer"."1.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level"."^1.4.0" =
    self.by-version."level"."1.5.0";
  by-version."level"."1.5.0" = self.buildNodePackage {
    name = "level-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level/-/level-1.5.0.tgz";
      name = "level-1.5.0.tgz";
      sha1 = "08a6683cf13efe2e6bfe236e2811ace3520c6038";
    };
    deps = {
      "level-packager-1.2.1" = self.by-version."level-packager"."1.2.1";
      "leveldown-1.5.3" = self.by-version."leveldown"."1.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-codec"."~6.0.0" =
    self.by-version."level-codec"."6.0.0";
  by-version."level-codec"."6.0.0" = self.buildNodePackage {
    name = "level-codec-6.0.0";
    version = "6.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-codec/-/level-codec-6.0.0.tgz";
      name = "level-codec-6.0.0.tgz";
      sha1 = "e9a4c2756b274e01cca0f8d74416fd57111f5245";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-codec"."~6.1.0" =
    self.by-version."level-codec"."6.1.0";
  by-version."level-codec"."6.1.0" = self.buildNodePackage {
    name = "level-codec-6.1.0";
    version = "6.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-codec/-/level-codec-6.1.0.tgz";
      name = "level-codec-6.1.0.tgz";
      sha1 = "f5df0a99582f76dac43855151ab6f4e4d0d60045";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-errors"."^1.0.3" =
    self.by-version."level-errors"."1.0.4";
  by-version."level-errors"."1.0.4" = self.buildNodePackage {
    name = "level-errors-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-errors/-/level-errors-1.0.4.tgz";
      name = "level-errors-1.0.4.tgz";
      sha1 = "3585e623974c737a93755492a43c0267cda4425f";
    };
    deps = {
      "errno-0.1.4" = self.by-version."errno"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-errors"."~1.0.3" =
    self.by-version."level-errors"."1.0.4";
  by-spec."level-iterator-stream"."~1.3.0" =
    self.by-version."level-iterator-stream"."1.3.1";
  by-version."level-iterator-stream"."1.3.1" = self.buildNodePackage {
    name = "level-iterator-stream-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-iterator-stream/-/level-iterator-stream-1.3.1.tgz";
      name = "level-iterator-stream-1.3.1.tgz";
      sha1 = "e43b78b1a8143e6fa97a4f485eb8ea530352f2ed";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "level-errors-1.0.4" = self.by-version."level-errors"."1.0.4";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-js"."~2.1.6" =
    self.by-version."level-js"."2.1.6";
  by-version."level-js"."2.1.6" = self.buildNodePackage {
    name = "level-js-2.1.6";
    version = "2.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-js/-/level-js-2.1.6.tgz";
      name = "level-js-2.1.6.tgz";
      sha1 = "4e94f728e5597c623ee6280dbeb5b8699365cb4d";
    };
    deps = {
      "abstract-leveldown-0.12.4" = self.by-version."abstract-leveldown"."0.12.4";
      "idb-wrapper-1.4.1" = self.by-version."idb-wrapper"."1.4.1";
      "isbuffer-0.0.0" = self.by-version."isbuffer"."0.0.0";
      "ltgt-1.2.0" = self.by-version."ltgt"."1.2.0";
      "tape-2.10.3" = self.by-version."tape"."2.10.3";
      "typedarray-to-buffer-1.0.4" = self.by-version."typedarray-to-buffer"."1.0.4";
      "xtend-2.1.2" = self.by-version."xtend"."2.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-live-stream"."~1.4.9" =
    self.by-version."level-live-stream"."1.4.12";
  by-version."level-live-stream"."1.4.12" = self.buildNodePackage {
    name = "level-live-stream-1.4.12";
    version = "1.4.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-live-stream/-/level-live-stream-1.4.12.tgz";
      name = "level-live-stream-1.4.12.tgz";
      sha1 = "f3b8ca8f89fc11cfb2e0fdab64984ececd5a5211";
    };
    deps = {
      "level-sublevel-6.6.1" = self.by-version."level-sublevel"."6.6.1";
      "pull-level-2.0.3" = self.by-version."pull-level"."2.0.3";
      "pull-stream-to-stream-1.2.6" = self.by-version."pull-stream-to-stream"."1.2.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-memview"."~0.0.0" =
    self.by-version."level-memview"."0.0.0";
  by-version."level-memview"."0.0.0" = self.buildNodePackage {
    name = "level-memview-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-memview/-/level-memview-0.0.0.tgz";
      name = "level-memview-0.0.0.tgz";
      sha1 = "46d35373ae34e342cf4a574a5e3514a1d4753a20";
    };
    deps = {
      "level-live-stream-1.4.12" = self.by-version."level-live-stream"."1.4.12";
      "pull-stream-2.26.1" = self.by-version."pull-stream"."2.26.1";
      "pull-level-1.2.0" = self.by-version."pull-level"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "level-memview" = self.by-version."level-memview"."0.0.0";
  by-spec."level-packager"."~1.2.0" =
    self.by-version."level-packager"."1.2.1";
  by-version."level-packager"."1.2.1" = self.buildNodePackage {
    name = "level-packager-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-packager/-/level-packager-1.2.1.tgz";
      name = "level-packager-1.2.1.tgz";
      sha1 = "067fedfd072b7fe3c6bec6080c0cbd4a6b2e11f4";
    };
    deps = {
      "levelup-1.3.3" = self.by-version."levelup"."1.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-peek"."^2.0.1" =
    self.by-version."level-peek"."2.0.2";
  by-version."level-peek"."2.0.2" = self.buildNodePackage {
    name = "level-peek-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-peek/-/level-peek-2.0.2.tgz";
      name = "level-peek-2.0.2.tgz";
      sha1 = "d4cddb7df620f7a47ad5dd85e0f921334523a206";
    };
    deps = {
      "pull-level-2.0.3" = self.by-version."pull-level"."2.0.3";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-post"."~1.0.3" =
    self.by-version."level-post"."1.0.5";
  by-version."level-post"."1.0.5" = self.buildNodePackage {
    name = "level-post-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-post/-/level-post-1.0.5.tgz";
      name = "level-post-1.0.5.tgz";
      sha1 = "2a66390409bf6a1621a444bab6f016444cc9802c";
    };
    deps = {
      "ltgt-2.1.3" = self.by-version."ltgt"."2.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-sublevel"."^6.6.0" =
    self.by-version."level-sublevel"."6.6.1";
  by-version."level-sublevel"."6.6.1" = self.buildNodePackage {
    name = "level-sublevel-6.6.1";
    version = "6.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-sublevel/-/level-sublevel-6.6.1.tgz";
      name = "level-sublevel-6.6.1.tgz";
      sha1 = "f9a77f7521ab70a8f8e92ed56f21a3c7886a4485";
    };
    deps = {
      "bytewise-1.1.0" = self.by-version."bytewise"."1.1.0";
      "levelup-0.19.1" = self.by-version."levelup"."0.19.1";
      "ltgt-2.1.3" = self.by-version."ltgt"."2.1.3";
      "pull-level-2.0.3" = self.by-version."pull-level"."2.0.3";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "typewiselite-1.0.0" = self.by-version."typewiselite"."1.0.0";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."level-sublevel"."^6.6.1" =
    self.by-version."level-sublevel"."6.6.1";
  by-spec."level-sublevel"."~6.3.15" =
    self.by-version."level-sublevel"."6.3.17";
  by-version."level-sublevel"."6.3.17" = self.buildNodePackage {
    name = "level-sublevel-6.3.17";
    version = "6.3.17";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-sublevel/-/level-sublevel-6.3.17.tgz";
      name = "level-sublevel-6.3.17.tgz";
      sha1 = "6d514fe432619199fa300911bfdfa3f98de761cb";
    };
    deps = {
      "pull-stream-2.21.0" = self.by-version."pull-stream"."2.21.0";
      "ltgt-2.0.0" = self.by-version."ltgt"."2.0.0";
      "levelup-0.19.1" = self.by-version."levelup"."0.19.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
      "bytewise-0.7.1" = self.by-version."bytewise"."0.7.1";
      "typewiselite-1.0.0" = self.by-version."typewiselite"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "level-sublevel" = self.by-version."level-sublevel"."6.3.17";
  by-spec."level-test"."^2.0.1" =
    self.by-version."level-test"."2.0.2";
  by-version."level-test"."2.0.2" = self.buildNodePackage {
    name = "level-test-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/level-test/-/level-test-2.0.2.tgz";
      name = "level-test-2.0.2.tgz";
      sha1 = "f654cdd0b6dd099222e5f8f8f532c2f9bcc59cef";
    };
    deps = {
      "level-1.5.0" = self.by-version."level"."1.5.0";
      "level-js-2.1.6" = self.by-version."level-js"."2.1.6";
      "levelup-1.1.1" = self.by-version."levelup"."1.1.1";
      "memdown-1.0.0" = self.by-version."memdown"."1.0.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "osenv-0.1.4" = self.by-version."osenv"."0.1.4";
      "rimraf-2.3.4" = self.by-version."rimraf"."2.3.4";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
      "leveldown-1.5.3" = self.by-version."leveldown"."1.5.3";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "level-test" = self.by-version."level-test"."2.0.2";
  by-spec."leveldown"."^1.2.2" =
    self.by-version."leveldown"."1.5.3";
  by-version."leveldown"."1.5.3" = self.buildNodePackage {
    name = "leveldown-1.5.3";
    version = "1.5.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/leveldown/-/leveldown-1.5.3.tgz";
      name = "leveldown-1.5.3.tgz";
      sha1 = "1f360f9e8cbcfd28f363e8ae380d4341fbef33b0";
    };
    deps = {
      "abstract-leveldown-2.6.1" = self.by-version."abstract-leveldown"."2.6.1";
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "fast-future-1.0.2" = self.by-version."fast-future"."1.0.2";
      "nan-2.4.0" = self.by-version."nan"."2.4.0";
      "prebuild-5.1.2" = self.by-version."prebuild"."5.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."leveldown"."~1.5.0" =
    self.by-version."leveldown"."1.5.3";
  by-spec."levelup"."~0.19.0" =
    self.by-version."levelup"."0.19.1";
  by-version."levelup"."0.19.1" = self.buildNodePackage {
    name = "levelup-0.19.1";
    version = "0.19.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/levelup/-/levelup-0.19.1.tgz";
      name = "levelup-0.19.1.tgz";
      sha1 = "f3a6a7205272c4b5f35e412ff004a03a0aedf50b";
    };
    deps = {
      "bl-0.8.2" = self.by-version."bl"."0.8.2";
      "deferred-leveldown-0.2.0" = self.by-version."deferred-leveldown"."0.2.0";
      "errno-0.1.4" = self.by-version."errno"."0.1.4";
      "prr-0.0.0" = self.by-version."prr"."0.0.0";
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
      "semver-5.1.1" = self.by-version."semver"."5.1.1";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."levelup"."~1.1.1" =
    self.by-version."levelup"."1.1.1";
  by-version."levelup"."1.1.1" = self.buildNodePackage {
    name = "levelup-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/levelup/-/levelup-1.1.1.tgz";
      name = "levelup-1.1.1.tgz";
      sha1 = "a157bb4d9ff57724dcbdd8a02bd8eb1904c3d093";
    };
    deps = {
      "deferred-leveldown-1.0.0" = self.by-version."deferred-leveldown"."1.0.0";
      "level-codec-6.0.0" = self.by-version."level-codec"."6.0.0";
      "level-errors-1.0.4" = self.by-version."level-errors"."1.0.4";
      "level-iterator-stream-1.3.1" = self.by-version."level-iterator-stream"."1.3.1";
      "prr-1.0.1" = self.by-version."prr"."1.0.1";
      "semver-4.3.6" = self.by-version."semver"."4.3.6";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."levelup"."~1.3.0" =
    self.by-version."levelup"."1.3.3";
  by-version."levelup"."1.3.3" = self.buildNodePackage {
    name = "levelup-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/levelup/-/levelup-1.3.3.tgz";
      name = "levelup-1.3.3.tgz";
      sha1 = "bf9db62bdb6188d08eaaa2efcf6cc311916f41fd";
    };
    deps = {
      "deferred-leveldown-1.2.1" = self.by-version."deferred-leveldown"."1.2.1";
      "level-codec-6.1.0" = self.by-version."level-codec"."6.1.0";
      "level-errors-1.0.4" = self.by-version."level-errors"."1.0.4";
      "level-iterator-stream-1.3.1" = self.by-version."level-iterator-stream"."1.3.1";
      "prr-1.0.1" = self.by-version."prr"."1.0.1";
      "semver-5.1.1" = self.by-version."semver"."5.1.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."libsodium"."0.2.12" =
    self.by-version."libsodium"."0.2.12";
  by-version."libsodium"."0.2.12" = self.buildNodePackage {
    name = "libsodium-0.2.12";
    version = "0.2.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/libsodium/-/libsodium-0.2.12.tgz";
      name = "libsodium-0.2.12.tgz";
      sha1 = "83083564dcf089cb82a5035be92ba5d224a2ccde";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."libsodium-wrappers"."^0.2.9" =
    self.by-version."libsodium-wrappers"."0.2.12";
  by-version."libsodium-wrappers"."0.2.12" = self.buildNodePackage {
    name = "libsodium-wrappers-0.2.12";
    version = "0.2.12";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/libsodium-wrappers/-/libsodium-wrappers-0.2.12.tgz";
      name = "libsodium-wrappers-0.2.12.tgz";
      sha1 = "51fb50774b8edc517927b307b812a46c3a467e1e";
    };
    deps = {
      "libsodium-0.2.12" = self.by-version."libsodium"."0.2.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."load-json-file"."^1.0.0" =
    self.by-version."load-json-file"."1.1.0";
  by-version."load-json-file"."1.1.0" = self.buildNodePackage {
    name = "load-json-file-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/load-json-file/-/load-json-file-1.1.0.tgz";
      name = "load-json-file-1.1.0.tgz";
      sha1 = "956905708d58b4bab4c2261b04f59f31c99374c0";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "parse-json-2.2.0" = self.by-version."parse-json"."2.2.0";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
      "strip-bom-2.0.0" = self.by-version."strip-bom"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."^4.14.0" =
    self.by-version."lodash"."4.17.4";
  by-version."lodash"."4.17.4" = self.buildNodePackage {
    name = "lodash-4.17.4";
    version = "4.17.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash/-/lodash-4.17.4.tgz";
      name = "lodash-4.17.4.tgz";
      sha1 = "78203a4d1c328ae1d86dca6460e369b57f4055ae";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.pad"."^4.1.0" =
    self.by-version."lodash.pad"."4.5.1";
  by-version."lodash.pad"."4.5.1" = self.buildNodePackage {
    name = "lodash.pad-4.5.1";
    version = "4.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.pad/-/lodash.pad-4.5.1.tgz";
      name = "lodash.pad-4.5.1.tgz";
      sha1 = "4330949a833a7c8da22cc20f6a26c4d59debba70";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.padend"."^4.1.0" =
    self.by-version."lodash.padend"."4.6.1";
  by-version."lodash.padend"."4.6.1" = self.buildNodePackage {
    name = "lodash.padend-4.6.1";
    version = "4.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.padend/-/lodash.padend-4.6.1.tgz";
      name = "lodash.padend-4.6.1.tgz";
      sha1 = "53ccba047d06e158d311f45da625f4e49e6f166e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.padstart"."^4.1.0" =
    self.by-version."lodash.padstart"."4.6.1";
  by-version."lodash.padstart"."4.6.1" = self.buildNodePackage {
    name = "lodash.padstart-4.6.1";
    version = "4.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lodash.padstart/-/lodash.padstart-4.6.1.tgz";
      name = "lodash.padstart-4.6.1.tgz";
      sha1 = "d2e3eebff0d9d39ad50f5cbd1b52a7bce6bb611b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."log-symbols"."^1.0.2" =
    self.by-version."log-symbols"."1.0.2";
  by-version."log-symbols"."1.0.2" = self.buildNodePackage {
    name = "log-symbols-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/log-symbols/-/log-symbols-1.0.2.tgz";
      name = "log-symbols-1.0.2.tgz";
      sha1 = "376ff7b58ea3086a0f09facc74617eca501e1a18";
    };
    deps = {
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."log-update"."^1.0.1" =
    self.by-version."log-update"."1.0.2";
  by-version."log-update"."1.0.2" = self.buildNodePackage {
    name = "log-update-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/log-update/-/log-update-1.0.2.tgz";
      name = "log-update-1.0.2.tgz";
      sha1 = "19929f64c4093d2d2e7075a1dad8af59c296b8d1";
    };
    deps = {
      "ansi-escapes-1.4.0" = self.by-version."ansi-escapes"."1.4.0";
      "cli-cursor-1.0.2" = self.by-version."cli-cursor"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."longest-streak"."^1.0.0" =
    self.by-version."longest-streak"."1.0.0";
  by-version."longest-streak"."1.0.0" = self.buildNodePackage {
    name = "longest-streak-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/longest-streak/-/longest-streak-1.0.0.tgz";
      name = "longest-streak-1.0.0.tgz";
      sha1 = "d06597c4d4c31b52ccb1f5d8f8fe7148eafd6965";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."looper"."^2.0.0" =
    self.by-version."looper"."2.0.0";
  by-version."looper"."2.0.0" = self.buildNodePackage {
    name = "looper-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/looper/-/looper-2.0.0.tgz";
      name = "looper-2.0.0.tgz";
      sha1 = "66cd0c774af3d4fedac53794f742db56da8f09ec";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."looper"."^3.0.0" =
    self.by-version."looper"."3.0.0";
  by-version."looper"."3.0.0" = self.buildNodePackage {
    name = "looper-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/looper/-/looper-3.0.0.tgz";
      name = "looper-3.0.0.tgz";
      sha1 = "2efa54c3b1cbaba9b94aee2e5914b0be57fbb749";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."looper"."~3.0.0" =
    self.by-version."looper"."3.0.0";
  by-spec."loud-rejection"."^1.0.0" =
    self.by-version."loud-rejection"."1.6.0";
  by-version."loud-rejection"."1.6.0" = self.buildNodePackage {
    name = "loud-rejection-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/loud-rejection/-/loud-rejection-1.6.0.tgz";
      name = "loud-rejection-1.6.0.tgz";
      sha1 = "5b46f80147edee578870f086d04821cf998e551f";
    };
    deps = {
      "currently-unhandled-0.4.1" = self.by-version."currently-unhandled"."0.4.1";
      "signal-exit-3.0.2" = self.by-version."signal-exit"."3.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.7.3";
  by-version."lru-cache"."2.7.3" = self.buildNodePackage {
    name = "lru-cache-2.7.3";
    version = "2.7.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lru-cache/-/lru-cache-2.7.3.tgz";
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
  by-spec."ltgt"."^1.0.1" =
    self.by-version."ltgt"."1.2.0";
  by-version."ltgt"."1.2.0" = self.buildNodePackage {
    name = "ltgt-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ltgt/-/ltgt-1.2.0.tgz";
      name = "ltgt-1.2.0.tgz";
      sha1 = "617707dc39f38294415e66a02f3c2705ac407866";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ltgt"."^2.1.2" =
    self.by-version."ltgt"."2.1.3";
  by-version."ltgt"."2.1.3" = self.buildNodePackage {
    name = "ltgt-2.1.3";
    version = "2.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ltgt/-/ltgt-2.1.3.tgz";
      name = "ltgt-2.1.3.tgz";
      sha1 = "10851a06d9964b971178441c23c9e52698eece34";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ltgt"."~1.0.2" =
    self.by-version."ltgt"."1.0.2";
  by-version."ltgt"."1.0.2" = self.buildNodePackage {
    name = "ltgt-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ltgt/-/ltgt-1.0.2.tgz";
      name = "ltgt-1.0.2.tgz";
      sha1 = "e6817eb29ad204fc0c9e96ef8b0fee98ef6b9aa3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ltgt"."~2.0.0" =
    self.by-version."ltgt"."2.0.0";
  by-version."ltgt"."2.0.0" = self.buildNodePackage {
    name = "ltgt-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ltgt/-/ltgt-2.0.0.tgz";
      name = "ltgt-2.0.0.tgz";
      sha1 = "b40ed1e337caf577c0a963f9cffbc680318009c2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ltgt"."~2.1.1" =
    self.by-version."ltgt"."2.1.3";
  by-spec."map-merge"."^1.1.0" =
    self.by-version."map-merge"."1.1.0";
  by-version."map-merge"."1.1.0" = self.buildNodePackage {
    name = "map-merge-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/map-merge/-/map-merge-1.1.0.tgz";
      name = "map-merge-1.1.0.tgz";
      sha1 = "6a6fc58c95d8aab46c2bdde44d515b6ee06fce34";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."map-obj"."^1.0.0" =
    self.by-version."map-obj"."1.0.1";
  by-version."map-obj"."1.0.1" = self.buildNodePackage {
    name = "map-obj-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz";
      name = "map-obj-1.0.1.tgz";
      sha1 = "d933ceb9205d82bdcf4886f6742bdc2b4dea146d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."map-obj"."^1.0.1" =
    self.by-version."map-obj"."1.0.1";
  by-spec."markdown-table"."^0.4.0" =
    self.by-version."markdown-table"."0.4.0";
  by-version."markdown-table"."0.4.0" = self.buildNodePackage {
    name = "markdown-table-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/markdown-table/-/markdown-table-0.4.0.tgz";
      name = "markdown-table-0.4.0.tgz";
      sha1 = "890c2c1b3bfe83fb00e4129b8e4cfe645270f9d1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mdmanifest"."^1.0.4" =
    self.by-version."mdmanifest"."1.0.8";
  by-version."mdmanifest"."1.0.8" = self.buildNodePackage {
    name = "mdmanifest-1.0.8";
    version = "1.0.8";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/mdmanifest/-/mdmanifest-1.0.8.tgz";
      name = "mdmanifest-1.0.8.tgz";
      sha1 = "c04891883c28c83602e1d06b05a11037e359b4c8";
    };
    deps = {
      "remark-3.2.3" = self.by-version."remark"."3.2.3";
      "remark-html-2.0.2" = self.by-version."remark-html"."2.0.2";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "word-wrap-1.2.0" = self.by-version."word-wrap"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mdmanifest" = self.by-version."mdmanifest"."1.0.8";
  by-spec."memdown"."~1.0.0" =
    self.by-version."memdown"."1.0.0";
  by-version."memdown"."1.0.0" = self.buildNodePackage {
    name = "memdown-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/memdown/-/memdown-1.0.0.tgz";
      name = "memdown-1.0.0.tgz";
      sha1 = "d3d1fe9bd60c39b5e156247890ea5f95fa764eb9";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "ltgt-1.0.2" = self.by-version."ltgt"."1.0.2";
      "functional-red-black-tree-1.0.1" = self.by-version."functional-red-black-tree"."1.0.1";
      "abstract-leveldown-2.6.1" = self.by-version."abstract-leveldown"."2.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."meow"."^3.0.0" =
    self.by-version."meow"."3.7.0";
  by-version."meow"."3.7.0" = self.buildNodePackage {
    name = "meow-3.7.0";
    version = "3.7.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/meow/-/meow-3.7.0.tgz";
      name = "meow-3.7.0.tgz";
      sha1 = "72cb668b425228290abbfa856892587308a801fb";
    };
    deps = {
      "camelcase-keys-2.1.0" = self.by-version."camelcase-keys"."2.1.0";
      "decamelize-1.2.0" = self.by-version."decamelize"."1.2.0";
      "loud-rejection-1.6.0" = self.by-version."loud-rejection"."1.6.0";
      "map-obj-1.0.1" = self.by-version."map-obj"."1.0.1";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "normalize-package-data-2.3.5" = self.by-version."normalize-package-data"."2.3.5";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "read-pkg-up-1.0.1" = self.by-version."read-pkg-up"."1.0.1";
      "redent-1.0.0" = self.by-version."redent"."1.0.0";
      "trim-newlines-1.0.0" = self.by-version."trim-newlines"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."micromatch"."^2.1.5" =
    self.by-version."micromatch"."2.3.11";
  by-version."micromatch"."2.3.11" = self.buildNodePackage {
    name = "micromatch-2.3.11";
    version = "2.3.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/micromatch/-/micromatch-2.3.11.tgz";
      name = "micromatch-2.3.11.tgz";
      sha1 = "86677c97d1720b363431d04d0d15293bd38c1565";
    };
    deps = {
      "arr-diff-2.0.0" = self.by-version."arr-diff"."2.0.0";
      "array-unique-0.2.1" = self.by-version."array-unique"."0.2.1";
      "braces-1.8.5" = self.by-version."braces"."1.8.5";
      "expand-brackets-0.1.5" = self.by-version."expand-brackets"."0.1.5";
      "extglob-0.3.2" = self.by-version."extglob"."0.3.2";
      "filename-regex-2.0.0" = self.by-version."filename-regex"."2.0.0";
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
      "kind-of-3.1.0" = self.by-version."kind-of"."3.1.0";
      "normalize-path-2.0.1" = self.by-version."normalize-path"."2.0.1";
      "object.omit-2.0.1" = self.by-version."object.omit"."2.0.1";
      "parse-glob-3.0.4" = self.by-version."parse-glob"."3.0.4";
      "regex-cache-0.4.3" = self.by-version."regex-cache"."0.4.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.25.0" =
    self.by-version."mime-db"."1.25.0";
  by-version."mime-db"."1.25.0" = self.buildNodePackage {
    name = "mime-db-1.25.0";
    version = "1.25.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.25.0.tgz";
      name = "mime-db-1.25.0.tgz";
      sha1 = "c18dbd7c73a5dbf6f44a024dc0d165a1e7b1c392";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.12" =
    self.by-version."mime-types"."2.1.13";
  by-version."mime-types"."2.1.13" = self.buildNodePackage {
    name = "mime-types-2.1.13";
    version = "2.1.13";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-types/-/mime-types-2.1.13.tgz";
      name = "mime-types-2.1.13.tgz";
      sha1 = "e07aaa9c6c6b9a7ca3012c69003ad25a39e92a88";
    };
    deps = {
      "mime-db-1.25.0" = self.by-version."mime-db"."1.25.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.1.7" =
    self.by-version."mime-types"."2.1.13";
  by-spec."minimatch"."0.3" =
    self.by-version."minimatch"."0.3.0";
  by-version."minimatch"."0.3.0" = self.buildNodePackage {
    name = "minimatch-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz";
      name = "minimatch-0.3.0.tgz";
      sha1 = "275d8edaac4f1bb3326472089e7949c8394699dd";
    };
    deps = {
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."2 || 3" =
    self.by-version."minimatch"."3.0.3";
  by-version."minimatch"."3.0.3" = self.buildNodePackage {
    name = "minimatch-3.0.3";
    version = "3.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-3.0.3.tgz";
      name = "minimatch-3.0.3.tgz";
      sha1 = "2a4e4090b96b2db06a9d7df01055a62a77c9b774";
    };
    deps = {
      "brace-expansion-1.1.6" = self.by-version."brace-expansion"."1.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."3" =
    self.by-version."minimatch"."3.0.3";
  by-spec."minimatch"."^2.0.1" =
    self.by-version."minimatch"."2.0.10";
  by-version."minimatch"."2.0.10" = self.buildNodePackage {
    name = "minimatch-2.0.10";
    version = "2.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimatch/-/minimatch-2.0.10.tgz";
      name = "minimatch-2.0.10.tgz";
      sha1 = "8d087c39c6b38c001b97fca7ce6d0e1e80afbac7";
    };
    deps = {
      "brace-expansion-1.1.6" = self.by-version."brace-expansion"."1.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."^3.0.0" =
    self.by-version."minimatch"."3.0.3";
  by-spec."minimatch"."^3.0.2" =
    self.by-version."minimatch"."3.0.3";
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = self.buildNodePackage {
    name = "minimist-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
      name = "minimist-0.0.8.tgz";
      sha1 = "857fcabfc3397d2625b8228262e86aa7a011b05d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."^1.1.0" =
    self.by-version."minimist"."1.2.0";
  by-version."minimist"."1.2.0" = self.buildNodePackage {
    name = "minimist-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-1.2.0.tgz";
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
  by-spec."minimist"."^1.1.2" =
    self.by-version."minimist"."1.2.0";
  by-spec."minimist"."^1.1.3" =
    self.by-version."minimist"."1.2.0";
  "minimist" = self.by-version."minimist"."1.2.0";
  by-spec."minimist"."^1.2.0" =
    self.by-version."minimist"."1.2.0";
  by-spec."minimist"."~0.0.7" =
    self.by-version."minimist"."0.0.10";
  by-version."minimist"."0.0.10" = self.buildNodePackage {
    name = "minimist-0.0.10";
    version = "0.0.10";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/minimist/-/minimist-0.0.10.tgz";
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
  by-spec."mkdirp".">=0.5 0" =
    self.by-version."mkdirp"."0.5.1";
  by-version."mkdirp"."0.5.1" = self.buildNodePackage {
    name = "mkdirp-0.5.1";
    version = "0.5.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
      name = "mkdirp-0.5.1.tgz";
      sha1 = "30057438eac6cf7f8c4767f38648d6697d75c903";
    };
    deps = {
      "minimist-0.0.8" = self.by-version."minimist"."0.0.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."^0.5.0" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."^0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.5.0" =
    self.by-version."mkdirp"."0.5.1";
  "mkdirp" = self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."module-deps"."^3.9.0" =
    self.by-version."module-deps"."3.9.1";
  by-version."module-deps"."3.9.1" = self.buildNodePackage {
    name = "module-deps-3.9.1";
    version = "3.9.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/module-deps/-/module-deps-3.9.1.tgz";
      name = "module-deps-3.9.1.tgz";
      sha1 = "ea75caf9199090d25b0d5512b5acacb96e7f87f3";
    };
    deps = {
      "JSONStream-1.3.0" = self.by-version."JSONStream"."1.3.0";
      "browser-resolve-1.11.2" = self.by-version."browser-resolve"."1.11.2";
      "concat-stream-1.4.10" = self.by-version."concat-stream"."1.4.10";
      "defined-1.0.0" = self.by-version."defined"."1.0.0";
      "detective-4.3.2" = self.by-version."detective"."4.3.2";
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "parents-1.0.1" = self.by-version."parents"."1.0.1";
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "resolve-1.2.0" = self.by-version."resolve"."1.2.0";
      "stream-combiner2-1.0.2" = self.by-version."stream-combiner2"."1.0.2";
      "subarg-1.0.0" = self.by-version."subarg"."1.0.0";
      "through2-1.1.1" = self.by-version."through2"."1.1.1";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."monotonic-timestamp"."~0.0.8" =
    self.by-version."monotonic-timestamp"."0.0.9";
  by-version."monotonic-timestamp"."0.0.9" = self.buildNodePackage {
    name = "monotonic-timestamp-0.0.9";
    version = "0.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/monotonic-timestamp/-/monotonic-timestamp-0.0.9.tgz";
      name = "monotonic-timestamp-0.0.9.tgz";
      sha1 = "5ba5adc7aac85e1d7ce77be847161ed246b39603";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."monotonic-timestamp"."~0.0.9" =
    self.by-version."monotonic-timestamp"."0.0.9";
  by-spec."ms"."0.7.1" =
    self.by-version."ms"."0.7.1";
  by-version."ms"."0.7.1" = self.buildNodePackage {
    name = "ms-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ms/-/ms-0.7.1.tgz";
      name = "ms-0.7.1.tgz";
      sha1 = "9cd13c03adbff25b65effde7ce864ee952017098";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ms"."0.7.2" =
    self.by-version."ms"."0.7.2";
  by-version."ms"."0.7.2" = self.buildNodePackage {
    name = "ms-0.7.2";
    version = "0.7.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ms/-/ms-0.7.2.tgz";
      name = "ms-0.7.2.tgz";
      sha1 = "ae25cf2512b3885a1d95d7f037868d8431124765";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."multiblob"."^1.10.0" =
    self.by-version."multiblob"."1.10.2";
  by-version."multiblob"."1.10.2" = self.buildNodePackage {
    name = "multiblob-1.10.2";
    version = "1.10.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/multiblob/-/multiblob-1.10.2.tgz";
      name = "multiblob-1.10.2.tgz";
      sha1 = "4c47a1e4e90c3cbae95bbce0631ba67204676b3d";
    };
    deps = {
      "blake2s-1.0.1" = self.by-version."blake2s"."1.0.1";
      "cont-1.0.3" = self.by-version."cont"."1.0.3";
      "explain-error-1.0.3" = self.by-version."explain-error"."1.0.3";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-defer-0.2.2" = self.by-version."pull-defer"."0.2.2";
      "pull-file-0.5.0" = self.by-version."pull-file"."0.5.0";
      "pull-glob-1.0.6" = self.by-version."pull-glob"."1.0.6";
      "pull-live-1.0.1" = self.by-version."pull-live"."1.0.1";
      "pull-notify-0.0.2" = self.by-version."pull-notify"."0.0.2";
      "pull-paramap-1.2.1" = self.by-version."pull-paramap"."1.2.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-write-file-0.2.4" = self.by-version."pull-write-file"."0.2.4";
      "rc-0.5.5" = self.by-version."rc"."0.5.5";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."multiblob"."^1.10.1" =
    self.by-version."multiblob"."1.10.2";
  "multiblob" = self.by-version."multiblob"."1.10.2";
  by-spec."multiblob-http"."^0.2.0" =
    self.by-version."multiblob-http"."0.2.0";
  by-version."multiblob-http"."0.2.0" = self.buildNodePackage {
    name = "multiblob-http-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/multiblob-http/-/multiblob-http-0.2.0.tgz";
      name = "multiblob-http-0.2.0.tgz";
      sha1 = "09c820eda9b83f6b98bce884b75846926e6be151";
    };
    deps = {
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."multicb"."^1.0.0" =
    self.by-version."multicb"."1.2.1";
  by-version."multicb"."1.2.1" = self.buildNodePackage {
    name = "multicb-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/multicb/-/multicb-1.2.1.tgz";
      name = "multicb-1.2.1.tgz";
      sha1 = "e2499df476a7f8f8d52ded265d13b2c1a69d9827";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "multicb" = self.by-version."multicb"."1.2.1";
  by-spec."multiserver"."^1.2.0" =
    self.by-version."multiserver"."1.7.6";
  by-version."multiserver"."1.7.6" = self.buildNodePackage {
    name = "multiserver-1.7.6";
    version = "1.7.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/multiserver/-/multiserver-1.7.6.tgz";
      name = "multiserver-1.7.6.tgz";
      sha1 = "77f9ecb20c86ff4269cdc16e22f0824224c5ad25";
    };
    deps = {
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-ws-3.2.8" = self.by-version."pull-ws"."3.2.8";
      "secret-handshake-1.1.1" = self.by-version."secret-handshake"."1.1.1";
      "separator-escape-0.0.0" = self.by-version."separator-escape"."0.0.0";
      "socks-1.1.9" = self.by-version."socks"."1.1.9";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."multiserver"."^1.7.0" =
    self.by-version."multiserver"."1.7.6";
  by-spec."multiserver"."^1.7.2" =
    self.by-version."multiserver"."1.7.6";
  by-spec."muxrpc"."^6.1.1" =
    self.by-version."muxrpc"."6.3.3";
  by-version."muxrpc"."6.3.3" = self.buildNodePackage {
    name = "muxrpc-6.3.3";
    version = "6.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/muxrpc/-/muxrpc-6.3.3.tgz";
      name = "muxrpc-6.3.3.tgz";
      sha1 = "68ad940ef7f601df9da9ef2211b0a173d5286f9d";
    };
    deps = {
      "explain-error-1.0.3" = self.by-version."explain-error"."1.0.3";
      "packet-stream-2.0.0" = self.by-version."packet-stream"."2.0.0";
      "packet-stream-codec-1.1.1" = self.by-version."packet-stream-codec"."1.1.1";
      "pull-goodbye-0.0.1" = self.by-version."pull-goodbye"."0.0.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "muxrpc" = self.by-version."muxrpc"."6.3.3";
  by-spec."muxrpc"."^6.2.2" =
    self.by-version."muxrpc"."6.3.3";
  by-spec."muxrpc"."^6.3.3" =
    self.by-version."muxrpc"."6.3.3";
  by-spec."muxrpc-validation"."^2.0.0" =
    self.by-version."muxrpc-validation"."2.0.1";
  by-version."muxrpc-validation"."2.0.1" = self.buildNodePackage {
    name = "muxrpc-validation-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/muxrpc-validation/-/muxrpc-validation-2.0.1.tgz";
      name = "muxrpc-validation-2.0.1.tgz";
      sha1 = "cd650d172025fe9d064230aab38ca6328dd16f2f";
    };
    deps = {
      "pull-stream-2.28.4" = self.by-version."pull-stream"."2.28.4";
      "zerr-1.0.4" = self.by-version."zerr"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "muxrpc-validation" = self.by-version."muxrpc-validation"."2.0.1";
  by-spec."muxrpcli"."^1.0.0" =
    self.by-version."muxrpcli"."1.1.0";
  by-version."muxrpcli"."1.1.0" = self.buildNodePackage {
    name = "muxrpcli-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/muxrpcli/-/muxrpcli-1.1.0.tgz";
      name = "muxrpcli-1.1.0.tgz";
      sha1 = "4ae9ba986ab825c4a5c12fcb71c6daa81eab5158";
    };
    deps = {
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "pull-stream-2.28.4" = self.by-version."pull-stream"."2.28.4";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
      "word-wrap-1.2.0" = self.by-version."word-wrap"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "muxrpcli" = self.by-version."muxrpcli"."1.1.0";
  by-spec."mv"."^2.1.1" =
    self.by-version."mv"."2.1.1";
  by-version."mv"."2.1.1" = self.buildNodePackage {
    name = "mv-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mv/-/mv-2.1.1.tgz";
      name = "mv-2.1.1.tgz";
      sha1 = "ae6ce0d6f6d5e0a4f7d893798d03c1ea9559b6a2";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "ncp-2.0.0" = self.by-version."ncp"."2.0.0";
      "rimraf-2.4.5" = self.by-version."rimraf"."2.4.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mv" = self.by-version."mv"."2.1.1";
  by-spec."nan"."^2.0.9" =
    self.by-version."nan"."2.5.0";
  by-version."nan"."2.5.0" = self.buildNodePackage {
    name = "nan-2.5.0";
    version = "2.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.5.0.tgz";
      name = "nan-2.5.0.tgz";
      sha1 = "aa8f1e34531d807e9e27755b234b4a6ec0c152a8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nan"."^2.3.0" =
    self.by-version."nan"."2.5.0";
  by-spec."nan"."~2.4.0" =
    self.by-version."nan"."2.4.0";
  by-version."nan"."2.4.0" = self.buildNodePackage {
    name = "nan-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.4.0.tgz";
      name = "nan-2.4.0.tgz";
      sha1 = "fb3c59d45fe4effe215f0b890f8adf6eb32d2232";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ncp"."~2.0.0" =
    self.by-version."ncp"."2.0.0";
  by-version."ncp"."2.0.0" = self.buildNodePackage {
    name = "ncp-2.0.0";
    version = "2.0.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/ncp/-/ncp-2.0.0.tgz";
      name = "ncp-2.0.0.tgz";
      sha1 = "195a21d6c46e361d2fb1281ba38b91e9df7bdbb3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-abi"."^1.0.3" =
    self.by-version."node-abi"."1.0.3";
  by-version."node-abi"."1.0.3" = self.buildNodePackage {
    name = "node-abi-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-abi/-/node-abi-1.0.3.tgz";
      name = "node-abi-1.0.3.tgz";
      sha1 = "0768a3abc28d260e747ca166c484a34ca42b8659";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-gyp"."^3.0.3" =
    self.by-version."node-gyp"."3.5.0";
  by-version."node-gyp"."3.5.0" = self.buildNodePackage {
    name = "node-gyp-3.5.0";
    version = "3.5.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-gyp/-/node-gyp-3.5.0.tgz";
      name = "node-gyp-3.5.0.tgz";
      sha1 = "a8fe5e611d079ec16348a3eb960e78e11c85274a";
    };
    deps = {
      "fstream-1.0.10" = self.by-version."fstream"."1.0.10";
      "glob-7.1.1" = self.by-version."glob"."7.1.1";
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
      "npmlog-4.0.2" = self.by-version."npmlog"."4.0.2";
      "osenv-0.1.4" = self.by-version."osenv"."0.1.4";
      "request-2.79.0" = self.by-version."request"."2.79.0";
      "rimraf-2.5.4" = self.by-version."rimraf"."2.5.4";
      "semver-5.3.0" = self.by-version."semver"."5.3.0";
      "tar-2.2.1" = self.by-version."tar"."2.2.1";
      "which-1.2.12" = self.by-version."which"."1.2.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-ninja"."^1.0.1" =
    self.by-version."node-ninja"."1.0.2";
  by-version."node-ninja"."1.0.2" = self.buildNodePackage {
    name = "node-ninja-1.0.2";
    version = "1.0.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-ninja/-/node-ninja-1.0.2.tgz";
      name = "node-ninja-1.0.2.tgz";
      sha1 = "20a09e57b92e2df591993d4bf098ac3e727062b6";
    };
    deps = {
      "fstream-1.0.10" = self.by-version."fstream"."1.0.10";
      "glob-7.1.1" = self.by-version."glob"."7.1.1";
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
      "npmlog-2.0.4" = self.by-version."npmlog"."2.0.4";
      "osenv-0.1.4" = self.by-version."osenv"."0.1.4";
      "path-array-1.0.1" = self.by-version."path-array"."1.0.1";
      "request-2.79.0" = self.by-version."request"."2.79.0";
      "rimraf-2.5.4" = self.by-version."rimraf"."2.5.4";
      "semver-5.3.0" = self.by-version."semver"."5.3.0";
      "tar-2.2.1" = self.by-version."tar"."2.2.1";
      "which-1.2.12" = self.by-version."which"."1.2.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-pre-gyp"."^0.6.29" =
    self.by-version."node-pre-gyp"."0.6.32";
  by-version."node-pre-gyp"."0.6.32" = self.buildNodePackage {
    name = "node-pre-gyp-0.6.32";
    version = "0.6.32";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-pre-gyp/-/node-pre-gyp-0.6.32.tgz";
      name = "node-pre-gyp-0.6.32.tgz";
      sha1 = "fc452b376e7319b3d255f5f34853ef6fd8fe1fd5";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "nopt-3.0.6" = self.by-version."nopt"."3.0.6";
      "npmlog-4.0.2" = self.by-version."npmlog"."4.0.2";
      "rc-1.1.6" = self.by-version."rc"."1.1.6";
      "request-2.79.0" = self.by-version."request"."2.79.0";
      "rimraf-2.5.4" = self.by-version."rimraf"."2.5.4";
      "semver-5.3.0" = self.by-version."semver"."5.3.0";
      "tar-2.2.1" = self.by-version."tar"."2.2.1";
      "tar-pack-3.3.0" = self.by-version."tar-pack"."3.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."noderify"."~1.0.0" =
    self.by-version."noderify"."1.0.0";
  by-version."noderify"."1.0.0" = self.buildNodePackage {
    name = "noderify-1.0.0";
    version = "1.0.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/noderify/-/noderify-1.0.0.tgz";
      name = "noderify-1.0.0.tgz";
      sha1 = "92c8d21d9dbdcdd1795c3fad3d98bf0a4ea55a2c";
    };
    deps = {
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "module-deps-3.9.1" = self.by-version."module-deps"."3.9.1";
      "resolve-1.2.0" = self.by-version."resolve"."1.2.0";
      "sort-stream-1.0.1" = self.by-version."sort-stream"."1.0.1";
      "through2-2.0.3" = self.by-version."through2"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "noderify" = self.by-version."noderify"."1.0.0";
  by-spec."non-private-ip"."^1.2.1" =
    self.by-version."non-private-ip"."1.4.1";
  by-version."non-private-ip"."1.4.1" = self.buildNodePackage {
    name = "non-private-ip-1.4.1";
    version = "1.4.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/non-private-ip/-/non-private-ip-1.4.1.tgz";
      name = "non-private-ip-1.4.1.tgz";
      sha1 = "adba2df680cae6cd6b056110229420efb6ccf483";
    };
    deps = {
      "ip-0.3.3" = self.by-version."ip"."0.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."non-private-ip"."^1.3.0" =
    self.by-version."non-private-ip"."1.4.1";
  by-spec."non-private-ip"."~1.1.0" =
    self.by-version."non-private-ip"."1.1.0";
  by-version."non-private-ip"."1.1.0" = self.buildNodePackage {
    name = "non-private-ip-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/non-private-ip/-/non-private-ip-1.1.0.tgz";
      name = "non-private-ip-1.1.0.tgz";
      sha1 = "46f45352d50f687340e4c011f7163ca6d1907403";
    };
    deps = {
      "ip-0.3.3" = self.by-version."ip"."0.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "non-private-ip" = self.by-version."non-private-ip"."1.1.0";
  by-spec."noop-logger"."^0.1.0" =
    self.by-version."noop-logger"."0.1.1";
  by-version."noop-logger"."0.1.1" = self.buildNodePackage {
    name = "noop-logger-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/noop-logger/-/noop-logger-0.1.1.tgz";
      name = "noop-logger-0.1.1.tgz";
      sha1 = "94a2b1633c4f1317553007d8966fd0e841b6a4c2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nopt"."2 || 3" =
    self.by-version."nopt"."3.0.6";
  by-version."nopt"."3.0.6" = self.buildNodePackage {
    name = "nopt-3.0.6";
    version = "3.0.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/nopt/-/nopt-3.0.6.tgz";
      name = "nopt-3.0.6.tgz";
      sha1 = "c6465dbf08abcd4db359317f79ac68a646b28ff9";
    };
    deps = {
      "abbrev-1.0.9" = self.by-version."abbrev"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."nopt"."~3.0.6" =
    self.by-version."nopt"."3.0.6";
  by-spec."normalize-package-data"."^2.3.2" =
    self.by-version."normalize-package-data"."2.3.5";
  by-version."normalize-package-data"."2.3.5" = self.buildNodePackage {
    name = "normalize-package-data-2.3.5";
    version = "2.3.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/normalize-package-data/-/normalize-package-data-2.3.5.tgz";
      name = "normalize-package-data-2.3.5.tgz";
      sha1 = "8d924f142960e1777e7ffe170543631cc7cb02df";
    };
    deps = {
      "hosted-git-info-2.1.5" = self.by-version."hosted-git-info"."2.1.5";
      "is-builtin-module-1.0.0" = self.by-version."is-builtin-module"."1.0.0";
      "semver-5.3.0" = self.by-version."semver"."5.3.0";
      "validate-npm-package-license-3.0.1" = self.by-version."validate-npm-package-license"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."normalize-package-data"."^2.3.4" =
    self.by-version."normalize-package-data"."2.3.5";
  by-spec."normalize-path"."^2.0.1" =
    self.by-version."normalize-path"."2.0.1";
  by-version."normalize-path"."2.0.1" = self.buildNodePackage {
    name = "normalize-path-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/normalize-path/-/normalize-path-2.0.1.tgz";
      name = "normalize-path-2.0.1.tgz";
      sha1 = "47886ac1662760d4261b7d979d241709d3ce3f7a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."normalize-uri"."^1.0.0" =
    self.by-version."normalize-uri"."1.1.0";
  by-version."normalize-uri"."1.1.0" = self.buildNodePackage {
    name = "normalize-uri-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/normalize-uri/-/normalize-uri-1.1.0.tgz";
      name = "normalize-uri-1.1.0.tgz";
      sha1 = "01fb440c7fd059b9d9be8645aac14341efd059dd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."npm-prefix"."^1.0.1" =
    self.by-version."npm-prefix"."1.2.0";
  by-version."npm-prefix"."1.2.0" = self.buildNodePackage {
    name = "npm-prefix-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/npm-prefix/-/npm-prefix-1.2.0.tgz";
      name = "npm-prefix-1.2.0.tgz";
      sha1 = "e619455f7074ba54cc66d6d0d37dd9f1be6bcbc0";
    };
    deps = {
      "rc-1.1.6" = self.by-version."rc"."1.1.6";
      "shellsubstitute-1.2.0" = self.by-version."shellsubstitute"."1.2.0";
      "untildify-2.1.0" = self.by-version."untildify"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."npmlog"."0 || 1 || 2" =
    self.by-version."npmlog"."2.0.4";
  by-version."npmlog"."2.0.4" = self.buildNodePackage {
    name = "npmlog-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/npmlog/-/npmlog-2.0.4.tgz";
      name = "npmlog-2.0.4.tgz";
      sha1 = "98b52530f2514ca90d09ec5b22c8846722375692";
    };
    deps = {
      "ansi-0.3.1" = self.by-version."ansi"."0.3.1";
      "are-we-there-yet-1.1.2" = self.by-version."are-we-there-yet"."1.1.2";
      "gauge-1.2.7" = self.by-version."gauge"."1.2.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."npmlog"."0 || 1 || 2 || 3 || 4" =
    self.by-version."npmlog"."4.0.2";
  by-version."npmlog"."4.0.2" = self.buildNodePackage {
    name = "npmlog-4.0.2";
    version = "4.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/npmlog/-/npmlog-4.0.2.tgz";
      name = "npmlog-4.0.2.tgz";
      sha1 = "d03950e0e78ce1527ba26d2a7592e9348ac3e75f";
    };
    deps = {
      "are-we-there-yet-1.1.2" = self.by-version."are-we-there-yet"."1.1.2";
      "console-control-strings-1.1.0" = self.by-version."console-control-strings"."1.1.0";
      "gauge-2.7.2" = self.by-version."gauge"."2.7.2";
      "set-blocking-2.0.0" = self.by-version."set-blocking"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."npmlog"."^2.0.0" =
    self.by-version."npmlog"."2.0.4";
  by-spec."npmlog"."^4.0.1" =
    self.by-version."npmlog"."4.0.2";
  by-spec."number-is-nan"."^1.0.0" =
    self.by-version."number-is-nan"."1.0.1";
  by-version."number-is-nan"."1.0.1" = self.buildNodePackage {
    name = "number-is-nan-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.1.tgz";
      name = "number-is-nan-1.0.1.tgz";
      sha1 = "097b602b53422a522c1afb8790318336941a011d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.8.1" =
    self.by-version."oauth-sign"."0.8.2";
  by-version."oauth-sign"."0.8.2" = self.buildNodePackage {
    name = "oauth-sign-0.8.2";
    version = "0.8.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.2.tgz";
      name = "oauth-sign-0.8.2.tgz";
      sha1 = "46a6ab7f0aead8deae9ec0565780b7d4efeb9d43";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^4.0.1" =
    self.by-version."object-assign"."4.1.0";
  by-version."object-assign"."4.1.0" = self.buildNodePackage {
    name = "object-assign-4.1.0";
    version = "4.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-assign/-/object-assign-4.1.0.tgz";
      name = "object-assign-4.1.0.tgz";
      sha1 = "7a3b3d0e98063d43f4c03f2e8ae6cd51a86883a0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^4.1.0" =
    self.by-version."object-assign"."4.1.0";
  by-spec."object-inspect"."~0.3.0" =
    self.by-version."object-inspect"."0.3.1";
  by-version."object-inspect"."0.3.1" = self.buildNodePackage {
    name = "object-inspect-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-inspect/-/object-inspect-0.3.1.tgz";
      name = "object-inspect-0.3.1.tgz";
      sha1 = "39fdc8ca276408a795f5c736b2c44cd04c1e76a8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-inspect"."~1.0.0" =
    self.by-version."object-inspect"."1.0.2";
  by-version."object-inspect"."1.0.2" = self.buildNodePackage {
    name = "object-inspect-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-inspect/-/object-inspect-1.0.2.tgz";
      name = "object-inspect-1.0.2.tgz";
      sha1 = "a97885b553e575eb4009ebc09bdda9b1cd21979a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-keys"."~0.4.0" =
    self.by-version."object-keys"."0.4.0";
  by-version."object-keys"."0.4.0" = self.buildNodePackage {
    name = "object-keys-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-keys/-/object-keys-0.4.0.tgz";
      name = "object-keys-0.4.0.tgz";
      sha1 = "28a6aae7428dd2c3a92f3d95f21335dd204e0336";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object.omit"."^2.0.0" =
    self.by-version."object.omit"."2.0.1";
  by-version."object.omit"."2.0.1" = self.buildNodePackage {
    name = "object.omit-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object.omit/-/object.omit-2.0.1.tgz";
      name = "object.omit-2.0.1.tgz";
      sha1 = "1a9c744829f39dbb858c76ca3579ae2a54ebd1fa";
    };
    deps = {
      "for-own-0.1.4" = self.by-version."for-own"."0.1.4";
      "is-extendable-0.1.1" = self.by-version."is-extendable"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."observ"."~0.2.0" =
    self.by-version."observ"."0.2.0";
  by-version."observ"."0.2.0" = self.buildNodePackage {
    name = "observ-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/observ/-/observ-0.2.0.tgz";
      name = "observ-0.2.0.tgz";
      sha1 = "0bc39b3e29faa5f9e6caa5906cb8392df400aa68";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."observ-debounce"."^1.1.1" =
    self.by-version."observ-debounce"."1.1.1";
  by-version."observ-debounce"."1.1.1" = self.buildNodePackage {
    name = "observ-debounce-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/observ-debounce/-/observ-debounce-1.1.1.tgz";
      name = "observ-debounce-1.1.1.tgz";
      sha1 = "304e97c85adda70ecd7f08da450678ef90f0b707";
    };
    deps = {
      "observ-0.2.0" = self.by-version."observ"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "observ-debounce" = self.by-version."observ-debounce"."1.1.1";
  by-spec."on-change-network"."0.0.2" =
    self.by-version."on-change-network"."0.0.2";
  by-version."on-change-network"."0.0.2" = self.buildNodePackage {
    name = "on-change-network-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-change-network/-/on-change-network-0.0.2.tgz";
      name = "on-change-network-0.0.2.tgz";
      sha1 = "d977249477f91726949d80e82346dab6ef45216b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "on-change-network" = self.by-version."on-change-network"."0.0.2";
  by-spec."on-wakeup"."^1.0.0" =
    self.by-version."on-wakeup"."1.0.1";
  by-version."on-wakeup"."1.0.1" = self.buildNodePackage {
    name = "on-wakeup-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-wakeup/-/on-wakeup-1.0.1.tgz";
      name = "on-wakeup-1.0.1.tgz";
      sha1 = "00d79d987dde7c8117bee74bb4903f6f6dafa52b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "on-wakeup" = self.by-version."on-wakeup"."1.0.1";
  by-spec."once"."^1.3.0" =
    self.by-version."once"."1.4.0";
  by-version."once"."1.4.0" = self.buildNodePackage {
    name = "once-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/once/-/once-1.4.0.tgz";
      name = "once-1.4.0.tgz";
      sha1 = "583b1aa775961d4b113ac17d9c50baef9dd76bd1";
    };
    deps = {
      "wrappy-1.0.2" = self.by-version."wrappy"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."^1.3.1" =
    self.by-version."once"."1.4.0";
  by-spec."once"."~1.3.0" =
    self.by-version."once"."1.3.3";
  by-version."once"."1.3.3" = self.buildNodePackage {
    name = "once-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/once/-/once-1.3.3.tgz";
      name = "once-1.3.3.tgz";
      sha1 = "b2e261557ce4c314ec8304f3fa82663e4297ca20";
    };
    deps = {
      "wrappy-1.0.2" = self.by-version."wrappy"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."~1.3.3" =
    self.by-version."once"."1.3.3";
  by-spec."onetime"."^1.0.0" =
    self.by-version."onetime"."1.1.0";
  by-version."onetime"."1.1.0" = self.buildNodePackage {
    name = "onetime-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/onetime/-/onetime-1.1.0.tgz";
      name = "onetime-1.1.0.tgz";
      sha1 = "a1f7838f8314c516f05ecefcbc4ccfe04b4ed789";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = self.buildNodePackage {
    name = "options-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/options/-/options-0.0.6.tgz";
      name = "options-0.0.6.tgz";
      sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-homedir"."^1.0.0" =
    self.by-version."os-homedir"."1.0.2";
  by-version."os-homedir"."1.0.2" = self.buildNodePackage {
    name = "os-homedir-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-homedir/-/os-homedir-1.0.2.tgz";
      name = "os-homedir-1.0.2.tgz";
      sha1 = "ffbc4988336e0e833de0c168c7ef152121aa7fb3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-homedir"."^1.0.1" =
    self.by-version."os-homedir"."1.0.2";
  by-spec."os-tmpdir"."^1.0.0" =
    self.by-version."os-tmpdir"."1.0.2";
  by-version."os-tmpdir"."1.0.2" = self.buildNodePackage {
    name = "os-tmpdir-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.2.tgz";
      name = "os-tmpdir-1.0.2.tgz";
      sha1 = "bbe67406c79aa85c5cfec766fe5734555dfa1274";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."osenv"."0" =
    self.by-version."osenv"."0.1.4";
  by-version."osenv"."0.1.4" = self.buildNodePackage {
    name = "osenv-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/osenv/-/osenv-0.1.4.tgz";
      name = "osenv-0.1.4.tgz";
      sha1 = "42fe6d5953df06c8064be6f176c3d05aaaa34644";
    };
    deps = {
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
      "os-tmpdir-1.0.2" = self.by-version."os-tmpdir"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."osenv"."^0.1.3" =
    self.by-version."osenv"."0.1.4";
  "osenv" = self.by-version."osenv"."0.1.4";
  by-spec."osenv"."~0.1.1" =
    self.by-version."osenv"."0.1.4";
  by-spec."packet-stream"."~2.0.0" =
    self.by-version."packet-stream"."2.0.0";
  by-version."packet-stream"."2.0.0" = self.buildNodePackage {
    name = "packet-stream-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/packet-stream/-/packet-stream-2.0.0.tgz";
      name = "packet-stream-2.0.0.tgz";
      sha1 = "6bfc7b2e478a341c64f902caa766d6c43dfa65d1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."packet-stream-codec"."^1.1.1" =
    self.by-version."packet-stream-codec"."1.1.1";
  by-version."packet-stream-codec"."1.1.1" = self.buildNodePackage {
    name = "packet-stream-codec-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/packet-stream-codec/-/packet-stream-codec-1.1.1.tgz";
      name = "packet-stream-codec-1.1.1.tgz";
      sha1 = "107dec850ad9d27a63310eb1470e82a7e90a1c58";
    };
    deps = {
      "pull-reader-1.2.8" = self.by-version."pull-reader"."1.2.8";
      "pull-through-1.0.18" = self.by-version."pull-through"."1.0.18";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parents"."^1.0.0" =
    self.by-version."parents"."1.0.1";
  by-version."parents"."1.0.1" = self.buildNodePackage {
    name = "parents-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/parents/-/parents-1.0.1.tgz";
      name = "parents-1.0.1.tgz";
      sha1 = "fedd4d2bf193a77745fe71e371d73c3307d9c751";
    };
    deps = {
      "path-platform-0.11.15" = self.by-version."path-platform"."0.11.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parse-entities"."^1.0.0" =
    self.by-version."parse-entities"."1.1.0";
  by-version."parse-entities"."1.1.0" = self.buildNodePackage {
    name = "parse-entities-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parse-entities/-/parse-entities-1.1.0.tgz";
      name = "parse-entities-1.1.0.tgz";
      sha1 = "4bc58f35fdc8e65dded35a12f2e40223ca24a3f7";
    };
    deps = {
      "character-entities-1.2.0" = self.by-version."character-entities"."1.2.0";
      "character-entities-legacy-1.1.0" = self.by-version."character-entities-legacy"."1.1.0";
      "character-reference-invalid-1.1.0" = self.by-version."character-reference-invalid"."1.1.0";
      "has-1.0.1" = self.by-version."has"."1.0.1";
      "is-alphanumerical-1.0.0" = self.by-version."is-alphanumerical"."1.0.0";
      "is-decimal-1.0.0" = self.by-version."is-decimal"."1.0.0";
      "is-hexadecimal-1.0.0" = self.by-version."is-hexadecimal"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parse-glob"."^3.0.4" =
    self.by-version."parse-glob"."3.0.4";
  by-version."parse-glob"."3.0.4" = self.buildNodePackage {
    name = "parse-glob-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parse-glob/-/parse-glob-3.0.4.tgz";
      name = "parse-glob-3.0.4.tgz";
      sha1 = "b2c376cfb11f35513badd173ef0bb6e3a388391c";
    };
    deps = {
      "glob-base-0.3.0" = self.by-version."glob-base"."0.3.0";
      "is-dotfile-1.0.2" = self.by-version."is-dotfile"."1.0.2";
      "is-extglob-1.0.0" = self.by-version."is-extglob"."1.0.0";
      "is-glob-2.0.1" = self.by-version."is-glob"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parse-json"."^2.2.0" =
    self.by-version."parse-json"."2.2.0";
  by-version."parse-json"."2.2.0" = self.buildNodePackage {
    name = "parse-json-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parse-json/-/parse-json-2.2.0.tgz";
      name = "parse-json-2.2.0.tgz";
      sha1 = "f480f40434ef80741f8469099f8dea18f55a4dc9";
    };
    deps = {
      "error-ex-1.3.0" = self.by-version."error-ex"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-array"."^1.0.0" =
    self.by-version."path-array"."1.0.1";
  by-version."path-array"."1.0.1" = self.buildNodePackage {
    name = "path-array-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-array/-/path-array-1.0.1.tgz";
      name = "path-array-1.0.1.tgz";
      sha1 = "7e2f0f35f07a2015122b868b7eac0eb2c4fec271";
    };
    deps = {
      "array-index-1.0.0" = self.by-version."array-index"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-exists"."^2.0.0" =
    self.by-version."path-exists"."2.1.0";
  by-version."path-exists"."2.1.0" = self.buildNodePackage {
    name = "path-exists-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-exists/-/path-exists-2.1.0.tgz";
      name = "path-exists-2.1.0.tgz";
      sha1 = "0feb6c64f0fc518d9a754dd5efb62c7022761f4b";
    };
    deps = {
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-is-absolute"."^1.0.0" =
    self.by-version."path-is-absolute"."1.0.1";
  by-version."path-is-absolute"."1.0.1" = self.buildNodePackage {
    name = "path-is-absolute-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-is-absolute/-/path-is-absolute-1.0.1.tgz";
      name = "path-is-absolute-1.0.1.tgz";
      sha1 = "174b9268735534ffbc7ace6bf53a5a9e1b5c5f5f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-platform"."~0.11.15" =
    self.by-version."path-platform"."0.11.15";
  by-version."path-platform"."0.11.15" = self.buildNodePackage {
    name = "path-platform-0.11.15";
    version = "0.11.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-platform/-/path-platform-0.11.15.tgz";
      name = "path-platform-0.11.15.tgz";
      sha1 = "e864217f74c36850f0852b78dc7bf7d4a5721bf2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-type"."^1.0.0" =
    self.by-version."path-type"."1.1.0";
  by-version."path-type"."1.1.0" = self.buildNodePackage {
    name = "path-type-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-type/-/path-type-1.1.0.tgz";
      name = "path-type-1.1.0.tgz";
      sha1 = "59c44f7ee491da704da415da5a4070ba4f8fe441";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "pify-2.3.0" = self.by-version."pify"."2.3.0";
      "pinkie-promise-2.0.1" = self.by-version."pinkie-promise"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pify"."^2.0.0" =
    self.by-version."pify"."2.3.0";
  by-version."pify"."2.3.0" = self.buildNodePackage {
    name = "pify-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pify/-/pify-2.3.0.tgz";
      name = "pify-2.3.0.tgz";
      sha1 = "ed141a6ac043a849ea588498e7dca8b15330e90c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie"."^2.0.0" =
    self.by-version."pinkie"."2.0.4";
  by-version."pinkie"."2.0.4" = self.buildNodePackage {
    name = "pinkie-2.0.4";
    version = "2.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pinkie/-/pinkie-2.0.4.tgz";
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
    self.by-version."pinkie-promise"."2.0.1";
  by-version."pinkie-promise"."2.0.1" = self.buildNodePackage {
    name = "pinkie-promise-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pinkie-promise/-/pinkie-promise-2.0.1.tgz";
      name = "pinkie-promise-2.0.1.tgz";
      sha1 = "2135d6dfa7a358c069ac9b178776288228450ffa";
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
  by-spec."plur"."^2.0.0" =
    self.by-version."plur"."2.1.2";
  by-version."plur"."2.1.2" = self.buildNodePackage {
    name = "plur-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/plur/-/plur-2.1.2.tgz";
      name = "plur-2.1.2.tgz";
      sha1 = "7482452c1a0f508e3e344eaec312c91c29dc655a";
    };
    deps = {
      "irregular-plurals-1.2.0" = self.by-version."irregular-plurals"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prebuild"."^4.1.0" =
    self.by-version."prebuild"."4.5.0";
  by-version."prebuild"."4.5.0" = self.buildNodePackage {
    name = "prebuild-4.5.0";
    version = "4.5.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/prebuild/-/prebuild-4.5.0.tgz";
      name = "prebuild-4.5.0.tgz";
      sha1 = "2aaa0df2063bff814a803bd4dc94ff9b64e5df00";
    };
    deps = {
      "async-1.5.2" = self.by-version."async"."1.5.2";
      "execspawn-1.0.1" = self.by-version."execspawn"."1.0.1";
      "expand-template-1.0.3" = self.by-version."expand-template"."1.0.3";
      "ghreleases-1.0.5" = self.by-version."ghreleases"."1.0.5";
      "github-from-package-0.0.0" = self.by-version."github-from-package"."0.0.0";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "node-gyp-3.5.0" = self.by-version."node-gyp"."3.5.0";
      "node-ninja-1.0.2" = self.by-version."node-ninja"."1.0.2";
      "noop-logger-0.1.1" = self.by-version."noop-logger"."0.1.1";
      "npmlog-2.0.4" = self.by-version."npmlog"."2.0.4";
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
      "pump-1.0.2" = self.by-version."pump"."1.0.2";
      "rc-1.1.6" = self.by-version."rc"."1.1.6";
      "simple-get-1.4.3" = self.by-version."simple-get"."1.4.3";
      "tar-fs-1.15.0" = self.by-version."tar-fs"."1.15.0";
      "tar-stream-1.5.2" = self.by-version."tar-stream"."1.5.2";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prebuild"."^5.0.2" =
    self.by-version."prebuild"."5.1.2";
  by-version."prebuild"."5.1.2" = self.buildNodePackage {
    name = "prebuild-5.1.2";
    version = "5.1.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/prebuild/-/prebuild-5.1.2.tgz";
      name = "prebuild-5.1.2.tgz";
      sha1 = "d2b59d2d9cc4dc8c646da4336d827d47f5b0f411";
    };
    deps = {
      "async-2.1.4" = self.by-version."async"."2.1.4";
      "execspawn-1.0.1" = self.by-version."execspawn"."1.0.1";
      "expand-template-1.0.3" = self.by-version."expand-template"."1.0.3";
      "ghreleases-1.0.5" = self.by-version."ghreleases"."1.0.5";
      "github-from-package-0.0.0" = self.by-version."github-from-package"."0.0.0";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "node-abi-1.0.3" = self.by-version."node-abi"."1.0.3";
      "node-gyp-3.5.0" = self.by-version."node-gyp"."3.5.0";
      "node-ninja-1.0.2" = self.by-version."node-ninja"."1.0.2";
      "noop-logger-0.1.1" = self.by-version."noop-logger"."0.1.1";
      "npmlog-4.0.2" = self.by-version."npmlog"."4.0.2";
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
      "pump-1.0.2" = self.by-version."pump"."1.0.2";
      "rc-1.1.6" = self.by-version."rc"."1.1.6";
      "simple-get-1.4.3" = self.by-version."simple-get"."1.4.3";
      "tar-fs-1.15.0" = self.by-version."tar-fs"."1.15.0";
      "tar-stream-1.5.2" = self.by-version."tar-stream"."1.5.2";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."preserve"."^0.2.0" =
    self.by-version."preserve"."0.2.0";
  by-version."preserve"."0.2.0" = self.buildNodePackage {
    name = "preserve-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/preserve/-/preserve-0.2.0.tgz";
      name = "preserve-0.2.0.tgz";
      sha1 = "815ed1f6ebc65926f865b310c0713bcb3315ce4b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."private-box"."^0.2.1" =
    self.by-version."private-box"."0.2.1";
  by-version."private-box"."0.2.1" = self.buildNodePackage {
    name = "private-box-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/private-box/-/private-box-0.2.1.tgz";
      name = "private-box-0.2.1.tgz";
      sha1 = "1df061afca5b3039c7feaadd0daf0f56f07e3ec0";
    };
    deps = {
      "chloride-2.2.4" = self.by-version."chloride"."2.2.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."process-nextick-args"."~1.0.6" =
    self.by-version."process-nextick-args"."1.0.7";
  by-version."process-nextick-args"."1.0.7" = self.buildNodePackage {
    name = "process-nextick-args-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.7.tgz";
      name = "process-nextick-args-1.0.7.tgz";
      sha1 = "150e20b756590ad3f91093f25a4f2ad8bff30ba3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prr"."~0.0.0" =
    self.by-version."prr"."0.0.0";
  by-version."prr"."0.0.0" = self.buildNodePackage {
    name = "prr-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/prr/-/prr-0.0.0.tgz";
      name = "prr-0.0.0.tgz";
      sha1 = "1a84b85908325501411853d0081ee3fa86e2926a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prr"."~1.0.1" =
    self.by-version."prr"."1.0.1";
  by-version."prr"."1.0.1" = self.buildNodePackage {
    name = "prr-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/prr/-/prr-1.0.1.tgz";
      name = "prr-1.0.1.tgz";
      sha1 = "d3fc114ba06995a45ec6893f484ceb1d78f5f476";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-abortable"."~4.0.0" =
    self.by-version."pull-abortable"."4.0.0";
  by-version."pull-abortable"."4.0.0" = self.buildNodePackage {
    name = "pull-abortable-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-abortable/-/pull-abortable-4.0.0.tgz";
      name = "pull-abortable-4.0.0.tgz";
      sha1 = "7017a984c3b834de77bac38c10b776f22dfc1843";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-abortable" = self.by-version."pull-abortable"."4.0.0";
  by-spec."pull-box-stream"."^1.0.9" =
    self.by-version."pull-box-stream"."1.0.11";
  by-version."pull-box-stream"."1.0.11" = self.buildNodePackage {
    name = "pull-box-stream-1.0.11";
    version = "1.0.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-box-stream/-/pull-box-stream-1.0.11.tgz";
      name = "pull-box-stream-1.0.11.tgz";
      sha1 = "e74f3de1907c05c9f26b1a5f9e74a078ad1e86d7";
    };
    deps = {
      "chloride-2.2.4" = self.by-version."chloride"."2.2.4";
      "increment-buffer-1.0.1" = self.by-version."increment-buffer"."1.0.1";
      "pull-reader-1.2.8" = self.by-version."pull-reader"."1.2.8";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-through-1.0.18" = self.by-version."pull-through"."1.0.18";
      "split-buffer-1.0.0" = self.by-version."split-buffer"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-cat".">=1.1 <2" =
    self.by-version."pull-cat"."1.1.11";
  by-version."pull-cat"."1.1.11" = self.buildNodePackage {
    name = "pull-cat-1.1.11";
    version = "1.1.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-cat/-/pull-cat-1.1.11.tgz";
      name = "pull-cat-1.1.11.tgz";
      sha1 = "b642dd1255da376a706b6db4fa962f5fdb74c31b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-cat"."^1.1.11" =
    self.by-version."pull-cat"."1.1.11";
  by-spec."pull-cat"."^1.1.8" =
    self.by-version."pull-cat"."1.1.11";
  by-spec."pull-cat"."^1.1.9" =
    self.by-version."pull-cat"."1.1.11";
  by-spec."pull-cat"."~1.1.5" =
    self.by-version."pull-cat"."1.1.11";
  "pull-cat" = self.by-version."pull-cat"."1.1.11";
  by-spec."pull-core"."1" =
    self.by-version."pull-core"."1.1.0";
  by-version."pull-core"."1.1.0" = self.buildNodePackage {
    name = "pull-core-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-core/-/pull-core-1.1.0.tgz";
      name = "pull-core-1.1.0.tgz";
      sha1 = "3d8127d6dac1475705c9800961f59d66c8046c8a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-core"."~1.0.0" =
    self.by-version."pull-core"."1.0.0";
  by-version."pull-core"."1.0.0" = self.buildNodePackage {
    name = "pull-core-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-core/-/pull-core-1.0.0.tgz";
      name = "pull-core-1.0.0.tgz";
      sha1 = "e0eb93918dfa70963ed09e36f63daa15b76b38a4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-core"."~1.1.0" =
    self.by-version."pull-core"."1.1.0";
  by-spec."pull-defer"."^0.2.2" =
    self.by-version."pull-defer"."0.2.2";
  by-version."pull-defer"."0.2.2" = self.buildNodePackage {
    name = "pull-defer-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-defer/-/pull-defer-0.2.2.tgz";
      name = "pull-defer-0.2.2.tgz";
      sha1 = "0887b0ffb30af32a56dbecfa72c1672271f07b13";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-file"."^0.5.0" =
    self.by-version."pull-file"."0.5.0";
  by-version."pull-file"."0.5.0" = self.buildNodePackage {
    name = "pull-file-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-file/-/pull-file-0.5.0.tgz";
      name = "pull-file-0.5.0.tgz";
      sha1 = "b3ca405306e082f9d4528288933badb2b656365b";
    };
    deps = {
      "pull-utf8-decoder-1.0.2" = self.by-version."pull-utf8-decoder"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-file" = self.by-version."pull-file"."0.5.0";
  by-spec."pull-fs"."~1.1.6" =
    self.by-version."pull-fs"."1.1.6";
  by-version."pull-fs"."1.1.6" = self.buildNodePackage {
    name = "pull-fs-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-fs/-/pull-fs-1.1.6.tgz";
      name = "pull-fs-1.1.6.tgz";
      sha1 = "f184f6a7728bb4d95641376bead69f6f66df47cd";
    };
    deps = {
      "pull-file-0.5.0" = self.by-version."pull-file"."0.5.0";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-traverse-1.0.3" = self.by-version."pull-traverse"."1.0.3";
      "pull-write-file-0.2.4" = self.by-version."pull-write-file"."0.2.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-glob"."~1.0.6" =
    self.by-version."pull-glob"."1.0.6";
  by-version."pull-glob"."1.0.6" = self.buildNodePackage {
    name = "pull-glob-1.0.6";
    version = "1.0.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-glob/-/pull-glob-1.0.6.tgz";
      name = "pull-glob-1.0.6.tgz";
      sha1 = "dea5ac5948ee15978dab24d777202927f68ae8a6";
    };
    deps = {
      "pull-fs-1.1.6" = self.by-version."pull-fs"."1.1.6";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-goodbye"."~0.0.1" =
    self.by-version."pull-goodbye"."0.0.1";
  by-version."pull-goodbye"."0.0.1" = self.buildNodePackage {
    name = "pull-goodbye-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-goodbye/-/pull-goodbye-0.0.1.tgz";
      name = "pull-goodbye-0.0.1.tgz";
      sha1 = "4d9371ef0e22dce32000ea949c922f2f9f8f69ea";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-handshake"."^1.1.1" =
    self.by-version."pull-handshake"."1.1.4";
  by-version."pull-handshake"."1.1.4" = self.buildNodePackage {
    name = "pull-handshake-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-handshake/-/pull-handshake-1.1.4.tgz";
      name = "pull-handshake-1.1.4.tgz";
      sha1 = "6000a0fd018884cdfd737254f8cc60ab2a637791";
    };
    deps = {
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-pair-1.1.0" = self.by-version."pull-pair"."1.1.0";
      "pull-pushable-2.0.1" = self.by-version."pull-pushable"."2.0.1";
      "pull-reader-1.2.8" = self.by-version."pull-reader"."1.2.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-inactivity"."~2.1.1" =
    self.by-version."pull-inactivity"."2.1.2";
  by-version."pull-inactivity"."2.1.2" = self.buildNodePackage {
    name = "pull-inactivity-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-inactivity/-/pull-inactivity-2.1.2.tgz";
      name = "pull-inactivity-2.1.2.tgz";
      sha1 = "37a3d6ebbfac292cd435f5e481e5074c8c1fad75";
    };
    deps = {
      "pull-abortable-4.0.0" = self.by-version."pull-abortable"."4.0.0";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-inactivity" = self.by-version."pull-inactivity"."2.1.2";
  by-spec."pull-level"."^1.5.2" =
    self.by-version."pull-level"."1.5.2";
  by-version."pull-level"."1.5.2" = self.buildNodePackage {
    name = "pull-level-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-level/-/pull-level-1.5.2.tgz";
      name = "pull-level-1.5.2.tgz";
      sha1 = "2b4bdc8eab8d4f2e3708b49512350b14bb035b56";
    };
    deps = {
      "level-post-1.0.5" = self.by-version."level-post"."1.0.5";
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-pushable-2.0.1" = self.by-version."pull-pushable"."2.0.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-window-2.1.4" = self.by-version."pull-window"."2.1.4";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-level"."^2.0.2" =
    self.by-version."pull-level"."2.0.3";
  by-version."pull-level"."2.0.3" = self.buildNodePackage {
    name = "pull-level-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-level/-/pull-level-2.0.3.tgz";
      name = "pull-level-2.0.3.tgz";
      sha1 = "9500635e257945d6feede185f5d7a24773455b17";
    };
    deps = {
      "level-post-1.0.5" = self.by-version."level-post"."1.0.5";
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-live-1.0.1" = self.by-version."pull-live"."1.0.1";
      "pull-pushable-2.0.1" = self.by-version."pull-pushable"."2.0.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-window-2.1.4" = self.by-version."pull-window"."2.1.4";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-level" = self.by-version."pull-level"."2.0.3";
  by-spec."pull-level"."^2.0.3" =
    self.by-version."pull-level"."2.0.3";
  by-spec."pull-level"."~1.2.0" =
    self.by-version."pull-level"."1.2.0";
  by-version."pull-level"."1.2.0" = self.buildNodePackage {
    name = "pull-level-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-level/-/pull-level-1.2.0.tgz";
      name = "pull-level-1.2.0.tgz";
      sha1 = "53b32122650eb15d35b60e54321fba11cf5c6e66";
    };
    deps = {
      "pull-stream-2.28.4" = self.by-version."pull-stream"."2.28.4";
      "pull-pushable-1.1.4" = self.by-version."pull-pushable"."1.1.4";
      "pull-window-2.1.4" = self.by-version."pull-window"."2.1.4";
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "stream-to-pull-stream-1.3.1" = self.by-version."stream-to-pull-stream"."1.3.1";
      "level-post-1.0.5" = self.by-version."level-post"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-live"."^1.0.0" =
    self.by-version."pull-live"."1.0.1";
  by-version."pull-live"."1.0.1" = self.buildNodePackage {
    name = "pull-live-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-live/-/pull-live-1.0.1.tgz";
      name = "pull-live-1.0.1.tgz";
      sha1 = "a4ecee01e330155e9124bbbcf4761f21b38f51f5";
    };
    deps = {
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-live"."^1.0.1" =
    self.by-version."pull-live"."1.0.1";
  by-spec."pull-many"."~1.0.6" =
    self.by-version."pull-many"."1.0.8";
  by-version."pull-many"."1.0.8" = self.buildNodePackage {
    name = "pull-many-1.0.8";
    version = "1.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-many/-/pull-many-1.0.8.tgz";
      name = "pull-many-1.0.8.tgz";
      sha1 = "3dadd9b6d156c545721bda8d0003dd8eaa06293e";
    };
    deps = {
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-many" = self.by-version."pull-many"."1.0.8";
  by-spec."pull-notify"."0.0.0" =
    self.by-version."pull-notify"."0.0.0";
  by-version."pull-notify"."0.0.0" = self.buildNodePackage {
    name = "pull-notify-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-notify/-/pull-notify-0.0.0.tgz";
      name = "pull-notify-0.0.0.tgz";
      sha1 = "cb68db63b800eace4c0a23c514b352e372fba8b3";
    };
    deps = {
      "pull-pushable-1.1.4" = self.by-version."pull-pushable"."1.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-notify" = self.by-version."pull-notify"."0.0.0";
  by-spec."pull-notify"."0.0.2" =
    self.by-version."pull-notify"."0.0.2";
  by-version."pull-notify"."0.0.2" = self.buildNodePackage {
    name = "pull-notify-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-notify/-/pull-notify-0.0.2.tgz";
      name = "pull-notify-0.0.2.tgz";
      sha1 = "280bbba1a57683e22a38206b2989465f24051821";
    };
    deps = {
      "pull-pushable-2.0.1" = self.by-version."pull-pushable"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-notify"."^0.1.0" =
    self.by-version."pull-notify"."0.1.1";
  by-version."pull-notify"."0.1.1" = self.buildNodePackage {
    name = "pull-notify-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-notify/-/pull-notify-0.1.1.tgz";
      name = "pull-notify-0.1.1.tgz";
      sha1 = "6f86ff95d270b89c3ebf255b6031b7032dc99cca";
    };
    deps = {
      "pull-pushable-2.0.1" = self.by-version."pull-pushable"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-pair"."~1.1.0" =
    self.by-version."pull-pair"."1.1.0";
  by-version."pull-pair"."1.1.0" = self.buildNodePackage {
    name = "pull-pair-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-pair/-/pull-pair-1.1.0.tgz";
      name = "pull-pair-1.1.0.tgz";
      sha1 = "7ee427263fdf4da825397ac0a05e1ab4b74bd76d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-paramap"."^1.1.4" =
    self.by-version."pull-paramap"."1.2.1";
  by-version."pull-paramap"."1.2.1" = self.buildNodePackage {
    name = "pull-paramap-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-paramap/-/pull-paramap-1.2.1.tgz";
      name = "pull-paramap-1.2.1.tgz";
      sha1 = "ec533c90bbb1fcbc4ac94a94bf029f0615172172";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-paramap"."^1.1.6" =
    self.by-version."pull-paramap"."1.2.1";
  by-spec."pull-paramap"."~1.1.1" =
    self.by-version."pull-paramap"."1.1.6";
  by-version."pull-paramap"."1.1.6" = self.buildNodePackage {
    name = "pull-paramap-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-paramap/-/pull-paramap-1.1.6.tgz";
      name = "pull-paramap-1.1.6.tgz";
      sha1 = "a0532a57eb0c041230a625dc0cceaa55aa6e93fd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-paramap" = self.by-version."pull-paramap"."1.1.6";
  by-spec."pull-ping"."^2.0.2" =
    self.by-version."pull-ping"."2.0.2";
  by-version."pull-ping"."2.0.2" = self.buildNodePackage {
    name = "pull-ping-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-ping/-/pull-ping-2.0.2.tgz";
      name = "pull-ping-2.0.2.tgz";
      sha1 = "7bc4a340167dad88f682a196c63485735c7a0894";
    };
    deps = {
      "pull-pushable-2.0.1" = self.by-version."pull-pushable"."2.0.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "statistics-3.3.0" = self.by-version."statistics"."3.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-ping" = self.by-version."pull-ping"."2.0.2";
  by-spec."pull-pushable"."1" =
    self.by-version."pull-pushable"."1.1.4";
  by-version."pull-pushable"."1.1.4" = self.buildNodePackage {
    name = "pull-pushable-1.1.4";
    version = "1.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-pushable/-/pull-pushable-1.1.4.tgz";
      name = "pull-pushable-1.1.4.tgz";
      sha1 = "7664d6741f72687ef5c89f533b78682f3de9a20e";
    };
    deps = {
      "pull-stream-2.18.3" = self.by-version."pull-stream"."2.18.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-pushable"."^2.0.0" =
    self.by-version."pull-pushable"."2.0.1";
  by-version."pull-pushable"."2.0.1" = self.buildNodePackage {
    name = "pull-pushable-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-pushable/-/pull-pushable-2.0.1.tgz";
      name = "pull-pushable-2.0.1.tgz";
      sha1 = "02bdca51a39cf585f483fbecde2fc9378076f212";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-pushable" = self.by-version."pull-pushable"."2.0.1";
  by-spec."pull-pushable"."~1.1.4" =
    self.by-version."pull-pushable"."1.1.4";
  by-spec."pull-reader"."^1.2.3" =
    self.by-version."pull-reader"."1.2.8";
  by-version."pull-reader"."1.2.8" = self.buildNodePackage {
    name = "pull-reader-1.2.8";
    version = "1.2.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-reader/-/pull-reader-1.2.8.tgz";
      name = "pull-reader-1.2.8.tgz";
      sha1 = "a673c837dae6bbace25fd0480fc6ab5583158463";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-reader"."^1.2.4" =
    self.by-version."pull-reader"."1.2.8";
  by-spec."pull-reader"."^1.2.5" =
    self.by-version."pull-reader"."1.2.8";
  by-spec."pull-stream".">=2.20 <3" =
    self.by-version."pull-stream"."2.28.4";
  by-version."pull-stream"."2.28.4" = self.buildNodePackage {
    name = "pull-stream-2.28.4";
    version = "2.28.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream/-/pull-stream-2.28.4.tgz";
      name = "pull-stream-2.28.4.tgz";
      sha1 = "7ea97413c1619c20bc3bdf9e10e91347b03253e4";
    };
    deps = {
      "pull-core-1.1.0" = self.by-version."pull-core"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-stream"."^2.28.3" =
    self.by-version."pull-stream"."2.28.4";
  by-spec."pull-stream"."^3.0.0" =
    self.by-version."pull-stream"."3.5.0";
  by-version."pull-stream"."3.5.0" = self.buildNodePackage {
    name = "pull-stream-3.5.0";
    version = "3.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream/-/pull-stream-3.5.0.tgz";
      name = "pull-stream-3.5.0.tgz";
      sha1 = "1ee5b6f76fd3b3a49a5afb6ded5c0320acb3cfc7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-stream" = self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."^3.2.3" =
    self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."^3.3.0" =
    self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."^3.4.0" =
    self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."^3.4.2" =
    self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."^3.4.3" =
    self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."^3.4.5" =
    self.by-version."pull-stream"."3.5.0";
  by-spec."pull-stream"."~2.18.2" =
    self.by-version."pull-stream"."2.18.3";
  by-version."pull-stream"."2.18.3" = self.buildNodePackage {
    name = "pull-stream-2.18.3";
    version = "2.18.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream/-/pull-stream-2.18.3.tgz";
      name = "pull-stream-2.18.3.tgz";
      sha1 = "7a07962234d7579c908860db8c27f7f34fd45000";
    };
    deps = {
      "pull-core-1.0.0" = self.by-version."pull-core"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-stream"."~2.21.0" =
    self.by-version."pull-stream"."2.21.0";
  by-version."pull-stream"."2.21.0" = self.buildNodePackage {
    name = "pull-stream-2.21.0";
    version = "2.21.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream/-/pull-stream-2.21.0.tgz";
      name = "pull-stream-2.21.0.tgz";
      sha1 = "5b04e0bb35ffe64744fa9bb68465a84f9e1fe5d1";
    };
    deps = {
      "pull-core-1.0.0" = self.by-version."pull-core"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-stream"."~2.26.0" =
    self.by-version."pull-stream"."2.26.1";
  by-version."pull-stream"."2.26.1" = self.buildNodePackage {
    name = "pull-stream-2.26.1";
    version = "2.26.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream/-/pull-stream-2.26.1.tgz";
      name = "pull-stream-2.26.1.tgz";
      sha1 = "4bf2559de87b8af2f5b96b7190d2ee431ca1e519";
    };
    deps = {
      "pull-core-1.1.0" = self.by-version."pull-core"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-stream"."~2.27.0" =
    self.by-version."pull-stream"."2.27.0";
  by-version."pull-stream"."2.27.0" = self.buildNodePackage {
    name = "pull-stream-2.27.0";
    version = "2.27.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream/-/pull-stream-2.27.0.tgz";
      name = "pull-stream-2.27.0.tgz";
      sha1 = "fdf0eb910cdc4041d65956c00bee30dbbd00a068";
    };
    deps = {
      "pull-core-1.1.0" = self.by-version."pull-core"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-stream-to-stream"."~1.2.4" =
    self.by-version."pull-stream-to-stream"."1.2.6";
  by-version."pull-stream-to-stream"."1.2.6" = self.buildNodePackage {
    name = "pull-stream-to-stream-1.2.6";
    version = "1.2.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream-to-stream/-/pull-stream-to-stream-1.2.6.tgz";
      name = "pull-stream-to-stream-1.2.6.tgz";
      sha1 = "dd9fa3732edb3d16e67cd1f224bca38a6d5748c7";
    };
    deps = {
      "pull-core-1.1.0" = self.by-version."pull-core"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-stream-to-stream"."~1.3.0" =
    self.by-version."pull-stream-to-stream"."1.3.3";
  by-version."pull-stream-to-stream"."1.3.3" = self.buildNodePackage {
    name = "pull-stream-to-stream-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stream-to-stream/-/pull-stream-to-stream-1.3.3.tgz";
      name = "pull-stream-to-stream-1.3.3.tgz";
      sha1 = "f283f5b63c39a1e49d334e3c81d2c15ce851e9b4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-stream-to-stream" = self.by-version."pull-stream-to-stream"."1.3.3";
  by-spec."pull-stringify"."~1.2.2" =
    self.by-version."pull-stringify"."1.2.2";
  by-version."pull-stringify"."1.2.2" = self.buildNodePackage {
    name = "pull-stringify-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-stringify/-/pull-stringify-1.2.2.tgz";
      name = "pull-stringify-1.2.2.tgz";
      sha1 = "5a1c34e0075faf2f2f6d46004e36dccd33bd7c7c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pull-stringify" = self.by-version."pull-stringify"."1.2.2";
  by-spec."pull-through"."^1.0.17" =
    self.by-version."pull-through"."1.0.18";
  by-version."pull-through"."1.0.18" = self.buildNodePackage {
    name = "pull-through-1.0.18";
    version = "1.0.18";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-through/-/pull-through-1.0.18.tgz";
      name = "pull-through-1.0.18.tgz";
      sha1 = "8dd62314263e59cf5096eafbb127a2b6ef310735";
    };
    deps = {
      "looper-3.0.0" = self.by-version."looper"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-through"."^1.0.18" =
    self.by-version."pull-through"."1.0.18";
  by-spec."pull-traverse"."^1.0.3" =
    self.by-version."pull-traverse"."1.0.3";
  by-version."pull-traverse"."1.0.3" = self.buildNodePackage {
    name = "pull-traverse-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-traverse/-/pull-traverse-1.0.3.tgz";
      name = "pull-traverse-1.0.3.tgz";
      sha1 = "74fb5d7be7fa6bd7a78e97933e199b7945866938";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-utf8-decoder"."^1.0.2" =
    self.by-version."pull-utf8-decoder"."1.0.2";
  by-version."pull-utf8-decoder"."1.0.2" = self.buildNodePackage {
    name = "pull-utf8-decoder-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-utf8-decoder/-/pull-utf8-decoder-1.0.2.tgz";
      name = "pull-utf8-decoder-1.0.2.tgz";
      sha1 = "a7afa2384d1e6415a5d602054126cc8de3bcbce7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-window".">=2.1.2 <3" =
    self.by-version."pull-window"."2.1.4";
  by-version."pull-window"."2.1.4" = self.buildNodePackage {
    name = "pull-window-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-window/-/pull-window-2.1.4.tgz";
      name = "pull-window-2.1.4.tgz";
      sha1 = "fc3b86feebd1920c7ae297691e23f705f88552f0";
    };
    deps = {
      "looper-2.0.0" = self.by-version."looper"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-window"."^2.1.4" =
    self.by-version."pull-window"."2.1.4";
  by-spec."pull-write"."^1.1.0" =
    self.by-version."pull-write"."1.1.1";
  by-version."pull-write"."1.1.1" = self.buildNodePackage {
    name = "pull-write-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-write/-/pull-write-1.1.1.tgz";
      name = "pull-write-1.1.1.tgz";
      sha1 = "52460417d6e63e1b0c76628d168bb673182df040";
    };
    deps = {
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-write-file"."^0.2.1" =
    self.by-version."pull-write-file"."0.2.4";
  by-version."pull-write-file"."0.2.4" = self.buildNodePackage {
    name = "pull-write-file-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-write-file/-/pull-write-file-0.2.4.tgz";
      name = "pull-write-file-0.2.4.tgz";
      sha1 = "437344aeb2189f65e678ed1af37f0f760a5453ef";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pull-ws"."^3.2.7" =
    self.by-version."pull-ws"."3.2.8";
  by-version."pull-ws"."3.2.8" = self.buildNodePackage {
    name = "pull-ws-3.2.8";
    version = "3.2.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pull-ws/-/pull-ws-3.2.8.tgz";
      name = "pull-ws-3.2.8.tgz";
      sha1 = "0b3abebac15399e15d0db24cbedddc7dd8363f2e";
    };
    deps = {
      "relative-url-1.0.2" = self.by-version."relative-url"."1.0.2";
      "ws-1.1.1" = self.by-version."ws"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pump"."^1.0.0" =
    self.by-version."pump"."1.0.2";
  by-version."pump"."1.0.2" = self.buildNodePackage {
    name = "pump-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pump/-/pump-1.0.2.tgz";
      name = "pump-1.0.2.tgz";
      sha1 = "3b3ee6512f94f0e575538c17995f9f16990a5d51";
    };
    deps = {
      "end-of-stream-1.1.0" = self.by-version."end-of-stream"."1.1.0";
      "once-1.4.0" = self.by-version."once"."1.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode"."^1.4.1" =
    self.by-version."punycode"."1.4.1";
  by-version."punycode"."1.4.1" = self.buildNodePackage {
    name = "punycode-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/punycode/-/punycode-1.4.1.tgz";
      name = "punycode-1.4.1.tgz";
      sha1 = "c0d5a63b2718800ad8e1eb0fa5269c84dd41845e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~6.3.0" =
    self.by-version."qs"."6.3.0";
  by-version."qs"."6.3.0" = self.buildNodePackage {
    name = "qs-6.3.0";
    version = "6.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-6.3.0.tgz";
      name = "qs-6.3.0.tgz";
      sha1 = "f403b264f23bc01228c74131b407f18d5ea5d442";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."randomatic"."^1.1.3" =
    self.by-version."randomatic"."1.1.6";
  by-version."randomatic"."1.1.6" = self.buildNodePackage {
    name = "randomatic-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/randomatic/-/randomatic-1.1.6.tgz";
      name = "randomatic-1.1.6.tgz";
      sha1 = "110dcabff397e9dcff7c0789ccc0a49adf1ec5bb";
    };
    deps = {
      "is-number-2.1.0" = self.by-version."is-number"."2.1.0";
      "kind-of-3.1.0" = self.by-version."kind-of"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rc"."^1.0.3" =
    self.by-version."rc"."1.1.6";
  by-version."rc"."1.1.6" = self.buildNodePackage {
    name = "rc-1.1.6";
    version = "1.1.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rc/-/rc-1.1.6.tgz";
      name = "rc-1.1.6.tgz";
      sha1 = "43651b76b6ae53b5c802f1151fa3fc3b059969c9";
    };
    deps = {
      "deep-extend-0.4.1" = self.by-version."deep-extend"."0.4.1";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "strip-json-comments-1.0.4" = self.by-version."strip-json-comments"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rc"."^1.1.0" =
    self.by-version."rc"."1.1.6";
  by-spec."rc"."^1.1.6" =
    self.by-version."rc"."1.1.6";
  by-spec."rc"."~0.5.4" =
    self.by-version."rc"."0.5.5";
  by-version."rc"."0.5.5" = self.buildNodePackage {
    name = "rc-0.5.5";
    version = "0.5.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rc/-/rc-0.5.5.tgz";
      name = "rc-0.5.5.tgz";
      sha1 = "541cc3300f464b6dfe6432d756f0f2dd3e9eb199";
    };
    deps = {
      "minimist-0.0.10" = self.by-version."minimist"."0.0.10";
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "strip-json-comments-0.1.3" = self.by-version."strip-json-comments"."0.1.3";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rc"."~1.1.6" =
    self.by-version."rc"."1.1.6";
  by-spec."read-pkg"."^1.0.0" =
    self.by-version."read-pkg"."1.1.0";
  by-version."read-pkg"."1.1.0" = self.buildNodePackage {
    name = "read-pkg-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/read-pkg/-/read-pkg-1.1.0.tgz";
      name = "read-pkg-1.1.0.tgz";
      sha1 = "f5ffaa5ecd29cb31c0474bca7d756b6bb29e3f28";
    };
    deps = {
      "load-json-file-1.1.0" = self.by-version."load-json-file"."1.1.0";
      "normalize-package-data-2.3.5" = self.by-version."normalize-package-data"."2.3.5";
      "path-type-1.1.0" = self.by-version."path-type"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."read-pkg-up"."^1.0.1" =
    self.by-version."read-pkg-up"."1.0.1";
  by-version."read-pkg-up"."1.0.1" = self.buildNodePackage {
    name = "read-pkg-up-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/read-pkg-up/-/read-pkg-up-1.0.1.tgz";
      name = "read-pkg-up-1.0.1.tgz";
      sha1 = "9d63c13276c065918d57f002a57f40a1b643fb02";
    };
    deps = {
      "find-up-1.1.2" = self.by-version."find-up"."1.1.2";
      "read-pkg-1.1.0" = self.by-version."read-pkg"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream".">=1.0.33-1 <1.1.0-0" =
    self.by-version."readable-stream"."1.0.34";
  by-version."readable-stream"."1.0.34" = self.buildNodePackage {
    name = "readable-stream-1.0.34";
    version = "1.0.34";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-1.0.34.tgz";
      name = "readable-stream-1.0.34.tgz";
      sha1 = "125820e34bc842d2f2aaafafe4c2916ee32c157c";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream".">=1.1.13-1 <1.2.0-0" =
    self.by-version."readable-stream"."1.1.14";
  by-version."readable-stream"."1.1.14" = self.buildNodePackage {
    name = "readable-stream-1.1.14";
    version = "1.1.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-1.1.14.tgz";
      name = "readable-stream-1.1.14.tgz";
      sha1 = "7cf4c54ef648e3813084c636dd2079e166c081d9";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^1.0.33" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^1.1.13" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."^2.0.0" =
    self.by-version."readable-stream"."2.2.2";
  by-version."readable-stream"."2.2.2" = self.buildNodePackage {
    name = "readable-stream-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.2.2.tgz";
      name = "readable-stream-2.2.2.tgz";
      sha1 = "a9e6fec3c7dda85f8bb1b3ba7028604556fc825e";
    };
    deps = {
      "buffer-shims-1.0.0" = self.by-version."buffer-shims"."1.0.0";
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "process-nextick-args-1.0.7" = self.by-version."process-nextick-args"."1.0.7";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^2.0.0 || ^1.1.13" =
    self.by-version."readable-stream"."2.2.2";
  by-spec."readable-stream"."^2.0.2" =
    self.by-version."readable-stream"."2.2.2";
  by-spec."readable-stream"."^2.0.5" =
    self.by-version."readable-stream"."2.2.2";
  by-spec."readable-stream"."^2.1.5" =
    self.by-version."readable-stream"."2.2.2";
  by-spec."readable-stream"."^2.2.2" =
    self.by-version."readable-stream"."2.2.2";
  by-spec."readable-stream"."~1.0.17" =
    self.by-version."readable-stream"."1.0.34";
  by-spec."readable-stream"."~1.0.26" =
    self.by-version."readable-stream"."1.0.34";
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.14";
  by-spec."readable-stream"."~2.0.5" =
    self.by-version."readable-stream"."2.0.6";
  by-version."readable-stream"."2.0.6" = self.buildNodePackage {
    name = "readable-stream-2.0.6";
    version = "2.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.0.6.tgz";
      name = "readable-stream-2.0.6.tgz";
      sha1 = "8f90341e68a53ccc928788dacfcd11b36eb9b78e";
    };
    deps = {
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
      "process-nextick-args-1.0.7" = self.by-version."process-nextick-args"."1.0.7";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."~2.1.4" =
    self.by-version."readable-stream"."2.1.5";
  by-version."readable-stream"."2.1.5" = self.buildNodePackage {
    name = "readable-stream-2.1.5";
    version = "2.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.1.5.tgz";
      name = "readable-stream-2.1.5.tgz";
      sha1 = "66fa8b720e1438b364681f2ad1a63c618448c9d0";
    };
    deps = {
      "buffer-shims-1.0.0" = self.by-version."buffer-shims"."1.0.0";
      "core-util-is-1.0.2" = self.by-version."core-util-is"."1.0.2";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "isarray-1.0.0" = self.by-version."isarray"."1.0.0";
      "process-nextick-args-1.0.7" = self.by-version."process-nextick-args"."1.0.7";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.2" = self.by-version."util-deprecate"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readdirp"."^2.0.0" =
    self.by-version."readdirp"."2.1.0";
  by-version."readdirp"."2.1.0" = self.buildNodePackage {
    name = "readdirp-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readdirp/-/readdirp-2.1.0.tgz";
      name = "readdirp-2.1.0.tgz";
      sha1 = "4ed0ad060df3073300c48440373f72d1cc642d78";
    };
    deps = {
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "readable-stream-2.2.2" = self.by-version."readable-stream"."2.2.2";
      "set-immediate-shim-1.0.1" = self.by-version."set-immediate-shim"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."redent"."^1.0.0" =
    self.by-version."redent"."1.0.0";
  by-version."redent"."1.0.0" = self.buildNodePackage {
    name = "redent-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/redent/-/redent-1.0.0.tgz";
      name = "redent-1.0.0.tgz";
      sha1 = "cf916ab1fd5f1f16dfb20822dd6ec7f730c2afde";
    };
    deps = {
      "indent-string-2.1.0" = self.by-version."indent-string"."2.1.0";
      "strip-indent-1.0.1" = self.by-version."strip-indent"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."regex-cache"."^0.4.2" =
    self.by-version."regex-cache"."0.4.3";
  by-version."regex-cache"."0.4.3" = self.buildNodePackage {
    name = "regex-cache-0.4.3";
    version = "0.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/regex-cache/-/regex-cache-0.4.3.tgz";
      name = "regex-cache-0.4.3.tgz";
      sha1 = "9b1a6c35d4d0dfcef5711ae651e8e9d3d7114145";
    };
    deps = {
      "is-equal-shallow-0.1.3" = self.by-version."is-equal-shallow"."0.1.3";
      "is-primitive-2.0.0" = self.by-version."is-primitive"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."relative-url"."^1.0.2" =
    self.by-version."relative-url"."1.0.2";
  by-version."relative-url"."1.0.2" = self.buildNodePackage {
    name = "relative-url-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/relative-url/-/relative-url-1.0.2.tgz";
      name = "relative-url-1.0.2.tgz";
      sha1 = "d21c52a72d6061018bcee9f9c9fc106bf7d65287";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."remark"."^3.2.2" =
    self.by-version."remark"."3.2.3";
  by-version."remark"."3.2.3" = self.buildNodePackage {
    name = "remark-3.2.3";
    version = "3.2.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/remark/-/remark-3.2.3.tgz";
      name = "remark-3.2.3.tgz";
      sha1 = "802a38c3aa98c9e1e3ea015eeba211d27cb65e1f";
    };
    deps = {
      "camelcase-2.1.1" = self.by-version."camelcase"."2.1.1";
      "ccount-1.0.1" = self.by-version."ccount"."1.0.1";
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "chokidar-1.6.1" = self.by-version."chokidar"."1.6.1";
      "collapse-white-space-1.0.2" = self.by-version."collapse-white-space"."1.0.2";
      "commander-2.9.0" = self.by-version."commander"."2.9.0";
      "concat-stream-1.6.0" = self.by-version."concat-stream"."1.6.0";
      "debug-2.6.0" = self.by-version."debug"."2.6.0";
      "elegant-spinner-1.0.1" = self.by-version."elegant-spinner"."1.0.1";
      "extend.js-0.0.2" = self.by-version."extend.js"."0.0.2";
      "glob-6.0.4" = self.by-version."glob"."6.0.4";
      "globby-4.1.0" = self.by-version."globby"."4.1.0";
      "he-0.5.0" = self.by-version."he"."0.5.0";
      "log-update-1.0.2" = self.by-version."log-update"."1.0.2";
      "longest-streak-1.0.0" = self.by-version."longest-streak"."1.0.0";
      "markdown-table-0.4.0" = self.by-version."markdown-table"."0.4.0";
      "minimatch-3.0.3" = self.by-version."minimatch"."3.0.3";
      "npm-prefix-1.2.0" = self.by-version."npm-prefix"."1.2.0";
      "parse-entities-1.1.0" = self.by-version."parse-entities"."1.1.0";
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
      "stringify-entities-1.3.0" = self.by-version."stringify-entities"."1.3.0";
      "to-vfile-1.0.0" = self.by-version."to-vfile"."1.0.0";
      "trim-0.0.1" = self.by-version."trim"."0.0.1";
      "trim-trailing-lines-1.1.0" = self.by-version."trim-trailing-lines"."1.1.0";
      "unified-2.1.4" = self.by-version."unified"."2.1.4";
      "user-home-2.0.0" = self.by-version."user-home"."2.0.0";
      "vfile-1.4.0" = self.by-version."vfile"."1.4.0";
      "vfile-find-down-1.0.0" = self.by-version."vfile-find-down"."1.0.0";
      "vfile-find-up-1.0.0" = self.by-version."vfile-find-up"."1.0.0";
      "vfile-reporter-1.5.0" = self.by-version."vfile-reporter"."1.5.0";
      "ware-1.3.0" = self.by-version."ware"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."remark-html"."^2.0.2" =
    self.by-version."remark-html"."2.0.2";
  by-version."remark-html"."2.0.2" = self.buildNodePackage {
    name = "remark-html-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/remark-html/-/remark-html-2.0.2.tgz";
      name = "remark-html-2.0.2.tgz";
      sha1 = "592a347bdd3d5881f4f080c98b5b152fb1407a92";
    };
    deps = {
      "collapse-white-space-1.0.2" = self.by-version."collapse-white-space"."1.0.2";
      "detab-1.0.2" = self.by-version."detab"."1.0.2";
      "normalize-uri-1.1.0" = self.by-version."normalize-uri"."1.1.0";
      "object-assign-4.1.0" = self.by-version."object-assign"."4.1.0";
      "trim-0.0.1" = self.by-version."trim"."0.0.1";
      "trim-lines-1.1.0" = self.by-version."trim-lines"."1.1.0";
      "unist-util-visit-1.1.1" = self.by-version."unist-util-visit"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."repeat-element"."^1.1.2" =
    self.by-version."repeat-element"."1.1.2";
  by-version."repeat-element"."1.1.2" = self.buildNodePackage {
    name = "repeat-element-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/repeat-element/-/repeat-element-1.1.2.tgz";
      name = "repeat-element-1.1.2.tgz";
      sha1 = "ef089a178d1483baae4d93eb98b4f9e4e11d990a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."repeat-string"."^1.5.0" =
    self.by-version."repeat-string"."1.6.1";
  by-version."repeat-string"."1.6.1" = self.buildNodePackage {
    name = "repeat-string-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/repeat-string/-/repeat-string-1.6.1.tgz";
      name = "repeat-string-1.6.1.tgz";
      sha1 = "8dcae470e1c88abc2d600fff4a776286da75e637";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."repeat-string"."^1.5.2" =
    self.by-version."repeat-string"."1.6.1";
  by-spec."repeating"."^2.0.0" =
    self.by-version."repeating"."2.0.1";
  by-version."repeating"."2.0.1" = self.buildNodePackage {
    name = "repeating-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/repeating/-/repeating-2.0.1.tgz";
      name = "repeating-2.0.1.tgz";
      sha1 = "5214c53a926d3552707527fbab415dbc08d06dda";
    };
    deps = {
      "is-finite-1.0.2" = self.by-version."is-finite"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2" =
    self.by-version."request"."2.79.0";
  by-version."request"."2.79.0" = self.buildNodePackage {
    name = "request-2.79.0";
    version = "2.79.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/request/-/request-2.79.0.tgz";
      name = "request-2.79.0.tgz";
      sha1 = "4dfe5bf6be8b8cdc37fcf93e04b65577722710de";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.5.0" = self.by-version."aws4"."1.5.0";
      "caseless-0.11.0" = self.by-version."caseless"."0.11.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-2.1.2" = self.by-version."form-data"."2.1.2";
      "har-validator-2.0.6" = self.by-version."har-validator"."2.0.6";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.13" = self.by-version."mime-types"."2.1.13";
      "oauth-sign-0.8.2" = self.by-version."oauth-sign"."0.8.2";
      "qs-6.3.0" = self.by-version."qs"."6.3.0";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.3.2" = self.by-version."tough-cookie"."2.3.2";
      "tunnel-agent-0.4.3" = self.by-version."tunnel-agent"."0.4.3";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.79.0" =
    self.by-version."request"."2.79.0";
  by-spec."resolve"."1.1.7" =
    self.by-version."resolve"."1.1.7";
  by-version."resolve"."1.1.7" = self.buildNodePackage {
    name = "resolve-1.1.7";
    version = "1.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resolve/-/resolve-1.1.7.tgz";
      name = "resolve-1.1.7.tgz";
      sha1 = "203114d82ad2c5ed9e8e0411b3932875e889e97b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."^1.1.3" =
    self.by-version."resolve"."1.2.0";
  by-version."resolve"."1.2.0" = self.buildNodePackage {
    name = "resolve-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resolve/-/resolve-1.2.0.tgz";
      name = "resolve-1.2.0.tgz";
      sha1 = "9589c3f2f6149d1417a40becc1663db6ec6bc26c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."^1.1.6" =
    self.by-version."resolve"."1.2.0";
  by-spec."restore-cursor"."^1.0.1" =
    self.by-version."restore-cursor"."1.0.1";
  by-version."restore-cursor"."1.0.1" = self.buildNodePackage {
    name = "restore-cursor-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/restore-cursor/-/restore-cursor-1.0.1.tgz";
      name = "restore-cursor-1.0.1.tgz";
      sha1 = "34661f46886327fed2991479152252df92daa541";
    };
    deps = {
      "exit-hook-1.1.1" = self.by-version."exit-hook"."1.1.1";
      "onetime-1.1.0" = self.by-version."onetime"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resumer"."~0.0.0" =
    self.by-version."resumer"."0.0.0";
  by-version."resumer"."0.0.0" = self.buildNodePackage {
    name = "resumer-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resumer/-/resumer-0.0.0.tgz";
      name = "resumer-0.0.0.tgz";
      sha1 = "f1e8f461e4064ba39e82af3cdc2a8c893d076759";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."2" =
    self.by-version."rimraf"."2.5.4";
  by-version."rimraf"."2.5.4" = self.buildNodePackage {
    name = "rimraf-2.5.4";
    version = "2.5.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.5.4.tgz";
      name = "rimraf-2.5.4.tgz";
      sha1 = "96800093cbf1a0c86bd95b4625467535c29dfa04";
    };
    deps = {
      "glob-7.1.1" = self.by-version."glob"."7.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."^2.4.2" =
    self.by-version."rimraf"."2.5.4";
  "rimraf" = self.by-version."rimraf"."2.5.4";
  by-spec."rimraf"."~2.2.8" =
    self.by-version."rimraf"."2.2.8";
  by-version."rimraf"."2.2.8" = self.buildNodePackage {
    name = "rimraf-2.2.8";
    version = "2.2.8";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
      name = "rimraf-2.2.8.tgz";
      sha1 = "e439be2aaee327321952730f99a8929e4fc50582";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."~2.3.4" =
    self.by-version."rimraf"."2.3.4";
  by-version."rimraf"."2.3.4" = self.buildNodePackage {
    name = "rimraf-2.3.4";
    version = "2.3.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.3.4.tgz";
      name = "rimraf-2.3.4.tgz";
      sha1 = "82d9bc1b2fcf31e205ac7b28138a025d08e9159a";
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
  by-spec."rimraf"."~2.4.0" =
    self.by-version."rimraf"."2.4.5";
  by-version."rimraf"."2.4.5" = self.buildNodePackage {
    name = "rimraf-2.4.5";
    version = "2.4.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rimraf/-/rimraf-2.4.5.tgz";
      name = "rimraf-2.4.5.tgz";
      sha1 = "ee710ce5d93a8fdb856fb5ea8ff0e2d75934b2da";
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
  by-spec."rimraf"."~2.5.1" =
    self.by-version."rimraf"."2.5.4";
  by-spec."rimraf"."~2.5.4" =
    self.by-version."rimraf"."2.5.4";
  by-spec."secret-handshake"."^1.1.1" =
    self.by-version."secret-handshake"."1.1.1";
  by-version."secret-handshake"."1.1.1" = self.buildNodePackage {
    name = "secret-handshake-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/secret-handshake/-/secret-handshake-1.1.1.tgz";
      name = "secret-handshake-1.1.1.tgz";
      sha1 = "5036a826cdd99ce7fedacae4b92ebc8913e8fedb";
    };
    deps = {
      "chloride-2.2.4" = self.by-version."chloride"."2.2.4";
      "deep-equal-1.0.1" = self.by-version."deep-equal"."1.0.1";
      "pull-box-stream-1.0.11" = self.by-version."pull-box-stream"."1.0.11";
      "pull-handshake-1.1.4" = self.by-version."pull-handshake"."1.1.4";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."secret-stack"."^3.2.0" =
    self.by-version."secret-stack"."3.2.0";
  by-version."secret-stack"."3.2.0" = self.buildNodePackage {
    name = "secret-stack-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/secret-stack/-/secret-stack-3.2.0.tgz";
      name = "secret-stack-3.2.0.tgz";
      sha1 = "751d146e174b31cee383fa3e83f2c099dbf708e3";
    };
    deps = {
      "hoox-0.0.1" = self.by-version."hoox"."0.0.1";
      "map-merge-1.1.0" = self.by-version."map-merge"."1.1.0";
      "multiserver-1.7.6" = self.by-version."multiserver"."1.7.6";
      "muxrpc-6.3.3" = self.by-version."muxrpc"."6.3.3";
      "non-private-ip-1.4.1" = self.by-version."non-private-ip"."1.4.1";
      "pull-inactivity-2.1.2" = self.by-version."pull-inactivity"."2.1.2";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "secret-stack" = self.by-version."secret-stack"."3.2.0";
  by-spec."secure-scuttlebutt"."^15.5.0" =
    self.by-version."secure-scuttlebutt"."15.5.1";
  by-version."secure-scuttlebutt"."15.5.1" = self.buildNodePackage {
    name = "secure-scuttlebutt-15.5.1";
    version = "15.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/secure-scuttlebutt/-/secure-scuttlebutt-15.5.1.tgz";
      name = "secure-scuttlebutt-15.5.1.tgz";
      sha1 = "87b21d5eb01bfa8447c500c3f669360bd8bd196d";
    };
    deps = {
      "bytewise-1.1.0" = self.by-version."bytewise"."1.1.0";
      "cont-1.0.3" = self.by-version."cont"."1.0.3";
      "deep-equal-0.2.2" = self.by-version."deep-equal"."0.2.2";
      "explain-error-1.0.3" = self.by-version."explain-error"."1.0.3";
      "level-1.5.0" = self.by-version."level"."1.5.0";
      "level-peek-2.0.2" = self.by-version."level-peek"."2.0.2";
      "level-sublevel-6.6.1" = self.by-version."level-sublevel"."6.6.1";
      "ltgt-2.0.0" = self.by-version."ltgt"."2.0.0";
      "monotonic-timestamp-0.0.9" = self.by-version."monotonic-timestamp"."0.0.9";
      "pull-cat-1.1.11" = self.by-version."pull-cat"."1.1.11";
      "pull-defer-0.2.2" = self.by-version."pull-defer"."0.2.2";
      "pull-level-2.0.3" = self.by-version."pull-level"."2.0.3";
      "pull-live-1.0.1" = self.by-version."pull-live"."1.0.1";
      "pull-notify-0.1.1" = self.by-version."pull-notify"."0.1.1";
      "pull-paramap-1.2.1" = self.by-version."pull-paramap"."1.2.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "pull-write-1.1.1" = self.by-version."pull-write"."1.1.1";
      "ssb-feed-2.3.0" = self.by-version."ssb-feed"."2.3.0";
      "ssb-keys-7.0.3" = self.by-version."ssb-keys"."7.0.3";
      "ssb-msgs-5.2.0" = self.by-version."ssb-msgs"."5.2.0";
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
      "stream-to-pull-stream-1.7.2" = self.by-version."stream-to-pull-stream"."1.7.2";
      "typewiselite-1.0.0" = self.by-version."typewiselite"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "secure-scuttlebutt" = self.by-version."secure-scuttlebutt"."15.5.1";
  by-spec."semver"."2 || 3 || 4 || 5" =
    self.by-version."semver"."5.3.0";
  by-version."semver"."5.3.0" = self.buildNodePackage {
    name = "semver-5.3.0";
    version = "5.3.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/semver/-/semver-5.3.0.tgz";
      name = "semver-5.3.0.tgz";
      sha1 = "9b2ce5d3de02d17c6012ad326aa6b4d0cf54f94f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver"."2.x || 3.x || 4 || 5" =
    self.by-version."semver"."5.3.0";
  by-spec."semver"."~4.3.3" =
    self.by-version."semver"."4.3.6";
  by-version."semver"."4.3.6" = self.buildNodePackage {
    name = "semver-4.3.6";
    version = "4.3.6";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/semver/-/semver-4.3.6.tgz";
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
  by-spec."semver"."~5.1.0" =
    self.by-version."semver"."5.1.1";
  by-version."semver"."5.1.1" = self.buildNodePackage {
    name = "semver-5.1.1";
    version = "5.1.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/semver/-/semver-5.1.1.tgz";
      name = "semver-5.1.1.tgz";
      sha1 = "a3292a373e6f3e0798da0b20641b9a9c5bc47e19";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver"."~5.3.0" =
    self.by-version."semver"."5.3.0";
  by-spec."separator-escape"."0.0.0" =
    self.by-version."separator-escape"."0.0.0";
  by-version."separator-escape"."0.0.0" = self.buildNodePackage {
    name = "separator-escape-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/separator-escape/-/separator-escape-0.0.0.tgz";
      name = "separator-escape-0.0.0.tgz";
      sha1 = "e433676932020454e3c14870c517ea1de56c2fa4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."set-blocking"."~2.0.0" =
    self.by-version."set-blocking"."2.0.0";
  by-version."set-blocking"."2.0.0" = self.buildNodePackage {
    name = "set-blocking-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/set-blocking/-/set-blocking-2.0.0.tgz";
      name = "set-blocking-2.0.0.tgz";
      sha1 = "045f9782d011ae9a6803ddd382b24392b3d890f7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."set-immediate-shim"."^1.0.1" =
    self.by-version."set-immediate-shim"."1.0.1";
  by-version."set-immediate-shim"."1.0.1" = self.buildNodePackage {
    name = "set-immediate-shim-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/set-immediate-shim/-/set-immediate-shim-1.0.1.tgz";
      name = "set-immediate-shim-1.0.1.tgz";
      sha1 = "4b2b1b27eb808a9f8dcc481a58e5e56f599f3f61";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sha.js"."2.4.5" =
    self.by-version."sha.js"."2.4.5";
  by-version."sha.js"."2.4.5" = self.buildNodePackage {
    name = "sha.js-2.4.5";
    version = "2.4.5";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sha.js/-/sha.js-2.4.5.tgz";
      name = "sha.js-2.4.5.tgz";
      sha1 = "27d171efcc82a118b99639ff581660242b506e7c";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sha.js"."^2.4.8" =
    self.by-version."sha.js"."2.4.8";
  by-version."sha.js"."2.4.8" = self.buildNodePackage {
    name = "sha.js-2.4.8";
    version = "2.4.8";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sha.js/-/sha.js-2.4.8.tgz";
      name = "sha.js-2.4.8.tgz";
      sha1 = "37068c2c476b6baf402d14a49c67f597921f634f";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."shellsubstitute"."^1.1.0" =
    self.by-version."shellsubstitute"."1.2.0";
  by-version."shellsubstitute"."1.2.0" = self.buildNodePackage {
    name = "shellsubstitute-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/shellsubstitute/-/shellsubstitute-1.2.0.tgz";
      name = "shellsubstitute-1.2.0.tgz";
      sha1 = "e4f702a50c518b0f6fe98451890d705af29b6b70";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.1";
  by-version."sigmund"."1.0.1" = self.buildNodePackage {
    name = "sigmund-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sigmund/-/sigmund-1.0.1.tgz";
      name = "sigmund-1.0.1.tgz";
      sha1 = "3ff21f198cad2175f9f3b781853fd94d0d19b590";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."signal-exit"."^3.0.0" =
    self.by-version."signal-exit"."3.0.2";
  by-version."signal-exit"."3.0.2" = self.buildNodePackage {
    name = "signal-exit-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/signal-exit/-/signal-exit-3.0.2.tgz";
      name = "signal-exit-3.0.2.tgz";
      sha1 = "b5fdc08f1287ea1178628e415e25132b73646c6d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."simple-get"."^1.4.2" =
    self.by-version."simple-get"."1.4.3";
  by-version."simple-get"."1.4.3" = self.buildNodePackage {
    name = "simple-get-1.4.3";
    version = "1.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/simple-get/-/simple-get-1.4.3.tgz";
      name = "simple-get-1.4.3.tgz";
      sha1 = "e9755eda407e96da40c5e5158c9ea37b33becbeb";
    };
    deps = {
      "once-1.4.0" = self.by-version."once"."1.4.0";
      "unzip-response-1.0.2" = self.by-version."unzip-response"."1.0.2";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."simple-mime"."~0.1.0" =
    self.by-version."simple-mime"."0.1.0";
  by-version."simple-mime"."0.1.0" = self.buildNodePackage {
    name = "simple-mime-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/simple-mime/-/simple-mime-0.1.0.tgz";
      name = "simple-mime-0.1.0.tgz";
      sha1 = "95f517c4f466d7cff561a71fc9dab2596ea9ef2e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."smart-buffer"."^1.0.4" =
    self.by-version."smart-buffer"."1.0.11";
  by-version."smart-buffer"."1.0.11" = self.buildNodePackage {
    name = "smart-buffer-1.0.11";
    version = "1.0.11";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/smart-buffer/-/smart-buffer-1.0.11.tgz";
      name = "smart-buffer-1.0.11.tgz";
      sha1 = "3050337098a8e4cdf0350fef63dd146049ff940a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sntp"."1.x.x" =
    self.by-version."sntp"."1.0.9";
  by-version."sntp"."1.0.9" = self.buildNodePackage {
    name = "sntp-1.0.9";
    version = "1.0.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
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
  by-spec."socks"."1.1.9" =
    self.by-version."socks"."1.1.9";
  by-version."socks"."1.1.9" = self.buildNodePackage {
    name = "socks-1.1.9";
    version = "1.1.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/socks/-/socks-1.1.9.tgz";
      name = "socks-1.1.9.tgz";
      sha1 = "628d7e4d04912435445ac0b6e459376cb3e6d691";
    };
    deps = {
      "ip-1.1.4" = self.by-version."ip"."1.1.4";
      "smart-buffer-1.0.11" = self.by-version."smart-buffer"."1.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sodium-browserify"."^1.0.3" =
    self.by-version."sodium-browserify"."1.2.1";
  by-version."sodium-browserify"."1.2.1" = self.buildNodePackage {
    name = "sodium-browserify-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sodium-browserify/-/sodium-browserify-1.2.1.tgz";
      name = "sodium-browserify-1.2.1.tgz";
      sha1 = "b0b559ca36981679085214855e26645df67aaf1c";
    };
    deps = {
      "libsodium-wrappers-0.2.12" = self.by-version."libsodium-wrappers"."0.2.12";
      "sha.js-2.4.5" = self.by-version."sha.js"."2.4.5";
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sodium-browserify-tweetnacl"."^0.2.0" =
    self.by-version."sodium-browserify-tweetnacl"."0.2.2";
  by-version."sodium-browserify-tweetnacl"."0.2.2" = self.buildNodePackage {
    name = "sodium-browserify-tweetnacl-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sodium-browserify-tweetnacl/-/sodium-browserify-tweetnacl-0.2.2.tgz";
      name = "sodium-browserify-tweetnacl-0.2.2.tgz";
      sha1 = "be422da1193d499d874bd63d3e2c1c76a30ee48f";
    };
    deps = {
      "chloride-test-1.1.1" = self.by-version."chloride-test"."1.1.1";
      "ed2curve-0.1.4" = self.by-version."ed2curve"."0.1.4";
      "sha.js-2.4.8" = self.by-version."sha.js"."2.4.8";
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
      "tweetnacl-auth-0.3.1" = self.by-version."tweetnacl-auth"."0.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sodium-prebuilt"."1.0.22" =
    self.by-version."sodium-prebuilt"."1.0.22";
  by-version."sodium-prebuilt"."1.0.22" = self.buildNodePackage {
    name = "sodium-prebuilt-1.0.22";
    version = "1.0.22";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sodium-prebuilt/-/sodium-prebuilt-1.0.22.tgz";
      name = "sodium-prebuilt-1.0.22.tgz";
      sha1 = "f4c806f1e69b0b20c557959aeb3afb9defd53f46";
    };
    deps = {
      "nan-2.5.0" = self.by-version."nan"."2.5.0";
      "prebuild-4.5.0" = self.by-version."prebuild"."4.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sort-stream"."^1.0.1" =
    self.by-version."sort-stream"."1.0.1";
  by-version."sort-stream"."1.0.1" = self.buildNodePackage {
    name = "sort-stream-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/sort-stream/-/sort-stream-1.0.1.tgz";
      name = "sort-stream-1.0.1.tgz";
      sha1 = "a30684c9c29ca333069c18d6a0ab0f768af61df2";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-correct"."~1.0.0" =
    self.by-version."spdx-correct"."1.0.2";
  by-version."spdx-correct"."1.0.2" = self.buildNodePackage {
    name = "spdx-correct-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/spdx-correct/-/spdx-correct-1.0.2.tgz";
      name = "spdx-correct-1.0.2.tgz";
      sha1 = "4b3073d933ff51f3912f03ac5519498a4150db40";
    };
    deps = {
      "spdx-license-ids-1.2.2" = self.by-version."spdx-license-ids"."1.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-expression-parse"."~1.0.0" =
    self.by-version."spdx-expression-parse"."1.0.4";
  by-version."spdx-expression-parse"."1.0.4" = self.buildNodePackage {
    name = "spdx-expression-parse-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/spdx-expression-parse/-/spdx-expression-parse-1.0.4.tgz";
      name = "spdx-expression-parse-1.0.4.tgz";
      sha1 = "9bdf2f20e1f40ed447fbe273266191fced51626c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."spdx-license-ids"."^1.0.2" =
    self.by-version."spdx-license-ids"."1.2.2";
  by-version."spdx-license-ids"."1.2.2" = self.buildNodePackage {
    name = "spdx-license-ids-1.2.2";
    version = "1.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/spdx-license-ids/-/spdx-license-ids-1.2.2.tgz";
      name = "spdx-license-ids-1.2.2.tgz";
      sha1 = "c9df7a3424594ade6bd11900d596696dc06bac57";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."split-buffer"."~1.0.0" =
    self.by-version."split-buffer"."1.0.0";
  by-version."split-buffer"."1.0.0" = self.buildNodePackage {
    name = "split-buffer-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/split-buffer/-/split-buffer-1.0.0.tgz";
      name = "split-buffer-1.0.0.tgz";
      sha1 = "b7e8e0ab51345158b72c1f6dbef2406d51f1d027";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-blobs"."^0.1.6" =
    self.by-version."ssb-blobs"."0.1.7";
  by-version."ssb-blobs"."0.1.7" = self.buildNodePackage {
    name = "ssb-blobs-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-blobs/-/ssb-blobs-0.1.7.tgz";
      name = "ssb-blobs-0.1.7.tgz";
      sha1 = "36b4798716a06531fb75584081522fcb25ecb924";
    };
    deps = {
      "cont-1.0.3" = self.by-version."cont"."1.0.3";
      "level-1.5.0" = self.by-version."level"."1.5.0";
      "multiblob-1.10.2" = self.by-version."multiblob"."1.10.2";
      "pull-level-1.5.2" = self.by-version."pull-level"."1.5.2";
      "pull-notify-0.1.1" = self.by-version."pull-notify"."0.1.1";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-blobs" = self.by-version."ssb-blobs"."0.1.7";
  by-spec."ssb-client"."^4.0.2" =
    self.by-version."ssb-client"."4.4.0";
  by-version."ssb-client"."4.4.0" = self.buildNodePackage {
    name = "ssb-client-4.4.0";
    version = "4.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-client/-/ssb-client-4.4.0.tgz";
      name = "ssb-client-4.4.0.tgz";
      sha1 = "b16ef95659e233cd4b978a83612d42b121c764ea";
    };
    deps = {
      "explain-error-1.0.3" = self.by-version."explain-error"."1.0.3";
      "multiserver-1.7.6" = self.by-version."multiserver"."1.7.6";
      "muxrpc-6.3.3" = self.by-version."muxrpc"."6.3.3";
      "ssb-config-2.2.0" = self.by-version."ssb-config"."2.2.0";
      "ssb-keys-6.1.2" = self.by-version."ssb-keys"."6.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-client" = self.by-version."ssb-client"."4.4.0";
  by-spec."ssb-config"."^2.0.0" =
    self.by-version."ssb-config"."2.2.0";
  by-version."ssb-config"."2.2.0" = self.buildNodePackage {
    name = "ssb-config-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-config/-/ssb-config-2.2.0.tgz";
      name = "ssb-config-2.2.0.tgz";
      sha1 = "41cad038a8575af4062d3fd57d3b167be85b03bc";
    };
    deps = {
      "deep-extend-0.4.1" = self.by-version."deep-extend"."0.4.1";
      "non-private-ip-1.4.1" = self.by-version."non-private-ip"."1.4.1";
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
      "rc-1.1.6" = self.by-version."rc"."1.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-config" = self.by-version."ssb-config"."2.2.0";
  by-spec."ssb-feed"."^2.2.1" =
    self.by-version."ssb-feed"."2.3.0";
  by-version."ssb-feed"."2.3.0" = self.buildNodePackage {
    name = "ssb-feed-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-feed/-/ssb-feed-2.3.0.tgz";
      name = "ssb-feed-2.3.0.tgz";
      sha1 = "b84e8e0297a0f5904c4cf5a202f76ba1e078d047";
    };
    deps = {
      "cont-1.0.3" = self.by-version."cont"."1.0.3";
      "monotonic-timestamp-0.0.9" = self.by-version."monotonic-timestamp"."0.0.9";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "ssb-keys-7.0.3" = self.by-version."ssb-keys"."7.0.3";
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-keys"."^6.0.0" =
    self.by-version."ssb-keys"."6.1.2";
  by-version."ssb-keys"."6.1.2" = self.buildNodePackage {
    name = "ssb-keys-6.1.2";
    version = "6.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-keys/-/ssb-keys-6.1.2.tgz";
      name = "ssb-keys-6.1.2.tgz";
      sha1 = "a56238e39c8553b19a4926626186c24058d0a0b1";
    };
    deps = {
      "blake2s-1.0.1" = self.by-version."blake2s"."1.0.1";
      "chloride-2.2.4" = self.by-version."chloride"."2.2.4";
      "deep-equal-0.2.2" = self.by-version."deep-equal"."0.2.2";
      "hmac-1.0.1" = self.by-version."hmac"."1.0.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "private-box-0.2.1" = self.by-version."private-box"."0.2.1";
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-keys"."^7.0.0" =
    self.by-version."ssb-keys"."7.0.3";
  by-version."ssb-keys"."7.0.3" = self.buildNodePackage {
    name = "ssb-keys-7.0.3";
    version = "7.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-keys/-/ssb-keys-7.0.3.tgz";
      name = "ssb-keys-7.0.3.tgz";
      sha1 = "2f7f509cd02503ec7a94dee221ae7f7b5f0f4a3a";
    };
    deps = {
      "chloride-2.2.4" = self.by-version."chloride"."2.2.4";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "private-box-0.2.1" = self.by-version."private-box"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-keys" = self.by-version."ssb-keys"."7.0.3";
  by-spec."ssb-msg-schemas"."~3.2.0" =
    self.by-version."ssb-msg-schemas"."3.2.1";
  by-version."ssb-msg-schemas"."3.2.1" = self.buildNodePackage {
    name = "ssb-msg-schemas-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-msg-schemas/-/ssb-msg-schemas-3.2.1.tgz";
      name = "ssb-msg-schemas-3.2.1.tgz";
      sha1 = "a322384be0b4609a7086ae304f89632f77121b30";
    };
    deps = {
      "pull-stream-2.27.0" = self.by-version."pull-stream"."2.27.0";
      "ssb-msgs-3.1.2" = self.by-version."ssb-msgs"."3.1.2";
      "ssb-ref-0.0.0" = self.by-version."ssb-ref"."0.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-msg-schemas" = self.by-version."ssb-msg-schemas"."3.2.1";
  by-spec."ssb-msgs"."^3.1.2" =
    self.by-version."ssb-msgs"."3.1.2";
  by-version."ssb-msgs"."3.1.2" = self.buildNodePackage {
    name = "ssb-msgs-3.1.2";
    version = "3.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-msgs/-/ssb-msgs-3.1.2.tgz";
      name = "ssb-msgs-3.1.2.tgz";
      sha1 = "5c32dd941b775a43f355705550ae2f57e1a5769d";
    };
    deps = {
      "ssb-ref-0.0.0" = self.by-version."ssb-ref"."0.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-msgs"."^5.0.0" =
    self.by-version."ssb-msgs"."5.2.0";
  by-version."ssb-msgs"."5.2.0" = self.buildNodePackage {
    name = "ssb-msgs-5.2.0";
    version = "5.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-msgs/-/ssb-msgs-5.2.0.tgz";
      name = "ssb-msgs-5.2.0.tgz";
      sha1 = "c681da5cd70c574c922dca4f03c521538135c243";
    };
    deps = {
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-msgs"."~5.0.0" =
    self.by-version."ssb-msgs"."5.0.0";
  by-version."ssb-msgs"."5.0.0" = self.buildNodePackage {
    name = "ssb-msgs-5.0.0";
    version = "5.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-msgs/-/ssb-msgs-5.0.0.tgz";
      name = "ssb-msgs-5.0.0.tgz";
      sha1 = "394829a67f2aa1b1232ff3aef89999cfacde1165";
    };
    deps = {
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-msgs" = self.by-version."ssb-msgs"."5.0.0";
  by-spec."ssb-ref"."^2.0.0" =
    self.by-version."ssb-ref"."2.6.2";
  by-version."ssb-ref"."2.6.2" = self.buildNodePackage {
    name = "ssb-ref-2.6.2";
    version = "2.6.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-ref/-/ssb-ref-2.6.2.tgz";
      name = "ssb-ref-2.6.2.tgz";
      sha1 = "2aa19f1036854c7165f960fa6f962f12f0605277";
    };
    deps = {
      "ip-1.1.4" = self.by-version."ip"."1.1.4";
      "is-valid-domain-0.0.2" = self.by-version."is-valid-domain"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-ref"."^2.3.0" =
    self.by-version."ssb-ref"."2.6.2";
  by-spec."ssb-ref"."^2.6.2" =
    self.by-version."ssb-ref"."2.6.2";
  "ssb-ref" = self.by-version."ssb-ref"."2.6.2";
  by-spec."ssb-ref"."~0.0.0" =
    self.by-version."ssb-ref"."0.0.0";
  by-version."ssb-ref"."0.0.0" = self.buildNodePackage {
    name = "ssb-ref-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-ref/-/ssb-ref-0.0.0.tgz";
      name = "ssb-ref-0.0.0.tgz";
      sha1 = "ab82712aeabed766a85056d016251848be9dc659";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-sort"."0.0.0" =
    self.by-version."ssb-sort"."0.0.0";
  by-version."ssb-sort"."0.0.0" = self.buildNodePackage {
    name = "ssb-sort-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-sort/-/ssb-sort-0.0.0.tgz";
      name = "ssb-sort-0.0.0.tgz";
      sha1 = "384c2eb3fa48cc46c5f11d596bf686619fa8979f";
    };
    deps = {
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ssb-ws"."^1.0.0" =
    self.by-version."ssb-ws"."1.0.1";
  by-version."ssb-ws"."1.0.1" = self.buildNodePackage {
    name = "ssb-ws-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ssb-ws/-/ssb-ws-1.0.1.tgz";
      name = "ssb-ws-1.0.1.tgz";
      sha1 = "595ffbb0fdffe0599bb66a480b116fbfa928978c";
    };
    deps = {
      "emoji-server-1.0.0" = self.by-version."emoji-server"."1.0.0";
      "multiblob-http-0.2.0" = self.by-version."multiblob-http"."0.2.0";
      "multiserver-1.7.6" = self.by-version."multiserver"."1.7.6";
      "muxrpc-6.3.3" = self.by-version."muxrpc"."6.3.3";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
      "ssb-ref-2.6.2" = self.by-version."ssb-ref"."2.6.2";
      "ssb-sort-0.0.0" = self.by-version."ssb-sort"."0.0.0";
      "stack-0.1.0" = self.by-version."stack"."0.1.0";
      "web-bootloader-0.1.2" = self.by-version."web-bootloader"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ssb-ws" = self.by-version."ssb-ws"."1.0.1";
  by-spec."sshpk"."^1.7.0" =
    self.by-version."sshpk"."1.10.1";
  by-version."sshpk"."1.10.1" = self.buildNodePackage {
    name = "sshpk-1.10.1";
    version = "1.10.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sshpk/-/sshpk-1.10.1.tgz";
      name = "sshpk-1.10.1.tgz";
      sha1 = "30e1a5d329244974a1af61511339d595af6638b0";
    };
    deps = {
      "asn1-0.2.3" = self.by-version."asn1"."0.2.3";
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
      "dashdash-1.14.1" = self.by-version."dashdash"."1.14.1";
      "getpass-0.1.6" = self.by-version."getpass"."0.1.6";
    };
    optionalDependencies = {
      "jsbn-0.1.0" = self.by-version."jsbn"."0.1.0";
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
      "jodid25519-1.0.2" = self.by-version."jodid25519"."1.0.2";
      "ecc-jsbn-0.1.1" = self.by-version."ecc-jsbn"."0.1.1";
      "bcrypt-pbkdf-1.0.0" = self.by-version."bcrypt-pbkdf"."1.0.0";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stack"."^0.1.0" =
    self.by-version."stack"."0.1.0";
  by-version."stack"."0.1.0" = self.buildNodePackage {
    name = "stack-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stack/-/stack-0.1.0.tgz";
      name = "stack-0.1.0.tgz";
      sha1 = "e923598a9be51e617682cb21cf1b2818a449ada2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."statistics"."^3.0.0" =
    self.by-version."statistics"."3.3.0";
  by-version."statistics"."3.3.0" = self.buildNodePackage {
    name = "statistics-3.3.0";
    version = "3.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/statistics/-/statistics-3.3.0.tgz";
      name = "statistics-3.3.0.tgz";
      sha1 = "ec7b4750ff03ab24a64dd9b357a78316bead78aa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "statistics" = self.by-version."statistics"."3.3.0";
  by-spec."statistics"."^3.3.0" =
    self.by-version."statistics"."3.3.0";
  by-spec."stream-combiner2"."~1.0.0" =
    self.by-version."stream-combiner2"."1.0.2";
  by-version."stream-combiner2"."1.0.2" = self.buildNodePackage {
    name = "stream-combiner2-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stream-combiner2/-/stream-combiner2-1.0.2.tgz";
      name = "stream-combiner2-1.0.2.tgz";
      sha1 = "ba72a6b50cbfabfa950fc8bc87604bd01eb60671";
    };
    deps = {
      "duplexer2-0.0.2" = self.by-version."duplexer2"."0.0.2";
      "through2-0.5.1" = self.by-version."through2"."0.5.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-to-pull-stream"."1.3" =
    self.by-version."stream-to-pull-stream"."1.3.1";
  by-version."stream-to-pull-stream"."1.3.1" = self.buildNodePackage {
    name = "stream-to-pull-stream-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stream-to-pull-stream/-/stream-to-pull-stream-1.3.1.tgz";
      name = "stream-to-pull-stream-1.3.1.tgz";
      sha1 = "f5be9be0f1e94bb3d1ae668bff8e9251b85a6c6e";
    };
    deps = {
      "pull-core-1.0.0" = self.by-version."pull-core"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-to-pull-stream"."^1.6.1" =
    self.by-version."stream-to-pull-stream"."1.7.2";
  by-version."stream-to-pull-stream"."1.7.2" = self.buildNodePackage {
    name = "stream-to-pull-stream-1.7.2";
    version = "1.7.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stream-to-pull-stream/-/stream-to-pull-stream-1.7.2.tgz";
      name = "stream-to-pull-stream-1.7.2.tgz";
      sha1 = "757609ae1cebd33c7432d4afbe31ff78650b9dde";
    };
    deps = {
      "looper-3.0.0" = self.by-version."looper"."3.0.0";
      "pull-stream-3.5.0" = self.by-version."pull-stream"."3.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."stream-to-pull-stream"."^1.6.10" =
    self.by-version."stream-to-pull-stream"."1.7.2";
  "stream-to-pull-stream" = self.by-version."stream-to-pull-stream"."1.7.2";
  by-spec."stream-to-pull-stream"."^1.6.6" =
    self.by-version."stream-to-pull-stream"."1.7.2";
  by-spec."stream-to-pull-stream"."^1.7.0" =
    self.by-version."stream-to-pull-stream"."1.7.2";
  by-spec."stream-to-pull-stream"."^1.7.1" =
    self.by-version."stream-to-pull-stream"."1.7.2";
  by-spec."stream-to-pull-stream"."^1.7.2" =
    self.by-version."stream-to-pull-stream"."1.7.2";
  by-spec."string-width"."^1.0.0" =
    self.by-version."string-width"."1.0.2";
  by-version."string-width"."1.0.2" = self.buildNodePackage {
    name = "string-width-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/string-width/-/string-width-1.0.2.tgz";
      name = "string-width-1.0.2.tgz";
      sha1 = "118bdf5b8cdc51a2a7e70d211e07e2b0b9b107d3";
    };
    deps = {
      "code-point-at-1.1.0" = self.by-version."code-point-at"."1.1.0";
      "is-fullwidth-code-point-1.0.0" = self.by-version."is-fullwidth-code-point"."1.0.0";
      "strip-ansi-3.0.1" = self.by-version."strip-ansi"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string-width"."^1.0.1" =
    self.by-version."string-width"."1.0.2";
  by-spec."string_decoder"."~0.10.x" =
    self.by-version."string_decoder"."0.10.31";
  by-version."string_decoder"."0.10.31" = self.buildNodePackage {
    name = "string_decoder-0.10.31";
    version = "0.10.31";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/string_decoder/-/string_decoder-0.10.31.tgz";
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
  by-spec."stringify-entities"."^1.0.0" =
    self.by-version."stringify-entities"."1.3.0";
  by-version."stringify-entities"."1.3.0" = self.buildNodePackage {
    name = "stringify-entities-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/stringify-entities/-/stringify-entities-1.3.0.tgz";
      name = "stringify-entities-1.3.0.tgz";
      sha1 = "2244a516c4f1e8e01b73dad01023016776abd917";
    };
    deps = {
      "character-entities-html4-1.1.0" = self.by-version."character-entities-html4"."1.1.0";
      "character-entities-legacy-1.1.0" = self.by-version."character-entities-legacy"."1.1.0";
      "has-1.0.1" = self.by-version."has"."1.0.1";
      "is-alphanumerical-1.0.0" = self.by-version."is-alphanumerical"."1.0.0";
      "is-hexadecimal-1.0.0" = self.by-version."is-hexadecimal"."1.0.0";
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
      url = "https://registry.npmjs.org/stringstream/-/stringstream-0.0.5.tgz";
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
    self.by-version."strip-ansi"."3.0.1";
  by-version."strip-ansi"."3.0.1" = self.buildNodePackage {
    name = "strip-ansi-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-ansi/-/strip-ansi-3.0.1.tgz";
      name = "strip-ansi-3.0.1.tgz";
      sha1 = "6a385fb8853d952d5ff05d0e8aaf94278dc63dcf";
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
  by-spec."strip-ansi"."^3.0.1" =
    self.by-version."strip-ansi"."3.0.1";
  by-spec."strip-bom"."^2.0.0" =
    self.by-version."strip-bom"."2.0.0";
  by-version."strip-bom"."2.0.0" = self.buildNodePackage {
    name = "strip-bom-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-bom/-/strip-bom-2.0.0.tgz";
      name = "strip-bom-2.0.0.tgz";
      sha1 = "6219a85616520491f35788bdbf1447a99c7e6b0e";
    };
    deps = {
      "is-utf8-0.2.1" = self.by-version."is-utf8"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-indent"."^1.0.1" =
    self.by-version."strip-indent"."1.0.1";
  by-version."strip-indent"."1.0.1" = self.buildNodePackage {
    name = "strip-indent-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-indent/-/strip-indent-1.0.1.tgz";
      name = "strip-indent-1.0.1.tgz";
      sha1 = "0c7962a6adefa7bbd4ac366460a638552ae1a0a2";
    };
    deps = {
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-json-comments"."0.1.x" =
    self.by-version."strip-json-comments"."0.1.3";
  by-version."strip-json-comments"."0.1.3" = self.buildNodePackage {
    name = "strip-json-comments-0.1.3";
    version = "0.1.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-0.1.3.tgz";
      name = "strip-json-comments-0.1.3.tgz";
      sha1 = "164c64e370a8a3cc00c9e01b539e569823f0ee54";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-json-comments"."~1.0.4" =
    self.by-version."strip-json-comments"."1.0.4";
  by-version."strip-json-comments"."1.0.4" = self.buildNodePackage {
    name = "strip-json-comments-1.0.4";
    version = "1.0.4";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-1.0.4.tgz";
      name = "strip-json-comments-1.0.4.tgz";
      sha1 = "1e15fbcac97d3ee99bf2d73b4c656b082bbafb91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."subarg"."^1.0.0" =
    self.by-version."subarg"."1.0.0";
  by-version."subarg"."1.0.0" = self.buildNodePackage {
    name = "subarg-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/subarg/-/subarg-1.0.0.tgz";
      name = "subarg-1.0.0.tgz";
      sha1 = "f62cf17581e996b48fc965699f54c06ae268b8d2";
    };
    deps = {
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."supports-color"."^0.2.0" =
    self.by-version."supports-color"."0.2.0";
  by-version."supports-color"."0.2.0" = self.buildNodePackage {
    name = "supports-color-0.2.0";
    version = "0.2.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/supports-color/-/supports-color-0.2.0.tgz";
      name = "supports-color-0.2.0.tgz";
      sha1 = "d92de2694eb3f67323973d7ae3d8b55b4c22190a";
    };
    deps = {
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
      url = "https://registry.npmjs.org/supports-color/-/supports-color-2.0.0.tgz";
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
  by-spec."tape"."~2.10.2" =
    self.by-version."tape"."2.10.3";
  by-version."tape"."2.10.3" = self.buildNodePackage {
    name = "tape-2.10.3";
    version = "2.10.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/tape/-/tape-2.10.3.tgz";
      name = "tape-2.10.3.tgz";
      sha1 = "1d866f42d46f211baae28c290d30d4e9570c7938";
    };
    deps = {
      "deep-equal-0.2.2" = self.by-version."deep-equal"."0.2.2";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "object-inspect-0.3.1" = self.by-version."object-inspect"."0.3.1";
      "resumer-0.0.0" = self.by-version."resumer"."0.0.0";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tape"."~4.0.0" =
    self.by-version."tape"."4.0.3";
  by-version."tape"."4.0.3" = self.buildNodePackage {
    name = "tape-4.0.3";
    version = "4.0.3";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/tape/-/tape-4.0.3.tgz";
      name = "tape-4.0.3.tgz";
      sha1 = "c7f2905d51c54702324252ae6c8302443a3cb2b1";
    };
    deps = {
      "deep-equal-1.0.1" = self.by-version."deep-equal"."1.0.1";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "glob-5.0.15" = self.by-version."glob"."5.0.15";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "object-inspect-1.0.2" = self.by-version."object-inspect"."1.0.2";
      "resumer-0.0.0" = self.by-version."resumer"."0.0.0";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "tape" = self.by-version."tape"."4.0.3";
  by-spec."tar"."^2.0.0" =
    self.by-version."tar"."2.2.1";
  by-version."tar"."2.2.1" = self.buildNodePackage {
    name = "tar-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar/-/tar-2.2.1.tgz";
      name = "tar-2.2.1.tgz";
      sha1 = "8e4d2a256c0e2185c6b18ad694aec968b83cb1d1";
    };
    deps = {
      "block-stream-0.0.9" = self.by-version."block-stream"."0.0.9";
      "fstream-1.0.10" = self.by-version."fstream"."1.0.10";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar"."~2.2.1" =
    self.by-version."tar"."2.2.1";
  by-spec."tar-fs"."^1.7.0" =
    self.by-version."tar-fs"."1.15.0";
  by-version."tar-fs"."1.15.0" = self.buildNodePackage {
    name = "tar-fs-1.15.0";
    version = "1.15.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar-fs/-/tar-fs-1.15.0.tgz";
      name = "tar-fs-1.15.0.tgz";
      sha1 = "74c97dc773737c2aeacbfff246c654d6528a5315";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "pump-1.0.2" = self.by-version."pump"."1.0.2";
      "tar-stream-1.5.2" = self.by-version."tar-stream"."1.5.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-pack"."~3.3.0" =
    self.by-version."tar-pack"."3.3.0";
  by-version."tar-pack"."3.3.0" = self.buildNodePackage {
    name = "tar-pack-3.3.0";
    version = "3.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar-pack/-/tar-pack-3.3.0.tgz";
      name = "tar-pack-3.3.0.tgz";
      sha1 = "30931816418f55afc4d21775afdd6720cee45dae";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "fstream-1.0.10" = self.by-version."fstream"."1.0.10";
      "fstream-ignore-1.0.5" = self.by-version."fstream-ignore"."1.0.5";
      "once-1.3.3" = self.by-version."once"."1.3.3";
      "readable-stream-2.1.5" = self.by-version."readable-stream"."2.1.5";
      "rimraf-2.5.4" = self.by-version."rimraf"."2.5.4";
      "tar-2.2.1" = self.by-version."tar"."2.2.1";
      "uid-number-0.0.6" = self.by-version."uid-number"."0.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-stream"."^1.1.2" =
    self.by-version."tar-stream"."1.5.2";
  by-version."tar-stream"."1.5.2" = self.buildNodePackage {
    name = "tar-stream-1.5.2";
    version = "1.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar-stream/-/tar-stream-1.5.2.tgz";
      name = "tar-stream-1.5.2.tgz";
      sha1 = "fbc6c6e83c1a19d4cb48c7d96171fc248effc7bf";
    };
    deps = {
      "bl-1.2.0" = self.by-version."bl"."1.2.0";
      "end-of-stream-1.1.0" = self.by-version."end-of-stream"."1.1.0";
      "readable-stream-2.2.2" = self.by-version."readable-stream"."2.2.2";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-stream"."^1.2.1" =
    self.by-version."tar-stream"."1.5.2";
  by-spec."text-table"."^0.2.0" =
    self.by-version."text-table"."0.2.0";
  by-version."text-table"."0.2.0" = self.buildNodePackage {
    name = "text-table-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/text-table/-/text-table-0.2.0.tgz";
      name = "text-table-0.2.0.tgz";
      sha1 = "7f5ee823ae805207c00af2df4a84ec3fcfa570b4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through".">=2.2.7 <3" =
    self.by-version."through"."2.3.8";
  by-version."through"."2.3.8" = self.buildNodePackage {
    name = "through-2.3.8";
    version = "2.3.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through/-/through-2.3.8.tgz";
      name = "through-2.3.8.tgz";
      sha1 = "0dd4c9ffaabc357960b1b724115d7e0e86a2e1f5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through"."~2.3.1" =
    self.by-version."through"."2.3.8";
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.8";
  by-spec."through2"."^1.0.0" =
    self.by-version."through2"."1.1.1";
  by-version."through2"."1.1.1" = self.buildNodePackage {
    name = "through2-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-1.1.1.tgz";
      name = "through2-1.1.1.tgz";
      sha1 = "0847cbc4449f3405574dbdccd9bb841b83ac3545";
    };
    deps = {
      "readable-stream-1.1.14" = self.by-version."readable-stream"."1.1.14";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through2"."^2.0.0" =
    self.by-version."through2"."2.0.3";
  by-version."through2"."2.0.3" = self.buildNodePackage {
    name = "through2-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-2.0.3.tgz";
      name = "through2-2.0.3.tgz";
      sha1 = "0004569b37c7c74ba39c43f3ced78d1ad94140be";
    };
    deps = {
      "readable-stream-2.2.2" = self.by-version."readable-stream"."2.2.2";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through2"."~0.5.1" =
    self.by-version."through2"."0.5.1";
  by-version."through2"."0.5.1" = self.buildNodePackage {
    name = "through2-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-0.5.1.tgz";
      name = "through2-0.5.1.tgz";
      sha1 = "dfdd012eb9c700e2323fd334f38ac622ab372da7";
    };
    deps = {
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
      "xtend-3.0.0" = self.by-version."xtend"."3.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through2"."~0.6.3" =
    self.by-version."through2"."0.6.5";
  by-version."through2"."0.6.5" = self.buildNodePackage {
    name = "through2-0.6.5";
    version = "0.6.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/through2/-/through2-0.6.5.tgz";
      name = "through2-0.6.5.tgz";
      sha1 = "41ab9c67b29d57209071410e1d7a7a968cd3ad48";
    };
    deps = {
      "readable-stream-1.0.34" = self.by-version."readable-stream"."1.0.34";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."to-utf8"."0.0.1" =
    self.by-version."to-utf8"."0.0.1";
  by-version."to-utf8"."0.0.1" = self.buildNodePackage {
    name = "to-utf8-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/to-utf8/-/to-utf8-0.0.1.tgz";
      name = "to-utf8-0.0.1.tgz";
      sha1 = "d17aea72ff2fba39b9e43601be7b3ff72e089852";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."to-vfile"."^1.0.0" =
    self.by-version."to-vfile"."1.0.0";
  by-version."to-vfile"."1.0.0" = self.buildNodePackage {
    name = "to-vfile-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/to-vfile/-/to-vfile-1.0.0.tgz";
      name = "to-vfile-1.0.0.tgz";
      sha1 = "88defecd43adb2ef598625f0e3d59f7f342941ba";
    };
    deps = {
      "vfile-1.4.0" = self.by-version."vfile"."1.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie"."~2.3.0" =
    self.by-version."tough-cookie"."2.3.2";
  by-version."tough-cookie"."2.3.2" = self.buildNodePackage {
    name = "tough-cookie-2.3.2";
    version = "2.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tough-cookie/-/tough-cookie-2.3.2.tgz";
      name = "tough-cookie-2.3.2.tgz";
      sha1 = "f081f76e4c85720e6c37a5faced737150d84072a";
    };
    deps = {
      "punycode-1.4.1" = self.by-version."punycode"."1.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."trim"."0.0.1" =
    self.by-version."trim"."0.0.1";
  by-version."trim"."0.0.1" = self.buildNodePackage {
    name = "trim-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/trim/-/trim-0.0.1.tgz";
      name = "trim-0.0.1.tgz";
      sha1 = "5858547f6b290757ee95cccc666fb50084c460dd";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."trim"."^0.0.1" =
    self.by-version."trim"."0.0.1";
  by-spec."trim-lines"."^1.0.0" =
    self.by-version."trim-lines"."1.1.0";
  by-version."trim-lines"."1.1.0" = self.buildNodePackage {
    name = "trim-lines-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/trim-lines/-/trim-lines-1.1.0.tgz";
      name = "trim-lines-1.1.0.tgz";
      sha1 = "9926d03ede13ba18f7d42222631fb04c79ff26fe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."trim-newlines"."^1.0.0" =
    self.by-version."trim-newlines"."1.0.0";
  by-version."trim-newlines"."1.0.0" = self.buildNodePackage {
    name = "trim-newlines-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/trim-newlines/-/trim-newlines-1.0.0.tgz";
      name = "trim-newlines-1.0.0.tgz";
      sha1 = "5887966bb582a4503a41eb524f7d35011815a613";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."trim-trailing-lines"."^1.0.0" =
    self.by-version."trim-trailing-lines"."1.1.0";
  by-version."trim-trailing-lines"."1.1.0" = self.buildNodePackage {
    name = "trim-trailing-lines-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/trim-trailing-lines/-/trim-trailing-lines-1.1.0.tgz";
      name = "trim-trailing-lines-1.1.0.tgz";
      sha1 = "7aefbb7808df9d669f6da2e438cac8c46ada7684";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tunnel-agent"."~0.4.1" =
    self.by-version."tunnel-agent"."0.4.3";
  by-version."tunnel-agent"."0.4.3" = self.buildNodePackage {
    name = "tunnel-agent-0.4.3";
    version = "0.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.3.tgz";
      name = "tunnel-agent-0.4.3.tgz";
      sha1 = "6373db76909fe570e08d73583365ed828a74eeeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."0.x.x" =
    self.by-version."tweetnacl"."0.14.5";
  by-version."tweetnacl"."0.14.5" = self.buildNodePackage {
    name = "tweetnacl-0.14.5";
    version = "0.14.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tweetnacl/-/tweetnacl-0.14.5.tgz";
      name = "tweetnacl-0.14.5.tgz";
      sha1 = "5ae68177f192d4456269d108afa93ff8743f4f64";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."^0.14.1" =
    self.by-version."tweetnacl"."0.14.5";
  by-spec."tweetnacl"."^0.14.3" =
    self.by-version."tweetnacl"."0.14.5";
  by-spec."tweetnacl"."~0.14.0" =
    self.by-version."tweetnacl"."0.14.5";
  by-spec."tweetnacl-auth"."^0.3.0" =
    self.by-version."tweetnacl-auth"."0.3.1";
  by-version."tweetnacl-auth"."0.3.1" = self.buildNodePackage {
    name = "tweetnacl-auth-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tweetnacl-auth/-/tweetnacl-auth-0.3.1.tgz";
      name = "tweetnacl-auth-0.3.1.tgz";
      sha1 = "b75bc2df15649bb84e8b9aa3c0669c6c4bce0d25";
    };
    deps = {
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typedarray"."^0.0.6" =
    self.by-version."typedarray"."0.0.6";
  by-version."typedarray"."0.0.6" = self.buildNodePackage {
    name = "typedarray-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
      name = "typedarray-0.0.6.tgz";
      sha1 = "867ac74e3864187b1d3d47d996a78ec5c8830777";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typedarray"."~0.0.5" =
    self.by-version."typedarray"."0.0.6";
  by-spec."typedarray-to-buffer"."~1.0.0" =
    self.by-version."typedarray-to-buffer"."1.0.4";
  by-version."typedarray-to-buffer"."1.0.4" = self.buildNodePackage {
    name = "typedarray-to-buffer-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/typedarray-to-buffer/-/typedarray-to-buffer-1.0.4.tgz";
      name = "typedarray-to-buffer-1.0.4.tgz";
      sha1 = "9bb8ba0e841fb3f4cf1fe7c245e9f3fa8a5fe99c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typewise"."^1.0.3" =
    self.by-version."typewise"."1.0.3";
  by-version."typewise"."1.0.3" = self.buildNodePackage {
    name = "typewise-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/typewise/-/typewise-1.0.3.tgz";
      name = "typewise-1.0.3.tgz";
      sha1 = "1067936540af97937cc5dcf9922486e9fa284651";
    };
    deps = {
      "typewise-core-1.2.0" = self.by-version."typewise-core"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typewise-core"."^1.2" =
    self.by-version."typewise-core"."1.2.0";
  by-version."typewise-core"."1.2.0" = self.buildNodePackage {
    name = "typewise-core-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/typewise-core/-/typewise-core-1.2.0.tgz";
      name = "typewise-core-1.2.0.tgz";
      sha1 = "97eb91805c7f55d2f941748fa50d315d991ef195";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typewise-core"."^1.2.0" =
    self.by-version."typewise-core"."1.2.0";
  by-spec."typewiselite"."^1.0.0" =
    self.by-version."typewiselite"."1.0.0";
  by-version."typewiselite"."1.0.0" = self.buildNodePackage {
    name = "typewiselite-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/typewiselite/-/typewiselite-1.0.0.tgz";
      name = "typewiselite-1.0.0.tgz";
      sha1 = "c8882fa1bb1092c06005a97f34ef5c8508e3664e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typewiselite"."~1.0.0" =
    self.by-version."typewiselite"."1.0.0";
  by-spec."uid-number"."~0.0.6" =
    self.by-version."uid-number"."0.0.6";
  by-version."uid-number"."0.0.6" = self.buildNodePackage {
    name = "uid-number-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/uid-number/-/uid-number-0.0.6.tgz";
      name = "uid-number-0.0.6.tgz";
      sha1 = "0ea10e8035e8eb5b8e4449f06da1c730663baa81";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ultron"."1.0.x" =
    self.by-version."ultron"."1.0.2";
  by-version."ultron"."1.0.2" = self.buildNodePackage {
    name = "ultron-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ultron/-/ultron-1.0.2.tgz";
      name = "ultron-1.0.2.tgz";
      sha1 = "ace116ab557cd197386a4e88f4685378c8b2e4fa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unherit"."^1.0.0" =
    self.by-version."unherit"."1.1.0";
  by-version."unherit"."1.1.0" = self.buildNodePackage {
    name = "unherit-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unherit/-/unherit-1.1.0.tgz";
      name = "unherit-1.1.0.tgz";
      sha1 = "6b9aaedfbf73df1756ad9e316dd981885840cd7d";
    };
    deps = {
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unherit"."^1.0.4" =
    self.by-version."unherit"."1.1.0";
  by-spec."unified"."^2.0.0" =
    self.by-version."unified"."2.1.4";
  by-version."unified"."2.1.4" = self.buildNodePackage {
    name = "unified-2.1.4";
    version = "2.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unified/-/unified-2.1.4.tgz";
      name = "unified-2.1.4.tgz";
      sha1 = "14bc6cd40d98ffff75b405506bad873ecbbac3ba";
    };
    deps = {
      "attach-ware-1.1.1" = self.by-version."attach-ware"."1.1.1";
      "bail-1.0.1" = self.by-version."bail"."1.0.1";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "unherit-1.1.0" = self.by-version."unherit"."1.1.0";
      "vfile-1.4.0" = self.by-version."vfile"."1.4.0";
      "ware-1.3.0" = self.by-version."ware"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unique-random"."^1.0.0" =
    self.by-version."unique-random"."1.0.0";
  by-version."unique-random"."1.0.0" = self.buildNodePackage {
    name = "unique-random-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unique-random/-/unique-random-1.0.0.tgz";
      name = "unique-random-1.0.0.tgz";
      sha1 = "ce3e224c8242cd33a0e77b0d7180d77e6b62d0c4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unique-random-array"."^1.0.0" =
    self.by-version."unique-random-array"."1.0.0";
  by-version."unique-random-array"."1.0.0" = self.buildNodePackage {
    name = "unique-random-array-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unique-random-array/-/unique-random-array-1.0.0.tgz";
      name = "unique-random-array-1.0.0.tgz";
      sha1 = "42b3721c579388d8b667c93c2dbde3d5d81a9136";
    };
    deps = {
      "unique-random-1.0.0" = self.by-version."unique-random"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unist-util-visit"."^1.0.0" =
    self.by-version."unist-util-visit"."1.1.1";
  by-version."unist-util-visit"."1.1.1" = self.buildNodePackage {
    name = "unist-util-visit-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unist-util-visit/-/unist-util-visit-1.1.1.tgz";
      name = "unist-util-visit-1.1.1.tgz";
      sha1 = "e917a3b137658b335cb4420c7da2e74d928e4e94";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."untildify"."^2.1.0" =
    self.by-version."untildify"."2.1.0";
  by-version."untildify"."2.1.0" = self.buildNodePackage {
    name = "untildify-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/untildify/-/untildify-2.1.0.tgz";
      name = "untildify-2.1.0.tgz";
      sha1 = "17eb2807987f76952e9c0485fc311d06a826a2e0";
    };
    deps = {
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unzip-response"."^1.0.0" =
    self.by-version."unzip-response"."1.0.2";
  by-version."unzip-response"."1.0.2" = self.buildNodePackage {
    name = "unzip-response-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unzip-response/-/unzip-response-1.0.2.tgz";
      name = "unzip-response-1.0.2.tgz";
      sha1 = "b984f0877fc0a89c2c773cc1ef7b5b232b5b06fe";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."url-template"."~2.0.6" =
    self.by-version."url-template"."2.0.8";
  by-version."url-template"."2.0.8" = self.buildNodePackage {
    name = "url-template-2.0.8";
    version = "2.0.8";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/url-template/-/url-template-2.0.8.tgz";
      name = "url-template-2.0.8.tgz";
      sha1 = "fc565a3cccbff7730c775f5641f9555791439f21";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."user-home"."^2.0.0" =
    self.by-version."user-home"."2.0.0";
  by-version."user-home"."2.0.0" = self.buildNodePackage {
    name = "user-home-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/user-home/-/user-home-2.0.0.tgz";
      name = "user-home-2.0.0.tgz";
      sha1 = "9c70bfd8169bc1dcbf48604e0f04b8b49cde9e9f";
    };
    deps = {
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
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
      url = "https://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.2.tgz";
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
  by-spec."util-extend"."^1.0.1" =
    self.by-version."util-extend"."1.0.3";
  by-version."util-extend"."1.0.3" = self.buildNodePackage {
    name = "util-extend-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/util-extend/-/util-extend-1.0.3.tgz";
      name = "util-extend-1.0.3.tgz";
      sha1 = "a7c216d267545169637b3b6edc6ca9119e2ff93f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uuid"."^3.0.0" =
    self.by-version."uuid"."3.0.1";
  by-version."uuid"."3.0.1" = self.buildNodePackage {
    name = "uuid-3.0.1";
    version = "3.0.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/uuid/-/uuid-3.0.1.tgz";
      name = "uuid-3.0.1.tgz";
      sha1 = "6544bba2dfda8c1cf17e629a3a305e2bb1fee6c1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."validate-npm-package-license"."^3.0.1" =
    self.by-version."validate-npm-package-license"."3.0.1";
  by-version."validate-npm-package-license"."3.0.1" = self.buildNodePackage {
    name = "validate-npm-package-license-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/validate-npm-package-license/-/validate-npm-package-license-3.0.1.tgz";
      name = "validate-npm-package-license-3.0.1.tgz";
      sha1 = "2804babe712ad3379459acfbe24746ab2c303fbc";
    };
    deps = {
      "spdx-correct-1.0.2" = self.by-version."spdx-correct"."1.0.2";
      "spdx-expression-parse-1.0.4" = self.by-version."spdx-expression-parse"."1.0.4";
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
      url = "https://registry.npmjs.org/verror/-/verror-1.3.6.tgz";
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
  by-spec."vfile"."^1.0.0" =
    self.by-version."vfile"."1.4.0";
  by-version."vfile"."1.4.0" = self.buildNodePackage {
    name = "vfile-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vfile/-/vfile-1.4.0.tgz";
      name = "vfile-1.4.0.tgz";
      sha1 = "c0fd6fa484f8debdb771f68c31ed75d88da97fe7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vfile"."^1.1.0" =
    self.by-version."vfile"."1.4.0";
  by-spec."vfile-find-down"."^1.0.0" =
    self.by-version."vfile-find-down"."1.0.0";
  by-version."vfile-find-down"."1.0.0" = self.buildNodePackage {
    name = "vfile-find-down-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vfile-find-down/-/vfile-find-down-1.0.0.tgz";
      name = "vfile-find-down-1.0.0.tgz";
      sha1 = "84a4d66d03513f6140a84e0776ef0848d4f0ad95";
    };
    deps = {
      "to-vfile-1.0.0" = self.by-version."to-vfile"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vfile-find-up"."^1.0.0" =
    self.by-version."vfile-find-up"."1.0.0";
  by-version."vfile-find-up"."1.0.0" = self.buildNodePackage {
    name = "vfile-find-up-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vfile-find-up/-/vfile-find-up-1.0.0.tgz";
      name = "vfile-find-up-1.0.0.tgz";
      sha1 = "5604da6fe453b34350637984eb5fe4909e280390";
    };
    deps = {
      "to-vfile-1.0.0" = self.by-version."to-vfile"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vfile-reporter"."^1.5.0" =
    self.by-version."vfile-reporter"."1.5.0";
  by-version."vfile-reporter"."1.5.0" = self.buildNodePackage {
    name = "vfile-reporter-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vfile-reporter/-/vfile-reporter-1.5.0.tgz";
      name = "vfile-reporter-1.5.0.tgz";
      sha1 = "21a7009bfe55e24df8ff432aa5bf6f6efa74e418";
    };
    deps = {
      "chalk-1.1.3" = self.by-version."chalk"."1.1.3";
      "log-symbols-1.0.2" = self.by-version."log-symbols"."1.0.2";
      "plur-2.1.2" = self.by-version."plur"."2.1.2";
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
      "text-table-0.2.0" = self.by-version."text-table"."0.2.0";
      "vfile-sort-1.0.0" = self.by-version."vfile-sort"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vfile-sort"."^1.0.0" =
    self.by-version."vfile-sort"."1.0.0";
  by-version."vfile-sort"."1.0.0" = self.buildNodePackage {
    name = "vfile-sort-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vfile-sort/-/vfile-sort-1.0.0.tgz";
      name = "vfile-sort-1.0.0.tgz";
      sha1 = "17ee491ba43e8951bb22913fcff32a7dc4d234d4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ware"."^1.3.0" =
    self.by-version."ware"."1.3.0";
  by-version."ware"."1.3.0" = self.buildNodePackage {
    name = "ware-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ware/-/ware-1.3.0.tgz";
      name = "ware-1.3.0.tgz";
      sha1 = "d1b14f39d2e2cb4ab8c4098f756fe4b164e473d4";
    };
    deps = {
      "wrap-fn-0.1.5" = self.by-version."wrap-fn"."0.1.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."web-bootloader"."^0.1.0" =
    self.by-version."web-bootloader"."0.1.2";
  by-version."web-bootloader"."0.1.2" = self.buildNodePackage {
    name = "web-bootloader-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/web-bootloader/-/web-bootloader-0.1.2.tgz";
      name = "web-bootloader-0.1.2.tgz";
      sha1 = "de18224ce986333ea988c38e376e8818f2902486";
    };
    deps = {
      "arraybuffer-base64-1.0.0" = self.by-version."arraybuffer-base64"."1.0.0";
      "binary-xhr-0.0.2" = self.by-version."binary-xhr"."0.0.2";
      "hyperfile-1.1.1" = self.by-version."hyperfile"."1.1.1";
      "hyperprogress-0.1.1" = self.by-version."hyperprogress"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."which"."1" =
    self.by-version."which"."1.2.12";
  by-version."which"."1.2.12" = self.buildNodePackage {
    name = "which-1.2.12";
    version = "1.2.12";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/which/-/which-1.2.12.tgz";
      name = "which-1.2.12.tgz";
      sha1 = "de67b5e450269f194909ef23ece4ebe416fa1192";
    };
    deps = {
      "isexe-1.1.2" = self.by-version."isexe"."1.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wide-align"."^1.1.0" =
    self.by-version."wide-align"."1.1.0";
  by-version."wide-align"."1.1.0" = self.buildNodePackage {
    name = "wide-align-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wide-align/-/wide-align-1.1.0.tgz";
      name = "wide-align-1.1.0.tgz";
      sha1 = "40edde802a71fea1f070da3e62dcda2e7add96ad";
    };
    deps = {
      "string-width-1.0.2" = self.by-version."string-width"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."word-wrap"."^1.1.0" =
    self.by-version."word-wrap"."1.2.0";
  by-version."word-wrap"."1.2.0" = self.buildNodePackage {
    name = "word-wrap-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/word-wrap/-/word-wrap-1.2.0.tgz";
      name = "word-wrap-1.2.0.tgz";
      sha1 = "ee971b6b7ce9ecae73a4b89a1cfdaa48dcf38ce7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wrap-fn"."^0.1.0" =
    self.by-version."wrap-fn"."0.1.5";
  by-version."wrap-fn"."0.1.5" = self.buildNodePackage {
    name = "wrap-fn-0.1.5";
    version = "0.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wrap-fn/-/wrap-fn-0.1.5.tgz";
      name = "wrap-fn-0.1.5.tgz";
      sha1 = "f21b6e41016ff4a7e31720dbc63a09016bdf9845";
    };
    deps = {
      "co-3.1.0" = self.by-version."co"."3.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wrappy"."1" =
    self.by-version."wrappy"."1.0.2";
  by-version."wrappy"."1.0.2" = self.buildNodePackage {
    name = "wrappy-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/wrappy/-/wrappy-1.0.2.tgz";
      name = "wrappy-1.0.2.tgz";
      sha1 = "b5243d8f3ec1aa35f1364605bc0d1036e30ab69f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ws"."^1.1.0" =
    self.by-version."ws"."1.1.1";
  by-version."ws"."1.1.1" = self.buildNodePackage {
    name = "ws-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ws/-/ws-1.1.1.tgz";
      name = "ws-1.1.1.tgz";
      sha1 = "082ddb6c641e85d4bb451f03d52f06eabdb1f018";
    };
    deps = {
      "options-0.0.6" = self.by-version."options"."0.0.6";
      "ultron-1.0.2" = self.by-version."ultron"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend".">=4.0.0 <4.1.0-0" =
    self.by-version."xtend"."4.0.1";
  by-version."xtend"."4.0.1" = self.buildNodePackage {
    name = "xtend-4.0.1";
    version = "4.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xtend/-/xtend-4.0.1.tgz";
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
  by-spec."xtend"."^4.0.0" =
    self.by-version."xtend"."4.0.1";
  by-spec."xtend"."^4.0.1" =
    self.by-version."xtend"."4.0.1";
  by-spec."xtend"."~2.1.2" =
    self.by-version."xtend"."2.1.2";
  by-version."xtend"."2.1.2" = self.buildNodePackage {
    name = "xtend-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xtend/-/xtend-2.1.2.tgz";
      name = "xtend-2.1.2.tgz";
      sha1 = "6efecc2a4dad8e6962c4901b337ce7ba87b5d28b";
    };
    deps = {
      "object-keys-0.4.0" = self.by-version."object-keys"."0.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."~3.0.0" =
    self.by-version."xtend"."3.0.0";
  by-version."xtend"."3.0.0" = self.buildNodePackage {
    name = "xtend-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/xtend/-/xtend-3.0.0.tgz";
      name = "xtend-3.0.0.tgz";
      sha1 = "5cce7407baf642cba7becda568111c493f59665a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."~4.0.0" =
    self.by-version."xtend"."4.0.1";
  by-spec."xtend"."~4.0.1" =
    self.by-version."xtend"."4.0.1";
  by-spec."zerr"."^1.0.0" =
    self.by-version."zerr"."1.0.4";
  by-version."zerr"."1.0.4" = self.buildNodePackage {
    name = "zerr-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/zerr/-/zerr-1.0.4.tgz";
      name = "zerr-1.0.4.tgz";
      sha1 = "62814dd799eff8361f2a228f41f705c5e19de4c9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "zerr" = self.by-version."zerr"."1.0.4";
  by-spec."zerr"."^1.0.1" =
    self.by-version."zerr"."1.0.4";
}

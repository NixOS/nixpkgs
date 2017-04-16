{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."accepts"."~1.1.0" =
    self.by-version."accepts"."1.1.1";
  by-version."accepts"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-accepts-1.1.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/accepts/-/accepts-1.1.1.tgz";
        name = "accepts-1.1.1.tgz";
        sha1 = "3b40bf6abc3fe3bc004534f4672ae1efd0063a96";
      })
    ];
    buildInputs =
      (self.nativeDeps."accepts" or []);
    deps = [
      self.by-version."mime-types"."2.0.2"
      self.by-version."negotiator"."0.4.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "accepts" ];
  };
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
  by-spec."block-stream"."*" =
    self.by-version."block-stream"."0.0.7";
  by-version."block-stream"."0.0.7" = lib.makeOverridable self.buildNodePackage {
    name = "node-block-stream-0.0.7";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/block-stream/-/block-stream-0.0.7.tgz";
        name = "block-stream-0.0.7.tgz";
        sha1 = "9088ab5ae1e861f4d81b176b4a8046080703deed";
      })
    ];
    buildInputs =
      (self.nativeDeps."block-stream" or []);
    deps = [
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "block-stream" ];
  };
  by-spec."body-parser"."^1.6.3" =
    self.by-version."body-parser"."1.9.0";
  by-version."body-parser"."1.9.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-body-parser-1.9.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/body-parser/-/body-parser-1.9.0.tgz";
        name = "body-parser-1.9.0.tgz";
        sha1 = "95d72943b1a4f67f56bbac9e0dcc837b68703605";
      })
    ];
    buildInputs =
      (self.nativeDeps."body-parser" or []);
    deps = [
      self.by-version."bytes"."1.0.0"
      self.by-version."depd"."1.0.0"
      self.by-version."iconv-lite"."0.4.4"
      self.by-version."media-typer"."0.3.0"
      self.by-version."on-finished"."2.1.0"
      self.by-version."qs"."2.2.4"
      self.by-version."raw-body"."1.3.0"
      self.by-version."type-is"."1.5.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "body-parser" ];
  };
  "body-parser" = self.by-version."body-parser"."1.9.0";
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
  by-spec."bytes"."1" =
    self.by-version."bytes"."1.0.0";
  by-version."bytes"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-bytes-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bytes/-/bytes-1.0.0.tgz";
        name = "bytes-1.0.0.tgz";
        sha1 = "3569ede8ba34315fab99c3e92cb04c7220de1fa8";
      })
    ];
    buildInputs =
      (self.nativeDeps."bytes" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "bytes" ];
  };
  by-spec."bytes"."1.0.0" =
    self.by-version."bytes"."1.0.0";
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
  by-spec."cookie"."0.1.2" =
    self.by-version."cookie"."0.1.2";
  by-version."cookie"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-0.1.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie/-/cookie-0.1.2.tgz";
        name = "cookie-0.1.2.tgz";
        sha1 = "72fec3d24e48a3432073d90c12642005061004b1";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie" ];
  };
  by-spec."cookie-signature"."1.0.5" =
    self.by-version."cookie-signature"."1.0.5";
  by-version."cookie-signature"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-cookie-signature-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.5.tgz";
        name = "cookie-signature-1.0.5.tgz";
        sha1 = "a122e3f1503eca0f5355795b0711bb2368d450f9";
      })
    ];
    buildInputs =
      (self.nativeDeps."cookie-signature" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "cookie-signature" ];
  };
  by-spec."crc"."3.0.0" =
    self.by-version."crc"."3.0.0";
  by-version."crc"."3.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-crc-3.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/crc/-/crc-3.0.0.tgz";
        name = "crc-3.0.0.tgz";
        sha1 = "d11e97ec44a844e5eb15a74fa2c7875d0aac4b22";
      })
    ];
    buildInputs =
      (self.nativeDeps."crc" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "crc" ];
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
  by-spec."debug"."~2.0.0" =
    self.by-version."debug"."2.0.0";
  by-version."debug"."2.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-debug-2.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-2.0.0.tgz";
        name = "debug-2.0.0.tgz";
        sha1 = "89bd9df6732b51256bc6705342bba02ed12131ef";
      })
    ];
    buildInputs =
      (self.nativeDeps."debug" or []);
    deps = [
      self.by-version."ms"."0.6.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "debug" ];
  };
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
  by-spec."depd"."0.4.5" =
    self.by-version."depd"."0.4.5";
  by-version."depd"."0.4.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-depd-0.4.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/depd/-/depd-0.4.5.tgz";
        name = "depd-0.4.5.tgz";
        sha1 = "1a664b53388b4a6573e8ae67b5f767c693ca97f1";
      })
    ];
    buildInputs =
      (self.nativeDeps."depd" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "depd" ];
  };
  by-spec."depd"."~1.0.0" =
    self.by-version."depd"."1.0.0";
  by-version."depd"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-depd-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/depd/-/depd-1.0.0.tgz";
        name = "depd-1.0.0.tgz";
        sha1 = "2fda0d00e98aae2845d4991ab1bf1f2a199073d5";
      })
    ];
    buildInputs =
      (self.nativeDeps."depd" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "depd" ];
  };
  by-spec."destroy"."1.0.3" =
    self.by-version."destroy"."1.0.3";
  by-version."destroy"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-destroy-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
        name = "destroy-1.0.3.tgz";
        sha1 = "b433b4724e71fd8551d9885174851c5fc377e2c9";
      })
    ];
    buildInputs =
      (self.nativeDeps."destroy" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "destroy" ];
  };
  by-spec."ee-first"."1.0.5" =
    self.by-version."ee-first"."1.0.5";
  by-version."ee-first"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-ee-first-1.0.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ee-first/-/ee-first-1.0.5.tgz";
        name = "ee-first-1.0.5.tgz";
        sha1 = "8c9b212898d8cd9f1a9436650ce7be202c9e9ff0";
      })
    ];
    buildInputs =
      (self.nativeDeps."ee-first" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ee-first" ];
  };
  by-spec."escape-html"."1.0.1" =
    self.by-version."escape-html"."1.0.1";
  by-version."escape-html"."1.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-escape-html-1.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
        name = "escape-html-1.0.1.tgz";
        sha1 = "181a286ead397a39a92857cfb1d43052e356bff0";
      })
    ];
    buildInputs =
      (self.nativeDeps."escape-html" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "escape-html" ];
  };
  by-spec."etag"."~1.4.0" =
    self.by-version."etag"."1.4.0";
  by-version."etag"."1.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-etag-1.4.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/etag/-/etag-1.4.0.tgz";
        name = "etag-1.4.0.tgz";
        sha1 = "3050991615857707c04119d075ba2088e0701225";
      })
    ];
    buildInputs =
      (self.nativeDeps."etag" or []);
    deps = [
      self.by-version."crc"."3.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "etag" ];
  };
  by-spec."express"."^4.8.3" =
    self.by-version."express"."4.9.5";
  by-version."express"."4.9.5" = lib.makeOverridable self.buildNodePackage {
    name = "node-express-4.9.5";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/express/-/express-4.9.5.tgz";
        name = "express-4.9.5.tgz";
        sha1 = "7f62aa84ac8f5e96acfb98e2944dde0bf1cf8688";
      })
    ];
    buildInputs =
      (self.nativeDeps."express" or []);
    deps = [
      self.by-version."accepts"."1.1.1"
      self.by-version."cookie-signature"."1.0.5"
      self.by-version."debug"."2.0.0"
      self.by-version."depd"."0.4.5"
      self.by-version."escape-html"."1.0.1"
      self.by-version."etag"."1.4.0"
      self.by-version."finalhandler"."0.2.0"
      self.by-version."fresh"."0.2.4"
      self.by-version."media-typer"."0.3.0"
      self.by-version."methods"."1.1.0"
      self.by-version."on-finished"."2.1.0"
      self.by-version."parseurl"."1.3.0"
      self.by-version."path-to-regexp"."0.1.3"
      self.by-version."proxy-addr"."1.0.3"
      self.by-version."qs"."2.2.4"
      self.by-version."range-parser"."1.0.2"
      self.by-version."send"."0.9.3"
      self.by-version."serve-static"."1.6.3"
      self.by-version."type-is"."1.5.2"
      self.by-version."vary"."1.0.0"
      self.by-version."cookie"."0.1.2"
      self.by-version."merge-descriptors"."0.0.2"
      self.by-version."utils-merge"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "express" ];
  };
  "express" = self.by-version."express"."4.9.5";
  by-spec."finalhandler"."0.2.0" =
    self.by-version."finalhandler"."0.2.0";
  by-version."finalhandler"."0.2.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-finalhandler-0.2.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.2.0.tgz";
        name = "finalhandler-0.2.0.tgz";
        sha1 = "794082424b17f6a4b2a0eda39f9db6948ee4be8d";
      })
    ];
    buildInputs =
      (self.nativeDeps."finalhandler" or []);
    deps = [
      self.by-version."debug"."2.0.0"
      self.by-version."escape-html"."1.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "finalhandler" ];
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
  by-spec."forwarded"."~0.1.0" =
    self.by-version."forwarded"."0.1.0";
  by-version."forwarded"."0.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-forwarded-0.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
        name = "forwarded-0.1.0.tgz";
        sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
      })
    ];
    buildInputs =
      (self.nativeDeps."forwarded" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "forwarded" ];
  };
  by-spec."fresh"."0.2.4" =
    self.by-version."fresh"."0.2.4";
  by-version."fresh"."0.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-fresh-0.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fresh/-/fresh-0.2.4.tgz";
        name = "fresh-0.2.4.tgz";
        sha1 = "3582499206c9723714190edd74b4604feb4a614c";
      })
    ];
    buildInputs =
      (self.nativeDeps."fresh" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fresh" ];
  };
  by-spec."fstream"."~0.1.28" =
    self.by-version."fstream"."0.1.31";
  by-version."fstream"."0.1.31" = lib.makeOverridable self.buildNodePackage {
    name = "node-fstream-0.1.31";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/fstream/-/fstream-0.1.31.tgz";
        name = "fstream-0.1.31.tgz";
        sha1 = "7337f058fbbbbefa8c9f561a28cab0849202c988";
      })
    ];
    buildInputs =
      (self.nativeDeps."fstream" or []);
    deps = [
      self.by-version."graceful-fs"."3.0.2"
      self.by-version."inherits"."2.0.1"
      self.by-version."mkdirp"."0.5.0"
      self.by-version."rimraf"."2.2.8"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  by-spec."graceful-fs"."~3.0.2" =
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
  by-spec."iconv-lite"."0.4.4" =
    self.by-version."iconv-lite"."0.4.4";
  by-version."iconv-lite"."0.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-iconv-lite-0.4.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.4.tgz";
        name = "iconv-lite-0.4.4.tgz";
        sha1 = "e95f2e41db0735fc21652f7827a5ee32e63c83a8";
      })
    ];
    buildInputs =
      (self.nativeDeps."iconv-lite" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "iconv-lite" ];
  };
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
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.1";
  by-spec."ipaddr.js"."0.1.3" =
    self.by-version."ipaddr.js"."0.1.3";
  by-version."ipaddr.js"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-ipaddr.js-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-0.1.3.tgz";
        name = "ipaddr.js-0.1.3.tgz";
        sha1 = "27a9ca37f148d2102b0ef191ccbf2c51a8f025c6";
      })
    ];
    buildInputs =
      (self.nativeDeps."ipaddr.js" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ipaddr.js" ];
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
  by-spec."media-typer"."0.3.0" =
    self.by-version."media-typer"."0.3.0";
  by-version."media-typer"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-media-typer-0.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
        name = "media-typer-0.3.0.tgz";
        sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
      })
    ];
    buildInputs =
      (self.nativeDeps."media-typer" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "media-typer" ];
  };
  by-spec."merge-descriptors"."0.0.2" =
    self.by-version."merge-descriptors"."0.0.2";
  by-version."merge-descriptors"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-merge-descriptors-0.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-0.0.2.tgz";
        name = "merge-descriptors-0.0.2.tgz";
        sha1 = "c36a52a781437513c57275f39dd9d317514ac8c7";
      })
    ];
    buildInputs =
      (self.nativeDeps."merge-descriptors" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "merge-descriptors" ];
  };
  by-spec."methods"."1.1.0" =
    self.by-version."methods"."1.1.0";
  by-version."methods"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-methods-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/methods/-/methods-1.1.0.tgz";
        name = "methods-1.1.0.tgz";
        sha1 = "5dca4ee12df52ff3b056145986a8f01cbc86436f";
      })
    ];
    buildInputs =
      (self.nativeDeps."methods" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "methods" ];
  };
  by-spec."mime"."1.2.11" =
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
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-spec."mime"."~1.2.9" =
    self.by-version."mime"."1.2.11";
  by-spec."mime-db"."~1.1.0" =
    self.by-version."mime-db"."1.1.0";
  by-version."mime-db"."1.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-db-1.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-db/-/mime-db-1.1.0.tgz";
        name = "mime-db-1.1.0.tgz";
        sha1 = "4613f418ab995450bf4bda240cd0ab38016a07a9";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-db" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime-db" ];
  };
  by-spec."mime-types"."~2.0.2" =
    self.by-version."mime-types"."2.0.2";
  by-version."mime-types"."2.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-mime-types-2.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.2.tgz";
        name = "mime-types-2.0.2.tgz";
        sha1 = "c74b779f2896c367888622bd537aaaad4c0a2c08";
      })
    ];
    buildInputs =
      (self.nativeDeps."mime-types" or []);
    deps = [
      self.by-version."mime-db"."1.1.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "mime-types" ];
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
  by-spec."mkdirp"."0.5" =
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
  by-spec."ms"."0.6.2" =
    self.by-version."ms"."0.6.2";
  by-version."ms"."0.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-ms-0.6.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ms/-/ms-0.6.2.tgz";
        name = "ms-0.6.2.tgz";
        sha1 = "d89c2124c6fdc1353d65a8b77bf1aac4b193708c";
      })
    ];
    buildInputs =
      (self.nativeDeps."ms" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ms" ];
  };
  by-spec."nan"."~1.0.0" =
    self.by-version."nan"."1.0.0";
  by-version."nan"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-nan-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nan/-/nan-1.0.0.tgz";
        name = "nan-1.0.0.tgz";
        sha1 = "ae24f8850818d662fcab5acf7f3b95bfaa2ccf38";
      })
    ];
    buildInputs =
      (self.nativeDeps."nan" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "nan" ];
  };
  by-spec."negotiator"."0.4.8" =
    self.by-version."negotiator"."0.4.8";
  by-version."negotiator"."0.4.8" = lib.makeOverridable self.buildNodePackage {
    name = "node-negotiator-0.4.8";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/negotiator/-/negotiator-0.4.8.tgz";
        name = "negotiator-0.4.8.tgz";
        sha1 = "96010b23b63c387f47a4bed96762a831cda39eab";
      })
    ];
    buildInputs =
      (self.nativeDeps."negotiator" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "negotiator" ];
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
  by-spec."on-finished"."2.1.0" =
    self.by-version."on-finished"."2.1.0";
  by-version."on-finished"."2.1.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-on-finished-2.1.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/on-finished/-/on-finished-2.1.0.tgz";
        name = "on-finished-2.1.0.tgz";
        sha1 = "0c539f09291e8ffadde0c8a25850fb2cedc7022d";
      })
    ];
    buildInputs =
      (self.nativeDeps."on-finished" or []);
    deps = [
      self.by-version."ee-first"."1.0.5"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "on-finished" ];
  };
  by-spec."on-finished"."~2.1.0" =
    self.by-version."on-finished"."2.1.0";
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "node-options-0.0.6";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/options/-/options-0.0.6.tgz";
        name = "options-0.0.6.tgz";
        sha1 = "ec22d312806bb53e731773e7cdaefcf1c643128f";
      })
    ];
    buildInputs =
      (self.nativeDeps."options" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "options" ];
  };
  by-spec."parseurl"."~1.3.0" =
    self.by-version."parseurl"."1.3.0";
  by-version."parseurl"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-parseurl-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/parseurl/-/parseurl-1.3.0.tgz";
        name = "parseurl-1.3.0.tgz";
        sha1 = "b58046db4223e145afa76009e61bac87cc2281b3";
      })
    ];
    buildInputs =
      (self.nativeDeps."parseurl" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "parseurl" ];
  };
  by-spec."path-to-regexp"."0.1.3" =
    self.by-version."path-to-regexp"."0.1.3";
  by-version."path-to-regexp"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-path-to-regexp-0.1.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.3.tgz";
        name = "path-to-regexp-0.1.3.tgz";
        sha1 = "21b9ab82274279de25b156ea08fd12ca51b8aecb";
      })
    ];
    buildInputs =
      (self.nativeDeps."path-to-regexp" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "path-to-regexp" ];
  };
  by-spec."proxy-addr"."~1.0.3" =
    self.by-version."proxy-addr"."1.0.3";
  by-version."proxy-addr"."1.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-proxy-addr-1.0.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.3.tgz";
        name = "proxy-addr-1.0.3.tgz";
        sha1 = "17d824aac844707441249da6d1ea5e889007cdd6";
      })
    ];
    buildInputs =
      (self.nativeDeps."proxy-addr" or []);
    deps = [
      self.by-version."forwarded"."0.1.0"
      self.by-version."ipaddr.js"."0.1.3"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "proxy-addr" ];
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
  by-spec."qs"."2.2.4" =
    self.by-version."qs"."2.2.4";
  by-version."qs"."2.2.4" = lib.makeOverridable self.buildNodePackage {
    name = "node-qs-2.2.4";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-2.2.4.tgz";
        name = "qs-2.2.4.tgz";
        sha1 = "2e9fbcd34b540e3421c924ecd01e90aa975319c8";
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
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.2";
  by-version."range-parser"."1.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-range-parser-1.0.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.2.tgz";
        name = "range-parser-1.0.2.tgz";
        sha1 = "06a12a42e5131ba8e457cd892044867f2344e549";
      })
    ];
    buildInputs =
      (self.nativeDeps."range-parser" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "range-parser" ];
  };
  by-spec."raw-body"."1.3.0" =
    self.by-version."raw-body"."1.3.0";
  by-version."raw-body"."1.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-raw-body-1.3.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/raw-body/-/raw-body-1.3.0.tgz";
        name = "raw-body-1.3.0.tgz";
        sha1 = "978230a156a5548f42eef14de22d0f4f610083d1";
      })
    ];
    buildInputs =
      (self.nativeDeps."raw-body" or []);
    deps = [
      self.by-version."bytes"."1.0.0"
      self.by-version."iconv-lite"."0.4.4"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "raw-body" ];
  };
  by-spec."request"."~2.34.0" =
    self.by-version."request"."2.34.0";
  by-version."request"."2.34.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-request-2.34.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.34.0.tgz";
        name = "request-2.34.0.tgz";
        sha1 = "b5d8b9526add4a2d4629f4d417124573996445ae";
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
      self.by-version."tough-cookie"."0.12.1"
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
  "request" = self.by-version."request"."2.34.0";
  by-spec."rimraf"."2" =
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
  by-spec."send"."0.9.3" =
    self.by-version."send"."0.9.3";
  by-version."send"."0.9.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-send-0.9.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/send/-/send-0.9.3.tgz";
        name = "send-0.9.3.tgz";
        sha1 = "b43a7414cd089b7fbec9b755246f7c37b7b85cc0";
      })
    ];
    buildInputs =
      (self.nativeDeps."send" or []);
    deps = [
      self.by-version."debug"."2.0.0"
      self.by-version."depd"."0.4.5"
      self.by-version."destroy"."1.0.3"
      self.by-version."escape-html"."1.0.1"
      self.by-version."etag"."1.4.0"
      self.by-version."fresh"."0.2.4"
      self.by-version."mime"."1.2.11"
      self.by-version."ms"."0.6.2"
      self.by-version."on-finished"."2.1.0"
      self.by-version."range-parser"."1.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "send" ];
  };
  by-spec."serve-static"."~1.6.3" =
    self.by-version."serve-static"."1.6.3";
  by-version."serve-static"."1.6.3" = lib.makeOverridable self.buildNodePackage {
    name = "node-serve-static-1.6.3";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/serve-static/-/serve-static-1.6.3.tgz";
        name = "serve-static-1.6.3.tgz";
        sha1 = "b214235d4d4516db050ea9f7b429b46212e79132";
      })
    ];
    buildInputs =
      (self.nativeDeps."serve-static" or []);
    deps = [
      self.by-version."escape-html"."1.0.1"
      self.by-version."parseurl"."1.3.0"
      self.by-version."send"."0.9.3"
      self.by-version."utils-merge"."1.0.0"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "serve-static" ];
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
  by-spec."tar"."~0.1.19" =
    self.by-version."tar"."0.1.20";
  by-version."tar"."0.1.20" = lib.makeOverridable self.buildNodePackage {
    name = "node-tar-0.1.20";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tar/-/tar-0.1.20.tgz";
        name = "tar-0.1.20.tgz";
        sha1 = "42940bae5b5f22c74483699126f9f3f27449cb13";
      })
    ];
    buildInputs =
      (self.nativeDeps."tar" or []);
    deps = [
      self.by-version."block-stream"."0.0.7"
      self.by-version."fstream"."0.1.31"
      self.by-version."inherits"."2.0.1"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tar" ];
  };
  "tar" = self.by-version."tar"."0.1.20";
  by-spec."tinycolor"."0.x" =
    self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-tinycolor-0.0.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
        name = "tinycolor-0.0.1.tgz";
        sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
      })
    ];
    buildInputs =
      (self.nativeDeps."tinycolor" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "tinycolor" ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."0.12.1";
  by-version."tough-cookie"."0.12.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-tough-cookie-0.12.1";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
        name = "tough-cookie-0.12.1.tgz";
        sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
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
  by-spec."type-is"."~1.5.1" =
    self.by-version."type-is"."1.5.2";
  by-version."type-is"."1.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "node-type-is-1.5.2";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/type-is/-/type-is-1.5.2.tgz";
        name = "type-is-1.5.2.tgz";
        sha1 = "8291bbe845a904acfaffd05a41fdeb234bfa9e5f";
      })
    ];
    buildInputs =
      (self.nativeDeps."type-is" or []);
    deps = [
      self.by-version."media-typer"."0.3.0"
      self.by-version."mime-types"."2.0.2"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "type-is" ];
  };
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-utils-merge-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
        name = "utils-merge-1.0.0.tgz";
        sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
      })
    ];
    buildInputs =
      (self.nativeDeps."utils-merge" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "utils-merge" ];
  };
  by-spec."vary"."~1.0.0" =
    self.by-version."vary"."1.0.0";
  by-version."vary"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "node-vary-1.0.0";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/vary/-/vary-1.0.0.tgz";
        name = "vary-1.0.0.tgz";
        sha1 = "c5e76cec20d3820d8f2a96e7bee38731c34da1e7";
      })
    ];
    buildInputs =
      (self.nativeDeps."vary" or []);
    deps = [
    ];
    peerDependencies = [
    ];
    passthru.names = [ "vary" ];
  };
  by-spec."ws"."~0.4.32" =
    self.by-version."ws"."0.4.32";
  by-version."ws"."0.4.32" = lib.makeOverridable self.buildNodePackage {
    name = "ws-0.4.32";
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ws/-/ws-0.4.32.tgz";
        name = "ws-0.4.32.tgz";
        sha1 = "787a6154414f3c99ed83c5772153b20feb0cec32";
      })
    ];
    buildInputs =
      (self.nativeDeps."ws" or []);
    deps = [
      self.by-version."commander"."2.1.0"
      self.by-version."nan"."1.0.0"
      self.by-version."tinycolor"."0.0.1"
      self.by-version."options"."0.0.6"
    ];
    peerDependencies = [
    ];
    passthru.names = [ "ws" ];
  };
  "ws" = self.by-version."ws"."0.4.32";
}

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
  by-spec."assert-plus"."0.1.2" =
    self.by-version."assert-plus"."0.1.2";
  by-version."assert-plus"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "assert-plus-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/assert-plus/-/assert-plus-0.1.2.tgz";
        name = "assert-plus-0.1.2.tgz";
        sha1 = "d93ffdbb67ac5507779be316a7d65146417beef8";
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
  by-spec."async"."~0.2.9" =
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
  "async" = self.by-version."async"."0.2.10";
  by-spec."async"."~0.9.0" =
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
  by-spec."bindings-shyp"."~0.2.3" =
    self.by-version."bindings-shyp"."0.2.3";
  by-version."bindings-shyp"."0.2.3" = lib.makeOverridable self.buildNodePackage {
    name = "bindings-shyp-0.2.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bindings-shyp/-/bindings-shyp-0.2.3.tgz";
        name = "bindings-shyp-0.2.3.tgz";
        sha1 = "909151c14c701f350eb6be8ad14784ad79813671";
      })
    ];
    buildInputs =
      (self.nativeDeps."bindings-shyp" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "bindings-shyp" ];
  };
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
  by-spec."buffer-equal"."~0.0.0" =
    self.by-version."buffer-equal"."0.0.1";
  by-version."buffer-equal"."0.0.1" = lib.makeOverridable self.buildNodePackage {
    name = "buffer-equal-0.0.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz";
        name = "buffer-equal-0.0.1.tgz";
        sha1 = "91bc74b11ea405bc916bc6aa908faafa5b4aac4b";
      })
    ];
    buildInputs =
      (self.nativeDeps."buffer-equal" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "buffer-equal" ];
  };
  by-spec."bunker"."0.1.X" =
    self.by-version."bunker"."0.1.2";
  by-version."bunker"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "bunker-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/bunker/-/bunker-0.1.2.tgz";
        name = "bunker-0.1.2.tgz";
        sha1 = "c88992464a8e2a6ede86930375f92b58077ef97c";
      })
    ];
    buildInputs =
      (self.nativeDeps."bunker" or []);
    deps = {
      "burrito-0.2.12" = self.by-version."burrito"."0.2.12";
    };
    peerDependencies = [
    ];
    passthru.names = [ "bunker" ];
  };
  by-spec."burrito".">=0.2.5 <0.3" =
    self.by-version."burrito"."0.2.12";
  by-version."burrito"."0.2.12" = lib.makeOverridable self.buildNodePackage {
    name = "burrito-0.2.12";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/burrito/-/burrito-0.2.12.tgz";
        name = "burrito-0.2.12.tgz";
        sha1 = "d0d6e6ac81d5e99789c6fa4accb0b0031ea54f6b";
      })
    ];
    buildInputs =
      (self.nativeDeps."burrito" or []);
    deps = {
      "traverse-0.5.2" = self.by-version."traverse"."0.5.2";
      "uglify-js-1.1.1" = self.by-version."uglify-js"."1.1.1";
    };
    peerDependencies = [
    ];
    passthru.names = [ "burrito" ];
  };
  by-spec."charm"."0.1.x" =
    self.by-version."charm"."0.1.2";
  by-version."charm"."0.1.2" = lib.makeOverridable self.buildNodePackage {
    name = "charm-0.1.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/charm/-/charm-0.1.2.tgz";
        name = "charm-0.1.2.tgz";
        sha1 = "06c21eed1a1b06aeb67553cdc53e23274bac2296";
      })
    ];
    buildInputs =
      (self.nativeDeps."charm" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "charm" ];
  };
  by-spec."colony-compiler"."~0.6.21" =
    self.by-version."colony-compiler"."0.6.23";
  by-version."colony-compiler"."0.6.23" = lib.makeOverridable self.buildNodePackage {
    name = "colony-compiler-0.6.23";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colony-compiler/-/colony-compiler-0.6.23.tgz";
        name = "colony-compiler-0.6.23.tgz";
        sha1 = "0bef9e899e1ae928f6fe5e0dcca6cab4d47ab448";
      })
    ];
    buildInputs =
      (self.nativeDeps."colony-compiler" or []);
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "optimist-0.5.2" = self.by-version."optimist"."0.5.2";
      "nan-1.0.0" = self.by-version."nan"."1.0.0";
      "async-0.9.0" = self.by-version."async"."0.9.0";
      "bindings-shyp-0.2.3" = self.by-version."bindings-shyp"."0.2.3";
      # "colony-compiler-shyp-win32-ia32-0.6.17-1" = self.by-version."colony-compiler-shyp-win32-ia32"."0.6.17-1";
      # "colony-compiler-shyp-win32-x64-0.6.17-0" = self.by-version."colony-compiler-shyp-win32-x64"."0.6.17-0";
      # "colony-compiler-shyp-darwin-x64-0.6.17-0" = self.by-version."colony-compiler-shyp-darwin-x64"."0.6.17-0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "colony-compiler" ];
  };
  "colony-compiler" = self.by-version."colony-compiler"."0.6.23";
  by-spec."colony-compiler-shyp-darwin-x64"."0.6.x" =
    self.by-version."colony-compiler-shyp-darwin-x64"."0.6.17-0";
  by-version."colony-compiler-shyp-darwin-x64"."0.6.17-0" = lib.makeOverridable self.buildNodePackage {
    name = "colony-compiler-shyp-darwin-x64-0.6.17-0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colony-compiler-shyp-darwin-x64/-/colony-compiler-shyp-darwin-x64-0.6.17-0.tgz";
        name = "colony-compiler-shyp-darwin-x64-0.6.17-0.tgz";
        sha1 = "33eedbee7ff8679fde69ba03bf27777110113732";
      })
    ];
    buildInputs =
      (self.nativeDeps."colony-compiler-shyp-darwin-x64" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colony-compiler-shyp-darwin-x64" ];
  };
  by-spec."colony-compiler-shyp-win32-ia32"."0.6.x" =
    self.by-version."colony-compiler-shyp-win32-ia32"."0.6.17-1";
  by-version."colony-compiler-shyp-win32-ia32"."0.6.17-1" = lib.makeOverridable self.buildNodePackage {
    name = "colony-compiler-shyp-win32-ia32-0.6.17-1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colony-compiler-shyp-win32-ia32/-/colony-compiler-shyp-win32-ia32-0.6.17-1.tgz";
        name = "colony-compiler-shyp-win32-ia32-0.6.17-1.tgz";
        sha1 = "6e11a978be5df7be00112d2a349d5e34925f443a";
      })
    ];
    buildInputs =
      (self.nativeDeps."colony-compiler-shyp-win32-ia32" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colony-compiler-shyp-win32-ia32" ];
  };
  by-spec."colony-compiler-shyp-win32-x64"."0.6.x" =
    self.by-version."colony-compiler-shyp-win32-x64"."0.6.17-0";
  by-version."colony-compiler-shyp-win32-x64"."0.6.17-0" = lib.makeOverridable self.buildNodePackage {
    name = "colony-compiler-shyp-win32-x64-0.6.17-0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colony-compiler-shyp-win32-x64/-/colony-compiler-shyp-win32-x64-0.6.17-0.tgz";
        name = "colony-compiler-shyp-win32-x64-0.6.17-0.tgz";
        sha1 = "cd30416df0ab52e49c74e81d69bd23329983d005";
      })
    ];
    buildInputs =
      (self.nativeDeps."colony-compiler-shyp-win32-x64" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colony-compiler-shyp-win32-x64" ];
  };
  by-spec."colors"."0.5.x" =
    self.by-version."colors"."0.5.1";
  by-version."colors"."0.5.1" = lib.makeOverridable self.buildNodePackage {
    name = "colors-0.5.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colors/-/colors-0.5.1.tgz";
        name = "colors-0.5.1.tgz";
        sha1 = "7d0023eaeb154e8ee9fce75dcb923d0ed1667774";
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
  by-spec."colors"."~0.6.0-1" =
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
  "colors" = self.by-version."colors"."0.6.2";
  by-spec."colors"."~0.6.1" =
    self.by-version."colors"."0.6.2";
  by-spec."colorsafeconsole"."0.0.4" =
    self.by-version."colorsafeconsole"."0.0.4";
  by-version."colorsafeconsole"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "colorsafeconsole-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/colorsafeconsole/-/colorsafeconsole-0.0.4.tgz";
        name = "colorsafeconsole-0.0.4.tgz";
        sha1 = "dc10508bb000e51964fb485fd8557faa169effbe";
      })
    ];
    buildInputs =
      (self.nativeDeps."colorsafeconsole" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "colorsafeconsole" ];
  };
  "colorsafeconsole" = self.by-version."colorsafeconsole"."0.0.4";
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
  by-spec."ctype"."0.5.2" =
    self.by-version."ctype"."0.5.2";
  by-version."ctype"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "ctype-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/ctype/-/ctype-0.5.2.tgz";
        name = "ctype-0.5.2.tgz";
        sha1 = "fe8091d468a373a0b0c9ff8bbfb3425c00973a1d";
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
  by-spec."debug"."^0.8.1" =
    self.by-version."debug"."0.8.1";
  by-version."debug"."0.8.1" = lib.makeOverridable self.buildNodePackage {
    name = "debug-0.8.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/debug/-/debug-0.8.1.tgz";
        name = "debug-0.8.1.tgz";
        sha1 = "20ff4d26f5e422cb68a1bacbbb61039ad8c1c130";
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
  "debug" = self.by-version."debug"."0.8.1";
  by-spec."deep-equal"."~0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-version."deep-equal"."0.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.0.0.tgz";
        name = "deep-equal-0.0.0.tgz";
        sha1 = "99679d3bbd047156fcd450d3d01eeb9068691e83";
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
  by-spec."deep-equal"."~0.2.0" =
    self.by-version."deep-equal"."0.2.1";
  by-version."deep-equal"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "deep-equal-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.2.1.tgz";
        name = "deep-equal-0.2.1.tgz";
        sha1 = "fad7a793224cbf0c3c7786f92ef780e4fc8cc878";
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
  by-spec."deep-is"."0.1.x" =
    self.by-version."deep-is"."0.1.3";
  by-version."deep-is"."0.1.3" = lib.makeOverridable self.buildNodePackage {
    name = "deep-is-0.1.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz";
        name = "deep-is-0.1.3.tgz";
        sha1 = "b369d6fb5dbc13eecf524f91b070feedc357cf34";
      })
    ];
    buildInputs =
      (self.nativeDeps."deep-is" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "deep-is" ];
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
  by-spec."difflet"."~0.2.0" =
    self.by-version."difflet"."0.2.6";
  by-version."difflet"."0.2.6" = lib.makeOverridable self.buildNodePackage {
    name = "difflet-0.2.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/difflet/-/difflet-0.2.6.tgz";
        name = "difflet-0.2.6.tgz";
        sha1 = "ab23b31f5649b6faa8e3d2acbd334467365ca6fa";
      })
    ];
    buildInputs =
      (self.nativeDeps."difflet" or []);
    deps = {
      "traverse-0.6.6" = self.by-version."traverse"."0.6.6";
      "charm-0.1.2" = self.by-version."charm"."0.1.2";
      "deep-is-0.1.3" = self.by-version."deep-is"."0.1.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "difflet" ];
  };
  by-spec."effess"."~0.0.2" =
    self.by-version."effess"."0.0.5";
  by-version."effess"."0.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "effess-0.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/effess/-/effess-0.0.5.tgz";
        name = "effess-0.0.5.tgz";
        sha1 = "d328fd03929c168c02a63d9d3d889657dc9499db";
      })
    ];
    buildInputs =
      (self.nativeDeps."effess" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "effess" ];
  };
  by-spec."effess"."~0.0.5" =
    self.by-version."effess"."0.0.5";
  "effess" = self.by-version."effess"."0.0.5";
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
  by-spec."fstream"."~0.1.25" =
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
      "graceful-fs-3.0.4" = self.by-version."graceful-fs"."3.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    peerDependencies = [
    ];
    passthru.names = [ "fstream" ];
  };
  "fstream" = self.by-version."fstream"."0.1.31";
  by-spec."fstream"."~0.1.28" =
    self.by-version."fstream"."0.1.31";
  by-spec."glob"."~3.2.1" =
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
  by-spec."glob"."~3.2.9" =
    self.by-version."glob"."3.2.11";
  by-spec."graceful-fs"."~1" =
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
  by-spec."graceful-fs"."~3.0.2" =
    self.by-version."graceful-fs"."3.0.4";
  by-version."graceful-fs"."3.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "graceful-fs-3.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.4.tgz";
        name = "graceful-fs-3.0.4.tgz";
        sha1 = "a0306d9b0940e0fc512d33b5df1014e88e0637a3";
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
  by-spec."hardware-resolve"."~0.1.3" =
    self.by-version."hardware-resolve"."0.1.6";
  by-version."hardware-resolve"."0.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "hardware-resolve-0.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hardware-resolve/-/hardware-resolve-0.1.6.tgz";
        name = "hardware-resolve-0.1.6.tgz";
        sha1 = "b03f5077ab1b4b185ecd9486a3ba754f4b46e02a";
      })
    ];
    buildInputs =
      (self.nativeDeps."hardware-resolve" or []);
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
      "effess-0.0.5" = self.by-version."effess"."0.0.5";
    };
    peerDependencies = [
    ];
    passthru.names = [ "hardware-resolve" ];
  };
  "hardware-resolve" = self.by-version."hardware-resolve"."0.1.6";
  by-spec."hawk"."~1.0.0" =
    self.by-version."hawk"."1.0.0";
  by-version."hawk"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "hawk-1.0.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/hawk/-/hawk-1.0.0.tgz";
        name = "hawk-1.0.0.tgz";
        sha1 = "b90bb169807285411da7ffcb8dd2598502d3b52d";
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
  by-spec."http-signature"."~0.10.0" =
    self.by-version."http-signature"."0.10.0";
  by-version."http-signature"."0.10.0" = lib.makeOverridable self.buildNodePackage {
    name = "http-signature-0.10.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/http-signature/-/http-signature-0.10.0.tgz";
        name = "http-signature-0.10.0.tgz";
        sha1 = "1494e4f5000a83c0f11bcc12d6007c530cb99582";
      })
    ];
    buildInputs =
      (self.nativeDeps."http-signature" or []);
    deps = {
      "assert-plus-0.1.2" = self.by-version."assert-plus"."0.1.2";
      "asn1-0.1.11" = self.by-version."asn1"."0.1.11";
      "ctype-0.5.2" = self.by-version."ctype"."0.5.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "http-signature" ];
  };
  by-spec."humanize"."0.0.9" =
    self.by-version."humanize"."0.0.9";
  by-version."humanize"."0.0.9" = lib.makeOverridable self.buildNodePackage {
    name = "humanize-0.0.9";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/humanize/-/humanize-0.0.9.tgz";
        name = "humanize-0.0.9.tgz";
        sha1 = "1994ffaecdfe9c441ed2bdac7452b7bb4c9e41a4";
      })
    ];
    buildInputs =
      (self.nativeDeps."humanize" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "humanize" ];
  };
  "humanize" = self.by-version."humanize"."0.0.9";
  by-spec."inherits"."*" =
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
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
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
  by-spec."keypress"."~0.2.1" =
    self.by-version."keypress"."0.2.1";
  by-version."keypress"."0.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "keypress-0.2.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/keypress/-/keypress-0.2.1.tgz";
        name = "keypress-0.2.1.tgz";
        sha1 = "1e80454250018dbad4c3fe94497d6e67b6269c77";
      })
    ];
    buildInputs =
      (self.nativeDeps."keypress" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "keypress" ];
  };
  "keypress" = self.by-version."keypress"."0.2.1";
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
  by-spec."mime"."~1.2.11" =
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
  by-spec."mime"."~1.2.9" =
    self.by-version."mime"."1.2.11";
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
  by-spec."minimatch"."~0.2.14" =
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
  by-spec."mkdirp"."~0.3 || 0.4 || 0.5" =
    self.by-version."mkdirp"."0.5.0";
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
  "mkdirp" = self.by-version."mkdirp"."0.3.5";
  by-spec."mute-stream"."~0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = lib.makeOverridable self.buildNodePackage {
    name = "mute-stream-0.0.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
        name = "mute-stream-0.0.4.tgz";
        sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
      })
    ];
    buildInputs =
      (self.nativeDeps."mute-stream" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "mute-stream" ];
  };
  by-spec."my-local-ip"."~1.0.0" =
    self.by-version."my-local-ip"."1.0.0";
  by-version."my-local-ip"."1.0.0" = lib.makeOverridable self.buildNodePackage {
    name = "my-local-ip-1.0.0";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/my-local-ip/-/my-local-ip-1.0.0.tgz";
        name = "my-local-ip-1.0.0.tgz";
        sha1 = "37585555a4ff1985309edac7c2a045a466be6c32";
      })
    ];
    buildInputs =
      (self.nativeDeps."my-local-ip" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "my-local-ip" ];
  };
  "my-local-ip" = self.by-version."my-local-ip"."1.0.0";
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
  by-spec."node-uuid"."~1.4.0" =
    self.by-version."node-uuid"."1.4.1";
  by-version."node-uuid"."1.4.1" = lib.makeOverridable self.buildNodePackage {
    name = "node-uuid-1.4.1";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/node-uuid/-/node-uuid-1.4.1.tgz";
        name = "node-uuid-1.4.1.tgz";
        sha1 = "39aef510e5889a3dca9c895b506c73aae1bac048";
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
  by-spec."nomnom"."~1.6.2" =
    self.by-version."nomnom"."1.6.2";
  by-version."nomnom"."1.6.2" = lib.makeOverridable self.buildNodePackage {
    name = "nomnom-1.6.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nomnom/-/nomnom-1.6.2.tgz";
        name = "nomnom-1.6.2.tgz";
        sha1 = "84a66a260174408fc5b77a18f888eccc44fb6971";
      })
    ];
    buildInputs =
      (self.nativeDeps."nomnom" or []);
    deps = {
      "colors-0.5.1" = self.by-version."colors"."0.5.1";
      "underscore-1.4.4" = self.by-version."underscore"."1.4.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "nomnom" ];
  };
  "nomnom" = self.by-version."nomnom"."1.6.2";
  by-spec."nopt"."~2" =
    self.by-version."nopt"."2.2.1";
  by-version."nopt"."2.2.1" = lib.makeOverridable self.buildNodePackage {
    name = "nopt-2.2.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/nopt/-/nopt-2.2.1.tgz";
        name = "nopt-2.2.1.tgz";
        sha1 = "2aa09b7d1768487b3b89a9c5aa52335bff0baea7";
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
  by-spec."object-inspect"."~0.4.0" =
    self.by-version."object-inspect"."0.4.0";
  by-version."object-inspect"."0.4.0" = lib.makeOverridable self.buildNodePackage {
    name = "object-inspect-0.4.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/object-inspect/-/object-inspect-0.4.0.tgz";
        name = "object-inspect-0.4.0.tgz";
        sha1 = "f5157c116c1455b243b06ee97703392c5ad89fec";
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
  by-spec."optimist"."~0.5.2" =
    self.by-version."optimist"."0.5.2";
  by-version."optimist"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "optimist-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/optimist/-/optimist-0.5.2.tgz";
        name = "optimist-0.5.2.tgz";
        sha1 = "85c8c1454b3315e4a78947e857b1df033450bfbc";
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
  by-spec."osenv"."0.0.3" =
    self.by-version."osenv"."0.0.3";
  by-version."osenv"."0.0.3" = lib.makeOverridable self.buildNodePackage {
    name = "osenv-0.0.3";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/osenv/-/osenv-0.0.3.tgz";
        name = "osenv-0.0.3.tgz";
        sha1 = "cd6ad8ddb290915ad9e22765576025d411f29cb6";
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
  by-spec."qs"."~0.6.0" =
    self.by-version."qs"."0.6.6";
  by-version."qs"."0.6.6" = lib.makeOverridable self.buildNodePackage {
    name = "qs-0.6.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/qs/-/qs-0.6.6.tgz";
        name = "qs-0.6.6.tgz";
        sha1 = "6e015098ff51968b8a3c819001d5f2c89bc4b107";
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
  by-spec."read"."^1.0.5" =
    self.by-version."read"."1.0.5";
  by-version."read"."1.0.5" = lib.makeOverridable self.buildNodePackage {
    name = "read-1.0.5";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/read/-/read-1.0.5.tgz";
        name = "read-1.0.5.tgz";
        sha1 = "007a3d169478aa710a491727e453effb92e76203";
      })
    ];
    buildInputs =
      (self.nativeDeps."read" or []);
    deps = {
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
    };
    peerDependencies = [
    ];
    passthru.names = [ "read" ];
  };
  "read" = self.by-version."read"."1.0.5";
  by-spec."request"."~2.33.0" =
    self.by-version."request"."2.33.0";
  by-version."request"."2.33.0" = lib.makeOverridable self.buildNodePackage {
    name = "request-2.33.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/request/-/request-2.33.0.tgz";
        name = "request-2.33.0.tgz";
        sha1 = "5167878131726070ec633752ea230a2379dc65ff";
      })
    ];
    buildInputs =
      (self.nativeDeps."request" or []);
    deps = {
      "qs-0.6.6" = self.by-version."qs"."0.6.6";
      "json-stringify-safe-5.0.0" = self.by-version."json-stringify-safe"."5.0.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "node-uuid-1.4.1" = self.by-version."node-uuid"."1.4.1";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
      "form-data-0.1.4" = self.by-version."form-data"."0.1.4";
      "tunnel-agent-0.3.0" = self.by-version."tunnel-agent"."0.3.0";
      "http-signature-0.10.0" = self.by-version."http-signature"."0.10.0";
      "oauth-sign-0.3.0" = self.by-version."oauth-sign"."0.3.0";
      "hawk-1.0.0" = self.by-version."hawk"."1.0.0";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "request" ];
  };
  "request" = self.by-version."request"."2.33.0";
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
  by-spec."runforcover"."~0.0.2" =
    self.by-version."runforcover"."0.0.2";
  by-version."runforcover"."0.0.2" = lib.makeOverridable self.buildNodePackage {
    name = "runforcover-0.0.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/runforcover/-/runforcover-0.0.2.tgz";
        name = "runforcover-0.0.2.tgz";
        sha1 = "344f057d8d45d33aebc6cc82204678f69c4857cc";
      })
    ];
    buildInputs =
      (self.nativeDeps."runforcover" or []);
    deps = {
      "bunker-0.1.2" = self.by-version."bunker"."0.1.2";
    };
    peerDependencies = [
    ];
    passthru.names = [ "runforcover" ];
  };
  by-spec."semver"."^2.3.0" =
    self.by-version."semver"."2.3.2";
  by-version."semver"."2.3.2" = lib.makeOverridable self.buildNodePackage {
    name = "semver-2.3.2";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/semver/-/semver-2.3.2.tgz";
        name = "semver-2.3.2.tgz";
        sha1 = "b9848f25d6cf36333073ec9ef8856d42f1233e52";
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
  "semver" = self.by-version."semver"."2.3.2";
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
  by-spec."slide"."*" =
    self.by-version."slide"."1.1.6";
  by-version."slide"."1.1.6" = lib.makeOverridable self.buildNodePackage {
    name = "slide-1.1.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/slide/-/slide-1.1.6.tgz";
        name = "slide-1.1.6.tgz";
        sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
      })
    ];
    buildInputs =
      (self.nativeDeps."slide" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "slide" ];
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
  by-spec."structured-clone"."~0.2.2" =
    self.by-version."structured-clone"."0.2.2";
  by-version."structured-clone"."0.2.2" = lib.makeOverridable self.buildNodePackage {
    name = "structured-clone-0.2.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/structured-clone/-/structured-clone-0.2.2.tgz";
        name = "structured-clone-0.2.2.tgz";
        sha1 = "ac92b6be31958a643db30f1335abc6a1b02dfdc2";
      })
    ];
    buildInputs =
      (self.nativeDeps."structured-clone" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "structured-clone" ];
  };
  "structured-clone" = self.by-version."structured-clone"."0.2.2";
  by-spec."tap"."~0.4.8" =
    self.by-version."tap"."0.4.13";
  by-version."tap"."0.4.13" = lib.makeOverridable self.buildNodePackage {
    name = "tap-0.4.13";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tap/-/tap-0.4.13.tgz";
        name = "tap-0.4.13.tgz";
        sha1 = "3986134d6759727fc2223e61126eeb87243accbc";
      })
    ];
    buildInputs =
      (self.nativeDeps."tap" or []);
    deps = {
      "buffer-equal-0.0.1" = self.by-version."buffer-equal"."0.0.1";
      "deep-equal-0.0.0" = self.by-version."deep-equal"."0.0.0";
      "difflet-0.2.6" = self.by-version."difflet"."0.2.6";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "runforcover-0.0.2" = self.by-version."runforcover"."0.0.2";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "yamlish-0.0.6" = self.by-version."yamlish"."0.0.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tap" ];
  };
  "tap" = self.by-version."tap"."0.4.13";
  by-spec."tape"."~2.12.3" =
    self.by-version."tape"."2.12.3";
  by-version."tape"."2.12.3" = lib.makeOverridable self.buildNodePackage {
    name = "tape-2.12.3";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tape/-/tape-2.12.3.tgz";
        name = "tape-2.12.3.tgz";
        sha1 = "5559d5454050292627537c012991ec6971f66156";
      })
    ];
    buildInputs =
      (self.nativeDeps."tape" or []);
    deps = {
      "deep-equal-0.2.1" = self.by-version."deep-equal"."0.2.1";
      "defined-0.0.0" = self.by-version."defined"."0.0.0";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "object-inspect-0.4.0" = self.by-version."object-inspect"."0.4.0";
      "resumer-0.0.0" = self.by-version."resumer"."0.0.0";
      "through-2.3.6" = self.by-version."through"."2.3.6";
    };
    peerDependencies = [
    ];
    passthru.names = [ "tape" ];
  };
  "tape" = self.by-version."tape"."2.12.3";
  by-spec."tar"."~0.1.18" =
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
  "tar" = self.by-version."tar"."0.1.20";
  by-spec."temp"."~0.6.0" =
    self.by-version."temp"."0.6.0";
  by-version."temp"."0.6.0" = lib.makeOverridable self.buildNodePackage {
    name = "temp-0.6.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/temp/-/temp-0.6.0.tgz";
        name = "temp-0.6.0.tgz";
        sha1 = "6b13df5cddf370f2e3a606ca40f202c419173f07";
      })
    ];
    buildInputs =
      (self.nativeDeps."temp" or []);
    deps = {
      "rimraf-2.1.4" = self.by-version."rimraf"."2.1.4";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
    };
    peerDependencies = [
    ];
    passthru.names = [ "temp" ];
  };
  "temp" = self.by-version."temp"."0.6.0";
  by-spec."through"."~2.3.4" =
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
  by-spec."traverse"."0.6.x" =
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
  by-spec."traverse"."~0.5.1" =
    self.by-version."traverse"."0.5.2";
  by-version."traverse"."0.5.2" = lib.makeOverridable self.buildNodePackage {
    name = "traverse-0.5.2";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/traverse/-/traverse-0.5.2.tgz";
        name = "traverse-0.5.2.tgz";
        sha1 = "e203c58d5f7f0e37db6e74c0acb929bb09b61d85";
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
  by-spec."tunnel-agent"."~0.3.0" =
    self.by-version."tunnel-agent"."0.3.0";
  by-version."tunnel-agent"."0.3.0" = lib.makeOverridable self.buildNodePackage {
    name = "tunnel-agent-0.3.0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.3.0.tgz";
        name = "tunnel-agent-0.3.0.tgz";
        sha1 = "ad681b68f5321ad2827c4cfb1b7d5df2cfe942ee";
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
  by-spec."uglify-js"."~1.1.1" =
    self.by-version."uglify-js"."1.1.1";
  by-version."uglify-js"."1.1.1" = lib.makeOverridable self.buildNodePackage {
    name = "uglify-js-1.1.1";
    bin = true;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.1.1.tgz";
        name = "uglify-js-1.1.1.tgz";
        sha1 = "ee71a97c4cefd06a1a9b20437f34118982aa035b";
      })
    ];
    buildInputs =
      (self.nativeDeps."uglify-js" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "uglify-js" ];
  };
  by-spec."underscore"."~1.4.4" =
    self.by-version."underscore"."1.4.4";
  by-version."underscore"."1.4.4" = lib.makeOverridable self.buildNodePackage {
    name = "underscore-1.4.4";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/underscore/-/underscore-1.4.4.tgz";
        name = "underscore-1.4.4.tgz";
        sha1 = "61a6a32010622afa07963bf325203cf12239d604";
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
  by-spec."usb"."~0.3.11" =
    self.by-version."usb"."0.3.11";
  by-version."usb"."0.3.11" = lib.makeOverridable self.buildNodePackage {
    name = "usb-0.3.11";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/usb/-/usb-0.3.11.tgz";
        name = "usb-0.3.11.tgz";
        sha1 = "ee61d114181fd1de8738053920cde069d0aa428e";
      })
    ];
    buildInputs =
      (self.nativeDeps."usb" or []);
    deps = {
      "bindings-shyp-0.2.3" = self.by-version."bindings-shyp"."0.2.3";
      # "usb-shyp-win32-x64-0.3.11-0" = self.by-version."usb-shyp-win32-x64"."0.3.11-0";
      # "usb-shyp-win32-ia32-0.3.11-0" = self.by-version."usb-shyp-win32-ia32"."0.3.11-0";
      # "usb-shyp-darwin-x64-0.3.11-0" = self.by-version."usb-shyp-darwin-x64"."0.3.11-0";
    };
    peerDependencies = [
    ];
    passthru.names = [ "usb" ];
  };
  "usb" = self.by-version."usb"."0.3.11";
  by-spec."usb-shyp-darwin-x64"."0.3.x" =
    self.by-version."usb-shyp-darwin-x64"."0.3.11-0";
  by-version."usb-shyp-darwin-x64"."0.3.11-0" = lib.makeOverridable self.buildNodePackage {
    name = "usb-shyp-darwin-x64-0.3.11-0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/usb-shyp-darwin-x64/-/usb-shyp-darwin-x64-0.3.11-0.tgz";
        name = "usb-shyp-darwin-x64-0.3.11-0.tgz";
        sha1 = "8e6c98e5dff676576dac02c8a0465f1eae833285";
      })
    ];
    buildInputs =
      (self.nativeDeps."usb-shyp-darwin-x64" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "usb-shyp-darwin-x64" ];
  };
  by-spec."usb-shyp-win32-ia32"."0.3.x" =
    self.by-version."usb-shyp-win32-ia32"."0.3.11-0";
  by-version."usb-shyp-win32-ia32"."0.3.11-0" = lib.makeOverridable self.buildNodePackage {
    name = "usb-shyp-win32-ia32-0.3.11-0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/usb-shyp-win32-ia32/-/usb-shyp-win32-ia32-0.3.11-0.tgz";
        name = "usb-shyp-win32-ia32-0.3.11-0.tgz";
        sha1 = "365babb7f648cb8aff12f70c65445e1b0958bbbb";
      })
    ];
    buildInputs =
      (self.nativeDeps."usb-shyp-win32-ia32" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "usb-shyp-win32-ia32" ];
  };
  by-spec."usb-shyp-win32-x64"."0.3.x" =
    self.by-version."usb-shyp-win32-x64"."0.3.11-0";
  by-version."usb-shyp-win32-x64"."0.3.11-0" = lib.makeOverridable self.buildNodePackage {
    name = "usb-shyp-win32-x64-0.3.11-0";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/usb-shyp-win32-x64/-/usb-shyp-win32-x64-0.3.11-0.tgz";
        name = "usb-shyp-win32-x64-0.3.11-0.tgz";
        sha1 = "561417f00ab33c9d990a56e3a4ee446a21a3fcbe";
      })
    ];
    buildInputs =
      (self.nativeDeps."usb-shyp-win32-x64" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "usb-shyp-win32-x64" ];
  };
  by-spec."wordwrap"."~0.0.2" =
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
  by-spec."yamlish"."*" =
    self.by-version."yamlish"."0.0.6";
  by-version."yamlish"."0.0.6" = lib.makeOverridable self.buildNodePackage {
    name = "yamlish-0.0.6";
    bin = false;
    src = [
      (fetchurl {
        url = "http://registry.npmjs.org/yamlish/-/yamlish-0.0.6.tgz";
        name = "yamlish-0.0.6.tgz";
        sha1 = "c5df8f7661731351e39eb52223f83a46659452e3";
      })
    ];
    buildInputs =
      (self.nativeDeps."yamlish" or []);
    deps = {
    };
    peerDependencies = [
    ];
    passthru.names = [ "yamlish" ];
  };
}

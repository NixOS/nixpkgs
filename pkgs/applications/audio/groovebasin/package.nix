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
  by-spec."abbrev"."1" =
    self.by-version."abbrev"."1.0.7";
  by-version."abbrev"."1.0.7" = self.buildNodePackage {
    name = "abbrev-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/abbrev/-/abbrev-1.0.7.tgz";
      name = "abbrev-1.0.7.tgz";
      sha1 = "5b6035b2ee9d4fb5cf859f08a9be81b208491843";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."abstract-leveldown"."~2.2.1" =
    self.by-version."abstract-leveldown"."2.2.2";
  by-version."abstract-leveldown"."2.2.2" = self.buildNodePackage {
    name = "abstract-leveldown-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/abstract-leveldown/-/abstract-leveldown-2.2.2.tgz";
      name = "abstract-leveldown-2.2.2.tgz";
      sha1 = "ecaff98c20641422710ab04b01e8f04d6b64fe77";
    };
    deps = {
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."accepts"."~1.2.7" =
    self.by-version."accepts"."1.2.9";
  by-version."accepts"."1.2.9" = self.buildNodePackage {
    name = "accepts-1.2.9";
    version = "1.2.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/accepts/-/accepts-1.2.9.tgz";
      name = "accepts-1.2.9.tgz";
      sha1 = "76e9631d05e3ff192a34afb9389f7b3953ded001";
    };
    deps = {
      "mime-types-2.1.1" = self.by-version."mime-types"."2.1.1";
      "negotiator-0.5.3" = self.by-version."negotiator"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."0.1.1";
  by-version."amdefine"."0.1.1" = self.buildNodePackage {
    name = "amdefine-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/amdefine/-/amdefine-0.1.1.tgz";
      name = "amdefine-0.1.1.tgz";
      sha1 = "b5c75c532052dccd6a39c0064c772c8d57a06cd2";
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
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.2";
  by-version."async"."0.9.2" = self.buildNodePackage {
    name = "async-0.9.2";
    version = "0.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.9.2.tgz";
      name = "async-0.9.2.tgz";
      sha1 = "aea74d5e61c1f899613bf64bda66d4c78f2fd17d";
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
  by-spec."base64url"."0.0.3" =
    self.by-version."base64url"."0.0.3";
  by-version."base64url"."0.0.3" = self.buildNodePackage {
    name = "base64url-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64url/-/base64url-0.0.3.tgz";
      name = "base64url-0.0.3.tgz";
      sha1 = "50c20edac277dde1a0b15059954ced7a2d102d57";
    };
    deps = {
      "tap-0.3.3" = self.by-version."tap"."0.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64url"."~0.0.4" =
    self.by-version."base64url"."0.0.6";
  by-version."base64url"."0.0.6" = self.buildNodePackage {
    name = "base64url-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64url/-/base64url-0.0.6.tgz";
      name = "base64url-0.0.6.tgz";
      sha1 = "9597b36b330db1c42477322ea87ea8027499b82b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64url"."~1.0.4" =
    self.by-version."base64url"."1.0.4";
  by-version."base64url"."1.0.4" = self.buildNodePackage {
    name = "base64url-1.0.4";
    version = "1.0.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64url/-/base64url-1.0.4.tgz";
      name = "base64url-1.0.4.tgz";
      sha1 = "29a2a7ade9791fbb25f312ab35a2fd3126ceac0e";
    };
    deps = {
      "concat-stream-1.4.10" = self.by-version."concat-stream"."1.4.10";
      "meow-2.0.0" = self.by-version."meow"."2.0.0";
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
      url = "http://registry.npmjs.org/bindings/-/bindings-1.2.1.tgz";
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
  by-spec."bl"."~0.9.4" =
    self.by-version."bl"."0.9.4";
  by-spec."bluebird"."^2.9.26" =
    self.by-version."bluebird"."2.9.30";
  by-version."bluebird"."2.9.30" = self.buildNodePackage {
    name = "bluebird-2.9.30";
    version = "2.9.30";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.30.tgz";
      name = "bluebird-2.9.30.tgz";
      sha1 = "edda875ec9aad1f29cf1f56d6e82fbab2b0df556";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."0.4.x" =
    self.by-version."boom"."0.4.2";
  by-version."boom"."0.4.2" = self.buildNodePackage {
    name = "boom-0.4.2";
    version = "0.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-0.4.2.tgz";
      name = "boom-0.4.2.tgz";
      sha1 = "7a636e9ded4efcefb19cef4947a3c67dfaee911b";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."boom"."2.x.x" =
    self.by-version."boom"."2.8.0";
  by-version."boom"."2.8.0" = self.buildNodePackage {
    name = "boom-2.8.0";
    version = "2.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/boom/-/boom-2.8.0.tgz";
      name = "boom-2.8.0.tgz";
      sha1 = "317bdfd47018fe7dd79b0e9da73efe244119fdf1";
    };
    deps = {
      "hoek-2.14.0" = self.by-version."hoek"."2.14.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."browserify-lite"."~0.2.4" =
    self.by-version."browserify-lite"."0.2.4";
  by-version."browserify-lite"."0.2.4" = self.buildNodePackage {
    name = "browserify-lite-0.2.4";
    version = "0.2.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/browserify-lite/-/browserify-lite-0.2.4.tgz";
      name = "browserify-lite-0.2.4.tgz";
      sha1 = "00a32f466c8f3dbbd1074250fd0aa775716ab140";
    };
    deps = {
      "pend-1.2.0" = self.by-version."pend"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "browserify-lite" = self.by-version."browserify-lite"."0.2.4";
  by-spec."buffer-crc32"."~0.2.3" =
    self.by-version."buffer-crc32"."0.2.5";
  by-version."buffer-crc32"."0.2.5" = self.buildNodePackage {
    name = "buffer-crc32-0.2.5";
    version = "0.2.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/buffer-crc32/-/buffer-crc32-0.2.5.tgz";
      name = "buffer-crc32-0.2.5.tgz";
      sha1 = "db003ac2671e62ebd6ece78ea2c2e1b405736e91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-equal"."~0.0.0" =
    self.by-version."buffer-equal"."0.0.1";
  by-version."buffer-equal"."0.0.1" = self.buildNodePackage {
    name = "buffer-equal-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/buffer-equal/-/buffer-equal-0.0.1.tgz";
      name = "buffer-equal-0.0.1.tgz";
      sha1 = "91bc74b11ea405bc916bc6aa908faafa5b4aac4b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffer-equal-constant-time"."^1.0.1" =
    self.by-version."buffer-equal-constant-time"."1.0.1";
  by-version."buffer-equal-constant-time"."1.0.1" = self.buildNodePackage {
    name = "buffer-equal-constant-time-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/buffer-equal-constant-time/-/buffer-equal-constant-time-1.0.1.tgz";
      name = "buffer-equal-constant-time-1.0.1.tgz";
      sha1 = "f8e71132f7ffe6e01a5c9697a4c6f3e48d5cc819";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bunker"."0.1.X" =
    self.by-version."bunker"."0.1.2";
  by-version."bunker"."0.1.2" = self.buildNodePackage {
    name = "bunker-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bunker/-/bunker-0.1.2.tgz";
      name = "bunker-0.1.2.tgz";
      sha1 = "c88992464a8e2a6ede86930375f92b58077ef97c";
    };
    deps = {
      "burrito-0.2.12" = self.by-version."burrito"."0.2.12";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."burrito".">=0.2.5 <0.3" =
    self.by-version."burrito"."0.2.12";
  by-version."burrito"."0.2.12" = self.buildNodePackage {
    name = "burrito-0.2.12";
    version = "0.2.12";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/burrito/-/burrito-0.2.12.tgz";
      name = "burrito-0.2.12.tgz";
      sha1 = "d0d6e6ac81d5e99789c6fa4accb0b0031ea54f6b";
    };
    deps = {
      "traverse-0.5.2" = self.by-version."traverse"."0.5.2";
      "uglify-js-1.1.1" = self.by-version."uglify-js"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase"."^1.0.1" =
    self.by-version."camelcase"."1.1.0";
  by-version."camelcase"."1.1.0" = self.buildNodePackage {
    name = "camelcase-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/camelcase/-/camelcase-1.1.0.tgz";
      name = "camelcase-1.1.0.tgz";
      sha1 = "953b25c3bc98671ee59a44cb9d542672da7331b9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase-keys"."^1.0.0" =
    self.by-version."camelcase-keys"."1.0.0";
  by-version."camelcase-keys"."1.0.0" = self.buildNodePackage {
    name = "camelcase-keys-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/camelcase-keys/-/camelcase-keys-1.0.0.tgz";
      name = "camelcase-keys-1.0.0.tgz";
      sha1 = "bd1a11bf9b31a1ce493493a930de1a0baf4ad7ec";
    };
    deps = {
      "camelcase-1.1.0" = self.by-version."camelcase"."1.1.0";
      "map-obj-1.0.1" = self.by-version."map-obj"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.10.0" =
    self.by-version."caseless"."0.10.0";
  by-version."caseless"."0.10.0" = self.buildNodePackage {
    name = "caseless-0.10.0";
    version = "0.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.10.0.tgz";
      name = "caseless-0.10.0.tgz";
      sha1 = "ed6b2719adcd1fd18f58dc081c0f1a5b43963909";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.8.0" =
    self.by-version."caseless"."0.8.0";
  by-version."caseless"."0.8.0" = self.buildNodePackage {
    name = "caseless-0.8.0";
    version = "0.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/caseless/-/caseless-0.8.0.tgz";
      name = "caseless-0.8.0.tgz";
      sha1 = "5bca2881d41437f54b2407ebe34888c7b9ad4f7d";
    };
    deps = {
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
  by-spec."charm"."0.1.x" =
    self.by-version."charm"."0.1.2";
  by-version."charm"."0.1.2" = self.buildNodePackage {
    name = "charm-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/charm/-/charm-0.1.2.tgz";
      name = "charm-0.1.2.tgz";
      sha1 = "06c21eed1a1b06aeb67553cdc53e23274bac2296";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cheerio"."^0.18.0" =
    self.by-version."cheerio"."0.18.0";
  by-version."cheerio"."0.18.0" = self.buildNodePackage {
    name = "cheerio-0.18.0";
    version = "0.18.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cheerio/-/cheerio-0.18.0.tgz";
      name = "cheerio-0.18.0.tgz";
      sha1 = "4e1c06377e725b740e996e0dfec353863de677fa";
    };
    deps = {
      "CSSselect-0.4.1" = self.by-version."CSSselect"."0.4.1";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
      "htmlparser2-3.8.3" = self.by-version."htmlparser2"."3.8.3";
      "dom-serializer-0.0.1" = self.by-version."dom-serializer"."0.0.1";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."clarinet"."~0.8.1" =
    self.by-version."clarinet"."0.8.1";
  by-version."clarinet"."0.8.1" = self.buildNodePackage {
    name = "clarinet-0.8.1";
    version = "0.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/clarinet/-/clarinet-0.8.1.tgz";
      name = "clarinet-0.8.1.tgz";
      sha1 = "ddfd10cd292abf5cab239140774e394bfd1ee7a6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."combined-stream"."~1.0.1" =
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
  by-spec."commander"."^2.8.1" =
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
  by-spec."concat-stream"."~1.4.7" =
    self.by-version."concat-stream"."1.4.10";
  by-version."concat-stream"."1.4.10" = self.buildNodePackage {
    name = "concat-stream-1.4.10";
    version = "1.4.10";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/concat-stream/-/concat-stream-1.4.10.tgz";
      name = "concat-stream-1.4.10.tgz";
      sha1 = "acc3bbf5602cb8cc980c6ac840fa7d8603e3ef36";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."connect-static"."~1.5.0" =
    self.by-version."connect-static"."1.5.0";
  by-version."connect-static"."1.5.0" = self.buildNodePackage {
    name = "connect-static-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/connect-static/-/connect-static-1.5.0.tgz";
      name = "connect-static-1.5.0.tgz";
      sha1 = "f8b455532e04de7c3dc7c1e062207f0b7a626ec7";
    };
    deps = {
      "findit2-2.2.3" = self.by-version."findit2"."2.2.3";
      "mime-1.2.11" = self.by-version."mime"."1.2.11";
      "pend-1.2.0" = self.by-version."pend"."1.2.0";
      "streamsink-1.2.0" = self.by-version."streamsink"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "connect-static" = self.by-version."connect-static"."1.5.0";
  by-spec."content-disposition"."0.5.0" =
    self.by-version."content-disposition"."0.5.0";
  by-version."content-disposition"."0.5.0" = self.buildNodePackage {
    name = "content-disposition-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/content-disposition/-/content-disposition-0.5.0.tgz";
      name = "content-disposition-0.5.0.tgz";
      sha1 = "4284fe6ae0630874639e44e80a418c2934135e9e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-disposition"."~0.5.0" =
    self.by-version."content-disposition"."0.5.0";
  "content-disposition" = self.by-version."content-disposition"."0.5.0";
  by-spec."content-type"."~1.0.1" =
    self.by-version."content-type"."1.0.1";
  by-version."content-type"."1.0.1" = self.buildNodePackage {
    name = "content-type-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/content-type/-/content-type-1.0.1.tgz";
      name = "content-type-1.0.1.tgz";
      sha1 = "a19d2247327dc038050ce622b7a154ec59c5e600";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie"."0.1.2" =
    self.by-version."cookie"."0.1.2";
  by-version."cookie"."0.1.2" = self.buildNodePackage {
    name = "cookie-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie/-/cookie-0.1.2.tgz";
      name = "cookie-0.1.2.tgz";
      sha1 = "72fec3d24e48a3432073d90c12642005061004b1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-signature"."1.0.6" =
    self.by-version."cookie-signature"."1.0.6";
  by-version."cookie-signature"."1.0.6" = self.buildNodePackage {
    name = "cookie-signature-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz";
      name = "cookie-signature-1.0.6.tgz";
      sha1 = "e303a882b342cc3ee8ca513a79999734dab3ae2c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookies"."~0.5.0" =
    self.by-version."cookies"."0.5.0";
  by-version."cookies"."0.5.0" = self.buildNodePackage {
    name = "cookies-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookies/-/cookies-0.5.0.tgz";
      name = "cookies-0.5.0.tgz";
      sha1 = "164cac46a1d3ca3b3b87427414c24931d8381025";
    };
    deps = {
      "keygrip-1.0.1" = self.by-version."keygrip"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cookies" = self.by-version."cookies"."0.5.0";
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
  by-spec."crc"."3.2.1" =
    self.by-version."crc"."3.2.1";
  by-version."crc"."3.2.1" = self.buildNodePackage {
    name = "crc-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/crc/-/crc-3.2.1.tgz";
      name = "crc-3.2.1.tgz";
      sha1 = "5d9c8fb77a245cd5eca291e5d2d005334bab0082";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cryptiles"."0.2.x" =
    self.by-version."cryptiles"."0.2.2";
  by-version."cryptiles"."0.2.2" = self.buildNodePackage {
    name = "cryptiles-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cryptiles/-/cryptiles-0.2.2.tgz";
      name = "cryptiles-0.2.2.tgz";
      sha1 = "ed91ff1f17ad13d3748288594f8a48a0d26f325c";
    };
    deps = {
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
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
      "boom-2.8.0" = self.by-version."boom"."2.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."css-parse"."1.7.x" =
    self.by-version."css-parse"."1.7.0";
  by-version."css-parse"."1.7.0" = self.buildNodePackage {
    name = "css-parse-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/css-parse/-/css-parse-1.7.0.tgz";
      name = "css-parse-1.7.0.tgz";
      sha1 = "321f6cf73782a6ff751111390fc05e2c657d8c9b";
    };
    deps = {
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
  by-spec."curlydiff"."~2.0.1" =
    self.by-version."curlydiff"."2.0.1";
  by-version."curlydiff"."2.0.1" = self.buildNodePackage {
    name = "curlydiff-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/curlydiff/-/curlydiff-2.0.1.tgz";
      name = "curlydiff-2.0.1.tgz";
      sha1 = "6ac4b754ea5b63af2632022d03a152306f7eac0b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "curlydiff" = self.by-version."curlydiff"."2.0.1";
  by-spec."debug"."*" =
    self.by-version."debug"."2.2.0";
  by-version."debug"."2.2.0" = self.buildNodePackage {
    name = "debug-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-2.2.0.tgz";
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
  by-spec."debug"."~2.2.0" =
    self.by-version."debug"."2.2.0";
  by-spec."deep-equal"."~0.0.0" =
    self.by-version."deep-equal"."0.0.0";
  by-version."deep-equal"."0.0.0" = self.buildNodePackage {
    name = "deep-equal-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-equal/-/deep-equal-0.0.0.tgz";
      name = "deep-equal-0.0.0.tgz";
      sha1 = "99679d3bbd047156fcd450d3d01eeb9068691e83";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."deep-is"."0.1.x" =
    self.by-version."deep-is"."0.1.3";
  by-version."deep-is"."0.1.3" = self.buildNodePackage {
    name = "deep-is-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/deep-is/-/deep-is-0.1.3.tgz";
      name = "deep-is-0.1.3.tgz";
      sha1 = "b369d6fb5dbc13eecf524f91b070feedc357cf34";
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
  by-spec."depd"."~1.0.1" =
    self.by-version."depd"."1.0.1";
  by-version."depd"."1.0.1" = self.buildNodePackage {
    name = "depd-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/depd/-/depd-1.0.1.tgz";
      name = "depd-1.0.1.tgz";
      sha1 = "80aec64c9d6d97e65cc2a9caa93c0aa6abf73aaa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."destroy"."1.0.3" =
    self.by-version."destroy"."1.0.3";
  by-version."destroy"."1.0.3" = self.buildNodePackage {
    name = "destroy-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/destroy/-/destroy-1.0.3.tgz";
      name = "destroy-1.0.3.tgz";
      sha1 = "b433b4724e71fd8551d9885174851c5fc377e2c9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."diacritics"."~1.2.1" =
    self.by-version."diacritics"."1.2.1";
  by-version."diacritics"."1.2.1" = self.buildNodePackage {
    name = "diacritics-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/diacritics/-/diacritics-1.2.1.tgz";
      name = "diacritics-1.2.1.tgz";
      sha1 = "e4d323a7c564197f7af514c5964bd45d0eb8cf77";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."difflet"."~0.2.0" =
    self.by-version."difflet"."0.2.6";
  by-version."difflet"."0.2.6" = self.buildNodePackage {
    name = "difflet-0.2.6";
    version = "0.2.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/difflet/-/difflet-0.2.6.tgz";
      name = "difflet-0.2.6.tgz";
      sha1 = "ab23b31f5649b6faa8e3d2acbd334467365ca6fa";
    };
    deps = {
      "traverse-0.6.6" = self.by-version."traverse"."0.6.6";
      "charm-0.1.2" = self.by-version."charm"."0.1.2";
      "deep-is-0.1.3" = self.by-version."deep-is"."0.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dom-serializer"."0" =
    self.by-version."dom-serializer"."0.1.0";
  by-version."dom-serializer"."0.1.0" = self.buildNodePackage {
    name = "dom-serializer-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dom-serializer/-/dom-serializer-0.1.0.tgz";
      name = "dom-serializer-0.1.0.tgz";
      sha1 = "073c697546ce0780ce23be4a28e293e40bc30c82";
    };
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."dom-serializer"."~0.0.0" =
    self.by-version."dom-serializer"."0.0.1";
  by-version."dom-serializer"."0.0.1" = self.buildNodePackage {
    name = "dom-serializer-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dom-serializer/-/dom-serializer-0.0.1.tgz";
      name = "dom-serializer-0.0.1.tgz";
      sha1 = "9589827f1e32d22c37c829adabd59b3247af8eaf";
    };
    deps = {
      "domelementtype-1.1.3" = self.by-version."domelementtype"."1.1.3";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
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
  by-spec."domelementtype"."~1.1.1" =
    self.by-version."domelementtype"."1.1.3";
  by-version."domelementtype"."1.1.3" = self.buildNodePackage {
    name = "domelementtype-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domelementtype/-/domelementtype-1.1.3.tgz";
      name = "domelementtype-1.1.3.tgz";
      sha1 = "bd28773e2642881aec51544924299c5cd822185b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."domhandler"."2.3" =
    self.by-version."domhandler"."2.3.0";
  by-version."domhandler"."2.3.0" = self.buildNodePackage {
    name = "domhandler-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domhandler/-/domhandler-2.3.0.tgz";
      name = "domhandler-2.3.0.tgz";
      sha1 = "2de59a0822d5027fabff6f032c2b25a2a8abe738";
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
  by-spec."domutils"."1.5" =
    self.by-version."domutils"."1.5.1";
  by-version."domutils"."1.5.1" = self.buildNodePackage {
    name = "domutils-1.5.1";
    version = "1.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/domutils/-/domutils-1.5.1.tgz";
      name = "domutils-1.5.1.tgz";
      sha1 = "dcd8488a26f563d61079e48c9f7b7e32373682cf";
    };
    deps = {
      "dom-serializer-0.1.0" = self.by-version."dom-serializer"."0.1.0";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ee-first"."1.1.0" =
    self.by-version."ee-first"."1.1.0";
  by-version."ee-first"."1.1.0" = self.buildNodePackage {
    name = "ee-first-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ee-first/-/ee-first-1.1.0.tgz";
      name = "ee-first-1.1.0.tgz";
      sha1 = "6a0d7c6221e490feefd92ec3f441c9ce8cd097f4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."entities"."1.0" =
    self.by-version."entities"."1.0.0";
  by-version."entities"."1.0.0" = self.buildNodePackage {
    name = "entities-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/entities/-/entities-1.0.0.tgz";
      name = "entities-1.0.0.tgz";
      sha1 = "b2987aa3821347fcde642b24fdfc9e4fb712bf26";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."entities"."~1.1.1" =
    self.by-version."entities"."1.1.1";
  by-version."entities"."1.1.1" = self.buildNodePackage {
    name = "entities-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/entities/-/entities-1.1.1.tgz";
      name = "entities-1.1.1.tgz";
      sha1 = "6e5c2d0a5621b5dadaecef80b90edfb5cd7772f0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-html"."1.0.1" =
    self.by-version."escape-html"."1.0.1";
  by-version."escape-html"."1.0.1" = self.buildNodePackage {
    name = "escape-html-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.1.tgz";
      name = "escape-html-1.0.1.tgz";
      sha1 = "181a286ead397a39a92857cfb1d43052e356bff0";
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
  by-spec."etag"."~1.6.0" =
    self.by-version."etag"."1.6.0";
  by-version."etag"."1.6.0" = self.buildNodePackage {
    name = "etag-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/etag/-/etag-1.6.0.tgz";
      name = "etag-1.6.0.tgz";
      sha1 = "8bcb2c6af1254c481dfc8b997c906ef4e442c207";
    };
    deps = {
      "crc-3.2.1" = self.by-version."crc"."3.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."~4.12.3" =
    self.by-version."express"."4.12.4";
  by-version."express"."4.12.4" = self.buildNodePackage {
    name = "express-4.12.4";
    version = "4.12.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/express/-/express-4.12.4.tgz";
      name = "express-4.12.4.tgz";
      sha1 = "8fec2510255bc6b2e58107c48239c0fa307c1aa2";
    };
    deps = {
      "accepts-1.2.9" = self.by-version."accepts"."1.2.9";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "cookie-0.1.2" = self.by-version."cookie"."0.1.2";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.6.0" = self.by-version."etag"."1.6.0";
      "finalhandler-0.3.6" = self.by-version."finalhandler"."0.3.6";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "merge-descriptors-1.0.0" = self.by-version."merge-descriptors"."1.0.0";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.3" = self.by-version."path-to-regexp"."0.1.3";
      "proxy-addr-1.0.8" = self.by-version."proxy-addr"."1.0.8";
      "qs-2.4.2" = self.by-version."qs"."2.4.2";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.12.3" = self.by-version."send"."0.12.3";
      "serve-static-1.9.3" = self.by-version."serve-static"."1.9.3";
      "type-is-1.6.3" = self.by-version."type-is"."1.6.3";
      "vary-1.0.0" = self.by-version."vary"."1.0.0";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."4.12.4";
  by-spec."fast-future"."~1.0.0" =
    self.by-version."fast-future"."1.0.1";
  by-version."fast-future"."1.0.1" = self.buildNodePackage {
    name = "fast-future-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fast-future/-/fast-future-1.0.1.tgz";
      name = "fast-future-1.0.1.tgz";
      sha1 = "6cbd22d999ab39cd10fc79392486e7a678716818";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fd-slicer"."~1.0.0" =
    self.by-version."fd-slicer"."1.0.1";
  by-version."fd-slicer"."1.0.1" = self.buildNodePackage {
    name = "fd-slicer-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fd-slicer/-/fd-slicer-1.0.1.tgz";
      name = "fd-slicer-1.0.1.tgz";
      sha1 = "8b5bcbd9ec327c5041bf9ab023fd6750f1177e65";
    };
    deps = {
      "pend-1.2.0" = self.by-version."pend"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fd-slicer"."~1.0.1" =
    self.by-version."fd-slicer"."1.0.1";
  by-spec."finalhandler"."0.3.6" =
    self.by-version."finalhandler"."0.3.6";
  by-version."finalhandler"."0.3.6" = self.buildNodePackage {
    name = "finalhandler-0.3.6";
    version = "0.3.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.3.6.tgz";
      name = "finalhandler-0.3.6.tgz";
      sha1 = "daf9c4161b1b06e001466b1411dfdb6973be138b";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."findit2"."~2.2.3" =
    self.by-version."findit2"."2.2.3";
  by-version."findit2"."2.2.3" = self.buildNodePackage {
    name = "findit2-2.2.3";
    version = "2.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/findit2/-/findit2-2.2.3.tgz";
      name = "findit2-2.2.3.tgz";
      sha1 = "58a466697df8a6205cdfdbf395536b8bd777a5f6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "findit2" = self.by-version."findit2"."2.2.3";
  by-spec."forever-agent"."~0.5.0" =
    self.by-version."forever-agent"."0.5.2";
  by-version."forever-agent"."0.5.2" = self.buildNodePackage {
    name = "forever-agent-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forever-agent/-/forever-agent-0.5.2.tgz";
      name = "forever-agent-0.5.2.tgz";
      sha1 = "6d0e09c4921f94a27f63d3b49c5feff1ea4c5130";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."forwarded"."~0.1.0" =
    self.by-version."forwarded"."0.1.0";
  by-version."forwarded"."0.1.0" = self.buildNodePackage {
    name = "forwarded-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
      name = "forwarded-0.1.0.tgz";
      sha1 = "19ef9874c4ae1c297bcf078fde63a09b66a84363";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fresh"."0.2.4" =
    self.by-version."fresh"."0.2.4";
  by-version."fresh"."0.2.4" = self.buildNodePackage {
    name = "fresh-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fresh/-/fresh-0.2.4.tgz";
      name = "fresh-0.2.4.tgz";
      sha1 = "3582499206c9723714190edd74b4604feb4a614c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gapitoken"."~0.1.2" =
    self.by-version."gapitoken"."0.1.4";
  by-version."gapitoken"."0.1.4" = self.buildNodePackage {
    name = "gapitoken-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gapitoken/-/gapitoken-0.1.4.tgz";
      name = "gapitoken-0.1.4.tgz";
      sha1 = "643dedb26cb142466f62b73d2782e7822a6f1ad8";
    };
    deps = {
      "jws-0.0.2" = self.by-version."jws"."0.0.2";
      "request-2.57.0" = self.by-version."request"."2.57.0";
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
  by-spec."glob"."3.2.x" =
    self.by-version."glob"."3.2.11";
  by-version."glob"."3.2.11" = self.buildNodePackage {
    name = "glob-3.2.11";
    version = "3.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-3.2.11.tgz";
      name = "glob-3.2.11.tgz";
      sha1 = "4a973f635b9190f715d10987d5c00fd2815ebe3d";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-0.3.0" = self.by-version."minimatch"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."google-auth-library"."~0.9.3" =
    self.by-version."google-auth-library"."0.9.6";
  by-version."google-auth-library"."0.9.6" = self.buildNodePackage {
    name = "google-auth-library-0.9.6";
    version = "0.9.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/google-auth-library/-/google-auth-library-0.9.6.tgz";
      name = "google-auth-library-0.9.6.tgz";
      sha1 = "57aa09f2621d6eafe8852b0167c9100759a67220";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "gtoken-1.1.1" = self.by-version."gtoken"."1.1.1";
      "lodash.noop-3.0.0" = self.by-version."lodash.noop"."3.0.0";
      "jws-3.0.0" = self.by-version."jws"."3.0.0";
      "request-2.51.0" = self.by-version."request"."2.51.0";
      "string-template-0.2.1" = self.by-version."string-template"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."google-p12-pem"."^0.0.1" =
    self.by-version."google-p12-pem"."0.0.1";
  by-version."google-p12-pem"."0.0.1" = self.buildNodePackage {
    name = "google-p12-pem-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/google-p12-pem/-/google-p12-pem-0.0.1.tgz";
      name = "google-p12-pem-0.0.1.tgz";
      sha1 = "965638d464f13b4a866356a5ba047163ec0b08b7";
    };
    deps = {
      "node-forge-0.6.16" = self.by-version."node-forge"."0.6.16";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."googleapis"."~2.0.3" =
    self.by-version."googleapis"."2.0.5";
  by-version."googleapis"."2.0.5" = self.buildNodePackage {
    name = "googleapis-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/googleapis/-/googleapis-2.0.5.tgz";
      name = "googleapis-2.0.5.tgz";
      sha1 = "fb2d678f97152eb0a336da84bbc1eeb16a9c8310";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "gapitoken-0.1.4" = self.by-version."gapitoken"."0.1.4";
      "google-auth-library-0.9.6" = self.by-version."google-auth-library"."0.9.6";
      "request-2.54.0" = self.by-version."request"."2.54.0";
      "string-template-0.2.1" = self.by-version."string-template"."0.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "googleapis" = self.by-version."googleapis"."2.0.5";
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
  by-spec."groove"."~2.3.3" =
    self.by-version."groove"."2.3.4";
  by-version."groove"."2.3.4" = self.buildNodePackage {
    name = "groove-2.3.4";
    version = "2.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/groove/-/groove-2.3.4.tgz";
      name = "groove-2.3.4.tgz";
      sha1 = "bbfb8e40584c5921f6df9d52d4017f2acb0a7e45";
    };
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-1.8.4" = self.by-version."nan"."1.8.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "groove" = self.by-version."groove"."2.3.4";
  by-spec."gtoken"."^1.1.0" =
    self.by-version."gtoken"."1.1.1";
  by-version."gtoken"."1.1.1" = self.buildNodePackage {
    name = "gtoken-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gtoken/-/gtoken-1.1.1.tgz";
      name = "gtoken-1.1.1.tgz";
      sha1 = "969af828d1f7efea32a500ea09b0edfa8e0c438a";
    };
    deps = {
      "google-p12-pem-0.0.1" = self.by-version."google-p12-pem"."0.0.1";
      "jws-3.0.0" = self.by-version."jws"."3.0.0";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "request-2.57.0" = self.by-version."request"."2.57.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."^1.4.0" =
    self.by-version."har-validator"."1.7.1";
  by-version."har-validator"."1.7.1" = self.buildNodePackage {
    name = "har-validator-1.7.1";
    version = "1.7.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/har-validator/-/har-validator-1.7.1.tgz";
      name = "har-validator-1.7.1.tgz";
      sha1 = "8ec8952f8287d21b451ba3e36f27ed8d997d8a95";
    };
    deps = {
      "bluebird-2.9.30" = self.by-version."bluebird"."2.9.30";
      "chalk-1.0.0" = self.by-version."chalk"."1.0.0";
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "is-my-json-valid-2.12.0" = self.by-version."is-my-json-valid"."2.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."^1.6.1" =
    self.by-version."har-validator"."1.7.1";
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
  by-spec."hawk"."1.1.1" =
    self.by-version."hawk"."1.1.1";
  by-version."hawk"."1.1.1" = self.buildNodePackage {
    name = "hawk-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-1.1.1.tgz";
      name = "hawk-1.1.1.tgz";
      sha1 = "87cd491f9b46e4e2aeaca335416766885d2d1ed9";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
      "boom-0.4.2" = self.by-version."boom"."0.4.2";
      "cryptiles-0.2.2" = self.by-version."cryptiles"."0.2.2";
      "sntp-0.2.4" = self.by-version."sntp"."0.2.4";
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
      "hoek-2.14.0" = self.by-version."hoek"."2.14.0";
      "boom-2.8.0" = self.by-version."boom"."2.8.0";
      "cryptiles-2.0.4" = self.by-version."cryptiles"."2.0.4";
      "sntp-1.0.9" = self.by-version."sntp"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hoek"."0.9.x" =
    self.by-version."hoek"."0.9.1";
  by-version."hoek"."0.9.1" = self.buildNodePackage {
    name = "hoek-0.9.1";
    version = "0.9.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-0.9.1.tgz";
      name = "hoek-0.9.1.tgz";
      sha1 = "3d322462badf07716ea7eb85baf88079cddce505";
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
    self.by-version."hoek"."2.14.0";
  by-version."hoek"."2.14.0" = self.buildNodePackage {
    name = "hoek-2.14.0";
    version = "2.14.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hoek/-/hoek-2.14.0.tgz";
      name = "hoek-2.14.0.tgz";
      sha1 = "81211691f52a5a835ae49edbf1e89c9003476aa4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."htmlparser2"."~3.8.1" =
    self.by-version."htmlparser2"."3.8.3";
  by-version."htmlparser2"."3.8.3" = self.buildNodePackage {
    name = "htmlparser2-3.8.3";
    version = "3.8.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.8.3.tgz";
      name = "htmlparser2-3.8.3.tgz";
      sha1 = "996c28b191516a8be86501a7d79757e5c70c1068";
    };
    deps = {
      "domhandler-2.3.0" = self.by-version."domhandler"."2.3.0";
      "domutils-1.5.1" = self.by-version."domutils"."1.5.1";
      "domelementtype-1.3.0" = self.by-version."domelementtype"."1.3.0";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "entities-1.0.0" = self.by-version."entities"."1.0.0";
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
  by-spec."http-signature"."~0.11.0" =
    self.by-version."http-signature"."0.11.0";
  by-version."http-signature"."0.11.0" = self.buildNodePackage {
    name = "http-signature-0.11.0";
    version = "0.11.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-signature/-/http-signature-0.11.0.tgz";
      name = "http-signature-0.11.0.tgz";
      sha1 = "1796cf67a001ad5cd6849dca0991485f09089fe6";
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
  by-spec."httpolyglot"."~0.1.1" =
    self.by-version."httpolyglot"."0.1.1";
  by-version."httpolyglot"."0.1.1" = self.buildNodePackage {
    name = "httpolyglot-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/httpolyglot/-/httpolyglot-0.1.1.tgz";
      name = "httpolyglot-0.1.1.tgz";
      sha1 = "cd0f5c995cbb95dde325d16a7537f90c0048e53d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "httpolyglot" = self.by-version."httpolyglot"."0.1.1";
  by-spec."human-size"."~1.1.0" =
    self.by-version."human-size"."1.1.0";
  by-version."human-size"."1.1.0" = self.buildNodePackage {
    name = "human-size-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/human-size/-/human-size-1.1.0.tgz";
      name = "human-size-1.1.0.tgz";
      sha1 = "052562be999841c037022c20259990c56ea996f9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "human-size" = self.by-version."human-size"."1.1.0";
  by-spec."indent-string"."^1.1.0" =
    self.by-version."indent-string"."1.2.1";
  by-version."indent-string"."1.2.1" = self.buildNodePackage {
    name = "indent-string-1.2.1";
    version = "1.2.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/indent-string/-/indent-string-1.2.1.tgz";
      name = "indent-string-1.2.1.tgz";
      sha1 = "294c5930792f8bb5b14462a4aa425b94f07d3a56";
    };
    deps = {
      "get-stdin-4.0.1" = self.by-version."get-stdin"."4.0.1";
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
      "repeating-1.1.3" = self.by-version."repeating"."1.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."*" =
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
  by-spec."inherits"."2" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ipaddr.js"."1.0.1" =
    self.by-version."ipaddr.js"."1.0.1";
  by-version."ipaddr.js"."1.0.1" = self.buildNodePackage {
    name = "ipaddr.js-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.0.1.tgz";
      name = "ipaddr.js-1.0.1.tgz";
      sha1 = "5f38801dc73e0400fc7076386f6ed5215fbd8f95";
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
    self.by-version."is-finite"."1.0.1";
  by-version."is-finite"."1.0.1" = self.buildNodePackage {
    name = "is-finite-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-finite/-/is-finite-1.0.1.tgz";
      name = "is-finite-1.0.1.tgz";
      sha1 = "6438603eaebe2793948ff4a4262ec8db3d62597b";
    };
    deps = {
      "number-is-nan-1.0.0" = self.by-version."number-is-nan"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.12.0" =
    self.by-version."is-my-json-valid"."2.12.0";
  by-version."is-my-json-valid"."2.12.0" = self.buildNodePackage {
    name = "is-my-json-valid-2.12.0";
    version = "2.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.12.0.tgz";
      name = "is-my-json-valid-2.12.0.tgz";
      sha1 = "8fa6c408b26be95b45a23e8f8c4b464a53874d2b";
    };
    deps = {
      "generate-function-2.0.0" = self.by-version."generate-function"."2.0.0";
      "generate-object-property-1.2.0" = self.by-version."generate-object-property"."1.2.0";
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
  by-spec."isstream"."~0.1.1" =
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
  by-spec."json-stringify-safe"."~5.0.0" =
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
  by-spec."jstream"."~0.2.7" =
    self.by-version."jstream"."0.2.7";
  by-version."jstream"."0.2.7" = self.buildNodePackage {
    name = "jstream-0.2.7";
    version = "0.2.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jstream/-/jstream-0.2.7.tgz";
      name = "jstream-0.2.7.tgz";
      sha1 = "55f06cd6d4204caeac4907a5de1b90aabf4d60da";
    };
    deps = {
      "clarinet-0.8.1" = self.by-version."clarinet"."0.8.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jwa"."~1.0.0" =
    self.by-version."jwa"."1.0.0";
  by-version."jwa"."1.0.0" = self.buildNodePackage {
    name = "jwa-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jwa/-/jwa-1.0.0.tgz";
      name = "jwa-1.0.0.tgz";
      sha1 = "040b64fb582171a65f3368e96837ea4dcf42f3d8";
    };
    deps = {
      "base64url-0.0.6" = self.by-version."base64url"."0.0.6";
      "buffer-equal-constant-time-1.0.1" = self.by-version."buffer-equal-constant-time"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jws"."0.0.2" =
    self.by-version."jws"."0.0.2";
  by-version."jws"."0.0.2" = self.buildNodePackage {
    name = "jws-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jws/-/jws-0.0.2.tgz";
      name = "jws-0.0.2.tgz";
      sha1 = "8c6916977183cce3361da48c8c2e0c606e7a95c6";
    };
    deps = {
      "tap-0.3.3" = self.by-version."tap"."0.3.3";
      "base64url-0.0.3" = self.by-version."base64url"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jws"."^3.0.0" =
    self.by-version."jws"."3.0.0";
  by-version."jws"."3.0.0" = self.buildNodePackage {
    name = "jws-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jws/-/jws-3.0.0.tgz";
      name = "jws-3.0.0.tgz";
      sha1 = "da5f267897dd4e9cf8137979db33fc54a3c05418";
    };
    deps = {
      "jwa-1.0.0" = self.by-version."jwa"."1.0.0";
      "base64url-1.0.4" = self.by-version."base64url"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."jws"."~3.0.0" =
    self.by-version."jws"."3.0.0";
  by-spec."keese"."~1.1.1" =
    self.by-version."keese"."1.1.1";
  by-version."keese"."1.1.1" = self.buildNodePackage {
    name = "keese-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keese/-/keese-1.1.1.tgz";
      name = "keese-1.1.1.tgz";
      sha1 = "69a1f971e64ee5d2094af002f6d92fa806250842";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "keese" = self.by-version."keese"."1.1.1";
  by-spec."keygrip"."~1.0.0" =
    self.by-version."keygrip"."1.0.1";
  by-version."keygrip"."1.0.1" = self.buildNodePackage {
    name = "keygrip-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/keygrip/-/keygrip-1.0.1.tgz";
      name = "keygrip-1.0.1.tgz";
      sha1 = "b02fa4816eef21a8c4b35ca9e52921ffc89a30e9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lastfm"."~0.9.2" =
    self.by-version."lastfm"."0.9.2";
  by-version."lastfm"."0.9.2" = self.buildNodePackage {
    name = "lastfm-0.9.2";
    version = "0.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lastfm/-/lastfm-0.9.2.tgz";
      name = "lastfm-0.9.2.tgz";
      sha1 = "d00ca2e3b30eb484e510792875525900e4d77d88";
    };
    deps = {
      "underscore-1.6.0" = self.by-version."underscore"."1.6.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "lastfm" = self.by-version."lastfm"."0.9.2";
  by-spec."leveldown"."~1.0.6" =
    self.by-version."leveldown"."1.0.7";
  by-version."leveldown"."1.0.7" = self.buildNodePackage {
    name = "leveldown-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/leveldown/-/leveldown-1.0.7.tgz";
      name = "leveldown-1.0.7.tgz";
      sha1 = "39bbe95f92ce09992ec12de47ade5167be2b6874";
    };
    deps = {
      "abstract-leveldown-2.2.2" = self.by-version."abstract-leveldown"."2.2.2";
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "fast-future-1.0.1" = self.by-version."fast-future"."1.0.1";
      "nan-1.8.4" = self.by-version."nan"."1.8.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "leveldown" = self.by-version."leveldown"."1.0.7";
  by-spec."lodash"."~2.4.1" =
    self.by-version."lodash"."2.4.2";
  by-version."lodash"."2.4.2" = self.buildNodePackage {
    name = "lodash-2.4.2";
    version = "2.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-2.4.2.tgz";
      name = "lodash-2.4.2.tgz";
      sha1 = "fadd834b9683073da179b3eae6d9c0d15053f73e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.noop"."~3.0.0" =
    self.by-version."lodash.noop"."3.0.0";
  by-version."lodash.noop"."3.0.0" = self.buildNodePackage {
    name = "lodash.noop-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.noop/-/lodash.noop-3.0.0.tgz";
      name = "lodash.noop-3.0.0.tgz";
      sha1 = "f383ca8dba97d8f217e49afcd2b824db9e5e8d68";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.6.4";
  by-version."lru-cache"."2.6.4" = self.buildNodePackage {
    name = "lru-cache-2.6.4";
    version = "2.6.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.6.4.tgz";
      name = "lru-cache-2.6.4.tgz";
      sha1 = "2675190ccd1b0701ec2f652a4d0d3d400d76c0dd";
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
      url = "http://registry.npmjs.org/map-obj/-/map-obj-1.0.1.tgz";
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
  by-spec."media-typer"."0.3.0" =
    self.by-version."media-typer"."0.3.0";
  by-version."media-typer"."0.3.0" = self.buildNodePackage {
    name = "media-typer-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
      name = "media-typer-0.3.0.tgz";
      sha1 = "8710d7af0aa626f8fffa1ce00168545263255748";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."meow"."~2.0.0" =
    self.by-version."meow"."2.0.0";
  by-version."meow"."2.0.0" = self.buildNodePackage {
    name = "meow-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/meow/-/meow-2.0.0.tgz";
      name = "meow-2.0.0.tgz";
      sha1 = "8f530a8ecf5d40d3f4b4df93c3472900fba2a8f1";
    };
    deps = {
      "camelcase-keys-1.0.0" = self.by-version."camelcase-keys"."1.0.0";
      "indent-string-1.2.1" = self.by-version."indent-string"."1.2.1";
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
      "object-assign-1.0.0" = self.by-version."object-assign"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."merge-descriptors"."1.0.0" =
    self.by-version."merge-descriptors"."1.0.0";
  by-version."merge-descriptors"."1.0.0" = self.buildNodePackage {
    name = "merge-descriptors-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.0.tgz";
      name = "merge-descriptors-1.0.0.tgz";
      sha1 = "2169cf7538e1b0cc87fb88e1502d8474bbf79864";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mess"."~0.1.2" =
    self.by-version."mess"."0.1.2";
  by-version."mess"."0.1.2" = self.buildNodePackage {
    name = "mess-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mess/-/mess-0.1.2.tgz";
      name = "mess-0.1.2.tgz";
      sha1 = "2c81a424efc87a69ad11f1c7129d1f6f6353b9c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mess" = self.by-version."mess"."0.1.2";
  by-spec."methods"."~1.1.1" =
    self.by-version."methods"."1.1.1";
  by-version."methods"."1.1.1" = self.buildNodePackage {
    name = "methods-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/methods/-/methods-1.1.1.tgz";
      name = "methods-1.1.1.tgz";
      sha1 = "17ea6366066d00c58e375b8ec7dfd0453c89822a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."1.3.4" =
    self.by-version."mime"."1.3.4";
  by-version."mime"."1.3.4" = self.buildNodePackage {
    name = "mime-1.3.4";
    version = "1.3.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.3.4.tgz";
      name = "mime-1.3.4.tgz";
      sha1 = "115f9e3b6b3daf2959983cb38f149a2d40eb5d53";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."^1.2.11" =
    self.by-version."mime"."1.3.4";
  by-spec."mime"."~1.2.11" =
    self.by-version."mime"."1.2.11";
  by-version."mime"."1.2.11" = self.buildNodePackage {
    name = "mime-1.2.11";
    version = "1.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime/-/mime-1.2.11.tgz";
      name = "mime-1.2.11.tgz";
      sha1 = "58203eed86e3a5ef17aed2b7d9ebd47f0a60dd10";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.12.0" =
    self.by-version."mime-db"."1.12.0";
  by-version."mime-db"."1.12.0" = self.buildNodePackage {
    name = "mime-db-1.12.0";
    version = "1.12.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.12.0.tgz";
      name = "mime-db-1.12.0.tgz";
      sha1 = "3d0c63180f458eb10d325aaa37d7c58ae312e9d7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-db"."~1.13.0" =
    self.by-version."mime-db"."1.13.0";
  by-version."mime-db"."1.13.0" = self.buildNodePackage {
    name = "mime-db-1.13.0";
    version = "1.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.13.0.tgz";
      name = "mime-db-1.13.0.tgz";
      sha1 = "fd6808168fe30835e7ea2205fc981d3b633e4e34";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~1.0.1" =
    self.by-version."mime-types"."1.0.2";
  by-version."mime-types"."1.0.2" = self.buildNodePackage {
    name = "mime-types-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-1.0.2.tgz";
      name = "mime-types-1.0.2.tgz";
      sha1 = "995ae1392ab8affcbfcb2641dd054e943c0d5dce";
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
    self.by-version."mime-types"."2.0.14";
  by-version."mime-types"."2.0.14" = self.buildNodePackage {
    name = "mime-types-2.0.14";
    version = "2.0.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.0.14.tgz";
      name = "mime-types-2.0.14.tgz";
      sha1 = "310e159db23e077f8bb22b748dabfa4957140aa6";
    };
    deps = {
      "mime-db-1.12.0" = self.by-version."mime-db"."1.12.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.0.3" =
    self.by-version."mime-types"."2.0.14";
  by-spec."mime-types"."~2.1.1" =
    self.by-version."mime-types"."2.1.1";
  by-version."mime-types"."2.1.1" = self.buildNodePackage {
    name = "mime-types-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.1.tgz";
      name = "mime-types-2.1.1.tgz";
      sha1 = "c7b692796d5166f4826d10b4675c8a916657d04e";
    };
    deps = {
      "mime-db-1.13.0" = self.by-version."mime-db"."1.13.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."0.3" =
    self.by-version."minimatch"."0.3.0";
  by-version."minimatch"."0.3.0" = self.buildNodePackage {
    name = "minimatch-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-0.3.0.tgz";
      name = "minimatch-0.3.0.tgz";
      sha1 = "275d8edaac4f1bb3326472089e7949c8394699dd";
    };
    deps = {
      "lru-cache-2.6.4" = self.by-version."lru-cache"."2.6.4";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimist"."0.0.8" =
    self.by-version."minimist"."0.0.8";
  by-version."minimist"."0.0.8" = self.buildNodePackage {
    name = "minimist-0.0.8";
    version = "0.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimist/-/minimist-0.0.8.tgz";
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
  by-spec."mkdirp"."0.3.x" =
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
  by-spec."mkdirp"."~0.3" =
    self.by-version."mkdirp"."0.3.5";
  by-spec."mkdirp"."~0.5.0" =
    self.by-version."mkdirp"."0.5.1";
  by-version."mkdirp"."0.5.1" = self.buildNodePackage {
    name = "mkdirp-0.5.1";
    version = "0.5.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.1.tgz";
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
  by-spec."mkdirp"."~0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  "mkdirp" = self.by-version."mkdirp"."0.5.1";
  by-spec."ms"."0.7.1" =
    self.by-version."ms"."0.7.1";
  by-version."ms"."0.7.1" = self.buildNodePackage {
    name = "ms-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms/-/ms-0.7.1.tgz";
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
  by-spec."multiparty"."~4.1.2" =
    self.by-version."multiparty"."4.1.2";
  by-version."multiparty"."4.1.2" = self.buildNodePackage {
    name = "multiparty-4.1.2";
    version = "4.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/multiparty/-/multiparty-4.1.2.tgz";
      name = "multiparty-4.1.2.tgz";
      sha1 = "54f8ec9712052fa1dfd8ec975056c8230d6f2370";
    };
    deps = {
      "fd-slicer-1.0.1" = self.by-version."fd-slicer"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "multiparty" = self.by-version."multiparty"."4.1.2";
  by-spec."music-library-index"."~1.3.0" =
    self.by-version."music-library-index"."1.3.0";
  by-version."music-library-index"."1.3.0" = self.buildNodePackage {
    name = "music-library-index-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/music-library-index/-/music-library-index-1.3.0.tgz";
      name = "music-library-index-1.3.0.tgz";
      sha1 = "f7dbf6f7df5a0c8c50382542183872aedc5cb86a";
    };
    deps = {
      "diacritics-1.2.1" = self.by-version."diacritics"."1.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "music-library-index" = self.by-version."music-library-index"."1.3.0";
  by-spec."mv"."~2.0.3" =
    self.by-version."mv"."2.0.3";
  by-version."mv"."2.0.3" = self.buildNodePackage {
    name = "mv-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mv/-/mv-2.0.3.tgz";
      name = "mv-2.0.3.tgz";
      sha1 = "e9ab707d71dc38de24edcc637a8e2f5f480c7f32";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "ncp-0.6.0" = self.by-version."ncp"."0.6.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mv" = self.by-version."mv"."2.0.3";
  by-spec."nan"."~1.8.4" =
    self.by-version."nan"."1.8.4";
  by-version."nan"."1.8.4" = self.buildNodePackage {
    name = "nan-1.8.4";
    version = "1.8.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-1.8.4.tgz";
      name = "nan-1.8.4.tgz";
      sha1 = "3c76b5382eab33e44b758d2813ca9d92e9342f34";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ncp"."~0.6.0" =
    self.by-version."ncp"."0.6.0";
  by-version."ncp"."0.6.0" = self.buildNodePackage {
    name = "ncp-0.6.0";
    version = "0.6.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/ncp/-/ncp-0.6.0.tgz";
      name = "ncp-0.6.0.tgz";
      sha1 = "df8ce021e262be21b52feb3d3e5cfaab12491f0d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."negotiator"."0.5.3" =
    self.by-version."negotiator"."0.5.3";
  by-version."negotiator"."0.5.3" = self.buildNodePackage {
    name = "negotiator-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/negotiator/-/negotiator-0.5.3.tgz";
      name = "negotiator-0.5.3.tgz";
      sha1 = "269d5c476810ec92edbe7b6c2f28316384f9a7e8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node-forge"."0.6.16" =
    self.by-version."node-forge"."0.6.16";
  by-version."node-forge"."0.6.16" = self.buildNodePackage {
    name = "node-forge-0.6.16";
    version = "0.6.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/node-forge/-/node-forge-0.6.16.tgz";
      name = "node-forge-0.6.16.tgz";
      sha1 = "aae85babf97034d46f1b74a39bfe5891282ae842";
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
  by-spec."nopt"."~2" =
    self.by-version."nopt"."2.2.1";
  by-version."nopt"."2.2.1" = self.buildNodePackage {
    name = "nopt-2.2.1";
    version = "2.2.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/nopt-2.2.1.tgz";
      name = "nopt-2.2.1.tgz";
      sha1 = "2aa09b7d1768487b3b89a9c5aa52335bff0baea7";
    };
    deps = {
      "abbrev-1.0.7" = self.by-version."abbrev"."1.0.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."number-is-nan"."^1.0.0" =
    self.by-version."number-is-nan"."1.0.0";
  by-version."number-is-nan"."1.0.0" = self.buildNodePackage {
    name = "number-is-nan-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/number-is-nan/-/number-is-nan-1.0.0.tgz";
      name = "number-is-nan-1.0.0.tgz";
      sha1 = "c020f529c5282adfdd233d91d4b181c3d686dc4b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."oauth-sign"."~0.5.0" =
    self.by-version."oauth-sign"."0.5.0";
  by-version."oauth-sign"."0.5.0" = self.buildNodePackage {
    name = "oauth-sign-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.5.0.tgz";
      name = "oauth-sign-0.5.0.tgz";
      sha1 = "d767f5169325620eab2e087ef0c472e773db6461";
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
  by-spec."oauth-sign"."~0.8.0" =
    self.by-version."oauth-sign"."0.8.0";
  by-version."oauth-sign"."0.8.0" = self.buildNodePackage {
    name = "oauth-sign-0.8.0";
    version = "0.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/oauth-sign/-/oauth-sign-0.8.0.tgz";
      name = "oauth-sign-0.8.0.tgz";
      sha1 = "938fdc875765ba527137d8aec9d178e24debc553";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^1.0.0" =
    self.by-version."object-assign"."1.0.0";
  by-version."object-assign"."1.0.0" = self.buildNodePackage {
    name = "object-assign-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-assign/-/object-assign-1.0.0.tgz";
      name = "object-assign-1.0.0.tgz";
      sha1 = "e65dc8766d3b47b4b8307465c8311da030b070a6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.2.1" =
    self.by-version."on-finished"."2.2.1";
  by-version."on-finished"."2.2.1" = self.buildNodePackage {
    name = "on-finished-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/on-finished/-/on-finished-2.2.1.tgz";
      name = "on-finished-2.2.1.tgz";
      sha1 = "5c85c1cc36299f78029653f667f27b6b99ebc029";
    };
    deps = {
      "ee-first-1.1.0" = self.by-version."ee-first"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-tmpdir"."^1.0.0" =
    self.by-version."os-tmpdir"."1.0.1";
  by-version."os-tmpdir"."1.0.1" = self.buildNodePackage {
    name = "os-tmpdir-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/os-tmpdir/-/os-tmpdir-1.0.1.tgz";
      name = "os-tmpdir-1.0.1.tgz";
      sha1 = "e9b423a1edaf479882562e92ed71d7743a071b6e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."osenv"."~0.1.0" =
    self.by-version."osenv"."0.1.2";
  by-version."osenv"."0.1.2" = self.buildNodePackage {
    name = "osenv-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/osenv/-/osenv-0.1.2.tgz";
      name = "osenv-0.1.2.tgz";
      sha1 = "f4d23ebeceaef078600fb78c0ea58fac5996a02d";
    };
    deps = {
      "os-tmpdir-1.0.1" = self.by-version."os-tmpdir"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "osenv" = self.by-version."osenv"."0.1.2";
  by-spec."parseurl"."~1.3.0" =
    self.by-version."parseurl"."1.3.0";
  by-version."parseurl"."1.3.0" = self.buildNodePackage {
    name = "parseurl-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parseurl/-/parseurl-1.3.0.tgz";
      name = "parseurl-1.3.0.tgz";
      sha1 = "b58046db4223e145afa76009e61bac87cc2281b3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-to-regexp"."0.1.3" =
    self.by-version."path-to-regexp"."0.1.3";
  by-version."path-to-regexp"."0.1.3" = self.buildNodePackage {
    name = "path-to-regexp-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.3.tgz";
      name = "path-to-regexp-0.1.3.tgz";
      sha1 = "21b9ab82274279de25b156ea08fd12ca51b8aecb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pend"."~1.2.0" =
    self.by-version."pend"."1.2.0";
  by-version."pend"."1.2.0" = self.buildNodePackage {
    name = "pend-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pend/-/pend-1.2.0.tgz";
      name = "pend-1.2.0.tgz";
      sha1 = "7a57eb550a6783f9115331fcf4663d5c8e007a50";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pend" = self.by-version."pend"."1.2.0";
  by-spec."proxy-addr"."~1.0.8" =
    self.by-version."proxy-addr"."1.0.8";
  by-version."proxy-addr"."1.0.8" = self.buildNodePackage {
    name = "proxy-addr-1.0.8";
    version = "1.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/proxy-addr/-/proxy-addr-1.0.8.tgz";
      name = "proxy-addr-1.0.8.tgz";
      sha1 = "db54ec878bcc1053d57646609219b3715678bafe";
    };
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-1.0.1" = self.by-version."ipaddr.js"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."2.4.2" =
    self.by-version."qs"."2.4.2";
  by-version."qs"."2.4.2" = self.buildNodePackage {
    name = "qs-2.4.2";
    version = "2.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-2.4.2.tgz";
      name = "qs-2.4.2.tgz";
      sha1 = "f7ce788e5777df0b5010da7f7c4e73ba32470f5a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~2.3.1" =
    self.by-version."qs"."2.3.3";
  by-version."qs"."2.3.3" = self.buildNodePackage {
    name = "qs-2.3.3";
    version = "2.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-2.3.3.tgz";
      name = "qs-2.3.3.tgz";
      sha1 = "e9e85adbe75da0bbe4c8e0476a086290f863b404";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~2.4.0" =
    self.by-version."qs"."2.4.2";
  by-spec."qs"."~3.1.0" =
    self.by-version."qs"."3.1.0";
  by-version."qs"."3.1.0" = self.buildNodePackage {
    name = "qs-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-3.1.0.tgz";
      name = "qs-3.1.0.tgz";
      sha1 = "d0e9ae745233a12dc43fb4f3055bba446261153c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."range-parser"."~1.0.2" =
    self.by-version."range-parser"."1.0.2";
  by-version."range-parser"."1.0.2" = self.buildNodePackage {
    name = "range-parser-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/range-parser/-/range-parser-1.0.2.tgz";
      name = "range-parser-1.0.2.tgz";
      sha1 = "06a12a42e5131ba8e457cd892044867f2344e549";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."readable-stream"."~1.1.9" =
    self.by-version."readable-stream"."1.1.13";
  by-spec."repeating"."^1.1.0" =
    self.by-version."repeating"."1.1.3";
  by-version."repeating"."1.1.3" = self.buildNodePackage {
    name = "repeating-1.1.3";
    version = "1.1.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/repeating/-/repeating-1.1.3.tgz";
      name = "repeating-1.1.3.tgz";
      sha1 = "3d4114218877537494f97f77f9785fab810fa4ac";
    };
    deps = {
      "is-finite-1.0.1" = self.by-version."is-finite"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.37.0" =
    self.by-version."request"."2.57.0";
  by-version."request"."2.57.0" = self.buildNodePackage {
    name = "request-2.57.0";
    version = "2.57.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.57.0.tgz";
      name = "request-2.57.0.tgz";
      sha1 = "d445105a42d009b9d724289633b449a6d723d989";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.10.0" = self.by-version."caseless"."0.10.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-3.1.0" = self.by-version."qs"."3.1.0";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-2.0.0" = self.by-version."tough-cookie"."2.0.0";
      "http-signature-0.11.0" = self.by-version."http-signature"."0.11.0";
      "oauth-sign-0.8.0" = self.by-version."oauth-sign"."0.8.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.7.1" = self.by-version."har-validator"."1.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.54.0" =
    self.by-version."request"."2.57.0";
  by-spec."request"."^2.55.0" =
    self.by-version."request"."2.57.0";
  by-spec."request"."~2.51.0" =
    self.by-version."request"."2.51.0";
  by-version."request"."2.51.0" = self.buildNodePackage {
    name = "request-2.51.0";
    version = "2.51.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.51.0.tgz";
      name = "request-2.51.0.tgz";
      sha1 = "35d00bbecc012e55f907b1bd9e0dbd577bfef26e";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.8.0" = self.by-version."caseless"."0.8.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-1.0.2" = self.by-version."mime-types"."1.0.2";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-2.0.0" = self.by-version."tough-cookie"."2.0.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.5.0" = self.by-version."oauth-sign"."0.5.0";
      "hawk-1.1.1" = self.by-version."hawk"."1.1.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."~2.54.0" =
    self.by-version."request"."2.54.0";
  by-version."request"."2.54.0" = self.buildNodePackage {
    name = "request-2.54.0";
    version = "2.54.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.54.0.tgz";
      name = "request-2.54.0.tgz";
      sha1 = "a13917cd8e8fa73332da0bf2f84a30181def1953";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.4.2" = self.by-version."qs"."2.4.2";
      "tunnel-agent-0.4.0" = self.by-version."tunnel-agent"."0.4.0";
      "tough-cookie-2.0.0" = self.by-version."tough-cookie"."2.0.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.7.1" = self.by-version."har-validator"."1.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rimraf"."~2.2.8" =
    self.by-version."rimraf"."2.2.8";
  by-version."rimraf"."2.2.8" = self.buildNodePackage {
    name = "rimraf-2.2.8";
    version = "2.2.8";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.2.8.tgz";
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
  by-spec."runforcover"."~0.0.2" =
    self.by-version."runforcover"."0.0.2";
  by-version."runforcover"."0.0.2" = self.buildNodePackage {
    name = "runforcover-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/runforcover/-/runforcover-0.0.2.tgz";
      name = "runforcover-0.0.2.tgz";
      sha1 = "344f057d8d45d33aebc6cc82204678f69c4857cc";
    };
    deps = {
      "bunker-0.1.2" = self.by-version."bunker"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sax"."0.5.x" =
    self.by-version."sax"."0.5.8";
  by-version."sax"."0.5.8" = self.buildNodePackage {
    name = "sax-0.5.8";
    version = "0.5.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sax/-/sax-0.5.8.tgz";
      name = "sax-0.5.8.tgz";
      sha1 = "d472db228eb331c2506b0e8c15524adb939d12c1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."semver"."~4.3.4" =
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
  by-spec."send"."0.12.3" =
    self.by-version."send"."0.12.3";
  by-version."send"."0.12.3" = self.buildNodePackage {
    name = "send-0.12.3";
    version = "0.12.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/send/-/send-0.12.3.tgz";
      name = "send-0.12.3.tgz";
      sha1 = "cd12dc58fde21e4f91902b39b2fda05a7a6d9bdc";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "etag-1.6.0" = self.by-version."etag"."1.6.0";
      "fresh-0.2.4" = self.by-version."fresh"."0.2.4";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
      "on-finished-2.2.1" = self.by-version."on-finished"."2.2.1";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.9.3" =
    self.by-version."serve-static"."1.9.3";
  by-version."serve-static"."1.9.3" = self.buildNodePackage {
    name = "serve-static-1.9.3";
    version = "1.9.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/serve-static/-/serve-static-1.9.3.tgz";
      name = "serve-static-1.9.3.tgz";
      sha1 = "5f8da07323ad385ff3dc541f1a7917b2e436eb57";
    };
    deps = {
      "escape-html-1.0.1" = self.by-version."escape-html"."1.0.1";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.12.3" = self.by-version."send"."0.12.3";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "serve-static" = self.by-version."serve-static"."1.9.3";
  by-spec."sigmund"."~1.0.0" =
    self.by-version."sigmund"."1.0.1";
  by-version."sigmund"."1.0.1" = self.buildNodePackage {
    name = "sigmund-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sigmund/-/sigmund-1.0.1.tgz";
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
  by-spec."slide"."*" =
    self.by-version."slide"."1.1.6";
  by-version."slide"."1.1.6" = self.buildNodePackage {
    name = "slide-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/slide/-/slide-1.1.6.tgz";
      name = "slide-1.1.6.tgz";
      sha1 = "56eb027d65b4d2dce6cb2e2d32c4d4afc9e1d707";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."sntp"."0.2.x" =
    self.by-version."sntp"."0.2.4";
  by-version."sntp"."0.2.4" = self.buildNodePackage {
    name = "sntp-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sntp/-/sntp-0.2.4.tgz";
      name = "sntp-0.2.4.tgz";
      sha1 = "fb885f18b0f3aad189f824862536bceeec750900";
    };
    deps = {
      "hoek-0.9.1" = self.by-version."hoek"."0.9.1";
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
      url = "http://registry.npmjs.org/sntp/-/sntp-1.0.9.tgz";
      name = "sntp-1.0.9.tgz";
      sha1 = "6541184cc90aeea6c6e7b35e2659082443c66198";
    };
    deps = {
      "hoek-2.14.0" = self.by-version."hoek"."2.14.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."0.1.x" =
    self.by-version."source-map"."0.1.43";
  by-version."source-map"."0.1.43" = self.buildNodePackage {
    name = "source-map-0.1.43";
    version = "0.1.43";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/source-map/-/source-map-0.1.43.tgz";
      name = "source-map-0.1.43.tgz";
      sha1 = "c24bc146ca517c1471f5dacbe2571b2b7f9e3346";
    };
    deps = {
      "amdefine-0.1.1" = self.by-version."amdefine"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."streamsink"."~1.2.0" =
    self.by-version."streamsink"."1.2.0";
  by-version."streamsink"."1.2.0" = self.buildNodePackage {
    name = "streamsink-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/streamsink/-/streamsink-1.2.0.tgz";
      name = "streamsink-1.2.0.tgz";
      sha1 = "efafee9f1e22d3591ed7de3dcaa95c3f5e79f73c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string-template"."~0.2.0" =
    self.by-version."string-template"."0.2.1";
  by-version."string-template"."0.2.1" = self.buildNodePackage {
    name = "string-template-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/string-template/-/string-template-0.2.1.tgz";
      name = "string-template-0.2.1.tgz";
      sha1 = "42932e598a352d01fc22ec3367d9d84eec6c9add";
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
  by-spec."stylus"."~0.49.3" =
    self.by-version."stylus"."0.49.3";
  by-version."stylus"."0.49.3" = self.buildNodePackage {
    name = "stylus-0.49.3";
    version = "0.49.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/stylus/-/stylus-0.49.3.tgz";
      name = "stylus-0.49.3.tgz";
      sha1 = "1fbdabe479ed460872c71a6252a67f95040ba511";
    };
    deps = {
      "css-parse-1.7.0" = self.by-version."css-parse"."1.7.0";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "sax-0.5.8" = self.by-version."sax"."0.5.8";
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "stylus" = self.by-version."stylus"."0.49.3";
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
  by-spec."tap"."~0.3.3" =
    self.by-version."tap"."0.3.3";
  by-version."tap"."0.3.3" = self.buildNodePackage {
    name = "tap-0.3.3";
    version = "0.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/tap/-/tap-0.3.3.tgz";
      name = "tap-0.3.3.tgz";
      sha1 = "c862237af0a213f97fff46594bd1d44eca705d63";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "yamlish-0.0.7" = self.by-version."yamlish"."0.0.7";
      "slide-1.1.6" = self.by-version."slide"."1.1.6";
      "runforcover-0.0.2" = self.by-version."runforcover"."0.0.2";
      "nopt-2.2.1" = self.by-version."nopt"."2.2.1";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
      "difflet-0.2.6" = self.by-version."difflet"."0.2.6";
      "deep-equal-0.0.0" = self.by-version."deep-equal"."0.0.0";
      "buffer-equal-0.0.1" = self.by-version."buffer-equal"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tough-cookie".">=0.12.0" =
    self.by-version."tough-cookie"."2.0.0";
  by-version."tough-cookie"."2.0.0" = self.buildNodePackage {
    name = "tough-cookie-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-2.0.0.tgz";
      name = "tough-cookie-2.0.0.tgz";
      sha1 = "41ce08720b35cf90beb044dd2609fb19e928718f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."traverse"."0.6.x" =
    self.by-version."traverse"."0.6.6";
  by-version."traverse"."0.6.6" = self.buildNodePackage {
    name = "traverse-0.6.6";
    version = "0.6.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/traverse/-/traverse-0.6.6.tgz";
      name = "traverse-0.6.6.tgz";
      sha1 = "cbdf560fd7b9af632502fed40f918c157ea97137";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."traverse"."~0.5.1" =
    self.by-version."traverse"."0.5.2";
  by-version."traverse"."0.5.2" = self.buildNodePackage {
    name = "traverse-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/traverse/-/traverse-0.5.2.tgz";
      name = "traverse-0.5.2.tgz";
      sha1 = "e203c58d5f7f0e37db6e74c0acb929bb09b61d85";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."type-is"."~1.6.2" =
    self.by-version."type-is"."1.6.3";
  by-version."type-is"."1.6.3" = self.buildNodePackage {
    name = "type-is-1.6.3";
    version = "1.6.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/type-is/-/type-is-1.6.3.tgz";
      name = "type-is-1.6.3.tgz";
      sha1 = "d87d201777f76dfc526ac202679715d41a28c580";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.1.1" = self.by-version."mime-types"."2.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."typedarray"."~0.0.5" =
    self.by-version."typedarray"."0.0.6";
  by-version."typedarray"."0.0.6" = self.buildNodePackage {
    name = "typedarray-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/typedarray/-/typedarray-0.0.6.tgz";
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
  by-spec."uglify-js"."~1.1.1" =
    self.by-version."uglify-js"."1.1.1";
  by-version."uglify-js"."1.1.1" = self.buildNodePackage {
    name = "uglify-js-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-js/-/uglify-js-1.1.1.tgz";
      name = "uglify-js-1.1.1.tgz";
      sha1 = "ee71a97c4cefd06a1a9b20437f34118982aa035b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."^1.6.0" =
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
  by-spec."underscore"."~1.6.0" =
    self.by-version."underscore"."1.6.0";
  by-version."underscore"."1.6.0" = self.buildNodePackage {
    name = "underscore-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.6.0.tgz";
      name = "underscore-1.6.0.tgz";
      sha1 = "8b38b10cacdef63337b8b24e4ff86d45aea529a8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = self.buildNodePackage {
    name = "utils-merge-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
      name = "utils-merge-1.0.0.tgz";
      sha1 = "0294fb922bb9375153541c4f7096231f287c8af8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."vary"."~1.0.0" =
    self.by-version."vary"."1.0.0";
  by-version."vary"."1.0.0" = self.buildNodePackage {
    name = "vary-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/vary/-/vary-1.0.0.tgz";
      name = "vary-1.0.0.tgz";
      sha1 = "c5e76cec20d3820d8f2a96e7bee38731c34da1e7";
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
  by-spec."xtend"."~4.0.0" =
    self.by-version."xtend"."4.0.0";
  by-spec."yamlish"."*" =
    self.by-version."yamlish"."0.0.7";
  by-version."yamlish"."0.0.7" = self.buildNodePackage {
    name = "yamlish-0.0.7";
    version = "0.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yamlish/-/yamlish-0.0.7.tgz";
      name = "yamlish-0.0.7.tgz";
      sha1 = "b4af9a1dcc63618873c3d6e451ec3213c39a57fb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."yauzl"."~2.3.0" =
    self.by-version."yauzl"."2.3.1";
  by-version."yauzl"."2.3.1" = self.buildNodePackage {
    name = "yauzl-2.3.1";
    version = "2.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yauzl/-/yauzl-2.3.1.tgz";
      name = "yauzl-2.3.1.tgz";
      sha1 = "6707fe2b6a4dac9445cc429bf04a11c7dedfa36a";
    };
    deps = {
      "fd-slicer-1.0.1" = self.by-version."fd-slicer"."1.0.1";
      "pend-1.2.0" = self.by-version."pend"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "yauzl" = self.by-version."yauzl"."2.3.1";
  by-spec."yawl"."~1.0.2" =
    self.by-version."yawl"."1.0.2";
  by-version."yawl"."1.0.2" = self.buildNodePackage {
    name = "yawl-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yawl/-/yawl-1.0.2.tgz";
      name = "yawl-1.0.2.tgz";
      sha1 = "df1301cb50e5bc74cc36d5c1ef9cfbd1f84b408e";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "pend-1.2.0" = self.by-version."pend"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "yawl" = self.by-version."yawl"."1.0.2";
  by-spec."yazl"."~2.2.2" =
    self.by-version."yazl"."2.2.2";
  by-version."yazl"."2.2.2" = self.buildNodePackage {
    name = "yazl-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yazl/-/yazl-2.2.2.tgz";
      name = "yazl-2.2.2.tgz";
      sha1 = "60187f4ce6df314e7501c3c0e40bcf1b58fda183";
    };
    deps = {
      "buffer-crc32-0.2.5" = self.by-version."buffer-crc32"."0.2.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "yazl" = self.by-version."yazl"."2.2.2";
  by-spec."ytdl-core".">=0.5.1" =
    self.by-version."ytdl-core"."0.5.1";
  by-version."ytdl-core"."0.5.1" = self.buildNodePackage {
    name = "ytdl-core-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ytdl-core/-/ytdl-core-0.5.1.tgz";
      name = "ytdl-core-0.5.1.tgz";
      sha1 = "3c48d696b019d7faae635a3f1e4eaa9131110f43";
    };
    deps = {
      "cheerio-0.18.0" = self.by-version."cheerio"."0.18.0";
      "jstream-0.2.7" = self.by-version."jstream"."0.2.7";
      "request-2.57.0" = self.by-version."request"."2.57.0";
      "underscore-1.8.3" = self.by-version."underscore"."1.8.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "ytdl-core" = self.by-version."ytdl-core"."0.5.1";
}


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
  by-spec."accepts"."~1.2.10" =
    self.by-version."accepts"."1.2.11";
  by-version."accepts"."1.2.11" = self.buildNodePackage {
    name = "accepts-1.2.11";
    version = "1.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/accepts/-/accepts-1.2.11.tgz";
      name = "accepts-1.2.11.tgz";
      sha1 = "d341c6e3b420489632f0f4f8d2ad4fd9ddf374e0";
    };
    deps = {
      "mime-types-2.1.3" = self.by-version."mime-types"."2.1.3";
      "negotiator-0.5.3" = self.by-version."negotiator"."0.5.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."after"."0.8.1" =
    self.by-version."after"."0.8.1";
  by-version."after"."0.8.1" = self.buildNodePackage {
    name = "after-0.8.1";
    version = "0.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/after/-/after-0.8.1.tgz";
      name = "after-0.8.1.tgz";
      sha1 = "ab5d4fb883f596816d3515f8f791c0af486dd627";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."1.0.0";
  by-version."amdefine"."1.0.0" = self.buildNodePackage {
    name = "amdefine-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/amdefine/-/amdefine-1.0.0.tgz";
      name = "amdefine-1.0.0.tgz";
      sha1 = "fd17474700cb5cc9c2b709f0be9d23ce3c198c33";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^0.2.0" =
    self.by-version."ansi-regex"."0.2.1";
  by-version."ansi-regex"."0.2.1" = self.buildNodePackage {
    name = "ansi-regex-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-regex/-/ansi-regex-0.2.1.tgz";
      name = "ansi-regex-0.2.1.tgz";
      sha1 = "0d8e946967a3d8143f93e24e298525fc1b2235f9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ansi-regex"."^0.2.1" =
    self.by-version."ansi-regex"."0.2.1";
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
  by-spec."ansi-styles"."^1.1.0" =
    self.by-version."ansi-styles"."1.1.0";
  by-version."ansi-styles"."1.1.0" = self.buildNodePackage {
    name = "ansi-styles-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansi-styles/-/ansi-styles-1.1.0.tgz";
      name = "ansi-styles-1.1.0.tgz";
      sha1 = "eaecbf66cd706882760b2f4691582b8f55d7a7de";
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
  by-spec."argparse"."~ 0.1.11" =
    self.by-version."argparse"."0.1.16";
  by-version."argparse"."0.1.16" = self.buildNodePackage {
    name = "argparse-0.1.16";
    version = "0.1.16";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/argparse/-/argparse-0.1.16.tgz";
      name = "argparse-0.1.16.tgz";
      sha1 = "cfd01e0fbba3d6caed049fbd758d40f65196f57c";
    };
    deps = {
      "underscore-1.7.0" = self.by-version."underscore"."1.7.0";
      "underscore.string-2.4.0" = self.by-version."underscore.string"."2.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-flatten"."1.1.0" =
    self.by-version."array-flatten"."1.1.0";
  by-version."array-flatten"."1.1.0" = self.buildNodePackage {
    name = "array-flatten-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/array-flatten/-/array-flatten-1.1.0.tgz";
      name = "array-flatten-1.1.0.tgz";
      sha1 = "ac3efac717b0e7bbdc778ce0bde7381ac6604393";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."arraybuffer.slice"."0.0.6" =
    self.by-version."arraybuffer.slice"."0.0.6";
  by-version."arraybuffer.slice"."0.0.6" = self.buildNodePackage {
    name = "arraybuffer.slice-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/arraybuffer.slice/-/arraybuffer.slice-0.0.6.tgz";
      name = "arraybuffer.slice-0.0.6.tgz";
      sha1 = "f33b2159f0532a3f3107a272c0ccfbd1ad2979ca";
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
  by-spec."async"."^1.2.1" =
    self.by-version."async"."1.4.0";
  by-version."async"."1.4.0" = self.buildNodePackage {
    name = "async-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-1.4.0.tgz";
      name = "async-1.4.0.tgz";
      sha1 = "35f86f83c59e0421d099cd9a91d8278fb578c00d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."~0.1.22" =
    self.by-version."async"."0.1.22";
  by-version."async"."0.1.22" = self.buildNodePackage {
    name = "async-0.1.22";
    version = "0.1.22";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-0.1.22.tgz";
      name = "async-0.1.22.tgz";
      sha1 = "0fc1aaa088a0e3ef0ebe2d8831bab0dcf8845061";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."async"."~0.2.6" =
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
  by-spec."async"."~0.2.9" =
    self.by-version."async"."0.2.10";
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
  by-spec."base64-arraybuffer"."0.1.2" =
    self.by-version."base64-arraybuffer"."0.1.2";
  by-version."base64-arraybuffer"."0.1.2" = self.buildNodePackage {
    name = "base64-arraybuffer-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64-arraybuffer/-/base64-arraybuffer-0.1.2.tgz";
      name = "base64-arraybuffer-0.1.2.tgz";
      sha1 = "474df4a9f2da24e05df3158c3b1db3c3cd46a154";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."base64id"."0.1.0" =
    self.by-version."base64id"."0.1.0";
  by-version."base64id"."0.1.0" = self.buildNodePackage {
    name = "base64id-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/base64id/-/base64id-0.1.0.tgz";
      name = "base64id-0.1.0.tgz";
      sha1 = "02ce0fdeee0cef4f40080e1e73e834f0b1bfce3f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bcrypt-nodejs"."0.0.3" =
    self.by-version."bcrypt-nodejs"."0.0.3";
  by-version."bcrypt-nodejs"."0.0.3" = self.buildNodePackage {
    name = "bcrypt-nodejs-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bcrypt-nodejs/-/bcrypt-nodejs-0.0.3.tgz";
      name = "bcrypt-nodejs-0.0.3.tgz";
      sha1 = "c60917f26dc235661566c681061c303c2b28842b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bcrypt-nodejs" = self.by-version."bcrypt-nodejs"."0.0.3";
  by-spec."better-assert"."~1.0.0" =
    self.by-version."better-assert"."1.0.2";
  by-version."better-assert"."1.0.2" = self.buildNodePackage {
    name = "better-assert-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/better-assert/-/better-assert-1.0.2.tgz";
      name = "better-assert-1.0.2.tgz";
      sha1 = "40866b9e1b9e0b55b481894311e68faffaebc522";
    };
    deps = {
      "callsite-1.0.0" = self.by-version."callsite"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."~1.0.0" =
    self.by-version."bl"."1.0.0";
  by-version."bl"."1.0.0" = self.buildNodePackage {
    name = "bl-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bl/-/bl-1.0.0.tgz";
      name = "bl-1.0.0.tgz";
      sha1 = "ada9a8a89a6d7ac60862f7dec7db207873e0c3f5";
    };
    deps = {
      "readable-stream-2.0.2" = self.by-version."readable-stream"."2.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."blob"."0.0.2" =
    self.by-version."blob"."0.0.2";
  by-version."blob"."0.0.2" = self.buildNodePackage {
    name = "blob-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/blob/-/blob-0.0.2.tgz";
      name = "blob-0.0.2.tgz";
      sha1 = "b89562bd6994af95ba1e812155536333aa23cf24";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bluebird"."^2.9.30" =
    self.by-version."bluebird"."2.9.34";
  by-version."bluebird"."2.9.34" = self.buildNodePackage {
    name = "bluebird-2.9.34";
    version = "2.9.34";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bluebird/-/bluebird-2.9.34.tgz";
      name = "bluebird-2.9.34.tgz";
      sha1 = "2f7b4ec80216328a9fddebdf69c8d4942feff7d8";
    };
    deps = {
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
  by-spec."boom"."^2.8.x" =
    self.by-version."boom"."2.8.0";
  by-spec."browserify-zlib"."^0.1.4" =
    self.by-version."browserify-zlib"."0.1.4";
  by-version."browserify-zlib"."0.1.4" = self.buildNodePackage {
    name = "browserify-zlib-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/browserify-zlib/-/browserify-zlib-0.1.4.tgz";
      name = "browserify-zlib-0.1.4.tgz";
      sha1 = "bb35f8a519f600e0fa6b8485241c979d0141fb2d";
    };
    deps = {
      "pako-0.2.7" = self.by-version."pako"."0.2.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."callsite"."1.0.0" =
    self.by-version."callsite"."1.0.0";
  by-version."callsite"."1.0.0" = self.buildNodePackage {
    name = "callsite-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/callsite/-/callsite-1.0.0.tgz";
      name = "callsite-1.0.0.tgz";
      sha1 = "280398e5d664bd74038b6f0905153e6e8af1bc20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."camelcase"."^1.0.2" =
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
  by-spec."chalk"."^0.5.0" =
    self.by-version."chalk"."0.5.1";
  by-version."chalk"."0.5.1" = self.buildNodePackage {
    name = "chalk-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-0.5.1.tgz";
      name = "chalk-0.5.1.tgz";
      sha1 = "663b3a648b68b55d04690d49167aa837858f2174";
    };
    deps = {
      "ansi-styles-1.1.0" = self.by-version."ansi-styles"."1.1.0";
      "escape-string-regexp-1.0.3" = self.by-version."escape-string-regexp"."1.0.3";
      "has-ansi-0.1.0" = self.by-version."has-ansi"."0.1.0";
      "strip-ansi-0.3.0" = self.by-version."strip-ansi"."0.3.0";
      "supports-color-0.2.0" = self.by-version."supports-color"."0.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chalk"."^0.5.1" =
    self.by-version."chalk"."0.5.1";
  by-spec."chalk"."^1.0.0" =
    self.by-version."chalk"."1.1.0";
  by-version."chalk"."1.1.0" = self.buildNodePackage {
    name = "chalk-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chalk/-/chalk-1.1.0.tgz";
      name = "chalk-1.1.0.tgz";
      sha1 = "09b453cec497a75520e4a60ae48214a8700e0921";
    };
    deps = {
      "ansi-styles-2.1.0" = self.by-version."ansi-styles"."2.1.0";
      "escape-string-regexp-1.0.3" = self.by-version."escape-string-regexp"."1.0.3";
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
  by-spec."cheerio"."^0.17.0" =
    self.by-version."cheerio"."0.17.0";
  by-version."cheerio"."0.17.0" = self.buildNodePackage {
    name = "cheerio-0.17.0";
    version = "0.17.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cheerio/-/cheerio-0.17.0.tgz";
      name = "cheerio-0.17.0.tgz";
      sha1 = "fa5ae42cc60121133d296d0b46d983215f7268ea";
    };
    deps = {
      "CSSselect-0.4.1" = self.by-version."CSSselect"."0.4.1";
      "entities-1.1.1" = self.by-version."entities"."1.1.1";
      "htmlparser2-3.7.3" = self.by-version."htmlparser2"."3.7.3";
      "dom-serializer-0.0.1" = self.by-version."dom-serializer"."0.0.1";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cheerio" = self.by-version."cheerio"."0.17.0";
  by-spec."coffee-script"."~1.3.3" =
    self.by-version."coffee-script"."1.3.3";
  by-version."coffee-script"."1.3.3" = self.buildNodePackage {
    name = "coffee-script-1.3.3";
    version = "1.3.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/coffee-script/-/coffee-script-1.3.3.tgz";
      name = "coffee-script-1.3.3.tgz";
      sha1 = "150d6b4cb522894369efed6a2101c20bc7f4a4f4";
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
  by-spec."combined-stream"."^1.0.3" =
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
  by-spec."combined-stream"."~1.0.1" =
    self.by-version."combined-stream"."1.0.5";
  by-spec."commander"."0.6.1" =
    self.by-version."commander"."0.6.1";
  by-version."commander"."0.6.1" = self.buildNodePackage {
    name = "commander-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-0.6.1.tgz";
      name = "commander-0.6.1.tgz";
      sha1 = "fa68a14f6a945d54dbbe50d8cdb3320e9e3b1a06";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."2.3.0" =
    self.by-version."commander"."2.3.0";
  by-version."commander"."2.3.0" = self.buildNodePackage {
    name = "commander-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/commander/-/commander-2.3.0.tgz";
      name = "commander-2.3.0.tgz";
      sha1 = "fd430e889832ec353b9acd1de217c11cb3eef873";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."commander"."^2.3.0" =
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
  "commander" = self.by-version."commander"."2.8.1";
  by-spec."commander"."^2.8.1" =
    self.by-version."commander"."2.8.1";
  by-spec."commander"."~0.6.1" =
    self.by-version."commander"."0.6.1";
  by-spec."component-bind"."1.0.0" =
    self.by-version."component-bind"."1.0.0";
  by-version."component-bind"."1.0.0" = self.buildNodePackage {
    name = "component-bind-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-bind/-/component-bind-1.0.0.tgz";
      name = "component-bind-1.0.0.tgz";
      sha1 = "00c608ab7dcd93897c0009651b1d3a8e1e73bbd1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-emitter"."1.1.2" =
    self.by-version."component-emitter"."1.1.2";
  by-version."component-emitter"."1.1.2" = self.buildNodePackage {
    name = "component-emitter-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-emitter/-/component-emitter-1.1.2.tgz";
      name = "component-emitter-1.1.2.tgz";
      sha1 = "296594f2753daa63996d2af08d15a95116c9aec3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."component-inherit"."0.0.3" =
    self.by-version."component-inherit"."0.0.3";
  by-version."component-inherit"."0.0.3" = self.buildNodePackage {
    name = "component-inherit-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/component-inherit/-/component-inherit-0.0.3.tgz";
      name = "component-inherit-0.0.3.tgz";
      sha1 = "645fc4adf58b72b649d5cae65135619db26ff143";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."concat-stream"."^1.4.1" =
    self.by-version."concat-stream"."1.5.0";
  by-version."concat-stream"."1.5.0" = self.buildNodePackage {
    name = "concat-stream-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/concat-stream/-/concat-stream-1.5.0.tgz";
      name = "concat-stream-1.5.0.tgz";
      sha1 = "53f7d43c51c5e43f81c8fdd03321c631be68d611";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "typedarray-0.0.6" = self.by-version."typedarray"."0.0.6";
      "readable-stream-2.0.2" = self.by-version."readable-stream"."2.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."cookie"."0.1.3" =
    self.by-version."cookie"."0.1.3";
  by-version."cookie"."0.1.3" = self.buildNodePackage {
    name = "cookie-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cookie/-/cookie-0.1.3.tgz";
      name = "cookie-0.1.3.tgz";
      sha1 = "e734a5c1417fce472d5aef82c381cabb64d1a435";
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
      "boom-2.8.0" = self.by-version."boom"."2.8.0";
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
  by-spec."dateformat"."1.0.2-1.2.3" =
    self.by-version."dateformat"."1.0.2-1.2.3";
  by-version."dateformat"."1.0.2-1.2.3" = self.buildNodePackage {
    name = "dateformat-1.0.2-1.2.3";
    version = "1.0.2-1.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/dateformat/-/dateformat-1.0.2-1.2.3.tgz";
      name = "dateformat-1.0.2-1.2.3.tgz";
      sha1 = "b0220c02de98617433b72851cf47de3df2cdbee9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."debug"."0.6.0" =
    self.by-version."debug"."0.6.0";
  by-version."debug"."0.6.0" = self.buildNodePackage {
    name = "debug-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-0.6.0.tgz";
      name = "debug-0.6.0.tgz";
      sha1 = "ce9d5d025d5294b3f0748a494bebaf3c9fd8734f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."0.7.4" =
    self.by-version."debug"."0.7.4";
  by-version."debug"."0.7.4" = self.buildNodePackage {
    name = "debug-0.7.4";
    version = "0.7.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-0.7.4.tgz";
      name = "debug-0.7.4.tgz";
      sha1 = "06e1ea8082c2cb14e39806e22e2f6f757f92af39";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."2.0.0" =
    self.by-version."debug"."2.0.0";
  by-version."debug"."2.0.0" = self.buildNodePackage {
    name = "debug-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/debug/-/debug-2.0.0.tgz";
      name = "debug-2.0.0.tgz";
      sha1 = "89bd9df6732b51256bc6705342bba02ed12131ef";
    };
    deps = {
      "ms-0.6.2" = self.by-version."ms"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."debug"."~0.7.0" =
    self.by-version."debug"."0.7.4";
  by-spec."debug"."~0.7.2" =
    self.by-version."debug"."0.7.4";
  by-spec."debug"."~2.2.0" =
    self.by-version."debug"."2.2.0";
  by-spec."decamelize"."^1.0.0" =
    self.by-version."decamelize"."1.0.0";
  by-version."decamelize"."1.0.0" = self.buildNodePackage {
    name = "decamelize-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/decamelize/-/decamelize-1.0.0.tgz";
      name = "decamelize-1.0.0.tgz";
      sha1 = "5287122f71691d4505b18ff2258dc400a5b23847";
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
  by-spec."diff"."1.0.8" =
    self.by-version."diff"."1.0.8";
  by-version."diff"."1.0.8" = self.buildNodePackage {
    name = "diff-1.0.8";
    version = "1.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/diff/-/diff-1.0.8.tgz";
      name = "diff-1.0.8.tgz";
      sha1 = "343276308ec991b7bc82267ed55bc1411f971666";
    };
    deps = {
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
  by-spec."duplexer"."~0.1.1" =
    self.by-version."duplexer"."0.1.1";
  by-version."duplexer"."0.1.1" = self.buildNodePackage {
    name = "duplexer-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/duplexer/-/duplexer-0.1.1.tgz";
      name = "duplexer-0.1.1.tgz";
      sha1 = "ace6ff808c1ce66b57d1ebf97977acb02334cfc1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ee-first"."1.1.1" =
    self.by-version."ee-first"."1.1.1";
  by-version."ee-first"."1.1.1" = self.buildNodePackage {
    name = "ee-first-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz";
      name = "ee-first-1.1.1.tgz";
      sha1 = "590c61156b0ae2f4f0255732a158b266bc56b21d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."emitter"."http://github.com/component/emitter/archive/1.0.1.tar.gz" =
    self.by-version."emitter"."1.0.1";
  by-version."emitter"."1.0.1" = self.buildNodePackage {
    name = "emitter-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://github.com/component/emitter/archive/1.0.1.tar.gz";
      name = "emitter-1.0.1.tgz";
      sha256 = "0eae744826723877457f7a7ac7f31d68a5a060673b3a883f6a8e325bf48f313d";
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
  by-spec."engine.io"."1.3.1" =
    self.by-version."engine.io"."1.3.1";
  by-version."engine.io"."1.3.1" = self.buildNodePackage {
    name = "engine.io-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/engine.io/-/engine.io-1.3.1.tgz";
      name = "engine.io-1.3.1.tgz";
      sha1 = "2d968308fffae5d17f5209b6775246e90d8a705e";
    };
    deps = {
      "debug-0.6.0" = self.by-version."debug"."0.6.0";
      "ws-0.4.31" = self.by-version."ws"."0.4.31";
      "engine.io-parser-1.0.6" = self.by-version."engine.io-parser"."1.0.6";
      "base64id-0.1.0" = self.by-version."base64id"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."engine.io-client"."1.3.1" =
    self.by-version."engine.io-client"."1.3.1";
  by-version."engine.io-client"."1.3.1" = self.buildNodePackage {
    name = "engine.io-client-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/engine.io-client/-/engine.io-client-1.3.1.tgz";
      name = "engine.io-client-1.3.1.tgz";
      sha1 = "1c5a65d5c5af6d04b44c22c3dbcd95c39ed1c989";
    };
    deps = {
      "has-cors-1.0.3" = self.by-version."has-cors"."1.0.3";
      "ws-0.4.31" = self.by-version."ws"."0.4.31";
      "xmlhttprequest-1.5.0" = self.by-version."xmlhttprequest"."1.5.0";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
      "engine.io-parser-1.0.6" = self.by-version."engine.io-parser"."1.0.6";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "parseuri-0.0.2" = self.by-version."parseuri"."0.0.2";
      "parsejson-0.0.1" = self.by-version."parsejson"."0.0.1";
      "parseqs-0.0.2" = self.by-version."parseqs"."0.0.2";
      "component-inherit-0.0.3" = self.by-version."component-inherit"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."engine.io-parser"."1.0.6" =
    self.by-version."engine.io-parser"."1.0.6";
  by-version."engine.io-parser"."1.0.6" = self.buildNodePackage {
    name = "engine.io-parser-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/engine.io-parser/-/engine.io-parser-1.0.6.tgz";
      name = "engine.io-parser-1.0.6.tgz";
      sha1 = "d38813143a411cb3b914132ab05bf99e6f7a248e";
    };
    deps = {
      "base64-arraybuffer-0.1.2" = self.by-version."base64-arraybuffer"."0.1.2";
      "after-0.8.1" = self.by-version."after"."0.8.1";
      "arraybuffer.slice-0.0.6" = self.by-version."arraybuffer.slice"."0.0.6";
      "blob-0.0.2" = self.by-version."blob"."0.0.2";
      "utf8-2.0.0" = self.by-version."utf8"."2.0.0";
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
  by-spec."escape-html"."1.0.2" =
    self.by-version."escape-html"."1.0.2";
  by-version."escape-html"."1.0.2" = self.buildNodePackage {
    name = "escape-html-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-html/-/escape-html-1.0.2.tgz";
      name = "escape-html-1.0.2.tgz";
      sha1 = "d77d32fa98e38c2f41ae85e9278e0e0e6ba1022c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."1.0.2" =
    self.by-version."escape-string-regexp"."1.0.2";
  by-version."escape-string-regexp"."1.0.2" = self.buildNodePackage {
    name = "escape-string-regexp-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/escape-string-regexp/-/escape-string-regexp-1.0.2.tgz";
      name = "escape-string-regexp-1.0.2.tgz";
      sha1 = "4dbc2fe674e71949caf3fb2695ce7f2dc1d9a8d1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."escape-string-regexp"."^1.0.0" =
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
  by-spec."escape-string-regexp"."^1.0.2" =
    self.by-version."escape-string-regexp"."1.0.3";
  by-spec."esprima"."~ 1.0.2" =
    self.by-version."esprima"."1.0.4";
  by-version."esprima"."1.0.4" = self.buildNodePackage {
    name = "esprima-1.0.4";
    version = "1.0.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/esprima/-/esprima-1.0.4.tgz";
      name = "esprima-1.0.4.tgz";
      sha1 = "9f557e08fc3b4d26ece9dd34f8fbf476b62585ad";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."etag"."~1.7.0" =
    self.by-version."etag"."1.7.0";
  by-version."etag"."1.7.0" = self.buildNodePackage {
    name = "etag-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/etag/-/etag-1.7.0.tgz";
      name = "etag-1.7.0.tgz";
      sha1 = "03d30b5f67dd6e632d2945d30d6652731a34d5d8";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."event-stream"."^3.1.7" =
    self.by-version."event-stream"."3.3.1";
  by-version."event-stream"."3.3.1" = self.buildNodePackage {
    name = "event-stream-3.3.1";
    version = "3.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/event-stream/-/event-stream-3.3.1.tgz";
      name = "event-stream-3.3.1.tgz";
      sha1 = "b8cf6c00119181e688f335363daa7915ce890bdb";
    };
    deps = {
      "through-2.3.8" = self.by-version."through"."2.3.8";
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
      "from-0.1.3" = self.by-version."from"."0.1.3";
      "map-stream-0.1.0" = self.by-version."map-stream"."0.1.0";
      "pause-stream-0.0.11" = self.by-version."pause-stream"."0.0.11";
      "split-0.3.3" = self.by-version."split"."0.3.3";
      "stream-combiner-0.0.4" = self.by-version."stream-combiner"."0.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "event-stream" = self.by-version."event-stream"."3.3.1";
  by-spec."eventemitter2"."~0.4.13" =
    self.by-version."eventemitter2"."0.4.14";
  by-version."eventemitter2"."0.4.14" = self.buildNodePackage {
    name = "eventemitter2-0.4.14";
    version = "0.4.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/eventemitter2/-/eventemitter2-0.4.14.tgz";
      name = "eventemitter2-0.4.14.tgz";
      sha1 = "8f61b75cde012b2e9eb284d4545583b5643b61ab";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."exit"."~0.1.1" =
    self.by-version."exit"."0.1.2";
  by-version."exit"."0.1.2" = self.buildNodePackage {
    name = "exit-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/exit/-/exit-0.1.2.tgz";
      name = "exit-0.1.2.tgz";
      sha1 = "0632638f8d877cc82107d30a0fff1a17cba1cd0c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."express"."^4.9.5" =
    self.by-version."express"."4.13.1";
  by-version."express"."4.13.1" = self.buildNodePackage {
    name = "express-4.13.1";
    version = "4.13.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/express/-/express-4.13.1.tgz";
      name = "express-4.13.1.tgz";
      sha1 = "f117aa1d1f6bedbc8de5b6d71fc31a5acd0f63df";
    };
    deps = {
      "accepts-1.2.11" = self.by-version."accepts"."1.2.11";
      "array-flatten-1.1.0" = self.by-version."array-flatten"."1.1.0";
      "content-disposition-0.5.0" = self.by-version."content-disposition"."0.5.0";
      "content-type-1.0.1" = self.by-version."content-type"."1.0.1";
      "cookie-0.1.3" = self.by-version."cookie"."0.1.3";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "escape-html-1.0.2" = self.by-version."escape-html"."1.0.2";
      "etag-1.7.0" = self.by-version."etag"."1.7.0";
      "finalhandler-0.4.0" = self.by-version."finalhandler"."0.4.0";
      "fresh-0.3.0" = self.by-version."fresh"."0.3.0";
      "merge-descriptors-1.0.0" = self.by-version."merge-descriptors"."1.0.0";
      "methods-1.1.1" = self.by-version."methods"."1.1.1";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "path-to-regexp-0.1.6" = self.by-version."path-to-regexp"."0.1.6";
      "proxy-addr-1.0.8" = self.by-version."proxy-addr"."1.0.8";
      "qs-4.0.0" = self.by-version."qs"."4.0.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "send-0.13.0" = self.by-version."send"."0.13.0";
      "serve-static-1.10.0" = self.by-version."serve-static"."1.10.0";
      "type-is-1.6.5" = self.by-version."type-is"."1.6.5";
      "vary-1.0.1" = self.by-version."vary"."1.0.1";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."4.13.1";
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
  by-spec."faye-websocket"."~0.4.3" =
    self.by-version."faye-websocket"."0.4.4";
  by-version."faye-websocket"."0.4.4" = self.buildNodePackage {
    name = "faye-websocket-0.4.4";
    version = "0.4.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/faye-websocket/-/faye-websocket-0.4.4.tgz";
      name = "faye-websocket-0.4.4.tgz";
      sha1 = "c14c5b3bf14d7417ffbfd990c0a7495cd9f337bc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."figures"."^1.0.1" =
    self.by-version."figures"."1.3.5";
  by-version."figures"."1.3.5" = self.buildNodePackage {
    name = "figures-1.3.5";
    version = "1.3.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/figures/-/figures-1.3.5.tgz";
      name = "figures-1.3.5.tgz";
      sha1 = "d1a31f4e1d2c2938ecde5c06aa16134cf29f4771";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."finalhandler"."0.4.0" =
    self.by-version."finalhandler"."0.4.0";
  by-version."finalhandler"."0.4.0" = self.buildNodePackage {
    name = "finalhandler-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/finalhandler/-/finalhandler-0.4.0.tgz";
      name = "finalhandler-0.4.0.tgz";
      sha1 = "965a52d9e8d05d2b857548541fb89b53a2497d9b";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "escape-html-1.0.2" = self.by-version."escape-html"."1.0.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "unpipe-1.0.0" = self.by-version."unpipe"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."findup-sync"."~0.1.2" =
    self.by-version."findup-sync"."0.1.3";
  by-version."findup-sync"."0.1.3" = self.buildNodePackage {
    name = "findup-sync-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/findup-sync/-/findup-sync-0.1.3.tgz";
      name = "findup-sync-0.1.3.tgz";
      sha1 = "7f3e7a97b82392c653bf06589bd85190e93c3683";
    };
    deps = {
      "glob-3.2.11" = self.by-version."glob"."3.2.11";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
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
  by-spec."form-data"."~1.0.0-rc1" =
    self.by-version."form-data"."1.0.0-rc2";
  by-version."form-data"."1.0.0-rc2" = self.buildNodePackage {
    name = "form-data-1.0.0-rc2";
    version = "1.0.0-rc2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc2.tgz";
      name = "form-data-1.0.0-rc2.tgz";
      sha1 = "5bc9c9b3dd3dec1977b0abf58790192081d95235";
    };
    deps = {
      "async-1.4.0" = self.by-version."async"."1.4.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.3" = self.by-version."mime-types"."2.1.3";
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
  by-spec."fresh"."0.3.0" =
    self.by-version."fresh"."0.3.0";
  by-version."fresh"."0.3.0" = self.buildNodePackage {
    name = "fresh-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fresh/-/fresh-0.3.0.tgz";
      name = "fresh-0.3.0.tgz";
      sha1 = "651f838e22424e7566de161d8358caa199f83d4f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."from"."~0" =
    self.by-version."from"."0.1.3";
  by-version."from"."0.1.3" = self.buildNodePackage {
    name = "from-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/from/-/from-0.1.3.tgz";
      name = "from-0.1.3.tgz";
      sha1 = "ef63ac2062ac32acf7862e0d40b44b896f22f3bc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gaze"."~0.5.1" =
    self.by-version."gaze"."0.5.1";
  by-version."gaze"."0.5.1" = self.buildNodePackage {
    name = "gaze-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/gaze/-/gaze-0.5.1.tgz";
      name = "gaze-0.5.1.tgz";
      sha1 = "22e731078ef3e49d1c4ab1115ac091192051824c";
    };
    deps = {
      "globule-0.1.0" = self.by-version."globule"."0.1.0";
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
  by-spec."getobject"."~0.1.0" =
    self.by-version."getobject"."0.1.0";
  by-version."getobject"."0.1.0" = self.buildNodePackage {
    name = "getobject-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/getobject/-/getobject-0.1.0.tgz";
      name = "getobject-0.1.0.tgz";
      sha1 = "047a449789fa160d018f5486ed91320b6ec7885c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."3.2.3" =
    self.by-version."glob"."3.2.3";
  by-version."glob"."3.2.3" = self.buildNodePackage {
    name = "glob-3.2.3";
    version = "3.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-3.2.3.tgz";
      name = "glob-3.2.3.tgz";
      sha1 = "e313eeb249c7affaa5c475286b0e115b59839467";
    };
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."~3.1.21" =
    self.by-version."glob"."3.1.21";
  by-version."glob"."3.1.21" = self.buildNodePackage {
    name = "glob-3.1.21";
    version = "3.1.21";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-3.1.21.tgz";
      name = "glob-3.1.21.tgz";
      sha1 = "d29e0a055dea5138f4d07ed40e8982e83c2066cd";
    };
    deps = {
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "graceful-fs-1.2.3" = self.by-version."graceful-fs"."1.2.3";
      "inherits-1.0.0" = self.by-version."inherits"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."~3.2.9" =
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
  by-spec."global"."https://github.com/component/global/archive/v2.0.1.tar.gz" =
    self.by-version."global"."2.0.1";
  by-version."global"."2.0.1" = self.buildNodePackage {
    name = "global-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://github.com/component/global/archive/v2.0.1.tar.gz";
      name = "global-2.0.1.tgz";
      sha256 = "42be02b7148745447f6ba21137c972ca82d2cad92d30d63bd4fc310623901785";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."globule"."~0.1.0" =
    self.by-version."globule"."0.1.0";
  by-version."globule"."0.1.0" = self.buildNodePackage {
    name = "globule-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/globule/-/globule-0.1.0.tgz";
      name = "globule-0.1.0.tgz";
      sha1 = "d9c8edde1da79d125a151b79533b978676346ae5";
    };
    deps = {
      "lodash-1.0.2" = self.by-version."lodash"."1.0.2";
      "glob-3.1.21" = self.by-version."glob"."3.1.21";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."~1.2.0" =
    self.by-version."graceful-fs"."1.2.3";
  by-version."graceful-fs"."1.2.3" = self.buildNodePackage {
    name = "graceful-fs-1.2.3";
    version = "1.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-1.2.3.tgz";
      name = "graceful-fs-1.2.3.tgz";
      sha1 = "15a4806a57547cb2d2dbf27f42e89a8c3451b364";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."~2.0.0" =
    self.by-version."graceful-fs"."2.0.3";
  by-version."graceful-fs"."2.0.3" = self.buildNodePackage {
    name = "graceful-fs-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-2.0.3.tgz";
      name = "graceful-fs-2.0.3.tgz";
      sha1 = "7cd2cdb228a4a3f36e95efa6cc142de7d1a136d0";
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
  by-spec."growl"."1.8.1" =
    self.by-version."growl"."1.8.1";
  by-version."growl"."1.8.1" = self.buildNodePackage {
    name = "growl-1.8.1";
    version = "1.8.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/growl/-/growl-1.8.1.tgz";
      name = "growl-1.8.1.tgz";
      sha1 = "4b2dec8d907e93db336624dcec0183502f8c9428";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."grunt"."~0.4.0" =
    self.by-version."grunt"."0.4.5";
  by-version."grunt"."0.4.5" = self.buildNodePackage {
    name = "grunt-0.4.5";
    version = "0.4.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt/-/grunt-0.4.5.tgz";
      name = "grunt-0.4.5.tgz";
      sha1 = "56937cd5194324adff6d207631832a9d6ba4e7f0";
    };
    deps = {
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "coffee-script-1.3.3" = self.by-version."coffee-script"."1.3.3";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "dateformat-1.0.2-1.2.3" = self.by-version."dateformat"."1.0.2-1.2.3";
      "eventemitter2-0.4.14" = self.by-version."eventemitter2"."0.4.14";
      "findup-sync-0.1.3" = self.by-version."findup-sync"."0.1.3";
      "glob-3.1.21" = self.by-version."glob"."3.1.21";
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
      "iconv-lite-0.2.11" = self.by-version."iconv-lite"."0.2.11";
      "minimatch-0.2.14" = self.by-version."minimatch"."0.2.14";
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "lodash-0.9.2" = self.by-version."lodash"."0.9.2";
      "underscore.string-2.2.1" = self.by-version."underscore.string"."2.2.1";
      "which-1.0.9" = self.by-version."which"."1.0.9";
      "js-yaml-2.0.5" = self.by-version."js-yaml"."2.0.5";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "getobject-0.1.0" = self.by-version."getobject"."0.1.0";
      "grunt-legacy-util-0.2.0" = self.by-version."grunt-legacy-util"."0.2.0";
      "grunt-legacy-log-0.1.2" = self.by-version."grunt-legacy-log"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."grunt"."~0.4.5" =
    self.by-version."grunt"."0.4.5";
  "grunt" = self.by-version."grunt"."0.4.5";
  by-spec."grunt-contrib-uglify"."~0.5.0" =
    self.by-version."grunt-contrib-uglify"."0.5.1";
  by-version."grunt-contrib-uglify"."0.5.1" = self.buildNodePackage {
    name = "grunt-contrib-uglify-0.5.1";
    version = "0.5.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-contrib-uglify/-/grunt-contrib-uglify-0.5.1.tgz";
      name = "grunt-contrib-uglify-0.5.1.tgz";
      sha1 = "15f0aa5e8e8ba421aea980879ee505bc712b6cde";
    };
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "maxmin-0.2.2" = self.by-version."maxmin"."0.2.2";
      "uglify-js-2.4.24" = self.by-version."uglify-js"."2.4.24";
    };
    optionalDependencies = {
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"];
    os = [ ];
    cpu = [ ];
  };
  "grunt-contrib-uglify" = self.by-version."grunt-contrib-uglify"."0.5.1";
  by-spec."grunt-contrib-watch"."^0.6.1" =
    self.by-version."grunt-contrib-watch"."0.6.1";
  by-version."grunt-contrib-watch"."0.6.1" = self.buildNodePackage {
    name = "grunt-contrib-watch-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-contrib-watch/-/grunt-contrib-watch-0.6.1.tgz";
      name = "grunt-contrib-watch-0.6.1.tgz";
      sha1 = "64fdcba25a635f5b4da1b6ce6f90da0aeb6e3f15";
    };
    deps = {
      "gaze-0.5.1" = self.by-version."gaze"."0.5.1";
      "tiny-lr-fork-0.0.5" = self.by-version."tiny-lr-fork"."0.0.5";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "async-0.2.10" = self.by-version."async"."0.2.10";
    };
    optionalDependencies = {
    };
    peerDependencies = [
      self.by-version."grunt"."0.4.5"];
    os = [ ];
    cpu = [ ];
  };
  "grunt-contrib-watch" = self.by-version."grunt-contrib-watch"."0.6.1";
  by-spec."grunt-legacy-log"."~0.1.0" =
    self.by-version."grunt-legacy-log"."0.1.2";
  by-version."grunt-legacy-log"."0.1.2" = self.buildNodePackage {
    name = "grunt-legacy-log-0.1.2";
    version = "0.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-legacy-log/-/grunt-legacy-log-0.1.2.tgz";
      name = "grunt-legacy-log-0.1.2.tgz";
      sha1 = "15ee03b61e262e1b36f13762d967923cd1ce515e";
    };
    deps = {
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
      "grunt-legacy-log-utils-0.1.1" = self.by-version."grunt-legacy-log-utils"."0.1.1";
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "underscore.string-2.3.3" = self.by-version."underscore.string"."2.3.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."grunt-legacy-log-utils"."^0.1.1" =
    self.by-version."grunt-legacy-log-utils"."0.1.1";
  by-version."grunt-legacy-log-utils"."0.1.1" = self.buildNodePackage {
    name = "grunt-legacy-log-utils-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-legacy-log-utils/-/grunt-legacy-log-utils-0.1.1.tgz";
      name = "grunt-legacy-log-utils-0.1.1.tgz";
      sha1 = "c0706b9dd9064e116f36f23fe4e6b048672c0f7e";
    };
    deps = {
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "underscore.string-2.3.3" = self.by-version."underscore.string"."2.3.3";
      "colors-0.6.2" = self.by-version."colors"."0.6.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."grunt-legacy-util"."~0.2.0" =
    self.by-version."grunt-legacy-util"."0.2.0";
  by-version."grunt-legacy-util"."0.2.0" = self.buildNodePackage {
    name = "grunt-legacy-util-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-legacy-util/-/grunt-legacy-util-0.2.0.tgz";
      name = "grunt-legacy-util-0.2.0.tgz";
      sha1 = "93324884dbf7e37a9ff7c026dff451d94a9e554b";
    };
    deps = {
      "hooker-0.2.3" = self.by-version."hooker"."0.2.3";
      "async-0.1.22" = self.by-version."async"."0.1.22";
      "lodash-0.9.2" = self.by-version."lodash"."0.9.2";
      "exit-0.1.2" = self.by-version."exit"."0.1.2";
      "underscore.string-2.2.1" = self.by-version."underscore.string"."2.2.1";
      "getobject-0.1.0" = self.by-version."getobject"."0.1.0";
      "which-1.0.9" = self.by-version."which"."1.0.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."gzip-size"."^0.2.0" =
    self.by-version."gzip-size"."0.2.0";
  by-version."gzip-size"."0.2.0" = self.buildNodePackage {
    name = "gzip-size-0.2.0";
    version = "0.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/gzip-size/-/gzip-size-0.2.0.tgz";
      name = "gzip-size-0.2.0.tgz";
      sha1 = "e3a2a191205fe56ee326f5c271435dfaecfb3e1c";
    };
    deps = {
      "concat-stream-1.5.0" = self.by-version."concat-stream"."1.5.0";
      "browserify-zlib-0.1.4" = self.by-version."browserify-zlib"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."handlebars"."^2.0.0" =
    self.by-version."handlebars"."2.0.0";
  by-version."handlebars"."2.0.0" = self.buildNodePackage {
    name = "handlebars-2.0.0";
    version = "2.0.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/handlebars/-/handlebars-2.0.0.tgz";
      name = "handlebars-2.0.0.tgz";
      sha1 = "6e9d7f8514a3467fa5e9f82cc158ecfc1d5ac76f";
    };
    deps = {
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
    optionalDependencies = {
      "uglify-js-2.3.6" = self.by-version."uglify-js"."2.3.6";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "handlebars" = self.by-version."handlebars"."2.0.0";
  by-spec."har-validator"."^1.6.1" =
    self.by-version."har-validator"."1.8.0";
  by-version."har-validator"."1.8.0" = self.buildNodePackage {
    name = "har-validator-1.8.0";
    version = "1.8.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/har-validator/-/har-validator-1.8.0.tgz";
      name = "har-validator-1.8.0.tgz";
      sha1 = "d83842b0eb4c435960aeb108a067a3aa94c0eeb2";
    };
    deps = {
      "bluebird-2.9.34" = self.by-version."bluebird"."2.9.34";
      "chalk-1.1.0" = self.by-version."chalk"."1.1.0";
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "is-my-json-valid-2.12.1" = self.by-version."is-my-json-valid"."2.12.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-ansi"."^0.1.0" =
    self.by-version."has-ansi"."0.1.0";
  by-version."has-ansi"."0.1.0" = self.buildNodePackage {
    name = "has-ansi-0.1.0";
    version = "0.1.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-ansi/-/has-ansi-0.1.0.tgz";
      name = "has-ansi-0.1.0.tgz";
      sha1 = "84f265aae8c0e6a88a12d7022894b7568894c62e";
    };
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
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
  by-spec."has-binary-data"."0.1.1" =
    self.by-version."has-binary-data"."0.1.1";
  by-version."has-binary-data"."0.1.1" = self.buildNodePackage {
    name = "has-binary-data-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-binary-data/-/has-binary-data-0.1.1.tgz";
      name = "has-binary-data-0.1.1.tgz";
      sha1 = "e10749fb87828a52df96f4086587eb4a03966439";
    };
    deps = {
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."has-cors"."1.0.3" =
    self.by-version."has-cors"."1.0.3";
  by-version."has-cors"."1.0.3" = self.buildNodePackage {
    name = "has-cors-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/has-cors/-/has-cors-1.0.3.tgz";
      name = "has-cors-1.0.3.tgz";
      sha1 = "502acb9b3104dac33dd2630eaf2f888b0baf4cb3";
    };
    deps = {
      "global-2.0.1" = self.by-version."global"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."hawk"."~3.1.0" =
    self.by-version."hawk"."3.1.0";
  by-version."hawk"."3.1.0" = self.buildNodePackage {
    name = "hawk-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hawk/-/hawk-3.1.0.tgz";
      name = "hawk-3.1.0.tgz";
      sha1 = "8a13ae19977ec607602f3f0b9fd676f18c384e44";
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
  by-spec."hooker"."~0.2.3" =
    self.by-version."hooker"."0.2.3";
  by-version."hooker"."0.2.3" = self.buildNodePackage {
    name = "hooker-0.2.3";
    version = "0.2.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/hooker/-/hooker-0.2.3.tgz";
      name = "hooker-0.2.3.tgz";
      sha1 = "b834f723cc4a242aa65963459df6d984c5d3d959";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."htmlparser2"."~3.7.2" =
    self.by-version."htmlparser2"."3.7.3";
  by-version."htmlparser2"."3.7.3" = self.buildNodePackage {
    name = "htmlparser2-3.7.3";
    version = "3.7.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/htmlparser2/-/htmlparser2-3.7.3.tgz";
      name = "htmlparser2-3.7.3.tgz";
      sha1 = "6a64c77637c08c6f30ec2a8157a53333be7cb05e";
    };
    deps = {
      "domhandler-2.2.1" = self.by-version."domhandler"."2.2.1";
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
  by-spec."http-errors"."~1.3.1" =
    self.by-version."http-errors"."1.3.1";
  by-version."http-errors"."1.3.1" = self.buildNodePackage {
    name = "http-errors-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/http-errors/-/http-errors-1.3.1.tgz";
      name = "http-errors-1.3.1.tgz";
      sha1 = "197e22cdebd4198585e8694ef6786197b91ed942";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "statuses-1.2.1" = self.by-version."statuses"."1.2.1";
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
  by-spec."iconv-lite"."~0.2.11" =
    self.by-version."iconv-lite"."0.2.11";
  by-version."iconv-lite"."0.2.11" = self.buildNodePackage {
    name = "iconv-lite-0.2.11";
    version = "0.2.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/iconv-lite/-/iconv-lite-0.2.11.tgz";
      name = "iconv-lite-0.2.11.tgz";
      sha1 = "1ce60a3a57864a292d1321ff4609ca4bb965adc8";
    };
    deps = {
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
      url = "http://registry.npmjs.org/indexof/-/indexof-0.0.1.tgz";
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
  by-spec."inherits"."1" =
    self.by-version."inherits"."1.0.0";
  by-version."inherits"."1.0.0" = self.buildNodePackage {
    name = "inherits-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/inherits-1.0.0.tgz";
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
  by-spec."irc-replies"."~2.0.0" =
    self.by-version."irc-replies"."2.0.1";
  by-version."irc-replies"."2.0.1" = self.buildNodePackage {
    name = "irc-replies-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/irc-replies/-/irc-replies-2.0.1.tgz";
      name = "irc-replies-2.0.1.tgz";
      sha1 = "5bf4125fb6ec0f3929a89647b26e653232942b79";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-my-json-valid"."^2.12.0" =
    self.by-version."is-my-json-valid"."2.12.1";
  by-version."is-my-json-valid"."2.12.1" = self.buildNodePackage {
    name = "is-my-json-valid-2.12.1";
    version = "2.12.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-my-json-valid/-/is-my-json-valid-2.12.1.tgz";
      name = "is-my-json-valid-2.12.1.tgz";
      sha1 = "0ee5c19c9e93bae2760410cc72ef2798b52cc871";
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
  by-spec."jade"."0.26.3" =
    self.by-version."jade"."0.26.3";
  by-version."jade"."0.26.3" = self.buildNodePackage {
    name = "jade-0.26.3";
    version = "0.26.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/jade/-/jade-0.26.3.tgz";
      name = "jade-0.26.3.tgz";
      sha1 = "8f10d7977d8d79f2f6ff862a81b0513ccb25686c";
    };
    deps = {
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "mkdirp-0.3.0" = self.by-version."mkdirp"."0.3.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-yaml"."~2.0.5" =
    self.by-version."js-yaml"."2.0.5";
  by-version."js-yaml"."2.0.5" = self.buildNodePackage {
    name = "js-yaml-2.0.5";
    version = "2.0.5";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/js-yaml/-/js-yaml-2.0.5.tgz";
      name = "js-yaml-2.0.5.tgz";
      sha1 = "a25ae6509999e97df278c6719da11bd0687743a8";
    };
    deps = {
      "argparse-0.1.16" = self.by-version."argparse"."0.1.16";
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
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
  by-spec."json3"."3.2.6" =
    self.by-version."json3"."3.2.6";
  by-version."json3"."3.2.6" = self.buildNodePackage {
    name = "json3-3.2.6";
    version = "3.2.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/json3/-/json3-3.2.6.tgz";
      name = "json3-3.2.6.tgz";
      sha1 = "f6efc93c06a04de9aec53053df2559bb19e2038b";
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
  by-spec."linewise"."0.0.3" =
    self.by-version."linewise"."0.0.3";
  by-version."linewise"."0.0.3" = self.buildNodePackage {
    name = "linewise-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/linewise/-/linewise-0.0.3.tgz";
      name = "linewise-0.0.3.tgz";
      sha1 = "bf967ba0dd31faaf09ab5bdb3676ad7f2aa18493";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."^2.4.1" =
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
  by-spec."lodash"."~0.9.2" =
    self.by-version."lodash"."0.9.2";
  by-version."lodash"."0.9.2" = self.buildNodePackage {
    name = "lodash-0.9.2";
    version = "0.9.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-0.9.2.tgz";
      name = "lodash-0.9.2.tgz";
      sha1 = "8f3499c5245d346d682e5b0d3b40767e09f1a92c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."~1.0.1" =
    self.by-version."lodash"."1.0.2";
  by-version."lodash"."1.0.2" = self.buildNodePackage {
    name = "lodash-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-1.0.2.tgz";
      name = "lodash-1.0.2.tgz";
      sha1 = "8f57560c83b59fc270bd3d561b690043430e2551";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."~2.4.1" =
    self.by-version."lodash"."2.4.2";
  "lodash" = self.by-version."lodash"."2.4.2";
  by-spec."lru-cache"."2" =
    self.by-version."lru-cache"."2.6.5";
  by-version."lru-cache"."2.6.5" = self.buildNodePackage {
    name = "lru-cache-2.6.5";
    version = "2.6.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.6.5.tgz";
      name = "lru-cache-2.6.5.tgz";
      sha1 = "e56d6354148ede8d7707b58d143220fd08df0fd5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."map-stream"."~0.1.0" =
    self.by-version."map-stream"."0.1.0";
  by-version."map-stream"."0.1.0" = self.buildNodePackage {
    name = "map-stream-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/map-stream/-/map-stream-0.1.0.tgz";
      name = "map-stream-0.1.0.tgz";
      sha1 = "e56aa94c4c8055a16404a0674b78f215f7c8e194";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."maxmin"."^0.2.0" =
    self.by-version."maxmin"."0.2.2";
  by-version."maxmin"."0.2.2" = self.buildNodePackage {
    name = "maxmin-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/maxmin/-/maxmin-0.2.2.tgz";
      name = "maxmin-0.2.2.tgz";
      sha1 = "a36ced8cc22e3abcd108cfb797a3a4b40275593f";
    };
    deps = {
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "figures-1.3.5" = self.by-version."figures"."1.3.5";
      "gzip-size-0.2.0" = self.by-version."gzip-size"."0.2.0";
      "pretty-bytes-0.1.2" = self.by-version."pretty-bytes"."0.1.2";
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
  by-spec."mime-db"."~1.15.0" =
    self.by-version."mime-db"."1.15.0";
  by-version."mime-db"."1.15.0" = self.buildNodePackage {
    name = "mime-db-1.15.0";
    version = "1.15.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-db/-/mime-db-1.15.0.tgz";
      name = "mime-db-1.15.0.tgz";
      sha1 = "d219e6214bbcae23a6fa69c0868c4fadc1405e8a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."^2.1.1" =
    self.by-version."mime-types"."2.1.3";
  by-version."mime-types"."2.1.3" = self.buildNodePackage {
    name = "mime-types-2.1.3";
    version = "2.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mime-types/-/mime-types-2.1.3.tgz";
      name = "mime-types-2.1.3.tgz";
      sha1 = "f259849c7eb1f85b8f5f826187278a7f74f0c966";
    };
    deps = {
      "mime-db-1.15.0" = self.by-version."mime-db"."1.15.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.1.2" =
    self.by-version."mime-types"."2.1.3";
  by-spec."mime-types"."~2.1.3" =
    self.by-version."mime-types"."2.1.3";
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
      "lru-cache-2.6.5" = self.by-version."lru-cache"."2.6.5";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."~0.2.11" =
    self.by-version."minimatch"."0.2.14";
  by-version."minimatch"."0.2.14" = self.buildNodePackage {
    name = "minimatch-0.2.14";
    version = "0.2.14";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-0.2.14.tgz";
      name = "minimatch-0.2.14.tgz";
      sha1 = "c74e780574f63c6f9a090e90efbe6ef53a6a756a";
    };
    deps = {
      "lru-cache-2.6.5" = self.by-version."lru-cache"."2.6.5";
      "sigmund-1.0.1" = self.by-version."sigmund"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."minimatch"."~0.2.12" =
    self.by-version."minimatch"."0.2.14";
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
  by-spec."mkdirp"."0.3.0" =
    self.by-version."mkdirp"."0.3.0";
  by-version."mkdirp"."0.3.0" = self.buildNodePackage {
    name = "mkdirp-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.3.0.tgz";
      name = "mkdirp-0.3.0.tgz";
      sha1 = "1bbf5ab1ba827af23575143490426455f481fe1e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mkdirp"."0.5.0" =
    self.by-version."mkdirp"."0.5.0";
  by-version."mkdirp"."0.5.0" = self.buildNodePackage {
    name = "mkdirp-0.5.0";
    version = "0.5.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkdirp/-/mkdirp-0.5.0.tgz";
      name = "mkdirp-0.5.0.tgz";
      sha1 = "1d73076a6df986cd9344e15e71fcc05a4c9abf12";
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
  "mkdirp" = self.by-version."mkdirp"."0.5.1";
  by-spec."mocha"."~2.0.1" =
    self.by-version."mocha"."2.0.1";
  by-version."mocha"."2.0.1" = self.buildNodePackage {
    name = "mocha-2.0.1";
    version = "2.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/mocha/-/mocha-2.0.1.tgz";
      name = "mocha-2.0.1.tgz";
      sha1 = "5a16e88b856d0c4145d8c6888c27ebd4fab13e90";
    };
    deps = {
      "commander-2.3.0" = self.by-version."commander"."2.3.0";
      "debug-2.0.0" = self.by-version."debug"."2.0.0";
      "diff-1.0.8" = self.by-version."diff"."1.0.8";
      "escape-string-regexp-1.0.2" = self.by-version."escape-string-regexp"."1.0.2";
      "glob-3.2.3" = self.by-version."glob"."3.2.3";
      "growl-1.8.1" = self.by-version."growl"."1.8.1";
      "jade-0.26.3" = self.by-version."jade"."0.26.3";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "mocha" = self.by-version."mocha"."2.0.1";
  by-spec."moment"."~2.7.0" =
    self.by-version."moment"."2.7.0";
  by-version."moment"."2.7.0" = self.buildNodePackage {
    name = "moment-2.7.0";
    version = "2.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/moment/-/moment-2.7.0.tgz";
      name = "moment-2.7.0.tgz";
      sha1 = "359a19ec634cda3c706c8709adda54c0329aaec4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "moment" = self.by-version."moment"."2.7.0";
  by-spec."ms"."0.6.2" =
    self.by-version."ms"."0.6.2";
  by-version."ms"."0.6.2" = self.buildNodePackage {
    name = "ms-0.6.2";
    version = "0.6.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ms/-/ms-0.6.2.tgz";
      name = "ms-0.6.2.tgz";
      sha1 = "d89c2124c6fdc1353d65a8b77bf1aac4b193708c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."nan"."~0.3.0" =
    self.by-version."nan"."0.3.2";
  by-version."nan"."0.3.2" = self.buildNodePackage {
    name = "nan-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nan/-/nan-0.3.2.tgz";
      name = "nan-0.3.2.tgz";
      sha1 = "0df1935cab15369075ef160ad2894107aa14dc2d";
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
  by-spec."nopt"."~1.0.10" =
    self.by-version."nopt"."1.0.10";
  by-version."nopt"."1.0.10" = self.buildNodePackage {
    name = "nopt-1.0.10";
    version = "1.0.10";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/nopt-1.0.10.tgz";
      name = "nopt-1.0.10.tgz";
      sha1 = "6ddd21bd2a31417b92727dd585f8a6f37608ebee";
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
  by-spec."nopt"."~2.0.0" =
    self.by-version."nopt"."2.0.0";
  by-version."nopt"."2.0.0" = self.buildNodePackage {
    name = "nopt-2.0.0";
    version = "2.0.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/nopt-2.0.0.tgz";
      name = "nopt-2.0.0.tgz";
      sha1 = "ca7416f20a5e3f9c3b86180f96295fa3d0b52e0d";
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
  by-spec."noptify"."~0.0.3" =
    self.by-version."noptify"."0.0.3";
  by-version."noptify"."0.0.3" = self.buildNodePackage {
    name = "noptify-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/noptify/-/noptify-0.0.3.tgz";
      name = "noptify-0.0.3.tgz";
      sha1 = "58f654a73d9753df0c51d9686dc92104a67f4bbb";
    };
    deps = {
      "nopt-2.0.0" = self.by-version."nopt"."2.0.0";
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
  by-spec."object-component"."0.0.3" =
    self.by-version."object-component"."0.0.3";
  by-version."object-component"."0.0.3" = self.buildNodePackage {
    name = "object-component-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-component/-/object-component-0.0.3.tgz";
      name = "object-component-0.0.3.tgz";
      sha1 = "f0c69aa50efc95b866c186f400a33769cb2f1291";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."on-finished"."~2.3.0" =
    self.by-version."on-finished"."2.3.0";
  by-version."on-finished"."2.3.0" = self.buildNodePackage {
    name = "on-finished-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz";
      name = "on-finished-2.3.0.tgz";
      sha1 = "20f1336481b083cd75337992a16971aa2d906947";
    };
    deps = {
      "ee-first-1.1.1" = self.by-version."ee-first"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."~0.3" =
    self.by-version."optimist"."0.3.7";
  by-version."optimist"."0.3.7" = self.buildNodePackage {
    name = "optimist-0.3.7";
    version = "0.3.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/optimist/-/optimist-0.3.7.tgz";
      name = "optimist-0.3.7.tgz";
      sha1 = "c90941ad59e4273328923074d2cf2e7cbc6ec0d9";
    };
    deps = {
      "wordwrap-0.0.3" = self.by-version."wordwrap"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."optimist"."~0.3.5" =
    self.by-version."optimist"."0.3.7";
  by-spec."options".">=0.0.5" =
    self.by-version."options"."0.0.6";
  by-version."options"."0.0.6" = self.buildNodePackage {
    name = "options-0.0.6";
    version = "0.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/options/-/options-0.0.6.tgz";
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
  by-spec."pako"."~0.2.0" =
    self.by-version."pako"."0.2.7";
  by-version."pako"."0.2.7" = self.buildNodePackage {
    name = "pako-0.2.7";
    version = "0.2.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pako/-/pako-0.2.7.tgz";
      name = "pako-0.2.7.tgz";
      sha1 = "90e8917affd5ee2b69dfe943ec16b783c4e0c441";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parsejson"."0.0.1" =
    self.by-version."parsejson"."0.0.1";
  by-version."parsejson"."0.0.1" = self.buildNodePackage {
    name = "parsejson-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parsejson/-/parsejson-0.0.1.tgz";
      name = "parsejson-0.0.1.tgz";
      sha1 = "9b10c6c0d825ab589e685153826de0a3ba278bcc";
    };
    deps = {
      "better-assert-1.0.2" = self.by-version."better-assert"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseqs"."0.0.2" =
    self.by-version."parseqs"."0.0.2";
  by-version."parseqs"."0.0.2" = self.buildNodePackage {
    name = "parseqs-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parseqs/-/parseqs-0.0.2.tgz";
      name = "parseqs-0.0.2.tgz";
      sha1 = "9dfe70b2cddac388bde4f35b1f240fa58adbe6c7";
    };
    deps = {
      "better-assert-1.0.2" = self.by-version."better-assert"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."parseuri"."0.0.2" =
    self.by-version."parseuri"."0.0.2";
  by-version."parseuri"."0.0.2" = self.buildNodePackage {
    name = "parseuri-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/parseuri/-/parseuri-0.0.2.tgz";
      name = "parseuri-0.0.2.tgz";
      sha1 = "db41878f2d6964718be870b3140973d8093be156";
    };
    deps = {
      "better-assert-1.0.2" = self.by-version."better-assert"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."path-to-regexp"."0.1.6" =
    self.by-version."path-to-regexp"."0.1.6";
  by-version."path-to-regexp"."0.1.6" = self.buildNodePackage {
    name = "path-to-regexp-0.1.6";
    version = "0.1.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.6.tgz";
      name = "path-to-regexp-0.1.6.tgz";
      sha1 = "f01fd5734047b6bfbc5f208c6135a33d7af09c36";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pause-stream"."0.0.11" =
    self.by-version."pause-stream"."0.0.11";
  by-version."pause-stream"."0.0.11" = self.buildNodePackage {
    name = "pause-stream-0.0.11";
    version = "0.0.11";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pause-stream/-/pause-stream-0.0.11.tgz";
      name = "pause-stream-0.0.11.tgz";
      sha1 = "fe5a34b0cbce12b5aa6a2b403ee2e73b602f1445";
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
  by-spec."pretty-bytes"."^0.1.0" =
    self.by-version."pretty-bytes"."0.1.2";
  by-version."pretty-bytes"."0.1.2" = self.buildNodePackage {
    name = "pretty-bytes-0.1.2";
    version = "0.1.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/pretty-bytes/-/pretty-bytes-0.1.2.tgz";
      name = "pretty-bytes-0.1.2.tgz";
      sha1 = "cd90294d58a1ca4e8a5d0fb9c8225998881acf00";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."process-nextick-args"."~1.0.0" =
    self.by-version."process-nextick-args"."1.0.2";
  by-version."process-nextick-args"."1.0.2" = self.buildNodePackage {
    name = "process-nextick-args-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/process-nextick-args/-/process-nextick-args-1.0.2.tgz";
      name = "process-nextick-args-1.0.2.tgz";
      sha1 = "8b4d3fc586668bd5b6573e732edf2b71c1c1d8aa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."qs"."4.0.0" =
    self.by-version."qs"."4.0.0";
  by-version."qs"."4.0.0" = self.buildNodePackage {
    name = "qs-4.0.0";
    version = "4.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-4.0.0.tgz";
      name = "qs-4.0.0.tgz";
      sha1 = "c31d9b74ec27df75e543a86c78728ed8d4623607";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~0.5.2" =
    self.by-version."qs"."0.5.6";
  by-version."qs"."0.5.6" = self.buildNodePackage {
    name = "qs-0.5.6";
    version = "0.5.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/qs/-/qs-0.5.6.tgz";
      name = "qs-0.5.6.tgz";
      sha1 = "31b1ad058567651c526921506b9a8793911a0384";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~4.0.0" =
    self.by-version."qs"."4.0.0";
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
  by-spec."read"."^1.0.5" =
    self.by-version."read"."1.0.6";
  by-version."read"."1.0.6" = self.buildNodePackage {
    name = "read-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/read/-/read-1.0.6.tgz";
      name = "read-1.0.6.tgz";
      sha1 = "09873c14ecc114d063fad43b8ca5a33d304721c8";
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
  "read" = self.by-version."read"."1.0.6";
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
  by-spec."readable-stream"."~2.0.0" =
    self.by-version."readable-stream"."2.0.2";
  by-version."readable-stream"."2.0.2" = self.buildNodePackage {
    name = "readable-stream-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readable-stream/-/readable-stream-2.0.2.tgz";
      name = "readable-stream-2.0.2.tgz";
      sha1 = "bec81beae8cf455168bc2e5b2b31f5bcfaed9b1b";
    };
    deps = {
      "core-util-is-1.0.1" = self.by-version."core-util-is"."1.0.1";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
      "process-nextick-args-1.0.2" = self.by-version."process-nextick-args"."1.0.2";
      "string_decoder-0.10.31" = self.by-version."string_decoder"."0.10.31";
      "util-deprecate-1.0.1" = self.by-version."util-deprecate"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.51.0" =
    self.by-version."request"."2.60.0";
  by-version."request"."2.60.0" = self.buildNodePackage {
    name = "request-2.60.0";
    version = "2.60.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.60.0.tgz";
      name = "request-2.60.0.tgz";
      sha1 = "498820957fcdded1d37749069610c85f61a29f2d";
    };
    deps = {
      "bl-1.0.0" = self.by-version."bl"."1.0.0";
      "caseless-0.11.0" = self.by-version."caseless"."0.11.0";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-1.0.0-rc2" = self.by-version."form-data"."1.0.0-rc2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.3" = self.by-version."mime-types"."2.1.3";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-4.0.0" = self.by-version."qs"."4.0.0";
      "tunnel-agent-0.4.1" = self.by-version."tunnel-agent"."0.4.1";
      "tough-cookie-2.0.0" = self.by-version."tough-cookie"."2.0.0";
      "http-signature-0.11.0" = self.by-version."http-signature"."0.11.0";
      "oauth-sign-0.8.0" = self.by-version."oauth-sign"."0.8.0";
      "hawk-3.1.0" = self.by-version."hawk"."3.1.0";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "har-validator-1.8.0" = self.by-version."har-validator"."1.8.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "request" = self.by-version."request"."2.60.0";
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
  by-spec."send"."0.13.0" =
    self.by-version."send"."0.13.0";
  by-version."send"."0.13.0" = self.buildNodePackage {
    name = "send-0.13.0";
    version = "0.13.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/send/-/send-0.13.0.tgz";
      name = "send-0.13.0.tgz";
      sha1 = "518f921aeb0560aec7dcab2990b14cf6f3cce5de";
    };
    deps = {
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
      "depd-1.0.1" = self.by-version."depd"."1.0.1";
      "destroy-1.0.3" = self.by-version."destroy"."1.0.3";
      "escape-html-1.0.2" = self.by-version."escape-html"."1.0.2";
      "etag-1.7.0" = self.by-version."etag"."1.7.0";
      "fresh-0.3.0" = self.by-version."fresh"."0.3.0";
      "http-errors-1.3.1" = self.by-version."http-errors"."1.3.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.1" = self.by-version."ms"."0.7.1";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "range-parser-1.0.2" = self.by-version."range-parser"."1.0.2";
      "statuses-1.2.1" = self.by-version."statuses"."1.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-static"."~1.10.0" =
    self.by-version."serve-static"."1.10.0";
  by-version."serve-static"."1.10.0" = self.buildNodePackage {
    name = "serve-static-1.10.0";
    version = "1.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/serve-static/-/serve-static-1.10.0.tgz";
      name = "serve-static-1.10.0.tgz";
      sha1 = "be632faa685820e4a43ed3df1379135cc4f370d7";
    };
    deps = {
      "escape-html-1.0.2" = self.by-version."escape-html"."1.0.2";
      "parseurl-1.3.0" = self.by-version."parseurl"."1.3.0";
      "send-0.13.0" = self.by-version."send"."0.13.0";
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
  by-spec."slate-irc"."~0.7.3" =
    self.by-version."slate-irc"."0.7.3";
  by-version."slate-irc"."0.7.3" = self.buildNodePackage {
    name = "slate-irc-0.7.3";
    version = "0.7.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/slate-irc/-/slate-irc-0.7.3.tgz";
      name = "slate-irc-0.7.3.tgz";
      sha1 = "8d01f2bc809e00a5b2faca7d8d3130d155422a77";
    };
    deps = {
      "irc-replies-2.0.1" = self.by-version."irc-replies"."2.0.1";
      "slate-irc-parser-0.0.2" = self.by-version."slate-irc-parser"."0.0.2";
      "debug-2.2.0" = self.by-version."debug"."2.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "slate-irc" = self.by-version."slate-irc"."0.7.3";
  by-spec."slate-irc-parser"."0.0.2" =
    self.by-version."slate-irc-parser"."0.0.2";
  by-version."slate-irc-parser"."0.0.2" = self.buildNodePackage {
    name = "slate-irc-parser-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/slate-irc-parser/-/slate-irc-parser-0.0.2.tgz";
      name = "slate-irc-parser-0.0.2.tgz";
      sha1 = "0c5f8f20d817bb85329da9fca135c66b05947d80";
    };
    deps = {
      "linewise-0.0.3" = self.by-version."linewise"."0.0.3";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
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
  by-spec."socket.io"."~1.0.6" =
    self.by-version."socket.io"."1.0.6";
  by-version."socket.io"."1.0.6" = self.buildNodePackage {
    name = "socket.io-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io/-/socket.io-1.0.6.tgz";
      name = "socket.io-1.0.6.tgz";
      sha1 = "b566532888dae3ac9058a12f294015ebdfa8084a";
    };
    deps = {
      "engine.io-1.3.1" = self.by-version."engine.io"."1.3.1";
      "socket.io-parser-2.2.0" = self.by-version."socket.io-parser"."2.2.0";
      "socket.io-client-1.0.6" = self.by-version."socket.io-client"."1.0.6";
      "socket.io-adapter-0.2.0" = self.by-version."socket.io-adapter"."0.2.0";
      "has-binary-data-0.1.1" = self.by-version."has-binary-data"."0.1.1";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "socket.io" = self.by-version."socket.io"."1.0.6";
  by-spec."socket.io-adapter"."0.2.0" =
    self.by-version."socket.io-adapter"."0.2.0";
  by-version."socket.io-adapter"."0.2.0" = self.buildNodePackage {
    name = "socket.io-adapter-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-adapter/-/socket.io-adapter-0.2.0.tgz";
      name = "socket.io-adapter-0.2.0.tgz";
      sha1 = "bd39329b8961371787e24f345b074ec9cf000e33";
    };
    deps = {
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "socket.io-parser-2.1.2" = self.by-version."socket.io-parser"."2.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io-client"."1.0.6" =
    self.by-version."socket.io-client"."1.0.6";
  by-version."socket.io-client"."1.0.6" = self.buildNodePackage {
    name = "socket.io-client-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-client/-/socket.io-client-1.0.6.tgz";
      name = "socket.io-client-1.0.6.tgz";
      sha1 = "c86cb3e507ab2f96da4500bd34fcf46a1e9dfe5e";
    };
    deps = {
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "engine.io-client-1.3.1" = self.by-version."engine.io-client"."1.3.1";
      "component-bind-1.0.0" = self.by-version."component-bind"."1.0.0";
      "component-emitter-1.1.2" = self.by-version."component-emitter"."1.1.2";
      "object-component-0.0.3" = self.by-version."object-component"."0.0.3";
      "socket.io-parser-2.2.0" = self.by-version."socket.io-parser"."2.2.0";
      "has-binary-data-0.1.1" = self.by-version."has-binary-data"."0.1.1";
      "indexof-0.0.1" = self.by-version."indexof"."0.0.1";
      "parseuri-0.0.2" = self.by-version."parseuri"."0.0.2";
      "to-array-0.1.3" = self.by-version."to-array"."0.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io-parser"."2.1.2" =
    self.by-version."socket.io-parser"."2.1.2";
  by-version."socket.io-parser"."2.1.2" = self.buildNodePackage {
    name = "socket.io-parser-2.1.2";
    version = "2.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-parser/-/socket.io-parser-2.1.2.tgz";
      name = "socket.io-parser-2.1.2.tgz";
      sha1 = "876655b9edd555c5bdf7301cedf30a436c67b8b0";
    };
    deps = {
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "json3-3.2.6" = self.by-version."json3"."3.2.6";
      "emitter-1.0.1" = self.by-version."emitter"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."socket.io-parser"."2.2.0" =
    self.by-version."socket.io-parser"."2.2.0";
  by-version."socket.io-parser"."2.2.0" = self.buildNodePackage {
    name = "socket.io-parser-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/socket.io-parser/-/socket.io-parser-2.2.0.tgz";
      name = "socket.io-parser-2.2.0.tgz";
      sha1 = "2609601f59e6a7fab436a53be3d333fbbfcbd30a";
    };
    deps = {
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
      "json3-3.2.6" = self.by-version."json3"."3.2.6";
      "emitter-1.0.1" = self.by-version."emitter"."1.0.1";
      "isarray-0.0.1" = self.by-version."isarray"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."0.1.34" =
    self.by-version."source-map"."0.1.34";
  by-version."source-map"."0.1.34" = self.buildNodePackage {
    name = "source-map-0.1.34";
    version = "0.1.34";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/source-map/-/source-map-0.1.34.tgz";
      name = "source-map-0.1.34.tgz";
      sha1 = "a7cfe89aec7b1682c3b198d0acfb47d7d090566b";
    };
    deps = {
      "amdefine-1.0.0" = self.by-version."amdefine"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.1.7" =
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
      "amdefine-1.0.0" = self.by-version."amdefine"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."split"."0.3" =
    self.by-version."split"."0.3.3";
  by-version."split"."0.3.3" = self.buildNodePackage {
    name = "split-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/split/-/split-0.3.3.tgz";
      name = "split-0.3.3.tgz";
      sha1 = "cd0eea5e63a211dfff7eb0f091c4133e2d0dd28f";
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
  by-spec."statuses"."1" =
    self.by-version."statuses"."1.2.1";
  by-version."statuses"."1.2.1" = self.buildNodePackage {
    name = "statuses-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/statuses/-/statuses-1.2.1.tgz";
      name = "statuses-1.2.1.tgz";
      sha1 = "dded45cc18256d51ed40aec142489d5c61026d28";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."statuses"."~1.2.1" =
    self.by-version."statuses"."1.2.1";
  by-spec."stream-combiner"."~0.0.4" =
    self.by-version."stream-combiner"."0.0.4";
  by-version."stream-combiner"."0.0.4" = self.buildNodePackage {
    name = "stream-combiner-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stream-combiner/-/stream-combiner-0.0.4.tgz";
      name = "stream-combiner-0.0.4.tgz";
      sha1 = "4d5e433c185261dde623ca3f44c586bcf5c4ad14";
    };
    deps = {
      "duplexer-0.1.1" = self.by-version."duplexer"."0.1.1";
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
  by-spec."strip-ansi"."^0.3.0" =
    self.by-version."strip-ansi"."0.3.0";
  by-version."strip-ansi"."0.3.0" = self.buildNodePackage {
    name = "strip-ansi-0.3.0";
    version = "0.3.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-ansi/-/strip-ansi-0.3.0.tgz";
      name = "strip-ansi-0.3.0.tgz";
      sha1 = "25f48ea22ca79187f3174a4db8759347bb126220";
    };
    deps = {
      "ansi-regex-0.2.1" = self.by-version."ansi-regex"."0.2.1";
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
  by-spec."supports-color"."^0.2.0" =
    self.by-version."supports-color"."0.2.0";
  by-version."supports-color"."0.2.0" = self.buildNodePackage {
    name = "supports-color-0.2.0";
    version = "0.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/supports-color/-/supports-color-0.2.0.tgz";
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
  by-spec."through"."2" =
    self.by-version."through"."2.3.8";
  by-version."through"."2.3.8" = self.buildNodePackage {
    name = "through-2.3.8";
    version = "2.3.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/through/-/through-2.3.8.tgz";
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
  by-spec."through"."~2.3" =
    self.by-version."through"."2.3.8";
  by-spec."through"."~2.3.1" =
    self.by-version."through"."2.3.8";
  by-spec."tiny-lr-fork"."0.0.5" =
    self.by-version."tiny-lr-fork"."0.0.5";
  by-version."tiny-lr-fork"."0.0.5" = self.buildNodePackage {
    name = "tiny-lr-fork-0.0.5";
    version = "0.0.5";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/tiny-lr-fork/-/tiny-lr-fork-0.0.5.tgz";
      name = "tiny-lr-fork-0.0.5.tgz";
      sha1 = "1e99e1e2a8469b736ab97d97eefa98c71f76ed0a";
    };
    deps = {
      "qs-0.5.6" = self.by-version."qs"."0.5.6";
      "faye-websocket-0.4.4" = self.by-version."faye-websocket"."0.4.4";
      "noptify-0.0.3" = self.by-version."noptify"."0.0.3";
      "debug-0.7.4" = self.by-version."debug"."0.7.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tinycolor"."0.x" =
    self.by-version."tinycolor"."0.0.1";
  by-version."tinycolor"."0.0.1" = self.buildNodePackage {
    name = "tinycolor-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tinycolor/-/tinycolor-0.0.1.tgz";
      name = "tinycolor-0.0.1.tgz";
      sha1 = "320b5a52d83abb5978d81a3e887d4aefb15a6164";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."to-array"."0.1.3" =
    self.by-version."to-array"."0.1.3";
  by-version."to-array"."0.1.3" = self.buildNodePackage {
    name = "to-array-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/to-array/-/to-array-0.1.3.tgz";
      name = "to-array-0.1.3.tgz";
      sha1 = "d45dadc6363417f60f28474fea50ecddbb4f4991";
    };
    deps = {
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
  by-spec."tunnel-agent"."~0.4.0" =
    self.by-version."tunnel-agent"."0.4.1";
  by-version."tunnel-agent"."0.4.1" = self.buildNodePackage {
    name = "tunnel-agent-0.4.1";
    version = "0.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.4.1.tgz";
      name = "tunnel-agent-0.4.1.tgz";
      sha1 = "bbeecff4d679ce753db9462761a88dfcec3c5ab3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."type-is"."~1.6.4" =
    self.by-version."type-is"."1.6.5";
  by-version."type-is"."1.6.5" = self.buildNodePackage {
    name = "type-is-1.6.5";
    version = "1.6.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/type-is/-/type-is-1.6.5.tgz";
      name = "type-is-1.6.5.tgz";
      sha1 = "92129495c7b7563eaf923b447382c6c471f95de4";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.1.3" = self.by-version."mime-types"."2.1.3";
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
  by-spec."uglify-js"."^2.4.0" =
    self.by-version."uglify-js"."2.4.24";
  by-version."uglify-js"."2.4.24" = self.buildNodePackage {
    name = "uglify-js-2.4.24";
    version = "2.4.24";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.4.24.tgz";
      name = "uglify-js-2.4.24.tgz";
      sha1 = "fad5755c1e1577658bb06ff9ab6e548c95bebd6e";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.34" = self.by-version."source-map"."0.1.34";
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
      "yargs-3.5.4" = self.by-version."yargs"."3.5.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uglify-js"."~2.3" =
    self.by-version."uglify-js"."2.3.6";
  by-version."uglify-js"."2.3.6" = self.buildNodePackage {
    name = "uglify-js-2.3.6";
    version = "2.3.6";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-js/-/uglify-js-2.3.6.tgz";
      name = "uglify-js-2.3.6.tgz";
      sha1 = "fa0984770b428b7a9b2a8058f46355d14fef211a";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "source-map-0.1.43" = self.by-version."source-map"."0.1.43";
      "optimist-0.3.7" = self.by-version."optimist"."0.3.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uglify-to-browserify"."~1.0.0" =
    self.by-version."uglify-to-browserify"."1.0.2";
  by-version."uglify-to-browserify"."1.0.2" = self.buildNodePackage {
    name = "uglify-to-browserify-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
      name = "uglify-to-browserify-1.0.2.tgz";
      sha1 = "6e0924d6bda6b5afe349e39a6d632850a0f882b7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore"."~1.7.0" =
    self.by-version."underscore"."1.7.0";
  by-version."underscore"."1.7.0" = self.buildNodePackage {
    name = "underscore-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore/-/underscore-1.7.0.tgz";
      name = "underscore-1.7.0.tgz";
      sha1 = "6bbaf0877500d36be34ecaa584e0db9fef035209";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore.string"."~2.2.1" =
    self.by-version."underscore.string"."2.2.1";
  by-version."underscore.string"."2.2.1" = self.buildNodePackage {
    name = "underscore.string-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.2.1.tgz";
      name = "underscore.string-2.2.1.tgz";
      sha1 = "d7c0fa2af5d5a1a67f4253daee98132e733f0f19";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."underscore.string"."~2.3.3" =
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
  by-spec."underscore.string"."~2.4.0" =
    self.by-version."underscore.string"."2.4.0";
  by-version."underscore.string"."2.4.0" = self.buildNodePackage {
    name = "underscore.string-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/underscore.string/-/underscore.string-2.4.0.tgz";
      name = "underscore.string-2.4.0.tgz";
      sha1 = "8cdd8fbac4e2d2ea1e7e2e8097c42f442280f85b";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unpipe"."~1.0.0" =
    self.by-version."unpipe"."1.0.0";
  by-version."unpipe"."1.0.0" = self.buildNodePackage {
    name = "unpipe-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz";
      name = "unpipe-1.0.0.tgz";
      sha1 = "b2bf4ee8514aae6165b4817829d21b2ef49904ec";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."utf8"."2.0.0" =
    self.by-version."utf8"."2.0.0";
  by-version."utf8"."2.0.0" = self.buildNodePackage {
    name = "utf8-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/utf8/-/utf8-2.0.0.tgz";
      name = "utf8-2.0.0.tgz";
      sha1 = "79ce59eced874809cab9a71fc7102c7d45d4118d";
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
    self.by-version."util-deprecate"."1.0.1";
  by-version."util-deprecate"."1.0.1" = self.buildNodePackage {
    name = "util-deprecate-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/util-deprecate/-/util-deprecate-1.0.1.tgz";
      name = "util-deprecate-1.0.1.tgz";
      sha1 = "3556a3d13c4c6aa7983d7e2425478197199b7881";
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
    self.by-version."vary"."1.0.1";
  by-version."vary"."1.0.1" = self.buildNodePackage {
    name = "vary-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/vary/-/vary-1.0.1.tgz";
      name = "vary-1.0.1.tgz";
      sha1 = "99e4981566a286118dfb2b817357df7993376d10";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."which"."~1.0.5" =
    self.by-version."which"."1.0.9";
  by-version."which"."1.0.9" = self.buildNodePackage {
    name = "which-1.0.9";
    version = "1.0.9";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/which/-/which-1.0.9.tgz";
      name = "which-1.0.9.tgz";
      sha1 = "460c1da0f810103d0321a9b633af9e575e64486f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."window-size"."0.1.0" =
    self.by-version."window-size"."0.1.0";
  by-version."window-size"."0.1.0" = self.buildNodePackage {
    name = "window-size-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz";
      name = "window-size-0.1.0.tgz";
      sha1 = "5438cd2ea93b202efa3a19fe8887aee7c94f9c9d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."wordwrap"."0.0.2" =
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
  by-spec."ws"."0.4.31" =
    self.by-version."ws"."0.4.31";
  by-version."ws"."0.4.31" = self.buildNodePackage {
    name = "ws-0.4.31";
    version = "0.4.31";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/ws/-/ws-0.4.31.tgz";
      name = "ws-0.4.31.tgz";
      sha1 = "5a4849e7a9ccd1ed5a81aeb4847c9fedf3122927";
    };
    deps = {
      "commander-0.6.1" = self.by-version."commander"."0.6.1";
      "nan-0.3.2" = self.by-version."nan"."0.3.2";
      "tinycolor-0.0.1" = self.by-version."tinycolor"."0.0.1";
      "options-0.0.6" = self.by-version."options"."0.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xmlhttprequest"."https://github.com/LearnBoost/node-XMLHttpRequest/archive/0f36d0b5ebc03d85f860d42a64ae9791e1daa433.tar.gz" =
    self.by-version."xmlhttprequest"."1.5.0";
  by-version."xmlhttprequest"."1.5.0" = self.buildNodePackage {
    name = "xmlhttprequest-1.5.0";
    version = "1.5.0";
    bin = false;
    src = fetchurl {
      url = "https://github.com/LearnBoost/node-XMLHttpRequest/archive/0f36d0b5ebc03d85f860d42a64ae9791e1daa433.tar.gz";
      name = "xmlhttprequest-1.5.0.tgz";
      sha256 = "28dd0394d85befe8be4e9cd9f6803102780c62cbb09298cb174b52ff9777624f";
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
  by-spec."yargs"."~3.5.4" =
    self.by-version."yargs"."3.5.4";
  by-version."yargs"."3.5.4" = self.buildNodePackage {
    name = "yargs-3.5.4";
    version = "3.5.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/yargs/-/yargs-3.5.4.tgz";
      name = "yargs-3.5.4.tgz";
      sha1 = "d8aff8f665e94c34bd259bdebd1bfaf0ddd35361";
    };
    deps = {
      "camelcase-1.1.0" = self.by-version."camelcase"."1.1.0";
      "decamelize-1.0.0" = self.by-version."decamelize"."1.0.0";
      "window-size-0.1.0" = self.by-version."window-size"."0.1.0";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}

{ self, fetchurl, fetchgit ? null, lib }:

{
  by-spec."accepts"."~1.3.3" =
    self.by-version."accepts"."1.3.3";
  by-version."accepts"."1.3.3" = self.buildNodePackage {
    name = "accepts-1.3.3";
    version = "1.3.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/accepts/-/accepts-1.3.3.tgz";
      name = "accepts-1.3.3.tgz";
      sha1 = "c3ca7434938648c3e0d9c1e328dd68b622c284ca";
    };
    deps = {
      "mime-types-2.1.14" = self.by-version."mime-types"."2.1.14";
      "negotiator-0.6.1" = self.by-version."negotiator"."0.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."acorn"."^4.0.4" =
    self.by-version."acorn"."4.0.11";
  by-version."acorn"."4.0.11" = self.buildNodePackage {
    name = "acorn-4.0.11";
    version = "4.0.11";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/acorn/-/acorn-4.0.11.tgz";
      name = "acorn-4.0.11.tgz";
      sha1 = "edcda3bd937e7556410d42ed5860f67399c794c0";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."acorn"."~3.3.0" =
    self.by-version."acorn"."3.3.0";
  by-spec."acorn"."~4.0.2" =
    self.by-version."acorn"."4.0.11";
  by-spec."acorn-globals"."^3.0.0" =
    self.by-version."acorn-globals"."3.1.0";
  by-version."acorn-globals"."3.1.0" = self.buildNodePackage {
    name = "acorn-globals-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/acorn-globals/-/acorn-globals-3.1.0.tgz";
      name = "acorn-globals-3.1.0.tgz";
      sha1 = "fd8270f71fbb4996b004fa880ee5d46573a731bf";
    };
    deps = {
      "acorn-4.0.11" = self.by-version."acorn"."4.0.11";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ajv"."^4.9.1" =
    self.by-version."ajv"."4.11.5";
  by-version."ajv"."4.11.5" = self.buildNodePackage {
    name = "ajv-4.11.5";
    version = "4.11.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ajv/-/ajv-4.11.5.tgz";
      name = "ajv-4.11.5.tgz";
      sha1 = "b6ee74657b993a01dce44b7944d56f485828d5bd";
    };
    deps = {
      "co-4.6.0" = self.by-version."co"."4.6.0";
      "json-stable-stringify-1.0.1" = self.by-version."json-stable-stringify"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."align-text"."^0.1.1" =
    self.by-version."align-text"."0.1.4";
  by-version."align-text"."0.1.4" = self.buildNodePackage {
    name = "align-text-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/align-text/-/align-text-0.1.4.tgz";
      name = "align-text-0.1.4.tgz";
      sha1 = "0cd90a561093f35d0a99256c22b7069433fad117";
    };
    deps = {
      "kind-of-3.1.0" = self.by-version."kind-of"."3.1.0";
      "longest-1.0.1" = self.by-version."longest"."1.0.1";
      "repeat-string-1.6.1" = self.by-version."repeat-string"."1.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."align-text"."^0.1.3" =
    self.by-version."align-text"."0.1.4";
  by-spec."amdefine".">=0.0.4" =
    self.by-version."amdefine"."1.0.1";
  by-version."amdefine"."1.0.1" = self.buildNodePackage {
    name = "amdefine-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/amdefine/-/amdefine-1.0.1.tgz";
      name = "amdefine-1.0.1.tgz";
      sha1 = "4a5282ac164729e93619bcfd3ad151f817ce91f5";
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
    self.by-version."ansi-regex"."2.1.1";
  by-version."ansi-regex"."2.1.1" = self.buildNodePackage {
    name = "ansi-regex-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ansi-regex/-/ansi-regex-2.1.1.tgz";
      name = "ansi-regex-2.1.1.tgz";
      sha1 = "c3b33ab5ee360d86e0e628f0468ae7ef27d654df";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."aproba"."^1.0.3" =
    self.by-version."aproba"."1.1.1";
  by-version."aproba"."1.1.1" = self.buildNodePackage {
    name = "aproba-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aproba/-/aproba-1.1.1.tgz";
      name = "aproba-1.1.1.tgz";
      sha1 = "95d3600f07710aa0e9298c726ad5ecf2eacbabab";
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
      "readable-stream-2.2.6" = self.by-version."readable-stream"."2.2.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-flatten"."1.1.1" =
    self.by-version."array-flatten"."1.1.1";
  by-version."array-flatten"."1.1.1" = self.buildNodePackage {
    name = "array-flatten-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/array-flatten/-/array-flatten-1.1.1.tgz";
      name = "array-flatten-1.1.1.tgz";
      sha1 = "9a5f699051b1e7073328f2a008968b64ea2955d2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."asap"."~2.0.3" =
    self.by-version."asap"."2.0.5";
  by-version."asap"."2.0.5" = self.buildNodePackage {
    name = "asap-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/asap/-/asap-2.0.5.tgz";
      name = "asap-2.0.5.tgz";
      sha1 = "522765b50c3510490e52d7dcfe085ef9ba96958f";
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
  by-spec."assert-plus"."1.0.0" =
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
    self.by-version."aws4"."1.6.0";
  by-version."aws4"."1.6.0" = self.buildNodePackage {
    name = "aws4-1.6.0";
    version = "1.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/aws4/-/aws4-1.6.0.tgz";
      name = "aws4-1.6.0.tgz";
      sha1 = "83ef5ca860b2b32e4a0deedee8c771b9db57471e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."basic-auth"."~1.1.0" =
    self.by-version."basic-auth"."1.1.0";
  by-version."basic-auth"."1.1.0" = self.buildNodePackage {
    name = "basic-auth-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/basic-auth/-/basic-auth-1.1.0.tgz";
      name = "basic-auth-1.1.0.tgz";
      sha1 = "45221ee429f7ee1e5035be3f51533f1cdfd29884";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bcrypt-pbkdf"."^1.0.0" =
    self.by-version."bcrypt-pbkdf"."1.0.1";
  by-version."bcrypt-pbkdf"."1.0.1" = self.buildNodePackage {
    name = "bcrypt-pbkdf-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bcrypt-pbkdf/-/bcrypt-pbkdf-1.0.1.tgz";
      name = "bcrypt-pbkdf-1.0.1.tgz";
      sha1 = "63bc5dcb61331b92bc05fd528953c33462a06f8d";
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
      "readable-stream-2.2.6" = self.by-version."readable-stream"."2.2.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."body-parser"."^1.16.0" =
    self.by-version."body-parser"."1.17.1";
  by-version."body-parser"."1.17.1" = self.buildNodePackage {
    name = "body-parser-1.17.1";
    version = "1.17.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/body-parser/-/body-parser-1.17.1.tgz";
      name = "body-parser-1.17.1.tgz";
      sha1 = "75b3bc98ddd6e7e0d8ffe750dfaca5c66993fa47";
    };
    deps = {
      "bytes-2.4.0" = self.by-version."bytes"."2.4.0";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "http-errors-1.6.1" = self.by-version."http-errors"."1.6.1";
      "iconv-lite-0.4.15" = self.by-version."iconv-lite"."0.4.15";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "qs-6.4.0" = self.by-version."qs"."6.4.0";
      "raw-body-2.2.0" = self.by-version."raw-body"."2.2.0";
      "type-is-1.6.14" = self.by-version."type-is"."1.6.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "body-parser" = self.by-version."body-parser"."1.17.1";
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
  by-spec."bufferutil"."^2.0.0" =
    self.by-version."bufferutil"."2.0.1";
  by-version."bufferutil"."2.0.1" = self.buildNodePackage {
    name = "bufferutil-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bufferutil/-/bufferutil-2.0.1.tgz";
      name = "bufferutil-2.0.1.tgz";
      sha1 = "8de37f5a300730c305fc3edd9f93348ee8a46288";
    };
    deps = {
      "bindings-1.2.1" = self.by-version."bindings"."1.2.1";
      "nan-2.5.1" = self.by-version."nan"."2.5.1";
      "prebuild-install-2.1.1" = self.by-version."prebuild-install"."2.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bytes"."2.4.0" =
    self.by-version."bytes"."2.4.0";
  by-version."bytes"."2.4.0" = self.buildNodePackage {
    name = "bytes-2.4.0";
    version = "2.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/bytes/-/bytes-2.4.0.tgz";
      name = "bytes-2.4.0.tgz";
      sha1 = "7d97196f9d5baf7f6935e25985549edd2a6c2339";
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
    self.by-version."camelcase"."1.2.1";
  by-version."camelcase"."1.2.1" = self.buildNodePackage {
    name = "camelcase-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/camelcase/-/camelcase-1.2.1.tgz";
      name = "camelcase-1.2.1.tgz";
      sha1 = "9bb5304d2e0b56698b2c758b08a3eaa9daa58a39";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."caseless"."~0.12.0" =
    self.by-version."caseless"."0.12.0";
  by-version."caseless"."0.12.0" = self.buildNodePackage {
    name = "caseless-0.12.0";
    version = "0.12.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/caseless/-/caseless-0.12.0.tgz";
      name = "caseless-0.12.0.tgz";
      sha1 = "1b681c21ff84033c826543090689420d187151dc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."center-align"."^0.1.1" =
    self.by-version."center-align"."0.1.3";
  by-version."center-align"."0.1.3" = self.buildNodePackage {
    name = "center-align-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/center-align/-/center-align-0.1.3.tgz";
      name = "center-align-0.1.3.tgz";
      sha1 = "aa0d32629b6ee972200411cbd4461c907bc2b7ad";
    };
    deps = {
      "align-text-0.1.4" = self.by-version."align-text"."0.1.4";
      "lazy-cache-1.0.4" = self.by-version."lazy-cache"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."character-parser"."^2.1.1" =
    self.by-version."character-parser"."2.2.0";
  by-version."character-parser"."2.2.0" = self.buildNodePackage {
    name = "character-parser-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/character-parser/-/character-parser-2.2.0.tgz";
      name = "character-parser-2.2.0.tgz";
      sha1 = "c7ce28f36d4bcd9744e5ffc2c5fcde1c73261fc0";
    };
    deps = {
      "is-regex-1.0.4" = self.by-version."is-regex"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."chownr"."^1.0.1" =
    self.by-version."chownr"."1.0.1";
  by-version."chownr"."1.0.1" = self.buildNodePackage {
    name = "chownr-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/chownr/-/chownr-1.0.1.tgz";
      name = "chownr-1.0.1.tgz";
      sha1 = "e2a75042a9551908bebd25b8523d5f9769d79181";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."clean-css"."^3.3.0" =
    self.by-version."clean-css"."3.4.25";
  by-version."clean-css"."3.4.25" = self.buildNodePackage {
    name = "clean-css-3.4.25";
    version = "3.4.25";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/clean-css/-/clean-css-3.4.25.tgz";
      name = "clean-css-3.4.25.tgz";
      sha1 = "9e9a52d5c1e6bc5123e1b2783fa65fe958946ede";
    };
    deps = {
      "commander-2.8.1" = self.by-version."commander"."2.8.1";
      "source-map-0.4.4" = self.by-version."source-map"."0.4.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cliui"."^2.1.0" =
    self.by-version."cliui"."2.1.0";
  by-version."cliui"."2.1.0" = self.buildNodePackage {
    name = "cliui-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cliui/-/cliui-2.1.0.tgz";
      name = "cliui-2.1.0.tgz";
      sha1 = "4b475760ff80264c762c3a1719032e91c7fea0d1";
    };
    deps = {
      "center-align-0.1.3" = self.by-version."center-align"."0.1.3";
      "right-align-0.1.3" = self.by-version."right-align"."0.1.3";
      "wordwrap-0.0.2" = self.by-version."wordwrap"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."co"."^4.6.0" =
    self.by-version."co"."4.6.0";
  by-version."co"."4.6.0" = self.buildNodePackage {
    name = "co-4.6.0";
    version = "4.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/co/-/co-4.6.0.tgz";
      name = "co-4.6.0.tgz";
      sha1 = "6ea6bdf3d853ae54ccb8e47bfa0bf3f9031fb184";
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
  by-spec."commander"."2.8.x" =
    self.by-version."commander"."2.8.1";
  by-version."commander"."2.8.1" = self.buildNodePackage {
    name = "commander-2.8.1";
    version = "2.8.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/commander/-/commander-2.8.1.tgz";
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
  by-spec."commander"."^2.9.0" =
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
  "commander" = self.by-version."commander"."2.9.0";
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
  by-spec."constantinople"."^3.0.1" =
    self.by-version."constantinople"."3.1.0";
  by-version."constantinople"."3.1.0" = self.buildNodePackage {
    name = "constantinople-3.1.0";
    version = "3.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/constantinople/-/constantinople-3.1.0.tgz";
      name = "constantinople-3.1.0.tgz";
      sha1 = "7569caa8aa3f8d5935d62e1fa96f9f702cd81c79";
    };
    deps = {
      "acorn-3.3.0" = self.by-version."acorn"."3.3.0";
      "is-expression-2.1.0" = self.by-version."is-expression"."2.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-disposition"."0.5.2" =
    self.by-version."content-disposition"."0.5.2";
  by-version."content-disposition"."0.5.2" = self.buildNodePackage {
    name = "content-disposition-0.5.2";
    version = "0.5.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/content-disposition/-/content-disposition-0.5.2.tgz";
      name = "content-disposition-0.5.2.tgz";
      sha1 = "0cf68bb9ddf5f2be7961c3a85178cb85dba78cb4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."content-type"."~1.0.2" =
    self.by-version."content-type"."1.0.2";
  by-version."content-type"."1.0.2" = self.buildNodePackage {
    name = "content-type-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/content-type/-/content-type-1.0.2.tgz";
      name = "content-type-1.0.2.tgz";
      sha1 = "b7d113aee7a8dd27bd21133c4dc2529df1721eed";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie"."0.3.1" =
    self.by-version."cookie"."0.3.1";
  by-version."cookie"."0.3.1" = self.buildNodePackage {
    name = "cookie-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookie/-/cookie-0.3.1.tgz";
      name = "cookie-0.3.1.tgz";
      sha1 = "e7e0a1f9ef43b4c8ba925c5c5a96e806d16873bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cookie-parser"."~1.4.3" =
    self.by-version."cookie-parser"."1.4.3";
  by-version."cookie-parser"."1.4.3" = self.buildNodePackage {
    name = "cookie-parser-1.4.3";
    version = "1.4.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookie-parser/-/cookie-parser-1.4.3.tgz";
      name = "cookie-parser-1.4.3.tgz";
      sha1 = "0fe31fa19d000b95f4aadf1f53fdc2b8a203baa5";
    };
    deps = {
      "cookie-0.3.1" = self.by-version."cookie"."0.3.1";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "cookie-parser" = self.by-version."cookie-parser"."1.4.3";
  by-spec."cookie-signature"."1.0.6" =
    self.by-version."cookie-signature"."1.0.6";
  by-version."cookie-signature"."1.0.6" = self.buildNodePackage {
    name = "cookie-signature-1.0.6";
    version = "1.0.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/cookie-signature/-/cookie-signature-1.0.6.tgz";
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
  by-spec."debug"."2.6.1" =
    self.by-version."debug"."2.6.1";
  by-version."debug"."2.6.1" = self.buildNodePackage {
    name = "debug-2.6.1";
    version = "2.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.6.1.tgz";
      name = "debug-2.6.1.tgz";
      sha1 = "79855090ba2c4e3115cc7d8769491d58f0491351";
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
  by-spec."debug"."2.6.3" =
    self.by-version."debug"."2.6.3";
  by-version."debug"."2.6.3" = self.buildNodePackage {
    name = "debug-2.6.3";
    version = "2.6.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/debug/-/debug-2.6.3.tgz";
      name = "debug-2.6.3.tgz";
      sha1 = "0f7eb8c30965ec08c72accfa0130c8b79984141d";
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
  by-spec."debug"."^2.6.0" =
    self.by-version."debug"."2.6.3";
  by-spec."debug"."^2.6.1" =
    self.by-version."debug"."2.6.3";
  by-spec."decamelize"."^1.0.0" =
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
  by-spec."deep-extend"."~0.4.0" =
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
  by-spec."depd"."1.1.0" =
    self.by-version."depd"."1.1.0";
  by-version."depd"."1.1.0" = self.buildNodePackage {
    name = "depd-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/depd/-/depd-1.1.0.tgz";
      name = "depd-1.1.0.tgz";
      sha1 = "e1bd82c6aab6ced965b97b88b17ed3e528ca18c3";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."depd"."~1.1.0" =
    self.by-version."depd"."1.1.0";
  by-spec."destroy"."~1.0.4" =
    self.by-version."destroy"."1.0.4";
  by-version."destroy"."1.0.4" = self.buildNodePackage {
    name = "destroy-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/destroy/-/destroy-1.0.4.tgz";
      name = "destroy-1.0.4.tgz";
      sha1 = "978857442c44749e4206613e37946205826abd80";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."doctypes"."^1.1.0" =
    self.by-version."doctypes"."1.1.0";
  by-version."doctypes"."1.1.0" = self.buildNodePackage {
    name = "doctypes-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/doctypes/-/doctypes-1.1.0.tgz";
      name = "doctypes-1.1.0.tgz";
      sha1 = "ea80b106a87538774e8a3a4a5afe293de489e0a9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
      "jsbn-0.1.1" = self.by-version."jsbn"."0.1.1";
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
      url = "https://registry.npmjs.org/ee-first/-/ee-first-1.1.1.tgz";
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
  by-spec."encodeurl"."~1.0.1" =
    self.by-version."encodeurl"."1.0.1";
  by-version."encodeurl"."1.0.1" = self.buildNodePackage {
    name = "encodeurl-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/encodeurl/-/encodeurl-1.0.1.tgz";
      name = "encodeurl-1.0.1.tgz";
      sha1 = "79e3d58655346909fe6f0f45a5de68103b294d20";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."^1.0.0" =
    self.by-version."end-of-stream"."1.4.0";
  by-version."end-of-stream"."1.4.0" = self.buildNodePackage {
    name = "end-of-stream-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/end-of-stream/-/end-of-stream-1.4.0.tgz";
      name = "end-of-stream-1.4.0.tgz";
      sha1 = "7a90d833efda6cfa6eac0f4949dbb0fad3a63206";
    };
    deps = {
      "once-1.4.0" = self.by-version."once"."1.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."^1.1.0" =
    self.by-version."end-of-stream"."1.4.0";
  by-spec."errno"."^0.1.1" =
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
  by-spec."escape-html"."~1.0.3" =
    self.by-version."escape-html"."1.0.3";
  by-version."escape-html"."1.0.3" = self.buildNodePackage {
    name = "escape-html-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/escape-html/-/escape-html-1.0.3.tgz";
      name = "escape-html-1.0.3.tgz";
      sha1 = "0258eae4d3d0c0974de1c169188ef0051d1d1988";
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
      url = "https://registry.npmjs.org/etag/-/etag-1.7.0.tgz";
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
  by-spec."etag"."~1.8.0" =
    self.by-version."etag"."1.8.0";
  by-version."etag"."1.8.0" = self.buildNodePackage {
    name = "etag-1.8.0";
    version = "1.8.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/etag/-/etag-1.8.0.tgz";
      name = "etag-1.8.0.tgz";
      sha1 = "6f631aef336d6c46362b51764044ce216be3c051";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."eventemitter2"."^3.0.0" =
    self.by-version."eventemitter2"."3.0.2";
  by-version."eventemitter2"."3.0.2" = self.buildNodePackage {
    name = "eventemitter2-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/eventemitter2/-/eventemitter2-3.0.2.tgz";
      name = "eventemitter2-3.0.2.tgz";
      sha1 = "81c0edb739ffa64fb9f21bbcb1d2b419a5133512";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."expand-template"."^1.0.2" =
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
  by-spec."express"."^4.14.1" =
    self.by-version."express"."4.15.2";
  by-version."express"."4.15.2" = self.buildNodePackage {
    name = "express-4.15.2";
    version = "4.15.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/express/-/express-4.15.2.tgz";
      name = "express-4.15.2.tgz";
      sha1 = "af107fc148504457f2dca9a6f2571d7129b97b35";
    };
    deps = {
      "accepts-1.3.3" = self.by-version."accepts"."1.3.3";
      "array-flatten-1.1.1" = self.by-version."array-flatten"."1.1.1";
      "content-disposition-0.5.2" = self.by-version."content-disposition"."0.5.2";
      "content-type-1.0.2" = self.by-version."content-type"."1.0.2";
      "cookie-0.3.1" = self.by-version."cookie"."0.3.1";
      "cookie-signature-1.0.6" = self.by-version."cookie-signature"."1.0.6";
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.8.0" = self.by-version."etag"."1.8.0";
      "finalhandler-1.0.1" = self.by-version."finalhandler"."1.0.1";
      "fresh-0.5.0" = self.by-version."fresh"."0.5.0";
      "merge-descriptors-1.0.1" = self.by-version."merge-descriptors"."1.0.1";
      "methods-1.1.2" = self.by-version."methods"."1.1.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "path-to-regexp-0.1.7" = self.by-version."path-to-regexp"."0.1.7";
      "proxy-addr-1.1.3" = self.by-version."proxy-addr"."1.1.3";
      "qs-6.4.0" = self.by-version."qs"."6.4.0";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "send-0.15.1" = self.by-version."send"."0.15.1";
      "serve-static-1.12.1" = self.by-version."serve-static"."1.12.1";
      "setprototypeof-1.0.3" = self.by-version."setprototypeof"."1.0.3";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
      "type-is-1.6.14" = self.by-version."type-is"."1.6.14";
      "utils-merge-1.0.0" = self.by-version."utils-merge"."1.0.0";
      "vary-1.1.1" = self.by-version."vary"."1.1.1";
      "pug-2.0.0-beta9" = self.by-version."pug"."2.0.0-beta9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "express" = self.by-version."express"."4.15.2";
  by-spec."extend"."~3.0.0" =
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
  by-spec."finalhandler"."~1.0.0" =
    self.by-version."finalhandler"."1.0.1";
  by-version."finalhandler"."1.0.1" = self.buildNodePackage {
    name = "finalhandler-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/finalhandler/-/finalhandler-1.0.1.tgz";
      name = "finalhandler-1.0.1.tgz";
      sha1 = "bcd15d1689c0e5ed729b6f7f541a6df984117db8";
    };
    deps = {
      "debug-2.6.3" = self.by-version."debug"."2.6.3";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
      "unpipe-1.0.0" = self.by-version."unpipe"."1.0.0";
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
      "mime-types-2.1.14" = self.by-version."mime-types"."2.1.14";
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
      url = "https://registry.npmjs.org/forwarded/-/forwarded-0.1.0.tgz";
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
      url = "https://registry.npmjs.org/fresh/-/fresh-0.3.0.tgz";
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
  by-spec."fresh"."0.5.0" =
    self.by-version."fresh"."0.5.0";
  by-version."fresh"."0.5.0" = self.buildNodePackage {
    name = "fresh-0.5.0";
    version = "0.5.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/fresh/-/fresh-0.5.0.tgz";
      name = "fresh-0.5.0.tgz";
      sha1 = "f474ca5e6a9246d6fd8e0953cfa9b9c805afa78e";
    };
    deps = {
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
  by-spec."gauge"."~2.7.1" =
    self.by-version."gauge"."2.7.3";
  by-version."gauge"."2.7.3" = self.buildNodePackage {
    name = "gauge-2.7.3";
    version = "2.7.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/gauge/-/gauge-2.7.3.tgz";
      name = "gauge-2.7.3.tgz";
      sha1 = "1c23855f962f17b3ad3d0dc7443f304542edfe09";
    };
    deps = {
      "aproba-1.1.1" = self.by-version."aproba"."1.1.1";
      "console-control-strings-1.1.0" = self.by-version."console-control-strings"."1.1.0";
      "has-unicode-2.0.1" = self.by-version."has-unicode"."2.0.1";
      "object-assign-4.1.1" = self.by-version."object-assign"."4.1.1";
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
  by-spec."har-schema"."^1.0.5" =
    self.by-version."har-schema"."1.0.5";
  by-version."har-schema"."1.0.5" = self.buildNodePackage {
    name = "har-schema-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/har-schema/-/har-schema-1.0.5.tgz";
      name = "har-schema-1.0.5.tgz";
      sha1 = "d263135f43307c02c602afc8fe95970c0151369e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."har-validator"."~4.2.1" =
    self.by-version."har-validator"."4.2.1";
  by-version."har-validator"."4.2.1" = self.buildNodePackage {
    name = "har-validator-4.2.1";
    version = "4.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/har-validator/-/har-validator-4.2.1.tgz";
      name = "har-validator-4.2.1.tgz";
      sha1 = "33481d0f1bbff600dd203d75812a6a5fba002e2a";
    };
    deps = {
      "ajv-4.11.5" = self.by-version."ajv"."4.11.5";
      "har-schema-1.0.5" = self.by-version."har-schema"."1.0.5";
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
  by-spec."http-errors"."~1.6.1" =
    self.by-version."http-errors"."1.6.1";
  by-version."http-errors"."1.6.1" = self.buildNodePackage {
    name = "http-errors-1.6.1";
    version = "1.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/http-errors/-/http-errors-1.6.1.tgz";
      name = "http-errors-1.6.1.tgz";
      sha1 = "5f8b8ed98aca545656bf572997387f904a722257";
    };
    deps = {
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "inherits-2.0.3" = self.by-version."inherits"."2.0.3";
      "setprototypeof-1.0.3" = self.by-version."setprototypeof"."1.0.3";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
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
      "jsprim-1.4.0" = self.by-version."jsprim"."1.4.0";
      "sshpk-1.11.0" = self.by-version."sshpk"."1.11.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."iconv-lite"."0.4.15" =
    self.by-version."iconv-lite"."0.4.15";
  by-version."iconv-lite"."0.4.15" = self.buildNodePackage {
    name = "iconv-lite-0.4.15";
    version = "0.4.15";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/iconv-lite/-/iconv-lite-0.4.15.tgz";
      name = "iconv-lite-0.4.15.tgz";
      sha1 = "fe265a218ac6a57cfe854927e9d04c19825eddeb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."image-size"."~0.5.0" =
    self.by-version."image-size"."0.5.1";
  by-version."image-size"."0.5.1" = self.buildNodePackage {
    name = "image-size-0.5.1";
    version = "0.5.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/image-size/-/image-size-0.5.1.tgz";
      name = "image-size-0.5.1.tgz";
      sha1 = "28eea8548a4b1443480ddddc1e083ae54652439f";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inherits"."2.0.3" =
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
  by-spec."int64-buffer"."^0.1.9" =
    self.by-version."int64-buffer"."0.1.9";
  by-version."int64-buffer"."0.1.9" = self.buildNodePackage {
    name = "int64-buffer-0.1.9";
    version = "0.1.9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/int64-buffer/-/int64-buffer-0.1.9.tgz";
      name = "int64-buffer-0.1.9.tgz";
      sha1 = "9e039da043b24f78b196b283e04653ef5e990f61";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."ipaddr.js"."1.2.0" =
    self.by-version."ipaddr.js"."1.2.0";
  by-version."ipaddr.js"."1.2.0" = self.buildNodePackage {
    name = "ipaddr.js-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ipaddr.js/-/ipaddr.js-1.2.0.tgz";
      name = "ipaddr.js-1.2.0.tgz";
      sha1 = "8aba49c9192799585bdd643e0ccb50e8ae777ba4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is"."^3.1.0" =
    self.by-version."is"."3.2.1";
  by-version."is"."3.2.1" = self.buildNodePackage {
    name = "is-3.2.1";
    version = "3.2.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is/-/is-3.2.1.tgz";
      name = "is-3.2.1.tgz";
      sha1 = "d0ac2ad55eb7b0bec926a5266f6c662aaa83dca5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-buffer"."^1.0.2" =
    self.by-version."is-buffer"."1.1.5";
  by-version."is-buffer"."1.1.5" = self.buildNodePackage {
    name = "is-buffer-1.1.5";
    version = "1.1.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-buffer/-/is-buffer-1.1.5.tgz";
      name = "is-buffer-1.1.5.tgz";
      sha1 = "1f3b26ef613b214b88cbca23cc6c01d87961eecc";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-expression"."^2.0.1" =
    self.by-version."is-expression"."2.1.0";
  by-version."is-expression"."2.1.0" = self.buildNodePackage {
    name = "is-expression-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-expression/-/is-expression-2.1.0.tgz";
      name = "is-expression-2.1.0.tgz";
      sha1 = "91be9d47debcfef077977e9722be6dcfb4465ef0";
    };
    deps = {
      "acorn-3.3.0" = self.by-version."acorn"."3.3.0";
      "object-assign-4.1.1" = self.by-version."object-assign"."4.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-expression"."^3.0.0" =
    self.by-version."is-expression"."3.0.0";
  by-version."is-expression"."3.0.0" = self.buildNodePackage {
    name = "is-expression-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-expression/-/is-expression-3.0.0.tgz";
      name = "is-expression-3.0.0.tgz";
      sha1 = "39acaa6be7fd1f3471dc42c7416e61c24317ac9f";
    };
    deps = {
      "acorn-4.0.11" = self.by-version."acorn"."4.0.11";
      "object-assign-4.1.1" = self.by-version."object-assign"."4.1.1";
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
  by-spec."is-promise"."^2.0.0" =
    self.by-version."is-promise"."2.1.0";
  by-version."is-promise"."2.1.0" = self.buildNodePackage {
    name = "is-promise-2.1.0";
    version = "2.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-promise/-/is-promise-2.1.0.tgz";
      name = "is-promise-2.1.0.tgz";
      sha1 = "79a2a9ece7f096e80f36d2b2f3bc16c1ff4bf3fa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-regex"."^1.0.3" =
    self.by-version."is-regex"."1.0.4";
  by-version."is-regex"."1.0.4" = self.buildNodePackage {
    name = "is-regex-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/is-regex/-/is-regex-1.0.4.tgz";
      name = "is-regex-1.0.4.tgz";
      sha1 = "5517489b547091b0930e095654ced25ee97e9491";
    };
    deps = {
      "has-1.0.1" = self.by-version."has"."1.0.1";
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
  by-spec."isarray"."~1.0.0" =
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
      "jsbn-0.1.1" = self.by-version."jsbn"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."js-stringify"."^1.0.1" =
    self.by-version."js-stringify"."1.0.2";
  by-version."js-stringify"."1.0.2" = self.buildNodePackage {
    name = "js-stringify-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/js-stringify/-/js-stringify-1.0.2.tgz";
      name = "js-stringify-1.0.2.tgz";
      sha1 = "1736fddfd9724f28a3682adc6230ae7e4e9679db";
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
    self.by-version."jsbn"."0.1.1";
  by-version."jsbn"."0.1.1" = self.buildNodePackage {
    name = "jsbn-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsbn/-/jsbn-0.1.1.tgz";
      name = "jsbn-0.1.1.tgz";
      sha1 = "a5e654c2e5a2deb5f201d96cefbca80c0ef2f513";
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
  by-spec."json-stable-stringify"."^1.0.1" =
    self.by-version."json-stable-stringify"."1.0.1";
  by-version."json-stable-stringify"."1.0.1" = self.buildNodePackage {
    name = "json-stable-stringify-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/json-stable-stringify/-/json-stable-stringify-1.0.1.tgz";
      name = "json-stable-stringify-1.0.1.tgz";
      sha1 = "9a759d39c5f2ff503fd5300646ed445f88c4f9af";
    };
    deps = {
      "jsonify-0.0.0" = self.by-version."jsonify"."0.0.0";
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
  by-spec."jsonify"."~0.0.0" =
    self.by-version."jsonify"."0.0.0";
  by-version."jsonify"."0.0.0" = self.buildNodePackage {
    name = "jsonify-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz";
      name = "jsonify-0.0.0.tgz";
      sha1 = "2c74b6ee41d93ca51b7b5aaee8f503631d252a73";
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
    self.by-version."jsprim"."1.4.0";
  by-version."jsprim"."1.4.0" = self.buildNodePackage {
    name = "jsprim-1.4.0";
    version = "1.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jsprim/-/jsprim-1.4.0.tgz";
      name = "jsprim-1.4.0.tgz";
      sha1 = "a3b87e40298d8c380552d8cc7628a0bb95a22918";
    };
    deps = {
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
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
  by-spec."jstransformer"."1.0.0" =
    self.by-version."jstransformer"."1.0.0";
  by-version."jstransformer"."1.0.0" = self.buildNodePackage {
    name = "jstransformer-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/jstransformer/-/jstransformer-1.0.0.tgz";
      name = "jstransformer-1.0.0.tgz";
      sha1 = "ed8bf0921e2f3f1ed4d5c1a44f68709ed24722c3";
    };
    deps = {
      "is-promise-2.1.0" = self.by-version."is-promise"."2.1.0";
      "promise-7.1.1" = self.by-version."promise"."7.1.1";
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
      "is-buffer-1.1.5" = self.by-version."is-buffer"."1.1.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lazy-cache"."^1.0.3" =
    self.by-version."lazy-cache"."1.0.4";
  by-version."lazy-cache"."1.0.4" = self.buildNodePackage {
    name = "lazy-cache-1.0.4";
    version = "1.0.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/lazy-cache/-/lazy-cache-1.0.4.tgz";
      name = "lazy-cache-1.0.4.tgz";
      sha1 = "a1d78fc3a50474cb80845d3b3b6e1da49a446e8e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."less"."^2.7.2" =
    self.by-version."less"."2.7.2";
  by-version."less"."2.7.2" = self.buildNodePackage {
    name = "less-2.7.2";
    version = "2.7.2";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/less/-/less-2.7.2.tgz";
      name = "less-2.7.2.tgz";
      sha1 = "368d6cc73e1fb03981183280918743c5dcf9b3df";
    };
    deps = {
    };
    optionalDependencies = {
      "errno-0.1.4" = self.by-version."errno"."0.1.4";
      "graceful-fs-4.1.11" = self.by-version."graceful-fs"."4.1.11";
      "image-size-0.5.1" = self.by-version."image-size"."0.5.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "promise-7.1.1" = self.by-version."promise"."7.1.1";
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
      "request-2.81.0" = self.by-version."request"."2.81.0";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "less" = self.by-version."less"."2.7.2";
  by-spec."less"."~2.7.1" =
    self.by-version."less"."2.7.2";
  by-spec."less-middleware"."^2.2.0" =
    self.by-version."less-middleware"."2.2.0";
  by-version."less-middleware"."2.2.0" = self.buildNodePackage {
    name = "less-middleware-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/less-middleware/-/less-middleware-2.2.0.tgz";
      name = "less-middleware-2.2.0.tgz";
      sha1 = "c3e4d512c8403685204add7bdaad7398c535c674";
    };
    deps = {
      "less-2.7.2" = self.by-version."less"."2.7.2";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "node.extend-1.1.6" = self.by-version."node.extend"."1.1.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "less-middleware" = self.by-version."less-middleware"."2.2.0";
  by-spec."libquassel"."~2.1.7" =
    self.by-version."libquassel"."2.1.7";
  by-version."libquassel"."2.1.7" = self.buildNodePackage {
    name = "libquassel-2.1.7";
    version = "2.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/libquassel/-/libquassel-2.1.7.tgz";
      name = "libquassel-2.1.7.tgz";
      sha1 = "5bc12cda1efeb9199995ae98f906ee8660927175";
    };
    deps = {
      "debug-2.6.3" = self.by-version."debug"."2.6.3";
      "eventemitter2-3.0.2" = self.by-version."eventemitter2"."3.0.2";
      "net-browserify-alt-1.1.0" = self.by-version."net-browserify-alt"."1.1.0";
      "qtdatastream-0.7.1" = self.by-version."qtdatastream"."0.7.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "libquassel" = self.by-version."libquassel"."2.1.7";
  by-spec."longest"."^1.0.1" =
    self.by-version."longest"."1.0.1";
  by-version."longest"."1.0.1" = self.buildNodePackage {
    name = "longest-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/longest/-/longest-1.0.1.tgz";
      name = "longest-1.0.1.tgz";
      sha1 = "30a0b2da38f73770e8294a0d22e6625ed77d0097";
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
      url = "https://registry.npmjs.org/media-typer/-/media-typer-0.3.0.tgz";
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
  by-spec."merge-descriptors"."1.0.1" =
    self.by-version."merge-descriptors"."1.0.1";
  by-version."merge-descriptors"."1.0.1" = self.buildNodePackage {
    name = "merge-descriptors-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/merge-descriptors/-/merge-descriptors-1.0.1.tgz";
      name = "merge-descriptors-1.0.1.tgz";
      sha1 = "b00aaa556dd8b44568150ec9d1b953f3f90cbb61";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."methods"."~1.1.2" =
    self.by-version."methods"."1.1.2";
  by-version."methods"."1.1.2" = self.buildNodePackage {
    name = "methods-1.1.2";
    version = "1.1.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/methods/-/methods-1.1.2.tgz";
      name = "methods-1.1.2.tgz";
      sha1 = "5529a4d67654134edcc5266656835b0f851afcee";
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
      url = "https://registry.npmjs.org/mime/-/mime-1.3.4.tgz";
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
  by-spec."mime-db"."~1.26.0" =
    self.by-version."mime-db"."1.26.0";
  by-version."mime-db"."1.26.0" = self.buildNodePackage {
    name = "mime-db-1.26.0";
    version = "1.26.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-db/-/mime-db-1.26.0.tgz";
      name = "mime-db-1.26.0.tgz";
      sha1 = "eaffcd0e4fc6935cf8134da246e2e6c35305adff";
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
    self.by-version."mime-types"."2.1.14";
  by-version."mime-types"."2.1.14" = self.buildNodePackage {
    name = "mime-types-2.1.14";
    version = "2.1.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/mime-types/-/mime-types-2.1.14.tgz";
      name = "mime-types-2.1.14.tgz";
      sha1 = "f7ef7d97583fcaf3b7d282b6f8b5679dab1e94ee";
    };
    deps = {
      "mime-db-1.26.0" = self.by-version."mime-db"."1.26.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime-types"."~2.1.11" =
    self.by-version."mime-types"."2.1.14";
  by-spec."mime-types"."~2.1.13" =
    self.by-version."mime-types"."2.1.14";
  by-spec."mime-types"."~2.1.7" =
    self.by-version."mime-types"."2.1.14";
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
  by-spec."minimist"."^1.2.0" =
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
  by-spec."mkdirp"."^0.5.0" =
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
  by-spec."mkdirp"."^0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.5.1" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."morgan"."^1.8.0" =
    self.by-version."morgan"."1.8.1";
  by-version."morgan"."1.8.1" = self.buildNodePackage {
    name = "morgan-1.8.1";
    version = "1.8.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/morgan/-/morgan-1.8.1.tgz";
      name = "morgan-1.8.1.tgz";
      sha1 = "f93023d3887bd27b78dfd6023cea7892ee27a4b1";
    };
    deps = {
      "basic-auth-1.1.0" = self.by-version."basic-auth"."1.1.0";
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "on-headers-1.0.1" = self.by-version."on-headers"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "morgan" = self.by-version."morgan"."1.8.1";
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
  by-spec."nan"."~2.5.0" =
    self.by-version."nan"."2.5.1";
  by-version."nan"."2.5.1" = self.buildNodePackage {
    name = "nan-2.5.1";
    version = "2.5.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/nan/-/nan-2.5.1.tgz";
      name = "nan-2.5.1.tgz";
      sha1 = "d5b01691253326a97a2bbee9e61c55d8d60351e2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."negotiator"."0.6.1" =
    self.by-version."negotiator"."0.6.1";
  by-version."negotiator"."0.6.1" = self.buildNodePackage {
    name = "negotiator-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/negotiator/-/negotiator-0.6.1.tgz";
      name = "negotiator-0.6.1.tgz";
      sha1 = "2b327184e8992101177b28563fb5e7102acd0ca9";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."net-browserify-alt"."^1.1.0" =
    self.by-version."net-browserify-alt"."1.1.0";
  by-version."net-browserify-alt"."1.1.0" = self.buildNodePackage {
    name = "net-browserify-alt-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/net-browserify-alt/-/net-browserify-alt-1.1.0.tgz";
      name = "net-browserify-alt-1.1.0.tgz";
      sha1 = "02c9ecac88437be23f5948b208a1e65d8d138a73";
    };
    deps = {
      "body-parser-1.17.1" = self.by-version."body-parser"."1.17.1";
      "bufferutil-2.0.1" = self.by-version."bufferutil"."2.0.1";
      "ws-2.2.2" = self.by-version."ws"."2.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "net-browserify-alt" = self.by-version."net-browserify-alt"."1.1.0";
  by-spec."node-abi"."^2.0.0" =
    self.by-version."node-abi"."2.0.0";
  by-version."node-abi"."2.0.0" = self.buildNodePackage {
    name = "node-abi-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/node-abi/-/node-abi-2.0.0.tgz";
      name = "node-abi-2.0.0.tgz";
      sha1 = "443bfd151b599231028ae425e592e76cd31cb537";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."node.extend"."~1.1.5" =
    self.by-version."node.extend"."1.1.6";
  by-version."node.extend"."1.1.6" = self.buildNodePackage {
    name = "node.extend-1.1.6";
    version = "1.1.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/node.extend/-/node.extend-1.1.6.tgz";
      name = "node.extend-1.1.6.tgz";
      sha1 = "a7b882c82d6c93a4863a5504bd5de8ec86258b96";
    };
    deps = {
      "is-3.2.1" = self.by-version."is"."3.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."noop-logger"."^0.1.1" =
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
  by-spec."npmlog"."^4.0.1" =
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
      "gauge-2.7.3" = self.by-version."gauge"."2.7.3";
      "set-blocking-2.0.0" = self.by-version."set-blocking"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
    self.by-version."object-assign"."4.1.1";
  by-version."object-assign"."4.1.1" = self.buildNodePackage {
    name = "object-assign-4.1.1";
    version = "4.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/object-assign/-/object-assign-4.1.1.tgz";
      name = "object-assign-4.1.1.tgz";
      sha1 = "2109adc7965887cfc05cbbd442cac8bfbb360863";
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
    self.by-version."object-assign"."4.1.1";
  by-spec."on-finished"."~2.3.0" =
    self.by-version."on-finished"."2.3.0";
  by-version."on-finished"."2.3.0" = self.buildNodePackage {
    name = "on-finished-2.3.0";
    version = "2.3.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-finished/-/on-finished-2.3.0.tgz";
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
  by-spec."on-headers"."~1.0.1" =
    self.by-version."on-headers"."1.0.1";
  by-version."on-headers"."1.0.1" = self.buildNodePackage {
    name = "on-headers-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/on-headers/-/on-headers-1.0.1.tgz";
      name = "on-headers-1.0.1.tgz";
      sha1 = "928f5d0f470d49342651ea6794b0857c100693f7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."once"."^1.3.1" =
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
  by-spec."once"."^1.4.0" =
    self.by-version."once"."1.4.0";
  by-spec."os-homedir"."^1.0.1" =
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
  by-spec."parseurl"."~1.3.1" =
    self.by-version."parseurl"."1.3.1";
  by-version."parseurl"."1.3.1" = self.buildNodePackage {
    name = "parseurl-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/parseurl/-/parseurl-1.3.1.tgz";
      name = "parseurl-1.3.1.tgz";
      sha1 = "c8ab8c9223ba34888aa64a297b28853bec18da56";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-parse"."^1.0.5" =
    self.by-version."path-parse"."1.0.5";
  by-version."path-parse"."1.0.5" = self.buildNodePackage {
    name = "path-parse-1.0.5";
    version = "1.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-parse/-/path-parse-1.0.5.tgz";
      name = "path-parse-1.0.5.tgz";
      sha1 = "3c1adf871ea9cd6c9431b6ea2bd74a0ff055c4c1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."path-to-regexp"."0.1.7" =
    self.by-version."path-to-regexp"."0.1.7";
  by-version."path-to-regexp"."0.1.7" = self.buildNodePackage {
    name = "path-to-regexp-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/path-to-regexp/-/path-to-regexp-0.1.7.tgz";
      name = "path-to-regexp-0.1.7.tgz";
      sha1 = "df604178005f522f15eb4490e7247a1bfaa67f8c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."performance-now"."^0.2.0" =
    self.by-version."performance-now"."0.2.0";
  by-version."performance-now"."0.2.0" = self.buildNodePackage {
    name = "performance-now-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/performance-now/-/performance-now-0.2.0.tgz";
      name = "performance-now-0.2.0.tgz";
      sha1 = "33ef30c5c77d4ea21c5a53869d91b56d8f2555e5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prebuild-install"."~2.1.0" =
    self.by-version."prebuild-install"."2.1.1";
  by-version."prebuild-install"."2.1.1" = self.buildNodePackage {
    name = "prebuild-install-2.1.1";
    version = "2.1.1";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/prebuild-install/-/prebuild-install-2.1.1.tgz";
      name = "prebuild-install-2.1.1.tgz";
      sha1 = "d0a77ea51b6a00f928cb71bc0ccea24f87ec171e";
    };
    deps = {
      "expand-template-1.0.3" = self.by-version."expand-template"."1.0.3";
      "github-from-package-0.0.0" = self.by-version."github-from-package"."0.0.0";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "node-abi-2.0.0" = self.by-version."node-abi"."2.0.0";
      "noop-logger-0.1.1" = self.by-version."noop-logger"."0.1.1";
      "npmlog-4.0.2" = self.by-version."npmlog"."4.0.2";
      "os-homedir-1.0.2" = self.by-version."os-homedir"."1.0.2";
      "pump-1.0.2" = self.by-version."pump"."1.0.2";
      "rc-1.1.7" = self.by-version."rc"."1.1.7";
      "simple-get-1.4.3" = self.by-version."simple-get"."1.4.3";
      "tar-fs-1.15.2" = self.by-version."tar-fs"."1.15.2";
      "tunnel-agent-0.4.3" = self.by-version."tunnel-agent"."0.4.3";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
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
  by-spec."promise"."^7.0.1" =
    self.by-version."promise"."7.1.1";
  by-version."promise"."7.1.1" = self.buildNodePackage {
    name = "promise-7.1.1";
    version = "7.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/promise/-/promise-7.1.1.tgz";
      name = "promise-7.1.1.tgz";
      sha1 = "489654c692616b8aa55b0724fa809bb7db49c5bf";
    };
    deps = {
      "asap-2.0.5" = self.by-version."asap"."2.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."promise"."^7.1.1" =
    self.by-version."promise"."7.1.1";
  by-spec."proxy-addr"."~1.1.3" =
    self.by-version."proxy-addr"."1.1.3";
  by-version."proxy-addr"."1.1.3" = self.buildNodePackage {
    name = "proxy-addr-1.1.3";
    version = "1.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/proxy-addr/-/proxy-addr-1.1.3.tgz";
      name = "proxy-addr-1.1.3.tgz";
      sha1 = "dc97502f5722e888467b3fa2297a7b1ff47df074";
    };
    deps = {
      "forwarded-0.1.0" = self.by-version."forwarded"."0.1.0";
      "ipaddr.js-1.2.0" = self.by-version."ipaddr.js"."1.2.0";
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
  by-spec."pug"."^2.0.0-beta11" =
    self.by-version."pug"."2.0.0-beta9";
  by-version."pug"."2.0.0-beta9" = self.buildNodePackage {
    name = "pug-2.0.0-beta9";
    version = "2.0.0-beta9";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug/-/pug-2.0.0-beta9.tgz";
      name = "pug-2.0.0-beta9.tgz";
      sha1 = "158ec6dbace5bb78f2b25e8825477d03ea6e14b0";
    };
    deps = {
      "pug-code-gen-1.1.1" = self.by-version."pug-code-gen"."1.1.1";
      "pug-filters-2.1.1" = self.by-version."pug-filters"."2.1.1";
      "pug-lexer-2.3.2" = self.by-version."pug-lexer"."2.3.2";
      "pug-linker-2.0.2" = self.by-version."pug-linker"."2.0.2";
      "pug-load-2.0.5" = self.by-version."pug-load"."2.0.5";
      "pug-parser-2.0.2" = self.by-version."pug-parser"."2.0.2";
      "pug-runtime-2.0.3" = self.by-version."pug-runtime"."2.0.3";
      "pug-strip-comments-1.0.2" = self.by-version."pug-strip-comments"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "pug" = self.by-version."pug"."2.0.0-beta9";
  by-spec."pug-attrs"."^2.0.2" =
    self.by-version."pug-attrs"."2.0.2";
  by-version."pug-attrs"."2.0.2" = self.buildNodePackage {
    name = "pug-attrs-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-attrs/-/pug-attrs-2.0.2.tgz";
      name = "pug-attrs-2.0.2.tgz";
      sha1 = "8be2b2225568ffa75d1b866982bff9f4111affcb";
    };
    deps = {
      "constantinople-3.1.0" = self.by-version."constantinople"."3.1.0";
      "pug-runtime-2.0.3" = self.by-version."pug-runtime"."2.0.3";
      "js-stringify-1.0.2" = self.by-version."js-stringify"."1.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-code-gen"."^1.1.1" =
    self.by-version."pug-code-gen"."1.1.1";
  by-version."pug-code-gen"."1.1.1" = self.buildNodePackage {
    name = "pug-code-gen-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-code-gen/-/pug-code-gen-1.1.1.tgz";
      name = "pug-code-gen-1.1.1.tgz";
      sha1 = "1cf72744ef2a039eae6a3340caaa1105871258e8";
    };
    deps = {
      "constantinople-3.1.0" = self.by-version."constantinople"."3.1.0";
      "doctypes-1.1.0" = self.by-version."doctypes"."1.1.0";
      "js-stringify-1.0.2" = self.by-version."js-stringify"."1.0.2";
      "pug-attrs-2.0.2" = self.by-version."pug-attrs"."2.0.2";
      "pug-error-1.3.2" = self.by-version."pug-error"."1.3.2";
      "pug-runtime-2.0.3" = self.by-version."pug-runtime"."2.0.3";
      "void-elements-2.0.1" = self.by-version."void-elements"."2.0.1";
      "with-5.1.1" = self.by-version."with"."5.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-error"."^1.3.2" =
    self.by-version."pug-error"."1.3.2";
  by-version."pug-error"."1.3.2" = self.buildNodePackage {
    name = "pug-error-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-error/-/pug-error-1.3.2.tgz";
      name = "pug-error-1.3.2.tgz";
      sha1 = "53ae7d9d29bb03cf564493a026109f54c47f5f26";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-filters"."^2.1.0" =
    self.by-version."pug-filters"."2.1.1";
  by-version."pug-filters"."2.1.1" = self.buildNodePackage {
    name = "pug-filters-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-filters/-/pug-filters-2.1.1.tgz";
      name = "pug-filters-2.1.1.tgz";
      sha1 = "10ab2b6d7e5aeec99cad28a1e4c8085f823fc754";
    };
    deps = {
      "clean-css-3.4.25" = self.by-version."clean-css"."3.4.25";
      "constantinople-3.1.0" = self.by-version."constantinople"."3.1.0";
      "pug-error-1.3.2" = self.by-version."pug-error"."1.3.2";
      "pug-walk-1.1.1" = self.by-version."pug-walk"."1.1.1";
      "jstransformer-1.0.0" = self.by-version."jstransformer"."1.0.0";
      "resolve-1.3.2" = self.by-version."resolve"."1.3.2";
      "uglify-js-2.8.15" = self.by-version."uglify-js"."2.8.15";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-lexer"."^2.3.1" =
    self.by-version."pug-lexer"."2.3.2";
  by-version."pug-lexer"."2.3.2" = self.buildNodePackage {
    name = "pug-lexer-2.3.2";
    version = "2.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-lexer/-/pug-lexer-2.3.2.tgz";
      name = "pug-lexer-2.3.2.tgz";
      sha1 = "68b19d96ea5dc0e4a86148b01cb966c17815a614";
    };
    deps = {
      "character-parser-2.2.0" = self.by-version."character-parser"."2.2.0";
      "is-expression-3.0.0" = self.by-version."is-expression"."3.0.0";
      "pug-error-1.3.2" = self.by-version."pug-error"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-linker"."^2.0.1" =
    self.by-version."pug-linker"."2.0.2";
  by-version."pug-linker"."2.0.2" = self.buildNodePackage {
    name = "pug-linker-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-linker/-/pug-linker-2.0.2.tgz";
      name = "pug-linker-2.0.2.tgz";
      sha1 = "1deca67d741fab46b028c1366f178fbaee620233";
    };
    deps = {
      "pug-error-1.3.2" = self.by-version."pug-error"."1.3.2";
      "pug-walk-1.1.1" = self.by-version."pug-walk"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-load"."^2.0.4" =
    self.by-version."pug-load"."2.0.5";
  by-version."pug-load"."2.0.5" = self.buildNodePackage {
    name = "pug-load-2.0.5";
    version = "2.0.5";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-load/-/pug-load-2.0.5.tgz";
      name = "pug-load-2.0.5.tgz";
      sha1 = "eaaf46ccace8aff7461e0fad1e2b67305514f2c6";
    };
    deps = {
      "object-assign-4.1.1" = self.by-version."object-assign"."4.1.1";
      "pug-walk-1.1.1" = self.by-version."pug-walk"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-parser"."^2.0.2" =
    self.by-version."pug-parser"."2.0.2";
  by-version."pug-parser"."2.0.2" = self.buildNodePackage {
    name = "pug-parser-2.0.2";
    version = "2.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-parser/-/pug-parser-2.0.2.tgz";
      name = "pug-parser-2.0.2.tgz";
      sha1 = "53a680cfd05039dcb0c27d029094bc4a792689b0";
    };
    deps = {
      "pug-error-1.3.2" = self.by-version."pug-error"."1.3.2";
      "token-stream-0.0.1" = self.by-version."token-stream"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-runtime"."^2.0.3" =
    self.by-version."pug-runtime"."2.0.3";
  by-version."pug-runtime"."2.0.3" = self.buildNodePackage {
    name = "pug-runtime-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-runtime/-/pug-runtime-2.0.3.tgz";
      name = "pug-runtime-2.0.3.tgz";
      sha1 = "98162607b0fce9e254d427f33987a5aee7168bda";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-strip-comments"."^1.0.2" =
    self.by-version."pug-strip-comments"."1.0.2";
  by-version."pug-strip-comments"."1.0.2" = self.buildNodePackage {
    name = "pug-strip-comments-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-strip-comments/-/pug-strip-comments-1.0.2.tgz";
      name = "pug-strip-comments-1.0.2.tgz";
      sha1 = "d313afa01bcc374980e1399e23ebf2eb9bdc8513";
    };
    deps = {
      "pug-error-1.3.2" = self.by-version."pug-error"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pug-walk"."^1.1.1" =
    self.by-version."pug-walk"."1.1.1";
  by-version."pug-walk"."1.1.1" = self.buildNodePackage {
    name = "pug-walk-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/pug-walk/-/pug-walk-1.1.1.tgz";
      name = "pug-walk-1.1.1.tgz";
      sha1 = "b9976240d213692e6993fbc13ae1205c54052efe";
    };
    deps = {
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
      "end-of-stream-1.4.0" = self.by-version."end-of-stream"."1.4.0";
      "once-1.4.0" = self.by-version."once"."1.4.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pump"."^1.0.1" =
    self.by-version."pump"."1.0.2";
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
  by-spec."qs"."6.4.0" =
    self.by-version."qs"."6.4.0";
  by-version."qs"."6.4.0" = self.buildNodePackage {
    name = "qs-6.4.0";
    version = "6.4.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qs/-/qs-6.4.0.tgz";
      name = "qs-6.4.0.tgz";
      sha1 = "13e26d28ad6b0ffaa91312cd3bf708ed351e7233";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."qs"."~6.4.0" =
    self.by-version."qs"."6.4.0";
  by-spec."qtdatastream"."^0.7.1" =
    self.by-version."qtdatastream"."0.7.1";
  by-version."qtdatastream"."0.7.1" = self.buildNodePackage {
    name = "qtdatastream-0.7.1";
    version = "0.7.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/qtdatastream/-/qtdatastream-0.7.1.tgz";
      name = "qtdatastream-0.7.1.tgz";
      sha1 = "8085d390b4c19f7b02dee8a7cd873e2af58667b5";
    };
    deps = {
      "debug-2.6.3" = self.by-version."debug"."2.6.3";
      "int64-buffer-0.1.9" = self.by-version."int64-buffer"."0.1.9";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."range-parser"."~1.2.0" =
    self.by-version."range-parser"."1.2.0";
  by-version."range-parser"."1.2.0" = self.buildNodePackage {
    name = "range-parser-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/range-parser/-/range-parser-1.2.0.tgz";
      name = "range-parser-1.2.0.tgz";
      sha1 = "f49be6b487894ddc40dcc94a322f611092e00d5e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."raw-body"."~2.2.0" =
    self.by-version."raw-body"."2.2.0";
  by-version."raw-body"."2.2.0" = self.buildNodePackage {
    name = "raw-body-2.2.0";
    version = "2.2.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/raw-body/-/raw-body-2.2.0.tgz";
      name = "raw-body-2.2.0.tgz";
      sha1 = "994976cf6a5096a41162840492f0bdc5d6e7fb96";
    };
    deps = {
      "bytes-2.4.0" = self.by-version."bytes"."2.4.0";
      "iconv-lite-0.4.15" = self.by-version."iconv-lite"."0.4.15";
      "unpipe-1.0.0" = self.by-version."unpipe"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rc"."^1.1.6" =
    self.by-version."rc"."1.1.7";
  by-version."rc"."1.1.7" = self.buildNodePackage {
    name = "rc-1.1.7";
    version = "1.1.7";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/rc/-/rc-1.1.7.tgz";
      name = "rc-1.1.7.tgz";
      sha1 = "c5ea564bb07aff9fd3a5b32e906c1d3a65940fea";
    };
    deps = {
      "deep-extend-0.4.1" = self.by-version."deep-extend"."0.4.1";
      "ini-1.3.4" = self.by-version."ini"."1.3.4";
      "minimist-1.2.0" = self.by-version."minimist"."1.2.0";
      "strip-json-comments-2.0.1" = self.by-version."strip-json-comments"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^2.0.0" =
    self.by-version."readable-stream"."2.2.6";
  by-version."readable-stream"."2.2.6" = self.buildNodePackage {
    name = "readable-stream-2.2.6";
    version = "2.2.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/readable-stream/-/readable-stream-2.2.6.tgz";
      name = "readable-stream-2.2.6.tgz";
      sha1 = "8b43aed76e71483938d12a8d46c6cf1a00b1f816";
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
    self.by-version."readable-stream"."2.2.6";
  by-spec."readable-stream"."^2.0.5" =
    self.by-version."readable-stream"."2.2.6";
  by-spec."repeat-string"."^1.5.2" =
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
  by-spec."request"."^2.72.0" =
    self.by-version."request"."2.81.0";
  by-version."request"."2.81.0" = self.buildNodePackage {
    name = "request-2.81.0";
    version = "2.81.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/request/-/request-2.81.0.tgz";
      name = "request-2.81.0.tgz";
      sha1 = "c6928946a0e06c5f8d6f8a9333469ffda46298a0";
    };
    deps = {
      "aws-sign2-0.6.0" = self.by-version."aws-sign2"."0.6.0";
      "aws4-1.6.0" = self.by-version."aws4"."1.6.0";
      "caseless-0.12.0" = self.by-version."caseless"."0.12.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "extend-3.0.0" = self.by-version."extend"."3.0.0";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-2.1.2" = self.by-version."form-data"."2.1.2";
      "har-validator-4.2.1" = self.by-version."har-validator"."4.2.1";
      "hawk-3.1.3" = self.by-version."hawk"."3.1.3";
      "http-signature-1.1.1" = self.by-version."http-signature"."1.1.1";
      "is-typedarray-1.0.0" = self.by-version."is-typedarray"."1.0.0";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.1.14" = self.by-version."mime-types"."2.1.14";
      "oauth-sign-0.8.2" = self.by-version."oauth-sign"."0.8.2";
      "performance-now-0.2.0" = self.by-version."performance-now"."0.2.0";
      "qs-6.4.0" = self.by-version."qs"."6.4.0";
      "safe-buffer-5.0.1" = self.by-version."safe-buffer"."5.0.1";
      "stringstream-0.0.5" = self.by-version."stringstream"."0.0.5";
      "tough-cookie-2.3.2" = self.by-version."tough-cookie"."2.3.2";
      "tunnel-agent-0.6.0" = self.by-version."tunnel-agent"."0.6.0";
      "uuid-3.0.1" = self.by-version."uuid"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."resolve"."^1.1.6" =
    self.by-version."resolve"."1.3.2";
  by-version."resolve"."1.3.2" = self.buildNodePackage {
    name = "resolve-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/resolve/-/resolve-1.3.2.tgz";
      name = "resolve-1.3.2.tgz";
      sha1 = "1f0442c9e0cbb8136e87b9305f932f46c7f28235";
    };
    deps = {
      "path-parse-1.0.5" = self.by-version."path-parse"."1.0.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."right-align"."^0.1.1" =
    self.by-version."right-align"."0.1.3";
  by-version."right-align"."0.1.3" = self.buildNodePackage {
    name = "right-align-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/right-align/-/right-align-0.1.3.tgz";
      name = "right-align-0.1.3.tgz";
      sha1 = "61339b722fe6a3515689210d24e14c96148613ef";
    };
    deps = {
      "align-text-0.1.4" = self.by-version."align-text"."0.1.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."safe-buffer"."^5.0.1" =
    self.by-version."safe-buffer"."5.0.1";
  by-version."safe-buffer"."5.0.1" = self.buildNodePackage {
    name = "safe-buffer-5.0.1";
    version = "5.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/safe-buffer/-/safe-buffer-5.0.1.tgz";
      name = "safe-buffer-5.0.1.tgz";
      sha1 = "d263ca54696cd8a306b5ca6551e92de57918fbe7";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."send"."0.15.1" =
    self.by-version."send"."0.15.1";
  by-version."send"."0.15.1" = self.buildNodePackage {
    name = "send-0.15.1";
    version = "0.15.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/send/-/send-0.15.1.tgz";
      name = "send-0.15.1.tgz";
      sha1 = "8a02354c26e6f5cca700065f5f0cdeba90ec7b5f";
    };
    deps = {
      "debug-2.6.1" = self.by-version."debug"."2.6.1";
      "depd-1.1.0" = self.by-version."depd"."1.1.0";
      "destroy-1.0.4" = self.by-version."destroy"."1.0.4";
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "etag-1.8.0" = self.by-version."etag"."1.8.0";
      "fresh-0.5.0" = self.by-version."fresh"."0.5.0";
      "http-errors-1.6.1" = self.by-version."http-errors"."1.6.1";
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
      "ms-0.7.2" = self.by-version."ms"."0.7.2";
      "on-finished-2.3.0" = self.by-version."on-finished"."2.3.0";
      "range-parser-1.2.0" = self.by-version."range-parser"."1.2.0";
      "statuses-1.3.1" = self.by-version."statuses"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."serve-favicon"."~2.3.2" =
    self.by-version."serve-favicon"."2.3.2";
  by-version."serve-favicon"."2.3.2" = self.buildNodePackage {
    name = "serve-favicon-2.3.2";
    version = "2.3.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/serve-favicon/-/serve-favicon-2.3.2.tgz";
      name = "serve-favicon-2.3.2.tgz";
      sha1 = "dd419e268de012ab72b319d337f2105013f9381f";
    };
    deps = {
      "etag-1.7.0" = self.by-version."etag"."1.7.0";
      "fresh-0.3.0" = self.by-version."fresh"."0.3.0";
      "ms-0.7.2" = self.by-version."ms"."0.7.2";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "serve-favicon" = self.by-version."serve-favicon"."2.3.2";
  by-spec."serve-static"."1.12.1" =
    self.by-version."serve-static"."1.12.1";
  by-version."serve-static"."1.12.1" = self.buildNodePackage {
    name = "serve-static-1.12.1";
    version = "1.12.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/serve-static/-/serve-static-1.12.1.tgz";
      name = "serve-static-1.12.1.tgz";
      sha1 = "7443a965e3ced647aceb5639fa06bf4d1bbe0039";
    };
    deps = {
      "encodeurl-1.0.1" = self.by-version."encodeurl"."1.0.1";
      "escape-html-1.0.3" = self.by-version."escape-html"."1.0.3";
      "parseurl-1.3.1" = self.by-version."parseurl"."1.3.1";
      "send-0.15.1" = self.by-version."send"."0.15.1";
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
  by-spec."setprototypeof"."1.0.3" =
    self.by-version."setprototypeof"."1.0.3";
  by-version."setprototypeof"."1.0.3" = self.buildNodePackage {
    name = "setprototypeof-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/setprototypeof/-/setprototypeof-1.0.3.tgz";
      name = "setprototypeof-1.0.3.tgz";
      sha1 = "66567e37043eeb4f04d91bd658c0cbefb55b8e04";
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
  by-spec."source-map"."0.4.x" =
    self.by-version."source-map"."0.4.4";
  by-version."source-map"."0.4.4" = self.buildNodePackage {
    name = "source-map-0.4.4";
    version = "0.4.4";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/source-map/-/source-map-0.4.4.tgz";
      name = "source-map-0.4.4.tgz";
      sha1 = "eba4f5da9c0dc999de68032d8b4f76173652036b";
    };
    deps = {
      "amdefine-1.0.1" = self.by-version."amdefine"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."^0.5.3" =
    self.by-version."source-map"."0.5.6";
  by-version."source-map"."0.5.6" = self.buildNodePackage {
    name = "source-map-0.5.6";
    version = "0.5.6";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/source-map/-/source-map-0.5.6.tgz";
      name = "source-map-0.5.6.tgz";
      sha1 = "75ce38f52bf0733c5a7f0c118d81334a2bb5f412";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."source-map"."~0.5.1" =
    self.by-version."source-map"."0.5.6";
  by-spec."sshpk"."^1.7.0" =
    self.by-version."sshpk"."1.11.0";
  by-version."sshpk"."1.11.0" = self.buildNodePackage {
    name = "sshpk-1.11.0";
    version = "1.11.0";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/sshpk/-/sshpk-1.11.0.tgz";
      name = "sshpk-1.11.0.tgz";
      sha1 = "2d8d5ebb4a6fab28ffba37fa62a90f4a3ea59d77";
    };
    deps = {
      "asn1-0.2.3" = self.by-version."asn1"."0.2.3";
      "assert-plus-1.0.0" = self.by-version."assert-plus"."1.0.0";
      "dashdash-1.14.1" = self.by-version."dashdash"."1.14.1";
      "getpass-0.1.6" = self.by-version."getpass"."0.1.6";
    };
    optionalDependencies = {
      "jsbn-0.1.1" = self.by-version."jsbn"."0.1.1";
      "tweetnacl-0.14.5" = self.by-version."tweetnacl"."0.14.5";
      "jodid25519-1.0.2" = self.by-version."jodid25519"."1.0.2";
      "ecc-jsbn-0.1.1" = self.by-version."ecc-jsbn"."0.1.1";
      "bcrypt-pbkdf-1.0.1" = self.by-version."bcrypt-pbkdf"."1.0.1";
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."statuses".">= 1.3.1 < 2" =
    self.by-version."statuses"."1.3.1";
  by-version."statuses"."1.3.1" = self.buildNodePackage {
    name = "statuses-1.3.1";
    version = "1.3.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/statuses/-/statuses-1.3.1.tgz";
      name = "statuses-1.3.1.tgz";
      sha1 = "faf51b9eb74aaef3b3acf4ad5f61abf24cb7b93e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."statuses"."~1.3.1" =
    self.by-version."statuses"."1.3.1";
  by-spec."string-width"."^1.0.1" =
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
      "ansi-regex-2.1.1" = self.by-version."ansi-regex"."2.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."strip-ansi"."^3.0.1" =
    self.by-version."strip-ansi"."3.0.1";
  by-spec."strip-json-comments"."~2.0.1" =
    self.by-version."strip-json-comments"."2.0.1";
  by-version."strip-json-comments"."2.0.1" = self.buildNodePackage {
    name = "strip-json-comments-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/strip-json-comments/-/strip-json-comments-2.0.1.tgz";
      name = "strip-json-comments-2.0.1.tgz";
      sha1 = "3c531942e908c2697c0ec344858c286c7ca0a60a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-fs"."^1.13.0" =
    self.by-version."tar-fs"."1.15.2";
  by-version."tar-fs"."1.15.2" = self.buildNodePackage {
    name = "tar-fs-1.15.2";
    version = "1.15.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tar-fs/-/tar-fs-1.15.2.tgz";
      name = "tar-fs-1.15.2.tgz";
      sha1 = "761f5b32932c7b39461a60d537faea0d8084830c";
    };
    deps = {
      "chownr-1.0.1" = self.by-version."chownr"."1.0.1";
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
      "end-of-stream-1.4.0" = self.by-version."end-of-stream"."1.4.0";
      "readable-stream-2.2.6" = self.by-version."readable-stream"."2.2.6";
      "xtend-4.0.1" = self.by-version."xtend"."4.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."token-stream"."0.0.1" =
    self.by-version."token-stream"."0.0.1";
  by-version."token-stream"."0.0.1" = self.buildNodePackage {
    name = "token-stream-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/token-stream/-/token-stream-0.0.1.tgz";
      name = "token-stream-0.0.1.tgz";
      sha1 = "ceeefc717a76c4316f126d0b9dbaa55d7e7df01a";
    };
    deps = {
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
  by-spec."tunnel-agent"."^0.4.3" =
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
  by-spec."tunnel-agent"."^0.6.0" =
    self.by-version."tunnel-agent"."0.6.0";
  by-version."tunnel-agent"."0.6.0" = self.buildNodePackage {
    name = "tunnel-agent-0.6.0";
    version = "0.6.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/tunnel-agent/-/tunnel-agent-0.6.0.tgz";
      name = "tunnel-agent-0.6.0.tgz";
      sha1 = "27a5dea06b36b04a0a9966774b290868f0fc40fd";
    };
    deps = {
      "safe-buffer-5.0.1" = self.by-version."safe-buffer"."5.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tweetnacl"."^0.14.3" =
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
  by-spec."tweetnacl"."~0.14.0" =
    self.by-version."tweetnacl"."0.14.5";
  by-spec."type-is"."~1.6.14" =
    self.by-version."type-is"."1.6.14";
  by-version."type-is"."1.6.14" = self.buildNodePackage {
    name = "type-is-1.6.14";
    version = "1.6.14";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/type-is/-/type-is-1.6.14.tgz";
      name = "type-is-1.6.14.tgz";
      sha1 = "e219639c17ded1ca0789092dd54a03826b817cb2";
    };
    deps = {
      "media-typer-0.3.0" = self.by-version."media-typer"."0.3.0";
      "mime-types-2.1.14" = self.by-version."mime-types"."2.1.14";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."uglify-js"."^2.6.1" =
    self.by-version."uglify-js"."2.8.15";
  by-version."uglify-js"."2.8.15" = self.buildNodePackage {
    name = "uglify-js-2.8.15";
    version = "2.8.15";
    bin = true;
    src = fetchurl {
      url = "https://registry.npmjs.org/uglify-js/-/uglify-js-2.8.15.tgz";
      name = "uglify-js-2.8.15.tgz";
      sha1 = "835dd4cd5872554756e6874508d0d0561704d94d";
    };
    deps = {
      "source-map-0.5.6" = self.by-version."source-map"."0.5.6";
      "yargs-3.10.0" = self.by-version."yargs"."3.10.0";
    };
    optionalDependencies = {
      "uglify-to-browserify-1.0.2" = self.by-version."uglify-to-browserify"."1.0.2";
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
      url = "https://registry.npmjs.org/uglify-to-browserify/-/uglify-to-browserify-1.0.2.tgz";
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
  by-spec."ultron"."~1.1.0" =
    self.by-version."ultron"."1.1.0";
  by-version."ultron"."1.1.0" = self.buildNodePackage {
    name = "ultron-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ultron/-/ultron-1.1.0.tgz";
      name = "ultron-1.1.0.tgz";
      sha1 = "b07a2e6a541a815fc6a34ccd4533baec307ca864";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."unpipe"."1.0.0" =
    self.by-version."unpipe"."1.0.0";
  by-version."unpipe"."1.0.0" = self.buildNodePackage {
    name = "unpipe-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/unpipe/-/unpipe-1.0.0.tgz";
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
  by-spec."unpipe"."~1.0.0" =
    self.by-version."unpipe"."1.0.0";
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
  by-spec."utils-merge"."1.0.0" =
    self.by-version."utils-merge"."1.0.0";
  by-version."utils-merge"."1.0.0" = self.buildNodePackage {
    name = "utils-merge-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/utils-merge/-/utils-merge-1.0.0.tgz";
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
  by-spec."vary"."~1.1.0" =
    self.by-version."vary"."1.1.1";
  by-version."vary"."1.1.1" = self.buildNodePackage {
    name = "vary-1.1.1";
    version = "1.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/vary/-/vary-1.1.1.tgz";
      name = "vary-1.1.1.tgz";
      sha1 = "67535ebb694c1d52257457984665323f587e8d37";
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
  by-spec."void-elements"."^2.0.1" =
    self.by-version."void-elements"."2.0.1";
  by-version."void-elements"."2.0.1" = self.buildNodePackage {
    name = "void-elements-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/void-elements/-/void-elements-2.0.1.tgz";
      name = "void-elements-2.0.1.tgz";
      sha1 = "c066afb582bb1cb4128d60ea92392e94d5e9dbec";
    };
    deps = {
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
  by-spec."window-size"."0.1.0" =
    self.by-version."window-size"."0.1.0";
  by-version."window-size"."0.1.0" = self.buildNodePackage {
    name = "window-size-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/window-size/-/window-size-0.1.0.tgz";
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
  by-spec."with"."^5.0.0" =
    self.by-version."with"."5.1.1";
  by-version."with"."5.1.1" = self.buildNodePackage {
    name = "with-5.1.1";
    version = "5.1.1";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/with/-/with-5.1.1.tgz";
      name = "with-5.1.1.tgz";
      sha1 = "fa4daa92daf32c4ea94ed453c81f04686b575dfe";
    };
    deps = {
      "acorn-3.3.0" = self.by-version."acorn"."3.3.0";
      "acorn-globals-3.1.0" = self.by-version."acorn-globals"."3.1.0";
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
      url = "https://registry.npmjs.org/wordwrap/-/wordwrap-0.0.2.tgz";
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
  by-spec."ws"."^2.0.2" =
    self.by-version."ws"."2.2.2";
  by-version."ws"."2.2.2" = self.buildNodePackage {
    name = "ws-2.2.2";
    version = "2.2.2";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/ws/-/ws-2.2.2.tgz";
      name = "ws-2.2.2.tgz";
      sha1 = "aa26daf39c52b20ed716e3447f8641494a726b01";
    };
    deps = {
      "ultron-1.1.0" = self.by-version."ultron"."1.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."xtend"."4.0.1" =
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
  by-spec."yargs"."~3.10.0" =
    self.by-version."yargs"."3.10.0";
  by-version."yargs"."3.10.0" = self.buildNodePackage {
    name = "yargs-3.10.0";
    version = "3.10.0";
    bin = false;
    src = fetchurl {
      url = "https://registry.npmjs.org/yargs/-/yargs-3.10.0.tgz";
      name = "yargs-3.10.0.tgz";
      sha1 = "f7ee7bd857dd7c1d2d38c0e74efbd681d1431fd1";
    };
    deps = {
      "camelcase-1.2.1" = self.by-version."camelcase"."1.2.1";
      "cliui-2.1.0" = self.by-version."cliui"."2.1.0";
      "decamelize-1.2.0" = self.by-version."decamelize"."1.2.0";
      "window-size-0.1.0" = self.by-version."window-size"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
}

{ self, fetchurl, fetchgit ? null, lib }:

{
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
  by-spec."abbrev"."^1.0.5" =
    self.by-version."abbrev"."1.0.7";
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
  by-spec."ansi-regex"."^1.1.1" =
    self.by-version."ansi-regex"."1.1.1";
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
  by-spec."ansicolors"."~0.2.1" =
    self.by-version."ansicolors"."0.2.1";
  by-version."ansicolors"."0.2.1" = self.buildNodePackage {
    name = "ansicolors-0.2.1";
    version = "0.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ansicolors/-/ansicolors-0.2.1.tgz";
      name = "ansicolors-0.2.1.tgz";
      sha1 = "be089599097b74a5c9c4a84a0cdbcdb62bd87aef";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."archy"."1.0.0" =
    self.by-version."archy"."1.0.0";
  by-version."archy"."1.0.0" = self.buildNodePackage {
    name = "archy-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/archy/-/archy-1.0.0.tgz";
      name = "archy-1.0.0.tgz";
      sha1 = "f9c8c13757cc1dd7bc379ac77b2c62a5c2868c40";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."argparse"."~1.0.2" =
    self.by-version."argparse"."1.0.2";
  by-version."argparse"."1.0.2" = self.buildNodePackage {
    name = "argparse-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/argparse/-/argparse-1.0.2.tgz";
      name = "argparse-1.0.2.tgz";
      sha1 = "bcfae39059656d1973d0b9e6a1a74154b5a9a136";
    };
    deps = {
      "lodash-3.10.0" = self.by-version."lodash"."3.10.0";
      "sprintf-js-1.0.3" = self.by-version."sprintf-js"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-filter"."~0.0.0" =
    self.by-version."array-filter"."0.0.1";
  by-version."array-filter"."0.0.1" = self.buildNodePackage {
    name = "array-filter-0.0.1";
    version = "0.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/array-filter/-/array-filter-0.0.1.tgz";
      name = "array-filter-0.0.1.tgz";
      sha1 = "7da8cf2e26628ed732803581fd21f67cacd2eeec";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-map"."~0.0.0" =
    self.by-version."array-map"."0.0.0";
  by-version."array-map"."0.0.0" = self.buildNodePackage {
    name = "array-map-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/array-map/-/array-map-0.0.0.tgz";
      name = "array-map-0.0.0.tgz";
      sha1 = "88a2bab73d1cf7bcd5c1b118a003f66f665fa662";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."array-reduce"."~0.0.0" =
    self.by-version."array-reduce"."0.0.0";
  by-version."array-reduce"."0.0.0" = self.buildNodePackage {
    name = "array-reduce-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/array-reduce/-/array-reduce-0.0.0.tgz";
      name = "array-reduce-0.0.0.tgz";
      sha1 = "173899d3ffd1c7d9383e4479525dbe278cab5f2b";
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
  by-spec."async"."^0.9.0" =
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
  by-spec."async"."^1.2.1" =
    self.by-version."async"."1.3.0";
  by-version."async"."1.3.0" = self.buildNodePackage {
    name = "async-1.3.0";
    version = "1.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/async/-/async-1.3.0.tgz";
      name = "async-1.3.0.tgz";
      sha1 = "a6f1631e8a595a663496d0a5586bd12007d4871d";
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
  by-spec."async"."~0.2.8" =
    self.by-version."async"."0.2.10";
  by-spec."async"."~0.9.0" =
    self.by-version."async"."0.9.2";
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
  by-spec."balanced-match"."^0.2.0" =
    self.by-version."balanced-match"."0.2.0";
  by-version."balanced-match"."0.2.0" = self.buildNodePackage {
    name = "balanced-match-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/balanced-match/-/balanced-match-0.2.0.tgz";
      name = "balanced-match-0.2.0.tgz";
      sha1 = "38f6730c03aab6d5edbb52bd934885e756d71674";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."binary"."^0.3.0" =
    self.by-version."binary"."0.3.0";
  by-version."binary"."0.3.0" = self.buildNodePackage {
    name = "binary-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/binary/-/binary-0.3.0.tgz";
      name = "binary-0.3.0.tgz";
      sha1 = "9f60553bc5ce8c3386f3b553cff47462adecaa79";
    };
    deps = {
      "chainsaw-0.1.0" = self.by-version."chainsaw"."0.1.0";
      "buffers-0.1.1" = self.by-version."buffers"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bl"."^1.0.0" =
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
  by-spec."bower"."^1.3.4" =
    self.by-version."bower"."1.4.1";
  by-version."bower"."1.4.1" = self.buildNodePackage {
    name = "bower-1.4.1";
    version = "1.4.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower/-/bower-1.4.1.tgz";
      name = "bower-1.4.1.tgz";
      sha1 = "a18be39d030792754f30f1c5b32d37b0156ba8dd";
    };
    deps = {
      "abbrev-1.0.7" = self.by-version."abbrev"."1.0.7";
      "archy-1.0.0" = self.by-version."archy"."1.0.0";
      "bower-config-0.6.1" = self.by-version."bower-config"."0.6.1";
      "bower-endpoint-parser-0.2.2" = self.by-version."bower-endpoint-parser"."0.2.2";
      "bower-json-0.4.0" = self.by-version."bower-json"."0.4.0";
      "bower-logger-0.2.2" = self.by-version."bower-logger"."0.2.2";
      "bower-registry-client-0.3.0" = self.by-version."bower-registry-client"."0.3.0";
      "cardinal-0.4.4" = self.by-version."cardinal"."0.4.4";
      "chalk-1.1.0" = self.by-version."chalk"."1.1.0";
      "chmodr-0.1.0" = self.by-version."chmodr"."0.1.0";
      "configstore-0.3.2" = self.by-version."configstore"."0.3.2";
      "decompress-zip-0.1.0" = self.by-version."decompress-zip"."0.1.0";
      "fstream-1.0.7" = self.by-version."fstream"."1.0.7";
      "fstream-ignore-1.0.2" = self.by-version."fstream-ignore"."1.0.2";
      "github-0.2.4" = self.by-version."github"."0.2.4";
      "glob-4.5.3" = self.by-version."glob"."4.5.3";
      "graceful-fs-3.0.8" = self.by-version."graceful-fs"."3.0.8";
      "handlebars-2.0.0" = self.by-version."handlebars"."2.0.0";
      "inquirer-0.8.0" = self.by-version."inquirer"."0.8.0";
      "insight-0.5.3" = self.by-version."insight"."0.5.3";
      "is-root-1.0.0" = self.by-version."is-root"."1.0.0";
      "junk-1.0.2" = self.by-version."junk"."1.0.2";
      "lockfile-1.0.1" = self.by-version."lockfile"."1.0.1";
      "lru-cache-2.6.5" = self.by-version."lru-cache"."2.6.5";
      "mkdirp-0.5.0" = self.by-version."mkdirp"."0.5.0";
      "mout-0.11.0" = self.by-version."mout"."0.11.0";
      "nopt-3.0.3" = self.by-version."nopt"."3.0.3";
      "opn-1.0.2" = self.by-version."opn"."1.0.2";
      "p-throttler-0.1.1" = self.by-version."p-throttler"."0.1.1";
      "promptly-0.2.0" = self.by-version."promptly"."0.2.0";
      "q-1.4.1" = self.by-version."q"."1.4.1";
      "request-2.53.0" = self.by-version."request"."2.53.0";
      "request-progress-0.3.1" = self.by-version."request-progress"."0.3.1";
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
      "rimraf-2.4.1" = self.by-version."rimraf"."2.4.1";
      "semver-2.3.2" = self.by-version."semver"."2.3.2";
      "shell-quote-1.4.3" = self.by-version."shell-quote"."1.4.3";
      "stringify-object-1.0.1" = self.by-version."stringify-object"."1.0.1";
      "tar-fs-1.7.0" = self.by-version."tar-fs"."1.7.0";
      "tmp-0.0.24" = self.by-version."tmp"."0.0.24";
      "update-notifier-0.3.2" = self.by-version."update-notifier"."0.3.2";
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
      "which-1.1.1" = self.by-version."which"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bower" = self.by-version."bower"."1.4.1";
  by-spec."bower-config"."^0.6.1" =
    self.by-version."bower-config"."0.6.1";
  by-version."bower-config"."0.6.1" = self.buildNodePackage {
    name = "bower-config-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower-config/-/bower-config-0.6.1.tgz";
      name = "bower-config-0.6.1.tgz";
      sha1 = "7093155688bef44079bf4cb32d189312c87ded60";
    };
    deps = {
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "mout-0.9.1" = self.by-version."mout"."0.9.1";
      "optimist-0.6.1" = self.by-version."optimist"."0.6.1";
      "osenv-0.0.3" = self.by-version."osenv"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bower-config"."~0.6.1" =
    self.by-version."bower-config"."0.6.1";
  by-spec."bower-endpoint-parser"."^0.2.2" =
    self.by-version."bower-endpoint-parser"."0.2.2";
  by-version."bower-endpoint-parser"."0.2.2" = self.buildNodePackage {
    name = "bower-endpoint-parser-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower-endpoint-parser/-/bower-endpoint-parser-0.2.2.tgz";
      name = "bower-endpoint-parser-0.2.2.tgz";
      sha1 = "00b565adbfab6f2d35addde977e97962acbcb3f6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bower-json"."^0.4.0" =
    self.by-version."bower-json"."0.4.0";
  by-version."bower-json"."0.4.0" = self.buildNodePackage {
    name = "bower-json-0.4.0";
    version = "0.4.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower-json/-/bower-json-0.4.0.tgz";
      name = "bower-json-0.4.0.tgz";
      sha1 = "a99c3ccf416ef0590ed0ded252c760f1c6d93766";
    };
    deps = {
      "deep-extend-0.2.11" = self.by-version."deep-extend"."0.2.11";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "intersect-0.0.3" = self.by-version."intersect"."0.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bower-logger"."^0.2.2" =
    self.by-version."bower-logger"."0.2.2";
  by-version."bower-logger"."0.2.2" = self.buildNodePackage {
    name = "bower-logger-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower-logger/-/bower-logger-0.2.2.tgz";
      name = "bower-logger-0.2.2.tgz";
      sha1 = "39be07e979b2fc8e03a94634205ed9422373d381";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."bower-registry-client"."^0.3.0" =
    self.by-version."bower-registry-client"."0.3.0";
  by-version."bower-registry-client"."0.3.0" = self.buildNodePackage {
    name = "bower-registry-client-0.3.0";
    version = "0.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower-registry-client/-/bower-registry-client-0.3.0.tgz";
      name = "bower-registry-client-0.3.0.tgz";
      sha1 = "f5adcfdeda771a84be088ef1310d9756e58ebe74";
    };
    deps = {
      "async-0.2.10" = self.by-version."async"."0.2.10";
      "bower-config-0.6.1" = self.by-version."bower-config"."0.6.1";
      "graceful-fs-2.0.3" = self.by-version."graceful-fs"."2.0.3";
      "lru-cache-2.3.1" = self.by-version."lru-cache"."2.3.1";
      "request-2.51.0" = self.by-version."request"."2.51.0";
      "request-replay-0.2.0" = self.by-version."request-replay"."0.2.0";
      "rimraf-2.2.8" = self.by-version."rimraf"."2.2.8";
      "mkdirp-0.3.5" = self.by-version."mkdirp"."0.3.5";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."brace-expansion"."^1.0.0" =
    self.by-version."brace-expansion"."1.1.0";
  by-version."brace-expansion"."1.1.0" = self.buildNodePackage {
    name = "brace-expansion-1.1.0";
    version = "1.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/brace-expansion/-/brace-expansion-1.1.0.tgz";
      name = "brace-expansion-1.1.0.tgz";
      sha1 = "c9b7d03c03f37bc704be100e522b40db8f6cfcd9";
    };
    deps = {
      "balanced-match-0.2.0" = self.by-version."balanced-match"."0.2.0";
      "concat-map-0.0.1" = self.by-version."concat-map"."0.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."buffers"."~0.1.1" =
    self.by-version."buffers"."0.1.1";
  by-version."buffers"."0.1.1" = self.buildNodePackage {
    name = "buffers-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/buffers/-/buffers-0.1.1.tgz";
      name = "buffers-0.1.1.tgz";
      sha1 = "b24579c3bed4d6d396aeee6d9a8ae7f5482ab7bb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cardinal"."0.4.4" =
    self.by-version."cardinal"."0.4.4";
  by-version."cardinal"."0.4.4" = self.buildNodePackage {
    name = "cardinal-0.4.4";
    version = "0.4.4";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/cardinal/-/cardinal-0.4.4.tgz";
      name = "cardinal-0.4.4.tgz";
      sha1 = "ca5bb68a5b511b90fe93b9acea49bdee5c32bfe2";
    };
    deps = {
      "redeyed-0.4.4" = self.by-version."redeyed"."0.4.4";
      "ansicolors-0.2.1" = self.by-version."ansicolors"."0.2.1";
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
  by-spec."chainsaw"."~0.1.0" =
    self.by-version."chainsaw"."0.1.0";
  by-version."chainsaw"."0.1.0" = self.buildNodePackage {
    name = "chainsaw-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chainsaw/-/chainsaw-0.1.0.tgz";
      name = "chainsaw-0.1.0.tgz";
      sha1 = "5eab50b28afe58074d0d58291388828b5e5fbc98";
    };
    deps = {
      "traverse-0.3.9" = self.by-version."traverse"."0.3.9";
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
  by-spec."chmodr"."0.1.0" =
    self.by-version."chmodr"."0.1.0";
  by-version."chmodr"."0.1.0" = self.buildNodePackage {
    name = "chmodr-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/chmodr/-/chmodr-0.1.0.tgz";
      name = "chmodr-0.1.0.tgz";
      sha1 = "e09215a1d51542db2a2576969765bcf6125583eb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cli-color"."~0.3.2" =
    self.by-version."cli-color"."0.3.3";
  by-version."cli-color"."0.3.3" = self.buildNodePackage {
    name = "cli-color-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cli-color/-/cli-color-0.3.3.tgz";
      name = "cli-color-0.3.3.tgz";
      sha1 = "12d5bdd158ff8a0b0db401198913c03df069f6f5";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
      "memoizee-0.3.8" = self.by-version."memoizee"."0.3.8";
      "timers-ext-0.1.0" = self.by-version."timers-ext"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."cli-width"."^1.0.1" =
    self.by-version."cli-width"."1.0.1";
  by-version."cli-width"."1.0.1" = self.buildNodePackage {
    name = "cli-width-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cli-width/-/cli-width-1.0.1.tgz";
      name = "cli-width-1.0.1.tgz";
      sha1 = "14d4f6870234d91e97f7dd81e76be8271410a1ef";
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
  by-spec."configstore"."^0.3.1" =
    self.by-version."configstore"."0.3.2";
  by-version."configstore"."0.3.2" = self.buildNodePackage {
    name = "configstore-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/configstore/-/configstore-0.3.2.tgz";
      name = "configstore-0.3.2.tgz";
      sha1 = "25e4c16c3768abf75c5a65bc61761f495055b459";
    };
    deps = {
      "graceful-fs-3.0.8" = self.by-version."graceful-fs"."3.0.8";
      "js-yaml-3.3.1" = self.by-version."js-yaml"."3.3.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "object-assign-2.1.1" = self.by-version."object-assign"."2.1.1";
      "osenv-0.1.3" = self.by-version."osenv"."0.1.3";
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
      "uuid-2.0.1" = self.by-version."uuid"."2.0.1";
      "xdg-basedir-1.0.1" = self.by-version."xdg-basedir"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."configstore"."^0.3.2" =
    self.by-version."configstore"."0.3.2";
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
  by-spec."d"."~0.1.1" =
    self.by-version."d"."0.1.1";
  by-version."d"."0.1.1" = self.buildNodePackage {
    name = "d-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/d/-/d-0.1.1.tgz";
      name = "d-0.1.1.tgz";
      sha1 = "da184c535d18d8ee7ba2aa229b914009fae11309";
    };
    deps = {
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."decompress-zip"."^0.1.0" =
    self.by-version."decompress-zip"."0.1.0";
  by-version."decompress-zip"."0.1.0" = self.buildNodePackage {
    name = "decompress-zip-0.1.0";
    version = "0.1.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/decompress-zip/-/decompress-zip-0.1.0.tgz";
      name = "decompress-zip-0.1.0.tgz";
      sha1 = "bce60c11664f2d660fca4bcf634af6de5d6c14c7";
    };
    deps = {
      "binary-0.3.0" = self.by-version."binary"."0.3.0";
      "graceful-fs-3.0.8" = self.by-version."graceful-fs"."3.0.8";
      "mkpath-0.1.0" = self.by-version."mkpath"."0.1.0";
      "nopt-3.0.3" = self.by-version."nopt"."3.0.3";
      "q-1.4.1" = self.by-version."q"."1.4.1";
      "readable-stream-1.1.13" = self.by-version."readable-stream"."1.1.13";
      "touch-0.0.3" = self.by-version."touch"."0.0.3";
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
      url = "http://registry.npmjs.org/deep-extend/-/deep-extend-0.2.11.tgz";
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
  by-spec."duplexify"."^3.2.0" =
    self.by-version."duplexify"."3.4.2";
  by-version."duplexify"."3.4.2" = self.buildNodePackage {
    name = "duplexify-3.4.2";
    version = "3.4.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/duplexify/-/duplexify-3.4.2.tgz";
      name = "duplexify-3.4.2.tgz";
      sha1 = "71a578af03e0d063eb8f1326affd5e5600145e1b";
    };
    deps = {
      "end-of-stream-1.0.0" = self.by-version."end-of-stream"."1.0.0";
      "readable-stream-2.0.2" = self.by-version."readable-stream"."2.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."1.0.0" =
    self.by-version."end-of-stream"."1.0.0";
  by-version."end-of-stream"."1.0.0" = self.buildNodePackage {
    name = "end-of-stream-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/end-of-stream/-/end-of-stream-1.0.0.tgz";
      name = "end-of-stream-1.0.0.tgz";
      sha1 = "d4596e702734a93e40e9af864319eabd99ff2f0e";
    };
    deps = {
      "once-1.3.2" = self.by-version."once"."1.3.2";
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
      url = "http://registry.npmjs.org/end-of-stream/-/end-of-stream-1.1.0.tgz";
      name = "end-of-stream-1.1.0.tgz";
      sha1 = "e9353258baa9108965efc41cb0ef8ade2f3cfb07";
    };
    deps = {
      "once-1.3.2" = self.by-version."once"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."end-of-stream"."^1.1.0" =
    self.by-version."end-of-stream"."1.1.0";
  by-spec."es5-ext"."~0.10.2" =
    self.by-version."es5-ext"."0.10.7";
  by-version."es5-ext"."0.10.7" = self.buildNodePackage {
    name = "es5-ext-0.10.7";
    version = "0.10.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/es5-ext/-/es5-ext-0.10.7.tgz";
      name = "es5-ext-0.10.7.tgz";
      sha1 = "dfaea50721301042e2d89c1719d43493fa821656";
    };
    deps = {
      "es6-iterator-0.1.3" = self.by-version."es6-iterator"."0.1.3";
      "es6-symbol-2.0.1" = self.by-version."es6-symbol"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es5-ext"."~0.10.4" =
    self.by-version."es5-ext"."0.10.7";
  by-spec."es5-ext"."~0.10.5" =
    self.by-version."es5-ext"."0.10.7";
  by-spec."es5-ext"."~0.10.6" =
    self.by-version."es5-ext"."0.10.7";
  by-spec."es6-iterator"."~0.1.3" =
    self.by-version."es6-iterator"."0.1.3";
  by-version."es6-iterator"."0.1.3" = self.buildNodePackage {
    name = "es6-iterator-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/es6-iterator/-/es6-iterator-0.1.3.tgz";
      name = "es6-iterator-0.1.3.tgz";
      sha1 = "d6f58b8c4fc413c249b4baa19768f8e4d7c8944e";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
      "es6-symbol-2.0.1" = self.by-version."es6-symbol"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-symbol"."~2.0.1" =
    self.by-version."es6-symbol"."2.0.1";
  by-version."es6-symbol"."2.0.1" = self.buildNodePackage {
    name = "es6-symbol-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/es6-symbol/-/es6-symbol-2.0.1.tgz";
      name = "es6-symbol-2.0.1.tgz";
      sha1 = "761b5c67cfd4f1d18afb234f691d678682cb3bf3";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."es6-weak-map"."~0.1.2" =
    self.by-version."es6-weak-map"."0.1.4";
  by-version."es6-weak-map"."0.1.4" = self.buildNodePackage {
    name = "es6-weak-map-0.1.4";
    version = "0.1.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/es6-weak-map/-/es6-weak-map-0.1.4.tgz";
      name = "es6-weak-map-0.1.4.tgz";
      sha1 = "706cef9e99aa236ba7766c239c8b9e286ea7d228";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
      "es6-iterator-0.1.3" = self.by-version."es6-iterator"."0.1.3";
      "es6-symbol-2.0.1" = self.by-version."es6-symbol"."2.0.1";
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
  by-spec."esprima"."~1.0.4" =
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
  by-spec."esprima"."~2.2.0" =
    self.by-version."esprima"."2.2.0";
  by-version."esprima"."2.2.0" = self.buildNodePackage {
    name = "esprima-2.2.0";
    version = "2.2.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/esprima/-/esprima-2.2.0.tgz";
      name = "esprima-2.2.0.tgz";
      sha1 = "4292c1d68e4173d815fa2290dc7afc96d81fcd83";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."event-emitter"."~0.3.1" =
    self.by-version."event-emitter"."0.3.3";
  by-version."event-emitter"."0.3.3" = self.buildNodePackage {
    name = "event-emitter-0.3.3";
    version = "0.3.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/event-emitter/-/event-emitter-0.3.3.tgz";
      name = "event-emitter-0.3.3.tgz";
      sha1 = "df8e806541c68ab8ff20a79a1841b91abaa1bee4";
    };
    deps = {
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
      "d-0.1.1" = self.by-version."d"."0.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."extend"."~2.0.1" =
    self.by-version."extend"."2.0.1";
  by-version."extend"."2.0.1" = self.buildNodePackage {
    name = "extend-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/extend/-/extend-2.0.1.tgz";
      name = "extend-2.0.1.tgz";
      sha1 = "1ee8010689e7395ff9448241c98652bc759a8260";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."figures"."^1.3.2" =
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
  by-spec."figures"."^1.3.5" =
    self.by-version."figures"."1.3.5";
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
  by-spec."form-data"."~1.0.0-rc1" =
    self.by-version."form-data"."1.0.0-rc1";
  by-version."form-data"."1.0.0-rc1" = self.buildNodePackage {
    name = "form-data-1.0.0-rc1";
    version = "1.0.0-rc1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/form-data/-/form-data-1.0.0-rc1.tgz";
      name = "form-data-1.0.0-rc1.tgz";
      sha1 = "de5d87ff28439596f4f5500bff58d1244d54793a";
    };
    deps = {
      "async-1.3.0" = self.by-version."async"."1.3.0";
      "combined-stream-1.0.5" = self.by-version."combined-stream"."1.0.5";
      "mime-types-2.1.3" = self.by-version."mime-types"."2.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.0" =
    self.by-version."fstream"."1.0.7";
  by-version."fstream"."1.0.7" = self.buildNodePackage {
    name = "fstream-1.0.7";
    version = "1.0.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fstream/-/fstream-1.0.7.tgz";
      name = "fstream-1.0.7.tgz";
      sha1 = "455a1aa1d46077668d95b6d27838e1b1daa78c78";
    };
    deps = {
      "graceful-fs-3.0.8" = self.by-version."graceful-fs"."3.0.8";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "rimraf-2.4.1" = self.by-version."rimraf"."2.4.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."fstream"."^1.0.3" =
    self.by-version."fstream"."1.0.7";
  by-spec."fstream-ignore"."^1.0.2" =
    self.by-version."fstream-ignore"."1.0.2";
  by-version."fstream-ignore"."1.0.2" = self.buildNodePackage {
    name = "fstream-ignore-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/fstream-ignore/-/fstream-ignore-1.0.2.tgz";
      name = "fstream-ignore-1.0.2.tgz";
      sha1 = "18c891db01b782a74a7bff936a0f24997741c7ab";
    };
    deps = {
      "fstream-1.0.7" = self.by-version."fstream"."1.0.7";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.9" = self.by-version."minimatch"."2.0.9";
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
  by-spec."github"."^0.2.3" =
    self.by-version."github"."0.2.4";
  by-version."github"."0.2.4" = self.buildNodePackage {
    name = "github-0.2.4";
    version = "0.2.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/github/-/github-0.2.4.tgz";
      name = "github-0.2.4.tgz";
      sha1 = "24fa7f0e13fa11b946af91134c51982a91ce538b";
    };
    deps = {
      "mime-1.3.4" = self.by-version."mime"."1.3.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^4.3.2" =
    self.by-version."glob"."4.5.3";
  by-version."glob"."4.5.3" = self.buildNodePackage {
    name = "glob-4.5.3";
    version = "4.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/glob/-/glob-4.5.3.tgz";
      name = "glob-4.5.3.tgz";
      sha1 = "c6cb73d3226c1efef04de3c56d012f03377ee15f";
    };
    deps = {
      "inflight-1.0.4" = self.by-version."inflight"."1.0.4";
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
      "minimatch-2.0.9" = self.by-version."minimatch"."2.0.9";
      "once-1.3.2" = self.by-version."once"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."glob"."^4.4.2" =
    self.by-version."glob"."4.5.3";
  by-spec."got"."^3.2.0" =
    self.by-version."got"."3.3.1";
  by-version."got"."3.3.1" = self.buildNodePackage {
    name = "got-3.3.1";
    version = "3.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/got/-/got-3.3.1.tgz";
      name = "got-3.3.1.tgz";
      sha1 = "e5d0ed4af55fc3eef4d56007769d98192bcb2eca";
    };
    deps = {
      "duplexify-3.4.2" = self.by-version."duplexify"."3.4.2";
      "infinity-agent-2.0.3" = self.by-version."infinity-agent"."2.0.3";
      "is-redirect-1.0.0" = self.by-version."is-redirect"."1.0.0";
      "is-stream-1.0.1" = self.by-version."is-stream"."1.0.1";
      "lowercase-keys-1.0.0" = self.by-version."lowercase-keys"."1.0.0";
      "nested-error-stacks-1.0.1" = self.by-version."nested-error-stacks"."1.0.1";
      "object-assign-3.0.0" = self.by-version."object-assign"."3.0.0";
      "prepend-http-1.0.1" = self.by-version."prepend-http"."1.0.1";
      "read-all-stream-3.0.1" = self.by-version."read-all-stream"."3.0.1";
      "timed-out-2.0.0" = self.by-version."timed-out"."2.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."3" =
    self.by-version."graceful-fs"."3.0.8";
  by-version."graceful-fs"."3.0.8" = self.buildNodePackage {
    name = "graceful-fs-3.0.8";
    version = "3.0.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/graceful-fs/-/graceful-fs-3.0.8.tgz";
      name = "graceful-fs-3.0.8.tgz";
      sha1 = "ce813e725fa82f7e6147d51c9a5ca68270551c22";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."graceful-fs"."^3.0.0" =
    self.by-version."graceful-fs"."3.0.8";
  by-spec."graceful-fs"."^3.0.1" =
    self.by-version."graceful-fs"."3.0.8";
  by-spec."graceful-fs"."^3.0.5" =
    self.by-version."graceful-fs"."3.0.8";
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
      "is-my-json-valid-2.12.0" = self.by-version."is-my-json-valid"."2.12.0";
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
  by-spec."infinity-agent"."^2.0.0" =
    self.by-version."infinity-agent"."2.0.3";
  by-version."infinity-agent"."2.0.3" = self.buildNodePackage {
    name = "infinity-agent-2.0.3";
    version = "2.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/infinity-agent/-/infinity-agent-2.0.3.tgz";
      name = "infinity-agent-2.0.3.tgz";
      sha1 = "45e0e2ff7a9eb030b27d62b74b3744b7a7ac4216";
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
      "once-1.3.2" = self.by-version."once"."1.3.2";
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
  by-spec."inherits"."~2.0.0" =
    self.by-version."inherits"."2.0.1";
  by-spec."inherits"."~2.0.1" =
    self.by-version."inherits"."2.0.1";
  by-spec."ini"."~1.3.0" =
    self.by-version."ini"."1.3.4";
  by-version."ini"."1.3.4" = self.buildNodePackage {
    name = "ini-1.3.4";
    version = "1.3.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/ini/-/ini-1.3.4.tgz";
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
  by-spec."inquirer"."0.8.0" =
    self.by-version."inquirer"."0.8.0";
  by-version."inquirer"."0.8.0" = self.buildNodePackage {
    name = "inquirer-0.8.0";
    version = "0.8.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inquirer/-/inquirer-0.8.0.tgz";
      name = "inquirer-0.8.0.tgz";
      sha1 = "525d4dd827d4f3d506b453726068f90deb99b443";
    };
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
      "chalk-0.5.1" = self.by-version."chalk"."0.5.1";
      "cli-color-0.3.3" = self.by-version."cli-color"."0.3.3";
      "figures-1.3.5" = self.by-version."figures"."1.3.5";
      "lodash-2.4.2" = self.by-version."lodash"."2.4.2";
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
      "readline2-0.1.1" = self.by-version."readline2"."0.1.1";
      "rx-2.5.3" = self.by-version."rx"."2.5.3";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."inquirer"."^0.8.0" =
    self.by-version."inquirer"."0.8.5";
  by-version."inquirer"."0.8.5" = self.buildNodePackage {
    name = "inquirer-0.8.5";
    version = "0.8.5";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inquirer/-/inquirer-0.8.5.tgz";
      name = "inquirer-0.8.5.tgz";
      sha1 = "dbd740cf6ca3b731296a63ce6f6d961851f336df";
    };
    deps = {
      "ansi-regex-1.1.1" = self.by-version."ansi-regex"."1.1.1";
      "chalk-1.1.0" = self.by-version."chalk"."1.1.0";
      "cli-width-1.0.1" = self.by-version."cli-width"."1.0.1";
      "figures-1.3.5" = self.by-version."figures"."1.3.5";
      "lodash-3.10.0" = self.by-version."lodash"."3.10.0";
      "readline2-0.1.1" = self.by-version."readline2"."0.1.1";
      "rx-2.5.3" = self.by-version."rx"."2.5.3";
      "through-2.3.8" = self.by-version."through"."2.3.8";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."insight"."^0.5.0" =
    self.by-version."insight"."0.5.3";
  by-version."insight"."0.5.3" = self.buildNodePackage {
    name = "insight-0.5.3";
    version = "0.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/insight/-/insight-0.5.3.tgz";
      name = "insight-0.5.3.tgz";
      sha1 = "353626c1b86b12c7bdfecb0a54ef80cd7e6f89e0";
    };
    deps = {
      "async-0.9.2" = self.by-version."async"."0.9.2";
      "chalk-1.1.0" = self.by-version."chalk"."1.1.0";
      "configstore-0.3.2" = self.by-version."configstore"."0.3.2";
      "inquirer-0.8.5" = self.by-version."inquirer"."0.8.5";
      "lodash.debounce-3.1.1" = self.by-version."lodash.debounce"."3.1.1";
      "object-assign-2.1.1" = self.by-version."object-assign"."2.1.1";
      "os-name-1.0.3" = self.by-version."os-name"."1.0.3";
      "request-2.58.0" = self.by-version."request"."2.58.0";
      "tough-cookie-0.12.1" = self.by-version."tough-cookie"."0.12.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."intersect"."~0.0.3" =
    self.by-version."intersect"."0.0.3";
  by-version."intersect"."0.0.3" = self.buildNodePackage {
    name = "intersect-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/intersect/-/intersect-0.0.3.tgz";
      name = "intersect-0.0.3.tgz";
      sha1 = "c1a4a5e5eac6ede4af7504cc07e0ada7bc9f4920";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-absolute"."^0.1.7" =
    self.by-version."is-absolute"."0.1.7";
  by-version."is-absolute"."0.1.7" = self.buildNodePackage {
    name = "is-absolute-0.1.7";
    version = "0.1.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-absolute/-/is-absolute-0.1.7.tgz";
      name = "is-absolute-0.1.7.tgz";
      sha1 = "847491119fccb5fb436217cc737f7faad50f603f";
    };
    deps = {
      "is-relative-0.1.3" = self.by-version."is-relative"."0.1.3";
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
  by-spec."is-npm"."^1.0.0" =
    self.by-version."is-npm"."1.0.0";
  by-version."is-npm"."1.0.0" = self.buildNodePackage {
    name = "is-npm-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-npm/-/is-npm-1.0.0.tgz";
      name = "is-npm-1.0.0.tgz";
      sha1 = "f2fb63a65e4905b406c86072765a1a4dc793b9f4";
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
  by-spec."is-redirect"."^1.0.0" =
    self.by-version."is-redirect"."1.0.0";
  by-version."is-redirect"."1.0.0" = self.buildNodePackage {
    name = "is-redirect-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-redirect/-/is-redirect-1.0.0.tgz";
      name = "is-redirect-1.0.0.tgz";
      sha1 = "1d03dded53bd8db0f30c26e4f95d36fc7c87dc24";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-relative"."^0.1.0" =
    self.by-version."is-relative"."0.1.3";
  by-version."is-relative"."0.1.3" = self.buildNodePackage {
    name = "is-relative-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-relative/-/is-relative-0.1.3.tgz";
      name = "is-relative-0.1.3.tgz";
      sha1 = "905fee8ae86f45b3ec614bc3c15c869df0876e82";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-root"."^1.0.0" =
    self.by-version."is-root"."1.0.0";
  by-version."is-root"."1.0.0" = self.buildNodePackage {
    name = "is-root-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-root/-/is-root-1.0.0.tgz";
      name = "is-root-1.0.0.tgz";
      sha1 = "07b6c233bc394cd9d02ba15c966bd6660d6342d5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."is-stream"."^1.0.0" =
    self.by-version."is-stream"."1.0.1";
  by-version."is-stream"."1.0.1" = self.buildNodePackage {
    name = "is-stream-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/is-stream/-/is-stream-1.0.1.tgz";
      name = "is-stream-1.0.1.tgz";
      sha1 = "b44ce45b1f0c3df583f6b5debf84dcf9743ac8b5";
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
  by-spec."js-yaml"."^3.1.0" =
    self.by-version."js-yaml"."3.3.1";
  by-version."js-yaml"."3.3.1" = self.buildNodePackage {
    name = "js-yaml-3.3.1";
    version = "3.3.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/js-yaml/-/js-yaml-3.3.1.tgz";
      name = "js-yaml-3.3.1.tgz";
      sha1 = "ca1acd3423ec275d12140a7bab51db015ba0b3c0";
    };
    deps = {
      "argparse-1.0.2" = self.by-version."argparse"."1.0.2";
      "esprima-2.2.0" = self.by-version."esprima"."2.2.0";
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
  by-spec."jsonify"."~0.0.0" =
    self.by-version."jsonify"."0.0.0";
  by-version."jsonify"."0.0.0" = self.buildNodePackage {
    name = "jsonify-0.0.0";
    version = "0.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/jsonify/-/jsonify-0.0.0.tgz";
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
  by-spec."junk"."^1.0.0" =
    self.by-version."junk"."1.0.2";
  by-version."junk"."1.0.2" = self.buildNodePackage {
    name = "junk-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/junk/-/junk-1.0.2.tgz";
      name = "junk-1.0.2.tgz";
      sha1 = "cc71db3c05d53b3238d0f1dec97a88267c10700e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."latest-version"."^1.0.0" =
    self.by-version."latest-version"."1.0.1";
  by-version."latest-version"."1.0.1" = self.buildNodePackage {
    name = "latest-version-1.0.1";
    version = "1.0.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/latest-version/-/latest-version-1.0.1.tgz";
      name = "latest-version-1.0.1.tgz";
      sha1 = "72cfc46e3e8d1be651e1ebb54ea9f6ea96f374bb";
    };
    deps = {
      "package-json-1.2.0" = self.by-version."package-json"."1.2.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lockfile"."^1.0.0" =
    self.by-version."lockfile"."1.0.1";
  by-version."lockfile"."1.0.1" = self.buildNodePackage {
    name = "lockfile-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lockfile/-/lockfile-1.0.1.tgz";
      name = "lockfile-1.0.1.tgz";
      sha1 = "9d353ecfe3f54d150bb57f89d51746935a39c4f5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash".">= 3.2.0 < 4.0.0" =
    self.by-version."lodash"."3.10.0";
  by-version."lodash"."3.10.0" = self.buildNodePackage {
    name = "lodash-3.10.0";
    version = "3.10.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-3.10.0.tgz";
      name = "lodash-3.10.0.tgz";
      sha1 = "93d51c672828a4416a12af57220ba8a8737e2fbb";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash"."^3.3.1" =
    self.by-version."lodash"."3.10.0";
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
  by-spec."lodash._getnative"."^3.0.0" =
    self.by-version."lodash._getnative"."3.9.1";
  by-version."lodash._getnative"."3.9.1" = self.buildNodePackage {
    name = "lodash._getnative-3.9.1";
    version = "3.9.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._getnative/-/lodash._getnative-3.9.1.tgz";
      name = "lodash._getnative-3.9.1.tgz";
      sha1 = "570bc7dede46d61cdcde687d65d3eecbaa3aaff5";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.debounce"."^3.0.1" =
    self.by-version."lodash.debounce"."3.1.1";
  by-version."lodash.debounce"."3.1.1" = self.buildNodePackage {
    name = "lodash.debounce-3.1.1";
    version = "3.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.debounce/-/lodash.debounce-3.1.1.tgz";
      name = "lodash.debounce-3.1.1.tgz";
      sha1 = "812211c378a94cc29d5aa4e3346cf0bfce3a7df5";
    };
    deps = {
      "lodash._getnative-3.9.1" = self.by-version."lodash._getnative"."3.9.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lowercase-keys"."^1.0.0" =
    self.by-version."lowercase-keys"."1.0.0";
  by-version."lowercase-keys"."1.0.0" = self.buildNodePackage {
    name = "lowercase-keys-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lowercase-keys/-/lowercase-keys-1.0.0.tgz";
      name = "lowercase-keys-1.0.0.tgz";
      sha1 = "4e3366b39e7f5457e35f1324bdf6f88d0bfc7306";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-cache"."^2.5.0" =
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
  by-spec."lru-cache"."~2.3.0" =
    self.by-version."lru-cache"."2.3.1";
  by-version."lru-cache"."2.3.1" = self.buildNodePackage {
    name = "lru-cache-2.3.1";
    version = "2.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.3.1.tgz";
      name = "lru-cache-2.3.1.tgz";
      sha1 = "b3adf6b3d856e954e2c390e6cef22081245a53d6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lru-queue"."0.1" =
    self.by-version."lru-queue"."0.1.0";
  by-version."lru-queue"."0.1.0" = self.buildNodePackage {
    name = "lru-queue-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lru-queue/-/lru-queue-0.1.0.tgz";
      name = "lru-queue-0.1.0.tgz";
      sha1 = "2738bd9f0d3cf4f84490c5736c48699ac632cda3";
    };
    deps = {
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."memoizee"."~0.3.8" =
    self.by-version."memoizee"."0.3.8";
  by-version."memoizee"."0.3.8" = self.buildNodePackage {
    name = "memoizee-0.3.8";
    version = "0.3.8";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/memoizee/-/memoizee-0.3.8.tgz";
      name = "memoizee-0.3.8.tgz";
      sha1 = "b5faf419f02fafe3c2cc1cf5d3907c210fc7efdc";
    };
    deps = {
      "d-0.1.1" = self.by-version."d"."0.1.1";
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
      "es6-weak-map-0.1.4" = self.by-version."es6-weak-map"."0.1.4";
      "event-emitter-0.3.3" = self.by-version."event-emitter"."0.3.3";
      "lru-queue-0.1.0" = self.by-version."lru-queue"."0.1.0";
      "next-tick-0.2.2" = self.by-version."next-tick"."0.2.2";
      "timers-ext-0.1.0" = self.by-version."timers-ext"."0.1.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mime"."^1.2.11" =
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
  by-spec."minimatch"."^2.0.1" =
    self.by-version."minimatch"."2.0.9";
  by-version."minimatch"."2.0.9" = self.buildNodePackage {
    name = "minimatch-2.0.9";
    version = "2.0.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/minimatch/-/minimatch-2.0.9.tgz";
      name = "minimatch-2.0.9.tgz";
      sha1 = "4dbebef26f62a35976db0737ea3389641baf9b46";
    };
    deps = {
      "brace-expansion-1.1.0" = self.by-version."brace-expansion"."1.1.0";
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
  by-spec."minimist"."~0.0.7" =
    self.by-version."minimist"."0.0.10";
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
  by-spec."mkdirp".">=0.5 0" =
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
  by-spec."mkdirp"."^0.5.0" =
    self.by-version."mkdirp"."0.5.1";
  by-spec."mkdirp"."~0.3.5" =
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
  by-spec."mkpath"."^0.1.0" =
    self.by-version."mkpath"."0.1.0";
  by-version."mkpath"."0.1.0" = self.buildNodePackage {
    name = "mkpath-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mkpath/-/mkpath-0.1.0.tgz";
      name = "mkpath-0.1.0.tgz";
      sha1 = "7554a6f8d871834cc97b5462b122c4c124d6de91";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mout"."^0.11.0" =
    self.by-version."mout"."0.11.0";
  by-version."mout"."0.11.0" = self.buildNodePackage {
    name = "mout-0.11.0";
    version = "0.11.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mout/-/mout-0.11.0.tgz";
      name = "mout-0.11.0.tgz";
      sha1 = "93cdf0791ac8a24873ceeb42a5b016b7c867abee";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mout"."~0.9.0" =
    self.by-version."mout"."0.9.1";
  by-version."mout"."0.9.1" = self.buildNodePackage {
    name = "mout-0.9.1";
    version = "0.9.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mout/-/mout-0.9.1.tgz";
      name = "mout-0.9.1.tgz";
      sha1 = "84f0f3fd6acc7317f63de2affdcc0cee009b0477";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."mute-stream"."0.0.4" =
    self.by-version."mute-stream"."0.0.4";
  by-version."mute-stream"."0.0.4" = self.buildNodePackage {
    name = "mute-stream-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/mute-stream/-/mute-stream-0.0.4.tgz";
      name = "mute-stream-0.0.4.tgz";
      sha1 = "a9219960a6d5d5d046597aee51252c6655f7177e";
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
  by-spec."nested-error-stacks"."^1.0.0" =
    self.by-version."nested-error-stacks"."1.0.1";
  by-version."nested-error-stacks"."1.0.1" = self.buildNodePackage {
    name = "nested-error-stacks-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/nested-error-stacks/-/nested-error-stacks-1.0.1.tgz";
      name = "nested-error-stacks-1.0.1.tgz";
      sha1 = "d7bb90f2e66069d1f40b9d6e8daa69885ba39173";
    };
    deps = {
      "inherits-2.0.1" = self.by-version."inherits"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."next-tick"."~0.2.2" =
    self.by-version."next-tick"."0.2.2";
  by-version."next-tick"."0.2.2" = self.buildNodePackage {
    name = "next-tick-0.2.2";
    version = "0.2.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/next-tick/-/next-tick-0.2.2.tgz";
      name = "next-tick-0.2.2.tgz";
      sha1 = "75da4a927ee5887e39065880065b7336413b310d";
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
  by-spec."nopt"."^3.0.1" =
    self.by-version."nopt"."3.0.3";
  by-version."nopt"."3.0.3" = self.buildNodePackage {
    name = "nopt-3.0.3";
    version = "3.0.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/nopt/-/nopt-3.0.3.tgz";
      name = "nopt-3.0.3.tgz";
      sha1 = "0e9978f33016bae0b75e3748c03bbbb71da5c530";
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
  by-spec."object-assign"."^2.0.0" =
    self.by-version."object-assign"."2.1.1";
  by-version."object-assign"."2.1.1" = self.buildNodePackage {
    name = "object-assign-2.1.1";
    version = "2.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-assign/-/object-assign-2.1.1.tgz";
      name = "object-assign-2.1.1.tgz";
      sha1 = "43c36e5d569ff8e4816c4efa8be02d26967c18aa";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."object-assign"."^3.0.0" =
    self.by-version."object-assign"."3.0.0";
  by-version."object-assign"."3.0.0" = self.buildNodePackage {
    name = "object-assign-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/object-assign/-/object-assign-3.0.0.tgz";
      name = "object-assign-3.0.0.tgz";
      sha1 = "9bedd5ca0897949bca47e7ff408062d549f587f2";
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
    self.by-version."once"."1.3.2";
  by-version."once"."1.3.2" = self.buildNodePackage {
    name = "once-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/once/-/once-1.3.2.tgz";
      name = "once-1.3.2.tgz";
      sha1 = "d8feeca93b039ec1dcdee7741c92bdac5e28081b";
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
  by-spec."once"."^1.3.1" =
    self.by-version."once"."1.3.2";
  by-spec."once"."~1.3.0" =
    self.by-version."once"."1.3.2";
  by-spec."opn"."^1.0.1" =
    self.by-version."opn"."1.0.2";
  by-version."opn"."1.0.2" = self.buildNodePackage {
    name = "opn-1.0.2";
    version = "1.0.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/opn/-/opn-1.0.2.tgz";
      name = "opn-1.0.2.tgz";
      sha1 = "b909643346d00a1abc977a8b96f3ce3c53d5cf5f";
    };
    deps = {
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
  by-spec."optimist"."~0.6.0" =
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
  by-spec."os-homedir"."^1.0.0" =
    self.by-version."os-homedir"."1.0.0";
  by-version."os-homedir"."1.0.0" = self.buildNodePackage {
    name = "os-homedir-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/os-homedir/-/os-homedir-1.0.0.tgz";
      name = "os-homedir-1.0.0.tgz";
      sha1 = "e37078bc61b5869063053897257e39ec1261b702";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."os-name"."^1.0.0" =
    self.by-version."os-name"."1.0.3";
  by-version."os-name"."1.0.3" = self.buildNodePackage {
    name = "os-name-1.0.3";
    version = "1.0.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/os-name/-/os-name-1.0.3.tgz";
      name = "os-name-1.0.3.tgz";
      sha1 = "1b379f64835af7c5a7f498b357cb95215c159edf";
    };
    deps = {
      "osx-release-1.1.0" = self.by-version."osx-release"."1.1.0";
      "win-release-1.0.0" = self.by-version."win-release"."1.0.0";
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
  by-spec."osenv"."0.0.3" =
    self.by-version."osenv"."0.0.3";
  by-version."osenv"."0.0.3" = self.buildNodePackage {
    name = "osenv-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/osenv/-/osenv-0.0.3.tgz";
      name = "osenv-0.0.3.tgz";
      sha1 = "cd6ad8ddb290915ad9e22765576025d411f29cb6";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."osenv"."^0.1.0" =
    self.by-version."osenv"."0.1.3";
  by-version."osenv"."0.1.3" = self.buildNodePackage {
    name = "osenv-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/osenv/-/osenv-0.1.3.tgz";
      name = "osenv-0.1.3.tgz";
      sha1 = "83cf05c6d6458fc4d5ac6362ea325d92f2754217";
    };
    deps = {
      "os-homedir-1.0.0" = self.by-version."os-homedir"."1.0.0";
      "os-tmpdir-1.0.1" = self.by-version."os-tmpdir"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."osx-release"."^1.0.0" =
    self.by-version."osx-release"."1.1.0";
  by-version."osx-release"."1.1.0" = self.buildNodePackage {
    name = "osx-release-1.1.0";
    version = "1.1.0";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/osx-release/-/osx-release-1.1.0.tgz";
      name = "osx-release-1.1.0.tgz";
      sha1 = "f217911a28136949af1bf9308b241e2737d3cd6c";
    };
    deps = {
      "minimist-1.1.1" = self.by-version."minimist"."1.1.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."p-throttler"."0.1.1" =
    self.by-version."p-throttler"."0.1.1";
  by-version."p-throttler"."0.1.1" = self.buildNodePackage {
    name = "p-throttler-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/p-throttler/-/p-throttler-0.1.1.tgz";
      name = "p-throttler-0.1.1.tgz";
      sha1 = "15246409d225d3eefca85c50de710a83a78cca6a";
    };
    deps = {
      "q-0.9.7" = self.by-version."q"."0.9.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."package-json"."^1.0.0" =
    self.by-version."package-json"."1.2.0";
  by-version."package-json"."1.2.0" = self.buildNodePackage {
    name = "package-json-1.2.0";
    version = "1.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/package-json/-/package-json-1.2.0.tgz";
      name = "package-json-1.2.0.tgz";
      sha1 = "c8ecac094227cdf76a316874ed05e27cc939a0e0";
    };
    deps = {
      "got-3.3.1" = self.by-version."got"."3.3.1";
      "registry-url-3.0.3" = self.by-version."registry-url"."3.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie"."^1.0.0" =
    self.by-version."pinkie"."1.0.0";
  by-version."pinkie"."1.0.0" = self.buildNodePackage {
    name = "pinkie-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie/-/pinkie-1.0.0.tgz";
      name = "pinkie-1.0.0.tgz";
      sha1 = "5a47f28ba1015d0201bda7bf0f358e47bec8c7e4";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pinkie-promise"."^1.0.0" =
    self.by-version."pinkie-promise"."1.0.0";
  by-version."pinkie-promise"."1.0.0" = self.buildNodePackage {
    name = "pinkie-promise-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pinkie-promise/-/pinkie-promise-1.0.0.tgz";
      name = "pinkie-promise-1.0.0.tgz";
      sha1 = "d1da67f5482563bb7cf57f286ae2822ecfbf3670";
    };
    deps = {
      "pinkie-1.0.0" = self.by-version."pinkie"."1.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."prepend-http"."^1.0.0" =
    self.by-version."prepend-http"."1.0.1";
  by-version."prepend-http"."1.0.1" = self.buildNodePackage {
    name = "prepend-http-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/prepend-http/-/prepend-http-1.0.1.tgz";
      name = "prepend-http-1.0.1.tgz";
      sha1 = "5f13dad9a434fa4f346aa51cf03f3cea15fe4eb3";
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
  by-spec."promptly"."0.2.0" =
    self.by-version."promptly"."0.2.0";
  by-version."promptly"."0.2.0" = self.buildNodePackage {
    name = "promptly-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/promptly/-/promptly-0.2.0.tgz";
      name = "promptly-0.2.0.tgz";
      sha1 = "73ef200fa8329d5d3a8df41798950b8646ca46d9";
    };
    deps = {
      "read-1.0.6" = self.by-version."read"."1.0.6";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."pump"."^1.0.0" =
    self.by-version."pump"."1.0.0";
  by-version."pump"."1.0.0" = self.buildNodePackage {
    name = "pump-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/pump/-/pump-1.0.0.tgz";
      name = "pump-1.0.0.tgz";
      sha1 = "f0250fe282742492e4dea170e5ed3f7bc8a5e32c";
    };
    deps = {
      "end-of-stream-1.1.0" = self.by-version."end-of-stream"."1.1.0";
      "once-1.3.2" = self.by-version."once"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."punycode".">=0.2.0" =
    self.by-version."punycode"."1.3.2";
  by-version."punycode"."1.3.2" = self.buildNodePackage {
    name = "punycode-1.3.2";
    version = "1.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/punycode/-/punycode-1.3.2.tgz";
      name = "punycode-1.3.2.tgz";
      sha1 = "9653a036fb7c1ee42342f2325cceefea3926c48d";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."q"."^1.1.2" =
    self.by-version."q"."1.4.1";
  by-version."q"."1.4.1" = self.buildNodePackage {
    name = "q-1.4.1";
    version = "1.4.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/q/-/q-1.4.1.tgz";
      name = "q-1.4.1.tgz";
      sha1 = "55705bcd93c5f3673530c2c2cbc0c2b3addc286e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."q"."~0.9.2" =
    self.by-version."q"."0.9.7";
  by-version."q"."0.9.7" = self.buildNodePackage {
    name = "q-0.9.7";
    version = "0.9.7";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/q/-/q-0.9.7.tgz";
      name = "q-0.9.7.tgz";
      sha1 = "4de2e6cb3b29088c9e4cbc03bf9d42fb96ce2f75";
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
  by-spec."rc"."^1.0.1" =
    self.by-version."rc"."1.0.3";
  by-version."rc"."1.0.3" = self.buildNodePackage {
    name = "rc-1.0.3";
    version = "1.0.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rc/-/rc-1.0.3.tgz";
      name = "rc-1.0.3.tgz";
      sha1 = "51bf28d21f13a9324528a9633460161ad9a39f77";
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
  by-spec."read"."~1.0.4" =
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
  by-spec."read-all-stream"."^3.0.0" =
    self.by-version."read-all-stream"."3.0.1";
  by-version."read-all-stream"."3.0.1" = self.buildNodePackage {
    name = "read-all-stream-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/read-all-stream/-/read-all-stream-3.0.1.tgz";
      name = "read-all-stream-3.0.1.tgz";
      sha1 = "c3701aecd7c911516677590eedea49684c62fa47";
    };
    deps = {
      "pinkie-promise-1.0.0" = self.by-version."pinkie-promise"."1.0.0";
      "readable-stream-2.0.2" = self.by-version."readable-stream"."2.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readable-stream"."^1.1.8" =
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
  by-spec."readable-stream"."^2.0.0" =
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
  by-spec."readable-stream"."~2.0.0" =
    self.by-version."readable-stream"."2.0.2";
  by-spec."readline2"."^0.1.1" =
    self.by-version."readline2"."0.1.1";
  by-version."readline2"."0.1.1" = self.buildNodePackage {
    name = "readline2-0.1.1";
    version = "0.1.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/readline2/-/readline2-0.1.1.tgz";
      name = "readline2-0.1.1.tgz";
      sha1 = "99443ba6e83b830ef3051bfd7dc241a82728d568";
    };
    deps = {
      "mute-stream-0.0.4" = self.by-version."mute-stream"."0.0.4";
      "strip-ansi-2.0.1" = self.by-version."strip-ansi"."2.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."readline2"."~0.1.0" =
    self.by-version."readline2"."0.1.1";
  by-spec."redeyed"."~0.4.0" =
    self.by-version."redeyed"."0.4.4";
  by-version."redeyed"."0.4.4" = self.buildNodePackage {
    name = "redeyed-0.4.4";
    version = "0.4.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/redeyed/-/redeyed-0.4.4.tgz";
      name = "redeyed-0.4.4.tgz";
      sha1 = "37e990a6f2b21b2a11c2e6a48fd4135698cba97f";
    };
    deps = {
      "esprima-1.0.4" = self.by-version."esprima"."1.0.4";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."registry-url"."^3.0.0" =
    self.by-version."registry-url"."3.0.3";
  by-version."registry-url"."3.0.3" = self.buildNodePackage {
    name = "registry-url-3.0.3";
    version = "3.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/registry-url/-/registry-url-3.0.3.tgz";
      name = "registry-url-3.0.3.tgz";
      sha1 = "c9f5102e0fd9c9f250522a7f19f68672c84ccc96";
    };
    deps = {
      "rc-1.0.3" = self.by-version."rc"."1.0.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."2.53.0" =
    self.by-version."request"."2.53.0";
  by-version."request"."2.53.0" = self.buildNodePackage {
    name = "request-2.53.0";
    version = "2.53.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.53.0.tgz";
      name = "request-2.53.0.tgz";
      sha1 = "180a3ae92b7b639802e4f9545dd8fcdeb71d760c";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.9.0" = self.by-version."caseless"."0.9.0";
      "forever-agent-0.5.2" = self.by-version."forever-agent"."0.5.2";
      "form-data-0.2.0" = self.by-version."form-data"."0.2.0";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-2.3.3" = self.by-version."qs"."2.3.3";
      "tunnel-agent-0.4.1" = self.by-version."tunnel-agent"."0.4.1";
      "tough-cookie-2.0.0" = self.by-version."tough-cookie"."2.0.0";
      "http-signature-0.10.1" = self.by-version."http-signature"."0.10.1";
      "oauth-sign-0.6.0" = self.by-version."oauth-sign"."0.6.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
      "aws-sign2-0.5.0" = self.by-version."aws-sign2"."0.5.0";
      "stringstream-0.0.4" = self.by-version."stringstream"."0.0.4";
      "combined-stream-0.0.7" = self.by-version."combined-stream"."0.0.7";
      "isstream-0.1.2" = self.by-version."isstream"."0.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request"."^2.40.0" =
    self.by-version."request"."2.58.0";
  by-version."request"."2.58.0" = self.buildNodePackage {
    name = "request-2.58.0";
    version = "2.58.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request/-/request-2.58.0.tgz";
      name = "request-2.58.0.tgz";
      sha1 = "b5f49c0b94aab7fad388612a1fb6ad03b6cc1580";
    };
    deps = {
      "bl-0.9.4" = self.by-version."bl"."0.9.4";
      "caseless-0.10.0" = self.by-version."caseless"."0.10.0";
      "extend-2.0.1" = self.by-version."extend"."2.0.1";
      "forever-agent-0.6.1" = self.by-version."forever-agent"."0.6.1";
      "form-data-1.0.0-rc1" = self.by-version."form-data"."1.0.0-rc1";
      "json-stringify-safe-5.0.1" = self.by-version."json-stringify-safe"."5.0.1";
      "mime-types-2.0.14" = self.by-version."mime-types"."2.0.14";
      "node-uuid-1.4.3" = self.by-version."node-uuid"."1.4.3";
      "qs-3.1.0" = self.by-version."qs"."3.1.0";
      "tunnel-agent-0.4.1" = self.by-version."tunnel-agent"."0.4.1";
      "tough-cookie-2.0.0" = self.by-version."tough-cookie"."2.0.0";
      "http-signature-0.11.0" = self.by-version."http-signature"."0.11.0";
      "oauth-sign-0.8.0" = self.by-version."oauth-sign"."0.8.0";
      "hawk-2.3.1" = self.by-version."hawk"."2.3.1";
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
      "tunnel-agent-0.4.1" = self.by-version."tunnel-agent"."0.4.1";
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
  by-spec."request-progress"."0.3.1" =
    self.by-version."request-progress"."0.3.1";
  by-version."request-progress"."0.3.1" = self.buildNodePackage {
    name = "request-progress-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request-progress/-/request-progress-0.3.1.tgz";
      name = "request-progress-0.3.1.tgz";
      sha1 = "0721c105d8a96ac6b2ce8b2c89ae2d5ecfcf6b3a";
    };
    deps = {
      "throttleit-0.0.2" = self.by-version."throttleit"."0.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."request-replay"."~0.2.0" =
    self.by-version."request-replay"."0.2.0";
  by-version."request-replay"."0.2.0" = self.buildNodePackage {
    name = "request-replay-0.2.0";
    version = "0.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/request-replay/-/request-replay-0.2.0.tgz";
      name = "request-replay-0.2.0.tgz";
      sha1 = "9b693a5d118b39f5c596ead5ed91a26444057f60";
    };
    deps = {
      "retry-0.6.1" = self.by-version."retry"."0.6.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."retry"."0.6.1" =
    self.by-version."retry"."0.6.1";
  by-version."retry"."0.6.1" = self.buildNodePackage {
    name = "retry-0.6.1";
    version = "0.6.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/retry/-/retry-0.6.1.tgz";
      name = "retry-0.6.1.tgz";
      sha1 = "fdc90eed943fde11b893554b8cc63d0e899ba918";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."retry"."~0.6.0" =
    self.by-version."retry"."0.6.1";
  by-spec."rimraf"."2" =
    self.by-version."rimraf"."2.4.1";
  by-version."rimraf"."2.4.1" = self.buildNodePackage {
    name = "rimraf-2.4.1";
    version = "2.4.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/rimraf/-/rimraf-2.4.1.tgz";
      name = "rimraf-2.4.1.tgz";
      sha1 = "99ff3cc1d61d687b67489b9f97cfa9d3db3b9e48";
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
  by-spec."rimraf"."^2.2.8" =
    self.by-version."rimraf"."2.4.1";
  by-spec."rimraf"."~2.2.0" =
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
  by-spec."rx"."^2.2.27" =
    self.by-version."rx"."2.5.3";
  by-version."rx"."2.5.3" = self.buildNodePackage {
    name = "rx-2.5.3";
    version = "2.5.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/rx/-/rx-2.5.3.tgz";
      name = "rx-2.5.3.tgz";
      sha1 = "21adc7d80f02002af50dae97fd9dbf248755f566";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."rx"."^2.4.3" =
    self.by-version."rx"."2.5.3";
  by-spec."semver"."^2.3.0" =
    self.by-version."semver"."2.3.2";
  by-version."semver"."2.3.2" = self.buildNodePackage {
    name = "semver-2.3.2";
    version = "2.3.2";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver/-/semver-2.3.2.tgz";
      name = "semver-2.3.2.tgz";
      sha1 = "b9848f25d6cf36333073ec9ef8856d42f1233e52";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."semver-diff"."^2.0.0" =
    self.by-version."semver-diff"."2.0.0";
  by-version."semver-diff"."2.0.0" = self.buildNodePackage {
    name = "semver-diff-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/semver-diff/-/semver-diff-2.0.0.tgz";
      name = "semver-diff-2.0.0.tgz";
      sha1 = "d43024f91aa7843937dc1379002766809f7480d2";
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
  by-spec."shell-quote"."^1.4.2" =
    self.by-version."shell-quote"."1.4.3";
  by-version."shell-quote"."1.4.3" = self.buildNodePackage {
    name = "shell-quote-1.4.3";
    version = "1.4.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/shell-quote/-/shell-quote-1.4.3.tgz";
      name = "shell-quote-1.4.3.tgz";
      sha1 = "952c44e0b1ed9013ef53958179cc643e8777466b";
    };
    deps = {
      "jsonify-0.0.0" = self.by-version."jsonify"."0.0.0";
      "array-filter-0.0.1" = self.by-version."array-filter"."0.0.1";
      "array-reduce-0.0.0" = self.by-version."array-reduce"."0.0.0";
      "array-map-0.0.0" = self.by-version."array-map"."0.0.0";
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
  by-spec."sprintf-js"."~1.0.2" =
    self.by-version."sprintf-js"."1.0.3";
  by-version."sprintf-js"."1.0.3" = self.buildNodePackage {
    name = "sprintf-js-1.0.3";
    version = "1.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/sprintf-js/-/sprintf-js-1.0.3.tgz";
      name = "sprintf-js-1.0.3.tgz";
      sha1 = "04e6926f662895354f3dd015203633b857297e2c";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."string-length"."^1.0.0" =
    self.by-version."string-length"."1.0.1";
  by-version."string-length"."1.0.1" = self.buildNodePackage {
    name = "string-length-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/string-length/-/string-length-1.0.1.tgz";
      name = "string-length-1.0.1.tgz";
      sha1 = "56970fb1c38558e9e70b728bf3de269ac45adfac";
    };
    deps = {
      "strip-ansi-3.0.0" = self.by-version."strip-ansi"."3.0.0";
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
  by-spec."stringify-object"."^1.0.0" =
    self.by-version."stringify-object"."1.0.1";
  by-version."stringify-object"."1.0.1" = self.buildNodePackage {
    name = "stringify-object-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/stringify-object/-/stringify-object-1.0.1.tgz";
      name = "stringify-object-1.0.1.tgz";
      sha1 = "86d35e7dbfbce9aa45637d7ecdd7847e159db8a2";
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
  by-spec."strip-json-comments"."0.1.x" =
    self.by-version."strip-json-comments"."0.1.3";
  by-version."strip-json-comments"."0.1.3" = self.buildNodePackage {
    name = "strip-json-comments-0.1.3";
    version = "0.1.3";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/strip-json-comments/-/strip-json-comments-0.1.3.tgz";
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
  by-spec."tar-fs"."^1.4.1" =
    self.by-version."tar-fs"."1.7.0";
  by-version."tar-fs"."1.7.0" = self.buildNodePackage {
    name = "tar-fs-1.7.0";
    version = "1.7.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tar-fs/-/tar-fs-1.7.0.tgz";
      name = "tar-fs-1.7.0.tgz";
      sha1 = "3fbc987242234603c9a07811e19f01fd0d774b47";
    };
    deps = {
      "mkdirp-0.5.1" = self.by-version."mkdirp"."0.5.1";
      "pump-1.0.0" = self.by-version."pump"."1.0.0";
      "tar-stream-1.2.1" = self.by-version."tar-stream"."1.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tar-stream"."^1.1.2" =
    self.by-version."tar-stream"."1.2.1";
  by-version."tar-stream"."1.2.1" = self.buildNodePackage {
    name = "tar-stream-1.2.1";
    version = "1.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tar-stream/-/tar-stream-1.2.1.tgz";
      name = "tar-stream-1.2.1.tgz";
      sha1 = "7b09e93b93f02bce74f060d5f2146ac7cccf6021";
    };
    deps = {
      "bl-1.0.0" = self.by-version."bl"."1.0.0";
      "end-of-stream-1.1.0" = self.by-version."end-of-stream"."1.1.0";
      "readable-stream-2.0.2" = self.by-version."readable-stream"."2.0.2";
      "xtend-4.0.0" = self.by-version."xtend"."4.0.0";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."throttleit"."~0.0.2" =
    self.by-version."throttleit"."0.0.2";
  by-version."throttleit"."0.0.2" = self.buildNodePackage {
    name = "throttleit-0.0.2";
    version = "0.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/throttleit/-/throttleit-0.0.2.tgz";
      name = "throttleit-0.0.2.tgz";
      sha1 = "cfedf88e60c00dd9697b61fdd2a8343a9b680eaf";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."through"."^2.3.6" =
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
  by-spec."through"."~2.3.4" =
    self.by-version."through"."2.3.8";
  by-spec."timed-out"."^2.0.0" =
    self.by-version."timed-out"."2.0.0";
  by-version."timed-out"."2.0.0" = self.buildNodePackage {
    name = "timed-out-2.0.0";
    version = "2.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/timed-out/-/timed-out-2.0.0.tgz";
      name = "timed-out-2.0.0.tgz";
      sha1 = "f38b0ae81d3747d628001f41dafc652ace671c0a";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."timers-ext"."0.1" =
    self.by-version."timers-ext"."0.1.0";
  by-version."timers-ext"."0.1.0" = self.buildNodePackage {
    name = "timers-ext-0.1.0";
    version = "0.1.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/timers-ext/-/timers-ext-0.1.0.tgz";
      name = "timers-ext-0.1.0.tgz";
      sha1 = "00345a2ca93089d1251322054389d263e27b77e2";
    };
    deps = {
      "es5-ext-0.10.7" = self.by-version."es5-ext"."0.10.7";
      "next-tick-0.2.2" = self.by-version."next-tick"."0.2.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."tmp"."0.0.24" =
    self.by-version."tmp"."0.0.24";
  by-version."tmp"."0.0.24" = self.buildNodePackage {
    name = "tmp-0.0.24";
    version = "0.0.24";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tmp/-/tmp-0.0.24.tgz";
      name = "tmp-0.0.24.tgz";
      sha1 = "d6a5e198d14a9835cc6f2d7c3d9e302428c8cf12";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."touch"."0.0.3" =
    self.by-version."touch"."0.0.3";
  by-version."touch"."0.0.3" = self.buildNodePackage {
    name = "touch-0.0.3";
    version = "0.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/touch/-/touch-0.0.3.tgz";
      name = "touch-0.0.3.tgz";
      sha1 = "51aef3d449571d4f287a5d87c9c8b49181a0db1d";
    };
    deps = {
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
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
  by-spec."tough-cookie"."^0.12.1" =
    self.by-version."tough-cookie"."0.12.1";
  by-version."tough-cookie"."0.12.1" = self.buildNodePackage {
    name = "tough-cookie-0.12.1";
    version = "0.12.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/tough-cookie/-/tough-cookie-0.12.1.tgz";
      name = "tough-cookie-0.12.1.tgz";
      sha1 = "8220c7e21abd5b13d96804254bd5a81ebf2c7d62";
    };
    deps = {
      "punycode-1.3.2" = self.by-version."punycode"."1.3.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."traverse".">=0.3.0 <0.4" =
    self.by-version."traverse"."0.3.9";
  by-version."traverse"."0.3.9" = self.buildNodePackage {
    name = "traverse-0.3.9";
    version = "0.3.9";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/traverse/-/traverse-0.3.9.tgz";
      name = "traverse-0.3.9.tgz";
      sha1 = "717b8f220cc0bb7b44e40514c22b2e8bbc70d8b9";
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
  by-spec."update-notifier"."^0.3.0" =
    self.by-version."update-notifier"."0.3.2";
  by-version."update-notifier"."0.3.2" = self.buildNodePackage {
    name = "update-notifier-0.3.2";
    version = "0.3.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/update-notifier/-/update-notifier-0.3.2.tgz";
      name = "update-notifier-0.3.2.tgz";
      sha1 = "22a8735baadef3320e2db928f693da898dc87777";
    };
    deps = {
      "chalk-1.1.0" = self.by-version."chalk"."1.1.0";
      "configstore-0.3.2" = self.by-version."configstore"."0.3.2";
      "is-npm-1.0.0" = self.by-version."is-npm"."1.0.0";
      "latest-version-1.0.1" = self.by-version."latest-version"."1.0.1";
      "semver-diff-2.0.0" = self.by-version."semver-diff"."2.0.0";
      "string-length-1.0.1" = self.by-version."string-length"."1.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."user-home"."^1.0.0" =
    self.by-version."user-home"."1.1.1";
  by-version."user-home"."1.1.1" = self.buildNodePackage {
    name = "user-home-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/user-home/-/user-home-1.1.1.tgz";
      name = "user-home-1.1.1.tgz";
      sha1 = "2b5be23a32b63a7c9deb8d0f28d485724a3df190";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."user-home"."^1.1.0" =
    self.by-version."user-home"."1.1.1";
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
  by-spec."uuid"."^2.0.1" =
    self.by-version."uuid"."2.0.1";
  by-version."uuid"."2.0.1" = self.buildNodePackage {
    name = "uuid-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/uuid/-/uuid-2.0.1.tgz";
      name = "uuid-2.0.1.tgz";
      sha1 = "c2a30dedb3e535d72ccf82e343941a50ba8533ac";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."which"."^1.0.8" =
    self.by-version."which"."1.1.1";
  by-version."which"."1.1.1" = self.buildNodePackage {
    name = "which-1.1.1";
    version = "1.1.1";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/which/-/which-1.1.1.tgz";
      name = "which-1.1.1.tgz";
      sha1 = "9ce512459946166e12c083f08ec073380fc8cbbb";
    };
    deps = {
      "is-absolute-0.1.7" = self.by-version."is-absolute"."0.1.7";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."win-release"."^1.0.0" =
    self.by-version."win-release"."1.0.0";
  by-version."win-release"."1.0.0" = self.buildNodePackage {
    name = "win-release-1.0.0";
    version = "1.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/win-release/-/win-release-1.0.0.tgz";
      name = "win-release-1.0.0.tgz";
      sha1 = "8993308dedbd8d30ad5594b6b7382a8c1d96ae5a";
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
  by-spec."xdg-basedir"."^1.0.0" =
    self.by-version."xdg-basedir"."1.0.1";
  by-version."xdg-basedir"."1.0.1" = self.buildNodePackage {
    name = "xdg-basedir-1.0.1";
    version = "1.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/xdg-basedir/-/xdg-basedir-1.0.1.tgz";
      name = "xdg-basedir-1.0.1.tgz";
      sha1 = "14ff8f63a4fdbcb05d5b6eea22b36f3033b9f04e";
    };
    deps = {
      "user-home-1.1.1" = self.by-version."user-home"."1.1.1";
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
}

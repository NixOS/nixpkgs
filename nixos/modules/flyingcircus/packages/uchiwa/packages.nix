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
  by-spec."bower"."^1.3.4" =
    self.by-version."bower"."1.7.7";
  by-version."bower"."1.7.7" = self.buildNodePackage {
    name = "bower-1.7.7";
    version = "1.7.7";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/bower/-/bower-1.7.7.tgz";
      name = "bower-1.7.7.tgz";
      sha1 = "2fd7ff3ebdcba5a8ffcd84c397c8fdfe9f825f92";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "bower" = self.by-version."bower"."1.7.7";
  by-spec."cache-breaker"."0.0.4" =
    self.by-version."cache-breaker"."0.0.4";
  by-version."cache-breaker"."0.0.4" = self.buildNodePackage {
    name = "cache-breaker-0.0.4";
    version = "0.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/cache-breaker/-/cache-breaker-0.0.4.tgz";
      name = "cache-breaker-0.0.4.tgz";
      sha1 = "eb2aa3fbd7d7252beb8181318e61f25983d075e5";
    };
    deps = {
      "lodash-2.2.1" = self.by-version."lodash"."2.2.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
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
  by-spec."findup-sync"."~0.1.0" =
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
  by-spec."findup-sync"."~0.1.2" =
    self.by-version."findup-sync"."0.1.3";
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
      "inherits-1.0.2" = self.by-version."inherits"."1.0.2";
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
  by-spec."grunt"."^0.4.5" =
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
      "grunt-legacy-log-0.1.3" = self.by-version."grunt-legacy-log"."0.1.3";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "grunt" = self.by-version."grunt"."0.4.5";
  by-spec."grunt-cache-breaker"."^2.0.1" =
    self.by-version."grunt-cache-breaker"."2.0.1";
  by-version."grunt-cache-breaker"."2.0.1" = self.buildNodePackage {
    name = "grunt-cache-breaker-2.0.1";
    version = "2.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-cache-breaker/-/grunt-cache-breaker-2.0.1.tgz";
      name = "grunt-cache-breaker-2.0.1.tgz";
      sha1 = "f93159979be32b4c51e9c45374973d3e79479563";
    };
    deps = {
      "cache-breaker-0.0.4" = self.by-version."cache-breaker"."0.0.4";
      "lodash.clonedeep-3.0.2" = self.by-version."lodash.clonedeep"."3.0.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "grunt-cache-breaker" = self.by-version."grunt-cache-breaker"."2.0.1";
  by-spec."grunt-cli"."^0.1.13" =
    self.by-version."grunt-cli"."0.1.13";
  by-version."grunt-cli"."0.1.13" = self.buildNodePackage {
    name = "grunt-cli-0.1.13";
    version = "0.1.13";
    bin = true;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-cli/-/grunt-cli-0.1.13.tgz";
      name = "grunt-cli-0.1.13.tgz";
      sha1 = "e9ebc4047631f5012d922770c39378133cad10f4";
    };
    deps = {
      "nopt-1.0.10" = self.by-version."nopt"."1.0.10";
      "findup-sync-0.1.3" = self.by-version."findup-sync"."0.1.3";
      "resolve-0.3.1" = self.by-version."resolve"."0.3.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  "grunt-cli" = self.by-version."grunt-cli"."0.1.13";
  by-spec."grunt-legacy-log"."~0.1.0" =
    self.by-version."grunt-legacy-log"."0.1.3";
  by-version."grunt-legacy-log"."0.1.3" = self.buildNodePackage {
    name = "grunt-legacy-log-0.1.3";
    version = "0.1.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/grunt-legacy-log/-/grunt-legacy-log-0.1.3.tgz";
      name = "grunt-legacy-log-0.1.3.tgz";
      sha1 = "ec29426e803021af59029f87d2f9cd7335a05531";
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
  by-spec."grunt-legacy-log-utils"."~0.1.1" =
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
  by-spec."inherits"."1" =
    self.by-version."inherits"."1.0.2";
  by-version."inherits"."1.0.2" = self.buildNodePackage {
    name = "inherits-1.0.2";
    version = "1.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/inherits/-/inherits-1.0.2.tgz";
      name = "inherits-1.0.2.tgz";
      sha1 = "ca4309dadee6b54cc0b8d247e8d7c7a0975bdc9b";
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
  by-spec."lodash"."2.2.1" =
    self.by-version."lodash"."2.2.1";
  by-version."lodash"."2.2.1" = self.buildNodePackage {
    name = "lodash-2.2.1";
    version = "2.2.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash/-/lodash-2.2.1.tgz";
      name = "lodash-2.2.1.tgz";
      sha1 = "ca935fd14ab3c0c872abacf198b9cda501440867";
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
  by-spec."lodash._arraycopy"."^3.0.0" =
    self.by-version."lodash._arraycopy"."3.0.0";
  by-version."lodash._arraycopy"."3.0.0" = self.buildNodePackage {
    name = "lodash._arraycopy-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._arraycopy/-/lodash._arraycopy-3.0.0.tgz";
      name = "lodash._arraycopy-3.0.0.tgz";
      sha1 = "76e7b7c1f1fb92547374878a562ed06a3e50f6e1";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._arrayeach"."^3.0.0" =
    self.by-version."lodash._arrayeach"."3.0.0";
  by-version."lodash._arrayeach"."3.0.0" = self.buildNodePackage {
    name = "lodash._arrayeach-3.0.0";
    version = "3.0.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._arrayeach/-/lodash._arrayeach-3.0.0.tgz";
      name = "lodash._arrayeach-3.0.0.tgz";
      sha1 = "bab156b2a90d3f1bbd5c653403349e5e5933ef9e";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._baseassign"."^3.0.0" =
    self.by-version."lodash._baseassign"."3.2.0";
  by-version."lodash._baseassign"."3.2.0" = self.buildNodePackage {
    name = "lodash._baseassign-3.2.0";
    version = "3.2.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._baseassign/-/lodash._baseassign-3.2.0.tgz";
      name = "lodash._baseassign-3.2.0.tgz";
      sha1 = "8c38a099500f215ad09e59f1722fd0c52bfe0a4e";
    };
    deps = {
      "lodash._basecopy-3.0.1" = self.by-version."lodash._basecopy"."3.0.1";
      "lodash.keys-3.1.2" = self.by-version."lodash.keys"."3.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._baseclone"."^3.0.0" =
    self.by-version."lodash._baseclone"."3.3.0";
  by-version."lodash._baseclone"."3.3.0" = self.buildNodePackage {
    name = "lodash._baseclone-3.3.0";
    version = "3.3.0";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._baseclone/-/lodash._baseclone-3.3.0.tgz";
      name = "lodash._baseclone-3.3.0.tgz";
      sha1 = "303519bf6393fe7e42f34d8b630ef7794e3542b7";
    };
    deps = {
      "lodash._arraycopy-3.0.0" = self.by-version."lodash._arraycopy"."3.0.0";
      "lodash._arrayeach-3.0.0" = self.by-version."lodash._arrayeach"."3.0.0";
      "lodash._baseassign-3.2.0" = self.by-version."lodash._baseassign"."3.2.0";
      "lodash._basefor-3.0.3" = self.by-version."lodash._basefor"."3.0.3";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
      "lodash.keys-3.1.2" = self.by-version."lodash.keys"."3.1.2";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._basecopy"."^3.0.0" =
    self.by-version."lodash._basecopy"."3.0.1";
  by-version."lodash._basecopy"."3.0.1" = self.buildNodePackage {
    name = "lodash._basecopy-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._basecopy/-/lodash._basecopy-3.0.1.tgz";
      name = "lodash._basecopy-3.0.1.tgz";
      sha1 = "8da0e6a876cf344c0ad8a54882111dd3c5c7ca36";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._basefor"."^3.0.0" =
    self.by-version."lodash._basefor"."3.0.3";
  by-version."lodash._basefor"."3.0.3" = self.buildNodePackage {
    name = "lodash._basefor-3.0.3";
    version = "3.0.3";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._basefor/-/lodash._basefor-3.0.3.tgz";
      name = "lodash._basefor-3.0.3.tgz";
      sha1 = "7550b4e9218ef09fad24343b612021c79b4c20c2";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash._bindcallback"."^3.0.0" =
    self.by-version."lodash._bindcallback"."3.0.1";
  by-version."lodash._bindcallback"."3.0.1" = self.buildNodePackage {
    name = "lodash._bindcallback-3.0.1";
    version = "3.0.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash._bindcallback/-/lodash._bindcallback-3.0.1.tgz";
      name = "lodash._bindcallback-3.0.1.tgz";
      sha1 = "e531c27644cf8b57a99e17ed95b35c748789392e";
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
  by-spec."lodash.clonedeep"."^3.0.2" =
    self.by-version."lodash.clonedeep"."3.0.2";
  by-version."lodash.clonedeep"."3.0.2" = self.buildNodePackage {
    name = "lodash.clonedeep-3.0.2";
    version = "3.0.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.clonedeep/-/lodash.clonedeep-3.0.2.tgz";
      name = "lodash.clonedeep-3.0.2.tgz";
      sha1 = "a0a1e40d82a5ea89ff5b147b8444ed63d92827db";
    };
    deps = {
      "lodash._baseclone-3.3.0" = self.by-version."lodash._baseclone"."3.3.0";
      "lodash._bindcallback-3.0.1" = self.by-version."lodash._bindcallback"."3.0.1";
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.isarguments"."^3.0.0" =
    self.by-version."lodash.isarguments"."3.0.6";
  by-version."lodash.isarguments"."3.0.6" = self.buildNodePackage {
    name = "lodash.isarguments-3.0.6";
    version = "3.0.6";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.isarguments/-/lodash.isarguments-3.0.6.tgz";
      name = "lodash.isarguments-3.0.6.tgz";
      sha1 = "5dcaf8555b3ccd0afb15812b9819ec68ca098206";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.isarray"."^3.0.0" =
    self.by-version."lodash.isarray"."3.0.4";
  by-version."lodash.isarray"."3.0.4" = self.buildNodePackage {
    name = "lodash.isarray-3.0.4";
    version = "3.0.4";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.isarray/-/lodash.isarray-3.0.4.tgz";
      name = "lodash.isarray-3.0.4.tgz";
      sha1 = "79e4eb88c36a8122af86f844aa9bcd851b5fbb55";
    };
    deps = {
    };
    optionalDependencies = {
    };
    peerDependencies = [];
    os = [ ];
    cpu = [ ];
  };
  by-spec."lodash.keys"."^3.0.0" =
    self.by-version."lodash.keys"."3.1.2";
  by-version."lodash.keys"."3.1.2" = self.buildNodePackage {
    name = "lodash.keys-3.1.2";
    version = "3.1.2";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/lodash.keys/-/lodash.keys-3.1.2.tgz";
      name = "lodash.keys-3.1.2.tgz";
      sha1 = "4dbc0472b156be50a0b286855d1bd0b0c656098a";
    };
    deps = {
      "lodash._getnative-3.9.1" = self.by-version."lodash._getnative"."3.9.1";
      "lodash.isarguments-3.0.6" = self.by-version."lodash.isarguments"."3.0.6";
      "lodash.isarray-3.0.4" = self.by-version."lodash.isarray"."3.0.4";
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
      url = "http://registry.npmjs.org/lru-cache/-/lru-cache-2.7.3.tgz";
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
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
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
      "lru-cache-2.7.3" = self.by-version."lru-cache"."2.7.3";
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
  by-spec."resolve"."~0.3.1" =
    self.by-version."resolve"."0.3.1";
  by-version."resolve"."0.3.1" = self.buildNodePackage {
    name = "resolve-0.3.1";
    version = "0.3.1";
    bin = false;
    src = fetchurl {
      url = "http://registry.npmjs.org/resolve/-/resolve-0.3.1.tgz";
      name = "resolve-0.3.1.tgz";
      sha1 = "34c63447c664c70598d1c9b126fc43b2a24310a4";
    };
    deps = {
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
}

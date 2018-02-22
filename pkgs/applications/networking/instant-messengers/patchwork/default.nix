{ stdenv, writeScriptBin, path, fetchurl, fetchFromGitHub
, nodejs-8_x, yarn, python, electron }:

with builtins;

let
  version = "3.8.10";

  nodejs = nodejs-8_x;

  yarn2nix = (import (fetchFromGitHub {
    owner = "moretea";
    repo = "yarn2nix";
    rev = "d6e05a521bd92b2647bb7e853363d234f21b2cfd";
    sha256 = "1nvpii9p41vrb6zvr8rqcvmycrl6lnzzaif85qj1aavizncgb4wy";
  }) {
    inherit nodejs;
    pkgs = import path {};
    yarn = yarn.override { inherit nodejs; };
  });

  nodeHeaders = fetchurl {
    url = "https://nodejs.org/download/release/v${nodejs.version}/node-v${nodejs.version}-headers.tar.gz";
    sha256 = "1993kcghzr56zmw5sdj8wr8c42mna25806bcjknfxnh62zl4hwpg";
  };

  patchworkSource = fetchFromGitHub {
    owner = "ssbc";
    repo = "patchwork";
    rev = "v${version}";
    sha256 = "16h9ylmlhbszixya5bxm3n6fpdc9gv9zxp0jdr4jd32lr9n3gjbr";
  };

  patchwork = yarn2nix.mkYarnPackage {
    name = "patchwork-${version}";
    src = patchworkSource;
    packageJson = "${patchworkSource}/package.json";
    yarnLock = ./yarn.lock;
    pkgConfig = {
      leveldown = {
        buildInputs = [ python ];
        postInstall = ''
          node ../node-gyp/bin/node-gyp.js rebuild --build-from-source --tarball=${nodeHeaders}
        '';
      };
      "@paulcbetts/spellchecker" = {
        buildInputs = [ python ];
        postInstall = ''
          node ../../node-gyp/bin/node-gyp.js rebuild --build-from-source --tarball=${nodeHeaders}
        '';
      };
    };
  };

  startupScript = writeScriptBin "patchwork" ''
    #! ${stdenv.shell}

    set -ex
    export APP_ROOT_PATH=${patchwork}/node_modules/ssb-patchwork
    exec ${electron}/bin/electron ${patchwork}/node_modules/ssb-patchwork/index.js
  '';
in stdenv.mkDerivation {
  name = "patchwork";
  src = patchwork;

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${startupScript}/bin/patchwork $out/bin/patchwork
  '';
}

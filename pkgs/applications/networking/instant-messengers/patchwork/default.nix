{ stdenv, writeScriptBin, path, fetchurl, fetchFromGitHub
, nodejs-8_x, yarn, mkYarnPackage, python, electron }:

with builtins;

let
  version = "3.8.10";

  nodejs = nodejs-8_x;

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

  patchwork = mkYarnPackage {
    name = "patchwork-${version}";
    src = patchworkSource;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;
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

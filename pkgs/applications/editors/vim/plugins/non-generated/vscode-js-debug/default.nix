{
  pkgs,
  nodejs_20,
  fetchFromGitHub,
  vimUtils,
  system
}:
let

  nodejs = nodejs_20;
  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode-js-debug";
    rev = "v1.100.0";
    sha256 = "sha256-y3N54lOTI9IdRv2WgZd1e7ntUHh/qd9ybIi7Copd/wA=";
  };
  srcDeps = fetchFromGitHub {
    owner = "relief-melone";
    repo = "vscode-js-debug-nixpkgs-dependencies";
    rev = "v1.100.0";
    sha256 = "sha256-gWS01tlFVyV7/VCsR1TJkaosdmcsFQI5tyUwheFnuVM=";
  };

  def = import ./dependencies/default.nix;

  nodePkgs = def { inherit system nodejs pkgs; };
  nodeDependencies = ( nodePkgs // { }).nodeDependencies;

in
vimUtils.buildVimPlugin {
  inherit src;
  inherit nodeDependencies;

  pname = "vscode-js-debug";
  version = "v1.100.0";

  nativeBuildInputs = [ nodejs ];

  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules

    export PATH="${nodeDependencies}/bin:$PATH"
    export XDG_CACHE_HOME=$(pwd)/node-gyp-cache

    npx gulp dapDebugServer

    mv ./dist out
  '';
}

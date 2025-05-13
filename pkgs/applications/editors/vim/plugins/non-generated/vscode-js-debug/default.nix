{
  pkgs,
  nodejs_20,
  buildNpmPackage,
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

  nodePackage = buildNpmPackage (finalAttrs: {
    inherit src;

    pname = "vscode-js-debug";
    version = "v1.100.0";

    npmDepsHash = "sha256-4SweyCohiTAMhGFwqmtQtmyic3/34azMTou6vpM2Bqo=";
    npmPackFlags = [ "--ignore-scripts" "--legacy-peer-deps" ];
    makeCacheWritable = true;

    NODE_OPTIONS = "--openssl-legacy-provider";
  });

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
    ln -s ${nodePackage}/lib/node_modules ./node_modules

    export PATH="${nodePackage}/bin:$PATH"
    export XDG_CACHE_HOME=$(pwd)/node-gyp-cache

    npx gulp dapDebugServer

    mv ./dist out
  '';
}

{
  crystal,
  crystal2nix,
  _experimental-update-script-combinators,
  fetchFromGitHub,
  fetchurl,
  fetchzip,
  gitUpdater,
  lib,
  lz4,
  runCommand,
  versionCheckHook,
  writeShellScript,
}:
let
  # https://github.com/cloudamqp/lavinmq/blob/0dd2d59dae7f8e1cf921955fb7c8246f385592a1/Makefile#L64-L83
  chartjs = fetchzip {
    url = "https://github.com/chartjs/Chart.js/releases/download/v4.0.1/chart.js-4.0.1.tgz";
    hash = "sha256-0fyXDf+pBvZCN/Id+C9E3ruDhZEgdigKW7QQcrmAWTI=";
  };

  luxonjs = fetchurl {
    # Upstream utilizes non-reproducible URL.
    url = "https://cdn.jsdelivr.net/npm/luxon@3.7.1/build/es6/luxon.js";
    hash = "sha256-Empw8npRVYV9yVccXPw9lLu/B2IozEjnBiDEtmYR3PI=";
  };

  chartjs-adapter-luxon = fetchurl {
    url = "https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon@1.3.1/dist/chartjs-adapter-luxon.esm.js";
    hash = "sha256-+gI2T3FxkaSAZyFar5/5O1T/UuLeZHBCcHQuHRXRtt8=";
  };

  elements-js = fetchurl {
    url = "https://unpkg.com/@stoplight/elements@8.2.0/web-components.min.js";
    hash = "sha256-WYhi2m1VF2nrrZ1h1OMDdTXeVzoT0+C9He1MX8ZcWIU=";
  };

  elements-css = fetchurl {
    url = "https://unpkg.com/@stoplight/elements@8.2.0/styles.min.css";
    hash = "sha256-EZeE4j/8Obb6P9s9+T85H4JQ6K8UG3jfw7a+2GB5+Ts=";
  };
in
crystal.buildCrystalPackage rec {
  pname = "lavinmq";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "cloudamqp";
    repo = "lavinmq";
    tag = "v${version}";
    hash = "sha256-yIoc4egajF0AJUUIgDSCPddLncFPhHUa71i9GK7AJq0=";
  };

  buildInputs = [ lz4 ];

  format = "shards";
  shardsFile = ./shards.nix;

  crystalBinaries =
    lib.genAttrs
      (p: {
        src = "src/${p}.cr";
      })
      [
        "lavinmq"
        "lavinmqctl"
        "lavinmqperf"
      ];

  options = [
    "--release"
    "--progress"
    "--no-debug"
    "--verbose"

    # https://github.com/cloudamqp/lavinmq/blob/0dd2d59dae7f8e1cf921955fb7c8246f385592a1/Makefile#L10
    "-Dpreview_mt"
    "-Dexecution_context"
  ];

  preBuild = ''
    mkdir -p static/js/lib/chunks
    cp ${chartjs}/dist/chart.js static/js/lib
    cp ${chartjs}/dist/chunks/helpers.segment.js static/js/lib/chunks
    cp ${luxonjs} static/js/lib/luxon.js

    cp ${chartjs-adapter-luxon} static/js/lib/chartjs-adapter-luxon.esm.js
    sed -i''' -e "s|\(import { _adapters } from\).*|\1 './chart.js'|; s|\(import { DateTime } from\).*|\1 './luxon.js'|" \
      static/js/lib/chartjs-adapter-luxon.esm.js

    cp ${elements-js} static/js/lib/web-components.min.js
    cp ${elements-css} static/js/lib/styles.min.css
  '';

  # Tests are flaky
  doCheck = false;

  # Default installCheckPhase fails.
  installCheckPhase = "";
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater {
        rev-prefix = "v";
        ignoredVersions = "-";
      })
      (_experimental-update-script-combinators.copyAttrOutputToFile "lavinmq.shardLock" "./shard.lock")
      {
        command = [
          (writeShellScript "update-lock" "${lib.getExe crystal2nix}; mv shards.nix $1")
          ./.
        ];
        supportedFeatures = [ "silent" ];
      }
      {
        command = [
          "rm"
          "./shard.lock"
        ];
        supportedFeatures = [ "silent" ];
      }
    ];

    shardLock = runCommand "shard.lock" { } ''
      cp ${src}/shard.lock $out
    '';
  };

  meta = {
    description = "Ultra quick message queue and streaming server";
    homepage = "https://github.com/cloudamqp/lavinmq";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ivan770 ];
    mainProgram = "lavinmq";
  };
}

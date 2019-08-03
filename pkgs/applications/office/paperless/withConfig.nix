{ paperless, lib, writers }:

## Usage
#
# nix-build --out-link ./paperless -E '
# (import <nixpkgs> {}).paperless.withConfig {
#   dataDir = /tmp/paperless-data;
#   config = {
#     PAPERLESS_DISABLE_LOGIN = "true";
#   };
# }'
#
# Setup DB
# ./paperless migrate
#
# Consume documents in ${dataDir}/consume
# ./paperless document_consumer --oneshot
#
# Start web interface
# ./paperless runserver --noreload localhost:8000

{ config ? {}, dataDir ? null, ocrLanguages ? null
, paperlessPkg ? paperless, extraCmds ? "" }:
with lib;
let
  paperless = if ocrLanguages == null then
    paperlessPkg
  else
    (paperlessPkg.override {
      tesseract = paperlessPkg.tesseract.override {
        enableLanguages = ocrLanguages;
      };
    }).overrideDerivation (_: {
      # `ocrLanguages` might be missing some languages required by the tests.
      doCheck = false;
    });

  envVars = (optionalAttrs (dataDir != null) {
    PAPERLESS_CONSUMPTION_DIR = "${dataDir}/consume";
    PAPERLESS_MEDIADIR = "${dataDir}/media";
    PAPERLESS_STATICDIR = "${dataDir}/static";
    PAPERLESS_DBDIR = "${dataDir}";
  }) // config;

  envVarDefs = mapAttrsToList (n: v: ''export ${n}="${toString v}"'') envVars;
  setupEnvVars = builtins.concatStringsSep "\n" envVarDefs;

  setupEnv = ''
    source ${paperless}/share/paperless/setup-env.sh
    ${setupEnvVars}
    ${optionalString (dataDir != null) ''
      mkdir -p "$PAPERLESS_CONSUMPTION_DIR" \
               "$PAPERLESS_MEDIADIR" \
               "$PAPERLESS_STATICDIR" \
               "$PAPERLESS_DBDIR"
    ''}
  '';

  runPaperless = writers.writeBash "paperless" ''
    set -e
    ${setupEnv}
    ${extraCmds}
    exec python $paperlessSrc/manage.py "$@"
  '';
in
  runPaperless // {
    inherit paperless setupEnv;
  }

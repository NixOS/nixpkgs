{ recurseIntoAttrs, runTest }:

recurseIntoAttrs {
  ejabberd-h2o = runTest ./ejabberd-h2o.nix;
  prosody-nginx = runTest ./prosody-nginx.nix;
}

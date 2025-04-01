{ recurseIntoAttrs, runTest }:

recurseIntoAttrs {
  prosody-nginx = runTest ./prosody-nginx.nix;
}

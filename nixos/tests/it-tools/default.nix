{ recurseIntoAttrs, runTest, ... }:
recurseIntoAttrs {
  nginx = runTest ./nginx.nix;
  caddy = runTest ./caddy.nix;
}

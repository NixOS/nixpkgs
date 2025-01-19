{
  mattermost,
}:

mattermost.override {
  versionInfo = {
    # Latest, non-RC releases only.
    # If the latest is an ESR (Extended Support Release),
    # duplicate it here to facilitate the update script.
    # See https://docs.mattermost.com/about/mattermost-server-releases.html
    # and make sure the version regex is up to date here.
    # Ensure you also check ../mattermost/package.nix for ESR releases.
    regex = "^v(10\.4\.[0-9]+)$";
    version = "10.3.1";
    srcHash = "sha256-nghwf9FgdqEDLkm8dKqhvY1SvALSZ8dasTDwMwbL5AI=";
    vendorHash = "sha256-G2IhU8/XSITjJKNu1Iwwoabm+hG9r3kLPtZnlzuKBD8=";
    npmDepsHash = "sha256-Dc+ZFQzRQoUnsZDnPs55gr6O82WwyuBEmCZYFAwW50M=";
    autoUpdate = ./package.nix;
  };
}

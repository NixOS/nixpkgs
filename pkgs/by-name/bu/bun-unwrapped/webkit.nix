{
  fetchgit,
  webkit,
}:

# GitHub cannot generate archives for this repository. sources.json keeps the
# sparse checkout paths used by both the package and its update script.
fetchgit {
  name = "bun-webkit-source";
  url = "https://github.com/oven-sh/WebKit.git";
  inherit (webkit) rev hash sparseCheckout;
}

{
  lib,
  fetchFromGitHub,
  fetchpatch,
  crystal,
  libxml2,
  openssl,
}:

crystal.buildCrystalPackage rec {
  pname = "mint";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "mint-lang";
    repo = "mint";
    tag = version;
    hash = "sha256-T8gbJ6IeheaiT3QZ/005IV3942wTMjMa/8lWUuyayX0=";
  };

  format = "shards";

  patches = [
    # Update ameba for compat with Crystal 1.21; remove with next release.
    (fetchpatch {
      url = "https://github.com/mint-lang/mint/commit/f5c71b25db08811a0129dbf9b342f8ab42b6342a.patch?full_index=1";
      hash = "sha256-Llht8LL2QVHSJv4imbNXy/FWABAixczSVa6UNd4DLDI=";
    })
  ];

  # Update with
  #   nix-shell -p crystal2nix --run crystal2nix
  # with mint's shard.lock file in the current directory
  shardsFile = ./shards.nix;

  nativeBuildInputs = [
    libxml2 # xmllint
  ];

  buildInputs = [ openssl ];

  preCheck = ''
    substituteInPlace spec/spec_helper.cr \
      --replace-fail "clear_env: true" "clear_env: false"
  '';

  meta = {
    description = "Refreshing language for the front-end web";
    mainProgram = "mint";
    homepage = "https://www.mint-lang.com/";
    license = lib.licenses.bsd3;
  };
}

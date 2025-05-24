import ./generic.nix {
  hash = "sha256-hgZc30SRnmALTvuD32dNuO0r4pfpXXvN4CtJqn2fGuk=";
  version = "6.12.0";
  vendorHash = "sha256-/GwJG6kmjbiUUh0AWQ+IUbeK1kRcuWrwmNdTzH5LT38=";
  patches = [
    # fix nft, remove 6.13
    ./1995.diff
  ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}

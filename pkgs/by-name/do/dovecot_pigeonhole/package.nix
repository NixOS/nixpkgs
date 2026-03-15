import ./generic.nix {
  version = "2.4.2";
  url =
    {
      version,
      dovecotMajorMinor,
    }:
    "https://pigeonhole.dovecot.org/releases/${dovecotMajorMinor}/dovecot-pigeonhole-${version}.tar.gz";
  hash = "sha256-nXiBii9LGe6VkGKkUBpvlntuvkQbqhAOqeSwwJb/ghE=";
  patches = fetchpatch: [
    # https://github.com/NixOS/nixpkgs/pull/388463#issuecomment-3066016707
    (fetchpatch {
      url = "https://github.com/dovecot/pigeonhole/commit/517d74aa1d98b853b72608ce722bc58009c0f4a9.patch";
      hash = "sha256-BLBz9ZhOGEIIitnXG0uM6bZBRNnQBy4K2IJlh1+Un50=";
    })
  ];
}

{
  beta = import ./browser.nix {
    channel = "beta";
    version = "103.0.1264.21";
    revision = "1";
    sha256 = "sha256:1336i0hy7xnla0pi4vahaxshhmivi1zljhaxyg63352bc7w9j64f";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "104.0.1287.1";
    revision = "1";
    sha256 = "sha256:10h360vfsfql42i6mpdvf8d0219506ipbk3hdpwl0jhlsphmhw61";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "102.0.1245.44";
    revision = "1";
    sha256 = "sha256:10r12xlkcnag5jdmnwpqsbkjx1ih1027l573vxmcxmvpmj6y4373";
  };
}

{
  comet-gog,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  inherit (comet-gog) pname;
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "imLinguin";
    repo = "comet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LAEt2i/SRABrz+y2CTMudrugifLgHNxkMSdC8PXYF0E=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-SvDE+QqaSK0+4XgB3bdmqOtwxBDTlf7yckTR8XjmMXc=";

  inherit (comet-gog) postPatch;

  meta = comet-gog.meta // {
    changelog = "https://github.com/imLinguin/comet/releases/tag/v${finalAttrs.version}";
  };
})

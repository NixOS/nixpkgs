{
  lib,
  fetchFromGitHub,
  mkOpenbaoPlugin,
}:

mkOpenbaoPlugin (finalAttrs: {
  plugin = "auth-github";
  pluginType = "auth";
  pluginName = "github";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugins";
    tag = "auth-github-v${finalAttrs.version}";
    hash = "sha256-/1xK+hRkXVtJPpW/Pt4wymxM7Zomtz5h8IxKoASCZVM=";
    # The vendored tree has paths that only differ in case, which
    # collide on case-insensitive filesystems.
    postFetch = "rm -rf $out/vendor";
  };

  vendorHash = "sha256-+3bNB7Vk4kMili03MOSS536OezxmM5GRL/NhccI9F1k=";

  meta = {
    description = "OpenBao auth plugin to authenticate using GitHub credentials";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})

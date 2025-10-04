{
  lib,
  fetchgit,
  unstableGitUpdater,
  buildLua,
}:
buildLua {
  pname = "autosave";
  version = "0-unstable-2020-10-22";

  src = fetchgit {
    url = "https://gist.github.com/CyberShadow/2f71a97fb85ed42146f6d9f522bc34ef";
    rev = "744c3ee61d2f0a8e9bb4e308dec6897215ae4704";
    hash = "sha256-yxA8wgzdS7SyKLoNTWN87ShsBfPKUflbOu4Y0jS2G3I=";
  };

  scriptPath = "autosave.lua";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Periodically saves \"watch later\" data during playback";
    homepage = "https://gist.github.com/CyberShadow/2f71a97fb85ed42146f6d9f522bc34ef";
    maintainers = with lib.maintainers; [ arthsmn ];
    license = lib.licenses.bsd0;
  };
}

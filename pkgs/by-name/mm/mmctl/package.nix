{
  lib,
  mattermost,
}:

mattermost.withoutTests.server.overrideAttrs (prev: {
  pname = "mmctl";
  subPackages = [ "cmd/mmctl" ];

  # `mattermost` or `mattermostLatest` handle it
  passthru = lib.removeAttrs prev.passthru [ "updateScript" ];

  meta = prev.meta // {
    description = "Remote CLI tool for Mattermost";
    mainProgram = "mmctl";
  };
})

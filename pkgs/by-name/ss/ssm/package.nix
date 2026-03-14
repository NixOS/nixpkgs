{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ssm";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "antonjah";
    repo = "ssm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y6TgTsw0m4qS2P0brQfN4IQnKbfc9Kb9AoxT2K4y2IM=";
  };

  vendorHash = "sha256-Hxe6a27bTbRan8Z+jHVQ3X5sQtlC5K47fIXrRCgfG/E=";

  cgoSupport = false;

  ldflags = [
    "-w"
    "-s"
    "-extldflags '-static'"
  ];

  tags = [
    "netgo"
    "osusergo"
  ];

  buildMode = "exe";

  meta = {
    description = "TUI for managing ssh connections";
    longDescription = ''
      SSM is a terminal-based user interface (TUI) tool designed for managing SSH connections.
      It provides an intuitive way to add, edit, and connect to SSH hosts directly from the command line.
      Key features include fuzzy search for quick host selection, support for SSH config files,
      and integration with tmux for session management. Built with simplicity and efficiency in mind,
      SSM helps streamline SSH workflows for developers and system administrators.
    '';
    homepage = "https://github.com/antonjah/ssm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ antonjah ];
    mainProgram = "ssm";
  };
})

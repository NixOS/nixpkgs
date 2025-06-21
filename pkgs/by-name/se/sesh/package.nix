{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule rec {
  pname = "sesh";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    hash = "sha256-D//yt8DVy7DMX38qfmVa5UbGIgjzsGXQoscrhcgPzh4=";
  };

  vendorHash = "sha256-r6n0xZbOvqDU63d3WrXenvV4x81iRgpOS2h73xSlVBI=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Smart session manager for the terminal";
    homepage = "https://github.com/joshmedeski/sesh";
    changelog = "https://github.com/joshmedeski/sesh/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gwg313 ];
    mainProgram = "sesh";
  };
}

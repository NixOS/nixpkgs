{
  lib,
  pkgs,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "subtui";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "MattiaPun";
    repo = "subtui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b8p1JBA5cdbDAD8BXJnvptWpuC6oQ+aZZVt6nnKUPFM=";
  };

  vendorHash = "sha256-LSEp0NaNsdnpDZTDUvpK5L7yPlqt3/W4jI9OOnvo7Lc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  buildInputs = [ pkgs.mpv ];

  meta = {
    description = "Lightweight Subsonic TUI music player built in Go with scrobbling support";
    homepage = "https://github.com/MattiaPun/SubTUI";
    license = lib.licenses.mit;
    changelog = "https://github.com/MattiaPun/SubTUI/releases/tag/v${finalAttrs.version}";
    mainProgram = "SubTUI";
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})

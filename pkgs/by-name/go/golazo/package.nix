{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  libnotify,
}:
buildGoModule (finalAttrs: {
  pname = "golazo";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "0xjuanma";
    repo = "golazo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-udZ3F6DQAzRZpPukkeGE4Ho0zl4pAt2CinIOQqmYe5Q=";
  };

  vendorHash = "sha256-M2gfqU5rOfuiVSZnH/Dr8OVmDhyU2jYkgW7RuIUTd+E=";

  subPackages = [ "." ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libnotify ];

  ldflags = [
    "-X github.com/0xjuanma/golazo/cmd.Version=v${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Minimal TUI app to keep up with live & recent football/soccer matches written in Go";
    homepage = "https://github.com/0xjuanma/golazo";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "golazo";
    maintainers = with lib.maintainers; [ rafaelrc ];
  };
})

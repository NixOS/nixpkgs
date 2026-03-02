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
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "0xjuanma";
    repo = "golazo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TWpaW8MTkYEOp+7dd3LiDs05tCB3riUPmFRzhMiAeZI=";
  };

  vendorHash = "sha256-M2gfqU5rOfuiVSZnH/Dr8OVmDhyU2jYkgW7RuIUTd+E=";

  subPackages = [ "." ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libnotify ];

  ldflags = [
    "-X github.com/0xjuanma/golazo/cmd.Version=v${finalAttrs.version}"
  ];

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

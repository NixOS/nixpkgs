{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  libnotify,
  makeWrapper,
}:
buildGoModule (finalAttrs: {
  pname = "golazo";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "0xjuanma";
    repo = "golazo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g9JPPP/pZ65Jgq2hXYzRynhZebF7s2ZTNU4Ca1Iu5uc=";
  };

  vendorHash = "sha256-M2gfqU5rOfuiVSZnH/Dr8OVmDhyU2jYkgW7RuIUTd+E=";

  subPackages = [ "." ];

  ldflags = [
    "-X github.com/0xjuanma/golazo/cmd.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/golazo \
      --prefix PATH : ${
        lib.makeBinPath [
          libnotify
        ]
      }
  '';

  __structuredAttrs = true;
  strictDeps = true;

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

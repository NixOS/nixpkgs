{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "legendsbrowser2";
  version = "2.0.10";

  sourceRoot = "source/backend";
  src = fetchFromGitHub {
    owner = "robertjanetzko";
    repo = "LegendsBrowser2";
    tag = finalAttrs.version;
    hash = "sha256-wttBw3AKHkPCgoxnaxI8IZSPuw2xLoCK/9joAYFWPM8=";
  };
  vendorHash = "sha256-W7hc+U+rJZgXzcYoUHTG29j2xvJ/xTbBgDaiO7CVGnk=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 0755 $GOPATH/bin/backend $out/bin/legendsbrowser2

    runHook postInstall
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-platform, open source, legends viewer for dwarf fortress 0.47 written in go";
    homepage = "https://github.com/robertjanetzko/LegendsBrowser2";
    changelog = "https://github.com/robertjanetzko/LegendsBrowser2/releases/tag/${finalAttrs.version}";
    mainProgram = "legendsbrowser2";
    maintainers = [ lib.maintainers.andrewzah ];
    license = lib.licenses.mit;
  };
})

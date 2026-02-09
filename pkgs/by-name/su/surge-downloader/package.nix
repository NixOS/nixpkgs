{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "surge-downloader";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "surge-downloader";
    repo = "surge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6ISP7S5rcsjFQxXQGnqZ4jWgjNk98/npy7Z0pobIB98=";
  };

  vendorHash = "sha256-IGVt/HanZHglYSZ8WASrzqvTZZtK/bJpJzXNVqSqUfE=";

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  # tests are mostly stress-tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI download manager";
    longDescription = ''
      Surge is a blazing fast, open-source terminal (TUI) download manager built in Go.
      Designed for power users who prefer a keyboard-driven workflow. It features a beautiful TUI,
      as well as a background Headless Server and a CLI tool for automation.
    '';
    homepage = "https://github.com/surge-downloader/surge";
    license = lib.licenses.mit;
    mainProgram = "surge";
    maintainers = with lib.maintainers; [ ErmitaVulpe ];
  };
})

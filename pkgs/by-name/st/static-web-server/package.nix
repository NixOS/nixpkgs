{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "static-web-server";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "static-web-server";
    repo = "static-web-server";
    tag = "v${version}";
    hash = "sha256-EWCkad2v937GPL7qeHxPp24wf3EWk+M5iQkZBhErv/Y=";
  };

  cargoHash = "sha256-RYTG54c4Q4uP4lAZpjfulP/BV4jDp5xxsa6vtSn+vOs=";

  # static-web-server already has special handling for files with modification
  # time = Unix epoch, but the nix store is Unix epoch + 1 second.
  patches = [ ./include-unix-time-plus-one.diff ];

  # Some tests which implicitly relied on the above behavior now break.
  # Force an mtime update to everything except symbolic inks to fix.
  postUnpack = ''
    find . -not -type l -exec touch -m {} +
  '';

  # Need to copy in the systemd units for systemd.packages to discover them
  postInstall = ''
    install -Dm444 -t $out/lib/systemd/system/ systemd/static-web-server.{service,socket}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      inherit (nixosTests) static-web-server;
    };
  };

  meta = {
    description = "A cross-platform, high-performance and asynchronous web server for static files-serving";
    homepage = "https://static-web-server.net/";
    changelog = "https://github.com/static-web-server/static-web-server/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      misilelab
      progrm_jarvis
    ];
    mainProgram = "static-web-server";
  };
}

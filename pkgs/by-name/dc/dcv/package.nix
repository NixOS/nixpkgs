{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dcv";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "tokuhirom";
    repo = "dcv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OwfGZq+ce6RNb5dhNHsQ15iMPoEp7QlaYIUVYIiVqmI=";
  };

  vendorHash = "sha256-xwTPb+eGsisYB9Jy7rG9tQlIbnKWTbAdXqJBsjB0YK0=";

  # Don't use the vendored dependencies as they are out of sync with go.mod
  # Instead, let Go download dependencies through the module proxy
  proxyVendor = true;

  # Build helper binaries for all architectures before the main build
  # These helpers are embedded in the binary and used for container filesystem operations
  preBuild = ''
    make build-helpers
  '';

  # Strip debug symbols and DWARF tables to reduce binary size
  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "TUI (Terminal User Interface) tool for monitoring Docker containers and Docker Compose applications";
    homepage = "https://github.com/tokuhirom/dcv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ FelixLusseau ];
    mainProgram = "dcv";
  };
})

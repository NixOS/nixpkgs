{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "captive-browser";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "pacoorozco";
    repo = "captive-browser";
    rev = "ca6f74e132ecf298c87936d4c946fd551aefbbf7";
    sha256 = "sha256-wojx28GFg9whfkNxUbOVDVNHp8M7SLsmRBTP/Jh8nLQ=";
  };

  vendorHash = "sha256-8FMFgCJUTalJ45GR5UnyXqN6s0gVFtiy6zjugbngDYQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  meta = {
    description = "Dedicated Chrome instance to log into captive portals without messing with DNS settings";
    homepage = "https://blog.filippo.io/captive-browser";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
  };
})

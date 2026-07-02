{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "oui";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "thatmattlove";
    repo = "oui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lwjDFd2rxMh7kHOuwgIeA2/gnzHoNkGKTQGd/xqshZY=";
  };

  vendorHash = "sha256-EOu9imj0YwYhHX7ZzE9BzhkoDitC5AHjlwoWmQs0Rj4=";

  checkFlags = [
    # These tests require live IEEE network access, a local PostgreSQL server,
    # and a writable home directory.
    "-skip=^Test_(CollectAll|New)$"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MAC Address CLI Toolkit";
    homepage = "https://github.com/thatmattlove/oui";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ johannwagner ];
    mainProgram = "oui";
  };
})

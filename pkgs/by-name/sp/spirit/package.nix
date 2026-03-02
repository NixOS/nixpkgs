{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "spirit";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "block";
    repo = "spirit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lgDEYIc6NgDkqoYdwluaZ9VCockE3gbyP8O7LfoTrl0=";
  };

  vendorHash = "sha256-WSMziaE6ldYa915fAAecXGmJkFhh8Sk/IHjfBqXf9FI=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/block/spirit";
    description = "Online schema change tool for MySQL";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
})

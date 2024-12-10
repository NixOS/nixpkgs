{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  immich-go,
}:
buildGoModule rec {
  pname = "immich-go";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "simulot";
    repo = "immich-go";
    rev = "${version}";
    hash = "sha256-zYqPPLDfBx4FLvZIo5E6nAeIiFfBCLI00xLieXFkMxs=";
  };

  vendorHash = "sha256-Y5BujN2mk662oKxQpenjFlxazST2GqWr9ug0sOsxKbY=";

  # options used by upstream:
  # https://github.com/simulot/immich-go/blob/0.13.2/.goreleaser.yaml
  ldflags = [
    "-s"
    "-w"
    "-extldflags=-static"
    "-X main.version=${version}"
    "-X main.commit=${version}"
    "-X main.date=unknown"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.versionTest = testers.testVersion {
      package = immich-go;
      command = "immich-go -h";
      version = version;
    };
  };

  meta = {
    description = "Immich client tool for bulk-uploads";
    longDescription = ''
      Immich-Go is an open-source tool designed to streamline uploading
      large photo collections to your self-hosted Immich server.
    '';
    homepage = "https://github.com/simulot/immich-go";
    mainProgram = "immich-go";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ kai-tub ];
    changelog = "https://github.com/simulot/immich-go/releases/tag/${version}";
  };
}

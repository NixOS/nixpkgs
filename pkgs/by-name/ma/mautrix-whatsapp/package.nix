{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mautrix-whatsapp";
  version = "25.10";
  tag = "v0.2510.0";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "whatsapp";
    tag = tag;
    hash = "sha256-jJIVlK4vTJpwjugKNtWZhO31t7YX+q3W+ZmU1w/itvM=";
  };

  tags = "goolm";

  vendorHash = "sha256-LvGapdyGYXNUsC0qniwdoA3pUrOivfFq+nEilw5xFNM=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X"
    "main.Tag=${tag}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/mautrix/whatsapp";
    description = "Matrix-WhatsApp puppeting bridge";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      vskilet
      ma27
      chvp
      SchweGELBin
    ];
    mainProgram = "mautrix-whatsapp";
  };
}

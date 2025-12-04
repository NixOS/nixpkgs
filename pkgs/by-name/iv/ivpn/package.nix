{
  buildGoModule,
  fetchFromGitHub,
  lib,
  wirelesstools,
  nix-update-script,
}:

let
  version = "3.15.0";
in
buildGoModule rec {
  pname = "ivpn";
  inherit version;

  buildInputs = [ wirelesstools ];

  src = fetchFromGitHub {
    owner = "ivpn";
    repo = "desktop-app";
    tag = "v${version}";
    hash = "sha256-Y+oW/2WDkH/YydR+xSzEHPdCNKTmmsV4yEsju+OmDYE=";
  };

  modRoot = "cli";
  vendorHash = "sha256-xZ1tMiv06fE2wtpDagKjHiVTPYWpj32hM6n/v9ZcgrE=";

  proxyVendor = true; # .c file

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ivpn/desktop-app/daemon/version._version=${version}"
    "-X github.com/ivpn/desktop-app/daemon/version._time=1970-01-01"
  ];

  postInstall = ''
    mv $out/bin/{cli,ivpn}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Official IVPN Desktop app";
    homepage = "https://www.ivpn.net/apps";
    changelog = "https://github.com/ivpn/desktop-app/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      urandom
      blenderfreaky
    ];
    mainProgram = "ivpn";
  };
}

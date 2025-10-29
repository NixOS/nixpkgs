{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "hysteria";
    rev = "app/v${version}";
    hash = "sha256-j6MvVq/+buv/Md/84xUFyRh2zp8qms/1IdEREZ5trXM=";
  };

  vendorHash = "sha256-lCq+/RPbqstMR47ILJ+BdtBowFVWBDczFEg0KuF8DAQ=";
  proxyVendor = true;

  ldflags =
    let
      cmd = "github.com/apernet/hysteria/app/cmd";
    in
    [
      "-s"
      "-w"
      "-X ${cmd}.appVersion=${version}"
      "-X ${cmd}.appType=release"
    ];

  postInstall = ''
    mv $out/bin/app $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/apernet/hysteria";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "hysteria";
  };
}

{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule rec {
  pname = "hysteria";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "hysteria";
    rev = "app/v${version}";
    hash = "sha256-r8A1kY5zVIYLH4BmTF8BF135K5zQNBN0cvQpWI9SR2I=";
  };

  vendorHash = "sha256-TWGHOn64QvIiH5gr+il98IdO7cheAjQs/VFVwm2jKWU=";
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

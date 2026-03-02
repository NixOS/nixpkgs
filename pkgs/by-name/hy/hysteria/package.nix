{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "hysteria";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "hysteria";
    rev = "app/v${finalAttrs.version}";
    hash = "sha256-eObMqyYCyrt5TemNK5AVZlO01wPjb5QscV6BSnAhQF8=";
  };

  vendorHash = "sha256-K1RWbZHZUvPezPRoGSd0e8b+J1UREHWPLHWEWD5cpRc=";
  proxyVendor = true;

  ldflags =
    let
      cmd = "github.com/apernet/hysteria/app/cmd";
    in
    [
      "-s"
      "-w"
      "-X ${cmd}.appVersion=${finalAttrs.version}"
      "-X ${cmd}.appType=release"
    ];

  postInstall = ''
    mv $out/bin/app $out/bin/hysteria
  '';

  # Network required
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/apernet/hysteria";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ oluceps ];
    mainProgram = "hysteria";
  };
})

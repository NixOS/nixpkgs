{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  nix-update-script,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "hysteria";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "hysteria";
    rev = "app/v${finalAttrs.version}";
    hash = "sha256-pWiEY1H9iX5aX2nR/K8fNKeAbzLOCZhEe5KLk4arot4=";
  };

  vendorHash = "sha256-IFC/LMI28cGfUTtgTYf045OAEaMdPgd1bzhdSngQlrA=";
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

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mv $out/bin/app $out/bin/hysteria

    wrapProgram $out/bin/hysteria \
      --add-flags "--disable-update-check"
  '';

  # Network required
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) hysteria; };
  };

  meta = {
    description = "Feature-packed proxy & relay utility optimized for lossy, unstable connections";
    homepage = "https://github.com/apernet/hysteria";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      oluceps
      Guanran928
    ];
    mainProgram = "hysteria";
  };
})

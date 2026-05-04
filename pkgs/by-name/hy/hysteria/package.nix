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
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "hysteria";
    rev = "app/v${finalAttrs.version}";
    hash = "sha256-HgZVwaHL5q8aOxHhVt6RaHaBxoj83ujHaqLemQkLRUM=";
  };

  vendorHash = "sha256-oHxnawchsHU/M1PZ0zXR5luopso1FptXi+PL5pNgdj0=";
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

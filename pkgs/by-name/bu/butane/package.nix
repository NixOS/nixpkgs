{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "butane";
  version = "2.27.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "ignition";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CjYiBcUdbfrQWpMzvKjFG53SPVkQyxbQ/8coQt7BuH8=";
  };

  vendorHash = null;

  doCheck = false;

  subPackages = [ "butane/internal" ];

  ldflags = [
    "-X github.com/coreos/ignition/v2/butane/internal/version.Raw=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{internal,butane}
  '';

  meta = {
    description = "Translates human-readable Butane configs into machine-readable Ignition configs";
    mainProgram = "butane";
    license = lib.licenses.asl20;
    homepage = "https://github.com/coreos/ignition";
    maintainers = with lib.maintainers; [
      elijahcaine
      ruuda
    ];
  };
})

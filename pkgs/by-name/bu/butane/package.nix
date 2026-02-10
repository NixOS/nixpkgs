{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "butane";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "butane";
    rev = "v${finalAttrs.version}";
    hash = "sha256-htD/FecmBVUp0bmzDJpUNw8rVr9mheFwagUISFu8lJM=";
  };

  vendorHash = null;

  doCheck = false;

  subPackages = [ "internal" ];

  ldflags = [
    "-X github.com/coreos/butane/internal/version.Raw=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/{internal,butane}
  '';

  meta = {
    description = "Translates human-readable Butane configs into machine-readable Ignition configs";
    mainProgram = "butane";
    license = lib.licenses.asl20;
    homepage = "https://github.com/coreos/butane";
    maintainers = with lib.maintainers; [
      elijahcaine
      ruuda
    ];
  };
})

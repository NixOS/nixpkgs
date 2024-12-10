{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "butane";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "butane";
    rev = "v${version}";
    hash = "sha256-ELCERcgw01RcSMQjM0PL8CyTKrdfEPV9U8/RSf7YxCs=";
  };

  vendorHash = null;

  doCheck = false;

  subPackages = [ "internal" ];

  ldflags = [
    "-X github.com/coreos/butane/internal/version.Raw=v${version}"
  ];

  postInstall = ''
    mv $out/bin/{internal,butane}
  '';

  meta = with lib; {
    description = "Translates human-readable Butane configs into machine-readable Ignition configs";
    mainProgram = "butane";
    license = licenses.asl20;
    homepage = "https://github.com/coreos/butane";
    maintainers = with maintainers; [
      elijahcaine
      ruuda
    ];
  };
}

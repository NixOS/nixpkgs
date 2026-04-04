{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "butane";
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "butane";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RNK6G9/mNUTeRA0oWZoOdOUmc1F85Q3xmXUhtpgPymc=";
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

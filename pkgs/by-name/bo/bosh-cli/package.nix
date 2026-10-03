{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  openssh,
}:

buildGoModule (finalAttrs: {
  pname = "bosh-cli";

  version = "7.11.0";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-U0191FRHwA5Psu69RkVR9MVHRaR4E+l2PBEta+pohEs=";
  };
  vendorHash = null;

  postPatch = ''
    substituteInPlace cmd/version.go --replace '[DEV BUILD]' '${finalAttrs.version}'
  '';

  nativeBuildInputs = [ makeWrapper ];

  subPackages = [ "." ];

  doCheck = false;

  postInstall = ''
    mv $out/bin/bosh-cli $out/bin/bosh
    wrapProgram $out/bin/bosh --prefix PATH : '${lib.makeBinPath [ openssh ]}'
  '';

  meta = {
    description = "Command line interface to CloudFoundry BOSH";
    homepage = "https://bosh.io";
    changelog = "https://github.com/cloudfoundry/bosh-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
    mainProgram = "bosh";
  };
})

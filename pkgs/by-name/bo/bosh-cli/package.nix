{
  lib,
  fetchFromGitHub,
  buildGoModule,
  makeWrapper,
  openssh,
}:

buildGoModule rec {
  pname = "bosh-cli";

<<<<<<< HEAD
  version = "7.9.15";
=======
  version = "7.9.14";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "bosh-cli";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+dkRPK4RFVainDa4SNiA9B14uz3vaIfAjv09T3dDGIw=";
=======
    sha256 = "sha256-Chsnok59Q0lmYa9J8XGX3SlDsUjRoUcPArLVHTGkt3k=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  vendorHash = null;

  postPatch = ''
    substituteInPlace cmd/version.go --replace '[DEV BUILD]' '${version}'
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
    changelog = "https://github.com/cloudfoundry/bosh-cli/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ris ];
    mainProgram = "bosh";
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

buildGoModule rec {
  pname = "cloud-nuke";
<<<<<<< HEAD
  version = "0.46.0";
=======
  version = "0.45.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "cloud-nuke";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-uuTyLT6Qfnv7cLP//avPcNZreTWGHJRS6kxMC+UT39U=";
  };

  vendorHash = "sha256-EYIfecD3X3EdllR9FoqfEWSwB7wh6IxQTKItSivSPDs=";
=======
    hash = "sha256-Xv8m8hCg0kw82+AWCNKW0jcYyguR5SDHq/ldflR/iOA=";
  };

  vendorHash = "sha256-Qml8P9m8quUZAarsS7h3TGbcXBCJ2fRD3uyi8Do+lAw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.VERSION=${version}"
  ];

  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/cloud-nuke --set-default DISABLE_TELEMETRY true
  '';

  meta = {
    homepage = "https://github.com/gruntwork-io/cloud-nuke";
    description = "Tool for cleaning up your cloud accounts by nuking (deleting) all resources within it";
    mainProgram = "cloud-nuke";
    changelog = "https://github.com/gruntwork-io/cloud-nuke/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

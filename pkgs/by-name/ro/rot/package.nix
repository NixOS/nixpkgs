{ lib
, fetchFromGitHub
, buildGoModule
,
}:
buildGoModule rec {
  pname = "rot";
  version = "2023.12.20";

  src = (fetchFromGitHub {
    owner = "candiddev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TY98TzsmHzt4ZNHAVbepCmeA7LxOHkj2s9aRowHvdEQ=";
    fetchSubmodules = true;
  }).overrideAttrs (_: {
    GIT_CONFIG_COUNT = 1;
    GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
    GIT_CONFIG_VALUE_0 = "git@github.com:";
  });

  GOWORK = "off";

  patches = [ ./patch ];

  vendorHash = "sha256-L4S3sqmSBrCLCOQ2MzxD/fJCF1PrZjESqA+V81sxWKU=";

  subPackages = [ "go" ];

  postInstall = ''
    mv $out/bin/go $out/bin/$pname
  '';

  meta = with lib; {
    description = "Future proof secrets management";
    homepage = "https://rotx.dev";
    license = licenses.agpl3;
    maintainers = with maintainers; [ nrdxp ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook
}:

buildGoModule rec {
  pname = "ejsonkms";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "envato";
    repo = "ejsonkms";
    rev = "v${version}";
    hash = "sha256-aHnxdEADrzaRld7G2owSHO/0xYXIa8EBBR+phdA4eRM=";
  };

  vendorHash = "sha256-aLcSCDgd3IGiUg/JAPNIV30tAh6tDYZnFnqzaLELXw0=";

  ldflags = [
    "-X main.version=v${version}" "-s" "-w"
  ];

  doCheck = false;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = with lib; {
    description = "Integrates EJSON with AWS KMS";
    homepage = "https://github.com/envato/ejsonkms";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
  };
}

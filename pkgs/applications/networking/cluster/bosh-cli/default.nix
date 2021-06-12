{ lib
, fetchFromGitHub
, buildGoModule
, makeWrapper
, openssh
}:

buildGoModule rec {
  pname = "bosh-cli";

  version = "6.4.3";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = pname;
    rev = "v${version}";
    sha256 = "1glxwk0fv52rjim7ihcxkjx19fsn9k7gzg9zmwxgx8wpsjrdcq3f";
  };
  vendorSha256 = null;

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

  meta = with lib; {
    description = "A command line interface to CloudFoundry BOSH";
    homepage = "https://bosh.io";
    changelog = "https://github.com/cloudfoundry/bosh-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}

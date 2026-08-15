{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "credhub-cli";
  version = "2.9.59";

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "credhub-cli";
    rev = finalAttrs.version;
    sha256 = "sha256-jHMVLkRDEIch8naxEbCkfD2sTChbfiejcaoliQTZqt0=";
  };

  # these tests require network access that we're not going to give them
  postPatch = ''
    rm commands/api_test.go
    rm commands/socks5_test.go
  '';
  __darwinAllowLocalNetworking = true;

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
    "-X code.cloudfoundry.org/credhub-cli/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    ln -s $out/bin/credhub-cli $out/bin/credhub
  '';

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Provides a command line interface to interact with CredHub servers";
    homepage = "https://github.com/cloudfoundry/credhub-cli";
    maintainers = with lib.maintainers; [ ris ];
    license = lib.licenses.asl20;
  };
})

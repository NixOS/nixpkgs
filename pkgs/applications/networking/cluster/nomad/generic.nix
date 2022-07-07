{ lib
, buildGoModule
, fetchFromGitHub
, version
, sha256
, vendorSha256
, nixosTests
}:

buildGoModule rec {
  pname = "nomad";
  inherit version;

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    inherit sha256;
  };

  inherit vendorSha256;

  # ui:
  #  Nomad release commits include the compiled version of the UI, but the file
  #  is only included if we build with the ui tag.
  tags = [ "ui" ];

  passthru.tests.nomad = nixosTests.nomad;

  meta = with lib; {
    homepage = "https://www.nomadproject.io/";
    description = "A Distributed, Highly Available, Datacenter-Aware Scheduler";
    platforms = platforms.unix;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem pradeepchhetri endocrimes maxeaubrey techknowlogick ];
  };
}

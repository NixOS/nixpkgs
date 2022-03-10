{ lib, buildGoModule, fetchFromGitHub, testVersion, odo }:

buildGoModule rec {
  pname = "odo";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "redhat-developer";
    repo = "odo";
    rev = "v${version}";
    sha256 = "KYJkCoF80UPsebWwxpc5gIfmT3Aj4OU8r6dDkaWXqbY=";
  };

  vendorSha256 = null;

  buildPhase = ''
    make bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a odo $out/bin
  '';

  passthru.tests.version = testVersion {
    package = odo;
    command = "odo version";
    version = "v${version}";
  };

  meta = with lib; {
    description = "Developer-focused CLI for OpenShift and Kubernetes";
    license = licenses.asl20;
    homepage = "odo.dev";
    maintainers = with maintainers; [ stehessel ];
    platforms = platforms.unix;
  };
}

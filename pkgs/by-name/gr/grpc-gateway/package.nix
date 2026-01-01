{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  grpc-gateway,
}:

buildGoModule rec {
  pname = "grpc-gateway";
<<<<<<< HEAD
  version = "2.27.4";
=======
  version = "2.27.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    tag = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-4bhEQTVV04EyX/qJGNMIAQDcMWcDVr1tFkEjBHpc2CA=";
  };

  vendorHash = "sha256-ohZW/uPdt08Y2EpIQ2yeyGSjV9O58+QbQQqYrs6O8/g=";
=======
    sha256 = "sha256-NXcfr/+VZnYlK5A/RuTboB33WadoutG7GnACfrWBvwg=";
  };

  vendorHash = "sha256-EgFB5ADytn9h8P2CrM9mr5siX5G4+8HGyWt/upp3yHg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-X=main.version=${version}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.commit=${version}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = grpc-gateway;
      command = "protoc-gen-grpc-gateway --version";
      version = "Version ${version}, commit ${version}, built at 1970-01-01T00:00:00Z";
    };
    openapiv2Version = testers.testVersion {
      package = grpc-gateway;
      command = "protoc-gen-openapiv2 --version";
      version = "Version ${version}, commit ${version}, built at 1970-01-01T00:00:00Z";
    };
  };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "GRPC to JSON proxy generator plugin for Google Protocol Buffers";
    longDescription = ''
      This is a plugin for the Google Protocol Buffers compiler (protoc). It reads
      protobuf service definitions and generates a reverse-proxy server which
      translates a RESTful HTTP API into gRPC. This server is generated according to
      the google.api.http annotations in the protobuf service definitions.
    '';
    homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ happyalu ];
=======
    license = licenses.bsd3;
    maintainers = with maintainers; [ happyalu ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

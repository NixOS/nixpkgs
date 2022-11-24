{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "temporalite";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-rLEkWg5LNVb7i/2IARKGuP9ugaVJA9pwYbKLm0QLmOc=";
  };

  vendorSha256 = "sha256-vjuwh/HRRYfB6J49rfJxif12nYPnbBodWF9hTiGygS8=";

  subPackages = [ "cmd/temporalite" ];

  postPatch = ''
    substituteInPlace cmd/temporalite/ui_test.go \
      --replace "TestNewUIConfigWithMissingConfigFile" "SkipNewUIConfigWithMissingConfigFile"

    substituteInPlace cmd/temporalite/mtls_test.go \
      --replace "TestMTLSConfig" "SkipMTLSConfig"
  '';

  meta = with lib; {
    description = "An experimental distribution of Temporal that runs as a single process";
    homepage = "https://github.com/temporalio/temporalite";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}

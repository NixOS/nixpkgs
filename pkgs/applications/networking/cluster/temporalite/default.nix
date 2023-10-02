{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "temporalite";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IEB9AFEt8U2zXYfbChfL/UH1rNSLPnfS396/cPE8UdE=";
  };

  vendorHash = "sha256-w86/XCMRGBmXM+oQ5+0qiX0fdwiKXvsmEkApuRLUOiA=";

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

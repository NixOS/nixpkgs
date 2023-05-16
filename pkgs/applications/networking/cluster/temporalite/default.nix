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

<<<<<<< HEAD
  vendorHash = "sha256-w86/XCMRGBmXM+oQ5+0qiX0fdwiKXvsmEkApuRLUOiA=";
=======
  vendorSha256 = "sha256-w86/XCMRGBmXM+oQ5+0qiX0fdwiKXvsmEkApuRLUOiA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

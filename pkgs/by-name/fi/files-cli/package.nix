{ lib
, fetchFromGitHub
, buildGoModule
, versionCheckHook
}:

buildGoModule rec {
  pname = "files-cli";
  version = "2.13.85";

  src = fetchFromGitHub {
    repo = "files-cli";
    owner = "files-com";
    rev = "v${version}";
    hash = "sha256-rsEromVixVLtBLvhLWQ5ykjHq3/FScPSpuL9FqIOjZ8=";
  };

  vendorHash = "sha256-pobAFcmFsE340+Jboqnd88L3UHEquZ63eWwSXzgOWyc=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  meta = with lib; {
    description = "Files.com Command Line App for Windows, Linux, and macOS";
    homepage = "https://developers.files.com";
    license = licenses.mit;
    maintainers = with maintainers; [ kashw2 ];
    mainProgram = "files-cli";
  };

}

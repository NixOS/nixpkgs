{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "s5";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "mvisonneau";
    repo = "s5";
    rev = "v${version}";
    hash = "sha256-aNNf7ntGg2A84jD6UeoF4gFv8S/FonbIhV3ZOd/P4bw=";
  };

  vendorHash = "sha256-NmnYv0yAHmlOY9UK7GQtb5e9DwbyEbqQ2O6cpqkwtww=";

  subPackages = [ "cmd/s5" ];

  ldflags = [
    "-X github.com/mvisonneau/s5/internal/app.Version=v${version}"
  ];

  doCheck = true;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "--version";

  meta = with lib; {
    description = "Cipher/decipher text within a file";
    mainProgram = "s5";
    homepage = "https://github.com/mvisonneau/s5";
    license = licenses.asl20;
    platforms = platforms.unix ++ platforms.darwin;
    maintainers = with maintainers; [ mvisonneau ];
  };
}

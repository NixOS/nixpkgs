{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "evmdis";
  version = "0-unstable-2022-05-09";

  src = fetchFromGitHub {
    owner = "Arachnid";
    repo = "evmdis";
    rev = "7fad4fbee443262839ce9f88111b417801163086";
    hash = "sha256-jfbjXoGT8RtwLlqX13kcKdiFlhrVwA7Ems6abGJVRbA=";
  };

  vendorHash = null;

  preBuild = ''
    go mod init github.com/Arachnid/evmdis
  '';

  ldflags = [ "-s" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Arachnid/evmdis";
    description = "Ethereum EVM disassembler";
    mainProgram = "evmdis";
    license = [ lib.licenses.asl20 ];
    maintainers = with lib.maintainers; [ asymmetric ];
=======
  meta = with lib; {
    homepage = "https://github.com/Arachnid/evmdis";
    description = "Ethereum EVM disassembler";
    mainProgram = "evmdis";
    license = [ licenses.asl20 ];
    maintainers = with maintainers; [ asymmetric ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

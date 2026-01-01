{
  lib,
<<<<<<< HEAD
  protobuf,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "protols";
<<<<<<< HEAD
  version = "0.13.1";
=======
  version = "0.13.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "coder3101";
    repo = "protols";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-ZvQC7huJS37cgmAVZoiHZMjFWTdma7dueTczaKDdHks=";
  };

  cargoHash = "sha256-q3GMizdBupQSMVCuRqLjuw0Mof1q3UYOdUBugmrTDMU=";

  env.FALLBACK_INCLUDE_PATH = "${protobuf}/include";
=======
    hash = "sha256-Wa8xpHaL6cU2tjMr1WJaAc85laJq91uzHuqA0/XmLns=";
  };

  cargoHash = "sha256-7/4/Kcb7cih7GRzQA2vtQC/KBk9rgmcWor2Ij7c7Cjg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Protocol Buffers language server written in Rust";
    homepage = "https://github.com/coder3101/protols";
    changelog = "https://github.com/coder3101/protols/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "protols";
  };
}

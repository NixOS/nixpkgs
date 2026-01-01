{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-graph";
<<<<<<< HEAD
  version = "0.7.0";
=======
  version = "0.6.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mlange-42";
    repo = "git-graph";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-9GFwxWYDnH3kKDWpxgh7ciSLB1Zr2zExxIrIrhycmZY=";
  };

  cargoHash = "sha256-hKCEAXZj2ExSamvtl10RnAiuV9w6yOYdnsXm0gplFSU=";

  meta = {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-graph";
    license = lib.licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
=======
    tag = version;
    hash = "sha256-xYUpLujePO1MS0c25UJX5rRdmPzkaFgF5zJonzQOJqM=";
  };

  cargoHash = "sha256-tN70YyhVkLD5OiYNm64vbY5NtKAG2sFp4Ry6vFpXvtE=";

  meta = with lib; {
    description = "Command line tool to show clear git graphs arranged for your branching model";
    homepage = "https://github.com/mlange-42/git-graph";
    license = licenses.mit;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-graph";
  };
}

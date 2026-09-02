{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "git-appraise";
  version = "0.7-unstable-2022-04-13";

  strictDeps = true;
  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "google";
    repo = "git-appraise";
    rev = "99aeb0e71544d3e1952e208c339b1aec70968cf3";
    hash = "sha256-TteTI8yGP2sckoJ5xuBB5S8xzm1upXmZPlcDLvXZrpc=";
  };

  vendorHash = "sha256-Lzq4qpDAUjKFA2T685eW9NCfzEhDsn5UR1A1cIaZadE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Distributed code review system for Git repos";
    homepage = "https://github.com/google/git-appraise";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vdemeester ];
    mainProgram = "git-appraise";
  };
}

{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-appraise";
  version = "unstable-2022-04-13";

  src = fetchFromGitHub {
    owner = "google";
    repo = "git-appraise";
    rev = "99aeb0e71544d3e1952e208c339b1aec70968cf3";
    sha256 = "sha256-TteTI8yGP2sckoJ5xuBB5S8xzm1upXmZPlcDLvXZrpc=";
  };

  vendorSha256 = "sha256-Lzq4qpDAUjKFA2T685eW9NCfzEhDsn5UR1A1cIaZadE=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Distributed code review system for Git repos";
    homepage = "https://github.com/google/git-appraise";
    license = licenses.asl20;
    maintainers = with maintainers; [ vdemeester ];
  };
}

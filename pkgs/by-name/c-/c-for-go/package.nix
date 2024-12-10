{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "c-for-go";
  version = "unstable-2023-09-06";

  src = fetchFromGitHub {
    owner = "xlab";
    repo = "c-for-go";
    # c-for-go is not versioned upstream, so we pin it to a commit hash.
    rev = "a1822f0a09c1c6c89fc12aeb691a27b3221c73f3";
    hash = "sha256-P7lrAVyZ6fV63gVvLvsKt14pi32Pr2eVLT2mTdHHdrQ=";
  };

  vendorHash = "sha256-u/GWniw5UQBOtnj3ErdxL80j2Cv6cbMwvP1im3dZ2cM=";

  meta = with lib; {
    homepage = "https://github.com/xlab/c-for-go";
    changelog = "https://github.com/xlab/c-for-go/releases/";
    description = "Automatic C-Go Bindings Generator for the Go Programming Language";
    license = licenses.mit;
    maintainers = with maintainers; [ msanft ];
    mainProgram = "c-for-go";
  };
}

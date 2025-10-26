{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "ssh-key-confirmer";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "benjojo";
    repo = "ssh-key-confirmer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CXDjm8PMdCTwHnZWa0fYKel7Rmxq0XBWkfLmoVuSkKM=";
  };

  vendorHash = "sha256-CkfZ9dImjdka98eu4xuWZ6Xed7WX6DnXw81Ih7bhPm0=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Test ssh login key acceptance without having the private key";
    homepage = "https://github.com/benjojo/ssh-key-confirmer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
    mainProgram = "ssh-key-confirmer";
  };
})

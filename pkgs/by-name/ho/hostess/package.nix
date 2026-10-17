{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hostess";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "cbednarski";
    repo = "hostess";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UpBabzDujMkT/DDlEyr1h8Dxc8OozdG7v0ZpC4z7+sc=";
  };

  subPackages = [ "." ];

  vendorHash = null;

  meta = {
    description = "Idempotent command-line utility for managing your /etc/hosts* file";
    homepage = "https://github.com/cbednarski/hostess";
    mainProgram = "hostess";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edlimerkaj ];
  };
})

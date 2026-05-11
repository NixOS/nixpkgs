{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "age-plugin-sss";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "olastor";
    repo = "age-plugin-sss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QNu2Sp0CxYYXuMzf7X0mMYI677ICu5emOM4F9HlKhHA=";
  };

  vendorHash = "sha256-Aw7dwro6adluhQXPlZ9RZVGBAmNw539Z3c+a8TmPTXU=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${finalAttrs.version}"
  ];

  meta = {
    description = "Age plugin to split keys and wrap them with different recipients using Shamir's Secret Sharing";
    homepage = "https://github.com/olastor/age-plugin-sss/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arbel-arad ];
    mainProgram = "age-plugin-sss";
  };
})

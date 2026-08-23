{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "align";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Guitarbum722";
    repo = "align";
    tag = "v${finalAttrs.version}";
    sha256 = "17gs3417633z71kc6l5zqg4b3rjhpn2v8qs8rnfrk4nbwzz4nrq3";
  };

  vendorHash = null;

  meta = {
    homepage = "https://github.com/Guitarbum722/align";
    description = "General purpose application and library for aligning text";
    mainProgram = "align";
    maintainers = with lib.maintainers; [ hrhino ];
    license = lib.licenses.mit;
  };
})

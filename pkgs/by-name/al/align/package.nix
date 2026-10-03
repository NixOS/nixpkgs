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
    hash = "sha256-A2dL/ufLkpmdzUhjtIW9UOaxyMO/UMNmOH8McwIZ+p0=";
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

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "richgo";
  version = "0.3.12";

  src = fetchFromGitHub {
    owner = "kyoh86";
    repo = "richgo";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pOB1exuwGwSxStodKhLLwh1xBvLjopUn0k+sEARdA9g=";
  };

  vendorHash = "sha256-jIzBN5T5+eTFCYOdS5hj3yTGOfU8NTrFmnIu+dDjVeU=";

  meta = {
    description = "Enrich `go test` outputs with text decorations";
    mainProgram = "richgo";
    homepage = "https://github.com/kyoh86/richgo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
  };
})

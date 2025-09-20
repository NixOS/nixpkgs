{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "align";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "Guitarbum722";
    repo = "align";
    tag = "v${version}";
    hash = "sha256-A2dL/ufLkpmdzUhjtIW9UOaxyMO/UMNmOH8McwIZ+p0=";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/Guitarbum722/align";
    description = "General purpose application and library for aligning text";
    mainProgram = "align";
    maintainers = with maintainers; [ hrhino ];
    license = licenses.mit;
  };
}

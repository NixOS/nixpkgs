{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-AIH5ADJPkZEbYLHPyMRPMeO78Y+JQDTzfvrtLTKjrsY=";
  };

  vendorHash = "sha256-/9VuRb0dtKJccJYM7Jasm+xyFxphtN77YQvQkDZ8FcE=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = licenses.mit;
    maintainers = with maintainers; [ ozkutuk ];
    mainProgram = "gomi";
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "allmark";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "andreaskoch";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JfNn/e+cSq1pkeXs7A2dMsyhwOnh7x2bwm6dv6NOjLU=";
  };

  postPatch = ''
    go mod init github.com/andreaskoch/allmark
  '';

  vendorHash = null;

  postInstall = ''
    mv $out/bin/{cli,allmark}
  '';

  meta = {
    description = "Cross-platform markdown web server";
    homepage = "https://github.com/andreaskoch/allmark";
    changelog = "https://github.com/andreaskoch/allmark/-/releases/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      urandom
    ];
    mainProgram = "allmark";
  };
}

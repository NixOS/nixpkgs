{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gore";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "motemen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-7mhfegSSRE9FnKz+tWYMEtEKc+hayPQE8EEOEu33CjU=";
  };

  vendorHash = "sha256-0eCRDlcqZf+RAbs8oBRr+cd7ncWX6fXk/9jd8/GnAiw=";

  doCheck = false;

  meta = with lib; {
    description = "Yet another Go REPL that works nicely";
    mainProgram = "gore";
    homepage = "https://github.com/motemen/gore";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
  };
}

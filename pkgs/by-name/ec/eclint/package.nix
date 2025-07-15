{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "eclint";
  version = "0.5.1";

  src = fetchFromGitLab {
    owner = "greut";
    repo = "eclint";
    rev = "v${version}";
    hash = "sha256-XY+D0bRIgWTm2VH+uDVodYeyGeu+8Xyyq4xDvTDLii4=";
  };

  vendorHash = "sha256-4bka3GRl75aUYpZrWuCIvKNwPY8ykp25e+kn+G6JQ/I=";

  ldflags = [ "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://gitlab.com/greut/eclint";
    description = "EditorConfig linter written in Go";
    mainProgram = "eclint";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}

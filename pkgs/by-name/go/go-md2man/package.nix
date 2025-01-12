{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-md2man";
  version = "2.0.6";

  vendorHash = "sha256-aMLL/tmRLyGze3RSB9dKnoTv5ZK1eRtgV8fkajWEbU0=";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "cpuguy83";
    repo = "go-md2man";
    sha256 = "sha256-wJnHgp+NPchXkR71ARLMjo4VryzgGkz2tYWPsC+3eFo=";
  };

  meta = with lib; {
    description = "Go tool to convert markdown to man pages";
    mainProgram = "go-md2man";
    license = licenses.mit;
    homepage = "https://github.com/cpuguy83/go-md2man";
    maintainers = with maintainers; [ offline ];
  };
}

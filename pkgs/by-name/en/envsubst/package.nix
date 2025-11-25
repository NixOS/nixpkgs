{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "envsubst";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "a8m";
    repo = "envsubst";
    rev = "v${version}";
    sha256 = "sha256-eByxrLf/F8Ih8v+0TunghF4m42TLPeRRFnqN3Ib6e14=";
  };

  vendorHash = null;

  postInstall = ''
    install -Dm444 -t $out/share/doc/envsubst LICENSE *.md
  '';

  meta = with lib; {
    description = "Environment variables substitution for Go";
    homepage = "https://github.com/a8m/envsubst";
    license = licenses.mit;
    maintainers = with maintainers; [ nicknovitski ];
    mainProgram = "envsubst";
  };
}

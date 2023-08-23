{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "walk";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "antonmedv";
    repo = "walk";
    rev = "v${version}";
    hash = "sha256-lcXNGmDCXq73gAWFKHHsIb578b1EhznYaGC0myFQym8=";
  };

  vendorHash = "sha256-EYwfoTVcgV12xF/cv9O6QgXq9Gtc9qK9EmZNjXS4kC8=";

  meta = with lib; {
    description = "Terminal file manager";
    homepage = "https://github.com/antonmedv/walk";
    license = licenses.mit;
    maintainers = with maintainers; [ portothree surfaceflinger ];
    mainProgram = "walk";
  };
}

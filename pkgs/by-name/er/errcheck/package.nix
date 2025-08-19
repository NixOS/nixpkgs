{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "errcheck";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "kisielk";
    repo = "errcheck";
    rev = "v${version}";
    hash = "sha256-DhOoJL4InJHl4ImIrhV086a++srC5E4LF2VQb838+L8=";
  };

  vendorHash = "sha256-znkT0S13wCB47InP2QBCZqeWxDdEeIwQPoVWoxiAosQ=";

  subPackages = [ "." ];

  meta = with lib; {
    description = "Checks for unchecked errors in go programs";
    mainProgram = "errcheck";
    homepage = "https://github.com/kisielk/errcheck";
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
  };
}

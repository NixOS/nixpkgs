{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sptlrx";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "raitonoberu";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wk4vXm6sB+Rw0VFAhfD0GKxsP+1LwpS6VFHa3UENuJk=";
  };

  vendorSha256 = "sha256-l5gIbjB2rJyNmZBqrHo4kwClmAgjgDWHTs5KWzrfC08=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Spotify lyrics in your terminal";
    homepage = "https://github.com/raitonoberu/sptlrx";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}

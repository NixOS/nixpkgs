{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gitty";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "gitty";
    rev = "v${version}";
    sha256 = "sha256-g0D6nJiHY7cz72DSmdQZsj9Vgv/VOp0exTcLsaypGiU=";
  };

  vendorSha256 = "sha256-qrLECQkjXH0aTHmysq64jnXj9jgbunpVtBAIXJOEYIY=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/gitty/";
    description = "Contextual information about your git projects, right on the command-line";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}

{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gitty";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "gitty";
    rev = "v${version}";
    sha256 = "1byjcvzimwn6nmhz0agicq7zq0xhkj4idi9apm1mgd3m2l509ivj";
  };

  vendorSha256 = "1mbl585ja82kss5p8vli3hbykqxa00j8z63ypq6vi464qkh5x3py";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/gitty/";
    description = "Contextual information about your git projects, right on the command-line";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}

{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "gitty";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "gitty";
    rev = "v${version}";
    sha256 = "0y7iwvih1wqp1f28jm6ila2fh8f92l6l2w308a8bxjnbqrxijmh6";
  };

  vendorSha256 = "0viqsg907hf43h3s2wrpsrnp8faqjv23jqnl9zs7lwm26a74x0rc";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/muesli/gitty/";
    description = "Contextual information about your git projects, right on the command-line";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}

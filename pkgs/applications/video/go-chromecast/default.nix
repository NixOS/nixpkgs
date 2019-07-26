{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "1p8yilg8iv66g2752ygvy0hzs46d6f92rn7jb7wxz9j216yz4gvj";
  };
  modSha256 = "01zmhrkgdfkf0ssd7mydf6lhqipwcqbm9bim5sayhms4bzbljaic";

  meta = with lib; {
    homepage = https://github.com/vishen/go-chromecast;
    description = "cli for Google Chromecast, Home devices and Cast Groups";
    license = licenses.asl20;
    maintainers = with maintainers; [ dtzWill ];
  };
}

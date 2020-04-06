{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "umoci";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "umoci";
    rev = "v${version}";
    sha256 = "1gzj4nnys73wajdwjn5jsskvnhzh8s2vmyl76ax8drpvw19bd5g3";
  };

  goPackagePath = "github.com/openSUSE/umoci";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    description = "umoci modifies Open Container images";
    homepage = "https://umo.ci";
    license = licenses.asl20;
    maintainers = with maintainers; [ zokrezyl ];
    platforms = platforms.linux;
  };
}

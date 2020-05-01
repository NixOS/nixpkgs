{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "hydroxide";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "emersion";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d8wjyzmw89yhrszz487f7i19rcz7xlx4w2wd4c69k5nsdrs6dys";
  };

  modSha256 = "0888ikywclhjb4n7xqxc7hvzlhx1qhf4c3skaddqs3nrxm171jwn";

  subPackages = [ "cmd/hydroxide" ];

  meta = with lib; {
    description = "A third-party, open-source ProtonMail bridge";
    homepage = "https://github.com/emersion/hydroxide";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.unix;
  };
}

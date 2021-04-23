{ buildGoModule, fetchFromSourcehut, lib }:

buildGoModule rec {
  pname = "openring";
  version = "unstable-2021-04-03";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = pname;
    rev = "f13edb5dfd882ce608d61cf6b6740650ce9d84a3";
    sha256 = "sha256-Z65V77JZ9jCzBg7T2+d5Agxxd+MV2R7nYcLedYP5eOE=";
  };

  vendorSha256 = "sha256-BbBTmkGyLrIWphXC+dBaHaVzHuXRZ+4N/Jt2k3nF7Z4=";

  # The package has no tests.
  doCheck = false;

  meta = with lib; {
    description = "A webring for static site generators";
    homepage = "https://git.sr.ht/~sircmpwn/openring";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sumnerevans ];
  };
}

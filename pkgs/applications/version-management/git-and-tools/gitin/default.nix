{ lib
, buildGoPackage
, fetchFromGitHub
, pkg-config
, libgit2_0_27
}:

buildGoPackage rec {
  version = "0.2.3";
  pname = "gitin";

  goPackagePath = "github.com/isacikgoz/gitin";

  src = fetchFromGitHub {
    owner = "isacikgoz";
    repo = "gitin";
    rev = "v${version}";
    sha256 = "00z6i0bjk3hdxbc0cy12ss75b41yvzyl5pm6rdrvsjhzavry2fa3";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgit2_0_27 ];

  meta = with lib; {
    homepage = "https://github.com/isacikgoz/gitin";
    description = "Text-based user interface for git";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kimat ];
  };
}

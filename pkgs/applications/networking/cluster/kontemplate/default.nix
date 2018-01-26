{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "kontemplate-${version}";
  version = "1.3.0";

  goPackagePath = "github.com/tazjin/kontemplate";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "tazjin";
    repo = "kontemplate";
    sha256 = "0g9hs9gwwkng9vbnv07ibhll0kggdprffpmhlbz9nmv81w2z3myi";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Extremely simple Kubernetes resource templates";
    homepage = http://kontemplate.works;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mbode ];
    platforms = platforms.unix;
    repositories.git = git://github.com/tazjin/kontemplate.git;
  };
}

{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "scmpuff";
  version = "0.3.0";
  goPackagePath = "github.com/mroth/scmpuff";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "mroth";
    repo = pname;
    rev = "56dc2041f2c45ab15d41e63058c1c44fff905e81";
    sha256 = "0zrzzcs0i13pfwcqh8qb0sji54vh37rdr7qasg57y56cqpx16vl3";
  };

  meta = with stdenv.lib; {
    description = "Add numbered shortcuts to common git commands";
    homepage = "https://github.com/mroth/scmpuff";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    platforms = concatLists (with platforms; [ linux darwin windows ]);
  };
}

{ lib, nimPackages, fetchFromGitHub, nim, termbox, pcre }:

nimPackages.buildNimPackage rec {
  pname = "nimmm";
  version = "0.2.0";
  nimBinOnly = true;

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${version}";
    sha256 = "168n61avphbxsxfq8qzcnlqx6wgvz5yrjvs14g25cg3k46hj4xqg";
  };

  buildInputs = [ termbox pcre ]
    ++ (with nimPackages; [ noise nimbox lscolors ]);

  meta = with lib; {
    description = "Terminal file manager written in nim";
    homepage = "https://github.com/joachimschmidt557/nimmm";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.joachimschmidt557 ];
  };
}

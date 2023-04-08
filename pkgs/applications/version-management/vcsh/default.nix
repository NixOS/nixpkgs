{ lib, stdenv
, fetchurl
, makeWrapper
, pkg-config
, git
, perlPackages
}:

stdenv.mkDerivation rec {
  pname = "vcsh";
  version = "2.0.5";

  src = fetchurl {
    url = "https://github.com/RichiH/vcsh/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0bf3gacbyxw75ksd8y6528kgk7mqx6grz40gfiffxa2ghsz1xl01";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ git ];

  nativeCheckInputs = []
    ++ (with perlPackages; [ perl ShellCommand TestMost ]);

  outputs = [ "out" "doc" "man" ];

  meta = with lib; {
    description = "Version Control System for $HOME";
    homepage = "https://github.com/RichiH/vcsh";
    changelog = "https://github.com/RichiH/vcsh/blob/v${version}/changelog";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ttuegel alerque ];
    platforms = platforms.unix;
  };
}

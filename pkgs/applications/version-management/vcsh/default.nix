{ lib, stdenv
, fetchurl
, makeWrapper
, pkg-config
, git
, perlPackages
}:

stdenv.mkDerivation rec {
  pname = "vcsh";
  version = "2.0.2";

  src = fetchurl {
    url = "https://github.com/RichiH/vcsh/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "0qdd4f6rm5rhnym9f114pcj9vafhjjpg962c4g420rn78fxhpz1z";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ git ];

  checkInputs = []
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

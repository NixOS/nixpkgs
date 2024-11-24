{ lib, stdenv, fetchFromGitHub, autoreconfHook, libzip, boost, wt4, libconfig, pkg-config } :

stdenv.mkDerivation rec {
  pname = "fileshelter";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "epoupon";
    repo = "fileshelter";
    rev = "v${version}";
    sha256 = "07n70wwqj7lqdxs3wya1m8bwg8l6lgmmlfpwyv3r3s4dfzb1b3ka";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libzip boost wt4 libconfig ];

  NIX_LDFLAGS = "-lpthread";

  postInstall = ''
    ln -s ${wt4}/share/Wt/resources $out/share/fileshelter/docroot/resources
  '';

  meta = with lib; {
    homepage = "https://github.com/epoupon/fileshelter";
    description = "FileShelter is a 'one-click' file sharing web application";
    mainProgram = "fileshelter";
    maintainers = [ maintainers.willibutz ];
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
  };
}

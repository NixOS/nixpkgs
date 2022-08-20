{ lib, mkDerivation, fetchFromGitHub, pkg-config, qmake, qtbase, libjack2 }:
mkDerivation rec {
  pname = "jack_autoconnect";

  # It does not have any versions (yet?)
  version = "unstable-2021-02-01";

  src = fetchFromGitHub {
    owner = "kripton";
    repo = pname;
    rev = "fe0c8f69149e30979e067646f80b9d326341c02b";
    sha256 = "sha256-imvNc498Q2W9RKmiOoNepSoJzIv2tGvFG6hx+seiifw=";
  };

  buildInputs = [ qtbase libjack2 ];
  nativeBuildInputs = [ pkg-config qmake ];

  installPhase = ''
    mkdir -p -- "$out/bin"
    cp -- jack_autoconnect "$out/bin"
  '';

  meta = with lib; {
    homepage = "https://github.com/kripton/jack_autoconnect";
    description =
      "Tiny application that reacts on port registrations by clients and connects them";
    maintainers = with maintainers; [ unclechu ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}

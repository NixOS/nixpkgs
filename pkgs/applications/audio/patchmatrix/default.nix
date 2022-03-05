{ stdenv
, lib
, fetchFromGitHub
, libjack2
, lv2
, meson
, ninja
, pkg-config
, glew
, xorg
}:

stdenv.mkDerivation rec {
  pname = "patchmatrix";
  version = "0.26.0";

  src = fetchFromGitHub {
    owner = "OpenMusicKontrollers";
    repo = pname;
    rev = version;
    hash = "sha256-rR3y5rGzmib//caPmhthvMelAdHRvV0lMRfvcj9kcCg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glew
    libjack2
    lv2
    xorg.libX11
    xorg.libXext
  ];

  meta = with lib; {
    description = "A JACK patchbay in flow matrix style";
    homepage = "https://github.com/OpenMusicKontrollers/patchmatrix";
    license = licenses.artistic2;
    maintainers = with maintainers; [ pennae ];
    platforms = platforms.linux;
  };
}

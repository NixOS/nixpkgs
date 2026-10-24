{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, allegro5
, zlib
, gtk3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "b-em";
  version = "24f41ba";

  src = fetchFromGitHub {
    owner = "stardot";
    repo = pname;
    rev = version;
    hash = "sha256-nY/ExG+gNWC1Yb/2EPDp0xRS6iJF6mgP0OCr1JaXkpk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    wrapGAppsHook
  ];

  buildInputs = [
    allegro5
    zlib
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  enableParallelBuilds = true;

  meta = with lib; {
    description = "An open source Acorn BBC Micro emulator";
    homepage = "https://github.com/stardot/b-em";
    changelog = "https://github.com/stardot/b-em/blob/${src.rev}/Changes.txt";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pkharvey ];
    mainProgram = "b-em";
    platforms = [ "x86_64-linux" ];
  };
}

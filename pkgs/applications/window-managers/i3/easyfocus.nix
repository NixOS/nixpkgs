{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  xorgproto,
  libxcb,
  xcbutilkeysyms,
  xorg,
  i3ipc-glib,
  glib,
}:

stdenv.mkDerivation {
  pname = "i3easyfocus";
  version = "20190411";

  src = fetchFromGitHub {
    owner = "cornerman";
    repo = "i3-easyfocus";
    rev = "fffb468f7274f9d7c9b92867c8cb9314ec6cf81a";
    sha256 = "1db23vzzmp0hnfss1fkd80za6d2pajx7hdwikw50pk95jq0w8wfm";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libxcb
    xcbutilkeysyms
    xorgproto
    xorg.libX11.dev
    i3ipc-glib
    glib.dev
  ];

  # Makefile has no rule for 'install'
  installPhase = ''
    mkdir -p $out/bin
    cp i3-easyfocus $out/bin
  '';

  meta = with lib; {
    description = "Focus and select windows in i3";
    mainProgram = "i3-easyfocus";
    homepage = "https://github.com/cornerman/i3-easyfocus";
    maintainers = with maintainers; [ teto ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}

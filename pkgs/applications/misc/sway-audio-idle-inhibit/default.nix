{ fetchFromGitHub
, lib
, libpulseaudio
, meson
, ninja
, pkg-config
, stdenv
, wayland
, wayland-protocols
, ...
}:
let
  pname = "sway-audio-idle-inhibit";
  version = "0.1.1";
  owner = "ErikReider";
  repo = "SwayAudioIdleInhibit";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    inherit owner repo;
    rev = "v${version}";
    hash = "sha256-XUUUUeaXO7GApwe5vA/zxBrR1iCKvkQ/PMGelNXapbA=";
  };

  buildInputs = [
    libpulseaudio
    wayland
    wayland-protocols
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = with lib; {
    description = "Prevents swayidle from sleeping while any application is outputting or receiving audio";
    homepage = "https://github.com/${owner}/${repo}";
    changelog = "https://github.com/${owner}/${repo}/releases/tag/v${version}";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nrdxp ];
    mainProgram = pname;
  };
}

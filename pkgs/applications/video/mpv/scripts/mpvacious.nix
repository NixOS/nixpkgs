{ lib
, buildLua
, fetchFromGitHub
, curl
, wl-clipboard
, xclip
}:

buildLua rec {
  pname = "mpvacious";
  version = "0.24";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "mpvacious";
    rev = "v${version}";
    sha256 = "sha256-o0YcoSI+4934HlyIoI5V1h/FalCe+6tXS8Lg6kXWjSg=";
  };

  postPatch = ''
    substituteInPlace utils/forvo.lua \
      --replace "'curl" "'${curl}/bin/curl"
    substituteInPlace platform/nix.lua \
      --replace "'curl" "'${curl}/bin/curl" \
      --replace "'wl-copy" "'${wl-clipboard}/bin/wl-copy" \
      --replace "'xclip" "'${xclip}/bin/xclip"
  '';

  installPhase = ''
    runHook preInstall
    make PREFIX=$out/share/mpv install
    runHook postInstall
  '';

  meta = with lib; {
    description = "Adds mpv keybindings to create Anki cards from movies and TV shows";
    homepage = "https://github.com/Ajatt-Tools/mpvacious";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kmicklas ];
  };
}

{ lib
, stdenvNoCC
, fetchFromGitHub
, curl
, wl-clipboard
, xclip
}:

stdenvNoCC.mkDerivation rec {
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

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    rm -r .github
    mkdir -p $out/share/mpv/scripts
    cp -r . $out/share/mpv/scripts/mpvacious
    runHook postInstall
  '';

  passthru.scriptName = "mpvacious";

  meta = with lib; {
    description = "Adds mpv keybindings to create Anki cards from movies and TV shows";
    homepage = "https://github.com/Ajatt-Tools/mpvacious";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ kmicklas ];
  };
}

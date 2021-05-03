{ lib, stdenvNoCC, fetchFromGitHub, curl, xclip }:

stdenvNoCC.mkDerivation rec {
  pname = "mpvacious";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "mpvacious";
    rev = "v${version}";
    sha256 = "0r031hh3hpim9dli15m9q4cwka4ljvwg0hdgyp36r1n097q44r5f";
  };

  postPatch = ''
    substituteInPlace subs2srs.lua \
      --replace "'curl'" "'${curl}/bin/curl'" \
      --replace "xclip" "${xclip}/bin/xclip"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts
    cp subs2srs.lua $out/share/mpv/scripts
    runHook postInstall
  '';

  passthru.scriptName = "subs2srs.lua";

  meta = with lib; {
    description = "Adds mpv keybindings to create Anki cards from movies and TV shows";
    homepage = "https://github.com/Ajatt-Tools/mpvacious";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ kmicklas ];
  };
}

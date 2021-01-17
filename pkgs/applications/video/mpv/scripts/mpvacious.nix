{ lib, stdenv, fetchFromGitHub, curl, xclip }:

stdenv.mkDerivation rec {
  pname = "mpvacious";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "mpvacious";
    rev = "v${version}";
    sha256 = "1xz4qh2ibfv03m3pfdasim9byvlm78wigx1linmih19vgg99vky2";
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

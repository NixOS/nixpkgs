{ lib
, stdenvNoCC
, fetchFromGitHub
, curl
, wl-clipboard
, xclip
}:

stdenvNoCC.mkDerivation rec {
  pname = "mpvacious";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "Ajatt-Tools";
    repo = "mpvacious";
    rev = "v${version}";
    sha256 = "1lxlgbjk4x3skg5s7kkr9llcdlmpmabfrcslwhhz5f4j3bq7498w";
  };

  postPatch = ''
    # 'require' replaced with 'dofile' to work around
    # https://github.com/mpv-player/mpv/issues/7399 until fixed in mpvacious
    substituteInPlace subs2srs.lua \
      --replace "require('osd_styler')" "dofile('"$out/share/mpv/scripts/mpvacious/osd_styler.lua"')" \
      --replace "'curl'" "'${curl}/bin/curl'" \
      --replace "'wl-copy'" "'${wl-clipboard}/bin/wl-copy'" \
      --replace "xclip" "${xclip}/bin/xclip"
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/mpv/scripts/mpvacious
    cp *.lua $out/share/mpv/scripts/mpvacious
    runHook postInstall
  '';

  passthru.scriptName = "mpvacious/subs2srs.lua";

  meta = with lib; {
    description = "Adds mpv keybindings to create Anki cards from movies and TV shows";
    homepage = "https://github.com/Ajatt-Tools/mpvacious";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ kmicklas ];
  };
}

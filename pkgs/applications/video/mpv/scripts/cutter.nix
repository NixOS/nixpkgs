{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper }:

stdenvNoCC.mkDerivation {
  pname = "video-cutter";
  version = "unstable-2021-02-03";

  src = fetchFromGitHub {
    owner = "rushmj";
    repo = "mpv-video-cutter";
    rev = "718d6ce9356e63fdd47208ec44f575a212b9068a";
    sha256 = "sha256-ramID1DPl0UqEzevpqdYKb9aaW3CAy3Dy9CPb/oJ4eY=";
  };

  dontBuild = true;
  dontCheck = true;

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace cutter.lua \
      --replace '~/.config/mpv/scripts/c_concat.sh' '${placeholder "out"}/share/mpv/scripts/c_concat.sh'

    # needs to be ran separately so that we can replace everything, and not every single mention explicitly
    # original script places them in the scripts folder, just spawning unnecessary errors
    # i know that hardcoding .config and especially the .mpv directory isn't best practice, but I didn't want to deviate too much from upstream
    substituteInPlace cutter.lua \
      --replace '~/.config/mpv/scripts' "''${XDG_CONFIG_HOME:-~/.config}/mpv/cutter"
  '';

  installPhase = ''
    install -Dm755 c_concat.sh $out/share/mpv/scripts/c_concat.sh
    install cutter.lua $out/share/mpv/scripts/cutter.lua

    wrapProgram $out/share/mpv/scripts/c_concat.sh \
      --run "mkdir -p ~/.config/mpv/cutter/"
  '';

  passthru.scriptName = "cutter.lua";

  meta = with lib; {
    description = "Cut videos and concat them automatically";
    homepage = "https://github.com/rushmj/mpv-video-cutter";
    # repo doesn't have a license
    license = licenses.unfree;
    maintainers = with maintainers; [ lom ];
  };
}

{ lib, buildLua, fetchFromGitHub, makeWrapper }:

buildLua {
  pname = "video-cutter";
  version = "unstable-2021-02-03";

  src = fetchFromGitHub {
    owner = "rushmj";
    repo = "mpv-video-cutter";
    rev = "718d6ce9356e63fdd47208ec44f575a212b9068a";
    sha256 = "sha256-ramID1DPl0UqEzevpqdYKb9aaW3CAy3Dy9CPb/oJ4eY=";
  };

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

  passthru.scriptName = "cutter.lua";
  extraScripts = [ "c_concat.sh" ];

  postInstall = ''
    chmod 0755 $out/share/mpv/scripts/c_concat.sh
    wrapProgram $out/share/mpv/scripts/c_concat.sh \
      --run "mkdir -p ~/.config/mpv/cutter/"
  '';

  meta = with lib; {
    description = "Cut videos and concat them automatically";
    homepage = "https://github.com/rushmj/mpv-video-cutter";
    # repo doesn't have a license
    license = licenses.unfree;
    maintainers = with maintainers; [ lom ];
  };
}

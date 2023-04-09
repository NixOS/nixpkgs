{ lib
, stdenvNoCC
, fetchFromGitHub
}:

let
  script = { name, ... }@p:
    stdenvNoCC.mkDerivation (lib.attrsets.recursiveUpdate p {
      pname = "mpv_${name}";
      passthru.scriptName = "${name}.lua";

      src = fetchFromGitHub {
        owner = "occivink";
        repo = "mpv-scripts";
        rev = "af360f332897dda907644480f785336bc93facf1";
        hash = "sha256-KdCrUkJpbxxqmyUHksVVc8KdMn8ivJeUA2eerFZfEE8=";
      };
      version = "unstable-2022-10-02";

      dontBuild = true;
      installPhase = ''
        mkdir -p $out/share/mpv/scripts
        cp -r scripts/${name}.lua $out/share/mpv/scripts/
      '';

      meta = with lib; {
        homepage = "https://github.com/occivink/mpv-scripts";
        license = licenses.unlicense;
        platforms = platforms.all;
        maintainers = with maintainers; [ nicoo ];
      };
    });

in
{

  # Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
  seekTo = script { name = "seek-to"; meta.description = "Mpv script for seeking to a specific position"; };

  blacklistExtensions = script {
    name = "blacklist-extensions";
    meta.description = "Automatically remove playlist entries based on their extension.";
  };

}

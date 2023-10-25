{ lib
, stdenvNoCC
, fetchFromGitHub
}:

let
  script = { n, ... }@p:
    stdenvNoCC.mkDerivation (lib.attrsets.recursiveUpdate {
      pname = "mpv_${n}";
      passthru.scriptName = "${n}.lua";

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
        cp -r scripts/${n}.lua $out/share/mpv/scripts/
      '';

      meta = with lib; {
        homepage = "https://github.com/occivink/mpv-scripts";
        license = licenses.unlicense;
        platforms = platforms.all;
        maintainers = with maintainers; [ nicoo ];
      };

      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    } p);

in
{

  # Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
  seekTo = script {
    n = "seek-to";
    meta.description = "Mpv script for seeking to a specific position";
    outputHash = "sha256-3RlbtUivmeoR9TZ6rABiZSd5jd2lFv/8p/4irHMLshs=";
  };

  blacklistExtensions = script {
    n = "blacklist-extensions";
    meta.description = "Automatically remove playlist entries based on their extension.";
    outputHash = "sha256-qw9lz8ofmvvh23F9aWLxiU4YofY+YflRETu+nxMhvVE=";
  };

}

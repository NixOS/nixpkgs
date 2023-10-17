{ lib
, fetchFromGitHub
, buildLua
}:

let
  script = { pname, ...}@args:
    buildLua (lib.attrsets.recursiveUpdate {
      src = fetchFromGitHub {
        owner = "occivink";
        repo = "mpv-scripts";
        rev = "af360f332897dda907644480f785336bc93facf1";
        hash = "sha256-KdCrUkJpbxxqmyUHksVVc8KdMn8ivJeUA2eerFZfEE8=";
      };
      version = "unstable-2022-10-02";

      scriptPath = "scripts/${pname}.lua";

      meta = with lib; {
        homepage = "https://github.com/occivink/mpv-scripts";
        license = licenses.unlicense;
        maintainers = with maintainers; [ nicoo ];
      };
    } args);

in
{

  # Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
  seekTo = script {
    pname = "seek-to";
    meta.description = "Mpv script for seeking to a specific position";
    outputHash = "sha256-3RlbtUivmeoR9TZ6rABiZSd5jd2lFv/8p/4irHMLshs=";
  };

  blacklistExtensions = script {
    pname = "blacklist-extensions";
    meta.description = "Automatically remove playlist entries based on their extension.";
    outputHash = "sha256-qw9lz8ofmvvh23F9aWLxiU4YofY+YflRETu+nxMhvVE=";
  };
}

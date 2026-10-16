{
  lib,
  buildKodiAddon,
  fetchFromGitHub,
  vfs-libarchive,
}:
buildKodiAddon rec {
  pname = "archive_tool";
  namespace = "script.module.archive_tool";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "zach-morris";
    repo = "script.module.archive_tool";
    rev = version;
    hash = "sha256-545mOZPSeBnRNNhzKjExpcSOK1T0Sve32dL1nsr0c0E=";
  };

  propagatedBuildInputs = [
    vfs-libarchive
  ];

  passthru = {
    pythonPath = "lib";
  };

  meta = {
    homepage = "https://github.com/zach-morris/script.module.archive_tool";
    description = "Set of common python functions to work with the Kodi archive virtual file system (vfs) binary addons";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.kodi ];
  };
}

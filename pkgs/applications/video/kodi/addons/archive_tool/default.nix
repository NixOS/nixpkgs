{ lib, buildKodiAddon, fetchFromGitHub, vfs-libarchive }:
buildKodiAddon rec {
  pname = "archive_tool";
  namespace = "script.module.archive_tool";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "zach-morris";
    repo = "script.module.archive_tool";
    rev = version;
    sha256 = "0hbkyk59xxfjv6vzfjplahmqxi5564qjlwyq6k8ijy6jjcwnd3p7";
  };

  propagatedBuildInputs = [
    vfs-libarchive
  ];

  passthru = {
    pythonPath = "lib";
  };

  meta = with lib; {
    homepage = "https://github.com/zach-morris/script.module.archive_tool";
    description = "A set of common python functions to work with the Kodi archive virtual file system (vfs) binary addons";
    license = licenses.gpl3Plus;
    maintainers = teams.kodi.members;
  };
}

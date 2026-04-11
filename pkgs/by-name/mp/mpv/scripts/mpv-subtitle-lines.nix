{
  fetchFromGitHub,
  buildLua,
  lib,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-subtitle-lines";
  version = "0-unstable-2024-05-19";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-subtitle-lines";
    rev = "f0a85c7ba3370b490c46a77dcb2e212c0b149a50";
    hash = "sha256-m9LHIz/hAOEq0DzHY3Jd1LM1cfxZng6Iaqrug1PfnAE=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "List and search subtitle lines of the selected subtitle track";
    homepage = "https://github.com/christoph-heinrich/mpv-subtitle-lines";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ purrpurrn ];
  };
}

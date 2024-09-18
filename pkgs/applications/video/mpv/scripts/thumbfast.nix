{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
  mpv-unwrapped,
}:

buildLua {
  pname = "mpv-thumbfast";
  version = "0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "f1fdf10b17f394f2d42520d0e9bf22feaa20a9f4";
    hash = "sha256-cygLf+0PMH7cVXBcY12PdcxBHmy38DNoXQubKAlerHM=";
  };
  passthru.updateScript = unstableGitUpdater { };

  passthru.extraWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ mpv-unwrapped ])
  ];

  meta = {
    description = "High-performance on-the-fly thumbnailer for mpv";
    homepage = "https://github.com/po5/thumbfast";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
}

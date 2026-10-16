{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
  mpv-unwrapped,
}:

buildLua {
  pname = "mpv-thumbfast";
  version = "0-unstable-2026-06-28";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "thumbfast";
    rev = "0f711de3138c9bd6718209d819ac54022c23ded2";
    hash = "sha256-LVeEtzOMVSgBqN9z6VQLZnxXfrOUoQPOWazVXmj3ZFY=";
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

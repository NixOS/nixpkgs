{
  lib,
  buildLua,
  fetchFromGitHub,
  ffmpeg,
  unstableGitUpdater,
}:

buildLua {
  pname = "mpv-slicing";
  version = "0-unstable-2017-11-25";

  src = fetchFromGitHub {
    owner = "Kagami";
    repo = "mpv_slicing";
    rev = "d09c11227704c8d5bdaa2c799ef64dce881c63a7";
    hash = "sha256-MKoM0f74/XoctiHQVOB3LzFWtJXpsREfQh5icaebCJo=";
  };
  passthru.updateScript = unstableGitUpdater { };

  postPatch = ''
    substituteInPlace slicing.lua \
        --replace-fail ffmpeg ${lib.getExe ffmpeg}
  '';

  passthru.scriptName = "slicing.lua";

  meta = {
    description = "Lua script to cut fragments of the video in uncompressed RGB format";
    homepage = "https://github.com/Kagami/mpv_slicing";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

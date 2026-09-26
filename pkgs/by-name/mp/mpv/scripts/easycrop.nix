{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
}:

buildLua {
  pname = "easycrop";
  version = "0-unstable-2018-01-24";

  src = fetchFromGitHub {
    owner = "aidanholm";
    repo = "mpv-easycrop";
    rev = "b8a67bb9039e19dec54d92ea57076c0c98e981aa";
    hash = "sha256-VRQP8j/Z/OvVqrEpvWcLmJFotxbTRynHoqvfIQIQmqY=";
  };

  scriptPath = "easycrop.lua";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Manually crop videos during playback in mpv";
    longDescription = ''
      A simple mpv script for manually cropping videos with ease.

      - Works during video playback
      - No need to re-encode or modify video files

      Press "c" to begin cropping. Click at one corner of the desired
      cropping rectangle, and click a second time at the opposite
      corner; the video will be cropped immediately. Pressing "c" again
      will undo the current crop.

      If you wish to use a key other than "c" to crop, the keybind
      `easy_crop` can be changed.
    '';
    homepage = "https://github.com/aidanholm/mpv-easycrop";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
}

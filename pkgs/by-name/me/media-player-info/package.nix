{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  python3,
  udev,
  udevCheckHook,
  systemd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "media-player-info";
  version = "26";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "media-player-info";
    repo = "media-player-info";
    rev = finalAttrs.version;
    hash = "sha256-VoMr5Lxy6u/BA/9t65/S8AW41YU0FLp6eftYUVdoMjY=";
  };

  buildInputs = [
    udev
    systemd
  ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    udevCheckHook
  ];

  doInstallCheck = true;

  postPatch = ''
    patchShebangs ./tools
  '';

  configureFlags = [ "--with-udevdir=${placeholder "out"}/lib/udev" ];

  meta = {
    description = "Repository of data files describing media player capabilities";
    homepage = "https://www.freedesktop.org/wiki/Software/media-player-info/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ttuegel ];
    platforms = with lib.platforms; linux;
  };
})

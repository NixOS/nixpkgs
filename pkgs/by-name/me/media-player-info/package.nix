{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  pkg-config,
  python3,
  udev,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "media-player-info";
  version = "26";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "media-player-info";
    repo = "media-player-info";
    rev = version;
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
  ];

  postPatch = ''
    patchShebangs ./tools
  '';

  configureFlags = [ "--with-udevdir=${placeholder "out"}/lib/udev" ];

  meta = with lib; {
    description = "Repository of data files describing media player capabilities";
    homepage = "https://www.freedesktop.org/wiki/Software/media-player-info/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ttuegel ];
    platforms = with platforms; linux;
  };
}

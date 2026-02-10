{
  lib,
  stdenv,
  vdr,
  alsa-lib,
  fetchFromGitHub,
  libxcb-wm,
  xorg-server,
  ffmpeg,
  libva,
  libvdpau,
  libx11,
  libxcb,
  libGL,
  libGLU,
}:
stdenv.mkDerivation rec {
  pname = "vdr-softhddevice";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "ua0lnj";
    repo = "vdr-plugin-softhddevice";
    sha256 = "sha256-69mLiu/v+iZntrGvL0eNE/dDQwRVIlg5MfsNTr52Ots=";
    rev = "v${version}";
  };

  buildInputs = [
    vdr
    libxcb-wm
    ffmpeg
    alsa-lib
    libva
    libvdpau
    libxcb
    libx11
    libGL
    libGLU
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace softhddev.c \
      --replace "LOCALBASE \"/bin/X\"" "\"${xorg-server}/bin/X\""
  '';

  meta = {
    inherit (src.meta) homepage;
    description = "VDR SoftHDDevice Plug-in";
    maintainers = [ lib.maintainers.ck3d ];
    license = lib.licenses.gpl2;
    inherit (vdr.meta) platforms;
  };

}

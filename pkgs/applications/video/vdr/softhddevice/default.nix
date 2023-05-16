{ lib
, stdenv
, vdr
, alsa-lib
, fetchFromGitHub
, xcbutilwm
, xorgserver
, ffmpeg
, libva
, libvdpau
, xorg
}:
stdenv.mkDerivation rec {
  pname = "vdr-softhddevice";
<<<<<<< HEAD
  version = "1.12.1";
=======
  version = "1.9.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ua0lnj";
    repo = "vdr-plugin-softhddevice";
<<<<<<< HEAD
    sha256 = "sha256-/Q+O/6kK55E+JN1khRvM7F6H/Vnp/OOD80eU4zmrBt8=";
=======
    sha256 = "sha256-SviAuV+71pxnuEcmoLQkA1yti2jAAuG7yZZDlf3cODc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rev = "v${version}";
  };

  buildInputs = [
    vdr
    xcbutilwm
    ffmpeg
    alsa-lib
    libva
    libvdpau
    xorg.libxcb
    xorg.libX11
  ];

  makeFlags = [ "DESTDIR=$(out)" ];

  postPatch = ''
    substituteInPlace softhddev.c \
      --replace "LOCALBASE \"/bin/X\"" "\"${xorgserver}/bin/X\""
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "VDR SoftHDDevice Plug-in";
    maintainers = [ maintainers.ck3d ];
    license = licenses.gpl2;
    inherit (vdr.meta) platforms;
  };

}

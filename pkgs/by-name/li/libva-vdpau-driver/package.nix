{ lib, stdenv, fetchurl, fetchpatch, libvdpau, libGLU, libGL, libva, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libva-vdpau-driver";
  version = "0.7.4";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/vaapi/releases/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "1fcvgshzyc50yb8qqm6v6wn23ghimay23ci0p8sm8gxcy211jp0m";
  };

  patches = [
    (fetchpatch { url = "https://src.fedoraproject.org/rpms/libva-vdpau-driver/raw/0ad71107e28a60ea453ac70e895cf64342bd58d0/f/libva-vdpau-driver-0.7.4-glext-85.patch";
                  sha256 = "0f0v7cl7kna3jcfnxw48b9mfl0hpacw72df9vym96sa2206vqlb0"; })
    (fetchpatch { url = "https://src.fedoraproject.org/rpms/libva-vdpau-driver/raw/0ad71107e28a60ea453ac70e895cf64342bd58d0/f/libva-vdpau-driver-0.7.4-drop-h264-api.patch";
                  sha256 = "0q5w83jbf4qqmhwf54h906pzxgvhqv7g2vrkw7jzgnrxhhj9sj60"; })
    (fetchpatch { url = "https://src.fedoraproject.org/rpms/libva-vdpau-driver/raw/0ad71107e28a60ea453ac70e895cf64342bd58d0/f/libva-vdpau-driver-0.7.4-fix_type.patch";
                  sha256 = "0s5dk6aa4sm0iyicnf2fwfsrqbvr58nbp77mhjg5bvwlar7znqv7"; })
    (fetchpatch { url = "https://src.fedoraproject.org/rpms/libva-vdpau-driver/raw/0ad71107e28a60ea453ac70e895cf64342bd58d0/f/sigfpe-crash.patch";
                  sha256 = "15snqf60ib0xb3cnav5b2r55qv8lv2fa4p6jwxajh8wbvqpw0ibz"; })
    (fetchpatch { url = "https://src.fedoraproject.org/rpms/libva-vdpau-driver/raw/0ad71107e28a60ea453ac70e895cf64342bd58d0/f/implement-vaquerysurfaceattributes.patch";
                  sha256 = "1dapx3bqqblw6l2iqqw1yff6qifam8q4m2rq343kwb3dqhy2ymy5"; })
    (fetchpatch { url = "https://github.com/gentoo/gentoo/raw/34d5cc6fcf1d76c1c2833cb534717246c221214c/x11-libs/libva-vdpau-driver/files/libva-vdpau-driver-0.7.4-include-linux-videodev2.h.patch";
                  sha256 = "1m4is6lk580mppsx2mvdv1xifj6gvx724si4qynsm9qrdfdc9fby"; })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libvdpau libGLU libGL libva ];

  postPatch = ''
    sed -i -e "s,LIBVA_DRIVERS_PATH=.*,LIBVA_DRIVERS_PATH=$out/lib/dri," configure
  '';

  meta = with lib; {
    homepage = "https://cgit.freedesktop.org/vaapi/vdpau-driver";
    license = licenses.gpl2Plus;
    description = "VDPAU driver for the VAAPI library";
    platforms = platforms.linux;
  };
}

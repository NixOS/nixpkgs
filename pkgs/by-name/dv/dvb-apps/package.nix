{ lib
, stdenv
, fetchurl
, perl
, fetchpatch
}:
stdenv.mkDerivation {
  pname = "dvb-apps";
  version = "1.1.1-unstable-2014-03-21";

  src = fetchurl {
    url = "https://www.linuxtv.org/hg/dvb-apps/archive/3d43b280298c.tar.bz2";
    hash = "sha256-854vDr7X4yvOg1IgYq1NQU9n/M1d8bZHYYUkSX4V4Fc=";
  };

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-glibc-2.31.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-zSbbKSJgW4L983DR0GVXtgAHK6ILOQC3Gz2iGnmWOp8=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-no-ca_set_pid.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-GZunNYlhktalPOZ4ZST1MwooBvdDGA6ckscx/7mx8ok=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-1.1.1.20100223-alevt.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-+j+tP8O3mho+gcsDPzQUJaE39ZAgimMAJoRP1J1HrBk=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-1.1.1.20100223-ldflags.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-jrRE1yySLbQWbF+SaugFN8VuEIfveSvjR0nKpmKffpQ=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-1.1.1.20100223-perl526.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-zIROx0HEvtZqvNBLlKp3aI3S2CihuS6l/OWf6WFFCrY=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-1.1.1.20140321-dvbdate.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-dLPlscdDOd7Kq+2sEhgJ/PBY1zN/0/fh3TU6JOELaYw=";
    })
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/media-tv/linuxtv-dvb-apps/files/linuxtv-dvb-apps-1.1.1.20140321-gcc10.patch?id=ec6d38022bd905cb5460d4812e52434fd1f9663c";
      hash = "sha256-034TYxH1qHcdkwVxuAcNHORfBWhw/k8P+11QAc3jp74=";
    })
    (fetchpatch {
      url = "https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=779520;filename=bug779520.patch;msg=17";
      hash = "sha256-UL5lKDfloXvngsabnslpVXbe/dmt4dzVK5W8JkIieps=";
    })
  ];

  buildInputs = [ perl ];

  installFlags = [ "prefix=$(out)" ];

  dontConfigure = true; # skip configure

  meta = {
    description = "Linux DVB API applications and utilities";
    homepage = "https://linuxtv.org/";
    maintainers = with lib.maintainers; [ volfyd ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}

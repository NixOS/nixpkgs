{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libnfnetlink,
  libmnl,
}:

stdenv.mkDerivation rec {
  pname = "libnetfilter_log";
  version = "1.0.2";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_log/files/${pname}-${version}.tar.bz2";
    sha256 = "1spy9xs41v76kid5ana8n126f3mvgq6fjibbfbj4kn0larbhix73";
  };

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Userspace library providing interface to packets that have been logged by the kernel packet filter";
    longDescription = ''
      libnetfilter_log is a userspace library providing interface to packets
      that have been logged by the kernel packet filter. It is is part of a
      system that deprecates the old syslog/dmesg based packet logging. This
      library has been previously known as libnfnetlink_log.
    '';
    homepage = "https://netfilter.org/projects/libnetfilter_log/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}

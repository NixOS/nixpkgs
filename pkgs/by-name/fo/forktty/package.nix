{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "forktty";
  version = "1.3";

  src = fetchurl {
    url = "mirror://ibiblioPubLinux/utils/terminal/${pname}-${version}.tgz";
    hash = "sha256-6xc5eshCuCIOsDh0r2DizKAeypGH0TRRotZ4itsvpVk=";
  };

  preBuild = ''
    sed -e s@/usr/bin/ginstall@install@g -i Makefile
  '';

  preInstall = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/man/man8"
  '';

  makeFlags = [
    "prefix=$(out)"
    "manprefix=$(out)/share/"
  ];

  meta = with lib; {
    description = "Tool to detach from controlling TTY and attach to another";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}

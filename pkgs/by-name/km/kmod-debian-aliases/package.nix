{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "kmod-debian-aliases.conf";
  version = "30+20230601-2";

  src = fetchurl {
    url = "https://snapshot.debian.org/archive/debian/20231117T085632Z/pool/main/k/kmod/kmod_${version}.debian.tar.xz";
    hash = "sha256-xJMGKht8hu0aQjN9TER87Rv5EYkVMeDfX/jJ8+UjAqM=";
  };

  installPhase = ''
    cp extra/aliases.conf $out
  '';

  meta = with lib; {
    homepage = "https://packages.debian.org/source/sid/kmod";
    description = "Linux configuration file for modprobe";
    maintainers = with maintainers; [ mathnerd314 ];
    platforms = with platforms; linux;
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
  };
}

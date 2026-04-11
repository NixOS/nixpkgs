{
  stdenv,
  fetchurl,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmod-debian-aliases.conf";
  version = "30+20230601-2";

  src = fetchurl {
    url = "https://snapshot.debian.org/archive/debian/20231117T085632Z/pool/main/k/kmod/kmod_${finalAttrs.version}.debian.tar.xz";
    hash = "sha256-xJMGKht8hu0aQjN9TER87Rv5EYkVMeDfX/jJ8+UjAqM=";
  };

  installPhase = ''
    cp extra/aliases.conf $out
  '';

  meta = {
    homepage = "https://packages.debian.org/source/sid/kmod";
    description = "Linux configuration file for modprobe";
    maintainers = with lib.maintainers; [ mathnerd314 ];
    platforms = with lib.platforms; linux;
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
    ];
  };
})

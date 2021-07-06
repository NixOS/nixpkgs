{ lib, stdenv, fetchurl, dpkg }:

with lib;

stdenv.mkDerivation {
  name = "parsec-gaming";
  src = fetchurl {
    url = "https://builds.parsecgaming.com/package/parsec-linux.deb";
    sha256 = "1hfdzjd8qiksv336m4s4ban004vhv00cv2j461gc6zrp37s0fwhc";
  };
  phases = [ "buildPhase" ];
  buildInputs = [ dpkg ];
  buildPhase = ''
    mkdir -p $out
    dpkg-deb -x $src $out

    # Fix desktop file
    sed -i "s|/usr|$out|g" $out/usr/share/applications/parsecd.desktop

    # dpkg-deb makes $out group-writable, which nix doesn't like
    chmod 755 $out
    mv $out/usr/* $out
    rmdir $out/usr
  '';
  meta = {
    description = "Remote desktop for work and gaming";
    homepage = "https://parsec.app/";
    license = licenses.unfree;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux;
  };
};

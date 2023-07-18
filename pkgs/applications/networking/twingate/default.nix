{ autoPatchelfHook
, curl
, dpkg
, dbus
, fetchurl
, lib
, libnl
, udev
, cryptsetup
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "twingate";
  version = "1.0.83+88994";

  src = fetchurl {
    url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
    sha256 = "acf623192ae348d49d8cc6513f419dedaf65442f88d3aa0ebd964450427ab399";
  };

  buildInputs = [ dbus curl libnl udev cryptsetup ];
  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";

  postPatch = ''
    while read file; do
      substituteInPlace "$file" \
        --replace "/usr/bin" "$out/bin" \
        --replace "/usr/sbin" "$out/bin"
    done < <(find etc usr/lib usr/share -type f)
  '';

  installPhase = ''
    mkdir $out
    mv etc $out/
    mv usr/bin $out/bin
    mv usr/sbin/* $out/bin
    mv usr/lib $out/lib
    mv usr/share $out/share
  '';

  meta = with lib; {
    description = "Twingate Client";
    homepage = "https://twingate.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ tonyshkurenko ];
    platforms = platforms.linux;
  };
}

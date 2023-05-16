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
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "twingate";
<<<<<<< HEAD
  version = "2023.227.93197";

  src = fetchurl {
    url = "https://binaries.twingate.com/client/linux/DEB/x86_64/${version}/twingate-amd64.deb";
    hash = "sha256-YV56U+RXpTOJvyufVKtTY1c460//ZJcifq2XroTQLXU=";
  };

  buildInputs = [
    dbus
    curl
    libnl
    udev
    cryptsetup
  ];

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
=======
  version = "1.0.60";

  src = fetchurl {
    url = "https://binaries.twingate.com/client/linux/DEB/${version}/twingate-amd64.deb";
    sha256 = "b308c422af8a33ecd58e21a10a72c353351a189df67006e38d1ec029a93d5678";
  };

  buildInputs = [ dbus curl libnl udev cryptsetup ];
  nativeBuildInputs = [ dpkg autoPatchelfHook ];

  unpackCmd = "mkdir root ; dpkg-deb -x $curSrc root";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  passthru.tests = { inherit (nixosTests) twingate; };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Twingate Client";
    homepage = "https://twingate.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ tonyshkurenko ];
<<<<<<< HEAD
    platforms = [ "x86_64-linux" ];
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

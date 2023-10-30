{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config, cmake, ninja, yasm
, libjpeg, openssl, libopus, ffmpeg, alsa-lib, libpulseaudio, protobuf
, openh264, usrsctp, libevent, libvpx
, libX11, libXtst, libXcomposite, libXdamage, libXext, libXrender, libXrandr, libXi
, glib, abseil-cpp, pcre, util-linuxMinimal, libselinux, libsepol, pipewire
, mesa, libepoxy, libglvnd, unstableGitUpdater
}:

stdenv.mkDerivation {
  pname = "tg_owt";
  version = "unstable-2023-10-17";

  src = fetchFromGitHub {
    owner = "desktop-app";
    repo = "tg_owt";
    rev = "be153adaa363b2b13242466ad5b7b87f61301639";
    sha256 = "sha256-/hZNMV+IG00YzxH66Gh/BW9JdGFfsfnM93eD6oB3tlI=";
    fetchSubmodules = true;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ pkg-config cmake ninja yasm ];

  buildInputs = [
    libjpeg libopus ffmpeg alsa-lib libpulseaudio protobuf
    openh264 usrsctp libevent libvpx
    libX11 libXtst libXcomposite libXdamage libXext libXrender libXrandr libXi
    glib abseil-cpp pcre util-linuxMinimal libselinux libsepol pipewire
    mesa libepoxy libglvnd
  ];

  patches = [
    # GCC 12 Fix
    (fetchpatch {
      url = "https://github.com/desktop-app/tg_owt/pull/101/commits/86d2bcd7afb8706663d29e30f65863de5a626142.patch";
      hash = "sha256-iWS0mB8R0vqPU/0qf6Ax54UCAKYDVCPac2mi/VHbFm0=";
    })
    # additional fix for GCC 12 + musl
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/community/tg_owt/gcc12.patch?id=8120df03fa3b6db5b8ff92c7a52b680290ad6e20";
      hash = "sha256-ikgxUH1e7pz0n0pKUemrPXXa4UkECX+w467M9gU68zs=";
    })
  ];

  cmakeFlags = [
    # Building as a shared library isn't officially supported and may break at any time.
    "-DBUILD_SHARED_LIBS=OFF"
  ];

  propagatedBuildInputs = [
    # Required for linking downstream binaries.
    abseil-cpp openh264 usrsctp libevent libvpx openssl
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxalica ];
  };
}

{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libraspberrypi";
  version = "unstable-2022-06-16";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "54fd97ae4066a10b6b02089bc769ceed328737e0";
    hash = "sha512-f7tBgIykcIdkwcFjBKk5ooD/5Bsyrd/0OFr7LNCwWFYeE4DH3XA7UR7YjArkwqUVCVBByr82EOaacw0g1blOkw==";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [
    # -DARM64=ON disables all targets that only build on 32-bit ARM; this allows
    # the package to build on aarch64 and other architectures
    "-DARM64=${if stdenv.hostPlatform.isAarch32 then "OFF" else "ON"}"
    "-DVMCS_INSTALL_PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Userland tools & libraries for interfacing with Raspberry Pi hardware";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ dezgeg tkerber ];
  };
}

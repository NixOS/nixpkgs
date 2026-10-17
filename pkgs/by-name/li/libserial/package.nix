{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libserial";
  version = "1.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "crayzeewulf";
    repo = "libserial";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pZtZiKBaG5G8+Sx2r2Zd9bA8JyykJQMTvYxiAcMdbJU=";
  };

  patches = [
    ./cmake-deps.patch
    ./include-cstdint.patch
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  doCheck = false;

  meta = {
    description = "Serial port programming in C++";
    homepage = "https://github.com/crayzeewulf/libserial";
    changelog = "https://github.com/crayzeewulf/libserial/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.bugsaplenty ];
    platforms = lib.platforms.unix;
  };
  passthru.tests.pty-roundtrip = stdenv.mkDerivation {
    name = "libserial-pty-roundtrip-test";
    dontUnpack = true;
    buildInputs = [ finalAttrs.finalPackage ];
    installPhase = ''
      cat > test.cpp <<'EOF'
      #include <libserial/SerialPort.h>
      #include <fcntl.h>
      #include <unistd.h>
      #include <cassert>
      #include <cstring>
      #include <iostream>

      int main() {
          int master = posix_openpt(O_RDWR | O_NOCTTY);
          if (master < 0 || grantpt(master) != 0 || unlockpt(master) != 0) return 1;
          const std::string slaveDevice = ptsname(master);

          LibSerial::SerialPort port;
          port.Open(slaveDevice);
          port.SetBaudRate(LibSerial::BaudRate::BAUD_115200);
          port.SetCharacterSize(LibSerial::CharacterSize::CHAR_SIZE_8);
          port.SetFlowControl(LibSerial::FlowControl::FLOW_CONTROL_NONE);
          port.SetParity(LibSerial::Parity::PARITY_NONE);
          port.SetStopBits(LibSerial::StopBits::STOP_BITS_1);

          const std::string out = "nix-roundtrip";
          port.Write(out);
          char buf[64] = {0};
          assert(::read(master, buf, sizeof buf) == (ssize_t)out.size());
          assert(std::memcmp(buf, out.data(), out.size()) == 0);

          assert(::write(master, "ok", 2) == 2);
          std::string got;
          port.Read(got, 2, 1000);
          assert(got == "ok");

          std::cout << "pty roundtrip OK" << std::endl;
          return 0;
      }
      EOF
      $CXX -std=c++14 test.cpp -lserial -o test
      ./test
      touch $out
    '';
  };
})

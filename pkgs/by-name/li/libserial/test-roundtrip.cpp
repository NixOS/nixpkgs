#include <libserial/SerialPort.h>

#include <cassert>
#include <cstring>
#include <fcntl.h>
#include <iostream>
#include <unistd.h>

int main()
{
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

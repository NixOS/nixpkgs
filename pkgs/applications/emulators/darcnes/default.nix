{ lib, stdenv, fetchurl, libX11, libXt, libXext, libXaw }:

stdenv.mkDerivation rec {
  pname = "darcnes";
  version = "9b0401";

  src = fetchurl {
    url = "https://web.archive.org/web/20130511081532/http://www.dridus.com/~nyef/darcnes/download/dn${version}.tgz";
    sha256 = "05a7mh51rg7ydb414m3p5mm05p4nz2bgvspqzwm3bhbj7zz543k3";
  };

  patches = [ ./label.patch ];

  buildInputs = [ libX11 libXt libXext libXaw ];
  installPhase = "install -Dt $out/bin darcnes";

  meta = {
    homepage = "https://web.archive.org/web/20130502171725/http://www.dridus.com/~nyef/darcnes/";
    description = "Sega Master System, Game Gear, SG-1000, NES, ColecoVision and Apple II emulator";
    # Prohibited commercial use, credit required.
    license = lib.licenses.free;
    platforms = [ "i686-linux" ];
  };
}

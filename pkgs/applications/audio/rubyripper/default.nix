{ lib, stdenv, fetchurl, ruby, cdparanoia, makeWrapper }:
stdenv.mkDerivation rec {
  version = "0.6.2";
  pname = "rubyripper";
  src = fetchurl {
    url = "https://rubyripper.googlecode.com/files/rubyripper-${version}.tar.bz2";
    sha256 = "1fwyk3y0f45l2vi3a481qd7drsy82ccqdb8g2flakv58m45q0yl1";
  };

  preConfigure = "patchShebangs .";

  configureFlags = [ "--enable-cli" ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ruby cdparanoia ];
  postInstall = ''
    wrapProgram "$out/bin/rrip_cli" \
      --prefix PATH : "${ruby}/bin" \
      --prefix PATH : "${cdparanoia}/bin"
  '';

  meta = with lib; {
    description = "High quality CD audio ripper";
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}

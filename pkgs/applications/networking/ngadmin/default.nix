{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  readline,
  withReadline ? true,
  enableEmu ? true,
  enableSpy ? true,
}:

stdenv.mkDerivation {
  pname = "ngadmin";
  version = "unstable-2020-10-05";

  src = fetchFromGitHub {
    owner = "Alkorin";
    repo = "ngadmin";
    rev = "5bf8650ce6d465b8cb1e570548819f0cefe9a87d";
    sha256 = "15vixhwqcpbjdxlaznans9w63kwl29mdkds6spvbv2i7l33qnhq4";
  };

  nativeBuildInputs = [ autoreconfHook ] ++ lib.optional withReadline readline;
  enableParallelBuilding = true;
  configureFlags =
    with lib;
    optional (!withReadline) "--without-readline"
    ++ optional enableEmu "--enable-emu"
    ++ optional enableSpy "--enable-spy";

  meta = with lib; {
    description = "Netgear switch (NSDP) administration tool";
    homepage = "https://www.netgeek.ovh/wiki/projets:ngadmin";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.astro ];
  };
}

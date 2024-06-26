{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gnuclad";
  version = "0.2.4";

  src = fetchurl {
    url = "https://launchpad.net/gnuclad/trunk/${lib.versions.majorMinor version}/+download/${pname}-${version}.tar.gz";
    sha256 = "0ka2kscpjff7gflsargv3r9fdaxhkf3nym9mfaln3pnq6q7fwdki";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=catch-value";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    homepage = "https://launchpad.net/gnuclad";
    description = "gnuclad tries to help the environment by creating trees.  Its primary use will be generating cladogram trees for the GNU/Linux distro timeline project";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
    mainProgram = "gnuclad";
  };
}

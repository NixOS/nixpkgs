{
  lib,
  stdenv,
  fetchurl,
  flex,
  bison,
  sendmailPath ? "/run/wrappers/bin/sendmail",
}:

stdenv.mkDerivation rec {
  pname = "petidomo";
  version = "4.3";

  src = fetchurl {
    url = "mirror://sourceforge/petidomo/${pname}-${version}.tar.gz";
    sha256 = "0x4dbxc4fcfg1rw5ywpcypvylnzn3y4rh0m6fz4h4cdnzb8p1lvm";
  };

  buildInputs = [
    flex
    bison
  ];

  configureFlags = [ "--with-mta=${sendmailPath}" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "https://petidomo.sourceforge.net/";
    description = "Simple and easy to administer mailing list server";
    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.peti ];
  };
}

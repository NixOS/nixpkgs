{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  gettext,
  libidn2,
  libmaxminddb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "subnetcalc";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "dreibh";
    repo = "subnetcalc";
    tag = "subnetcalc-${finalAttrs.version}";
    hash = "sha256-xMWEd8F6tQuKVL4aybdwsidBbmPItuNd6iCZUfzjVLA=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    gettext
  ];

  buildInputs = [
    libidn2
    libmaxminddb
  ];

  meta = {
    description = "IPv4/IPv6 subnet address calculator";
    homepage = "https://www.nntb.no/~dreibh/subnetcalc/";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      SubNetCalc is an IPv4/IPv6 subnet address calculator. For given IPv4 or
      IPv6 address and netmask or prefix length, it calculates network address,
      broadcast address, maximum number of hosts and host address range. Also,
      it prints the addresses in binary format for better understandability.
      Furthermore, it prints useful information on specific address types (e.g.
      type, scope, interface ID, etc.).
    '';
    mainProgram = "subnetcalc";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})

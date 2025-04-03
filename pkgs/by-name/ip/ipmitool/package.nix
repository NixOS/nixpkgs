{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  openssl,
  readline,
  fetchurl,
}:

let
  iana-enterprise-numbers = fetchurl {
    url = "https://web.archive.org/web/20230312103209id_/https://www.iana.org/assignments/enterprise-numbers.txt";
    sha256 = "sha256-3Z5uoOYfbF1o6MSgvnr00w4Z5w4IHc56L1voKDzeH/w=";
  };
in
stdenv.mkDerivation {
  pname = "ipmitool";
  version = "1.8.19-unstable-2023-01-12";

  src = fetchFromGitHub {
    owner = "ipmitool";
    repo = "ipmitool";
    rev = "be11d948f89b10be094e28d8a0a5e8fb532c7b60";
    hash = "sha256-5s0F2cTZdmRb/I0rPqX/8KgK/7b5VCl3Hj/ALKpGbMQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    openssl
    readline
  ];

  postPatch = ''
    # Fixes `ipmi_fru.c:1556:41: error: initialization of 'struct fru_multirec_mgmt *' from incompatible pointer type 'struct fru_multirect_mgmt *' []`
    # Probably fine before GCC14, but this is an error now.
    substituteInPlace lib/ipmi_fru.c \
      --replace-fail fru_multirect_mgmt fru_multirec_mgmt
    cp ${iana-enterprise-numbers} enterprise-numbers
  '';

  configureFlags = [ "--disable-registry-download" ];

  meta = {
    description = "Command-line interface to IPMI-enabled devices";
    mainProgram = "ipmitool";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/ipmitool/ipmitool";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}

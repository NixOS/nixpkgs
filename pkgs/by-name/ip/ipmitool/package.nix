{ stdenv, lib, fetchFromGitHub, autoreconfHook, openssl, readline, fetchurl }:

let

  iana-enterprise-numbers = fetchurl {
    url = "https://web.archive.org/web/20230312103209id_/https://www.iana.org/assignments/enterprise-numbers.txt";
    sha256 = "sha256-3Z5uoOYfbF1o6MSgvnr00w4Z5w4IHc56L1voKDzeH/w=";
  };

in stdenv.mkDerivation rec {
  pname = "ipmitool";
  version = "1.8.19";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "IPMITOOL_${lib.replaceStrings ["."] ["_"] version}";
    hash = "sha256-VVYvuldRIHhaIUibed9cLX8Avfy760fdBLNO8MoUKCk=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl readline ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace 'AC_MSG_WARN([** Neither wget nor curl could be found.])' 'AM_CONDITIONAL([DOWNLOAD], [true])'
    cp ${iana-enterprise-numbers} enterprise-numbers
  '';

  meta = with lib; {
    description = "Command-line interface to IPMI-enabled devices";
    mainProgram = "ipmitool";
    license = licenses.bsd3;
    homepage = "https://github.com/ipmitool/ipmitool";
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}

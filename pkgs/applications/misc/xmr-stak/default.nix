{ stdenv, stdenvGcc6, lib
, fetchFromGitHub, cmake, libmicrohttpd_0_9_70, openssl
, opencl-headers, ocl-icd, hwloc
, devDonationLevel ? "0.0"
, openclSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "xmr-stak";
  version = "2.10.8";

  src = fetchFromGitHub {
    owner = "fireice-uk";
    repo = "xmr-stak";
    rev = version;
    sha256 = "0ilx5mhh91ks7dwvykfyynh53l6vkkignjpwkkss8ss6b2k8gdbj";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  cmakeFlags = [ "-DCUDA_ENABLE=OFF" ]
    ++ lib.optional (!openclSupport) "-DOpenCL_ENABLE=OFF";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libmicrohttpd_0_9_70 openssl hwloc ]
    ++ lib.optionals openclSupport [ opencl-headers ocl-icd ];

  postPatch = ''
    substituteInPlace xmrstak/donate-level.hpp \
      --replace 'fDevDonationLevel = 2.0' 'fDevDonationLevel = ${devDonationLevel}'
  '';

  meta = with lib; {
    description = "Unified All-in-one Monero miner";
    homepage = "https://github.com/fireice-uk/xmr-stak";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz ];
  };
}

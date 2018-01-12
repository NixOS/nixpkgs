{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl
, opencl-headers, ocl-icd, hwloc, cudatoolkit
, devDonationLevel ? "0.0"
, cudaSupport ? false
, openclSupport ? false
}:

stdenv.mkDerivation rec {
  name = "xmr-stak-${version}";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "fireice-uk";
    repo = "xmr-stak";
    rev = "v${version}";
    sha256 = "0n21y37d8khgfk9965mrhnh6y5ag7w0s6as1fmf76yx6vajvajsn";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  cmakeFlags = lib.optional (!cudaSupport) "-DCUDA_ENABLE=OFF"
    ++ lib.optional (!openclSupport) "-DOpenCL_ENABLE=OFF";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libmicrohttpd openssl hwloc ]
    ++ lib.optional cudaSupport cudatoolkit
    ++ lib.optionals openclSupport [ opencl-headers ocl-icd ];

  postPatch = ''
    substituteInPlace xmrstak/donate-level.hpp \
      --replace 'fDevDonationLevel = 2.0' 'fDevDonationLevel = ${devDonationLevel}'
  '';

  meta = with lib; {
    description = "Unified All-in-one Monero miner";
    homepage = "https://github.com/fireice-uk/xmr-stak";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fpletz ];
  };
}

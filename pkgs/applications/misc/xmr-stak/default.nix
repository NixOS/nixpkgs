{ stdenv, stdenvGcc6, lib
, fetchFromGitHub, cmake, libmicrohttpd, openssl
, opencl-headers, ocl-icd, hwloc, cudatoolkit
, devDonationLevel ? "0.0"
, cudaSupport ? false
, openclSupport ? true
}:

let
  stdenv' = if cudaSupport then stdenvGcc6 else stdenv;
in

stdenv'.mkDerivation rec {
  name = "xmr-stak-${version}";
  version = "2.10.5";

  src = fetchFromGitHub {
    owner = "fireice-uk";
    repo = "xmr-stak";
    rev = "${version}";
    sha256 = "16b6bj0rsr3cq9x3gxm54j197827d8lnfk7ghfjmaf7qa3q08adx";
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
    maintainers = with maintainers; [ fpletz bfortz ];
  };
}

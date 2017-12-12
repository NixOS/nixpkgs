{ stdenv, lib, fetchFromGitHub, cmake, libuv, libmicrohttpd, openssl
, opencl-headers, ocl-icd, hwloc, cudatoolkit
, devDonationLevel ? "0.0"
, cudaSupport ? false  # doesn't work currently
}:

stdenv.mkDerivation rec {
  name = "xmr-stak-${version}";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "fireice-uk";
    repo = "xmr-stak";
    rev = "v${version}";
    sha256 = "1gsp5d2qmc8qwbfm87c2vnak6ks6y9csfjbsi0570pdciapaf8vs";
  };

  NIX_CFLAGS_COMPILE = "-O3";

  cmakeFlags = lib.optional (!cudaSupport) "-DCUDA_ENABLE=OFF";

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [ libmicrohttpd openssl opencl-headers ocl-icd hwloc ]
    ++ lib.optional cudaSupport cudatoolkit;

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

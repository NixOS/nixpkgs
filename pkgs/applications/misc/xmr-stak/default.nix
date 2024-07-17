{
  stdenv,
  lib,
  fetchpatch,
  fetchFromGitHub,
  cmake,
  libmicrohttpd,
  openssl,
  opencl-headers,
  ocl-icd,
  hwloc,
  devDonationLevel ? "0.0",
  openclSupport ? true,
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

  env.NIX_CFLAGS_COMPILE = "-O3";

  patches = [
    (fetchpatch {
      name = "fix-libmicrohttpd-0-9-71.patch";
      url = "https://github.com/fireice-uk/xmr-stak/compare/06e08780eab54dbc025ce3f38c948e4eef2726a0...8adb208987f5881946992ab9cd9a45e4e2a4b870.patch";
      excludes = [ "CMakeLists.txt.user" ];
      hash = "sha256-Yv0U5EO1P5eikn1fKvUXEwemoUIjjeTjpP9p5J8pbC0=";
    })
  ];

  cmakeFlags = [ "-DCUDA_ENABLE=OFF" ] ++ lib.optional (!openclSupport) "-DOpenCL_ENABLE=OFF";

  nativeBuildInputs = [ cmake ];
  buildInputs =
    [
      libmicrohttpd
      openssl
      hwloc
    ]
    ++ lib.optionals openclSupport [
      opencl-headers
      ocl-icd
    ];

  postPatch = ''
    substituteInPlace xmrstak/donate-level.hpp \
      --replace 'fDevDonationLevel = 2.0' 'fDevDonationLevel = ${devDonationLevel}'
  '';

  meta = with lib; {
    # Does not build against gcc-13. No development activity upstream
    # for past few years.
    broken = true;
    description = "Unified All-in-one Monero miner";
    homepage = "https://github.com/fireice-uk/xmr-stak";
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bfortz ];
  };
}

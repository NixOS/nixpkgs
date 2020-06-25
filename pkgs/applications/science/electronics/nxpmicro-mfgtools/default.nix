{ stdenv,
  fetchFromGitHub,
  cmake,
  bzip2,
  libusb1,
  libzip,
  openssl,
  pkg-config
}:

stdenv.mkDerivation rec {
  name    = "nxpmicro-mfgtools-1.3.191";
  version = "uuu_1.3.191";

  meta = with stdenv.lib; {
    description = "uuu (Universal Update Utility), mfgtools 3.0";
    longDescription = ''
      Freescale/NXP I.MX Chip image deploy tools.
    '';
    homepage = https://github.com/NXPmicro/mfgtools;
    license = licenses.bsd3;
    maintainers = [ maintainers.bmilanov ];
    platforms = [ "x86_64-linux" ];
  };

  src = fetchFromGitHub {
    owner  = "NXPmicro";
    repo   = "mfgtools";
    rev    = version;
    sha256 = "196blmd7nf5kamvay22rvnkds2v6h7ab8lyl10dknxgy8i8siqq9";
  };

  preConfigure = "echo ${version} > .tarball-version";

  nativeBuildInputs = [ cmake ];
  buildInputs       = [ bzip2 libusb1 libzip openssl pkg-config ];
}


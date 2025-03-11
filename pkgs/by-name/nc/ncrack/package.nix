{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  openssl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ncrack";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "nmap";
    repo = "ncrack";
    rev = version;
    sha256 = "1gnv5xdd7n04glcpy7q1mkb6f8gdhdrhlrh8z6k4g2pjdhxlz26g";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains like upstream gcc-10:
    #   https://github.com/nmap/ncrack/pull/83
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/nmap/ncrack/commit/cc4103267bab6017a4da9d41156d0c1075012eba.patch";
      sha256 = "06nlfvc7p108f8ppbcgwmj4iwmjy95xhc1sawa8c78lrx22r7gy3";
    })
  ];

  # Our version is good; the check is bad.
  configureFlags = [ "--without-zlib-version-check" ];

  buildInputs = [
    openssl
    zlib
  ];

  meta = with lib; {
    description = "Network authentication tool";
    mainProgram = "ncrack";
    homepage = "https://nmap.org/ncrack/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}

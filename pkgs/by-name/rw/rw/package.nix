{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "rw";
  version = "1.0";

  src = fetchurl {
    url = "https://sortix.org/rw/release/rw-portable-${version}.tar.gz";
    # Use hash provided by upstream
    sha256 = "50009730e36991dfe579716f91f4f616f5ba05ffb7bf69c03d41bf305ed93b6d";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://sortix.org/rw";
    description = "Block device and byte copying program similar to dd";
    longDescription = ''
      rw is a command line program which copies information between files
      or byte streams. The rw command is designed to be a replacement for
      dd with standard style command line flags.
    '';
    license = licenses.isc;
    maintainers = with maintainers; [ dtzWill ];
    mainProgram = "rw";
  };
}

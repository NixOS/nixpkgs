{ lib, stdenv, fetchFromGitHub
, bash, libusb1, ncurses, rtl-sdr
}:

stdenv.mkDerivation rec {
  version = "1.12.0";
  pname = "wmbusmeters";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-3y9YTUXfFyZ4PqG4refwBhdnuHAp3FcEcDEQ/BVtT/U";
  };

  buildInputs = [ libusb1 ncurses rtl-sdr ];

  makeFlags = [
    "COMMIT_HASH="
    "TAG=${version}"
    "BRANCH="
    "CHANGES="
  ];

  preBuild = ''
    substituteInPlace scripts/*.sh \
      --replace "#!/bin/bash" "#!${bash}/bin/bash"
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    cp build/wmbusmeters build/wmbusmeters-admin $out/bin
    ln -s wmbusmeters $out/bin/wmbusmetersd

    gzip -v9 -n -c wmbusmeters.1 >$out/share/man/man1/wmbusmeters.1.gz
    gzip -v9 -n -c wmbusmeters-admin.1 >$out/share/man/man1/wmbusmeters-admin.1.gz
    ln -s wmbusmeters.1.gz $out/share/man/man1/wmbusmetersd.1.gz
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Acquires utility meter readings from wired M-BUS or wireless WM-BUS meters";
    homepage = "https://github.com/wmbusmeters/wmbusmeters";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ snicket2100 ];
    platforms = platforms.unix;
  };
}

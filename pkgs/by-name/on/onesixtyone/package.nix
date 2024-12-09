{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "onesixtyone";
  version = "unstable-2019-12-26";

  src = fetchFromGitHub {
    owner = "trailofbits";
    repo = "onesixtyone";
    rev = "9ce1dcdad73d45c8694086a4f90d7713be1cbdd7";
    sha256 = "111nxn4pcbx6p9j8cjjxv1j1s7dgf7f4dix8acsmahwbpzinzkg3";
  };

  buildPhase = ''
    $CC -o onesixtyone onesixtyone.c
  '';

  installPhase = ''
    install -D onesixtyone $out/bin/onesixtyone
  '';

  meta = with lib; {
    description = "Fast SNMP Scanner";
    homepage = "https://github.com/trailofbits/onesixtyone";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.fishi0x01 ];
    mainProgram = "onesixtyone";
  };
}


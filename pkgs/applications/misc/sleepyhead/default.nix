{ stdenv, fetchgit, qt5, zlib, libGLU, libX11 }:

let
  name = "sleepyhead-${version}";
  version = "1.0.0-beta-git";
in stdenv.mkDerivation {
  inherit name;

  src = fetchgit {
    url = https://gitlab.com/sleepyhead/sleepyhead-code.git;
    rev = "9e2329d8bca45693231b5e3dae80063717c24578";
    sha256 = "0448z8gyaxpgpnksg34lzmffj36jdpm0ir4xxa5gvzagkx0wk07h";
  };

  buildInputs = [
    qt5.qtbase qt5.qtwebkit qt5.qtserialport
    zlib
    libGLU
    libX11
  ];

  patchPhase = ''
    patchShebangs configure
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp sleepyhead/SleepyHead $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://sleepyhead.jedimark.net/;
    description = "Review and explore data produced by CPAP and related machines";
    longDescription = ''
      SleepyHead is cross platform, opensource sleep tracking program for reviewing CPAP and Oximetry data, which are devices used in the treatment of Sleep Disorders like Obstructive Sleep Apnea.
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.krav ];
  };

}

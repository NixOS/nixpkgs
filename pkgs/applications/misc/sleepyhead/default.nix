{ lib, stdenv, mkDerivation, fetchgit, zlib, libGLU, libX11, qtbase, qtwebkit, qtserialport, wrapQtAppsHook }:

let
  name = "sleepyhead-${version}";
  version = "20160426";
in mkDerivation {
  inherit name;

  src = fetchgit {
    url = "https://gitlab.com/sleepyhead/sleepyhead-code.git";
    rev = "9e2329d8bca45693231b5e3dae80063717c24578";
    sha256 = "sha256-8IDJQZ9P/f2K6p3kCOpt0gzpXP2UjKenve925R/6iBA=";
  };

  buildInputs = [
    qtbase qtwebkit qtserialport
    zlib
    libGLU
    libX11
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];

  patchPhase = ''
    patchShebangs configure
  '';

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    cp -r sleepyhead/SleepyHead.app $out/Applications
  '' else ''
    mkdir -p $out/bin
    cp sleepyhead/SleepyHead $out/bin
  '';

  postFixup = lib.optionalString stdenv.isDarwin ''
    wrapQtApp "$out/Applications/SleepyHead.app/Contents/MacOS/SleepyHead"
  '';

  meta = with lib; {
    homepage = "https://sleepyhead.jedimark.net/";
    description = "Review and explore data produced by CPAP and related machines";
    longDescription = ''
      SleepyHead is cross platform, opensource sleep tracking program for reviewing CPAP and Oximetry data, which are devices used in the treatment of Sleep Disorders like Obstructive Sleep Apnea.
    '';
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.krav ];
  };

}

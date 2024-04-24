{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, cglm
, gtk3
, libepoxy
, libGLU
}:

stdenv.mkDerivation rec {
  pname   = "fsv";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "jabl";
    repo  = "fsv";
    rev   = "${pname}-${version}";
    hash  = "sha256-fxsA3qcBPvK4H5P4juGTe6eg1lkygvzFpNW36B9lsE4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cglm
    gtk3
    libepoxy
    libGLU
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/fsv $out/bin/fsv

    runHook postInstall
  '';

  meta = with lib; {
    description     = "File system visualizer in cyberspace";
    longDescription = ''
      fsv (pronounced eff-ess-vee) is a file system visualizer in cyberspace.
      It lays out files and directories in three dimensions, geometrically
      representing the file system hierarchy to allow visual overview
      and analysis. fsv can visualize a modest home directory, a workstation's
      hard drive, or any arbitrarily large collection of files, limited only
      by the host computer's memory and graphics hardware.
    '';
    homepage    = "https://github.com/jabl/fsv";
    license     = licenses.lgpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
    mainProgram = "fsv";
  };
}

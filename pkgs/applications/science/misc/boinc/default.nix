{ fetchFromGitHub
, lib
, stdenv
, autoconf
, automake
, pkg-config
, m4
, curl
, libGLU
, libGL
, libXmu
, libXi
, freeglut
, libjpeg
, libtool
, wxGTK32
, xcbutil
, sqlite
, gtk3
, patchelf
, libXScrnSaver
, libnotify
, libX11
, libxcb
<<<<<<< HEAD
, headless ? false
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "boinc";
<<<<<<< HEAD
  version = "7.22.2";
=======
  version = "7.22.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    name = "${pname}-${version}-src";
    owner = "BOINC";
    repo = "boinc";
    rev = "client_release/${lib.versions.majorMinor version}/${version}";
<<<<<<< HEAD
    hash = "sha256-9GgvyYiDfppRuDFfxn50e+YZeSX0SLKSfo31lWx2FBs=";
=======
    hash = "sha256-DYbcWBJEjSJWRXNdumDhhybKSs8ofyREWqj2ghrvmBE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ libtool automake autoconf m4 pkg-config ];

  buildInputs = [
    curl
<<<<<<< HEAD
    sqlite
    patchelf
  ] ++ lib.optionals (!headless) [
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libGLU
    libGL
    libXmu
    libXi
    freeglut
    libjpeg
    wxGTK32
<<<<<<< HEAD
    gtk3
    libXScrnSaver
    libnotify
=======
    sqlite
    gtk3
    libXScrnSaver
    libnotify
    patchelf
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libX11
    libxcb
    xcbutil
  ];

<<<<<<< HEAD
  NIX_LDFLAGS = lib.optionalString (!headless) "-lX11";
=======
  NIX_LDFLAGS = "-lX11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  preConfigure = ''
    ./_autosetup
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  enableParallelBuilding = true;

<<<<<<< HEAD
  configureFlags = [ "--disable-server" ] ++ lib.optionals headless [ "--disable-manager" ];
=======
  configureFlags = [ "--disable-server" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    install --mode=444 -D 'client/scripts/boinc-client.service' "$out/etc/systemd/system/boinc.service"
  '';

  meta = with lib; {
    description = "Free software for distributed and grid computing";
    homepage = "https://boinc.berkeley.edu/";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Luflosi ];
  };
}

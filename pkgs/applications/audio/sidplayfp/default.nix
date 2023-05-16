{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, autoreconfHook
, perl
, pkg-config
, libsidplayfp
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, out123Support ? stdenv.hostPlatform.isDarwin
, mpg123
}:

stdenv.mkDerivation rec {
  pname = "sidplayfp";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ECHtHJrkJ5Y0YvDNdMM3VB+s7I/8JCPZiwsPYLM/oig=";
=======
    sha256 = "sha256-15KG+LkPkCLFsnWHUAQpQbqol/izAn/HRinszVRB5Ao=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook perl pkg-config ];

  buildInputs = [ libsidplayfp ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional out123Support mpg123;

  configureFlags = lib.optionals out123Support [
    "--with-out123"
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ dezgeg OPNA2608 ];
    platforms = platforms.all;
  };
}

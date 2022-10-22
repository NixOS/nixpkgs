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
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    rev = "v${version}";
    sha256 = "sha256-R60Dh19GYM157ysmN8EOJ47eO8a7sdkEEF1TObG1xzk=";
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
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ dezgeg OPNA2608 ];
    platforms = platforms.all;
  };
}

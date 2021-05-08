{ stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, perl
, pkg-config
, libsidplayfp
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsaLib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, out123Support ? stdenv.hostPlatform.isDarwin
, mpg123
}:

stdenv.mkDerivation rec {
  pname = "sidplayfp";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "libsidplayfp";
    repo = "sidplayfp";
    rev = "v${version}";
    sha256 = "0s3xmg3yzfqbsnlh2y46w7b5jim5zq7mshs6hx03q8wdr75cvwh4";
  };

  nativeBuildInputs = [ autoreconfHook perl pkg-config ];

  buildInputs = [ libsidplayfp ]
    ++ lib.optional alsaSupport alsaLib
    ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional out123Support mpg123;

  configureFlags = lib.optionals out123Support [
    "--with-out123"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A SID player using libsidplayfp";
    homepage = "https://github.com/libsidplayfp/sidplayfp";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ dezgeg OPNA2608 ];
    platforms = platforms.all;
  };
}

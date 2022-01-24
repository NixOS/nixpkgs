{ lib
, stdenv
, fetchurl
, makeWrapper
, pkg-config
, perl
, withAlsa ? stdenv.hostPlatform.isLinux
, alsa-lib
, withPulse ? stdenv.hostPlatform.isLinux
, libpulseaudio
, withCoreAudio ? stdenv.hostPlatform.isDarwin
, AudioUnit
, AudioToolbox
, withJack ? stdenv.hostPlatform.isUnix
, jack
, withConplay ? !stdenv.hostPlatform.isWindows
}:

stdenv.mkDerivation rec {
  pname = "mpg123";
  version = "1.29.3";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-ljiF2Mx3Ji8ot3GHx9GJ4yGV5kJE3iUwt5jd8yGD6Ec=";
  };

  outputs = [ "out" ] ++ lib.optionals withConplay [ "conplay" ];

  nativeBuildInputs = lib.optionals withConplay [ makeWrapper ]
    ++ lib.optionals (withPulse || withJack) [ pkg-config ];

  buildInputs = lib.optionals withConplay [ perl ]
    ++ lib.optionals withAlsa [ alsa-lib ]
    ++ lib.optionals withPulse [ libpulseaudio ]
    ++ lib.optionals withCoreAudio [ AudioUnit AudioToolbox ]
    ++ lib.optionals withJack [ jack ];

  configureFlags = [
    "--with-audio=${lib.strings.concatStringsSep "," (
      lib.optional withJack "jack"
      ++ lib.optional withPulse "pulse"
      ++ lib.optional withAlsa "alsa"
      ++ lib.optional withCoreAudio "coreaudio"
      ++ [ "dummy" ]
    )}"
  ] ++ lib.optional (stdenv.hostPlatform ? mpg123) "--with-cpu=${stdenv.hostPlatform.mpg123.cpu}";

  enableParallelBuilding = true;

  postInstall = lib.optionalString withConplay ''
    mkdir -p $conplay/bin
    mv scripts/conplay $conplay/bin/
  '';

  preFixup = lib.optionalString withConplay ''
    patchShebangs $conplay/bin/conplay
  '';

  postFixup = lib.optionalString withConplay ''
    wrapProgram $conplay/bin/conplay \
      --prefix PATH : $out/bin
  '';

  meta = with lib; {
    description = "Fast console MPEG Audio Player and decoder library";
    homepage = "https://mpg123.org";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ftrvxmtrx ];
    platforms = platforms.all;
  };
}

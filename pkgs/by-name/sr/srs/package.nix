{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, unzip
, ffmpeg
, perl
, tcl
, cmake
, which
, coreutils
, autoconf
, automake
, makeWrapper
}:
stdenv.mkDerivation rec {
  pname = "srs";
  version = "5.0-r2";

  src = fetchFromGitHub {
    owner = "ossrs";
    repo = "srs";
    rev = "v${version}";
    hash = "sha256-T4kmDKAkkC24Xsi3htGAW33Ir+NKKl2HYWyAfCmO6t0=";
  } + "/trunk";

  nativeBuildInputs = [ pkg-config ffmpeg perl unzip tcl cmake which autoconf automake makeWrapper];

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  configureFlags = [] ++ lib.optionals stdenv.isLinux ["--generic-linux=on"];

  prePatch = ''
    substituteInPlace 3rdparty/openssl-1.1-fit/config \
      --replace-fail '/usr/bin/env' '${coreutils}/bin/env'

    substituteInPlace 3rdparty/srt-1-fit/configure \
      --replace-fail '#!/usr/bin/tclsh' '#!${tcl}/bin/tclsh'
      '';

  postInstall = ''
      makeWrapper $out/objs/srs $out/bin/srs
  '';

  meta = with lib; {
    homepage = "https://github.com/ossrs/srs";
    description = "A simple, high efficiency and realtime video server, supports RTMP, WebRTC, HLS, HTTP-FLV, SRT, MPEG-DASH and GB28181";
    platforms = platforms.all;
    maintainers = with maintainers; [ rucadi ];
    license = licenses.mit;
    mainProgram = "srs";
  };
}

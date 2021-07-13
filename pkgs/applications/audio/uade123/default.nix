{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, which
, makeWrapper
, libao
, libbencodetools
, sox
, lame
, flac
, vorbis-tools
}:

stdenv.mkDerivation {
  pname = "uade123";
  version = "unstable-2021-05-21";

  src = fetchFromGitLab {
    owner = "uade-music-player";
    repo = "uade";
    rev = "7169a46e777d19957cd7ff8ac31843203e725ddc";
    sha256 = "1dm7c924fy79y3wkb0qi71m1k6yw1x6j3whw7d0w4ka9hv6za03b";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace src/frontends/mod2ogg/mod2ogg2.sh.in \
      --replace '-e stat' '-n stat' \
      --replace '/usr/local' "$out"
  '';

  nativeBuildInputs = [
    pkg-config
    which
    makeWrapper
  ];

  buildInputs = [
    libao
    libbencodetools
    sox
    lame
    flac
    vorbis-tools
  ];

  configureFlags = [
    "--bencode-tools-prefix=${libbencodetools}"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  postInstall = ''
    wrapProgram $out/bin/mod2ogg2.sh \
      --prefix PATH : $out/bin:${lib.makeBinPath [ sox lame flac vorbis-tools ]}
    # This is an old script, don't break expectations by renaming it
    ln -s $out/bin/mod2ogg2{.sh,}
  '';

  meta = with lib; {
    description = "Plays old Amiga tunes through UAE emulation and cloned m68k-assembler Eagleplayer API";
    homepage = "https://zakalwe.fi/uade/";
    # It's a mix of licenses. "GPL", Public Domain, "LGPL", GPL2+, BSD, LGPL21+ and source code with unknown licenses. E.g.
    # - hippel-coso player is "[not] under any Open Source certified license"
    # - infogrames player is disassembled from Andi Silvas player, unknown license
    # Let's make it easy and flag the whole package as unfree.
    license = licenses.unfree;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
  };
}

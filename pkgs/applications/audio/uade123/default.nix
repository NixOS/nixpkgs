{ lib
, stdenv
, fetchFromGitLab
, python3
, pkg-config
, which
, makeWrapper
, libao
, bencodetools
, sox
, lame
, flac
, vorbis-tools
}:

stdenv.mkDerivation rec {
  pname = "uade123";
  version = "3.01";

  src = fetchFromGitLab {
    owner = "uade-music-player";
    repo = "uade";
    rev = "uade-${version}";
    sha256 = "0fam3g8mlzrirrac3iwcwsz9jmsqwdy7lkwwdr2q4pkq9cpmh8m5";
  };

  postPatch = ''
    patchShebangs configure
    substituteInPlace configure \
      --replace 'PYTHON_SETUP_ARGS=""' 'PYTHON_SETUP_ARGS="--prefix=$out"'
    substituteInPlace src/frontends/mod2ogg/mod2ogg2.sh.in \
      --replace '-e stat' '-n stat' \
      --replace '/usr/local' "$out"
  '';

  nativeBuildInputs = [
    pkg-config
    which
    makeWrapper
    python3
  ];

  buildInputs = [
    libao
    bencodetools
    sox
    lame
    flac
    vorbis-tools
    (python3.withPackages (p: with p; [
      pillow
      tqdm
    ]))
  ];

  configureFlags = [
    "--bencode-tools-prefix=${bencodetools}"
  ];

  enableParallelBuilding = true;

  hardeningDisable = [ "format" ];

  postInstall = ''
    wrapProgram $out/bin/mod2ogg2.sh \
      --prefix PATH : $out/bin:${lib.makeBinPath [ sox lame flac vorbis-tools ]}
    # This is an old script, don't break expectations by renaming it
    ln -s $out/bin/mod2ogg2{.sh,}
    wrapProgram $out/bin/generate_amiga_oscilloscope_view \
      --prefix PYTHONPATH : "$PYTHONPATH:$out/${python3.sitePackages}"
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

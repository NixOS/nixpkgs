{ stdenv
, fetchzip
, libX11
, libXi
, libGL
, alsaLib
, SDL2
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "virtual-ans";
  version = "3.0.2c";

  src = fetchzip {
    url = "https://warmplace.ru/soft/ans/virtual_ans-${version}.zip";
    sha256 = "03r1v3l7rd59dakr7ndvgsqchv00ppkvi6sslgf1ng07r3rsvb1n";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libX11
    libXi
    libGL
    alsaLib
    SDL2
  ];

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/

    # Remove all executables except for current architecture
    ls -1d $out/START*              | grep -v ${startScript}     | xargs rm -rf
    ls -1d $out/bin/pixilang_linux* | grep -v ${linuxExecutable} | xargs rm -rf

    # Start script performs relative search for resources, so it cannot be moved
    # to bin directory
    ln -s $out/${startScript} $out/bin/virtual-ans
  '';

  startScript = if stdenv.isx86_32 then "START_LINUX_X86"
    else        if stdenv.isx86_64 then "START_LINUX_X86_64"
    #else        if stdenv.isDarwin then "START_MACOS.app" # disabled because I cannot test on Darwin
    else abort "Unsupported platform: ${stdenv.platform.kernelArch}.";

  linuxExecutable = if stdenv.isx86_32 then "pixilang_linux_x86"
    else            if stdenv.isx86_64 then "pixilang_linux_x86_64"
    else                                    "";

  meta = with stdenv.lib; {
    description = "Photoelectronic microtonal/spectral musical instrument";
    longDescription = ''
      Virtual ANS is a software simulator of the unique Russian synthesizer ANS
      - photoelectronic musical instrument created by Evgeny Murzin from 1938 to
      1958. The ANS made it possible to draw music in the form of a spectrogram
      (sonogram), without live instruments and performers. It was used by
      Stanislav Kreichi, Alfred Schnittke, Edward Artemiev and other Soviet
      composers in their experimental works. You can also hear the sound of the
      ANS in Andrei Tarkovsky's movies Solaris, The Mirror, Stalker.

      The simulator extends the capabilities of the original instrument. Now
      it's a full-featured graphics editor where you can convert sound into an
      image, load and play pictures, draw microtonal/spectral music and create
      some unusual deep atmospheric sounds. This app is for everyone who loves
      experiments and is looking for something new.

      Key features:

      + unlimited number of pure tone generators;
      + powerful sonogram editor - you can draw the spectrum and play it at the same time;
      + any sound (from a WAV file or a Microphone/Line-in) can be converted to image (sonogram) and vice versa;
      + support for MIDI devices;
      + polyphonic synth mode with MIDI mapping;
      + supported file formats: WAV, AIFF, PNG, JPEG, GIF;
      + supported sound systems: ASIO, DirectSound, MME, ALSA, OSS, JACK, Audiobus, IAA.
      '';
    homepage = "https://warmplace.ru/soft/ans/";
    license = licenses.free;
    # I cannot test the Darwin version, so I'll leave it disabled
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ jacg ];
  };

}

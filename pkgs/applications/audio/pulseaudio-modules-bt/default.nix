{ stdenv
, runCommand
, fetchFromGitHub
, pulseaudio
, pkgconfig
, ffmpeg_4
, patchelf
, fdk_aac
, libtool
, ldacbt
, cmake
, bluez
, dbus
, sbc
, lib
}:

let
  pulseSources = runCommand "pulseaudio-sources" {} ''
    mkdir $out
    tar -xf ${pulseaudio.src}
    mv pulseaudio*/* $out/
  '';

in stdenv.mkDerivation rec {
  name = "pulseaudio-modules-bt-${version}";
  version = "1.1.99";

  src = fetchFromGitHub {
    owner = "EHfive";
    repo = "pulseaudio-modules-bt";
    rev = "v${version}";
    sha256 = "0x670xbd62r3fs9a8pa5p4ppvxn6m64hvlrqa702gvikcvyrmwcg";
  };

  patches = [
    ./fix-install-path.patch
  ];

  nativeBuildInputs = [
    pkgconfig
    patchelf
    cmake
  ];

  buildInputs = [
    pulseaudio
    ffmpeg_4
    fdk_aac
    libtool
    ldacbt
    bluez
    dbus
    sbc
  ];

  postPatch = ''
    # Upstream bundles pulseaudio as a submodule
    rm -r pa
    ln -s ${pulseSources} pa

    # Pulseaudio version is detected with a -rebootstrapped suffix which build system assumptions
    substituteInPlace config.h.in --replace PulseAudio_VERSION ${pulseaudio.version}
    substituteInPlace CMakeLists.txt --replace '${"\${PulseAudio_VERSION}"}' ${pulseaudio.version}
  '';

  postFixup = ''
    for so in $out/lib/pulse-${pulseaudio.version}/modules/*.so; do
      orig_rpath=$(patchelf --print-rpath "$so")
      patchelf \
        --set-rpath "${ldacbt}/lib:${lib.getLib ffmpeg_4}/lib:$out/lib/pulse-${pulseaudio.version}/modules:$orig_rpath" \
        "$so"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/EHfive/pulseaudio-modules-bt;
    description = "LDAC, aptX, aptX HD, AAC codecs (A2DP Audio) support for Linux PulseAudio";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };
}

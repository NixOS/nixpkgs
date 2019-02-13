{ stdenv
, runCommand
, fetchFromGitHub
, pulseaudio
, pkgconfig
, ffmpeg_4
, patchelf
, fdk_aac
, libtool
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
  version = "unstable-2019-01-05";

  src = fetchFromGitHub {
    owner = "EHfive";
    repo = "pulseaudio-modules-bt";
    rev = "4b0cde160c96f40d860fef267a6ded49ae045be0";
    sha256 = "15jw5nf2dhqqdwzyh2x5kdkrq7f3qn140gw6gmspcai9kplhk24w";
    fetchSubmodules = true;
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
        --set-rpath "${lib.getLib ffmpeg_4}/lib:$out/lib/pulse-${pulseaudio.version}/modules:$orig_rpath" \
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

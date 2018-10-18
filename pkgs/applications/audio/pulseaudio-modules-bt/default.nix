{ stdenv
, runCommand
, fetchFromGitHub
, pulseaudio
, pkgconfig
, ffmpeg_4
, patchelf
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
  version = "unstable-2018-10-16";

  src = fetchFromGitHub {
    owner = "EHfive";
    repo = "pulseaudio-modules-bt";
    rev = "552c2b48c0cc7dd44d0746b261f7c7d5559e8e30";
    sha256 = "052jb1hjx1in7bafx4zpn78s7r6f2y7djriwi36dzqy9wmalmyjy";
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
    description = "SBC, Sony LDAC codec (A2DP Audio) support for Pulseaudio";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };
}

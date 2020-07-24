{ stdenv
, runCommand
, fetchFromGitHub
, pulseaudio
, pkgconfig
, ffmpeg
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
  pname = "pulseaudio-modules-bt";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "EHfive";
    repo = "pulseaudio-modules-bt";
    rev = "v${version}";
    sha256 = "0bzg6x405j39axnkvc6n6vkl1hv1frk94y1i9sl170081bk23asd";
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
    ffmpeg
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

    # Fraunhofer recommends to enable afterburner but upstream has it set to false by default
    substituteInPlace src/modules/bluetooth/a2dp/a2dp_aac.c \
      --replace "info->aac_afterburner = false;" "info->aac_afterburner = true;"
  '';

  postFixup = ''
    for so in $out/lib/pulse-${pulseaudio.version}/modules/*.so; do
      orig_rpath=$(patchelf --print-rpath "$so")
      patchelf \
        --set-rpath "${ldacbt}/lib:${lib.getLib ffmpeg}/lib:$out/lib/pulse-${pulseaudio.version}/modules:$orig_rpath" \
        "$so"
    done
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/EHfive/pulseaudio-modules-bt";
    description = "LDAC, aptX, aptX HD, AAC codecs (A2DP Audio) support for Linux PulseAudio";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ adisbladis ];
  };
}

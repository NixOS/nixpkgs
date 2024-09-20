{ lib, stdenv, fetchFromGitHub, cmake, gettext, runCommand
, csound
, eigen
, faust2
, fltk
, fluidsynth
, gmm
, hdf5
, lame
, libjack2
, libpng
, libwebsockets
, openssl
, python3
, wiiuse

# Flags to enable/disable building of opcodes
, enableChua ? !stdenv.hostPlatform.isAarch32
, enableFaust ? !stdenv.hostPlatform.isAarch
, enableFluid ? true
, enableHdf5 ? !stdenv.hostPlatform.isAarch
, enableImage ? true
, enableJack ? stdenv.isLinux
, enableLinearAlgebra ? !stdenv.hostPlatform.isAarch32
, enableMp3out ? true
, enablePython ? stdenv.buildPlatform.canExecute stdenv.hostPlatform
, enableWebsocket ? true
, enableFltk ? stdenv.isLinux
, enableWiimote ? true
}:

assert enableChua -> eigen != null;
assert enableFaust -> faust2 != null;
assert enableFluid -> fluidsynth != null;
assert enableHdf5 -> hdf5 != null;
assert enableImage -> libpng != null;
assert enableJack -> libjack2 != null;
assert enableLinearAlgebra -> gmm != null;
assert enableMp3out -> lame != null;
assert enablePython -> python3 != null;
assert enableWebsocket -> (libwebsockets != null && openssl != null);
assert enableFltk -> fltk != null;
assert enableWiimote -> wiiuse != null;

let
  inherit (lib) cmakeBool concatLists optional optionals optionalAttrs;

in stdenv.mkDerivation (finalAttrs: {
  pname = "csound-plugins";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "csound";
    repo = "plugins";
    rev = finalAttrs.version;
    hash = "sha256-bbcL+5WIFUb0Tps5jeMTOhnDRA3cm52B/yY/W6s9nA0=";
  };

  cmakeFlags = [
    (cmakeBool "BUILD_ABLETON_LINK_OPCODES"   false)
    (cmakeBool "BUILD_CUDA_OPCODES"           false)
    (cmakeBool "BUILD_CHUA_OPCODES"           enableChua)
    (cmakeBool "BUILD_FAUST_OPCODES"          enableFaust)
    (cmakeBool "BUILD_FLUID_OPCODES"          enableFluid)
    (cmakeBool "BUILD_HDF5_OPCODES"           enableHdf5)
    (cmakeBool "BUILD_IMAGE_OPCODES"          enableImage)
    (cmakeBool "BUILD_JACK_OPCODES"           enableJack)
    (cmakeBool "BUILD_LINEAR_ALGEBRA_OPCODES" enableLinearAlgebra)
    (cmakeBool "BUILD_MP3OUT_OPCODE"          enableMp3out)
    (cmakeBool "BUILD_OPENCL_OPCODES"         false)
    (cmakeBool "BUILD_P5GLOVE_OPCODES"        false)
    (cmakeBool "BUILD_PYTHON_OPCODES"         enablePython)
    (cmakeBool "BUILD_STK_OPCODES"            false)
    (cmakeBool "BUILD_WEBSOCKET_OPCODE"       enableWebsocket)
    (cmakeBool "USE_FLTK"                     enableFltk)
    (cmakeBool "BUILD_WIIMOTE_OPCODES"        enableWiimote)
  ];

  nativeBuildInputs = [ cmake gettext ] ++ optional enablePython python3;
  buildInputs = concatLists [
    [ csound ]
    (optional enableChua eigen)
    (optional enableFaust faust2)
    (optional enableFluid fluidsynth)
    (optional enableHdf5 hdf5)
    (optional enableImage libpng)
    (optional enableJack libjack2)
    (optional enableLinearAlgebra gmm)
    (optional enableMp3out lame)
    (optionals enableWebsocket [ libwebsockets openssl ])
    (optional enableFltk fltk)
    (optional enableWiimote wiiuse)
  ];

  passthru.tests = optionalAttrs (stdenv.buildPlatform.canExecute stdenv.hostPlatform) {
    opcodes = runCommand "${finalAttrs.pname}-opcodes-test" {
      plugins = finalAttrs.finalPackage;
      nativeBuildInputs = [ csound ];
      assertOpcodes = concatLists [
        (optional enableChua "chuap")
        (optional enableFaust "faustgen")
        (optional enableFluid "fluidInfo")
        (optional enableHdf5 "hdf5write")
        (optional enableImage "imageload")
        (optionals enableJack [ "JackoInit" "jacktransport" ])
        (optional enableLinearAlgebra "la_i_vr_create")
        (optional enableMp3out "mp3out")
        (optional enablePython "pyinit")
        (optional enableWebsocket "websocket")
        (optionals enableFltk [ "FLpanel" "FLvkeybd" ])
        (optional enableWiimote "wiiconnect")
      ];
    } ''
      export OPCODE6DIR=$plugins/lib/csound/plugins-6.0
      export OPCODE6DIR64=$plugins/lib/csound/plugins64-6.0

      csound -z >& opcodes || true

      for opcode in $assertOpcodes; do
        echo "Checking for $opcode opcode"
        grep -F "$opcode" opcodes >> $out
      done
    '';
  };

  meta = with lib; {
    description = "Additional opcodes for Csound";
    homepage = "https://csound.com/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ marcweber rvl ];
    platforms = platforms.linux;
  };
})

{ stdenv, lib }:

let
  inherit (lib) optionals;
  systemName =
    platform:
    with platform;
    if isCygwin then
      "CYGWIN"
    else if isRedox then
      "Generic"
    else
      uname.system;

  cmakeFlags' = optionals (stdenv.hostPlatform != stdenv.buildPlatform) (
    [
      "-DCMAKE_SYSTEM_NAME=${systemName stdenv.hostPlatform}"
    ]
    ++ optionals (stdenv.hostPlatform.uname.processor != null) [
      "-DCMAKE_SYSTEM_PROCESSOR=${stdenv.hostPlatform.uname.processor}"
    ]
    ++ optionals (stdenv.hostPlatform.uname.release != null) [
      "-DCMAKE_SYSTEM_VERSION=${stdenv.hostPlatform.uname.release}"
    ]
    ++ optionals (stdenv.hostPlatform.isDarwin) [
      "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
    ]
    ++ optionals (stdenv.buildPlatform.uname.system != null) [
      "-DCMAKE_HOST_SYSTEM_NAME=${stdenv.buildPlatform.uname.system}"
    ]
    ++ optionals (stdenv.buildPlatform.uname.processor != null) [
      "-DCMAKE_HOST_SYSTEM_PROCESSOR=${stdenv.buildPlatform.uname.processor}"
    ]
    ++ optionals (stdenv.buildPlatform.uname.release != null) [
      "-DCMAKE_HOST_SYSTEM_VERSION=${stdenv.buildPlatform.uname.release}"
    ]
    ++ optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
      "-DCMAKE_CROSSCOMPILING_EMULATOR=env"
    ]
    ++ optionals (stdenv.hostPlatform.isNone) [
      "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
    ]
    ++ optionals stdenv.hostPlatform.isStatic [
      "-DCMAKE_LINK_SEARCH_START_STATIC=ON"
    ]
  );

  makeCMakeFlags =
    {
      cmakeFlags ? [ ],
      ...
    }:
    cmakeFlags ++ cmakeFlags';

in
{
  inherit makeCMakeFlags;
}

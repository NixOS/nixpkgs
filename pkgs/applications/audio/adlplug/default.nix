{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, fmt
, liblo
, alsa-lib
, freetype
, libX11
, libXrandr
, libXinerama
, libXext
, libXcursor
, libobjc
, Cocoa
, CoreServices
, WebKit
, DiscRecording

  # Enabling JACK requires a JACK server at runtime, no fallback mechanism
, withJack ? false, jack

, type ? "ADL"
}:

assert lib.assertOneOf "type" type [ "ADL" "OPN" ];
let
  chip = {
    ADL = "OPL3";
    OPN = "OPN2";
  }.${type};
  mainProgram = "${type}plug";
in
stdenv.mkDerivation rec {
  pname = "${lib.strings.toLower type}plug";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "jpcima";
    repo = "ADLplug";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0mqx4bzri8s880v7jwd24nb93m5i3aklqld0b3h0hjnz0lh2qz0f";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/jpcima/ADLplug/83636c55bec1b86cabf634b9a6d56d07f00ecc61/resources/patch/juce-gcc9.patch";
      sha256 = "15hkdb76n9lgjsrpczj27ld9b4804bzrgw89g95cj4sc8wwkplyy";
      extraPrefix = "thirdparty/JUCE/";
      stripLen = 1;
    })
  ];

  cmakeFlags = [
    "-DADLplug_CHIP=${chip}"
    "-DADLplug_USE_SYSTEM_FMT=ON"
    "-DADLplug_Jack=${if withJack then "ON" else "OFF"}"
  ];

  NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin (toString [
    "-isystem ${CoreServices}/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers"
  ]);

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    fmt
    liblo
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    freetype
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libobjc
    Cocoa
    CoreServices
    WebKit
    DiscRecording
  ] ++ lib.optional withJack jack;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir $out/Applications
    mv $out/bin/${mainProgram}.app $out/Applications/
    ln -s $out/{Applications/${mainProgram}.app/Contents/MacOS,bin}/${mainProgram}
  '';

  meta = with lib; {
    inherit mainProgram;
    description = "${chip} FM Chip Synthesizer";
    homepage = src.meta.homepage;
    license = licenses.boost;
    platforms = platforms.all;
    maintainers = with maintainers; [ OPNA2608 ];
  };
}

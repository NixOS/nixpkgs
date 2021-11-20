{ lib, stdenv, fetchFromGitHub, fetchzip
, cmake, pkg-config, ninja, makeWrapper
, libjack2, alsa-lib, alsa-tools, freetype, libusb1
, libX11, libXrandr, libXinerama, libXext, libXcursor, libGL
, libxcb, xcbutil, libxkbcommon, xcbutilkeysyms, xcb-util-cursor
, gtk3, webkitgtk, python3, curl, pcre, mount, gnome, patchelf,
, buildType ? "Release" # "Debug", or "Release"
# It is not allowed to distribute binaries with the VST2 SDK plugin without a license
# (the author of Bespoke has such a licence but not Nix). VST3 should work out of the box.
# Read more in https://github.com/NixOS/nixpkgs/issues/145607
, enableVST2 ? false
}:

let
  # equal to vst-sdk in ../oxefmsynth/default.nix
  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk3610_11_06_2018_build_37";
    src = fetchzip {
      url =
        "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/${name}.zip";
      sha256 = "0da16iwac590wphz2sm5afrfj42jrsnkr1bxcy93lj7a369ildkj";
    };
    installPhase = ''
      cp -r . $out
    '';
  };

in
stdenv.mkDerivation rec {
  pname = "bespokesynth";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "BespokeSynth";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PN0Q6/gI1PeMaF/8EZFGJdLR8JVHQZfWunAhOIQxkHw=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=${buildType}"
  ] ++ lib.optional enableVST2 "-DBESPOKE_VST2_SDK_LOCATION=${vst-sdk}/VST2_SDK";

  nativeBuildInputs = [ python3 makeWrapper cmake pkg-config ninja ];

  # List obtained in https://github.com/BespokeSynth/BespokeSynth/blob/main/azure-pipelines.yml
  buildInputs = [
    libX11
    libXrandr
    libXinerama
    libXext
    libXcursor
    curl
    gtk3
    webkitgtk
    freetype
    libGL
    libusb1
    alsa-lib
    libjack2
    gnome.zenity
    alsa-tools
    libxcb
    xcbutil
    libxkbcommon
    xcbutilkeysyms
    xcb-util-cursor
    pcre
    mount
    patchelf
  ];

  # Ensure zenity is available, or it won't be able to open new files.
  # Ensure the python used for compilation is the same as the python used at run-time.
  # jedi is also required for auto-completion.
  postInstall = ''
    wrapProgram $out/bin/BespokeSynth --prefix PATH : '${
      lib.makeBinPath [
        gnome.zenity
        (python3.withPackages (ps: with ps; [ jedi ]))
      ]
    }'
  '';

  meta = with lib; {
    description =
      "Software modular synth with controllers support, scripting and VST";
    homepage = "https://github.com/awwbees/BespokeSynth";
    license = with licenses; [
      gpl3Plus
    ] ++ lib.optional enableVST2 unfree;
    maintainers = with maintainers; [ astro tobiasBora ];
    platforms = platforms.all;
  };
}

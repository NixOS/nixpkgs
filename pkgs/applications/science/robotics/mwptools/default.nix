{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, meson
, gcc
, vala
, gtk4
, clutter
, libchamplain
, gdl
, pkg-config
, cmake
, libgudev
, go
, libxml2
, libsoup
, vte
, mosquitto
, paho-mqtt-c
, espeak
, espeak-classic
, speechd
, flite
, ninja
, git
, ncurses
, bash-completion
, openlibm
, bash
, wrapGAppsHook
, bluez
, cairo
, pango
, gnuplot
, ruby
, gst_all_1
, unzip
, inav-blackbox-tools
, python3Packages
, useFlite ? true
, useSpeechd ? false
, useEspeak ? false
, useEspeak-classic ? false
}:

stdenv.mkDerivation rec {
  pname = "mwptools";
  version = "5.080.712";

  src = fetchFromGitHub {
    owner = "stronnag";
    repo = pname;
    rev = version;
    leaveDotGit = true;
    sha256 = "1ncx7zfnw0idzsipbxgbbl3a8mkmxpdwqkzliw9wlhyx0ygha4sg";
  };

  mwp-plot-elevations = buildGoModule {
    name = "mwp-plot-elevations";
    src = src + "/src/mwp-plot-elevations";
    goDeps = ./deps.nix;
    vendorSha256 = "sha256-BOWtnjl5oEFHO7RgUEHFXyCrr47HKbe8gBsWzNKnG88=";
  } + "/bin/mwp-plot-elevations";

  nativeBuildInputs = [
    meson
    ninja
    gcc
    pkg-config
    cmake
    go
    git
    bash
    wrapGAppsHook
  ];
  buildInputs = [
    vala
    gtk4
    clutter
    libchamplain
    gdl
    libgudev
    libxml2
    libsoup
    vte
    mosquitto
    paho-mqtt-c
    ncurses
    bash-completion
    openlibm
    bluez
    cairo
    pango
    gnuplot
    ruby
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    (gst_all_1.gst-plugins-good.override { gtkSupport = true; })
    unzip
    inav-blackbox-tools
    python3Packages.pymavlink
  ] ++ lib.optionals useEspeak-classic [
    espeak-classic
  ] ++ lib.optionals useEspeak [
    espeak
  ] ++ lib.optionals useSpeechd [
    speechd
  ] ++ lib.optionals useFlite [
    flite
  ];

  patches = [
    ./meson_replace_lib_paths.patch
    ./use_prebuild_go.patch
    ./replace_shebangs.patch
    ./change_default_config.patch
    ./fix_gmodule_paths.patch
  ];
  postPatch = ''
    substituteInPlace meson/post_install.sh \
      --replace '@BASH@' '${bash}/bin/bash'
    substituteInPlace src/mwp/meson.build \
      --replace '@LIB_PATHS@' "${builtins.concatStringsSep ", " (
          builtins.map (libary: "'${libary}/lib'") (nativeBuildInputs ++ buildInputs)
        )}"
    substituteInPlace src/mwp/speech_wrapper.c \
      ${if useEspeak-classic then "--replace '@ESPEAK_LIB@' '${espeak-classic}/lib'" else ""} \
      ${if useEspeak then "--replace '@ESPEAK_NG_LIB@' '${espeak}/lib'" else ""} \
      ${if useSpeechd then "--replace '@SPEECHD_LIB@' '${speechd}/lib'" else ""} \
      ${if useFlite then "--replace '@FLITE_LIB@' '${flite}/lib'" else ""}
    substituteInPlace src/mwp/org.mwptools.planner.gschema.xml \
      --replace '@SPEECH_API@' ${
        if useFlite then "flite" else
        if useSpeechd then "speechd" else
        if useEspeak then "espeak-ng" else
        if useEspeak-classic then "espeak" else ""
      }
  '';

  postInstall = ''
    cp ${mwp-plot-elevations} $out/bin/
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "$out/bin:${lib.makeBinPath buildInputs}"
    )
  '';

  meta = with lib; {
    description = "ground station, mission planner and tools for inav and multiwii-nav";
    homepage = "https://github.com/stronnag/mwptools";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilcreator ];
  };
}

{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  which,
  pkg-config,
  libjpeg,
  ocaml-ng,
  awscli2,
  bubblewrap,
  curl,
  dune,
  ffmpeg_6-full,
  yt-dlp,
  runtimePackages ? [
    awscli2
    bubblewrap
    curl
    ffmpeg_6-full
    yt-dlp
  ],
}:
let
  ocamlPackages = ocaml-ng.ocamlPackages_4_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "liquidsoap";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "liquidsoap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ViJlG+AUncL37mltlFFXVho98Up11qZI3wwSnrd9C8g=";
  };

  postPatch = ''
    substituteInPlace src/lang/base/dune \
      --replace-warn "(run git rev-parse --short HEAD)" "(run echo -n nixpkgs)"
    # Compatibility with camlimages 5.0.5
    substituteInPlace src/core/optionals/camlimages/dune \
      --replace-warn camlimages.all_formats camlimages.core
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    dune build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dune install --prefix "$out"

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgram $out/bin/liquidsoap \
      --set LIQ_LADSPA_PATH /run/current-system/sw/lib/ladspa \
      --prefix PATH : ${lib.makeBinPath runtimePackages}

    runHook postFixup
  '';

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    which
    ocamlPackages.ocaml
    dune
    ocamlPackages.findlib
    ocamlPackages.menhir
  ];

  buildInputs = [
    libjpeg

    # Mandatory dependencies
    ocamlPackages.dtools
    ocamlPackages.duppy
    ocamlPackages.mm
    ocamlPackages.ocurl
    ocamlPackages.re
    ocamlPackages.cry
    ocamlPackages.camomile
    ocamlPackages.uri
    ocamlPackages.fileutils
    ocamlPackages.magic-mime
    ocamlPackages.menhir # liquidsoap-lang
    ocamlPackages.menhirLib
    ocamlPackages.mem_usage
    ocamlPackages.metadata
    ocamlPackages.dune-build-info
    ocamlPackages.re
    ocamlPackages.sedlex # liquidsoap-lang
    ocamlPackages.ppx_hash # liquidsoap-lang
    ocamlPackages.ppx_string
    ocamlPackages.xml-light # liquidsoap-lang

    # Recommended dependencies
    ocamlPackages.ffmpeg

    # Optional dependencies
    ocamlPackages.alsa
    ocamlPackages.ao
    ocamlPackages.bjack
    ocamlPackages.camlimages
    ocamlPackages.dssi
    ocamlPackages.faad
    ocamlPackages.fdkaac
    ocamlPackages.flac
    ocamlPackages.frei0r
    ocamlPackages.gd
    ocamlPackages.graphics
    ocamlPackages.imagelib
    ocamlPackages.inotify
    ocamlPackages.ladspa
    ocamlPackages.lame
    ocamlPackages.lastfm
    ocamlPackages.lilv
    ocamlPackages.lo
    ocamlPackages.mad
    ocamlPackages.ogg
    ocamlPackages.opus
    ocamlPackages.portaudio
    ocamlPackages.posix-time2
    ocamlPackages.pulseaudio
    ocamlPackages.samplerate
    ocamlPackages.shine
    ocamlPackages.soundtouch
    ocamlPackages.speex
    ocamlPackages.ocaml_sqlite3
    ocamlPackages.srt
    ocamlPackages.ssl
    ocamlPackages.taglib
    ocamlPackages.theora
    ocamlPackages.tsdl
    ocamlPackages.tsdl-image
    ocamlPackages.tsdl-ttf
    ocamlPackages.vorbis
    ocamlPackages.xmlplaylist
    ocamlPackages.yaml
  ];

  meta = {
    description = "Swiss-army knife for multimedia streaming";
    mainProgram = "liquidsoap";
    homepage = "https://www.liquidsoap.info/";
    changelog = "https://raw.githubusercontent.com/savonet/liquidsoap/main/CHANGES.md";
    maintainers = with lib.maintainers; [
      dandellion
      juaningan
    ];
    license = lib.licenses.gpl2Plus;
    platforms = ocamlPackages.ocaml.meta.platforms or [ ];
  };
})

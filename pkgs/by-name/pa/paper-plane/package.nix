{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk4,
  libadwaita,
  tdlib,
  rlottie,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  rustc,
  cargo,
  desktop-file-utils,
  blueprint-compiler,
  libxml2,
  libshumate,
  gst_all_1,
  buildPackages,
}:

let
  pname = "paper-plane";
  version = "0.1.0-beta.5";

  src = fetchFromGitHub {
    owner = "paper-plane-developers";
    repo = "paper-plane";
    tag = "v${version}";
    hash = "sha256-qcAHxNnF980BHMqLF86M06YQnEN5L/8nkyrX6HQjpBA=";
  };

  # Paper Plane requires a patch to the gtk4, but may be removed later
  # https://github.com/paper-plane-developers/paper-plane/tree/main?tab=readme-ov-file#prerequisites
  gtk4-paperplane = gtk4.overrideAttrs (prev: {
    patches = (prev.patches or [ ]) ++ [ "${src}/build-aux/gtk-reversed-list.patch" ];
  });
  wrapPaperPlaneHook = buildPackages.wrapGAppsHook3.override {
    gtk3 = gtk4-paperplane;
  };
  # libadwaita has gtk4 in propagatedBuildInputs so it must be overrided
  # to avoid linking two libraries, while libshumate doesn't
  libadwaita-paperplane = libadwaita.override {
    gtk4 = gtk4-paperplane;
  };
  tdlib-paperplane = tdlib.overrideAttrs (prev: {
    pname = "tdlib-paperplane";
    version = "1.8.19";
    src = fetchFromGitHub {
      owner = "tdlib";
      repo = "td";
      rev = "2589c3fd46925f5d57e4ec79233cd1bd0f5d0c09";
      hash = "sha256-mbhxuJjrV3nC8Ja7N0WWF9ByHovJLmoLLuuzoU4khjU=";
    };
    postPatch = ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
      substituteInPlace td/generate/tl-parser/CMakeLists.txt \
        --replace-fail "cmake_minimum_required(VERSION 3.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
    '';
  });
  rlottie-paperplane = rlottie.overrideAttrs (prev: {
    pname = "rlottie-paperplane";
    version = "0-unstable-2022-09-14";
    src = fetchFromGitHub {
      owner = "paper-plane-developers";
      repo = "rlottie";
      rev = "1dd47cec7eb8e1f657f02dce9c497ae60f7cf8c5";
      hash = "sha256-OIKnDikuJuRIR9Jvl1PnUA9UAV09EmgGdDTeWoVi7jk=";
    };
    patches = [ ];
    env.NIX_CFLAGS_COMPILE = prev.env.NIX_CFLAGS_COMPILE + " -Wno-error";
  });
in
stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-QEX7w8eMV7DJFONjq23o8eCV+lliugS0pcdufFhcZrM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    rustc
    cargo
    wrapPaperPlaneHook
    desktop-file-utils
    blueprint-compiler
    libxml2.bin
  ];

  buildInputs = [
    libshumate
    libadwaita-paperplane
    tdlib-paperplane
    rlottie-paperplane
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  mesonFlags = [
    # The API ID and hash provided here are for use with Paper Plane only.
    # Redistribution of the key in Nixpkgs has been explicitly permitted
    # by Paper Plane developers. Please do not use it in other projects.
    "-Dtg_api_id=22303002"
    "-Dtg_api_hash=3cc0969992690f032197e6609b296599"
  ];

  # Workaround for the gettext-sys issue
  # https://github.com/Koka/gettext-rs/issues/114
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "16"
  ) "-Wno-error=incompatible-function-pointer-types";

  meta = {
    homepage = "https://github.com/paper-plane-developers/paper-plane";
    description = "Chat over Telegram on a modern and elegant client";
    longDescription = ''
      Paper Plane is an alternative Telegram client. It uses libadwaita
      for its user interface and strives to meet the design principles
      of the GNOME desktop.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ aleksana ];
    mainProgram = "paper-plane";
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  glib,
  gst_all_1,
  openssl,
  libclang,
  wayland,
  libxkbcommon,
  libGL,
  libx11,
  libxcursor,
  libxi,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ntsc-rs";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "ntsc-rs";
    repo = "ntsc-rs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-t65pE7Nk1It4Irhh8JXM+/+ewOGjok5HkmJPUg8tBEg=";
  };

  cargoHash = "sha256-MAaUrEbRNHZ5IMKUxr22HLacJG3YNvhuVfXyOoa+HEE=";

  nativeBuildInputs = [
    pkg-config
    libclang
    makeWrapper
  ];

  buildInputs = [
    glib
    openssl
    # I tried to include all related packages here like open-scq30 has done.
    wayland
    libxkbcommon
    libGL
    libx11
    libxcursor
    libxi
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  __structuredAttrs = true;

  env = {
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
  };

  # It seems that wrapGAppsHook4 doesn't work for this package.
  postFixup = ''
    for prog in \
      $out/bin/ntsc-rs-launcher \
      $out/bin/ntsc-rs-standalone
    do
      wrapProgram "$prog" \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            wayland
            libxkbcommon
            libGL
            libx11
            libxcursor
            libxi
          ]
        }
    done
  '';

  updateScript = nix-update-script { };

  meta = {
    description = "Free, open-source VHS effect which emulates NTSC and VHS video artifacts";
    homepage = "https://ntsc.rs/";
    downloadPage = "https://github.com/ntsc-rs/ntsc-rs/releases";
    changelog = "https://github.com/ntsc-rs/ntsc-rs/releases/tag/${finalAttrs.src.tag}";
    # See https://github.com/ntsc-rs/ntsc-rs/commit/621d2cc53e4f834a21005ec030a3b24fb5cbde38
    # for more info about licenses.
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "ntsc-rs";
  };
})

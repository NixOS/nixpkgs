{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  cosmic-icons,
  just,
  pkg-config,
  glib,
  libxkbcommon,
  wayland,
  xorg,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cosmic-files";
  version = "1.0.0-alpha.1";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    tag = "epoch-${finalAttrs.version}";
    hash = "sha256-UwQwZRzOyMvLRRmU2noxGrqblezkR8J2PNMVoyG0M0w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-me/U4LtnvYtf77qxF2Z1ncHRVOLp3inDVlwnCjwlj08=";

  env = {
    VERGEN_GIT_COMMIT_DATE = "2024-08-05";
    VERGEN_GIT_SHA = finalAttrs.src.tag;
  };

  nativeBuildInputs = [
    just
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    glib
    libxkbcommon
    wayland
  ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
  ];

  # LD_LIBRARY_PATH can be removed once tiny-xlib is bumped above 0.2.2
  postInstall = ''
    wrapProgram "$out/bin/cosmic-files" \
      --suffix XDG_DATA_DIRS : "${cosmic-icons}/share" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          wayland
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ahoneybun
      nyabinary
    ];
    platforms = lib.platforms.linux;
  };
})

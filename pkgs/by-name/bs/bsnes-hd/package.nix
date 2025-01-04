{
  lib,
  SDL2,
  alsa-lib,
  apple-sdk_11,
  fetchFromGitHub,
  fetchpatch,
  gtk3,
  gtksourceview3,
  libX11,
  libXv,
  libao,
  libicns,
  libpulseaudio,
  makeWrapper,
  openal,
  pkg-config,
  stdenv,
  udev,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "bsnes-hd";
  version = "10.6-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "0bb7b8645e22ea2476cabd58f32e987b14686601";
    hash = "sha256-YzWSZMn6v5hWIHnp6KmmpevCsf35Vi2BCcmFMnrFPH0=";
  };

  patches = [
    # Replace invocation of `sips` with an equivalent invocation of `png2icns`
    # while assembling the .app directory hierarchy in the macos build. The
    # `sips` executable isn't in our environment during the build, but
    # `png2icns` is available by way of the dependency on libicns.
    ./patches/0000-macos-replace-sips-with-png2icns.patch

    # During `make install` on macos the Makefile wants to move the .app into
    # the current user's home directory. This patches the Makefile such that the
    # .app ends up in $(prefix)/Applications. The $(prefix) variable will be set
    # to $out, so this will result in the .app ending up in the Applications
    # directory in the current nix profile.
    ./patches/0001-macos-copy-app-to-prefix.patch
  ];

  nativeBuildInputs =
    [ pkg-config ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libicns
      makeWrapper
    ];

  buildInputs =
    [
      SDL2
      libao
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libXv
      udev
      gtk3
      gtksourceview3
      alsa-lib
      openal
      libpulseaudio
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_11 ];

  makeFlags =
    [
      "-C bsnes"
      "prefix=$(out)"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ "hiro=gtk3" ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ "hiro=cocoa" ];

  enableParallelBuilding = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/bin
    makeWrapper $out/{Applications/bsnes.app/Contents/MacOS,bin}/bsnes
  '';

  # https://github.com/bsnes-emu/bsnes/issues/107
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    homepage = "https://github.com/DerKoun/bsnes-hd";
    description = "Fork of bsnes that adds HD video features";
    license = lib.licenses.gpl3Only;
    mainProgram = "bsnes";
    maintainers = with lib.maintainers; [
      AndersonTorres
      stevebob
    ];
    platforms = lib.platforms.unix;
  };
}

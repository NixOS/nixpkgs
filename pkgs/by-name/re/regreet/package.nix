{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  accountsservice,
  bubblewrap,
  dbus,
  glib,
  glycin-loaders,
  gst_all_1,
  gtk4,
  libglycin,
  pango,
  librsvg,
  libseccomp,
  shared-mime-info,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "regreet";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "rharish101";
    repo = "ReGreet";
    rev = finalAttrs.version;
    hash = "sha256-fJZqEcsqorTJA5qFhJ8wcNZKAC3q/KKFFIEZlrnkGHQ=";
  };

  cargoHash = "sha256-vWZ5lF5VKAPJTamvU/EavMHZsp4Gu2JvH4kbAvOqWTY=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];
  buildInputs = [
    accountsservice
    dbus
    glib
    gtk4
    # Static backgrounds are decoded by glycin since 0.5.0, not GStreamer
    libglycin.setupHook
    glycin-loaders
    gst_all_1.gstreamer # Used for animated wallpapers or video playback
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-base
    pango
    librsvg
    libseccomp
  ];

  # glycin also needs the MIME database to detect the image type, and bwrap in
  # PATH for its sandbox; a greeter session provides neither
  # See https://github.com/NixOS/nixpkgs/issues/557002
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      --prefix PATH : "${lib.makeBinPath [ bubblewrap ]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Clean and customizable greeter for greetd";
    homepage = "https://github.com/rharish101/ReGreet";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fufexan ];
    platforms = lib.platforms.linux;
    mainProgram = "regreet";
  };
})

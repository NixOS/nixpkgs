{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  # runtime dependencies
  e2fsprogs,
  expat,
  fontconfig,
  freetype,
  fribidi,
  gmp,
  harfbuzz,
  libdrm,
  libgbm,
  libglvnd,
  libgpg-error,
  libusb1,
  libuuid,
  libx11,
  libxcb,
  libxkbcommon,
  unzip,
  wayland,
  xkeyboard-config,
  zlib,
}:
let
  manifest = lib.importJSON ./manifest.json;

  files = map (file: {
    path = file.path;
    mode = toOctal file.mode;
    src = fetchurl {
      name = "papertracker-object-${file.sha256}";
      url = "https://download-global.papertracker.top/papertracker/objects/${file.sha256}";
      sha256 = file.sha256;
    };
  }) manifest.files;

  installScript = lib.concatMapStringsSep "\n" (
    file:
    "install -Dm${file.mode} "
    + lib.escapeShellArg file.src
    + " \"$out/libexec\"/"
    + lib.escapeShellArg file.path
  ) files;

  runtimeLibs = [
    libglvnd
    libxkbcommon
    wayland
  ];

  runtimeBins = [
    unzip # firmware updates
  ];

  toOctal = mode: lib.concatMapStrings toString (lib.toBaseDigits 8 mode);
in
stdenv.mkDerivation {
  pname = "papertracker";
  inherit (manifest) version;

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  # Additional libraries required by the application.
  # Bundled libraries are stored in "$out/libexec/lib".
  buildInputs = [
    e2fsprogs
    expat
    fontconfig
    freetype
    fribidi
    gmp
    harfbuzz
    libdrm
    libgbm # OpenVR plugin for dataset recorder
    libglvnd
    libgpg-error
    libusb1 # eye tracking hardware
    libuuid # OpenCV/gdcm
    libx11
    libxcb
    wayland
    zlib
  ];

  inherit installScript;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    # Copy all files listed in the manifest to $out/libexec
    mkdir -p "$out/libexec"
    eval "$installScript"

    mkdir -p "$out/share"
    cp --archive "$out/libexec/share/." "$out/share/"

    # The upstream desktop file references the unwrapped executable,
    # so replace it with the wrapped version in $out/bin
    substituteInPlace $out/share/applications/*.desktop \
      --replace-fail 'Exec=PaperTracker' 'Exec=papertracker'

    mkdir -p "$out/etc/udev/rules.d"
    install -Dm644 ${./70-papertracker.rules} "$out/etc/udev/rules.d/70-papertracker.rules"

    runHook postInstall
  '';

  postInstall = ''
    # Include unbundled libraries via LD_LIBRARY_PATH.
    # Default QT_QPA_PLATFORM to "wayland-egl" so Qt uses EGL by default.
    mkdir -p "$out/bin"
    makeWrapper "$out/libexec/bin/PaperTracker" "$out/bin/papertracker" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
      --prefix PATH : "${lib.makeBinPath runtimeBins}" \
      --set-default QT_QPA_PLATFORM "wayland-egl;wayland;xcb" \
      --set-default QT_XKB_CONFIG_ROOT "${xkeyboard-config}/share/X11/xkb"
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Face and eye tracking for VR headsets";
    longDescription = ''
      Paper_Tracker is a face and eye tracking application for VR headsets.

      The application is unfree. The full license is available in "libexec/bin/license.txt".

      On NixOS, add the package to `services.udev.packages` and re-login to be
      able to access the tracker hardware without root.
    '';
    homepage = "https://papertracker.top";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      SandroHc
    ];
    mainProgram = "papertracker";
    platforms = [ "x86_64-linux" ];
  };
}

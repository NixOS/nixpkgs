{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  makeWrapper,
  libGL,
  wayland,
  libxkbcommon,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  vulkan-loader,
  xdg-utils,
  fontconfig,
  gnutar,
  p7zip,
  ffmpeg-headless,
  shared-mime-info,
  nix-update-script,
}:

let
  # Loaded with dlopen by winit, glow and wgpu
  runtimeLibs = [
    libGL
    wayland
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
    vulkan-loader
  ];

  # Programs Ski runs for opening files, archives and video thumbnails
  runtimeTools = [
    xdg-utils
    fontconfig
    gnutar
    p7zip
    ffmpeg-headless
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ski";
  version = "0.6.3";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ilyamiro";
    repo = "Ski";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7nAykhGR3SjGGIGRyC8oYH4vCv3EE+9eX8EY5h4Zpho=";
  };

  cargoHash = "sha256-c4c7bxNz8i4msQ/eWQGKstOk8l6xPpqC/v6N+IpJM4Q=";

  nativeBuildInputs = [
    pkg-config
    patchelf
    makeWrapper
  ];

  # The tests exercise the preview cache on disk, and the sandbox's HOME is read-only
  preCheck = ''
    export XDG_CACHE_HOME=$TMPDIR/cache
  '';

  postInstall = ''
    install -Dm644 assets/ski.desktop $out/share/applications/ski.desktop
    install -Dm644 assets/logo.svg $out/share/icons/hicolor/scalable/apps/ski.svg

    install -Dm644 assets/ski.portal $out/share/xdg-desktop-portal/portals/ski.portal
    for name in org.freedesktop.impl.portal.desktop.ski org.freedesktop.FileManager1; do
      install -Dm644 assets/$name.service $out/share/dbus-1/services/$name.service
      substituteInPlace $out/share/dbus-1/services/$name.service --replace-fail @out@ $out
    done

    wrapProgram $out/bin/ski \
      --prefix PATH : ${lib.makeBinPath runtimeTools} \
      --suffix XDG_DATA_DIRS : ${shared-mime-info}/share
  '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeLibs} $out/bin/.ski-wrapped
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Small, fast, keyboard-friendly file manager";
    homepage = "https://github.com/ilyamiro/Ski";
    changelog = "https://github.com/ilyamiro/Ski/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilyamiro ];
    mainProgram = "ski";
    platforms = lib.platforms.linux;
  };
})

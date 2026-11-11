{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildDotnetModule,
  dotnetCorePackages,
  alsa-lib,
  clang,
  darwin,
  desktopToDarwinBundle,
  glib,
  libdecor,
  libGL,
  libmpg123,
  libpulseaudio,
  libsndfile,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxrender,
  libxxf86vm,
  pipewire,
  swift,
  udev,
  wayland,
  zlib,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "helion";
  version = "1.1.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Helion-Engine";
    repo = "Helion";
    tag = finalAttrs.version;
    hash = "sha256-fqcwuoFJWtUdy9tOggQQ9Bk6dxqBeOg1FXG4womzjc8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  projectFile = "Client/Client.csproj";
  nugetDeps = ./deps.json;

  selfContainedBuild = true;
  dotnetFlags = [
    "-p:AOT=true"
    "-p:SourceRevisionId=${finalAttrs.version}"
  ];

  patches = [
    # Fix crash when the working directory is /, as in a darwin app bundle
    # TODO: Remove after next version
    (fetchpatch {
      url = "https://github.com/Helion-Engine/Helion/commit/de2be15e824c0bed8466467bd8739993977ff23e.patch";
      hash = "sha256-5v/27Xto/h/XR2x0G/NhjH1atwOrrCyAZ1nmWvy5LkM=";
    })
  ];

  # Upstream links ZMusic's dependencies as static archives from Homebrew
  # on darwin. Link the direct ones dynamically, like on linux.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Client/Client.csproj \
      --replace-fail /opt/homebrew/opt/glib/lib/libglib-2.0.a -lglib-2.0 \
      --replace-fail /opt/homebrew/opt/mpg123/lib/libmpg123.a -lmpg123 \
      --replace-fail /opt/homebrew/opt/libsndfile/lib/libsndfile.a -lsndfile
    sed -i '\#/opt/homebrew/#d' Client/Client.csproj
  '';

  nativeBuildInputs = [
    clang
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

  buildInputs = [
    glib
    libmpg123
    libsndfile
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
  # Required by the NativeAOT runtime on darwin
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    swift
    darwin.ICU
  ];

  runtimeDeps = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libdecor
    libGL
    libpulseaudio
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxrender
    libxxf86vm
    pipewire
    udev
    wayland
  ];

  executables = [ "Helion" ];

  postInstall = ''
    install -Dm444 Assets/Misc/Helion.desktop -t $out/share/applications
    install -Dm444 Assets/Misc/helion.svg $out/share/icons/hicolor/scalable/apps/Helion.svg
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^([0-9.]+)$"
    ];
  };

  meta = {
    description = "Modern, fast-paced Doom FPS engine";
    longDescription = ''
      Helion is a Doom source port written in C# with a focus on performance. It
      renders statically with a state management system to reconcile dynamic map
      changes instead of walking the BSP tree, which makes very large maps
      playable. It supports WADs targeting vanilla, Boom, MBF, MBF21, ID24 and
      (partially) UDMF, and requires an OpenGL 3.3 capable GPU.
    '';
    homepage = "https://github.com/Helion-Engine/Helion";
    changelog = "https://github.com/Helion-Engine/Helion/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    maintainers = with lib.maintainers; [
      iedame
      keenanweaver
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "Helion";
  };
})

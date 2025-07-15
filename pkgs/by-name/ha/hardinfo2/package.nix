{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  glslang,
  pkg-config,
  libsForQt5,
  makeWrapper,
  wrapGAppsHook4,

  cups,
  gtk3,
  json-glib,
  lerc,
  libdatrie,
  libdecor,
  libepoxy,
  libnghttp2,
  libpsl,
  libselinux,
  libsepol,
  libsoup_3,
  libsysprof-capture,
  libthai,
  libxkbcommon,
  libXdmcp,
  libXtst,
  pcre2,
  sqlite,
  util-linux,
  vulkan-headers,
  wayland,

  # runtime
  dmidecode,
  gawk,
  iperf,
  mesa-demos,
  sysbench,
  udisks,
  vulkan-tools,
  xdg-utils,
  xrandr,

  nix-update-script,

  printingSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hardinfo2";
  version = "2.2.13";

  src = fetchFromGitHub {
    owner = "hardinfo2";
    repo = "hardinfo2";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-HRP8xjiwhlNHjW4D8y74Pshpn7bksmN5j4jhfF6KOYo=";
  };

  patches = [
    ./remove-update.patch
    ./default-no-theme.patch
  ];

  # fix absolute path for xdg-open
  postPatch = ''
    substituteInPlace deps/sysobj_early/gui/uri_handler.c \
      --replace-fail /usr/bin/xdg-open "${lib.getExe' xdg-utils "xdg-open"}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config

    glslang

    wrapGAppsHook4
    libsForQt5.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    gtk3
    json-glib
    lerc
    libdatrie
    libdecor
    libepoxy
    libnghttp2
    libpsl
    libselinux
    libsepol
    libsoup_3
    libsysprof-capture
    libthai
    libxkbcommon
    pcre2
    sqlite
    util-linux
    libXdmcp
    libXtst
    vulkan-headers
    wayland
  ];

  hardeningDisable = [ "fortify" ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_INSTALL_DATAROOTDIR" "${placeholder "out"}/share")
    (lib.cmakeFeature "CMAKE_INSTALL_SERVICEDIR" "${placeholder "out"}/lib")
  ];

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  runtimeDeps = [
    # system stats
    dmidecode
    mesa-demos # glxinfo + vkgears for benchmark

    # display info
    vulkan-tools # vulkaninfo
    xrandr

    # additional tooling for benchmarks
    # https://github.com/hardinfo2/hardinfo2/blob/release-2.2.13/shell/shell.c#L641-L652
    gawk
    iperf
    sysbench
    udisks
  ];

  runtimeLibs = lib.optionals printingSupport [ cups ];

  postFixup = ''
    wrapProgram $out/bin/hardinfo2 \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.runtimeLibs}

      substituteInPlace $out/lib/systemd/system/hardinfo2.service \
        --replace-fail "ExecStart=/usr/bin/hwinfo2_fetch_sysdata" "ExecStart=$out/hwinfo2_fetch_sysdata"
  '';

  # account for tags having a release- prefix
  passthru.updateScript = nix-update-script { extraArgs = [ "--version-regex=release-(.*)" ]; };

  meta = {
    description = "System information and benchmarks for Linux systems";
    homepage = "http://www.hardinfo2.org/";
    downloadPage = "https://github.com/hardinfo2/hardinfo2/";
    changelog = "https://github.com/hardinfo2/hardinfo2/releases/tag/release-${finalAttrs.version}";
    license = with lib.licenses; [
      gpl2Plus
      gpl3Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [
      sigmanificient
      jk
    ];
    platforms = lib.platforms.linux;
    mainProgram = "hardinfo2";
  };
})

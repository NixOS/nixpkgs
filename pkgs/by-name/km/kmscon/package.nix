{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  libtsm,
  systemdLibs,
  libxkbcommon,
  libdrm,
  libGLU,
  libGL,
  freetype,
  fontconfig,
  zlib,
  pango,
  pkg-config,
  docbook_xsl,
  docbook_xml_dtd_42,
  python3,
  ncurses,
  libxslt,
  libgbm,
  dbus,
  ninja,
  check,
  bash,
  inotify-tools,
  buildPackages,
  nix-update-script,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kmscon";
  version = "10.0.4";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "kmscon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F4XI924K4YxREEjqP0XLeFcvaW/9v5Iyuy9n75c9Osc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libGLU
    libGL
    libdrm
    libtsm
    libxkbcommon
    freetype
    fontconfig
    zlib
    pango
    systemdLibs
    libgbm
    dbus
    check
    # Needed for autoPatchShebangs when strictDeps = true
    bash
  ];

  nativeBuildInputs = [
    meson
    ninja
    docbook_xsl
    pkg-config
    libxslt # xsltproc
    docbook_xml_dtd_42
    python3
    ncurses
    zlib
  ];

  outputs = [
    "out"
    "man"
  ];

  env = {
    PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
    DESTDIR = "/";
  };

  postPatch = ''
    patchShebangs scripts/terminfo
  '';

  postFixup = ''
    substituteInPlace $out/bin/kmscon-launch-gui \
      --replace-fail "inotifywait" "${lib.getExe' inotify-tools "inotifywait"}"
  '';

  passthru = {
    tests.kmscon = nixosTests.kmscon;
    updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };
  };

  meta = {
    description = "KMS/DRM based System Console";
    mainProgram = "kmscon";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/";
    changelog = "https://github.com/kmscon/kmscon/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      lgpl21Plus
      ofl
    ];
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.linux;
  };
})

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
  pango,
  pkg-config,
  docbook_xsl,
  docbook_xml_dtd_42,
  libxslt,
  libgbm,
  ninja,
  check,
  bash,
  gawk,
  inotify-tools,
  buildPackages,
  nix-update-script,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kmscon";
  version = "9.3.2";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "kmscon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a1H9/j92Z/vjvFp226Ps9PFy5dAS8yg+RErgJWIb9HQ=";
  };

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libGLU
    libGL
    libdrm
    libtsm
    libxkbcommon
    pango
    systemdLibs
    libgbm
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
  ];

  outputs = [
    "out"
    "man"
  ];

  patches = [
    ./sandbox.patch # Generate system units where they should be (nix store) instead of /etc/systemd/system
  ];

  postFixup = ''
    substituteInPlace $out/bin/kmscon \
      --replace-fail "awk" "${lib.getExe gawk}"
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    platforms = lib.platforms.linux;
  };
})

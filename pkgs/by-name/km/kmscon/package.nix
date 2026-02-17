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
  buildPackages,
  nix-update-script,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kmscon";
  version = "9.3.1";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "kmscon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pH+dBcUKXrVh9/y6mNWmYBx6HVbuSZX/F2sCG/Yj5UQ=";
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
  ];

  outputs = [
    "out"
    "man"
  ];

  patches = [
    ./sandbox.patch # Generate system units where they should be (nix store) instead of /etc/systemd/system
  ];

  postPatch = ''
    for i in ./docs/man/*.in; do
      substituteInPlace "''${i}" \
        --replace-fail "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" \
                       "${docbook_xml_dtd_42}/xml/dtd/docbook/docbookx.dtd"
    done
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

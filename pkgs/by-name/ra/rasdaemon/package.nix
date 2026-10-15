{
  cmocka,
  dmidecode,
  fetchFromGitHub,
  lib,
  libtraceevent,
  meson,
  ninja,
  nix-update-script,
  nixosTests,
  pciutils,
  pkg-config,
  python3,
  sqlite,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rasdaemon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "mchehab";
    repo = "rasdaemon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fSrGE6Y21+yGb8pYid+As3YHJ3g3820UmFU9rnxj5WU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (python3.withPackages (p: [ p.sqlalchemy ]))
  ];

  # don't add systemd, it isn't needed
  buildInputs = [
    libtraceevent
    pciutils
    sqlite
  ];

  propagatedBuildInputs = [
    (python3.withPackages (p: [ p.sqlalchemy ]))
  ];

  checkInputs = [
    cmocka
  ];

  postPatch = ''
    patchShebangs contrib/
    substituteInPlace util/ras_dimm.py \
      --replace-fail 'which("dmidecode")' '"${lib.getExe dmidecode}"'
    substituteInPlace tests/test-db-cli.c \
      --replace-fail "'%s/util/ras-mc-ctl.py'" "python3 '%s/util/ras-mc-ctl.py'"
  '';

  mesonFlags = [
    (lib.mesonEnable "mysql" false)
    (lib.mesonEnable "postgresql" false)
  ];

  outputs = [
    "out"
    "dev"
    "man"
    "inject"
  ];

  doCheck = true;

  postInstall = ''
    # remove incorrectly installed meson file
    rm $out/etc/ras/dimm_labels.d/meson.build
    install -Dm 0755 ../contrib/edac-fake-inject $inject/bin/edac-fake-inject
    install -Dm 0755 ../contrib/edac-tests $inject/bin/edac-tests
  '';

  passthru.tests = { inherit (nixosTests) rasdaemon; };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''
      A Reliability, Availability and Serviceability (RAS) logging tool using EDAC kernel tracing events
    '';
    longDescription = ''
      Rasdaemon is a RAS (Reliability, Availability and Serviceability) logging
      tool. It records memory errors, using the EDAC tracing events. EDAC is a
      Linux kernel subsystem with handles detection of ECC errors from memory
      controllers for most chipsets on i386 and x86_64 architectures. EDAC
      drivers for other architectures like arm also exists.
    '';
    homepage = "https://github.com/mchehab/rasdaemon";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    changelog = "${finalAttrs.meta.homepage}/releases/tag/v${finalAttrs.version}";
    maintainers = [ lib.maintainers.zowoq ];
  };
})

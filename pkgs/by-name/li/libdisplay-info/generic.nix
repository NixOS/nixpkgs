{
  version,
  hash,
}:

{
  lib,
  stdenv,
  buildPackages,
  fetchFromGitLab,
  meson,
  pkg-config,
  ninja,
  python3,
  hwdata,
  libv4l,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdisplay-info";
  inherit version;

  src = fetchFromGitLab {
    inherit hash;
    domain = "gitlab.freedesktop.org";
    owner = "emersion";
    repo = "libdisplay-info";
    tag = finalAttrs.version;
  };

  strictDeps = true;
  __structuredAttrs = true;

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    hwdata
    python3
  ]
  ++ lib.optionals (stdenv.hostPlatform.emulatorAvailable buildPackages) [
    # Only used for tests, which we cannot run without an emulator
    libv4l
  ];

  postPatch = ''
    patchShebangs tool/gen-search-table.py
  '';

  meta = {
    description = "EDID and DisplayID library";
    mainProgram = "di-edid-decode";
    homepage = "https://gitlab.freedesktop.org/emersion/libdisplay-info";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    maintainers = with lib.maintainers; [ pedrohlc ];
  };
})

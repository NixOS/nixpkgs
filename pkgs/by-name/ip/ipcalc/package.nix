{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  libmaxminddb,
  ronn,
  jq,
  withGeo ? null,
}:
assert
  withGeo == null || throw "withGeo is no longer supported as libGeoIP support was removed upstream"; # Added v1.2.0
stdenv.mkDerivation (finalAttrs: {
  pname = "ipcalc";
  version = "1.2.0";

  __darwinAllowLocalNetworking = true;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "ipcalc";
    repo = "ipcalc";
    rev = finalAttrs.version;
    hash = "sha256-MiXdqgW5yGQWY0bPYQzAfWB6KN5KjXCJCT5PB/+o3NM=";
  };

  postPatch = ''
    patchShebangs tests/ipcalc-testrunner.sh
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    ronn
  ];

  nativeCheckInputs = [
    jq
  ];

  buildInputs = [
    libmaxminddb
  ];

  mesonFlags = [
    # runtime linking doesn't work on NixOS anyway
    "-Duse_runtime_linking=disabled"
  ];

  doCheck = true;

  meta = {
    changelog = "https://gitlab.com/ipcalc/ipcalc/-/blob/master/NEWS";
    description = "Simple IP network calculator";
    homepage = "https://gitlab.com/ipcalc/ipcalc";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "ipcalc";
  };
})

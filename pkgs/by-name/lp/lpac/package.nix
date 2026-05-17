{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
  cmake,
  pkg-config,
  pcsclite,
  curl,
  libmbim,
  libqmi,
  withDrivers ? true,
  withLibeuicc ? true,
  withMbim ? stdenv.hostPlatform.isLinux,
  withQmi ? stdenv.hostPlatform.isLinux,
  nix-update-script,
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation (finalAttrs: {

  pname = "lpac";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "estkme-group";
    repo = "lpac";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ALne5sHB6ff7cHAWe0rFwpP/Yz4EhZBiOrgdM2B8+OE=";
  };

  env.LPAC_VERSION = finalAttrs.version;

  patches = [
    ./lpac-version.patch

    # CMAKE_OSX_ARCHITECTURES is set to "arm64;x86_64", and not overridable without this fix.
    # https://github.com/estkme-group/lpac/pull/346
    (fetchpatch {
      url = "https://github.com/estkme-group/lpac/commit/be86645e596ee34f6d85cd0f3e039d5b31f35856.patch";
      hash = "sha256-Y3tL9A1uKjX0x1O2WrQQ9k88Zu+Lpc+MNV9DRYePwgs=";
    })
  ];

  cmakeFlags = [
    (lib.cmakeBool "LPAC_DYNAMIC_DRIVERS" withDrivers)
    (lib.cmakeBool "LPAC_DYNAMIC_LIBEUICC" withLibeuicc)
    (lib.cmakeBool "LPAC_WITH_APDU_MBIM" withMbim)
    (lib.cmakeBool "LPAC_WITH_APDU_QMI" withQmi)
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pcsclite
  ]
  ++ optional withMbim libmbim
  ++ optional withQmi libqmi;

  postInstall = ''
    mkdir -p $out/share/doc/lpac
    cp -vr $src/docs/* $out/share/doc/lpac
  '';

  passthru = {
    updateScript = nix-update-script { attrPath = finalAttrs.pname; };
  };

  meta = {
    description = "C-based eUICC LPA";
    homepage = "https://github.com/estkme-group/lpac";
    mainProgram = "lpac";
    changelog = "https://github.com/estkme-group/lpac/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.agpl3Plus ] ++ optional withLibeuicc lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.all;
  };
})

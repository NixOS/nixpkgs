{
  stdenv,
  fetchFromGitHub,
  lib,
  cmake,
  pkg-config,
  pcsclite,
  curl,
  libmbim,
  libqmi,
  withDrivers ? true,
  withLibeuicc ? true,
  withMbim ? true,
  withQmi ? true,
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

  patches = [ ./lpac-version.patch ];

  cmakeFlags = [
    (lib.cmakeBool "LPAC_DYNAMIC_DRIVERS" withDrivers)
    (lib.cmakeBool "LPAC_DYNAMIC_LIBEUICC" withLibeuicc)
    (lib.cmakeBool "LPAC_WITH_APDU_MBIM" withMbim)
    (lib.cmakeBool "LPAC_WITH_APDU_QMI" withQmi)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
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

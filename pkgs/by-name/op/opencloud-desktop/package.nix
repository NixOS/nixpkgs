{
  lib,
  cmake,
  kdePackages,
  fetchFromGitHub,
  fetchFromGitLab,
  libre-graph-api-cpp-qt-client,
  kdsingleapplication,
  nix-update-script,
  qt6,
  versionCheckHook,
  stdenv,
}:
let
  # See issue https://github.com/NixOS/nixpkgs/issues/455981
  # It was spotted upstream that ecm 6.19.0 caused this issue
  # Therefore we pin ecm 6.18.0 which makes opencloud function correctly
  ecm618 = kdePackages.extra-cmake-modules.overrideAttrs (
    finalAttrs: prevAttrs: {
      version = "6.18.0";
      src = fetchFromGitLab {
        domain = "invent.kde.org";
        owner = "frameworks";
        repo = "extra-cmake-modules";
        tag = "v${finalAttrs.version}";
        hash = "sha256-hpqczRaV32yyXXRWxR30tOBEUNWDkeSzVrv0SHMrz1Y=";
      };
      patches = [ ];
    }
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencloud-desktop";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NM9SspeMXu1q3tfpcFk4OuLapu/clbotJLu2u4nmAlY=";
  };

  buildInputs = [
    ecm618
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qttools
    kdePackages.qtkeychain
    libre-graph-api-cpp-qt-client
    kdsingleapplication
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  strictDeps = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/opencloudcmd";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/opencloud-eu/desktop/releases/tag/v${finalAttrs.version}";
    description = "Desktop Application for OpenCloud";
    downloadPage = "https://github.com/opencloud-eu/desktop";
    homepage = "https://opencloud.eu/en";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.FKouhai ];
  };
})

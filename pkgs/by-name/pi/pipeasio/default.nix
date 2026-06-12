{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  pipewire,
  wine64Packages,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pipeasio";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "30350n";
    repo = "pipeasio";
    tag = "support-nixos";
    hash = "sha256-uGyAGTxRIC0MTlOT9WnJ81mVssEm8T8ETaQsu00Qh7U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wine64Packages.stable
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    pipewire
    qt6.qtbase
  ];

  cmakeFlags =
    let
      WINE_INCLUDE_DIRS = [
        "${wine64Packages.stable}/include/wine"
        "${wine64Packages.stable}/include/wine/windows"
      ];
    in
    [ "-DWINE_INCLUDE_DIRS=${builtins.concatStringsSep ";" WINE_INCLUDE_DIRS}" ];

  dontWrapQtApps = true;

  postFixup = ''
    wrapQtApp $out/bin/pipeasio-settings
    wrapProgram $out/bin/pipeasio-register \
        --set PIPEASIO_PREFIX "$out" \
        --prefix PATH : "${wine64Packages.stable}/bin"
  '';

  meta = {
    homepage = "https://m0n7y5.github.io/pipeasio/";
    changelog = "https://github.com/M0n7y5/pipeasio/releases/tag/${finalAttrs.src.tag}";
    description = "ASIO to Pipewire driver for WINE";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      _30350n
    ];
    platforms = [ "x86_64-linux" ];
  };
})

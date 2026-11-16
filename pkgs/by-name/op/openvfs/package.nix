{
  lib,
  stdenv,
  cmake,
  ctestCheckHook,
  fetchFromGitHub,
  fuse3,
  kdePackages,
  nix-update-script,
  nlohmann_json,
  qt6,
}:
#
stdenv.mkDerivation (finalAttrs: {
  pname = "openvfs";
  version = "0-unstable-2026-11-09";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "openvfs";
    rev = "e3ea395145da8cfa4d16609310300982a4aeba6b";
    hash = "sha256-pGBpWcDqKeGT8W8g84RLdKXjYyFV9AAwH/645CrPCw0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;
  nativeCheckInputs = [ ctestCheckHook ];

  buildInputs = [
    fuse3
    kdePackages.extra-cmake-modules
    nlohmann_json
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Virtual Filesystem Layer for cloud storages for the free desktop (FUSE based files-on-demand)";
    longDescription = ''
      On desktop systems the default config should be linked to avoid that file managers download all files when indexing directories and creating thumbnails:

      ```nix
      environment.etc."xdg/openvfs/config.json".source = "''${pkgs.openvfs}/etc/xdg/openvfs/config.json";
      ```
    '';
    homepage = "https://github.com/opencloud-eu/openvfs";
    license = lib.licenses.gpl3Plus;
    mainProgram = "openvfs";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
})

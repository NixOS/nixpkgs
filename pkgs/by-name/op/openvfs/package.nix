{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fuse3,
  kdePackages,
  nix-update-script,
  nlohmann_json,
  qt6,
}:
#
stdenv.mkDerivation {
  pname = "openvfs";
  version = "0-unstable-2026-10-21";

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "openvfs";
    rev = "c20c0fe4925607cb835a2d98f29632e954c558dd";
    hash = "sha256-e2r+L1jUV/iSVuVbf9bvgSCiyxbuUvNej+ynZre8+dM=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

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
}

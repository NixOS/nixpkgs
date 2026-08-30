{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linyaps-web-store-installer";
  version = "1.6.8";

  src = fetchFromGitHub {
    owner = "OpenAtom-Linyaps";
    repo = "linyaps-web-store-installer";
    rev = finalAttrs.version;
    hash = "sha256-KbtGoXzxZmo6x1bvzDZbwp/wl+dBojB6E+K87CAkI7g=";
  };

  postPatch = ''
    substituteInPlace ll-installer/space.linglong.Installer.desktop \
      --replace-fail "Exec=/usr/bin/ll-installer" "Exec=$out/bin/ll-installer"
  '';

  patches = [
    (fetchpatch2 {
      # https://github.com/OpenAtom-Linyaps/linyaps-web-store-installer/pull/24
      url = "https://github.com/OpenAtom-Linyaps/linyaps-web-store-installer/commit/fc365dd06b17df38d9ae991775e51c5f1b547341.patch?full_index=1";
      hash = "sha256-BpFM3w8njRANvxH34PyP3Y2hLtZWOl18KZxzA+Ew3Zg=";
      includes = [ "CMakeLists.txt" ];
    })
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  meta = {
    description = "URI Handler for Linyaps Web Store";
    homepage = "https://github.com/OpenAtom-Linyaps/linyaps-web-store-installer";
    changelog = "https://github.com/OpenAtom-Linyaps/linyaps-web-store-installer/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ hhr2020 ];
    mainProgram = "ll-installer";
    platforms = lib.platforms.linux;
  };
})

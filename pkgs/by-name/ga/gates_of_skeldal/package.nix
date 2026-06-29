{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  SDL2,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gates-of-skeldal";
  version = "0-unstable-2025-05-02";

  src = fetchFromGitHub {
    owner = "ondra-novak";
    repo = "gates_of_skeldal";
    rev = "9013f1038a13d7d2c2bf707d6e860de258fb9d2e";
    hash = "sha256-a6yH5kq9IBZAAYvM30mUddE6JC+Yzg+6WtgEqcnVje4=";
  };

  strictDeps = true;

  patches = [
    # Fix build on darwin
    (fetchpatch {
       url = "https://github.com/phodina/gates_of_skeldal/commit/ba500bec5f63acd9cad38a88760f42e9a51dc41f.patch";
       sha256 = "sha256-awHBgy10tLvh3A0obaOdubX7uR1H/DsNkRzo2btqFCQ=";
     })
    # Remove the mylib target on darwin
    (fetchpatch {
       url = "https://github.com/phodina/gates_of_skeldal/commit/8d5c5c419a21361ad4a2196dfcadaa8a9f1f1c38.patch";
       sha256 = "sha256-IrqnFFHbR5+9RNPljdhmp+jFjGARoaFFB8mEsBCedEM=";
     })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    zlib
  ];

  preConfigure = ''
    # Remove -Werror from CMake configuration
    find . -type f -name 'CMakeLists.txt' -exec sed -i 's/-Werror//g' {} +
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp --recursive bin $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open source release of the game 'Brány Skeldalu' (Gates of Skeldal)";
    homepage = "https://github.com/ondra-novak/gates_of_skeldal";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ phodina ];
  };
})

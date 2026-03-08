{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  python3,
  curl,
  icu,
  libzim,
  pugixml,
  zlib,
  libmicrohttpd,
  mustache-hpp,
  gtest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkiwix";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "libkiwix";
    rev = finalAttrs.version;
    hash = "sha256-yZWzzu0LLUxg0CbdeKARuaFsf3UxvJJbqPRDGXWDjLI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    icu
    zlib
    mustache-hpp
  ];

  propagatedBuildInputs = [
    curl
    libmicrohttpd
    libzim
    pugixml
  ];

  nativeCheckInputs = [
    gtest
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs scripts
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Common code base for all Kiwix ports";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/libkiwix/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ colinsane ];
  };
})

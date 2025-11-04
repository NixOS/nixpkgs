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
  version = "14.1.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "libkiwix";
    rev = finalAttrs.version;
    hash = "sha256-/JR8TQPFwJUsWDHq0gsTazdd933LQ9ciGKtb7mKAQb8=";
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
    # These tests use network access and cannot be run
    substituteInPlace test/meson.build \
        --replace-fail "'server'," "" \
        --replace-fail "'library_server'," "" \
        --replace-fail "'server_search'" ""
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Common code base for all Kiwix ports";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/libkiwix/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ colinsane ];
  };
})

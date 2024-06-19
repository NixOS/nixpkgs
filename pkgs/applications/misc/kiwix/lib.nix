{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, python3
, curl
, icu
, libzim
, pugixml
, zlib
, libmicrohttpd
, mustache-hpp
, gtest
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libkiwix";
  version = "13.1.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "libkiwix";
    rev = finalAttrs.version;
    hash = "sha256-DKOwzfGyad/3diOaV1K8hXqT8YGfqCP6QDKDkxWu/1U=";
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

  meta = with lib; {
    description = "Common code base for all Kiwix ports";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/libkiwix/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
})

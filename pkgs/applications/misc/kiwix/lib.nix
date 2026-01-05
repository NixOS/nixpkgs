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
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "libkiwix";
    rev = finalAttrs.version;
    hash = "sha256-QP23ZS0FJsMVtnWOofywaAPIU0GJ2L+hLP/x0LXMKiU=";
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
    substituteInPlace meson.build \
        --replace-fail "libicu_dep = dependency('icu-i18n', static:static_deps)" \
                       "libicu_dep = [dependency('icu-i18n', static:static_deps), dependency('icu-uc', static:static_deps)]"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Common code base for all Kiwix ports";
    homepage = "https://kiwix.org";
    changelog = "https://github.com/kiwix/libkiwix/releases/tag/${finalAttrs.version}";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
})

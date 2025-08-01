{
  fetchFromGitLab,
  glib,
  json-glib,
  lib,
  libgcrypt,
  libsecret,
  libsoup_3,
  cmake,
  meson,
  ninja,
  olm,
  pkg-config,
  sqlite,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcmatrix";
  version = "0.0.3";

  src = fetchFromGitLab {
    domain = "source.puri.sm";
    owner = "Librem5";
    repo = "libcmatrix";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Usaqkb6zClVtYCL1VUv4iNeKs2GZECO9sOdPk3N8iLM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config

    cmake # used by meson to find olm
  ];

  buildInputs = [
    glib
    json-glib
    libgcrypt
    libsecret
    libsoup_3
    olm
    sqlite
  ];

  prePatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # 0u is not a valid version number on darwin
    substituteInPlace src/meson.build --replace-fail "soversion: '0u'," "soversion: '0',"
  '';

  meta = {
    changelog = "https://source.puri.sm/Librem5/libcmatrix/-/blob/${finalAttrs.src.tag}/NEWS";
    description = "Matrix protocol library written in C using GObject";
    homepage = "https://source.puri.sm/Librem5/libcmatrix";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})

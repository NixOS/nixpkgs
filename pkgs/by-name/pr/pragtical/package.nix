{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cacert,
  meson,
  ninja,
  pkg-config,
  freetype,
  libgit2,
  libkqueue,
  libuchardet,
  libzip,
  lua5_4,
  luajit,
  mbedtls_2,
  pcre2,
  sdl3,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pragtical";
  version = "3.7.0";
  pluginManagerVersion = "1.4.0";
  linenoiseRev = "e78e236c8d85c078fdd9fc4e1f08716058aa1a42";

  src = fetchFromGitHub {
    owner = "pragtical";
    repo = "pragtical";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;

    # also fetch required git submodules
    postFetch = ''
      cd "$out"

      export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

      substituteInPlace subprojects/ppm.wrap \
        --replace-fail 'revision = head' 'revision = v${finalAttrs.pluginManagerVersion}'
      substituteInPlace subprojects/linenoise.wrap \
        --replace-fail 'revision = master' 'revision = ${finalAttrs.linenoiseRev}'

      ${lib.getExe meson} subprojects download \
          colors linenoise plugins ppm widget

      find subprojects -type d -name .git -prune -execdir rm -r {} +
    '';

    hash = "sha256-oqXv08TvZWVRsSCX6V9oAGHkFS0hL/gm3tGdiivOI6Q=";
  };

  patches = [
    # https://github.com/pragtical/pragtical/pull/334
    (fetchpatch {
      name = "fix-dirmonitor-backend-detection.patch";
      url = "https://github.com/pragtical/pragtical/commit/5cf26e1f6a491f28d761390309dd77a795bdae9d.patch";
      hash = "sha256-eD17ItcsyRTKn6jydyW3J2lFq/hl3qHUmQ2LC4LXKC0=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    lua5_4 # needed for built-time lua bytecode generation
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    freetype
    libgit2
    libkqueue # optional
    libuchardet
    libzip
    lua5_4
    luajit
    mbedtls_2
    pcre2
    sdl3
    xz
    zlib
  ];

  mesonFlags = [ "-Duse_system_lua=true" ];

  meta = {
    changelog = "https://github.com/pragtical/pragtical/blob/${finalAttrs.src.rev}/changelog.md";
    description = "Practical and pragmatic code editor";
    homepage = "https://pragtical.dev";
    license = lib.licenses.mit;
    mainProgram = "pragtical";
    maintainers = with lib.maintainers; [
      suhr
      tomasajt
    ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
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
  mbedtls,
  pcre2,
  sdl3,
  sdl3-image,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pragtical";
  version = "3.8.2";
  pluginManagerVersion = "1.4.7.1";
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

    hash = "sha256-qdOiwn9ThF5LXFNVzvr3MXVRax57bB5T5jDkm/NpgkA=";
  };

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
    mbedtls
    pcre2
    sdl3
    sdl3-image
    xz
    zlib
  ];

  mesonFlags = [
    (lib.mesonBool "use_system_lua" true)
  ];

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

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
  libuchardet,
  libzip,
  lua5_4,
  luajit,
  mbedtls_2,
  pcre2,
  SDL2,
  xz,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pragtical";
  version = "3.6.0";
  pluginManagerVersion = "1.4.0";

  src = fetchFromGitHub {
    owner = "pragtical";
    repo = "pragtical";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;

    # also fetch required git submodules
    postFetch = ''
      cd "$out"

      export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

      substituteInPlace subprojects/ppm.wrap \
          --replace-fail 'revision = head' 'revision = v${finalAttrs.pluginManagerVersion}'

      ${lib.getExe meson} subprojects download \
          colors widget plugins ppm

      find subprojects -type d -name .git -prune -execdir rm -r {} +
    '';

    hash = "sha256-rJEUTLjMTv19W1wSvW2HJaxHrzrBQHiG74v8XlcqgMc=";
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
    libuchardet
    libzip
    lua5_4
    luajit
    mbedtls_2
    pcre2
    SDL2
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

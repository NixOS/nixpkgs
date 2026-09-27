{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  oniguruma,
  expat,
  freetype,
  libxcb,
  python3,
  libiconv,
  fira-code,
  fontconfig,
  harfbuzz,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "silicon";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lwwbjSXW5uonJNZTAqTK14Ib4QDOD4puxY2CsiJk4/Q=";
  };

  cargoHash = "sha256-MpmGLhg00quz4mYkidLofpcZTVwxbgIThg5v2r4HIfs=";

  # Fix build with gcc15
  #   regparse.c:588:5: error: initialization of 'int (*)(void)' from incompatible pointer type 'int (*)(st_str_end_key *, st_str_end_key *)' [-Wincompatible-pointer-types]
  #   regparse.c:678:5: error: initialization of 'int (*)(void)' from incompatible pointer type 'int (*)(st_callout_name_key *, st_callout_name_key *)' [-Wincompatible-pointer-types]
  env.RUSTONIG_SYSTEM_LIBONIG = true;

  buildInputs = [
    expat
    freetype
    fira-code
    fontconfig
    harfbuzz
    oniguruma
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libxcb ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ python3 ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Create beautiful image of your source code";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      evanjs
      _0x4A6F
    ];
    mainProgram = "silicon";
  };
})

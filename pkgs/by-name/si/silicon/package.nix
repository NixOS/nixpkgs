{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  expat,
  freetype,
  libxcb,
  python3,
  libiconv,
  fira-code,
  fontconfig,
  harfbuzz,
}:

rustPlatform.buildRustPackage rec {
  pname = "silicon";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "Aloxaf";
    repo = "silicon";
    rev = "v${version}";
    hash = "sha256-lwwbjSXW5uonJNZTAqTK14Ib4QDOD4puxY2CsiJk4/Q=";
  };

  cargoHash = "sha256-MpmGLhg00quz4mYkidLofpcZTVwxbgIThg5v2r4HIfs=";

  buildInputs = [
    expat
    freetype
    fira-code
    fontconfig
    harfbuzz
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

  meta = with lib; {
    description = "Create beautiful image of your source code";
    homepage = "https://github.com/Aloxaf/silicon";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      evanjs
      _0x4A6F
    ];
    mainProgram = "silicon";
  };
}

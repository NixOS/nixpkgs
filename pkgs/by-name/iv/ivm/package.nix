{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  cargo,
  llvm_16,
  stdenv,
  libffi,
  libz,
  libxml2,
  ncurses,
}:

rustPlatform.buildRustPackage rec {
  pname = "ivm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = "ivm";
    rev = "v${version}";
    hash = "sha256-pqqUvHK6mPrK1Mir2ILANxtih9OrAKDJPE0nRWc5JOY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-voUucoSLsKn0QhCpr52U8x9K4ykkx7iQ3SsHfjrXu+Q=";

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/ivm \
      --prefix PATH : ${
        lib.makeBinPath [
          cargo
          llvm_16.dev
          stdenv.cc
        ]
      } \
      --prefix LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libffi
          libz
          libxml2
          ncurses
        ]
      }
  '';

  meta = {
    description = "Cross-platform Inko version manager";
    homepage = "https://github.com/inko-lang/ivm";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.feathecutie ];
    platforms = lib.platforms.unix;
    mainProgram = "ivm";
  };
}

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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = "ivm";
    rev = "v${version}";
    hash = "sha256-z0oo1JUZbX3iT8N9+14NcqUzalpARImcbtUiQYS4djA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NiZGSg0EU3yw5YS4eq/AJt/9AcdqwKEJAaWBmF5NwWw=";

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

{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  cargo,
  llvm,
  stdenv,
  libffi,
  libz,
  libxml2,
  ncurses,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttr: {
  pname = "ivm";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "inko-lang";
    repo = "ivm";
    tag = "v${finalAttr.version}";
    hash = "sha256-pqqUvHK6mPrK1Mir2ILANxtih9OrAKDJPE0nRWc5JOY=";
  };

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
          llvm.dev
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform Inko version manager";
    homepage = "https://github.com/inko-lang/ivm";
    license = lib.licenses.mpl20;
    maintainers = [ lib.maintainers.feathecutie ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.unix;
    mainProgram = "ivm";
  };
})

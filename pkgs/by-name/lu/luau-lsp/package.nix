{ fetchFromGitHub
, stdenv
, lib
, cmake
, gcc9
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "luau-lsp";
  version = "1.28.1";

  src = fetchFromGitHub {
    owner = "JohnnyMorganz";
    repo = "luau-lsp";
    rev = finalAttrs.version;
    hash = "sha256-5+m5tLX0DRHrV6yI/SXc39orpAu1DlBmpNQ/rt7LUjQ=";
    fetchSubmodules = true;
  };

  # Build fails if this is false
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [ cmake ]
    ++ lib.optional stdenv.isLinux gcc9;

  buildPhase = ''
    mkdir build && cd build
    cmake .. -DCMAKE_BUILD_TYPE=Release
    cmake --build . --target Luau.LanguageServer.CLI --config Release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./luau-lsp $out/bin/luau-lsp
  '';

  meta = {
    description = "Language Server for Luau";
    homepage = "https://github.com/JohnnyMorganz/luau-lsp";
    downloadPage = "https://github.com/JohnnyMorganz/luau-lsp/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ eggflaw ];
    mainProgram = "luau-lsp";
  };
})

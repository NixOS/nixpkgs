{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "luau-lsp";
  version = "1.42.0";

  src = fetchFromGitHub {
    owner = "JohnnyMorganz";
    repo = "luau-lsp";
    tag = finalAttrs.version;
    hash = "sha256-MX5jXkSxfN7IqY3kvlAKiimFecsuvCnCQ0QegISvAxE=";
    fetchSubmodules = true;
  };

  # https://github.com/JohnnyMorganz/luau-lsp/issues/743#issuecomment-2293315812
  patches = [ ./cmakelists.patch ];

  nativeBuildInputs = [ cmake ];

  buildPhase = ''
    runHook preBuild

    cmake --build . --target Luau.LanguageServer.CLI --config Release

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D luau-lsp $out/bin/luau-lsp

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language Server Implementation for Luau";
    homepage = "https://github.com/JohnnyMorganz/luau-lsp";
    downloadPage = "https://github.com/JohnnyMorganz/luau-lsp/releases/tag/${finalAttrs.version}";
    changelog = "https://github.com/JohnnyMorganz/luau-lsp/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anninzy ];
    mainProgram = "luau-lsp";
    platforms = lib.platforms.linux;
  };
})

{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
  nix-update-script,
}:

stdenv.mkDerivation (self: {
  pname = "emmy-lua-code-style";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "CppCXY";
    repo = "EmmyLuaCodeStyle";
    rev = "refs/tags/${self.version}";
    hash = "sha256-UqAAUZDkdQyl8qkp1Au97VlU4DKZwVokB+IGmyCp+Ek=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script {};

  meta = {
    homepage = "https://github.com/CppCXY/EmmyLuaCodeStyle";
    changelog = "https://github.com/CppCXY/EmmyLuaCodeStyle/releases/tag/${self.version}";
    description = "fast, powerful, and feature-rich Lua formatting and checking tool.";
    mainProgram = "CodeFormat";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.nobbz ];
  };
})

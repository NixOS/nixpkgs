{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emmy-lua-code-style";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "CppCXY";
    repo = "EmmyLuaCodeStyle";
    tag = finalAttrs.version;
    hash = "sha256-FYtDO9ZL7MjC+vHzrylyYBQHTtef/GM9ipt//EcLr4w=";
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/CppCXY/EmmyLuaCodeStyle";
    changelog = "https://github.com/CppCXY/EmmyLuaCodeStyle/releases/tag/${finalAttrs.version}";
    description = "Fast, powerful, and feature-rich Lua formatting and checking tool";
    mainProgram = "CodeFormat";
    platforms = lib.platforms.unix;
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.nobbz ];
  };
})

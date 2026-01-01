{
  stdenv,
  fetchFromGitHub,
  cmake,
  lib,
  nix-update-script,
}:

stdenv.mkDerivation (self: {
  pname = "emmy-lua-code-style";
<<<<<<< HEAD
  version = "1.6.0";
=======
  version = "1.5.7";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "CppCXY";
    repo = "EmmyLuaCodeStyle";
    tag = self.version;
<<<<<<< HEAD
    hash = "sha256-FYtDO9ZL7MjC+vHzrylyYBQHTtef/GM9ipt//EcLr4w=";
=======
    hash = "sha256-Lzh4ruyrWRTwU95iTMQozpLT5w92owHsDQM874XIuOg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ cmake ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/CppCXY/EmmyLuaCodeStyle";
    changelog = "https://github.com/CppCXY/EmmyLuaCodeStyle/releases/tag/${self.version}";
    description = "Fast, powerful, and feature-rich Lua formatting and checking tool";
    mainProgram = "CodeFormat";
    platforms = lib.platforms.unix;
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.nobbz ];
  };
})

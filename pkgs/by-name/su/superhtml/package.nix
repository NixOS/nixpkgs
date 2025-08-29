{
  lib,
  fetchFromGitHub,
  stdenv,
  zig_0_15,
}:
let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "superhtml";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "kristoff-it";
    repo = "superhtml";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z8Tc869VTLQSQgfz291i/XgK7STxpZA9cuBdqbVgIsY=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-j3LOjl9J6Q8ua+ipyMbYwD7wbQDJNiCI7dIaze/60cw=";
  };

  nativeBuildInputs = [
    zig
  ];

  meta = with lib; {
    description = "HTML Language Server and Templating Language Library";
    homepage = "https://github.com/kristoff-it/superhtml";
    license = lib.licenses.mit;
    mainProgram = "superhtml";
    maintainers = with lib.maintainers; [ petertriho ];
    platforms = lib.platforms.unix;
  };
})

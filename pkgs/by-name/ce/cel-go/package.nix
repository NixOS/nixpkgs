{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  cel-spec = buildGoModule (finalAttrs: {
    pname = "cel-spec";
    version = "0.25.2";

    src = fetchFromGitHub {
      owner = "cel-expr";
      repo = "cel-spec";
      tag = "v${finalAttrs.version}";
      hash = "sha256-aNyBGUlpTqILCiQHo7BxaZShI6q9xgtRegywd+jQSlo=";
    };

    vendorHash = "sha256-7Ngemih4jRO6VHSH2QxU/p1Q/E/ukUZ5wuUbZzRj6kA=";

    installPhase = ''
      runHook preInstall
      cp -r . $out
      runHook postInstall
    '';
  });
in
buildGoModule (finalAttrs: {
  pname = "cel-go";
  version = "0.31.0";

  src = fetchFromGitHub {
    owner = "cel-expr";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d2qteEY7aRKvzD+uF7uNibUv5dECaL61NogbZfd3cAQ=";
  };

  modRoot = "repl";

  vendorHash = "sha256-SetkDfzfR/zqkNirGeGlczvV5h/CM9GiAPP2pKq6QDU=";

  subPackages = [
    "main"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postPatch = ''
    substituteInPlace repl/go.mod \
      --replace-fail "../../cel-spec" "./cel-spec"
  '';

  preBuild = ''
    mkdir cel-spec
    cp -r ${cel-spec}/* cel-spec
  '';

  postInstall = ''
    mv $out/bin/{main,cel-go}
  '';

  passthru = {
    inherit cel-spec;
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/cel-expr/cel-go/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, portable, non-Turing complete expression evaluation with gradual typing";
    homepage = "https://github.com/cel-expr/cel-go";
    license = lib.licenses.asl20;
    mainProgram = "cel-go";
    maintainers = with lib.maintainers; [ hythera ];
  };
})

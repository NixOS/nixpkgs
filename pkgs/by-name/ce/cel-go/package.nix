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
  version = "0.29.2";

  src = fetchFromGitHub {
    owner = "cel-expr";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IubOpjSE91Y2kmWrXw/jFA2QqB3Mx0d/DcJgDVI6+dc=";
  };

  modRoot = "repl";

  vendorHash = "sha256-xbg13CPZEK2uXa6U7T5I/6l1OFcgFOaThcKCfQkgJXI=";

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

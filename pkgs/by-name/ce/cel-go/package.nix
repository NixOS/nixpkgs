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
      owner = "google";
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
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fiFkoYVKdSdYkSMQxmC1SvEEGsalBasCl9tzsGSYwmw=";
  };

  modRoot = "repl";

  vendorHash = "sha256-tMaDwKoE5tzbQD5b7EnpKqiT/CT9WDCKgoxQeyhIlXE=";

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
    changelog = "https://github.com/google/cel-go/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, portable, non-Turing complete expression evaluation with gradual typing";
    homepage = "https://github.com/google/cel-go";
    license = lib.licenses.asl20;
    mainProgram = "cel-go";
    maintainers = with lib.maintainers; [ hythera ];
  };
})

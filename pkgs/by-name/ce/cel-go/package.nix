{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  cel-spec = buildGoModule (finalAttrs: {
    pname = "cel-spec";
    version = "0.25.1";

    src = fetchFromGitHub {
      owner = "google";
      repo = "cel-spec";
      tag = "v${finalAttrs.version}";
      hash = "sha256-D9NHnQerquU2nDhDIheHmzV2FUwKi+MfTO+sehMXudg=";
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
  version = "0.27.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cel-go";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gry3Kwx9SKFxLrUCVpg4hxv5J1R6HzHWW9W0OG7dpKA=";
  };

  modRoot = "repl";

  vendorHash = "sha256-J0O3yGBYsX+9Eel0O5crUJxk0DNLxob/Tsue57O9Toc=";

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

  meta = {
    changelog = "https://github.com/google/cel-go/releases/tag/${finalAttrs.src.tag}";
    description = "Fast, portable, non-Turing complete expression evaluation with gradual typing";
    homepage = "https://github.com/google/cel-go";
    license = lib.licenses.asl20;
    mainProgram = "cel-go";
    maintainers = with lib.maintainers; [ hythera ];
  };
})

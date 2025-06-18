{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
  pnpm_9,
  stdenvNoCC,
}:
let
  pname = "cyphernetes";
  version = "0.17.0";
  src = fetchFromGitHub {
    owner = "AvitalTamir";
    repo = "cyphernetes";
    tag = "v${version}";
    hash = "sha256-zVko3Vs2axLLP2I+jHRgeQsbgLZ9yP7NYDnZXntxdi8=";
  };

  cyphernetes-web-ui =
    let
      pname = "cyphernetes-web-ui";
      sourceRoot = "${src.name}/web";
    in
    stdenvNoCC.mkDerivation {
      inherit
        pname
        version
        src
        sourceRoot
        ;

      pnpmDeps = pnpm_9.fetchDeps {
        inherit
          pname
          version
          src
          sourceRoot
          ;
        hash = "sha256-yIEulmfkwkK1O01rXNhBGO2lQRvU3Kn2e6OpBR7rlD8=";
      };
      nativeBuildInputs = [
        nodejs
        pnpm_9.configHook
      ];
      buildPhase = ''
        runHook preBuild
        pnpm build
        runHook postBuild
      '';
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -R dist/* $out/
        runHook postInstall
      '';
    };
in
buildGoModule {
  inherit pname version src;
  vendorHash = "sha256-QthLrLhi+hWngtc11nyFPU63exHZ0mh3IWWa8YHXFPA=";
  subPackages = [ "cmd/cyphernetes" ];
  doCheck = false; # Tests need a kubeconfig with an active context configured
  preBuild = ''
    cp -r ${cyphernetes-web-ui} cmd/cyphernetes/web/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://cyphernet.es/";
    changelog = "https://github.com/AvitalTamir/cyphernetes/releases/tag/v${version}";
    description = "Kubernetes query language";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      kshlm
      stefankeidel
    ];
    mainProgram = "cyphernetes";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

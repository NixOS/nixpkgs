{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
  pnpm,
  stdenvNoCC,
}:
let
  pname = "cyphernetes";
  version = "0.14.0";
  src = fetchFromGitHub {
    owner = "AvitalTamir";
    repo = "cyphernetes";
    tag = "v${version}";
    hash = "sha256-rxZWI+2eWMNTjphxS+lsxAoZUXD8wWF1pfe6hLBxtuM=";
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

      pnpmDeps = pnpm.fetchDeps {
        inherit
          pname
          version
          src
          sourceRoot
          ;
        hash = "sha256-3uOBSVA4oyPDj9GLiBSPQonalaSYveJ4II01GTfaAUw=";
      };
      nativeBuildInputs = [
        nodejs
        pnpm.configHook
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
  vendorHash = "sha256-DRzYgpHShZn+17R1Jj/arwAP5lyTpWelmwloUxT3n5Y=";
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

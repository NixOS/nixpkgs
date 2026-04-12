{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "grove";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "zachthieme";
    repo = "grove";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O2PIgKkFTOg84WYNvNWcgtkjZprQV8dWmuCCFz61gns=";
  };

  vendorHash = "sha256-s5odRE+tm4K7dEDJVKVF/3882c6dCygOldJCMqt0wNM=";

  frontend = buildNpmPackage {
    pname = "grove-frontend";
    inherit (finalAttrs) src version;

    sourceRoot = "${finalAttrs.src.name}/web";

    npmDepsHash = "sha256-b2B6e2nW0tzrNCMGgUOoVNOP3umLh86viHKQ8OPMd44=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };

  preBuild = ''
    mkdir -p web/dist
    cp -r ${finalAttrs.frontend}/* web/dist/
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zachthieme/grove/cmd.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Interactive web-based org chart planner with CSV/XLSX import and drag-and-drop editing";
    homepage = "https://github.com/zachthieme/grove";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zachthieme ];
    mainProgram = "grove";
  };
})

{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "zachthieme";
    repo = "grove";
    tag = "v${version}";
    hash = "sha256-EgAsgV4LrnvWMvfElkzDERv9Ih0E7ALBMoqFZH0IGcY=";
  };

  frontend = buildNpmPackage {
    pname = "grove-frontend";
    inherit version src;

    sourceRoot = "${src.name}/web";

    npmDepsHash = "sha256-b2B6e2nW0tzrNCMGgUOoVNOP3umLh86viHKQ8OPMd44=";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/* $out/
      runHook postInstall
    '';
  };
in
buildGoModule {
  pname = "grove";
  inherit version src;

  vendorHash = "sha256-s5odRE+tm4K7dEDJVKVF/3882c6dCygOldJCMqt0wNM=";

  preBuild = ''
    mkdir -p web/dist
    cp -r ${frontend}/* web/dist/
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Interactive web-based org chart planner with CSV/XLSX import and drag-and-drop editing";
    homepage = "https://github.com/zachthieme/grove";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "grove";
  };
}

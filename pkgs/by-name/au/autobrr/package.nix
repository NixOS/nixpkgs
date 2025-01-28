{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
  nodejs,
  pnpm_9,
  typescript,
  versionCheckHook,
}:

let
  pname = "autobrr";
  version = "1.57.0";
  src = fetchFromGitHub {
    owner = "autobrr";
    repo = "autobrr";
    tag = "v${version}";
    hash = "sha256-RVkeSrL3ZfEz+oCICi8JFJ6AaOBBumi5mnnQYE5Gjt8=";
  };

  autobrr-web = stdenvNoCC.mkDerivation {
    pname = "${pname}-web";
    inherit src version;

    nativeBuildInputs = [
      nodejs
      pnpm_9.configHook
      typescript
    ];

    sourceRoot = "${src.name}/web";

    pnpmDeps = pnpm_9.fetchDeps {
      inherit (autobrr-web)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-mABHRuZfjq9qNanfGGv+xDhs3bSufaWRecJypic8SWo=";
    };

    postBuild = ''
      pnpm run build
    '';

    installPhase = ''
      cp -r dist $out
    '';
  };
in
buildGoModule rec {
  inherit
    autobrr-web
    pname
    version
    src
    ;

  vendorHash = "sha256-rCtUE2/IwR6AnXQNgeH0TQ0BL7g6vi9L128xP0PwOXc=";

  preBuild = ''
    cp -r ${autobrr-web}/* web/dist
  '';

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=${src.tag}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/autobrrctl";
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "autobrr-web"
    ];
  };

  meta = {
    description = "Modern, easy to use download automation for torrents and usenet";
    license = lib.licenses.gpl2Plus;
    homepage = "https://autobrr.com/";
    changelog = "https://autobrr.com/release-notes/v${version}";
    maintainers = with lib.maintainers; [ av-gal ];
    mainProgram = "autobrr";
    platforms = with lib.platforms; darwin ++ freebsd ++ linux;
  };
}

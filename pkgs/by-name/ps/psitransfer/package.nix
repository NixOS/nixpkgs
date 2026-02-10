{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage (finalAttrs: {
  pname = "psitransfer";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "psi-4ward";
    repo = "psitransfer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ikpdqcubqVFbjjQUlrL5Cn3MTsOhkw48dtgLowGv0ho=";
  };

  npmDepsHash = "sha256-4jKbDzjwWMJAGEjb2FwGv0wZw6SS0ZnlLWrTDX88zv0=";

  app = buildNpmPackage {
    pname = "psitransfer-app";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-PpUO1u7TcH8ZcTekLcGOn07EnCHqUlbEMS/YzMLSMAs=";

    postPatch = ''
      # https://github.com/psi-4ward/psitransfer/pull/284
      touch public/app/.npmignore
      cd app
    '';

    installPhase = ''
      cp -r ../public/app $out
    '';
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    vips # for 'sharp' dependency
  ];

  postPatch = ''
    rm -r public/app
    cp -r ${finalAttrs.app} public/app
  '';

  dontBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Simple open source self-hosted file sharing solution";
    homepage = "https://github.com/psi-4ward/psitransfer";
    changelog = "https://github.com/psi-4ward/psitransfer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hyshka ];
    mainProgram = "psitransfer";
  };
})

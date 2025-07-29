{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage (finalAttrs: {
  pname = "psitransfer";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "psi-4ward";
    repo = "psitransfer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5o4QliAXgSZekIy0CNWfEuOxNl0uetL8C8RKUJ8HsNA=";
  };

  npmDepsHash = "sha256-EW/Fej58LE/nbJomPtWvEjDveAUdo0jIWwC+ziN0gy0=";

  app = buildNpmPackage {
    pname = "psitransfer-app";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-q7E+osWIf6VZ3JvxCXoZYeF28aMgmKP6EzQkksUUjeY=";

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

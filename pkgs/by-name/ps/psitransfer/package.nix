{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage (finalAttrs: {
  pname = "psitransfer";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "psi-4ward";
    repo = "psitransfer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ezrDzMWKIP7SXHgSifwtGNjvaHAX6Yfk95vYjleT8+w=";
  };

  npmDepsHash = "sha256-kxco70h2Gy3ldjUY93d6i7XpmJXulgjfmbt2lYhmvSo=";

  app = buildNpmPackage {
    pname = "psitransfer-app";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-vbb7GGWiYt5ZqqFuEpJTO55oNJ+G5Lu0mXJQM1l7c/E=";

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
    maintainers = [ ];
    mainProgram = "psitransfer";
  };
})

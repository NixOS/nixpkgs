{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  vips,
}:

buildNpmPackage (finalAttrs: {
  pname = "psitransfer";
<<<<<<< HEAD
  version = "2.3.1";
=======
  version = "2.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "psi-4ward";
    repo = "psitransfer";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-I5+SgPR53zdgTwHd4tdSoPr1y1iQ/JHH0KXqexgkGVE=";
=======
    hash = "sha256-XUEvR8dWwFBbZdwVM8PQnYBc17SvGF5uO04vb/nAR2A=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  npmDepsHash = "sha256-BZpd/fsuV77uj2bGZcqBpIuOq3YlUw2bxovOfu8b9iE=";

  app = buildNpmPackage {
    pname = "psitransfer-app";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-zEGYv6TaHzgPCB3mHP2UMh8VkFqSBdrLuP5KjuEU0p8=";

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

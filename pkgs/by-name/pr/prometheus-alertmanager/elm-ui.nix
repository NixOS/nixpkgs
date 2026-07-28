{
  buildNpmPackage,
  elmPackages,
  prometheus-alertmanager,
}:

buildNpmPackage (finalAttrs: {
  pname = "alertmanager-elm-ui";
  inherit (prometheus-alertmanager) src version meta;

  sourceRoot = "${finalAttrs.src.name}/ui/app";

  postPatch = ''
    # don't download elm from github
    sed -i '/"elm":/d' package.json
  '';

  postConfigure = (
    elmPackages.fetchElmDeps {
      # elm2nix convert > elm-srcs.nix
      elmPackages = import ./elm-srcs.nix;
      elmVersion = elmPackages.elm.version;
      # elm2nix snapshot > registry.dat
      registryDat = ./registry.dat;
    }
  );

  npmDepsHash = "sha256-2flvNJXsOhE0k10Eu8kWo3p3aAABFB/f3yeYNrIztpw=";

  nativeBuildInputs = [
    elmPackages.elm
  ];

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp -r dist/* $out/
    runHook postInstall
  '';
})

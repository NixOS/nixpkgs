{
  version,
  src,
  pname,
  pnpm,
  meta,
  buildNpmPackage,
}:

buildNpmPackage {
  inherit version src meta;
  pname = "${pname}-webui";

  npmDepsHash = "sha256-oHBFuX65D/FgnGa03jjpIKAdH8Q4c2NrpD64bhfe720=";

  buildPhase = ''
    runHook preBuild

    node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
}

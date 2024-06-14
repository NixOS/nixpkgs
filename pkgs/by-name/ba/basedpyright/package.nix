{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  jq,
}:

let
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    rev = "v${version}";
    hash = "sha256-fiaIkZoW0eOzVLOv9vhEk32kgKorNSG1vtNw0bIOtNU=";
  };

  patchedPackageJSON = runCommand "package.json" { } ''
    ${jq}/bin/jq '
      .devDependencies |= with_entries(select(.key == "glob" or .key == "jsonc-parser"))
      | .scripts =  {  }
      ' ${src}/package.json > $out
  '';

  pyright-root = buildNpmPackage {
    pname = "pyright-root";
    inherit version src;
    npmDepsHash = "sha256-63kUhKrxtJhwGCRBnxBfOFXs2ARCNn+OOGu6+fSJey4=";
    dontNpmBuild = true;
    postPatch = ''
      cp ${patchedPackageJSON} ./package.json
      cp ${./package-lock.json} ./package-lock.json
    '';
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };

  pyright-internal = buildNpmPackage {
    pname = "pyright-internal";
    inherit version src;
    sourceRoot = "${src.name}/packages/pyright-internal";
    npmDepsHash = "sha256-bdlcGrYLnX318+MByYIzjnchl9n4+EcZKCZJgSMKyHo=";
    dontNpmBuild = true;
    # FIXME: Remove this flag when TypeScript 5.5 is released
    npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };
in
buildNpmPackage rec {
  pname = "basedpyright";
  inherit version src;

  sourceRoot = "${src.name}/packages/pyright";
  npmDepsHash = "sha256-JDGNpyOBK3EwbHIHp4Zoo376MqU5u97Zj46vtuWY488=";

  postPatch = ''
    chmod +w ../../
    ln -s ${pyright-root}/node_modules ../../node_modules
    chmod +w ../pyright-internal
    ln -s ${pyright-internal}/node_modules ../pyright-internal/node_modules
  '';

  postInstall = ''
    mv "$out/bin/pyright" "$out/bin/basedpyright"
    mv "$out/bin/pyright-langserver" "$out/bin/basedpyright-langserver"
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases/tag/${version}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/detachhead/basedpyright";
    license = lib.licenses.mit;
    mainProgram = "basedpyright";
    maintainers = with lib.maintainers; [ kiike ];
  };
}

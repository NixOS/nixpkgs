{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  jq,
}:

let
  version = "1.1.396";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "pyright";
    tag = version;
    hash = "sha256-6YvjpLV1Jj5N0CgN9hE7C2X9BMYZBJegB0xpSBW8n5c=";
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
    sourceRoot = "${src.name}"; # required for update.sh script
    npmDepsHash = "sha256-FqEh212Npa2Sye7qeKQJQukNc/nhNVCUp2HoypGGoOA=";
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
    npmDepsHash = "sha256-HwwVshop15nHE5oFuPIFmL5AduJ2z208cv2TbEAEMnY=";
    dontNpmBuild = true;
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };
in
buildNpmPackage rec {
  pname = "pyright";
  inherit version src;

  sourceRoot = "${src.name}/packages/pyright";
  npmDepsHash = "sha256-ywQimf2w5xXbNqcluv6Bi/wH7/QQG0U/r6Ferx9vbis=";

  postPatch = ''
    chmod +w ../../
    ln -s ${pyright-root}/node_modules ../../node_modules
    chmod +w ../pyright-internal
    ln -s ${pyright-internal}/node_modules ../pyright-internal/node_modules
  '';

  dontNpmBuild = true;

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/Microsoft/pyright/releases/tag/${src.tag}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/Microsoft/pyright";
    license = lib.licenses.mit;
    mainProgram = "pyright";
    maintainers = with lib.maintainers; [ kalekseev ];
  };
}

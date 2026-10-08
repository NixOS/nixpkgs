{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  jq,
}:

let
  version = "1.1.412";

  src = fetchFromGitHub {
    owner = "Microsoft";
    repo = "pyright";
    tag = version;
    hash = "sha256-V2sQp/LA43NjCdtr2/drZ1LMgm4u2tcf4EjdhWVLXHw=";
  };

  patchedPackageJSON =
    runCommand "package.json"
      {
        nativeBuildInputs = [ jq ];
      }
      ''
        jq '
          .devDependencies |= with_entries(select(.key == "glob" or .key == "jsonc-parser"))
          | .scripts =  {  }
          ' ${src}/package.json > $out
      '';

  pyright-root = buildNpmPackage {
    pname = "pyright-root";
    inherit version src;
    sourceRoot = "${src.name}"; # required for update.sh script
    npmDepsHash = "sha256-0w/CYFfAaEK6LKZZc9+nt5zUmxCqCcJfSZRAroOhJOA=";
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
    npmDepsHash = "sha256-skTnHcET5ujyKTEqh3oyiBwHF6yvaY8c/ccOnwQQKJ0=";
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
  npmDepsHash = "sha256-rgENiJVYKMSZimWzlvaaiC6Z5/OEdk4W47gkjcuv0nw=";

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

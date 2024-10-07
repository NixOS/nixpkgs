{
  lib,
  fetchFromGitHub,
  runCommand,
  buildNpmPackage,
  stdenvNoCC,
  docify,
  testers,
  writeText,
  jq,
  python3,
  basedpyright,
}:

let
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    rev = "refs/tags/v${version}";
    hash = "sha256-nYbxgrNFhQ576rN8W+Hf/Keohy1N8tihOeTQHItKPRc=";
  };

  # To regenerate the patched package-lock.json, copy the patched package.json
  # and run `nix-shell -p nodejs --command 'npm update --package-lock'`
  patchedPackageJSON = runCommand "package.json" { } ''
    ${jq}/bin/jq '
      .devDependencies |= with_entries(select(.key == "glob" or .key == "jsonc-parser" or .key == "@detachhead/ts-helpers"))
      | .scripts =  {  }
      ' ${src}/package.json > $out
  '';

  pyright-root = buildNpmPackage {
    pname = "pyright-root";
    inherit version src;
    npmDepsHash = "sha256-vxfoaShk3ihmhr/5/2GSOuMqeo6rxebO6aiD3DybjW4=";
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
    npmDepsHash = "sha256-Md17EF3a1GBfnHD2fnLGS76r0xiWYJmBBTzZWRc0j5c=";
    dontNpmBuild = true;
    # Uncomment this flag when using unreleased peer dependencies
    # npmFlags = [ "--legacy-peer-deps" ];
    installPhase = ''
      runHook preInstall
      cp -r . "$out"
      runHook postInstall
    '';
  };

  docstubs = stdenvNoCC.mkDerivation {
    name = "docstubs";
    inherit src;
    nativeBuildInputs = [ docify ];

    installPhase = ''
      runHook preInstall
      cp -r packages/pyright-internal/typeshed-fallback docstubs
      docify docstubs/stdlib --builtins-only --in-place
      cp -rv docstubs "$out"
      runHook postInstall
    '';
  };
in
buildNpmPackage rec {
  pname = "basedpyright";
  inherit version src;

  sourceRoot = "${src.name}/packages/pyright";
  npmDepsHash = "sha256-6/OhBbIuFjXTN8N/PitaQ57aYZmpwcUOJ/vlLbhiXAU=";

  postPatch = ''
    chmod +w ../../
    ln -s ${docstubs} ../../docstubs
    ln -s ${pyright-root}/node_modules ../../node_modules
    chmod +w ../pyright-internal
    ln -s ${pyright-internal}/node_modules ../pyright-internal/node_modules
  '';

  postInstall = ''
    mv "$out/bin/pyright" "$out/bin/basedpyright"
    mv "$out/bin/pyright-langserver" "$out/bin/basedpyright-langserver"
  '';

  dontNpmBuild = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      version = testers.testVersion { package = basedpyright; };

      # We are expecting 3 errors. Any other amount would indicate, not working
      # stub files, for instance.
      simple = testers.testEqualContents {
        assertion = "simple type checking";
        expected = writeText "expected" ''
          3
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [
                jq
                basedpyright
              ];
              base = writeText "base" ''
                import sys

                if sys.platform == "win32":
                    a = "a" + 1

                print(3)
                nonexistentfunction(3)
              '';

            }
            ''
              (basedpyright --outputjson $base || true) | jq -r .summary.errorCount > $out
            '';
      };
    };
  };

  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases/tag/${version}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/detachhead/basedpyright";
    license = lib.licenses.mit;
    mainProgram = "basedpyright";
    maintainers = with lib.maintainers; [ kiike ];
  };
}

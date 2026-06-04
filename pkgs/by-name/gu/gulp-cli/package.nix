{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  runCommand,
  versionCheckHook,
  jq,
}:
let
  pname = "gulp-cli";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "gulpjs";
    repo = "gulp-cli";
    tag = "v${version}";
    hash = "sha256-eLorGF/aZwzi+c6sabmgkqvryNtznt3mJVc/Vmfa9aE=";
  };

  # The published package includes a prebuilt `gulp.1` manpage that is not in
  # the git source. The man entry is removed so `npm pack` does not look for it.
  patchedPackageJSON = runCommand "package.json" { } ''
    ${jq}/bin/jq 'del(.man) | .files |= map(select(. != "gulp.1"))' ${src}/package.json > $out
  '';
in
buildNpmPackage (finalAttrs: {
  inherit pname version src;

  __structuredAttrs = true;

  postPatch = ''
    cp ${patchedPackageJSON} package.json
    # Upstream source does not include a package-lock.json, so it was regenerated
    # via `npm install --package-lock-only` at this tag
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-GQmVIkKYlsRXZLS4WLk47hmn87tmIu+AwShkzkK0Ih8=";

  dontNpmBuild = true;

  dontNpmPrune = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.tests = {
    # The following is a sample output of running the `gulp` command in a non-gulp project:
    # ```
    # [15:43:18] Local gulp not found in /nix/var/nix/builds/nix-36407-2235044704
    # [15:43:18] Try running: npm install gulp
    # ```
    # Therefore validate that the string "Local gulp not found in" is part of the output
    simple =
      runCommand "${finalAttrs.pname}-test-simple" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
        ''
          output=$(gulp 2>&1 || true)
          match="Local gulp not found in"
          if grep -q "$match" <<< "$output"; then
            touch $out
          else
            echo "Expected '$match' in output, got:" >&2
            echo "$output" >&2
            exit 1
          fi
        '';
  };

  meta = {
    description = "Command line interface for gulp";
    homepage = "https://gulpjs.com";
    changelog = "https://github.com/gulpjs/gulp-cli/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ joaquingatica ];
    mainProgram = "gulp";
    platforms = lib.platforms.all;
  };
})

{
  lib,
  stdenv,
  mattermost,
  nodejs,
  writeShellScriptBin,
  buildGoModule,
  golangci-lint,
  gotestsum,
  fetchNpmDeps,
  npmHooks,
  npm-lockfile-fix,
}:

{
  # The name of the plugin.
  pname,
  # The plugin version.
  version,
  # The plugin source.
  src,

  # True to ignore golangci-lint warnings. By default set to true
  # since plugins warn about the Mattermost interface but build fine.
  ignoreGoLintWarnings ? true,

  # The hash of the gomod vendor directory.
  vendorHash ? lib.fakeHash,

  # True to build the webapp.
  buildWebapp ? true,

  # The NPM dependency hash.
  npmDepsHash ? lib.fakeHash,

  # Any extra attributes to pass to buildGoModule.
  extraGoModuleAttrs ? { },
}:

let
  fakeGit = writeShellScriptBin "git" ''
    case "$1" in
      rev-parse|describe|tag)
        echo ${lib.escapeShellArg version} ;;
      config)
        echo ${lib.escapeShellArg pname} ;;
      *) ;;
    esac
  '';

  fake-golangci-lint = writeShellScriptBin "golangci-lint" ''
    set -uo pipefail
    ${lib.getExe golangci-lint} "$@"
    result=$?
    echo "golangci-lint returned: $result" >&2
    ${lib.optionalString (ignoreGoLintWarnings) ''
      if [ $result != 0 ]; then
        cat <<EOF >&2
      Ignoring return value since ignoreGoLintWarnings was true.
      Tell this plugin author to fix their lint.
      EOF
        result=0
      fi
    ''}
    exit $result
  '';
in
buildGoModule (
  rec {
    name = "${pname}-${version}.tar.gz";
    inherit version src vendorHash;

    npmDeps =
      if buildWebapp then
        fetchNpmDeps {
          src = "${src}/webapp";
          hash = npmDepsHash;
          forceGitDeps = true;
          postFetch = ''
            ${lib.getExe npm-lockfile-fix} package-lock.json
          '';
        }
      else
        null;

    makeCacheWritable = true;
    forceGitDeps = true;

    overrideModAttrs = final: {
      preBuild = ''
        go mod tidy
      '';

      # Adding the NPM config hook here breaks things, and isn't even needed.
      nativeBuildInputs = lib.lists.remove npmHooks.npmConfigHook final.nativeBuildInputs;
    };

    prePatch = lib.optionalString buildWebapp ''
      # Move important node.js files up a level and symlink the originals so the setup hook finds them
      for file in package.json package-lock.json node_modules; do
        if [ -f "webapp/$file" ]; then
          mv "webapp/$file" .
        fi
        (cd webapp && ln -vsf "../$file")
      done

      # Don't allow Go installation in the sandbox, but also don't fail
      substituteInPlace Makefile --replace-warn '$(GO) install' '@echo $(GO) install'
    '';

    nativeBuildInputs = [
      fakeGit
      nodejs
      npmHooks.npmConfigHook
    ];

    buildInputs = [ mattermost ];

    preBuild = ''
      # Or else Babel doesn't run.
      export NODE_OPTIONS=--openssl-legacy-provider

      # Only build GOOS and GOARCH plugins so we aren't
      # spitting out FreeBSD/Windows/Darwin executables we don't use.
      export MM_SERVICESETTINGS_ENABLEDEVELOPER=true
    '';

    buildPhase = ''
      runHook preBuild

      # These dependencies are ordinarily fetched via the Makefile, making
      # $(GO) install only echo means we still need to install them.
      mkdir -p bin
      ln -sf ${lib.getExe fake-golangci-lint} bin/golangci-lint
      ln -sf ${lib.getExe gotestsum} bin/gotestsum

      # Do the build.
      make

      runHook postBuild
    '';

    installPhase = ''
      plugin="$(ls dist/*.tar.gz | tail -n1)"
      if [ -z "$plugin" ] || [ ! -f "$plugin" ]; then
        echo "No plugin tarball in dist folder!" >&2
        exit 1
      fi
      cp -av "$plugin" $out
    '';
  }
  // extraGoModuleAttrs
)

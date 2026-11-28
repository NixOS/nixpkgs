{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage (finalAttrs: {
  pname = "meshcentral";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "Ylianst";
    repo = "MeshCentral";
    tag = finalAttrs.version;
    hash = "sha256-xS9R7fhFDQKmKtsNw8aZw8EwByx3rXYZDD93ma5DOWg=";
  };

  npmDepsHash = "sha256-CxalB/RdxXJcde/hn5dsJp8ykLrBSag+oIE4SKpCwq4=";

  # node-gyp needs distutils
  nativeBuildInputs = [ (nodejs.python.withPackages (ps: [ ps.setuptools ])) ];

  patches = [
    ./fix-js-include-paths.patch
    # from some reason the way the package is installed causes the `require`
    # line in `$out/lib/node_modules/meshcentral/bin/meshcentral` to import the
    # main file as a module, and thus nothing happens when it runs. We remove
    # this conditional since we never use this as a module.
    ./run.patch
    # Modules with a pinned version (e.g. `otplib`, `ua-client-hints-js`) that
    # have `exports` in their `package.json` are looked up in `$out/lib/node_modules`
    # by the fallback check, but we install them into
    # `$out/lib/node_modules/meshcentral/node_modules`. Without this MeshCentral
    # thinks they are missing and tries to run `npm install` at runtime.
    ./fix-module-version-check.patch
    # Add `optionalDependencies` that are used during runtime, to
    # `package{,-lock}.json`. During a video meeting with upstream, they sort
    # of agreed to track these optionalDependencies from now on, but they are
    # still not sure about a few details regarding this. See:
    #
    # https://github.com/Ylianst/MeshCentral/pull/7672
    #
    # The above doesn't apply cleanly on 1.1.57, but hopefully it shouldn't be
    # too hard to regenerate it for the next version.
    ./optionalDependencies.patch
  ];

  dontNpmBuild = true;

  meta = {
    description = "Computer management web app";
    homepage = "https://meshcentral.com/";
    changelog = "https://github.com/Ylianst/MeshCentral/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ samirbgno ];
    license = lib.licenses.asl20;
    mainProgram = "meshcentral";
  };
})

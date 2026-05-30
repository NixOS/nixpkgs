{
  unzip,
  gqlgenVersion,
  generatePaths ? [
    "./loaders"
    "./graph"
  ],
}:
let
  generateCmds = builtins.concatStringsSep "\n" (
    map (p: "if [ -d ${p} ]; then go generate ${p}; fi") generatePaths
  );
in
{
  overrideModAttrs = (
    _: {
      # Override the main preBuild (which unzips gqlgen) - not needed here.
      preBuild = "";
      # Run go generate AFTER go mod download so that gqlgen can execute.
      # The buildPhase creates an empty vendor/ dir which confuses go commands,
      # so remove it first and use -mod=mod to allow module resolution via cache.
      postBuild = ''
        rm -rf vendor
        export GOFLAGS=-mod=mod
        ${generateCmds}
        unset GOFLAGS
      '';
    }
  );

  # Workaround this error:
  #   go: git.sr.ht/~emersion/go-emailthreads@v0.0.0-...: module lookup disabled by GOPROXY=off
  #   tidy failed: go mod tidy failed: exit status 1
  #   graph/generate.go:10: running "go": exit status 1
  proxyVendor = true;

  nativeBuildInputs = [ unzip ];

  # Workaround -trimpath in the package derivation:
  # https://github.com/99designs/gqlgen/issues/1537
  # This is to give `go generate ./graph` access to gqlgen's *.gotpl files
  # If it fails, the gqlgenVersion may have to be updated.
  preBuild = ''
    unzip ''${GOPROXY#"file://"}/github.com/99designs/gqlgen/@v/v${gqlgenVersion}.zip
    ${generateCmds}
    rm -rf github.com
  '';
}

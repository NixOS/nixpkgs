{ unzip
, gqlgenVersion
}:
{
  overrideModAttrs = (_: {
    # No need to workaround -trimpath: it's not used in goModules,
    # but do download `go generate`'s dependencies nonetheless.
    preBuild = ''
      if [ -d ./loaders ]; then go generate ./loaders; fi
      if [ -d ./graph ]; then go generate ./graph; fi
    '';
  });

  # Workaround this error:
  #   go: git.sr.ht/~emersion/go-emailthreads@v0.0.0-20220412093310-4fd792e343ba: module lookup disabled by GOPROXY=off
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
    if [ -d ./loaders ]; then go generate ./loaders; fi
    if [ -d ./graph ]; then go generate ./graph; fi
    rm -rf github.com
  '';
}

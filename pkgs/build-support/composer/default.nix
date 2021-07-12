{ stdenv, fetchComposer }:

{ name ? "${args.pname}-${args.version}"
, src ? null
, srcs ? null
, composerHash ? "unset"
, composerHashAlgo ? "sha256"
, composerAttrs ? {}
, ...
} @ args:

let
  composerDeps = fetchComposer ({
    inherit name src srcs;
    hash = composerHash;
    hashAlgo = composerHashAlgo;
  } // composerAttrs);
in
stdenv.mkDerivation (args // {
  inherit composerDeps;

  # `vendor` directory is copied into `sourceRoot` during `postUnpack` so that it is available
  # to patch.
  postUnpack = ''
    mkdir -p $sourceRoot/vendor
    cp -r $composerDeps/* $sourceRoot/vendor

    # Respect `dontMakeSourcesWritable` variable from `unpackPhase`.
    if [ "''\${dontMakeSourcesWritable:-0}" != 1 ]; then
        chmod -R u+w -- "$sourceRoot/vendor"
    fi
  '';

  passthru = { inherit composerDeps; } // (args.passthru or {});
})

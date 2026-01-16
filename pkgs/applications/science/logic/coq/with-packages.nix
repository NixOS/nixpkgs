{
  buildEnv,
  coq,
  lib,
  makeBinaryWrapper,
  runCommand,
}:

packages:

let
  # At version 9.0, Coq underwent a name change to Rocq.
  # A couple paths and environment variables need to change at this point.
  isRocq = lib.versionAtLeast coq.coq-version "9.0";

  collectPropagated =
    pkg:
    [ pkg ]
    ++ (pkg.propagatedBuildInputs or [ ])
    ++ (lib.concatMap collectPropagated (pkg.propagatedBuildInputs or [ ]));

  allPackages = lib.unique (lib.concatMap collectPropagated packages);

  coqPath = lib.makeSearchPath "/lib/coq/${coq.coq-version}/user-contrib" allPackages;

  ocamlPath = lib.makeSearchPath "/lib/ocaml/${coq.ocaml.version}/site-lib" (
    [ coq.ocamlPackages.findlib ] ++ allPackages
  );

  pathEnvVar = if isRocq then "ROCQPATH" else "COQPATH";
in

buildEnv {
  name = "${coq.pname}-with-packages-${coq.version}";

  paths = [ coq ] ++ allPackages;

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    mkdir -p $out/bin

    # If coq is the only path that has a bin dir, buildEnv may decide to
    # symlink $out/bin directly to that. So we do this step to make sure we get a
    # writable bin dir
    mv $out/bin $out/bin-orig

    for binary in $out/bin-orig/*; do
      if [ -f "$binary" ] && [ -x "$binary" ]; then
        makeWrapper "$binary" "$out/bin/$(basename "$binary")" \
          --prefix ${pathEnvVar} : "${coqPath}" \
          --prefix OCAMLPATH : "${ocamlPath}"
      fi
    done
  '';

  passthru = coq.passthru // {
    unwrapped = coq;
    packages = allPackages;
  };

  meta = coq.meta;
}

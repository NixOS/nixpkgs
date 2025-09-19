{
  buildEnv,
  coq,
  lib,
  makeBinaryWrapper,
  runCommand,
  stdlib,
}:

packages:

let
  # At version 9.0, Coq underwent a name change to Rocq.
  # A couple paths and environment variables need to change at this point.
  isRocq = lib.versionAtLeast coq.coq-version "9.0";

  # Include stdlib by default unless it's already in the packages list
  allPackages =
    let
      hasStdlib = builtins.elem stdlib packages;
      stdlibToAdd = if (stdlib != null && !hasStdlib) then [ stdlib ] else [ ];
    in
    packages ++ stdlibToAdd;

  coqPath = lib.makeSearchPath "user-contrib" (
    map (x: "${x}/lib/coq/${coq.coq-version}") allPackages
  );

  ocamlPath = lib.makeSearchPath "site-lib" (
    map (x: "${x}/lib/ocaml/${coq.ocaml.version}") ([ coq.ocamlPackages.findlib ] ++ allPackages)
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

{ ocamlPackages }:

let
  inherit (ocamlPackages)
    buildDunePackage
    cmdliner
    dune-build-info
    odiff-core
    odiff-io
    alcotest
    ;
in
buildDunePackage {
  pname = "odiff";
  inherit (odiff-core) version src;

  buildInputs = [
    cmdliner
    dune-build-info
    odiff-core
    odiff-io
  ];

  doCheck = true;

  checkInputs = [ alcotest ];

  preCheck = ''
    mkdir -p _build/default/test
    cp -r test/test-images _build/default/test/test-images
  '';

  postInstall = ''
    mv $out/bin/ODiffBin $out/bin/odiff
  '';

  meta = odiff-core.meta // {
    mainProgram = "odiff";
  };
}

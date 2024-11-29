{ lib, buildDunePackage, reason, console, ppxlib }:

buildDunePackage {
  pname = "console_test";
  version = "1";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./console_test.opam
      ./console_test.re
      ./dune
      ./dune-project
    ];
  };

  duneVersion = "3";

  nativeBuildInputs = [
    reason
  ];

  buildInputs = [
    reason
    console
    ppxlib
  ];

  doInstallCheck = true;

  postInstallCheck = ''
    $out/bin/console_test | grep -q "{\"Hello fellow Nixer!\"}" > /dev/null
  '';
}

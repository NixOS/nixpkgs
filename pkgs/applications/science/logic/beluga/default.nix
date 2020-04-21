{ lib, fetchFromGitHub, ocamlPackages, rsync }:

ocamlPackages.buildDunePackage {
  pname = "beluga";
  version = "unstable-2020-03-11";

  src = fetchFromGitHub {
    owner  = "Beluga-lang";
    repo   = "Beluga";
    rev    = "6133b2f572219333f304bb4f77c177592324c55b";
    sha256 = "0sy6mi50z3mvs5z7dx38piydapk89all81rh038x3559b5fsk68q";
  };

  useDune2 = true;

  buildInputs = with ocamlPackages; [
    gen sedlex_2 ocaml_extlib dune-build-info linenoise
  ];

  postPatch = ''
    patchShebangs ./TEST ./run_harpoon_test.sh
  '';

  checkPhase = "./TEST";
  checkInputs = [ rsync ];
  doCheck = true;

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/beluga/
    cp -r tools/beluga-mode.el $out/share/emacs/site-lisp/beluga
  '';

  meta = with lib; {
    description = "A functional language for reasoning about formal systems";
    homepage    = "http://complogic.cs.mcgill.ca/beluga/";
    license     = licenses.gpl3Plus;
    maintainers = [ maintainers.bcdarwin ];
    platforms   = platforms.unix;
  };
}

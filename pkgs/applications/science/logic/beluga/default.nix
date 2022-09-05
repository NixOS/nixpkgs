{ lib, fetchFromGitHub, ocamlPackages, rsync }:

ocamlPackages.buildDunePackage rec {
  pname = "beluga";
  version = "1.0";

  src = fetchFromGitHub {
    owner  = "Beluga-lang";
    repo   = "Beluga";
    rev    = "v${version}";
    sha256 = "1ziqjfv8jwidl8lj2mid2shhgqhv31dfh5wad2zxjpvf6038ahsw";
  };

  useDune2 = true;

  buildInputs = with ocamlPackages; [
    gen sedlex ocaml_extlib dune-build-info linenoise
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

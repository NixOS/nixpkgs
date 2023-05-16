<<<<<<< HEAD
{ lib, fetchFromGitHub, ocamlPackages }:

ocamlPackages.buildDunePackage rec {
  pname = "beluga";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "Beluga-lang";
    repo = "Beluga";
    rev = "refs/tags/v${version}";
    hash = "sha256-0E7rmiLmQPfOAQ1qKiqxeLdqviVl+Thkl6KfOWkGZRc=";
=======
{ lib, fetchFromGitHub, ocamlPackages, rsync }:

ocamlPackages.buildDunePackage rec {
  pname = "beluga";
  version = "1.0";

  src = fetchFromGitHub {
    owner  = "Beluga-lang";
    repo   = "Beluga";
    rev    = "v${version}";
    sha256 = "1ziqjfv8jwidl8lj2mid2shhgqhv31dfh5wad2zxjpvf6038ahsw";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  duneVersion = "3";

  buildInputs = with ocamlPackages; [
<<<<<<< HEAD
    gen
    sedlex
    extlib
    dune-build-info
    linenoise
    omd
    uri
    ounit2
    yojson
  ];

=======
    gen sedlex extlib dune-build-info linenoise
  ];

  postPatch = ''
    patchShebangs ./TEST ./run_harpoon_test.sh
  '';

  checkPhase = "./TEST";
  nativeCheckInputs = [ rsync ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  doCheck = true;

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/beluga/
    cp -r tools/beluga-mode.el $out/share/emacs/site-lisp/beluga
  '';

  meta = with lib; {
    description = "A functional language for reasoning about formal systems";
<<<<<<< HEAD
    homepage = "https://complogic.cs.mcgill.ca/beluga";
    changelog = "https://github.com/Beluga-lang/Beluga/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bcdarwin ];
    platforms = platforms.unix;
=======
    homepage    = "http://complogic.cs.mcgill.ca/beluga/";
    license     = licenses.gpl3Plus;
    maintainers = [ maintainers.bcdarwin ];
    platforms   = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}

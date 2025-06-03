{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "beluga";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "Beluga-lang";
    repo = "Beluga";
    tag = "v${version}";
    hash = "sha256-QUZ3mmd0gBQ+hnAeo/TbvFsETnThAdAoQyfpz2F//4g=";
  };

  duneVersion = "3";

  buildInputs = with ocamlPackages; [
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

  doCheck = true;

  postInstall = ''
    mkdir -p $out/share/emacs/site-lisp/beluga/
    cp -r tools/beluga-mode.el $out/share/emacs/site-lisp/beluga
  '';

  meta = {
    description = "Functional language for reasoning about formal systems";
    homepage = "https://complogic.cs.mcgill.ca/beluga";
    changelog = "https://github.com/Beluga-lang/Beluga/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.bcdarwin ];
    platforms = lib.platforms.unix;
  };
}

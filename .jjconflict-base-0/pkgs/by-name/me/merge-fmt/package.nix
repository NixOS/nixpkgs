{
  lib,
  fetchurl,
  ocamlPackages,
}:

ocamlPackages.buildDunePackage rec {
  pname = "merge-fmt";
  version = "0.3";

  src = fetchurl {
    url = "https://github.com/hhugo/merge-fmt/releases/download/${version}/merge-fmt-${version}.tbz";
    hash = "sha256-F+ds0ToWcKD4NJU3yYSVW4B3m2LBnhR+4QVTDO79q14=";
  };

  minimalOCamlVersion = "4.06";
  duneVersion = "3";

  buildInputs = [
    ocamlPackages.cmdliner
    ocamlPackages.base
    ocamlPackages.stdio
  ];

  # core v0.17 compatibility, obtained by `git diff -r 3e37827~2..3e37827`
  patches = [ ./merge-fmt.patch ];

  meta = {
    description = "Git mergetool leveraging code formatters";
    homepage = "https://github.com/hhugo/merge-fmt";
    license = lib.licenses.mit;
    longDescription = ''
      `merge-fmt` is a small wrapper on top git commands to help resolve
      conflicts by leveraging code formatters.
    '';
    maintainers = [ lib.maintainers.alizter ];
    mainProgram = "merge-fmt";
  };
}

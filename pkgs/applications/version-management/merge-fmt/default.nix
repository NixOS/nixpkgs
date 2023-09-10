{ lib, fetchurl, buildDunePackage, cmdliner, base, stdio }:

buildDunePackage rec {
  pname = "merge-fmt";
  version = "0.3";

  src = fetchurl {
    url =
      "https://github.com/hhugo/merge-fmt/releases/download/${version}/merge-fmt-${version}.tbz";
    hash = "sha256-F+ds0ToWcKD4NJU3yYSVW4B3m2LBnhR+4QVTDO79q14=";
  };

  minimalOCamlVersion = "4.06";
  duneVersion = "3";

  buildInputs = [ cmdliner base stdio ];

  meta = with lib; {
    description = "Git mergetool leveraging code formatters";
    homepage = "https://github.com/hhugo/merge-fmt";
    license = licenses.mit;
    longDescription = ''
      `merge-fmt` is a small wrapper on top git commands to help resolve
      conflicts by leveraging code formatters.
    '';
    maintainers = [ maintainers.alizter ];
  };
}

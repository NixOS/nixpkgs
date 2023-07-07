{ lib
, python3
, fetchurl
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tailor";
  version = "0.9.37";

  src = fetchurl {
    url = "https://gitlab.com/ports1/tailor/-/archive/0.937/tailor-0.937.tar.gz";
    hash = "sha256-Bdf8ZCRsbCsFz1GRxyQxxndXSsm8oOL2738m9UxOTVc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    future
  ];

  # AssertionError: Tailor Darcs repository not found!
  doCheck = false;

  meta = with lib; {
    description = "A tool to migrate changesets between various kinds of version control system.";
    longDescription = ''
      With its ability to "translate the history" from one VCS kind to another,
      this tool makes it easier to keep the upstream changes merged in
      a own branch of a product.

      Tailor is able to fetch the history from Arch, Bazaar, CVS, Darcs, Monotone,
      Perforce or Subversion and rewrite it over Aegis, Bazaar, CVS, Darcs, Git,
      Mercurial, Monotone and Subversion.
    '';
    homepage = "https://gitlab.com/ports1/tailor";
    license = licenses.gpl1Plus;
    platforms = platforms.unix;
  };
}

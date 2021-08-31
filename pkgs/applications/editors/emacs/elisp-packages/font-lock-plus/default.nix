{ fetchurl, lib, trivialBuild, writeText }:

trivialBuild {
  pname = "font-lock+";
  version = "20180101.25";

  src = fetchurl {
    url = "https://www.emacswiki.org/emacs/download/font-lock%2b.el?revision=25";
    sha256 = "0197yzn4hbjmw5h3m08264b7zymw63pdafph5f3yzfm50q8p7kp4";
    name = "font-lock+.el";
  };

  meta = {
    homepage = "https://melpa.org/#/font-lock+";
    license = lib.licenses.gpl2Plus;
  };
}

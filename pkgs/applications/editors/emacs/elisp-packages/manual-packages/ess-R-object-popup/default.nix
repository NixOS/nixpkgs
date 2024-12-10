{
  trivialBuild,
  fetchFromGitHub,
  emacs,
  popup,
  ess,
}:

trivialBuild rec {
  pname = "ess-R-object-popup";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "myuhe";
    repo = "ess-R-object-popup.el";
    rev = "v${version}";
    hash = "sha256-YN8ZLXEbwTFdFfovkV2IXV9v6y/PTgCdiRQqbpRaF2E=";
  };

  packageRequires = [
    popup
    ess
  ];

  meta = {
    homepage = "https://github.com/myuhe/ess-R-object-popup.el";
    description = "Popup descriptions of R objects";
    inherit (emacs.meta) platforms;
  };
}

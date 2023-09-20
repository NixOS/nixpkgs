{ trivialBuild
, ott
, haskellPackages
}:

trivialBuild {
  pname = "ott-mode";

  inherit (ott) src version;

  postUnpack = ''
    mv $sourceRoot/emacs/ott-mode.el $sourceRoot
  '';

  meta = {
    description = "Emacs ott mode (from ott sources)";
    inherit (haskellPackages.Agda.meta) homepage license;
  };
}

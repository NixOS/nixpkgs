{ trivialBuild
, haskellPackages
}:

trivialBuild {
  pname = "agda-input";

  inherit (haskellPackages.Agda) src version;

  postUnpack = ''
    mv $sourceRoot/src/data/emacs-mode/agda-input.el $sourceRoot
  '';

  meta = {
    inherit (haskellPackages.Agda.meta) homepage license;
    description = "Standalone package providing the agda-input method without building Agda";
  };
}

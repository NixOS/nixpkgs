{ trivialBuild
, haskellPackages
}:

trivialBuild rec {
  pname = "agda-mode";
  version = pkgs.haskellPackages.Agda.version;

  dontUnpack = true;

  # already byte-compiled by Agda builder
  buildPhase = ''
    agda=`${pkgs.haskellPackages.Agda}/bin/agda-mode locate`
    cp `dirname $agda`/*.el* .
  '';

  meta = {
    inherit (pkgs.haskellPackages.Agda.meta) homepage license;
    description = "Agda2-mode for Emacs extracted from Agda package";
    longDescription = ''
      Wrapper packages that liberates init.el from `agda-mode locate` magic.
      Simply add this to user profile or systemPackages and do `(require
      'agda2)` in init.el.
    '';
  };
}


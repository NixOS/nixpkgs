{stdenv}:
stdenv.mkDerivation {
  name = "nix-prefetch-tools";
  src = "";
  srcRoot=".";
  prePhases = "undefUnpack";
  undefUnpack = ''
    unpackPhase () { :; };
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ${../fetchbzr/nix-prefetch-bzr} $out/bin
    cp ${../fetchcvs/nix-prefetch-cvs} $out/bin
    cp ${../fetchgit/nix-prefetch-git} $out/bin
    cp ${../fetchhg/nix-prefetch-hg} $out/bin
    cp ${../fetchsvn/nix-prefetch-svn} $out/bin
    chmod a+x $out/bin/*
  '';
  meta = {
    description = ''
      A package to include all the NixPkgs prefetchers
    '';
    maintainers = with stdenv.lib.maintainers; [raskin];
    platforms = with stdenv.lib.platforms; unix;
    # Quicker to build than to download, I hope
    hydraPlatforms = [];
  };
}

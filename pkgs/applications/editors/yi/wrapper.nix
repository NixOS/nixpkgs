# To use this for hacking of your Yi config file, drop into a shell
# with env attribute.
{ stdenv, makeWrapper
, haskellPackages
, extraPackages ? (s: [])
}:
let
  yiEnv = haskellPackages.ghcWithPackages
    (self: [ self.yi ] ++ extraPackages self);
in
stdenv.mkDerivation {
  pname = "yi-custom";
  version = "0.0.0.1";
  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${haskellPackages.yi}/bin/yi $out/bin/yi \
      --set NIX_GHC ${yiEnv}/bin/ghc
  '';

  # For hacking purposes
  passthru.env = yiEnv;

  meta = with stdenv.lib; {
    description = "Allows Yi to find libraries and the compiler easily";
    # This wrapper and wrapper only is under PD
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ];
  };

}

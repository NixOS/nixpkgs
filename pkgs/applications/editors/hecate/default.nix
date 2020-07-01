{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  version = "0.0.1";
  pname = "hecate";

  src = fetchFromGitHub {
    owner  = "evanmiller";
    repo   = "hecate";
    rev    = "v${version}";
    sha256 = "0ymirsd06z3qa9wi59k696mg8f4mhscw8gc5c5zkd0n3n8s0k0z8";
  };

  goPackagePath = "hecate";

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "terminal hex editor";
    longDescription = "The Hex Editor From Hell!";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}

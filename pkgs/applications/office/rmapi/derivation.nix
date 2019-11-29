{stdenv, buildGoModule}:

let
in buildGoModule rec {
  name = "rMAPI";

  goPackagePath = "github.com/juruen/rmapi";

  src = ./.;
  modSha256 = "1952wjp3d66k0dgkag0hh0zzzrv881q53n5vjj9m72008ni5pchr";

  goDeps = ./deps.nix;

  buildFlags = "--tags release";

  doCheck = true;

  meta = with stdenv.lib; {
    homepage = "https://github.com/juruen/rmapi";
    description = "rMAPI is a Go app that allows you to access the ReMarkable Cloud API programmatically";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}

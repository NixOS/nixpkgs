{
  lib,
  nix-init-unwrapped,
  nix,
  nurl,
  makeBinaryWrapper,
  symlinkJoin,
}:

symlinkJoin {
  pname = "nix-init";
  inherit (nix-init-unwrapped) version;

  nativeBuildInputs = [ makeBinaryWrapper ];
  paths = [ nix-init-unwrapped ];

  postBuild = ''
    wrapProgram $out/bin/nix-init \
      --prefix PATH : ${
        lib.makeBinPath [
          nix
          nurl
        ]
      }
  '';

  meta = {
    inherit (nix-init-unwrapped.meta)
      description
      mainProgram
      homepage
      changelog
      license
      maintainers
      ;
  };
}

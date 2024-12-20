{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  nixVersions,
  makeWrapper,
  nixosTests,
  fetchpatch,
}:

let
  rev = "77ffa33d83d2c7c6551c5e420e938e92d72fec24";
  sha256 = "sha256-MJRdVO2pt7wjOu5Hk0eVeNbk5bK5+Uo/Gh9XfO4OlMY=";
  nix = nixVersions.nix_2_24;
  inherit (nix.perl-bindings) perl;
in

stdenv.mkDerivation {
  pname = "nix-serve";
  version = "0.2-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev sha256;
  };

  patches = [
    # Part of https://github.com/edolstra/nix-serve/pull/61
    (fetchpatch {
      url = "https://github.com/edolstra/nix-serve/commit/9e434fff4486afeb3cc3f631f6dc56492b204704.patch";
      sha256 = "sha256-TxQ6q6UApTKsYIMdr/RyrkKSA3k47stV63bTbxchNTU=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm0755 nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

    makeWrapper ${
      perl.withPackages (p: [
        p.DBDSQLite
        p.Plack
        p.Starman
        nix.perl-bindings
      ])
    }/bin/starman $out/bin/nix-serve \
                --prefix PATH : "${
                  lib.makeBinPath [
                    bzip2
                    nix
                  ]
                }" \
                --add-flags $out/libexec/nix-serve/nix-serve.psgi
  '';

  /**
    The nix package that nix-serve got its nix perl bindings from.
  */
  passthru.nix = nix;

  passthru.tests = {
    nix-serve = nixosTests.nix-serve;
    nix-serve-ssh = nixosTests.nix-serve-ssh;
  };

  meta = with lib; {
    homepage = "https://github.com/edolstra/nix-serve";
    description = "Utility for sharing a Nix store as a binary cache";
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
    # See https://github.com/edolstra/nix-serve/issues/57
    broken = stdenv.hostPlatform.isDarwin;
    platforms = nix.meta.platforms;
    mainProgram = "nix-serve";
  };
}

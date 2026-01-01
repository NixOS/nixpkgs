{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  nix,
  perl,
  makeWrapper,
  nixosTests,
}:

let
  rev = "a7e046db4b29d422fc9aac60ea6b82b31399951a";
  sha256 = "sha256-6ZQ0OLijq6UtOtUqRdFC19+helhU0Av6MvGCZf6XmcQ=";
<<<<<<< HEAD
=======
  inherit (nix.libs) nix-perl-bindings;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in

stdenv.mkDerivation {
  pname = "nix-serve";
  version = "0.2-${lib.substring 0 7 rev}";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "nix-serve";
    inherit rev sha256;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    install -Dm0755 nix-serve.psgi $out/libexec/nix-serve/nix-serve.psgi

    makeWrapper ${
      perl.withPackages (p: [
        p.DBDSQLite
        p.Plack
        p.Starman
<<<<<<< HEAD
        nix.libs.nix-perl-bindings or null
=======
        nix-perl-bindings
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/edolstra/nix-serve";
    description = "Utility for sharing a Nix store as a binary cache";
    maintainers = [ lib.maintainers.eelco ];
    license = lib.licenses.lgpl21;
=======
  meta = with lib; {
    homepage = "https://github.com/edolstra/nix-serve";
    description = "Utility for sharing a Nix store as a binary cache";
    maintainers = [ maintainers.eelco ];
    license = licenses.lgpl21;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # See https://github.com/edolstra/nix-serve/issues/57
    broken = stdenv.hostPlatform.isDarwin;
    platforms = nix.meta.platforms;
    mainProgram = "nix-serve";
  };
}

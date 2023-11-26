{ lib
, stdenv
, fetchFromGitLab
, gnupg
, perl
, jetring
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jetring";
  version = "0.31";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "${finalAttrs.pname}";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-IXm0N5HAzm+o5ipULYQQo+VmQ9MbIrwZ+xRD9O6q43A=";
  };

  buildInputs = [
    gnupg
    perl
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    PROGS=(jetring-accept jetring-apply jetring-build jetring-diff
      jetring-explode jetring-gen jetring-review jetring-signindex
      jetring-checksum)

    mkdir -p $out/bin/
    mv "''${PROGS[@]}" $out/bin/

    mkdir -p $out/man/man{1,7}
    mv *.1 $out/man/man1
    mv *.7 $out/man/man7

    runHook postInstall
  '';

  meta = {
    homepage = "https://packages.debian.org/sid/jetring";
    description = "gpg keyring maintenance using changesets";
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ MakiseKurisu ];
    platforms = lib.platforms.all;
  };
})

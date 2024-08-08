{ lib
, stdenvNoCC
, fetchFromGitLab
, installShellFiles
, gnupg
, perl
, jetring
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jetring";
  version = "0.31";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "jetring";
    rev = "debian/${finalAttrs.version}";
    hash = "sha256-IXm0N5HAzm+o5ipULYQQo+VmQ9MbIrwZ+xRD9O6q43A=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

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

    installManPage *.1 *.7

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

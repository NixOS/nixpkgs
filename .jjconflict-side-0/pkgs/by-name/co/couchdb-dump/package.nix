{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  curl,
  gawk,
  gnugrep,
  gnused,
  gzip,
  sysctl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "couchdb-dump";
  version = "0-unstable-2021-07-24";

  src = fetchFromGitHub {
    owner = "danielebailo";
    repo = "couchdb-dump";
    rev = "f59fa242d34e505cb22ecb2ad1ffba0f6402978c";
    hash = "sha256-fBvbt/1ukpvcu8Aa/uAmVzw0ms8Sp35WLJPvHs9E9Bc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  patches = [ ./gsed.patch ];

  installPhase = ''
    runHook preInstall

    install -D couchdb-dump.sh $out/bin/couchdb-dump

    substituteInPlace $out/bin/couchdb-dump \
      --subst-var-by sed_cmd ${lib.getExe gnused}

    wrapProgram $out/bin/couchdb-dump --prefix PATH : ${
      lib.makeBinPath (
        [
          coreutils
          curl
          gawk
          gnugrep
          gnused
          gzip
        ]
        ++ lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) [
          sysctl
        ]
      )
    }

    runHook postInstall
  '';

  meta = {
    inherit (finalAttrs.src.meta) homepage;

    description = "Bash command line scripts to dump & restore a couchdb database";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DamienCassou ];
    mainProgram = "couchdb-dump";
  };
})

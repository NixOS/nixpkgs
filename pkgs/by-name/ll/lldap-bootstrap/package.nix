{
  curl,
  fetchFromGitHub,
  jq,
  jo,
  lib,
  lldap,
  lldap-bootstrap,
  makeWrapper,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "lldap-bootstrap";
  version = "unstable-2025-08-13";

  src = fetchFromGitHub {
    owner = "ibizaman";
    repo = "lldap";
    rev = "220c25f1abdc0c62f8ef3a41f25a3f4044094318";
    hash = "sha256-hByibduVbG+6uB0oUcgc+UzyR5WLieaRJ+61q8DCca0=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./scripts/bootstrap.sh $out/bin/lldap-bootstrap

    wrapProgram $out/bin/lldap-bootstrap \
      --set LLDAP_SET_PASSWORD_PATH ${lldap}/bin/lldap_set_password \
      --prefix PATH : ${
        lib.makeBinPath [
          curl
          jq
          jo
        ]
      }
  '';

  meta = {
    description = "Bootstrap script for LLDAP";
    homepage = "https://github.com/lldap/lldap";
    changelog = "https://github.com/lldap/lldap/blob/v${lldap-bootstrap.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bendlas
      ibizaman
    ];
    mainProgram = "lldap-bootstrap";
  };
}

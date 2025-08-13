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
let
  version = "0.6.2";
in
stdenv.mkDerivation {
  pname = "lldap-bootstrap";
  inherit version;

  src = fetchFromGitHub {
    owner = "lldap";
    repo = "lldap";
    rev = "v${version}";
    hash = "sha256-UBQWOrHika8X24tYdFfY8ETPh9zvI7/HV5j4aK8Uq+Y=";
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

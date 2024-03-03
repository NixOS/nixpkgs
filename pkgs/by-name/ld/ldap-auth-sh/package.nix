{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, curlFull
, openldap
, coreutils
, gnused
, gnugrep
}:

stdenv.mkDerivation {
  pname = "ldap-auth-sh";
  version = "unstable-2019-02-23";

  src = fetchFromGitHub {
    owner = "bob1de";
    repo = "ldap-auth-sh";
    rev = "819f9233116e68b5af5a5f45167bcbb4ed412ed4";
    hash = "sha256-+QjRP5SKUojaCv3lZX2Kv3wkaNvpWFd97phwsRlhroY=";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ldap-auth.sh $out/bin/ldap-auth
    wrapProgram $out/bin/ldap-auth \
      --prefix PATH : ${lib.makeBinPath [curlFull openldap coreutils gnused gnugrep]}

    runHook postInstallInstall
  '';

  meta = with lib; {
    description = "A simple but configurable shell script to authenticate against LDAP";
    homepage = "https://github.com/bob1de/ldap-auth-sh";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ traxys ];
    mainProgram = "ldap-auth-sh";
    platforms = platforms.all;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  perlPackages,
  shortenPerlShebang,
}:

perlPackages.buildPerlPackage rec {
  pname = "shelldap";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "mahlonsmith";
    repo = "shelldap";
    tag = "v${version}";
    hash = "sha256-67ttAXzu9pfeqjfhMfLMb9vWCXTrE+iUDCbamqswaLg=";
  };

  buildInputs = with perlPackages; [
    AlgorithmDiff
    AuthenSASL
    IOSocketSSL
    perl
    perlldap
    TermReadLineGnu
    TermShell
    TieIxHash
    YAMLSyck
  ];

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;

  prePatch = ''
    touch Makefile.PL
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin shelldap
    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    shortenPerlShebang $out/bin/shelldap
  '';

  # no make target 'test', not tests provided by source
  doCheck = false;

  outputs = [ "out" ];

  meta = {
    homepage = "https://github.com/mahlonsmith/shelldap/";
    description = "Handy shell-like interface for browsing LDAP servers and editing their content";
    changelog = "https://github.com/mahlonsmith/shelldap/blob/v${version}/CHANGELOG";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [
      clerie
      tobiasBora
    ];
    platforms = lib.platforms.unix;
    mainProgram = "shelldap";
  };
}

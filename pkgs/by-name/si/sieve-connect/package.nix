{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sieve-connect";
  version = "0.90";

  src = fetchFromGitHub {
    owner = "philpennock";
    repo = "sieve-connect";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F6Cian3jrK7SAM1omFxhI2UAfJ2rIFijWcgoF4tyG74=";
  };

  buildInputs = [ perlPackages.perl ];
  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  preBuild = ''
    # Fixes failing build when not building in git repo
    mkdir .git
    touch .git/HEAD
    echo "${finalAttrs.version}" > versionfile
    echo "$(date +%Y-%m-%d)" > datefile
  '';

  buildFlags = [
    "PERL5LIB=${perlPackages.makePerlPath [ perlPackages.FileSlurp ]}"
    "bin"
    "man"
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 sieve-connect $out/bin
    installManPage sieve-connect.1

    wrapProgram $out/bin/sieve-connect \
      --prefix PERL5LIB : "${
        with perlPackages;
        makePerlPath [
          AuthenSASL
          Socket6
          IOSocketINET6
          IOSocketSSL
          NetSSLeay
          NetDNS
          TermReadKey
          TermReadLineGnu
        ]
      }"
  '';

  meta = {
    description = "Client for the MANAGESIEVE Protocol";
    longDescription = ''
      This is sieve-connect. A client for the ManageSieve protocol,
      as specified in RFC 5804. Historically, this was MANAGESIEVE as
      implemented by timsieved in Cyrus IMAP.
    '';
    homepage = "https://github.com/philpennock/sieve-connect";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "sieve-connect";
  };
})

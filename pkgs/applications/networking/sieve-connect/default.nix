{ lib, stdenv, fetchFromGitHub, makeWrapper, perlPackages, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "sieve-connect";
  version = "0.90";

  src = fetchFromGitHub {
    owner = "philpennock";
    repo = "sieve-connect";
    rev = "v${version}";
    sha256 = "1ghvfa5ifa68b6imh85bkmy00r93c5f9hs6d039axb73gmma580p";
  };

  buildInputs = [ perlPackages.perl ];
  nativeBuildInputs = [ makeWrapper installShellFiles ];

  preBuild = ''
    # Fixes failing build when not building in git repo
    mkdir .git
    touch .git/HEAD
    echo "${version}" > versionfile
    echo "$(date +%Y-%m-%d)" > datefile
  '';

  buildFlags = [ "PERL5LIB=${perlPackages.makePerlPath [ perlPackages.FileSlurp ]}" "bin" "man" ];

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 sieve-connect $out/bin
    installManPage sieve-connect.1

    wrapProgram $out/bin/sieve-connect \
      --prefix PERL5LIB : "${with perlPackages; makePerlPath [
        AuthenSASL Socket6 IOSocketINET6 IOSocketSSL NetSSLeay NetDNS
        TermReadKey TermReadLineGnu ]}"
  '';

  meta = with lib; {
    description = "A client for the MANAGESIEVE Protocol";
    longDescription = ''
      This is sieve-connect. A client for the ManageSieve protocol,
      as specifed in RFC 5804. Historically, this was MANAGESIEVE as
      implemented by timsieved in Cyrus IMAP.
    '';
    homepage = "https://github.com/philpennock/sieve-connect";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ das_j ];
  };
}

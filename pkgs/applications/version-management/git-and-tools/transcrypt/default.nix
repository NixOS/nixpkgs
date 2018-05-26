{ stdenv, fetchFromGitHub, git, makeWrapper, openssl }:

stdenv.mkDerivation rec {
  name = "transcrypt-${version}";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "elasticdog";
    repo = "transcrypt";
    rev = "v${version}";
    sha256 = "1hvg4ipsxm27n5yn5jpk43qyvvx5gx3z3cczw1z3r6hrs4n8d5rz";
  };

  buildInputs = [ git makeWrapper openssl ];

  installPhase = ''
    install -m 755 -D transcrypt $out/bin/transcrypt
    install -m 644 -D man/transcrypt.1 $out/share/man/man1/transcrypt.1
    install -m 644 -D contrib/bash/transcrypt $out/share/bash-completion/completions/transcrypt
    install -m 644 -D contrib/zsh/_transcrypt $out/share/zsh/site-functions/_transcrypt

    wrapProgram $out/bin/transcrypt \
      --prefix PATH : "${stdenv.lib.makeBinPath [ git openssl ]}"
  '';

  meta = with stdenv.lib; {
    description = "Transparently encrypt files within a Git repository";
    longDescription = ''
      A script to configure transparent encryption of sensitive files stored in
      a Git repository. Files that you choose will be automatically encrypted
      when you commit them, and automatically decrypted when you check them
      out. The process will degrade gracefully, so even people without your
      encryption password can safely commit changes to the repository's
      non-encrypted files.
    '';
    homepage = https://github.com/elasticdog/transcrypt;
    license = licenses.mit;
    maintainers = [ maintainers.elasticdog ];
    platforms = platforms.all;
  };
}

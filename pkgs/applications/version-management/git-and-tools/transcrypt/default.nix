{ stdenv, fetchurl, git, openssl }:

stdenv.mkDerivation rec {
  name = "transcrypt-0.9.7";

  src = fetchurl {
    url = https://github.com/elasticdog/transcrypt/archive/v0.9.7.tar.gz;
    sha256 = "0pgrf74wdc7whvwz7lkkq6qfk38n37dc5668baq7czgckibvjqdh";
  };

  buildInputs = [ git openssl ];

  installPhase = ''
    install -m 755 -D transcrypt $out/bin/transcrypt
    install -m 644 -D man/transcrypt.1 $out/share/man/man1/transcrypt.1
    install -m 644 -D contrib/bash/transcrypt $out/share/bash-completion/completions/transcrypt
    install -m 644 -D contrib/zsh/_transcrypt $out/share/zsh/site-functions/_transcrypt
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

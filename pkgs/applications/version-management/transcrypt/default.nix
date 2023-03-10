{ lib, stdenv, fetchFromGitHub, git, makeWrapper, openssl, coreutils, util-linux, gnugrep, gnused, gawk }:

stdenv.mkDerivation rec {
  pname = "transcrypt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "elasticdog";
    repo = "transcrypt";
    rev = "v${version}";
    sha256 = "1dkr69plk16wllk5bzlkchrzw63pk239dgbjhrb3mb61i065jdam";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ git openssl coreutils util-linux gnugrep gnused gawk ];

  patches = [ ./helper-scripts_depspathprefix.patch ];

  installPhase = ''
    install -m 755 -D transcrypt $out/bin/transcrypt
    install -m 644 -D man/transcrypt.1 $out/share/man/man1/transcrypt.1
    install -m 644 -D contrib/bash/transcrypt $out/share/bash-completion/completions/transcrypt
    install -m 644 -D contrib/zsh/_transcrypt $out/share/zsh/site-functions/_transcrypt

    wrapProgram $out/bin/transcrypt \
      --prefix PATH : "${lib.makeBinPath [ git openssl coreutils util-linux gnugrep gnused gawk ]}"

    cat > $out/bin/transcrypt-depspathprefix << EOF
    #!${stdenv.shell}
    echo "${lib.makeBinPath [ git openssl coreutils gawk ]}:"
    EOF
    chmod +x $out/bin/transcrypt-depspathprefix
  '';

  meta = with lib; {
    description = "Transparently encrypt files within a Git repository";
    longDescription = ''
      A script to configure transparent encryption of sensitive files stored in
      a Git repository. Files that you choose will be automatically encrypted
      when you commit them, and automatically decrypted when you check them
      out. The process will degrade gracefully, so even people without your
      encryption password can safely commit changes to the repository's
      non-encrypted files.
    '';
    homepage = "https://github.com/elasticdog/transcrypt";
    license = licenses.mit;
    maintainers = [ maintainers.elasticdog ];
    platforms = platforms.all;
  };
}

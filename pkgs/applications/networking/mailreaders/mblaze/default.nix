{ coreutils, fetchFromGitHub, fetchpatch, file, gawk, gnugrep, gnused
, installShellFiles, less, lib, libiconv, makeWrapper, nano, stdenv, ruby ? null
}:

stdenv.mkDerivation rec {
  pname = "mblaze";
  version = "1.0";

  nativeBuildInputs = [ installShellFiles makeWrapper ];
  buildInputs = [ ruby ] ++ lib.optionals stdenv.isDarwin [ libiconv ];

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "mblaze";
    rev = "v${version}";
    sha256 = "0hxy3mjjv4hg856sl1r15fdmqaw4s9c26b3lidsd5x0kpqy601ai";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion contrib/_mblaze
  '' + lib.optionalString (ruby != null) ''
    install -Dt $out/bin contrib/msuck contrib/mblow

    # The following wrappings are used to preserve the executable
    # names (the value of $0 in a script). The script mcom is
    # designed to be run directly or via symlinks such as mrep. Using
    # symlinks changes the value of $0 in the script, and makes it
    # behave differently. When using the wrapProgram tool, the resulting
    # wrapper breaks this behaviour. The following wrappers preserve it.

    mkdir -p $out/wrapped
    for x in mcom mbnc mfwd mrep; do
      mv $out/bin/$x $out/wrapped
      makeWrapper $out/wrapped/$x $out/bin/$x \
        --argv0 $out/bin/$x \
        --prefix PATH : $out/bin \
        --prefix PATH : ${lib.makeBinPath [
          coreutils file gawk gnugrep gnused
        ]}
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/leahneukirchen/mblaze";
    description = "Unix utilities for processing and interacting with mail messages which are stored in maildir folders";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = [ maintainers.ajgrf ];
  };
}

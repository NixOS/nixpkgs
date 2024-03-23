{ lib, fetchFromGitHub }:
rec {
  version = "9.1.0148";

  outputs = [ "out" "xxd" ];

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    hash = "sha256-lBs9PwNE3GoxtMka9oftYx3gegjCv6D3sEyAWK6RZzM=";
  };

  enableParallelBuilding = true;
  enableParallelInstalling = false;

  hardeningDisable = [ "fortify" ];

  # Use man from $PATH; escape sequences are still problematic.
  postPatch = ''
    substituteInPlace runtime/ftplugin/man.vim \
      --replace "/usr/bin/man " "man "
  '';

  # man page moving is done in postFixup instead of postInstall otherwise fixupPhase moves it right back where it was
  postFixup = ''
    moveToOutput bin/xxd "$xxd"
    moveToOutput share/man/man1/xxd.1.gz "$xxd"
    for manFile in $out/share/man/*/man1/xxd.1*; do
      # moveToOutput does not take full paths or wildcards...
      moveToOutput "share/man/$(basename "$(dirname "$(dirname "$manFile")")")/man1/xxd.1.gz" "$xxd"
    done
  '';

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = "http://www.vim.org";
    license     = licenses.vim;
    maintainers = with maintainers; [ das_j equirosa ];
    platforms   = platforms.unix;
    mainProgram = "vim";
    outputsToInstall = [ "out" "xxd" ];
  };
}

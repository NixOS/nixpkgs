{ lib, fetchFromGitHub }:
rec {
  version = "9.1.2035";

  outputs = [
    "out"
    "xxd"
  ];

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    hash = "sha256-x7WosfqYApaY2Vv1X9+2at/A/KqfacuPy53MGtnxk9w=";
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

  meta = {
    description = "Most popular clone of the VI editor";
    homepage = "https://www.vim.org";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [
      das_j
      equirosa
      philiptaron
    ];
    platforms = lib.platforms.unix;
    mainProgram = "vim";
    outputsToInstall = [
      "out"
      "xxd"
    ];
  };
}

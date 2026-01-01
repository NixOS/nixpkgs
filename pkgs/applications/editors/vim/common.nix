{ lib, fetchFromGitHub }:
rec {
<<<<<<< HEAD
  version = "9.1.1918";
=======
  version = "9.1.1869";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  outputs = [
    "out"
    "xxd"
  ];

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-NU/A7yWcLaC+wqsfiHYVhnSZHGDao6+Oib/bSFNSVyQ=";
=======
    hash = "sha256-AHx4AHsJAsEE5LRzKgBeV3LoCaoHUB+0/gq7kOHObMk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "Most popular clone of the VI editor";
    homepage = "https://www.vim.org";
    license = lib.licenses.vim;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Most popular clone of the VI editor";
    homepage = "https://www.vim.org";
    license = licenses.vim;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      das_j
      equirosa
      philiptaron
    ];
<<<<<<< HEAD
    platforms = lib.platforms.unix;
=======
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "vim";
    outputsToInstall = [
      "out"
      "xxd"
    ];
  };
}

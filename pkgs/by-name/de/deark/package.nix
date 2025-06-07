{
  fetchFromGitHub,
  stdenv,
  lib,
  help2man,
}:
stdenv.mkDerivation rec {
  pname = "deark";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "jsummers";
    repo = "deark";
    tag = "v${version}";
    hash = "sha256-dyX41gWZnZ/07Vyxo1x4Y8neGHS5ev+YyBJ0cUH+gKY=";
  };

  nativeBuildInputs = [ help2man ];
  postBuild = ''
    make man
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 deark $out/bin/deark
    install -Dm644 deark.1 $out/share/man/man1/deark.1

    runHook postInstall
  '';

  meta = {
    description = "Utility for file format and metadata analysis, data extraction, decompression, and image format decoding";
    longDescription = "Deark is a portable command-line utility that can decode certain types of files, and either convert them to a more-modern or more-readable format, or extract embedded files from them.";
    homepage = "https://entropymine.com/deark/";
    downloadPage = "https://github.com/jsummers/deark/";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = with lib.licenses; [
      mit
      free
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ zacharyweiss ];
    mainProgram = "deark";
    platforms = lib.platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "leanify";
  version = "0.4.3-unstable-2026-06-05";

  src = fetchFromGitHub {
    owner = "JayXon";
    repo = "Leanify";
    rev = "dc557c4027fc8a7479c4a71506c75c98ea8829f9";
    hash = "sha256-jyz0F0mY4z0lFA5a1ibJKHYKb35MvuVhFct2Him/my8=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail "-flto" "" \
      --replace-fail "lib/LZMA/Alloc.o" "lib/LZMA/CpuArch.o lib/LZMA/Alloc.o" \
      --replace-quiet "-Werror" ""
  '';

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./leanify /dev/null

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp leanify $out/bin/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Lightweight lossless file minifier/optimizer";
    longDescription = ''
      Leanify is a lightweight lossless file minifier/optimizer.
      It removes unnecessary data (debug information, comments, metadata, etc.) and recompress the file to reduce file size.
      It will not reduce image quality at all.
    '';
    homepage = "https://github.com/JayXon/Leanify";
    changelog = "https://github.com/JayXon/Leanify/blob/master/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mynacol ];
    platforms = lib.platforms.all;
    mainProgram = "leanify";
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
}:

stdenv.mkDerivation {
  pname = "leanify";
  version = "unstable-2025-05-15";

  src = fetchFromGitHub {
    owner = "JayXon";
    repo = "Leanify";
    rev = "42770e600b32962e7110c24b5fcaa8c7c2144b17";
    hash = "sha256-njfMR2DSKeVh+ZUewall7837E9JY3nhrTxO4LOY1pEo=";
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

  meta = with lib; {
    description = "Lightweight lossless file minifier/optimizer";
    longDescription = ''
      Leanify is a lightweight lossless file minifier/optimizer.
      It removes unnecessary data (debug information, comments, metadata, etc.) and recompress the file to reduce file size.
      It will not reduce image quality at all.
    '';
    homepage = "https://github.com/JayXon/Leanify";
    changelog = "https://github.com/JayXon/Leanify/blob/master/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.mynacol ];
    platforms = platforms.all;
    mainProgram = "leanify";
  };
}

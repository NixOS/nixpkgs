{
  lib,
  stdenv,
  fetchFromGitHub,
  libiconv,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation {
  pname = "leanify";
<<<<<<< HEAD
  version = "0.4.3-unstable-2025-12-12";
=======
  version = "unstable-2025-05-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "JayXon";
    repo = "Leanify";
<<<<<<< HEAD
    rev = "d2ba1671056e022623e8445f5700670bc05204bf";
    hash = "sha256-MXQnJyA6z01lodes6CINV7mzbRr6GnZaMAsjloGJzeg=";
=======
    rev = "42770e600b32962e7110c24b5fcaa8c7c2144b17";
    hash = "sha256-njfMR2DSKeVh+ZUewall7837E9JY3nhrTxO4LOY1pEo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Lightweight lossless file minifier/optimizer";
    longDescription = ''
      Leanify is a lightweight lossless file minifier/optimizer.
      It removes unnecessary data (debug information, comments, metadata, etc.) and recompress the file to reduce file size.
      It will not reduce image quality at all.
    '';
    homepage = "https://github.com/JayXon/Leanify";
    changelog = "https://github.com/JayXon/Leanify/blob/master/CHANGELOG.md";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.mynacol ];
    platforms = lib.platforms.all;
=======
    license = licenses.mit;
    maintainers = [ maintainers.mynacol ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "leanify";
  };
}

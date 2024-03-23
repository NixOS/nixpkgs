{ stdenv
, lib
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "construct";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Thomas-de-Bock";
    repo = "construct";
    rev = finalAttrs.version;
    hash = "sha256-ENso0y7yEaXzGXzZOnlZ1L7+j/qayJL+f55/NYLz2ew=";
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
        --replace g++ c++
  '';

  makeTarget = "main";

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/construct -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Construct is an abstraction over x86 NASM Assembly";
    longDescription = "Construct adds features such as while loops, if statements, scoped macros and function-call syntax to NASM Assembly.";
    homepage = "https://github.com/Thomas-de-Bock/construct";
    maintainers = with maintainers; [ rucadi ];
    platforms = platforms.all;
    license = licenses.mit;
    mainProgram = "construct";
  };
})

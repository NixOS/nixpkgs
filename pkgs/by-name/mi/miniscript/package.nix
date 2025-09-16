{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "miniscript";
  version = "0-unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "sipa";
    repo = "miniscript";
    rev = "6806dfb15a1fafabf7dd28aae3c9d2bc49db01f1";
    sha256 = "sha256-qkYDzsl2Y4WEDDXs9cE/jIXm01jclkYUQbDGe1S0wYs=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Replace hardcoded g++ with c++ so clang can be used
    # on darwin
    substituteInPlace Makefile \
        --replace-fail 'g++' 'c++'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp miniscript $out/bin/miniscript
    runHook postInstall
  '';

  meta = with lib; {
    description = "Compiler and inspector for the miniscript Bitcoin policy language";
    longDescription = "Miniscript is a language for writing (a subset of) Bitcoin Scripts in a structured way, enabling analysis, composition, generic signing and more.";
    homepage = "https://bitcoin.sipa.be/miniscript/";
    license = licenses.mit;
    maintainers = with maintainers; [
      RaghavSood
      jb55
    ];
    mainProgram = "miniscript";
  };
}

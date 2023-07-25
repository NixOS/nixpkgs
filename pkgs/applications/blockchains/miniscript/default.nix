{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "miniscript";
  version = "unstable-2022-07-19";

  src = fetchFromGitHub {
    owner = "sipa";
    repo = pname;
    rev = "ca675488c4aa9605f6ae70c0e68a148a6fb277b4";
    sha256 = "sha256-kzLIJ0os6UnC0RPEybfw6wGrZpgmRCgj3zifmZjieoU=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp miniscript $out/bin/miniscript
    runHook postInstall
  '';

  meta = with lib; {
    description     = "Compiler and inspector for the miniscript Bitcoin policy language";
    longDescription = "Miniscript is a language for writing (a subset of) Bitcoin Scripts in a structured way, enabling analysis, composition, generic signing and more.";
    homepage        = "https://bitcoin.sipa.be/miniscript/";
    license         = licenses.mit;
    platforms       = platforms.linux;
    maintainers     = with maintainers; [ RaghavSood jb55 ];
  };
}

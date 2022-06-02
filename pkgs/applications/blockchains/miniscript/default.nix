{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "miniscript";
  version = "unstable-2020-12-01";

  src = fetchFromGitHub {
    owner = "sipa";
    repo = pname;
    rev = "02682a398a35b410571b10cde7f39837141ddad6";
    sha256 = "079jz4g88cfzfm9a6ykby9haxwcs033c1288mgr8cl2hw4qd2sjl";
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
    homepage        = "http://bitcoin.sipa.be/miniscript/";
    license         = licenses.mit;
    platforms       = platforms.linux;
    maintainers     = with maintainers; [ RaghavSood jb55 ];
  };
}

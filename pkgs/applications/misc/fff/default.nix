{ stdenv, lib, fetchFromGitHub, makeWrapper,
  bash, xdg_utils, file, coreutils }:

with lib;

stdenv.mkDerivation rec {
  name = "fff";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "dylanaraps";
    repo = name;
    rev = version;
    sha256 = "00yaxmhdyrf1pr82kiqgw2gszmwsw45pysm9vg77yppiq40flabv";
  };

  pathAdd = makeSearchPath "bin" [ xdg_utils file coreutils ];
  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/man/man1,share/doc/fff}
    mv ${name} $out/bin
    wrapProgram $out/bin/${name} --prefix PATH : ${pathAdd}
    mv ${name}.1 $out/share/man/man1
    mv README.md $out/share/doc/fff
  '';

  meta = with stdenv.lib; {
      description = "Fucking Fast File-Manager";
      homepage = https://github.com/dylanaraps/fff;
      license = licenses.mit;
      maintainers = [ maintainers.tadeokondrak ];
  };
}

{ lib, stdenv, fetchFromGitLab, python3 }:
stdenv.mkDerivation rec {
  pname = "pokemon-colorscripts";
  version = "2022-11-08";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "0483c85b93362637bdd0632056ff986c07f30868";
    hash = "sha256-rj0qKYHCu9SyNsj1PZn1g7arjcHuIDGHwubZg/yJt7A=";
  };

  buildInputs = [ python3 ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,etc,share/man/man1}
    mkdir $out/etc/pokemon-colorscripts
    cp pokemon-colorscripts.py $out/etc/pokemon-colorscripts/
    cp pokemon.json $out/etc/pokemon-colorscripts/
    cp -r colorscripts $out/etc/pokemon-colorscripts/
    cp pokemon-colorscripts.1 $out/share/man/man1
    # symlink the binary to bin/
    ln -s $out/etc/pokemon-colorscripts/pokemon-colorscripts.py $out/bin/pokemon-colorscripts
  '';

  meta = with lib; {
    description = "CLI utility to print out images of pokemon to terminal";
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    license = licenses.mit;
    maintainers = [ maintainers.quoorex ];
    platforms = platforms.all;
  };
}

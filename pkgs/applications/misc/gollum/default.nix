{ wrapCommand, bundlerEnv, ruby, git, lib }:

let
  pname = "gollum";
  env = bundlerEnv {
    name = "${pname}-gems";
    inherit pname ruby;
    gemdir = ./.;
  };
in wrapCommand pname {
  inherit (env.gems.gollum) version;
  executable = "${env}/bin/gollum";
  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ git ]}" ];
  meta = with lib; {
    description = "A simple, Git-powered wiki";
    homepage = https://github.com/gollum/gollum;
    license = licenses.mit;
    maintainers = with maintainers; [ jgillich primeos ];
    platforms = platforms.unix;
  };
}

{
  lib,
  bundlerApp,
}:

bundlerApp {
  pname = "3llo";

  gemdir = ./.;

  exes = [ "3llo" ];

  meta = {
    description = "Trello interactive CLI on terminal";
    license = lib.licenses.mit;
    homepage = "https://github.com/qcam/3llo";
    maintainers = [ ];
  };
}

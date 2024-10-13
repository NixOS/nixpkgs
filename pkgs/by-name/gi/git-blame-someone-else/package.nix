{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "git-blame-someone-else";
  version = "0-unstable-6-13-2018";

  src = fetchFromGitHub {
    owner = "jayphelps";
    repo = "git-blame-someone-else";
    rev = "8d854c2d78cb98afdb9f5a73240e06393260b327";
    hash = "sha256-xraG1dR5Q8oDlUXARgh0ql8eRwH4bJWblJFjH1wJcys=";
  };

  doCheck = true;

  doInstallCheck = true;

  meta = {
    description = "Blame someone else for your bad code.";
    longDescription = ''
      A simple script to spoof a git commit as someone else. Created as a joke, not recommended for production use.
    '';
    homepage = "https://github.com/jayphelps/git-blame-someone-else";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wgrav ];
    mainProgram = "git-blame-someone-else";
    platforms = lib.platforms.all;
  };
}

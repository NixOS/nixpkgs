{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  python3Packages,
  texinfo,
  perl,
  texi2html,
  autoreconfHook,
  bashInteractive,
}:
stdenv.mkDerivation {
  pname = "bashdb";
  version = "5.2-1.1.2";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "bashdb";
    rev = "1daa08b095fe2556fb25ad4191f194cb8fb03f5c";
    sha256 = "sha256-FI63KARtzV14cd77phTZ40RiYMVt0DF3JD9destQUHM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    texinfo
  ];

  buildInputs = [
    bashInteractive
    perl
    texi2html
  ];

  # NOTE: disabled because of failing tests
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/bashdb --prefix PYTHONPATH ":" "$(toPythonPath ${python3Packages.pygments})"
  '';

  meta = {
    description = "Bash script debugger";
    mainProgram = "bashdb";
    homepage = "https://github.com/rocky/bashdb";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
  };
}

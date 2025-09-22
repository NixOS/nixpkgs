{
  lib,
  stdenv,
  fetchFromSourcehut,
  port ? "1234",
}:

stdenv.mkDerivation {
  pname = "among-sus-unstable";
  version = "2021-05-19";

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "among-sus";
    rev = "554e60bf52e3fa931661b9414189a92bb8f69d78";
    hash = "sha256-HOiAwzQYxboEpwE38OxbETZLNoX77+lDLH7DzywqIUg=";
  };

  patchPhase = ''
    sed -i 's/port = 1234/port = ${port}/g' main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 among-sus $out/bin
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~martijnbraam/among-sus";
    description = "Among us, but it's a text adventure";
    mainProgram = "among-sus";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.eyjhb ];
    platforms = platforms.unix;
  };
}

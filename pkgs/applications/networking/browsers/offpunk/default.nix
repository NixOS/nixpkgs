{
  fetchFromGitea,
  less,
  lib,
  makeWrapper,
  offpunk,
  python3,
  ripgrep,
  stdenv,
  timg,
  xdg-utils,
  xsel,
}:

let
  pythonDependencies = with python3.pkgs; [
    beautifulsoup4
    cryptography
    feedparser
    pillow
    readability-lxml
    requests
    setproctitle
  ];
  otherDependencies = [
    less
    ripgrep
    timg
    xdg-utils
    xsel
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "offpunk";
  version = "1.4";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "ploum";
    repo = "offpunk";
    rev = "v${finalAttrs.version}";
    sha256 = "04dzkzsan1cnrslsvfgn1whpwald8xy34wqzvq81hd2mvw9a2n69";
  };

  buildInputs = [ makeWrapper ] ++ otherDependencies ++ pythonDependencies;

  installPhase = ''
    runHook preInstall

    install -D ./offpunk.py $out/bin/offpunk

    wrapProgram $out/bin/offpunk \
        --set PYTHONPATH "$PYTHONPATH" \
        --set PATH ${lib.makeBinPath otherDependencies}

   runHook postInstall
  '';

  meta = with lib; {
    description = "An Offline-First browser for the smolnet ";
    homepage = "https://notabug.org/ploum/offpunk";
    maintainers = with maintainers; [ DamienCassou ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
})

{
  fetchFromSourcehut,
  less,
  lib,
  makeWrapper,
  offpunk,
  python3,
  stdenv,
  testers,
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
    timg
    xdg-utils
    xsel
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "offpunk";
  version = "1.8";

  src = fetchFromSourcehut {
    owner = "~lioploum";
    repo = "offpunk";
    rev = "v${finalAttrs.version}";
    sha256 = "0xv7b3qkwyq55sz7c0v0pknrpikhzyqgr5y4y30cwa7jd8sn423f";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = otherDependencies ++ pythonDependencies;

  installPhase = ''
    runHook preInstall

    install -D ./offpunk.py $out/bin/offpunk

    wrapProgram $out/bin/offpunk \
        --set PYTHONPATH "$PYTHONPATH" \
        --set PATH ${lib.makeBinPath otherDependencies}

   runHook postInstall
  '';

  passthru.tests.version = testers.testVersion { package = offpunk; };

  meta = with lib; {
    description = "An Offline-First browser for the smolnet ";
    homepage = finalAttrs.src.meta.homepage;
    maintainers = with maintainers; [ DamienCassou ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
})

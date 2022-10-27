{
  fetchFromGitea,
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
  version = "1.6";

  src = fetchFromGitea {
    domain = "notabug.org";
    owner = "ploum";
    repo = "offpunk";
    rev = "v${finalAttrs.version}";
    sha256 = "1pfafb96xk7vis26zhfq254waz1ic9p0zdkxwpqs84p3vsmny775";
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
    homepage = "https://notabug.org/ploum/offpunk";
    maintainers = with maintainers; [ DamienCassou ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
})

{
  lib,
  python3,
  fetchFromGitHub,
  dbus,
  signal-cli,
  xclip,
  testers,
  scli,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "scli";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "isamert";
    repo = "scli";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-pp3uVABsncXXL2PZvTymHPKGAFvB24tnX+3K+C0VW8g=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pyqrcode
    urwid
    urwid-readline
  ];
  pyproject = false;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    patchShebangs scli
    install -Dm555 scli -t $out/bin
    echo "v$version" > $out/bin/VERSION

    runHook postInstall
  '';

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      dbus
      signal-cli
      xclip
    ])
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = scli;
      command = "HOME=$(mktemp -d) scli --version";
    };
  };

  meta = {
    description = "Simple terminal user interface for Signal";
    mainProgram = "scli";
    homepage = "https://github.com/isamert/scli";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})

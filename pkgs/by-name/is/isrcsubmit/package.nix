{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
  withKeyring ? true,
}:

python3Packages.buildPythonApplication {
  pname = "isrcsubmit";
  version = "2.1.0-unstable-2023-08-10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "JonnyJD";
    repo = "musicbrainz-isrcsubmit";
    rev = "8f4c3b9f9b8f983443d58fba381baaa3a74edad7";
    hash = "sha256-6SJt0wtXC49Eh6g7DBy73MeCueF7CRuCvYC27es1qAM=";
  };

  postPatch = ''
    # Change binary name to isrcsubmit so that `import isrcsubmit` in the wrapper doesn't fail
    substituteInPlace setup.py --replace-fail "'isrcsubmit.py=isrcsubmit:main'," "'isrcsubmit=isrcsubmit:main',"
    # Set default argument for main, which is set `if __name__ == '__main__'` upstream
    substituteInPlace isrcsubmit.py --replace-fail "main(argv):" "main(argv=sys.argv):"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies =
    with python3Packages;
    [
      musicbrainzngs
      discid
    ]
    ++ lib.optional withKeyring [
      keyring
    ];

  pythonImportsCheck = [ "isrcsubmit" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Script to submit ISRCs from disc to MusicBrainz";
    license = lib.licenses.gpl3Plus;
    homepage = "http://jonnyjd.github.io/musicbrainz-isrcsubmit/";
    maintainers = [ ];
    mainProgram = "isrcsubmit";
  };
}

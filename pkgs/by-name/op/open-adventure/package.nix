{
  lib,
  stdenv,
  fetchFromGitLab,
  python3Packages,
  pkg-config,
  libedit,
  cppcheck,
  coreutils,
  asciidoctor,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "open-adventure";
  version = "1.22";
  src = fetchFromGitLab {
    owner = "esr";
    repo = "open-adventure";
    tag = finalAttrs.version;
    hash = "sha256-mms4mSnJnXirnzw2UtIsnqejS2iyoNGQ5k1Ghvn2Ajc=";
  };

  nativeBuildInputs = [
    python3Packages.python
    python3Packages.pyyaml
    pkg-config
    asciidoctor
  ];

  buildInputs = [
    libedit
  ];

  doCheck = true;

  nativeCheckInputs = [
    python3Packages.pylint
    cppcheck
  ];

  postPatch = ''
    patchShebangs --build make_dungeon.py
    substituteInPlace tests/tapview --replace-fail "/bin/echo" ${lib.getExe' coreutils "echo"}
  '';

  buildFlags = [
    "advent.6"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -vp "$out/bin" "$out/share/man/man6" "$out/share/applications/" "$out/share/icons/hicolor/scalable/apps"
    install -m 555 ./advent $out/bin
    install -m 444 ./advent.6 $out/share/man/man6
    install -m 444 ./advent.desktop $out/share/applications
    install -m 444 ./advent.svg $out/share/icons/hicolor/scalable/apps

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Forward-port of the Crowther/Woods Adventure 2.5 game from 1995";
    longDescription = ''
      This code is a forward-port of the Crowther/Woods Adventure 2.5 game
      from 1995, last version in the main line of Colossal Cave Adventure
      development written by Crowther and Woods. The authors have given
      permission and encouragement to this release.
    '';
    license = lib.licenses.bsd2;
    mainProgram = "advent";
    homepage = "http://www.catb.org/~esr/open-adventure/";
    changelog = "https://gitlab.com/esr/open-adventure/-/blob/${finalAttrs.version}/NEWS.adoc";
    maintainers = with lib.maintainers; [ EmanuelM153 ];
    platforms = lib.platforms.all;
  };
})

{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutechess";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "cutechess";
    repo = "cutechess";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vhS3Eenxcq7D8E5WVON5C5hCTytcEVbYUeuCkfB0apA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
  ];
  buildInputs = [
    qt5.qtbase
  ];

  postInstall = ''
    install -Dm555 cutechess{,-cli} -t $out/bin/
    install -Dm444 libcutechess.a -t $out/lib/
    install -Dm444 $src/docs/cutechess-cli.6 -t $out/share/man/man6/
    install -Dm444 $src/docs/cutechess-engines.json.5 -t $out/share/man/man5/
  '';

  meta = {
    description = "GUI, CLI, and library for playing chess";
    homepage = "https://cutechess.com/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ iedame ];
    platforms = with lib.platforms; (linux ++ windows);
    mainProgram = "cutechess";
  };
})

{
  stdenv,
  lib,
  fetchFromGitLab,
  qt6,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cutecom";
  version = "0.60.0-RC1";

  src = fetchFromGitLab {
    owner = "cutecom";
    repo = "cutecom";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-Co0bUW7klSPf1VfBt7oT2DlQmf6CLELS0oapIyjpx8w=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/Applications" "$out/Applications"
  '';

  buildInputs = [ qt6.qtserialport ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
      ''
    else
      ''
        cd ..
        mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps,man/man1}
        cp cutecom.desktop "$out/share/applications"
        cp images/cutecom.svg "$out/share/icons/hicolor/scalable/apps"
        cp cutecom.1 "$out/share/man/man1"
      '';

  meta = {
    description = "Graphical serial terminal";
    homepage = "https://gitlab.com/cutecom/cutecom/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bennofs ];
    platforms = lib.platforms.unix;
    mainProgram = "cutecom";
  };
})

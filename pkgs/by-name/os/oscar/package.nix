{ stdenv
, fetchFromGitLab
, qt5
, libGLU
, bash
, lib
, ...
}:
stdenv.mkDerivation (final: {
  pname = "oscar";
  version = "1.5.3";

  src = fetchFromGitLab {
    owner = "pholy";
    repo = "OSCAR-code";
    rev = "${final.version}";
    sha256 = "sha256-ukd2pni4qEwWxG4lr8KUliZO/R2eziTTuSvDo8uigxQ=";
  };

  buildInputs = with qt5;
    [
      qtbase
      qttools
      qtserialport
      libGLU
    ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  nativeBuildInputs = with qt5; [
    wrapQtAppsHook
  ];

  postPatch =
    let
      lrelease = lib.getExe' (lib.getDev qt5.qttools) "lrelease";
    in
    ''
      substituteInPlace oscar/oscar.pro --replace-fail '$$LRELEASE' '${lrelease}'
      substituteInPlace oscar/oscar.pro --replace-fail /bin/bash '${lib.getExe bash}'
    '';

  buildPhase = ''
    mkdir build
    cd build
    qmake ../OSCAR_QT.pro
    make -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    mkdir -p $out/bin/
    mkdir -p $out/shared/
    cp -r oscar $out/shared/
    makeWrapper $out/shared/oscar/OSCAR $out/bin/oscar
  '';

  meta = {
    homepage = "https://www.sleepfiles.com/OSCAR/";
    description = "The Open Source CPAP Analysis Reporter";
    mainProgram = "oscar";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pcboy ];
    platforms = lib.platforms.unix;
  };
})

{
  stdenv,
  lib,
  pkg-config,
  zlib,
  fetchpatch,
  fetchurl,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chessx";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/chessx/chessx-${finalAttrs.version}.tgz";
    hash = "sha256-76YOe1WpB+vdEoEKGTHeaWJLpCVE4RoyYu1WLy3Dxhg=";
  };

  nativeBuildInputs = [
    pkg-config
  ]
  ++ (with libsForQt5; [
    qmake
    wrapQtAppsHook
  ]);

  buildInputs = [
    zlib
  ]
  ++ (with libsForQt5; [
    qtbase
    qtmultimedia
    qtsvg
    qttools
  ]);

  patches =
    # needed to backport patches to successfully build, due to broken release
    let
      repo = "https://github.com/Isarhamster/chessx/";
    in
    [
      (fetchpatch {
        url = "${repo}/commit/9797d46aa28804282bd58ce139b22492ab6881e6.diff";
        hash = "sha256-RnIf6bixvAvyp1CKuri5LhgYFqhDNiAVYWUmSUDMgVw=";
      })
      (fetchpatch {
        url = "${repo}/commit/4fab4d2f649d1cae2b54464c4e28337d1f20c214.diff";
        hash = "sha256-EJVHricN+6uabKLfn77t8c7JjO7tMmZGsj7ZyQUGcXA=";
      })
    ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 release/chessx -t "$out/bin"
    install -Dm444 unix/chessx.desktop -t "$out/share/applications"

    runHook postInstall
  '';

  meta = {
    homepage = "https://chessx.sourceforge.io/";
    description = "Browse and analyse chess games";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ luispedro ];
    platforms = lib.platforms.linux;
    mainProgram = "chessx";
  };
})

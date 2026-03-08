{
  lib,
  stdenv,
  fetchFromCodeberg,
  pkg-config,
  autoreconfHook,
  bash,
  perl,
  perlPackages,
  libhx,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hxtools";
  version = "20251011";

  src = fetchFromCodeberg {
    tag = "rel-${finalAttrs.version}";
    owner = "jengelh";
    repo = "hxtools";
    hash = "sha256-qwo8QfC1ZEvMTU7g2ZnIX3WQM+xjSPb6Y/inPI20x/g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    # Perl and Bash are pulled to make patchShebangs work.
    perl
    bash
    libhx
  ]
  ++ (with perlPackages; [ TextCSV_XS ]);

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://inai.de/projects/hxtools/";
    description = "Collection of small tools over the years by j.eng";
    # Taken from https://codeberg.org/jengelh/hxtools/src/branch/master/LICENSES.txt
    license = with lib.licenses; [
      mit
      bsd2Patent
      lgpl21Plus
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      meator
      chillcicada
    ];
    platforms = lib.platforms.all;
  };
})

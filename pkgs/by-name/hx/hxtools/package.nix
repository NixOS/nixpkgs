{
  lib,
<<<<<<< HEAD
  stdenv,
  fetchFromGitea,
  pkg-config,
  autoreconfHook,
  bash,
  perl,
  perlPackages,
  libHX,
  nix-update-script,
=======
  bash,
  fetchurl,
  libHX,
  makeWrapper,
  perl,
  perlPackages,
  stdenv,
  pkg-config,
  zstd,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hxtools";
<<<<<<< HEAD
  version = "20251011";

  src = fetchFromGitea {
    domain = "codeberg.org";
    tag = "rel-${finalAttrs.version}";
    owner = "jengelh";
    repo = "hxtools";
    hash = "sha256-qwo8QfC1ZEvMTU7g2ZnIX3WQM+xjSPb6Y/inPI20x/g=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
=======
  version = "20250309";

  src = fetchurl {
    url = "https://inai.de/files/hxtools/hxtools-${finalAttrs.version}.tar.zst";
    hash = "sha256-2ItcEiMe0GzgJ3MxZ28wjmXGSbZtc7BHpkpKIAodAwA=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    zstd
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  buildInputs = [
    # Perl and Bash are pulled to make patchShebangs work.
    perl
    bash
    libHX
<<<<<<< HEAD
  ]
  ++ (with perlPackages; [ TextCSV_XS ]);

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

=======
  ];

  postInstall = ''
    wrapProgram $out/bin/man2html \
      --prefix PERL5LIB : "${with perlPackages; makePerlPath [ TextCSV_XS ]}"
  '';

  strictDeps = true;

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
      meator
      chillcicada
    ];
=======
    maintainers = with lib.maintainers; [ meator ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.all;
  };
})

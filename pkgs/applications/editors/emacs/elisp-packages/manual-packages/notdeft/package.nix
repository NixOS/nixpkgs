{
  lib,
  stdenv,
  melpaBuild,
  fetchFromGitHub,
  hydra,
  ivy,
  pkg-config,
  tclap,
  unstableGitUpdater,
  xapian,
  # Configurable options
  # Include pre-configured hydras
  withHydra ? false,
  # Include Ivy integration
  withIvy ? false,
}:

melpaBuild {
  pname = "notdeft";
  version = "0-unstable-2025-02-04";

  src = fetchFromGitHub {
    owner = "hasu";
    repo = "notdeft";
    rev = "de2b6a7666e9e5010184966f89a04241f221afe3";
    hash = "sha256-B8aVRb8hyAKmHTTVCtDRcb2F0Rs5zhlqyfRe7IxH5jc=";
  };

  packageRequires = lib.optional withHydra hydra ++ lib.optional withIvy ivy;

  postPatch = ''
    substituteInPlace notdeft-xapian.el \
      --replace-fail 'defcustom notdeft-xapian-program nil' \
                     "defcustom notdeft-xapian-program \"$out/bin/notdeft-xapian\""
  '';

  files = ''
    (:defaults
     ${lib.optionalString withHydra ''"extras/notdeft-global-hydra.el"''}
     ${lib.optionalString withHydra ''"extras/notdeft-mode-hydra.el"''}
     ${lib.optionalString withIvy ''"extras/notdeft-ivy.el"''})
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    tclap
    xapian
  ];

  preBuild = ''
    $CXX -std=c++11 -o notdeft-xapian xapian/notdeft-xapian.cc -lxapian
  '';

  preInstall = ''
    install -D --target-directory=$out/bin notdeft-xapian
  '';

  passthru = {
    updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
  };

  meta = {
    homepage = "https://tero.hasu.is/notdeft/";
    description = "Fork of Deft that uses Xapian as a search engine";
    maintainers = [ lib.maintainers.nessdoor ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}

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
  version = "0-unstable-2021-12-04";

  src = fetchFromGitHub {
    owner = "hasu";
    repo = "notdeft";
    rev = "1b7054dcfc3547a7cafeb621552cec01d0540478";
    hash = "sha256-LMMLJFVpmoE/y3MqrgY2fmsehmzk6TkLsVoHmFUxiSw=";
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

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    tclap
    xapian
  ];

  preBuild = ''
    $CXX -std=c++11 -o notdeft-xapian xapian/notdeft-xapian.cc -lxapian
  '';

  preInstall = ''
    install -D --target-directory=$out/bin source/notdeft-xapian
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

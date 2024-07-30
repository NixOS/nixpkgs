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

let
  pname = "notdeft";
  version = "0-unstable-2021-12-04";

  src = fetchFromGitHub {
    owner = "hasu";
    repo = "notdeft";
    rev = "1b7054dcfc3547a7cafeb621552cec01d0540478";
    hash = "sha256-LMMLJFVpmoE/y3MqrgY2fmsehmzk6TkLsVoHmFUxiSw=";
  };

  # Xapian bindings for NotDeft
  notdeft-xapian = stdenv.mkDerivation {
    pname = "notdeft-xapian";
    inherit version src;

    strictDeps = true;

    nativeBuildInputs = [ pkg-config ];

    buildInputs = [
      tclap
      xapian
    ];

    buildPhase = ''
      runHook preBuild

      $CXX -std=c++11 -o notdeft-xapian xapian/notdeft-xapian.cc -lxapian

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp notdeft-xapian $out/bin

      runHook postInstall
    '';
  };
in
melpaBuild {
  inherit pname version src;

  packageRequires = lib.optional withHydra hydra ++ lib.optional withIvy ivy;

  postPatch = ''
    substituteInPlace notdeft-xapian.el \
      --replace 'defcustom notdeft-xapian-program nil' \
                "defcustom notdeft-xapian-program \"${notdeft-xapian}/bin/notdeft-xapian\""
  '';

  files = ''
    (:defaults
     ${lib.optionalString withHydra ''"extras/notdeft-global-hydra.el"''}
     ${lib.optionalString withHydra ''"extras/notdeft-mode-hydra.el"''}
     ${lib.optionalString withIvy ''"extras/notdeft-ivy.el"''})
  '';

  passthru = {
    inherit notdeft-xapian;
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

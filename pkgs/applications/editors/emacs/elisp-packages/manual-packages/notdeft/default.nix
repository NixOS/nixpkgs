{ lib
, stdenv
, trivialBuild
, fetchFromGitHub
, emacs
, hydra
, ivy
, pkg-config
, tclap
, xapian
  # Include pre-configured hydras
, withHydra ? false
  # Include Ivy integration
, withIvy ? false
}:

let
  pname = "notdeft";
  version = "20211204.0846";

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

    sourceRoot = "${src.name}/xapian";

    nativeBuildInputs = [ pkg-config tclap xapian ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      cp notdeft-xapian $out/bin

      runHook postInstall
    '';
  };
in
trivialBuild {
  inherit pname version src;
  packageRequires = lib.optional withHydra hydra
    ++ lib.optional withIvy ivy;
  buildInputs = [ xapian ];

  postPatch = ''
    substituteInPlace notdeft-xapian.el \
      --replace 'defcustom notdeft-xapian-program nil' \
                "defcustom notdeft-xapian-program \"${notdeft-xapian}/bin/notdeft-xapian\""
  '';

  # Extra modules are contained in the extras/ directory
  preBuild = lib.optionalString withHydra ''
    mv extras/notdeft-{mode-hydra,global-hydra}.el ./
  '' +
  lib.optionalString withIvy ''
    mv extras/notdeft-ivy.el ./
  '' + ''
    rm -r extras/
  '';

  meta = with lib; {
    homepage = "https://tero.hasu.is/notdeft/";
    description = "Fork of Deft that uses Xapian as a search engine";
    maintainers = [ maintainers.nessdoor ];
    platforms = platforms.linux;
  };
}

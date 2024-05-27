{ stdenv
, lib
, fetchFromGitHub
, hwdata
, gtk3
, pkg-config
, gettext
, sqlite # compile GUI
, withGUI ? false
}:

stdenv.mkDerivation rec {
  pname = "lshw";
  # Fix repology.org by not including the prefixed B, otherwise the `pname` attr
  # gets filled as `lshw-B.XX.XX` in `nix-env --query --available --attr nixpkgs.lshw --meta`
  # See https://github.com/NixOS/nix/pull/4463 for a definitive fix
  version = "02.20";

  src = fetchFromGitHub {
    owner = "lyonel";
    repo = pname;
    rev = "B.${version}";
    hash = "sha256-4etC7ymMgn1Q4f98DNASv8vn0AT55dYPdacZo6GRDw0=";
  };

  nativeBuildInputs = [ pkg-config gettext ];

  buildInputs = [ hwdata ]
    ++ lib.optionals withGUI [ gtk3 sqlite ];

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${src.rev}"
  ];

  buildFlags = [ "all" ] ++ lib.optional withGUI "gui";

  hardeningDisable = lib.optionals stdenv.hostPlatform.isStatic [ "fortify" ];

  installTargets = [ "install" ] ++ lib.optional withGUI "install-gui";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Provide detailed information on the hardware configuration of the machine";
    homepage = "https://ezix.org/project/wiki/HardwareLiSter";
    license = licenses.gpl2;
    mainProgram = "lshw";
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
  };
}

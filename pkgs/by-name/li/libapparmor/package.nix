{
  stdenv,
  lib,
  fetchFromGitLab,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  which,
  flex,
  bison,
  withPerl ?
    stdenv.hostPlatform == stdenv.buildPlatform && lib.meta.availableOn stdenv.hostPlatform perl,
  perl,
  withPython ?
    # static can't load python libraries
    !stdenv.hostPlatform.isStatic
    && lib.meta.availableOn stdenv.hostPlatform python3Packages.python
    # m4 python include script fails if cpu bit depth is different across machines
    && stdenv.hostPlatform.parsed.cpu.bits == stdenv.buildPlatform.parsed.cpu.bits,
  python3Packages,
  swig,
  ncurses,
  libxcrypt,

  # test
  dejagnu,

  # passthru
  nix-update-script,
  nixosTests,
  callPackage,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libapparmor";
  version = "4.1.2";

  src = fetchFromGitLab {
    owner = "apparmor";
    repo = "apparmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CwWNfH2Ykv4e+8ONytdM7J+aItAMVrq0yYrYzRXAe1w=";
  };
  sourceRoot = "${finalAttrs.src.name}/libraries/libapparmor";

  postPatch = ''
    substituteInPlace swig/perl/Makefile.am \
      --replace-fail install_vendor install_site
  '';

  strictDeps = true;

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    bison
    flex
    pkg-config
    swig
    ncurses
    which
    dejagnu
    perl # podchecker
  ]
  ++ lib.optionals withPython [
    python3Packages.setuptools
  ];

  nativeCheckInputs = [
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [
    libxcrypt
  ]
  ++ (lib.optional withPerl perl)
  ++ (lib.optional withPython python3Packages.python);

  # required to build apparmor-parser
  dontDisableStatic = true;

  # https://gitlab.com/apparmor/apparmor/issues/1
  configureFlags = [
    (lib.withFeature withPerl "perl")
    (lib.withFeature withPython "python")
  ];

  doCheck = withPerl && withPython;

  checkInputs = [ dejagnu ];

  pythonImportsCheck = [
    "LibAppArmor"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.apparmor;
    apparmorRulesFromClosure = callPackage ./apparmorRulesFromClosure.nix { };
  };

  meta = {
    homepage = "https://apparmor.net/";
    description = "Mandatory access control system - core library";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    maintainers = lib.teams.apparmor.members;
    platforms = lib.platforms.linux;
  };
})

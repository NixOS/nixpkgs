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
  version = "4.1.0";

  src = fetchFromGitLab {
    owner = "apparmor";
    repo = "apparmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oj6mGw/gvoRGpJqw72Lk6LJuurg8efjiV1pvZYbXz6A=";
  };
  sourceRoot = "${finalAttrs.src.name}/libraries/libapparmor";

  postPatch = ''
    substituteInPlace swig/perl/Makefile.am \
      --replace-fail install_vendor install_site
  '';

  strictDeps = true;

  nativeBuildInputs =
    [
      autoconf-archive
      autoreconfHook
      bison
      flex
      pkg-config
      swig
      ncurses
      which
      dejagnu
    ]
    ++ lib.optionals withPython [
      python3Packages.setuptools
    ]
    ++ lib.optionals (!finalAttrs.finalPackage.doCheck) [
      # TODO FIXME This is a super ugly HACK.
      # perl is required for podchecker.
      # It is a native build input on native platform because checks are enabled there.
      # Checks can't be enabled on cross, but moving perl to
      # nativeCheckInputs causes rebuilds on native compile.
      # Thus, hacks!
      # This should just be made unconditional and removed from nativeCheckInputs.
      perl
    ];

  nativeCheckInputs = [
    python3Packages.pythonImportsCheckHook
    perl
  ];

  buildInputs =
    [ libxcrypt ] ++ (lib.optional withPerl perl) ++ (lib.optional withPython python3Packages.python);

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

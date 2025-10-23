{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libedit,
  gmpxx,
  bison,
  flex,
  enableReadline ? false,
  readline,
  gtest,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensmt";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "usi-verification-and-security";
    repo = "opensmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xKpYABMn2bsXRg2PMjiMhsx6+FbAsxitLRnmqa1kmu0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  buildInputs = [
    libedit
    gmpxx
    gtest
  ]
  ++ lib.optional enableReadline readline;

  preConfigure = ''
    substituteInPlace test/CMakeLists.txt --replace-fail \
      'FetchContent_MakeAvailable' '#FetchContent_MakeAvailable'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    broken = with stdenv.hostPlatform; (isLinux && isAarch64);
    description = "Satisfiability modulo theory (SMT) solver";
    mainProgram = "opensmt";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = if enableReadline then lib.licenses.gpl2Plus else lib.licenses.mit;
    homepage = "https://github.com/usi-verification-and-security/opensmt";
  };
})

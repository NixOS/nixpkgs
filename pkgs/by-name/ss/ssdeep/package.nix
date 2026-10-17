{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ssdeep";
  version = "2.14.1";

  src = fetchFromGitHub {
    owner = "ssdeep-project";
    repo = "ssdeep";
    rev = "release-${finalAttrs.version}";
    hash = "sha256-DETU3KTh8u/ykmsBDQcVr8msvt+T1ISoLxzq96b0pvs=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # remove forbidden references to $TMPDIR
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --shrink-rpath --allowed-rpath-prefixes "$NIX_STORE" "$out"/bin/*
  '';

  meta = {
    description = "Program for calculating fuzzy hashes";
    mainProgram = "ssdeep";
    homepage = "https://ssdeep-project.github.io/ssdeep/index.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
})

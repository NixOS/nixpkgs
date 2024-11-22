{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  fetchpatch,
  pkg-config,
  libplist,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ldid-procursus";
  version = "2.1.5-procursus7";

  src = fetchFromGitHub {
    owner = "ProcursusTeam";
    repo = "ldid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QnSmWY9zCOPYAn2VHc5H+VQXjTCyr0EuosxvKGGpDtQ=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libplist
    openssl
  ];

  stripDebugFlags = [ "--strip-unneeded" ];
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  dontConfigure = true;

  patches = [
    (fetchpatch {
      name = "fix-memory-issues-with-various-entitlements.patch";
      url = "https://github.com/ProcursusTeam/ldid/commit/f38a095aa0cc721c40050cb074116c153608a11b.patch";
      hash = "sha256-D5o/E2tCbuNOv2D9UVaLEx8ZiwSB/wT0hf7XaTGzxE0=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "pkg-config" "$PKG_CONFIG"
  '';

  postInstall = ''
    installShellCompletion --cmd ldid --zsh _ldid
  '';

  meta = with lib; {
    mainProgram = "ldid";
    description = "Put real or fake signatures in a Mach-O binary";
    homepage = "https://github.com/ProcursusTeam/ldid";
    maintainers = with maintainers; [ keto ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openpam,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pam_reattach";
  version = "1.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fabianishere";
    repo = "pam_reattach";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5y/Wf8Yu4Y/AkiwRk1bxjqwrhHxUHQ7Kyo+3r3Gf58w=";
  };

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_OSX_ARCHITECTURES" stdenv.hostPlatform.darwinArch)
    (lib.cmakeBool "ENABLE_CLI" true)
  ];

  buildInputs = [ openpam ];

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/fabianishere/pam_reattach";
    description = "Reattach to the user's GUI session on macOS during authentication (for Touch ID support in tmux)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lockejan ];
    platforms = lib.platforms.darwin;
    mainProgram = "reattach-to-session-namespace";
  };
})

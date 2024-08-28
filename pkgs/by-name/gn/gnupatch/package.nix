{
  lib,
  stdenv,
  testers,
  fetchFromSavannah,
  unstableGitUpdater,
  gnulibBootstrapHook,
  bison,
  ed,
}:
let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "patch";
  version = "2.7.6-unstable-2024-08-25";

  # This used to be fetchurl from GNU mirror, but mirrors don’t have Git
  # snapshots and GNU patch had no releases in almost a decade.
  # fetchurl { url = "mirror://gnu/patch/patch-${version}.tar.xz"; hash = ""; };
  src = fetchFromSavannah {
    repo = "patch";
    rev = "abf6fb176bcd95e72ffb3ff85e6132d18cd77e75";
    hash = "sha256-eqYTvBjjFsxe2WOeFgFMKpVWFYDiyigzc4gTdhFQrfg=";
  };

  nativeBuildInputs = [
    gnulibBootstrapHook
    bison
  ];

  nativeCheckInputs = [ ed ];

  doCheck = canExecute;

  passthru.tests = lib.optionalAttrs canExecute {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  # nix develop --file maintainers/scripts/update.nix --argstr package gnupatch2
  passthru.updateScript = unstableGitUpdater {
    url = "https://git.savannah.gnu.org/git/patch.git";
    tagPrefix = "v";
  };

  meta = {
    description = "GNU Patch, a program to apply differences to files";
    mainProgram = "patch";

    longDescription = ''
      GNU Patch takes a patch file containing a difference listing
      produced by the diff program and applies those differences to one or
      more original files, producing patched versions.
    '';

    homepage = "https://savannah.gnu.org/projects/patch";

    license = lib.licenses.gpl3Plus;

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})

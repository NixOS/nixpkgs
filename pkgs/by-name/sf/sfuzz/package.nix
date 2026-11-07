{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  versionCheckHook,
  gnugrep,
  gnused,
  gzip,
  gnutar,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sfuzz";
  version = "0.7.1-unstable-2023-08-17";

  src = fetchFromGitHub {
    owner = "apconole";
    repo = "Simple-Fuzzer";
    rev = "e1b62bd8fe8950de81abb1c2606bdbe3ab037a95";
    hash = "sha256-E5DuDWTRU8CsUfvqGIt0w+MKICdUuuMn8ho0JKX399w=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gnugrep
    gnused
    gzip
    gnutar
  ];

  postPatch = ''
    sed -i 's#\(WHICH=\).*#\1${lib.getExe which}#' configure
  '';

  makeFlags = [ "PREFIX=$(out)" ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-V";
  doInstallCheck = true;

  passthru.updateScript = unstableGitUpdater { };
  preVersionCheck = ''
    export version=$(echo '${finalAttrs.version}' | cut -d- -f1)
  '';

  meta = {
    description = "A simple config-file driven block/mutation based fuzzing system";
    mainProgram = "sfuzz";
    homepage = "http://aconole.bytheb.org/projects/sfuzz";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ makefu ];
    platforms = lib.platforms.linux;
  };
})

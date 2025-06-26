{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  git,
  gnugrep,
  gnused,
  makeWrapper,
  inotify-tools,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "15af8a43cb4d8354f0b7e7c8d27e09587a9a3994";
    hash = "sha256-7sCncPxVMiDGi1PSoFhA9emSY2Jit35/FaBbinCdS/A=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
    cp -a contrib/git-* $out/bin/
  '';

  wrapperPath = lib.makeBinPath (
    [
      coreutils
      git
      gnugrep
      gnused
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
  );

  postFixup = ''
    wrap_path="${wrapperPath}":$out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : $wrap_path

    wrapProgram $out/bin/git-sync-on-inotify \
      --prefix PATH : $wrap_path
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}

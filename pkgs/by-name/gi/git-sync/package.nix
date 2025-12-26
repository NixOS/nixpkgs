{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  fswatch,
  gitMinimal,
  gnugrep,
  gnused,
  makeBinaryWrapper,
  inotify-tools,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "git-sync";
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "15af8a43cb4d8354f0b7e7c8d27e09587a9a3994";
    hash = "sha256-7sCncPxVMiDGi1PSoFhA9emSY2Jit35/FaBbinCdS/A=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;

  installPhase =
    let
      wrapperPath = lib.makeBinPath (
        [
          coreutils
          fswatch
          gitMinimal
          gnugrep
          gnused
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
      );

    in
    ''
      runHook preInstall

      for file in git-*; do
        install -D -m 755 "$file" -t $out/bin
      done

      for file in contrib/git-*; do
        install -D -m 755 "$file" -t $out/bin
      done

      wrap_path="${wrapperPath}":$out/bin

      for file in $out/bin/*; do
        wrapProgram $file \
          --prefix PATH : $wrap_path
      done

      runHook postInstall
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

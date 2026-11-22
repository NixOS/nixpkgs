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
  version = "0-unstable-2025-09-10";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "b991840c5533c010adda58015de44ba36d6bc1d0";
    hash = "sha256-Iarc5n88FpGck0BuA2SnyQZcbsIBIruzs3gFlwqMY4g=";
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
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [
      tomodachi94
      imalison
    ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,

  fzf,
  ripgrep,
  gawk,
  w3m,
  coreutils,
  parallel,

  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wikiman";
  version = "2.13.2";

  src = fetchFromGitHub {
    owner = "filiparag";
    repo = "wikiman";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-gk/9PVIRw9OQrdCSS+LcniXDYNcHUQUxZ2XGQCwpHaI=";
  };

  patches = [ ./fix-paths.patch ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  postFixup =
    let
      runtimeDependencies = [
        fzf
        ripgrep
        gawk
        w3m
        coreutils
        parallel
      ];
    in
    ''
      wrapProgram $out/bin/wikiman \
        --prefix PATH : "${lib.makeBinPath runtimeDependencies}":$out/bin \
        --set "conf_sys_usr" "$out"
    '';

  # Couldn't do a versionCheckHook since the script fails when no sources are found.
  # Even when just printing the version. Yeah.

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline search engine for manual pages, Arch Wiki, Gentoo Wiki and other documentation";
    homepage = "https://github.com/filiparag/wikiman";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "wikiman";
  };
})

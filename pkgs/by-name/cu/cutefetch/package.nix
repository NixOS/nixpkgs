{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
  bashNonInteractive,
  coreutils,
  findutils,
  gawk,
  gnugrep,
  gnused,
  ncurses,
  procps,
  wayland-utils,
  xdpyinfo,
  xprop,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cutefetch";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "cybardev";
    repo = "cutefetch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OiQNIkaDuZHsKcLGtkhkbKr7oS0VVSYfYJvOTHH5gPo=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  dontPatchShebangs = true;
  doInstallCheck = true;
  versionCheckProgramArg = "-v";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ bashNonInteractive ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  installPhase = ''
    runHook preInstall
    install -Dm555 cutefetch "$out/bin/cutefetch"
    patchShebangs --host "$out/bin/cutefetch"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/cutefetch" \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            coreutils
            findutils
            gawk
            gnugrep
            gnused
            ncurses
            procps
          ]
          ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
            wayland-utils
            xdpyinfo
            xprop
          ]
        )
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiny coloured fetch script with cute little animals";
    homepage = "https://github.com/cybardev/cutefetch";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cutefetch";
    maintainers = with lib.maintainers; [
      cybardev
      Kalitsune
    ];
  };
})

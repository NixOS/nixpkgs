{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  swift,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "macism";
  version = "3.0.10";

  src = fetchFromGitHub {
    owner = "laishulu";
    repo = "macism";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TNZoVCGbWYZHWL1hgdq9p+RrbsWLtL8FuNpf0OvN+uM=";
  };

  patches = [
    # Fix version check to work with nix build environment
    (fetchpatch2 {
      name = "fix-version-check";
      url = "https://github.com/laishulu/macism/commit/928f6f55e9cdaaf39ae5fe7ce7f803d608c68565.patch?full_index=1";
      hash = "sha256-9rh1bxpYMOKNumAthZBNluJbbH5HLI9PfM6hGzxGpjU=";
    })
  ];

  dontConfigure = true;

  nativeBuildInputs = [
    swift
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp macism $out/bin

    mkdir -p $out/Applications
    cp -r TemporaryWindow.app $out/Applications

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "Reliable CLI MacOS input source manager";
    longDescription = ''
      This tool manages macOS input sources from the command line, ideal for
      integration with vim and emacs(e.g. sis).

      macism's main advantage over other similar tools is that it can reliably
      select CJKV(Chinese/Japanese/Korean/Vietnamese) input source, while with
      other tools (such as input-source-switcher, im-select from smartim, swim),
      when you switch to CJKV input source, you will see that the input source
      icon has already changed in the menu bar, but unless you activate other
      applications and then switch back, the input source is actually still the
      same as before.
    '';
    homepage = "https://github.com/laishulu/macism";
    maintainers = with lib.maintainers; [
      yzx9
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    mainProgram = "macism";
  };
})

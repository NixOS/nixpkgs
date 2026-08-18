{
  stdenv,
  lib,
  fetchFromGitHub,
  runtimeShell,
  python3Packages,
  versionCheckHook,
  nixosTests,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "keyd";
  version = "2.6.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7yjGpicX1ly4UwF7gcOTaaHPRnxVUMwZkH70NDLL5M=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local ""

    substituteInPlace keyd.service.in \
      --replace-fail @PREFIX@ $out
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf ${lib.getExe finalAttrs.passthru.appMap} $out/bin/${finalAttrs.passthru.appMap.pname}
    rm -rf $out/etc
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.keyd = nixosTests.keyd;
    updateScript = nix-update-script { };
    appMap = python3Packages.buildPythonApplication (finalAttrsApp: {
      pname = "keyd-application-mapper";
      inherit (finalAttrs) version src;
      pyproject = false;

      postPatch = ''
        substituteInPlace scripts/${finalAttrsApp.pname} \
          --replace-fail /bin/sh ${runtimeShell}
      '';

      propagatedBuildInputs = with python3Packages; [
        python-xlib
        pygobject3.out
        dbus-python.out
      ];

      dontBuild = true;

      installPhase = ''
        install -Dm555 -t $out/bin scripts/${finalAttrsApp.pname}
      '';

      meta.mainProgram = "keyd-application-mapper";
    });
  };

  meta = {
    description = "Key remapping daemon for Linux";
    homepage = "https://github.com/rvaiya/keyd";
    changelog = "https://github.com/rvaiya/keyd/blob/master/docs/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "keyd";
    maintainers = with lib.maintainers; [ alfarel ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  versionCheckHook,
  nixosTests,
}:

let
  selectSystem =
    sources:
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "orb";
  version = "1.2.0";

  src = selectSystem {
    x86_64-linux = fetchurl {
      url = "https://pkgs.orb.net/stable/debian/pool/main/o/orb/orb_${finalAttrs.version}_amd64.deb";
      hash = "sha256-+jU8jqB1AwnEDdTOR9cD+Xh+9Rub5aBFUbc7wd9Cm6w=";
    };
    aarch64-linux = fetchurl {
      url = "https://pkgs.orb.net/stable/debian/pool/main/o/orb/orb_${finalAttrs.version}_arm64.deb";
      hash = "sha256-srpgConQS+kw0XDuJOVjvbwNtvMcfUPi9ThyX4sq3W8=";
    };
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/bin

    cp usr/bin/orb $out/bin/orb
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "version";
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru = {
    tests = nixosTests.orb;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Continous internet monitor by Ookla";
    longDescription = ''
      Orb continously monitors the quality of your internet connections,
      from any platform or device. Orb measures Responsiveness, Reliability & Speed,
      without disruption, with easy to understand scores.
    '';
    changelog = "https://orb.net/the-forge/changelog/linux_cli-${finalAttrs.version}";
    homepage = "https://orb.net";
    license = lib.licenses.unfree;
    mainProgram = "orb";
    maintainers = with lib.maintainers; [
      gepbird
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = with lib.platforms; linux; # upstream also supports darwin, open- and freebsd
  };
})

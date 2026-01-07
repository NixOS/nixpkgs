{
  stdenv,
  lib,
  fetchFromGitHub,
  systemd,
  runtimeShell,
  python3Packages,
  nixosTests,
  versionCheckHook,
}:
let
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = "keyd";
    rev = "v" + version;
    hash = "sha256-l7yjGpicX1ly4UwF7gcOTaaHPRnxVUMwZkH70NDLL5M=";
  };

  appMap = python3Packages.buildPythonApplication (finalAttrs: {
    pname = "keyd-application-mapper";
    inherit version src;
    pyproject = false;

    postPatch = ''
      substituteInPlace scripts/${finalAttrs.pname} \
        --replace-fail /bin/sh ${runtimeShell}
    '';

    propagatedBuildInputs = with python3Packages; [ xlib ];

    dontBuild = true;

    installPhase = ''
      install -Dm555 -t $out/bin scripts/${finalAttrs.pname}
    '';

    meta.mainProgram = "keyd-application-mapper";
  });

in
stdenv.mkDerivation {
  pname = "keyd";
  inherit version src;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail /usr/local ""

    substituteInPlace keyd.service.in \
      --replace-fail @PREFIX@ $out
  '';

  installFlags = [ "DESTDIR=${placeholder "out"}" ];

  buildInputs = [ systemd ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  enableParallelBuilding = true;

  postInstall = ''
    ln -sf ${lib.getExe appMap} $out/bin/${appMap.pname}
    rm -rf $out/etc
  '';

  passthru.tests.keyd = nixosTests.keyd;

  meta = {
    description = "Key remapping daemon for Linux";
    homepage = "https://github.com/rvaiya/keyd";
    license = lib.licenses.mit;
    mainProgram = "keyd";
    maintainers = with lib.maintainers; [ alfarel ];
    platforms = lib.platforms.linux;
  };
}

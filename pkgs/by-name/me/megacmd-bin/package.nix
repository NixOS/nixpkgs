{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  versionCheckHook,
  dpkg,
  gcc-unwrapped,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "megacmd";
  version = "2.4.0";

  src =
    let
      base_url = "https://mega.nz/linux/repo/xUbuntu_25.10/";
    in
    {
      x86_64-linux = fetchurl {
        url = "${base_url}/amd64/megacmd_${version}-1.1_amd64.deb";
        hash = "sha256-rcgjZHfWyCtC1JU6kdonVa2uRpXIBG6lp4XD+cKB9VE=";
      };
      aarch64-linux = fetchurl {
        url = "${base_url}/arm64/megacmd_${version}-1.1_arm64.deb";
        hash = "sha256-laNWyQpF3Xy40FLjeqY9RmUOR7ewHwlMUtGaEurJZdQ=";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  sourceRoot = "megacmd";
  unpackCmd = "dpkg -x $src ./${sourceRoot}";

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    gcc-unwrapped
    fuse
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r usr/{bin,share} $out/
    cp -r opt/megacmd/lib $out/lib

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/mega-exec";
  versionCheckProgramArg = "version";

  meta = {
    description = "MEGA Command Line Interactive and Scriptable Application";
    homepage = "https://mega.io/cmd";
    license = with lib.licenses; [
      bsd2
      gpl3Only
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      lunik1
      ulysseszhan
    ];
  };
}

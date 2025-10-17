{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
}:

let
  version = "7.01";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  # Use `./update.sh` to generate the entries below
  srcs = {
    i686-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x32-${downloadVersion}.tar.gz";
      hash = "sha256-1CSbxM7arGpn4Yj5fHEFKcDURFPrC2+XptLoaDH8LDs=";
    };
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      hash = "sha256-34iWajylsSmIOuAT6kV7c2537qWFHc+gT+JT/trWrw8=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      hash = "sha256-BjEJFzKyRpN4XL6KYW7ykQcSxqF4tYr2dCFf50JHH38=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      hash = "sha256-1ExnVDre49wWwB/BKP/L9xdYOMx8qkeZfmObJ7xm4dY=";
    };
  };
in
stdenv.mkDerivation {
  pname = "rar";
  inherit version;

  src = fetchurl (
    srcs.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}")
  );

  dontBuild = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ (lib.getLib stdenv.cc.cc) ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  installPhase = ''
    runHook preInstall

    install -Dm755 {rar,unrar} -t "$out/bin"
    install -Dm755 default.sfx -t "$out/lib"
    install -Dm644 {acknow.txt,license.txt} -t "$out/share/doc/rar"
    install -Dm644 rarfiles.lst -t "$out/etc"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    license = licenses.unfree;
    mainProgram = "rar";
    maintainers = with maintainers; [ thiagokokada ];
    platforms = lib.attrNames srcs;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

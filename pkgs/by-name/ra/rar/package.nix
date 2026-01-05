{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  perl,
}:

let
  version = "7.12";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  # Use `./update.sh` to generate the entries below
  srcs = {
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      hash = "sha256-Yw2andExNnJzZnvuB5rRA/Rp8bfNvJtCpPKDzCmTurI=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      hash = "sha256-lQeOD1n/0F6+ZlpVfp1NHAcxVqJ3fZFn9sQg7kSKg8U=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      hash = "sha256-Wzp5Izpc4usNldBEb3OZCeNyByTTJegoxbDD8HNnCPo=";
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
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  postPatch = ''
    perl -0777 -i -pe 's/ ([\w .-]+\n) ~+\n/=head1 \U$1/g' rar.txt
    perl -0777 -i -pe 's/ (Copyrights)/=head1 \U$1/g;' rar.txt
    mv rar.txt rar.1.pod
    pod2man -c "RAR User's Manual" -n "RAR" -r "rar ${version}" -s 1 rar.1.pod > rar.1
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 {rar,unrar} -t "$out/bin"
    install -Dm755 default.sfx -t "$out/lib"
    install -Dm644 {acknow.txt,license.txt} -t "$out/share/doc/rar"
    install -Dm644 rarfiles.lst -t "$out/etc"
    installManPage rar.1

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

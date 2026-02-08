{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  perl,
}:

let
  version = "7.20";
  downloadVersion = lib.replaceStrings [ "." ] [ "" ] version;
  # Use `./update.sh` to generate the entries below
  srcs = {
    x86_64-linux = {
      url = "https://www.rarlab.com/rar/rarlinux-x64-${downloadVersion}.tar.gz";
      hash = "sha256-0+f7oycjhbHQJV7jMqHowaZ3m7Wl/51NisK+hG5JykY=";
    };
    aarch64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-arm-${downloadVersion}.tar.gz";
      hash = "sha256-4ONjyPe0jw2tVN6r0dxGKjAKt0Aibp6ywJHtvS4FvUo=";
    };
    x86_64-darwin = {
      url = "https://www.rarlab.com/rar/rarmacos-x64-${downloadVersion}.tar.gz";
      hash = "sha256-LhLY9kuTswcC443a5L+wY7nHOIhZn6CqyKWqmfjXZt4=";
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

  meta = {
    description = "Utility for RAR archives";
    homepage = "https://www.rarlab.com/";
    license = lib.licenses.unfree;
    mainProgram = "rar";
    maintainers = with lib.maintainers; [ thiagokokada ];
    platforms = lib.attrNames srcs;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

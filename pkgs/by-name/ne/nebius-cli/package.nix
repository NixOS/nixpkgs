{ lib, stdenv, fetchurl, makeWrapper, installShellFiles }:

let
  version = "0.12.16";
  hash = "sha256-LaFcU8jzgDc3TVAosJMZ5JN7PhgminNURisZG5/CflY=";

  os = if stdenv.isDarwin then "darwin" else "linux";
  arch = if stdenv.isAarch64 then "arm64" else "x86_64";
  pname = "nebius-cli";

  storageBase = "https://storage.eu-north1.nebius.cloud/cli";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    urls = [ "${storageBase}/release/${version}/${os}/${arch}/nebius" ];
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  # Because this is just a downloaded binary, no unpack or build steps needed.
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 $src $out/bin/nebius

    runHook postInstall
  '';

  postInstall =
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      $out/bin/nebius completion zsh > completion.zsh
      $out/bin/nebius completion bash > completion.bash
      $out/bin/nebius completion fish > completion.fish

      installShellCompletion --cmd nebius completion.zsh completion.bash completion.fish
    '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/nebius version
  '';

  meta = with lib; {
    description = "Command-line interface for the Nebius AI Cloud Platform";
    homepage = "https://docs.nebius.com/cli";
    platforms = platforms.unix;
    # Mark as a downloaded binary
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [{
      email = "danielgafni16@gmail.com";
      name = "Daniel Gafni";
    }];
    mainProgram = "nebius";
  };
}

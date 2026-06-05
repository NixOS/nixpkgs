{ gokapi }:

gokapi.overrideAttrs (old: {
  __structuredAttrs = true;

  pname = "gokapi-cli";

  preBuild = "";

  subPackages = [
    "cmd/cli-uploader"
  ];

  postInstall = ''
    mv "$out/bin/cli-uploader" "$out/bin/gokapi-cli"
  '';

  nativeInstallCheckInputs = [ ];
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/gokapi-cli" help | grep -q "Gokapi CLI"

    runHook postInstallCheck
  '';

  meta = old.meta // {
    description = "CLI uploader and downloader for Gokapi";
    mainProgram = "gokapi-cli";
  };
})

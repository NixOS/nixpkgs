{
  lib,
  buildGoModule,
  fetchFromGitHub,
  android-tools,
}:

buildGoModule (finalAttrs: {
  pname = "fdroidcl";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Hoverth";
    repo = "fdroidcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SmPtMNHxktyhc0/izWmAzcfCXqF2BpPNJjsrqRlU1K0=";
  };

  vendorHash = "sha256-PNj5gkFj+ruxv1I4SezJxebDO2e1qGTYp3ZgekRLNt0=";

  postPatch = ''
    substituteInPlace adb/{server,device}.go \
      --replace 'exec.Command("adb"' 'exec.Command("${android-tools}/bin/adb"'
  '';

  # TestScript/search attempts to connect to fdroid
  doCheck = false;

  meta = {
    description = "F-Droid command line interface written in Go";
    mainProgram = "fdroidcl";
    homepage = "https://github.com/Hoverth/fdroidcl";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ aleksana ];
  };
})

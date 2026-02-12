{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "arduinoOTA";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "arduino";
    repo = "arduinoOTA";
    tag = finalAttrs.version;
    hash = "sha256-HaNMkeV/PDEotYp8+rUKFaBxGbZO8qA99Yp2sa6glz8=";
  };

  vendorHash = null;

  postPatch = ''
    substituteInPlace version/version.go \
      --replace 'versionString        = ""' 'versionString        = "${finalAttrs.version}"'
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/arduino/arduinoOTA";
    description = "Tool for uploading programs to Arduino boards over a network";
    mainProgram = "arduinoOTA";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ poelzi ];
    platforms = lib.platforms.all;
  };
})

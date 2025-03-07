{
  buildNpmPackage,
  lib,
  fetchurl,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "hypershell";
  version = "0.0.15";

  npmDepsHash = "sha256-WBGuJBxuOTBPOLGvO9VfTeVrA4+SMVf8LA+fBDCif1c=";

  dontNpmBuild = true;

  src = fetchFromGitHub {
    owner = "holepunchto";
    repo = "hypershell";
    rev = "v${version}";
    hash = "sha256-UWXlcY65elw+xKLte5KE5eyFLDZmEVQBSwsSpv9G7ng=";
  };

  patches = [
    # TODO: remove after this is merged: https://github.com/holepunchto/hypershell/pull/41
    (fetchurl {
      url = "https://github.com/holepunchto/hypershell/commit/a1775ee32d93bfe06b839da41d1727a575bccb3a.patch";
      hash = "sha256-xqQNXKaBN3sVWIEuzB67Ww43mQRkVQl7Div2SCMn0o0=";
    })
  ];

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/hypershell --help
  '';

  meta = {
    description = "Spawn shells anywhere. Fully peer-to-peer, authenticated, and end to end encrypted";
    homepage = "https://github.com/holepunchto/hypershell";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ davhau ];
    mainProgram = "hypershell";
    platforms = lib.platforms.all;
  };
}

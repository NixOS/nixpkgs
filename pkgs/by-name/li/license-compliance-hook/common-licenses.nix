{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  name = "common-licenses";
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = "spdx";
    repo = "license-list-data";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-0UmeSwIWEYWyGkoVqh6cKv6lx+7fjBpDanr6yo3DN0s=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/common-licenses
    for file in text/*; do
      mv $file $out/share/common-licenses/$(basename $file | sed 's/\(.*\)\..*/\1/')
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SPDX common plaintext license files";
    homepage = "https://spdx.org/licenses/";
    license = lib.licenses.publicDomain; # Computer-generated files have no license
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})

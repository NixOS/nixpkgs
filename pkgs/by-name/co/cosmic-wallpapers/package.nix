{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cosmic-wallpapers";
  version = "1.0.0-alpha.2";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-wallpapers";
    rev = "epoch-${finalAttrs.version}";
    forceFetchGit = true;
    fetchLFS = true;
    hash = "sha256-9abkb9dECE7qVq547DkpIUvaYLXLGfkRlTgLCbQtSPw=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pop-os/cosmic-wallpapers/pull/2/commits/4d17ebe69335f8ffa80fd1c48baa7f3d3efa4dbe.patch";
      hash = "sha256-4QRtX5dbN6C/ZKU3pvV7mTT7EDrMWvRCFB4004RMylM=";
    })
  ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    description = "Wallpapers for the COSMIC Desktop Environment";
    homepage = "https://system76.com/cosmic";
    license = with lib.licenses; [
      unfree # https://github.com/pop-os/cosmic-wallpapers/issues/1 https://github.com/pop-os/cosmic-wallpapers/issues/3 https://github.com/pop-os/cosmic-wallpapers/issues/4
      cc-by-40 # https://www.esa.int/ESA_Multimedia/Images/2017/06/A_stormy_stellar_nursery (A_stormy_stellar_nursery_esa_379309.jpg)
      publicDomain # https://earthobservatory.nasa.gov/image-use-policy (otherworldly_earth_nasa_ISS064-E-29444.jpg, phytoplankton_bloom_nasa_oli2_20240121.jpg); https://hubblesite.org/copyright (orion_nebula_nasa_heic0601a.jpg); https://webbtelescope.org/copyright (tarantula_nebula_nasa_PIA23646.jpg)
    ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.unix;
  };
})

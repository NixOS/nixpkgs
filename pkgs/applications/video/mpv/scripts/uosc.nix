{ lib
, fetchFromGitHub
, fetchpatch
, gitUpdater
, makeFontsConf
, buildLua
, buildGoModule
}:

buildLua (finalAttrs: {
  pname = "uosc";
  version = "5.1.1";
  scriptPath = "src/uosc";

  src = fetchFromGitHub {
    owner = "tomasklaen";
    repo = "uosc";
    rev = finalAttrs.version;
    hash = "sha256-+4k8T1yX3IRXK3XkUShsuJSH9w1Zla7CaRENcIqX4iM=";
  };
  passthru.updateScript = gitUpdater {};

  tools = buildGoModule {
    pname = "uosc-bin";
    inherit (finalAttrs) version src;
    vendorHash = "sha256-nkY0z2GiDxfNs98dpe+wZNI3dAXcuHaD/nHiZ2XnZ1Y=";
  };

  # Patch lua script to get the path to its `ziggy` binary form the environment
  patches = [
    # uosc#814: Support overriding `ziggy_path` via environment variable
    (fetchpatch {
      url = "https://github.com/tomasklaen/uosc/commit/4fdf68a1bcb510824d66f35ecc7672a6452a44b2.patch";
      hash = "sha256-igUqFf8e7LVIIjGxACdIWAeZxjF/yqaCL4QRXrzNQXk=";
    })
  ];

  # the script uses custom "texture" fonts as the background for ui elements.
  # In order for mpv to find them, we need to adjust the fontconfig search path.
  postInstall = "cp -r src/fonts $out/share";
  passthru.extraWrapperArgs = [
    "--set"
    "FONTCONFIG_FILE"
    (toString (makeFontsConf {
      fontDirectories = [ "${finalAttrs.finalPackage}/share/fonts" ];
    }))
    "--set"
    "MPV_UOSC_ZIGGY"
    (lib.getExe' finalAttrs.tools "ziggy")
  ];

  meta = with lib; {
    description = "Feature-rich minimalist proximity-based UI for MPV player";
    homepage = "https://github.com/tomasklaen/uosc";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
  };
})

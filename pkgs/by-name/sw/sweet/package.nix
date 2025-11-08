{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  gtk-engine-murrine,
  colorVariants ? [ ], # default: install all icons
}:

let
  pname = "sweet";
  colorVariantList = [
    "Sweet-Ambar-Blue-Dark-v40"
    "Sweet-Ambar-Blue-Dark"
    "Sweet-Ambar-Blue-v40"
    "Sweet-Ambar-Blue"
    "Sweet-Ambar-v40"
    "Sweet-Ambar"
    "Sweet-Dark-v40"
    "Sweet-Dark"
    "Sweet-mars-v40"
    "Sweet-mars"
    "Sweet-v40"
    "Sweet"
  ];

in
lib.checkListOfEnum "${pname}: color variants" colorVariantList colorVariants

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    inherit pname;
    version = "6.0";

    srcs = [
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-Dark-v40.tar.xz";
        hash = "sha256-LufK9MexE6YMuVniyfcNNaPfVLBMHnNmWBBNnGA2nUo=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-Dark.tar.xz";
        hash = "sha256-J0YOADP4FXKYMl/Nn70clD3h7Y5LtlTfWV9VLsWL9yo=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue-v40.tar.xz";
        hash = "sha256-HH9oZQ+F1nFhIJyP9d9W2CL+mA0bolq5GiNQtKQgrZk=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-Blue.tar.xz";
        hash = "sha256-2dcryd5Zj+Iu3R4jR++uJtyToGNoa1LtTpN1G6+kBRw=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar-v40.tar.xz";
        hash = "sha256-mpShu1fmBajl/wzlnu9zBWkskMlza5nEVS3u8Sh3b7s=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Ambar.tar.xz";
        hash = "sha256-wcbJW6MUctGSM8GW1ouLvUCmdcDHQkjTw9h0foRBgTg=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Dark-v40.tar.xz";
        hash = "sha256-aYPjnOEZMN9mPvnhK3eoCm1ybUxKPqPSoOL+kwsZsG4=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-Dark.tar.xz";
        hash = "sha256-Ej9p7/txrMhGUCyDTAEQHIS/pi92pfLrCV1L4HxWdZk=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-mars-v40.tar.xz";
        hash = "sha256-AKTNa6FHlPr1ZqlK5QYZzXRiPb5Nmzw2lTSNcWAtMAg=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-mars.tar.xz";
        hash = "sha256-bCL/DqiQGiHR24aaPtPyJKAkk8X+DyMxYeYuFJBuK6Y=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet-v40.tar.xz";
        hash = "sha256-1kHWoK9r3mRYIkizekVVYyFpWXU78BExKuNUsRB4uv4=";
      })
      (fetchurl {
        url = "https://github.com/EliverLara/Sweet/releases/download/v${finalAttrs.version}/Sweet.tar.xz";
        hash = "sha256-WzsquuUreT7b6TA6qGSYqGVrVWlIdQjlIdqWGMNJFpo=";
      })
    ];

    nativeBuildInputs = [ unzip ];

    propagatedUserEnvPkgs = [ gtk-engine-murrine ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/themes/
      cp -r ${
        lib.concatStringsSep " " (if colorVariants != [ ] then colorVariants else colorVariantList)
      } $out/share/themes/
      runHook postInstall
    '';

    meta = with lib; {
      description = "Light and dark colorful Gtk3.20+ theme";
      homepage = "https://github.com/EliverLara/Sweet";
      license = licenses.gpl3Plus;
      maintainers = with maintainers; [
        fuzen
        d3vil0p3r
      ];
      platforms = platforms.unix;
    };
  })

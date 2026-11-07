{
  lib,
  stdenvNoCC,
  testers,
  installIconsHook,
  emptyDirectory,
  nixos-icons,
}:
let
  mkTest = lib.extendMkDerivation {
    constructDrv = stdenvNoCC.mkDerivation;

    excludeDrvArgNames = [
      "name"
      "test"
    ];

    extendDrvArgs =
      finalAttrs:
      {
        name,
        test,
        nativeBuildInputs ? [ ],
        setMeta ? true,
        ...
      }:
      {
        pname = name + "-test";
        version = "none";

        __structuredAttrs = true;
        strictDeps = true;

        nativeBuildInputs = nativeBuildInputs ++ [
          installIconsHook
        ];

        doInstallCheck = true;
        installCheckPhase = test;

        meta = lib.optionalAttrs setMeta {
          mainProgram = "test";
        };
      };
  };

  withFail = testers.testBuildFailure;
  nixos-icons-list = {
    "16x16" = "share/icons/hicolor/16x16/apps/nix-snowflake.png";
    "32x32" = "share/icons/hicolor/32x32/apps/nix-snowflake.png";
    "48x48" = "share/icons/hicolor/48x48/apps/nix-snowflake.png";
    "64x64" = "share/icons/hicolor/64x64/apps/nix-snowflake.png";
    "72x72" = "share/icons/hicolor/72x72/apps/nix-snowflake.png";
    "96x96" = "share/icons/hicolor/96x96/apps/nix-snowflake.png";
    "128x128" = "share/icons/hicolor/128x128/apps/nix-snowflake.png";
    "256x256" = "share/icons/hicolor/256x256/apps/nix-snowflake.png";
    "512x512" = "share/icons/hicolor/512x512/apps/nix-snowflake.png";
    "svg" = "share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  };

  happyTest = ''
    find "$out/share/icons/hicolor/16x16/apps" -name test.png
    find "$out/share/icons/hicolor/32x32/apps" -name test.png
    find "$out/share/icons/hicolor/48x48/apps" -name test.png
    find "$out/share/icons/hicolor/64x64/apps" -name test.png
    find "$out/share/icons/hicolor/72x72/apps" -name test.png
    find "$out/share/icons/hicolor/96x96/apps" -name test.png
    find "$out/share/icons/hicolor/128x128/apps" -name test.png
    find "$out/share/icons/hicolor/256x256/apps" -name test.png
    find "$out/share/icons/hicolor/512x512/apps" -name test.png
    find "$out/share/icons/hicolor/scalable/apps" -name test.svg
  '';
in
{
  # This should all be happy-path
  disambiguation-success = mkTest {
    name = "disambiguation-success";
    src = nixos-icons;

    iconsToInstall = nixos-icons-list;

    test = happyTest;
  };

  # nixos-icons need disambiguation, so it must fail
  disambiguation-error = withFail (mkTest {
    name = "disambiguation-error";
    src = nixos-icons;
    test = "";
  });

  # If only one needs disambiguation, fail
  disam-one-unset = withFail (mkTest {
    name = "disam-one-unset";
    src = nixos-icons;

    iconsToInstall = removeAttrs nixos-icons-list [ "96x96" ];

    test = "";
  });

  # Fail if no mainProgram is set
  no-main = withFail (mkTest {
    name = "no-main";
    src = nixos-icons;
    setMeta = false;
    test = happyTest;
  });

  # If meta.mainProgram is unset, but iconInstallName is, don't fail
  with-icon-name = mkTest {
    name = "with-icon-name";
    src = nixos-icons;
    setMeta = false;

    iconsToInstall = nixos-icons-list;

    installIconName = "test2";

    test = lib.replaceStrings [ "test.png" ] [ "test2.png" ] happyTest;
  };

  # If there are no icons to install, don't fail
  no-icons = mkTest {
    name = "no-icons";
    src = emptyDirectory;
    test = ''
      touch "$out"
    '';
  };

  # Test adding some extra icons
  extra-icons = mkTest {
    name = "extra-icons";

    src = nixos-icons;

    iconsToInstall = nixos-icons-list;

    extraIconsToInstall = {
      png = "share/icons/hicolor/16x16/apps/nix-snowflake.png";
      svg = "share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    };

    test = happyTest + ''
      if [[ -f "$out/share/icons/test.png" ]]; then
        echo "png success"
      else
        echo "png fail"
        ls -alR "$out"
        exit 1
      fi

      if [[ -f "$out/share/icons/test.svg" ]]; then
        echo "svg success"
      else
        echo "svg fail"
        ls -alR "$out"
        exit 1
      fi
    '';
  };

  # Test adding some extra icons
  extra-icons-one = mkTest {
    name = "extra-icons-one";

    src = nixos-icons;

    iconsToInstall = nixos-icons-list;

    extraIconsToInstall.svg = "share/icons/hicolor/scalable/apps/nix-snowflake.svg";

    test = happyTest + ''
      if [[ -f "$out/share/icons/test.svg" ]]; then
        echo "svg success"
      else
        echo "svg fail"
        ls -alR "$out"
        exit 1
      fi
    '';
  };
}

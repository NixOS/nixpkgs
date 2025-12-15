{
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  fetchurl,
  lib,
  makeDesktopItem,
  makeWrapper,
  stdenvNoCC,
  unzip,
  buildType ? "stable",
  commandLineArgs ? "",
}:
let
  hostPlatform = stdenvNoCC.hostPlatform;
  nodePlatform = hostPlatform.node.platform;
  nodeArch = hostPlatform.node.arch;
in
stdenvNoCC.mkDerivation (
  finalAttrs:
  (
    {
      # https://github.com/toeverything/AFFiNE/releases/tag/v0.18.1
      version = "0.18.1";
      githubSourceCode = fetchFromGitHub {
        owner = "toeverything";
        repo = "AFFiNE";
        rev = "8b066a4b398aace25a20508a8e3c1a381721971f";
        hash = "sha256-TWwojG3lqQlQFX3BKoFjJ27a3T/SawXgNDO6fP6gW4k=";
      };
      productName = if buildType == "stable" then "AFFiNE" else "AFFiNE-" + buildType;
      binName = lib.toLower finalAttrs.productName;
      pname = "${finalAttrs.binName}-bin";
      meta = {
        description = "Workspace with fully merged docs, whiteboards and databases";
        longDescription = ''
          AFFiNE is an open-source, all-in-one workspace and an operating
          system for all the building blocks that assemble your knowledge
          base and much more -- wiki, knowledge management, presentation
          and digital assets
        '';
        homepage = "https://affine.pro/";
        license = lib.licenses.mit;
        maintainers = with lib.maintainers; [
          richar
          redyf
          xiaoxiangmoe
        ];
        platforms = [
          "aarch64-darwin"
          "x86_64-darwin"
          "x86_64-linux"
        ];
        sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
      }
      // lib.optionalAttrs hostPlatform.isLinux {
        mainProgram = finalAttrs.binName;
      };

      src = (
        let
          inherit (finalAttrs) version;
          affinePrebuiltBinariesHashes = {
            darwin-arm64 = "I8lOO97MNLkha0utWPAP4EKv9HiPMWpLi2ibvXjzjhdl7abgSPmMKbv1dGHxMzgMzGbDzhzKqzhYtJI+0Asfzw==";
            darwin-x64 = "LZdd7yHJx9Hx0Po8NQgeDp0BhIyXGr0QsbF6bWP5pS08c4fdtE9UzNPfJGfzz/snTkWfKMQZop0Ea4fYGosr1Q==";
            linux-x64 = "+impaFLuvcfpj4QjHwjZ06+fUpsxxRlk4eWO6+E4xkBMrV43gwZGeSeAw2pMgXogRGb/Oy6XUoA7o8tTQt9J6A==";
          };
          platform = if hostPlatform.isLinux then "linux" else "macos";
        in
        fetchurl {
          # example: https://github.com/toeverything/AFFiNE/releases/download/v0.18.1/affine-0.18.1-stable-darwin-arm64.zip
          url = "https://github.com/toeverything/AFFiNE/releases/download/v${version}/affine-${version}-${buildType}-${platform}-${nodeArch}.zip";
          sha512 = affinePrebuiltBinariesHashes."${nodePlatform}-${nodeArch}";
        }
      );

      nativeBuildInputs = [
        unzip
      ]
      ++ lib.optionals hostPlatform.isLinux [
        copyDesktopItems
        makeWrapper
      ];

      installPhase =
        let
          inherit (finalAttrs) binName productName;
        in
        if hostPlatform.isDarwin then
          ''
            runHook preInstall

            mkdir -p $out/Applications
            cd ..
            mv ${productName}.app $out/Applications

            runHook postInstall
          ''
        else
          ''
            runHook preInstall

            mkdir --parents $out/lib/${binName}/
            mv ./{resources,LICENSE*} $out/lib/${binName}/
            install -Dm644 "${finalAttrs.githubSourceCode}/packages/frontend/apps/electron/resources/icons/icon_${buildType}_64x64.png" $out/share/icons/hicolor/64x64/apps/${binName}.png

            makeWrapper "${electron}/bin/electron" $out/bin/${binName} \
              --inherit-argv0 \
              --add-flags $out/lib/${binName}/resources/app.asar \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
              --add-flags ${lib.escapeShellArg commandLineArgs}

            runHook postInstall
          '';
    }
    // lib.optionalAttrs hostPlatform.isLinux {
      desktopItems =
        let
          inherit (finalAttrs) binName productName;
        in
        [
          (makeDesktopItem {
            name = binName;
            desktopName = productName;
            comment = "AFFiNE Desktop App";
            exec = "${binName} %U";
            terminal = false;
            icon = binName;
            startupWMClass = binName;
            categories = [ "Utility" ];
            mimeTypes = [ "x-scheme-handler/${binName}" ];
          })
        ];
    }
  )
)

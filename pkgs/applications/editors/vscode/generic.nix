{
  stdenv,
  lib,
  coreutils,
  gnugrep,
  copyDesktopItems,
  makeDesktopItem,
  unzip,
  libsecret,
  libXScrnSaver,
  libxshmfence,
  buildPackages,
  at-spi2-atk,
  autoPatchelfHook,
  alsa-lib,
  libgbm,
  nss,
  nspr,
  xorg,
  systemdLibs,
  fontconfig,
  libdbusmenu,
  glib,
  buildFHSEnv,
  wayland,
  libglvnd,
  libkrb5,
  openssl,

  # Populate passthru.tests
  tests,

  # needed to fix "Save as Root"
  asar,
  bash,

  # Attributes inherit from specific versions
  version,
  vscodeVersion ? version,
  src,
  meta,
  sourceRoot,
  commandLineArgs,
  executableName,
  longName,
  shortName,
  pname,
  libraryName ? "vscode",
  iconName ? "vs${executableName}",
  updateScript,
  dontFixup ? false,
  rev ? null,
  vscodeServer ? null,
  sourceExecutableName ? executableName,
  useVSCodeRipgrep ? false,
  ripgrep,
  hasVsceSign ? false,
  patchVSCodePath ? true,
}:

stdenv.mkDerivation (
  finalAttrs:
  let

    # Vscode and variants allow for users to download and use extensions
    # which often include the usage of pre-built binaries.
    # This has been an on-going painpoint for many users, as
    # a full extension update cycle has to be done through nixpkgs
    # in order to create or update extensions.
    # See: #83288 #91179 #73810 #41189
    #
    # buildFHSEnv allows for users to use the existing vscode
    # extension tooling without significant pain.
    fhs =
      {
        additionalPkgs ? pkgs: [ ],
      }:
      buildFHSEnv {
        # also determines the name of the wrapped command
        pname = executableName;
        inherit version;

        # additional libraries which are commonly needed for extensions
        targetPkgs =
          pkgs:
          (with pkgs; [
            # ld-linux-x86-64-linux.so.2 and others
            glibc

            # dotnet
            curl
            icu
            libunwind
            libuuid
            lttng-ust
            openssl
            zlib

            # mono
            krb5

            # Needed for headless browser-in-vscode based plugins such as
            # anything based on Puppeteer https://pptr.dev .
            # e.g. Roo Code
            glib
            nspr
            nss
            dbus
            at-spi2-atk
            cups
            expat
            libxkbcommon
            xorg.libX11
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libxcb
            xorg.libXext
            xorg.libXfixes
            xorg.libXrandr
            cairo
            pango
            alsa-lib
            libgbm
            udev
            libudev0-shim
          ])
          ++ additionalPkgs pkgs;

        extraBwrapArgs = [
          "--bind-try /etc/nixos/ /etc/nixos/"
          "--ro-bind-try /etc/xdg/ /etc/xdg/"
        ];

        # symlink shared assets, including icons and desktop entries
        extraInstallCommands = ''
          ln -s "${finalAttrs.finalPackage}/share" "$out/"
        '';

        runScript = "${finalAttrs.finalPackage}/bin/${executableName}";

        # vscode likes to kill the parent so that the
        # gui application isn't attached to the terminal session
        dieWithParent = false;

        passthru = {
          inherit executableName;
          inherit (finalAttrs.finalPackage) pname version; # for home-manager module
        };

        meta = meta // {
          description = "Wrapped variant of ${pname} which launches in a FHS compatible environment, should allow for easy usage of extensions without nix-specific modifications";
        };
      };
  in
  {

    inherit
      pname
      version
      src
      sourceRoot
      dontFixup
      ;

    passthru = {
      inherit
        executableName
        longName
        tests
        updateScript
        vscodeVersion
        ;
      fhs = fhs { };
      fhsWithPackages = f: fhs { additionalPkgs = f; };
    }
    // lib.optionalAttrs (vscodeServer != null) {
      inherit rev vscodeServer;
    };

    desktopItems = [
      (makeDesktopItem {
        name = executableName;
        desktopName = longName;
        comment = "Code Editing. Redefined.";
        genericName = "Text Editor";
        exec = "${executableName} %F";
        icon = iconName;
        startupNotify = true;
        startupWMClass = shortName;
        categories = [
          "Utility"
          "TextEditor"
          "Development"
          "IDE"
        ];
        keywords = [ "vscode" ];
        actions.new-empty-window = {
          name = "New Empty Window";
          exec = "${executableName} --new-window %F";
          icon = iconName;
        };
      })
      (makeDesktopItem {
        name = executableName + "-url-handler";
        desktopName = longName + " - URL Handler";
        comment = "Code Editing. Redefined.";
        genericName = "Text Editor";
        exec = executableName + " --open-url %U";
        icon = iconName;
        startupNotify = true;
        startupWMClass = shortName;
        categories = [
          "Utility"
          "TextEditor"
          "Development"
          "IDE"
        ];
        mimeTypes = [ "x-scheme-handler/${iconName}" ];
        keywords = [ "vscode" ];
        noDisplay = true;
      })
    ];

    buildInputs = [
      libsecret
      libXScrnSaver
      libxshmfence
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      alsa-lib
      at-spi2-atk
      libkrb5
      libgbm
      nss
      nspr
      systemdLibs
      xorg.libxkbfile
    ];

    runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
      systemdLibs
      fontconfig.lib
      libdbusmenu
      wayland
      libsecret
    ];

    nativeBuildInputs = [
      unzip
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      autoPatchelfHook
      asar
      copyDesktopItems
      # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
      # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
      (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
    ];

    dontBuild = true;
    dontConfigure = true;
    noDumpEnvVars = true;

    stripExclude = lib.optional hasVsceSign [
      # vsce-sign is a single executable application built with Node.js, and it becomes non-functional if stripped
      "lib/vscode/resources/app/node_modules/@vscode/vsce-sign/bin/vsce-sign"
    ];

    installPhase = ''
      runHook preInstall
    ''
    + (
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p "$out/Applications/${longName}.app" "$out/bin"
          cp -r ./* "$out/Applications/${longName}.app"
          ln -s "$out/Applications/${longName}.app/Contents/Resources/app/bin/${sourceExecutableName}" "$out/bin/${executableName}"
        ''
      else
        (
          ''
            mkdir -p "$out/lib/${libraryName}" "$out/bin"
            cp -r ./* "$out/lib/${libraryName}"

            ln -s "$out/lib/${libraryName}/bin/${sourceExecutableName}" "$out/bin/${executableName}"
          ''
          # These are named vscode.png, vscode-insiders.png, etc to match the name in upstream *.deb packages.
          + ''
            mkdir -p "$out/share/pixmaps"
            cp "$out/lib/${libraryName}/resources/app/resources/linux/code.png" "$out/share/pixmaps/${iconName}.png"
          ''
        )
        # Override the previously determined VSCODE_PATH with the one we know to be correct
        + (lib.optionalString patchVSCodePath ''
          sed -i "/ELECTRON=/iVSCODE_PATH='$out/lib/${libraryName}'" "$out/bin/${executableName}"
          grep -q "VSCODE_PATH='$out/lib/${libraryName}'" "$out/bin/${executableName}" # check if sed succeeded
        '')
        # Remove native encryption code, as it derives the key from the executable path which does not work for us.
        # The credentials should be stored in a secure keychain already, so the benefit of this is questionable
        # in the first place.
        + ''
          rm -rf $out/lib/${libraryName}/resources/app/node_modules/vscode-encrypt
        ''
    )
    + ''
      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(
          ${
            # we cannot use runtimeDependencies otherwise libdbusmenu do not work on kde
            lib.optionalString stdenv.hostPlatform.isLinux
              "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libdbusmenu ]}"
          }
        --prefix PATH : ${
          lib.makeBinPath [
            # for moving files to trash
            glib

            # for launcher script
            gnugrep
            coreutils
          ]
        }
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}"
        --add-flags ${lib.escapeShellArg commandLineArgs}
      )
    '';

    # See https://github.com/NixOS/nixpkgs/issues/49643#issuecomment-873853897
    # linux only because of https://github.com/NixOS/nixpkgs/issues/138729
    postPatch =
      # this is a fix for "save as root" functionality
      lib.optionalString stdenv.hostPlatform.isLinux (
        ''
          packed="resources/app/node_modules.asar"
          unpacked="resources/app/node_modules"
          asar extract "$packed" "$unpacked"
          substituteInPlace $unpacked/@vscode/sudo-prompt/index.js \
            --replace-fail "/usr/bin/pkexec" "/run/wrappers/bin/pkexec" \
            --replace-fail "/bin/bash" "${bash}/bin/bash"
          rm -rf "$packed"
        ''
        # without this symlink loading JsChardet, the library that is used for auto encoding detection when files.autoGuessEncoding is true,
        # fails to load with: electron/js2c/renderer_init: Error: Cannot find module 'jschardet'
        # and the window immediately closes which renders VSCode unusable
        # see https://github.com/NixOS/nixpkgs/issues/152939 for full log
        + ''
          ln -rs "$unpacked" "$packed"
        ''
      )
      + (
        let
          vscodeRipgrep =
            if stdenv.hostPlatform.isDarwin then
              if lib.versionAtLeast vscodeVersion "1.94.0" then
                "Contents/Resources/app/node_modules/@vscode/ripgrep/bin/rg"
              else
                "Contents/Resources/app/node_modules.asar.unpacked/@vscode/ripgrep/bin/rg"
            else
              "resources/app/node_modules/@vscode/ripgrep/bin/rg";
        in
        if !useVSCodeRipgrep then
          ''
            rm ${vscodeRipgrep}
            ln -s ${ripgrep}/bin/rg ${vscodeRipgrep}
          ''
        else
          ''
            chmod +x ${vscodeRipgrep}
          ''
      );

    postFixup = lib.optionalString stdenv.hostPlatform.isLinux (
      ''
        patchelf \
          --add-needed ${libglvnd}/lib/libGLESv2.so.2 \
          --add-needed ${libglvnd}/lib/libGL.so.1 \
          --add-needed ${libglvnd}/lib/libEGL.so.1 \
          $out/lib/${libraryName}/${executableName}
      ''
      + (lib.optionalString hasVsceSign ''
        patchelf \
          --add-needed ${lib.getLib openssl}/lib/libssl.so \
          $out/lib/vscode/resources/app/node_modules/@vscode/vsce-sign/bin/vsce-sign
      '')
    );

    inherit meta;
  }
)

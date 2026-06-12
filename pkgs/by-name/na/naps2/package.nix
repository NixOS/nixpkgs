{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  runCommand,
  symlinkJoin,
  writeText,
  wrapGAppsHook3,
  makeBinaryWrapper,
  gtk3,
  gdk-pixbuf,
  glib,
  at-spi2-core,
  cairo,
  pango,
  sane-backends,
  libnotify,
  libtiff,
  apple-sdk_15,
  cctools,
  darwin,
  zlib,
  libiconv,
}:

let
  inherit (stdenv.hostPlatform) isDarwin;
  sdk = dotnetCorePackages.sdk_9_0;

  gtkLibs = [
    gtk3
    gdk-pixbuf
    glib
    at-spi2-core
    cairo
    pango
  ];
in

buildDotnetModule (finalAttrs: {
  pname = "naps2";
  version = "8.2.1";

  src = fetchFromGitHub {
    owner = "cyanfish";
    repo = "naps2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1OPFWmy9eDRnMJjYdzYubgfde7MNix8ZsSuN2ZHsvco=";
  };

  passthru = {
    # The unwrapped SDK overlaid with the macos workload, equivalent to what
    # `dotnet workload install macos` produces in a writable SDK installation.
    sdkWithMacosWorkload =
      let
        # Fetch-deps does not know about workloads, so re-add
        # these entries when regenerating deps.json.
        workloadPackEntries = builtins.filter (
          pack:
          lib.hasPrefix "Microsoft.macOS." pack.pname || lib.hasPrefix "Microsoft.NET.Runtime." pack.pname
        ) (lib.importJSON ./deps.json);

        # Workload install records live under the SDK feature band (9.0.313 -> 9.0.300).
        featureBand =
          lib.versions.majorMinor sdk.version
          + "."
          + builtins.substring 0 1 (lib.versions.patch sdk.version)
          + "00";

        installState = writeText "InstallState.json" (
          builtins.toJSON {
            version =
              (lib.findFirst (pack: lib.hasPrefix "Microsoft.macOS.Sdk" pack.pname) null workloadPackEntries)
              .version;
            isInstalled = true;
          }
        );

        # Create a tree of just the workload packs. symlinkJoin will merge this
        # cleanly with the 'packs' directory from sdk.unwrapped.
        workloadPacksTree = runCommand "dotnet-macos-workload-packs-tree" { } ''
          ${lib.concatMapStrings (entry: ''
            mkdir -p $out/packs/${entry.pname}
            ln -s \
              ${dotnetCorePackages.fetchNupkg entry}/share/nuget/packages/${lib.toLower entry.pname}/${entry.version} \
              $out/packs/${entry.pname}/${entry.version}
          '') workloadPackEntries}
        '';

      in
      symlinkJoin {
        name = "dotnet-sdk-macos-workload";

        paths = [
          sdk.unwrapped
          workloadPacksTree
        ];

        postBuild = ''
          install -Dm644 ${installState} $out/metadata/workloads/${featureBand}/microsoft.net.sdk.macos/InstallState.json
        '';
      };

    # A fake Xcode.app that fools the Xamarin macOS toolchain, grafted in
    # as a skeleton that doubles-back to apple-sdk
    xcode =
      let
        toolchainBin = symlinkJoin {
          name = "xcode-stub-toolchain";
          # apple-sdk's toolchain ships no compiler or linker; fix that
          paths = [
            "${apple-sdk_15}/Toolchains/XcodeDefault.xctoolchain/usr"
            stdenv.cc
            cctools
            darwin.sigtool
          ];
        };
        # MacOSX.platform Info.plist must cater to two audiences at once: the keys
        # that`xcrun` parses to register and the AdditionalInfo DT* that Xamarin's CompileAppManifest
        # needs
        platformPlist = plist {
          CFBundleIdentifier = "com.apple.platform.macosx";
          Identifier = "com.apple.platform.macosx";
          Name = "macosx";
          Description = "macOS";
          FamilyName = "macOS";
          FamilyIdentifier = "macosx";
          Type = "Platform";
          Version = "15.5";
          MinimumSDKVersion = "14.0";
          AdditionalInfo = {
            DTPlatformName = "macosx";
            DTPlatformVersion = "15.5";
            DTPlatformBuild = "16F6";
          };
        };
        plist = attrs: writeText "stub.plist" (lib.generators.toPlist { escape = true; } attrs);
        xcodePlist = {
          CFBundleShortVersionString = "16.4";
          CFBundleVersion = "23792";
        };
      in
      runCommand "xcode-stub-16.4" { } ''
        shopt -s nullglob

        dev="$out/Contents/Developer"
        toolchain="$dev/Toolchains/XcodeDefault.xctoolchain"
        platform="$dev/Platforms/MacOSX.platform"
        platformSource="${apple-sdk_15}/Platforms/MacOSX.platform"

        mkdir --parents \
          "$out/Contents/MacOS" \
          "$toolchain/usr" \
          "$platform/Developer/SDKs"

        touch "$out/Contents/MacOS/Xcode"
        cp ${
          plist (xcodePlist // { CFBundleIdentifier = "com.apple.dt.Xcode"; })
        } "$out/Contents/Info.plist"
        cp ${plist (xcodePlist // { ProductBuildVersion = "16F6"; })} "$out/Contents/version.plist"
        cp ${platformPlist} "$platform/Info.plist"

        # Link Static Toolchain and Apple SDK Assets for availability
        ln --symbolic "${apple-sdk_15}/Library" "$dev/Library"
        ln --symbolic "${apple-sdk_15}/usr" "$dev/usr"
        ln --symbolic "${apple-sdk_15}/Toolchains/XcodeDefault.xctoolchain/ToolchainInfo.plist" "$toolchain/ToolchainInfo.plist"
        ln --symbolic "${toolchainBin}/bin" "$toolchain/usr/bin"

        source="$platformSource/Developer"
        destination="$platform/Developer"

        # Symlink everything in Developer/ EXCEPT... the SDKs directory
        for entry in "$source"/*; do
          name="''${entry##*/}"
          [[ "$name" == "SDKs" ]] || ln --symbolic "$entry" "$destination/$name"
        done

        # Rebuild only the SDKs tree with specific symlink/copy logic
        for sdk in "$source/SDKs"/*; do
          name="''${sdk##*/}"
          target="$destination/SDKs/$name"

          if [[ -L "$sdk" ]]; then
            cp --no-dereference "$sdk" "$target"
          else
            mkdir --parents "$target"
            for child in "$sdk"/*; do
              ln --symbolic "$child" "$target/''${child##*/}"
            done
          fi
        done
      '';
  };

  # Custom button fonts crash NAPS2 at startup when the font cannot be
  # resolved so we fix that
  postPatch = ''
    substituteInPlace NAPS2.Lib/EtoForms/Ui/AboutForm.cs \
      --replace-fail '_donateButton.Font = new Font(' 'try { _donateButton.Font = new Font(' \
      --replace-fail 'FontStyle.Italic | FontStyle.Bold);' 'FontStyle.Italic | FontStyle.Bold); } catch {}'
    substituteInPlace NAPS2.Lib/EtoForms/Layout/C.cs \
      --replace-fail '_ => button.Font = new Font(button.Font.Family, baseFontSize * 4 / 3));' \
      '_ => { try { button.Font = new Font(button.Font.Family, baseFontSize * 4 / 3); } catch {} });'
  ''
  # Upstream gates the macOS global usings, MAC define, and project/package
  # references on the net8-macos, so we bump this UP
  + lib.optionalString isDarwin ''
    substituteInPlace NAPS2.Images.Mac/NAPS2.Images.Mac.csproj NAPS2.Sdk/NAPS2.Sdk.csproj \
      --replace-fail net8-macos net9-macos
  '';

  projectFile =
    if isDarwin then "NAPS2.App.Mac/NAPS2.App.Mac.csproj" else "NAPS2.App.Gtk/NAPS2.App.Gtk.csproj";
  nugetDeps = ./deps.json;

  # No TargetFramework override on Darwin: NAPS2.App.Mac is single-TFM, and
  # forcing TargetFrameworks would make it a cross-targeting outer build
  # which messes up the linking
  dotnetFlags = lib.optionals (!isDarwin) [ "-p:TargetFrameworks=net9" ];

  dotnet-sdk = sdk;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;
  selfContainedBuild = true;
  executables = [ "naps2" ];

  buildInputs = [
    sane-backends
    libtiff
  ]
  ++ lib.optionals isDarwin [
    apple-sdk_15
    zlib
    libiconv
  ]
  ++ lib.optionals (!isDarwin) gtkLibs;

  nativeBuildInputs = if isDarwin then [ makeBinaryWrapper ] else [ wrapGAppsHook3 ];

  runtimeDeps = lib.optionals (!isDarwin) (
    gtkLibs
    ++ [
      sane-backends
      libtiff
      libnotify
    ]
  );

  # The three workload-root variables and Directory.Build.props' NetCoreRoot all
  # point the workload-pack resolver at the overlaid SDK. So the Xamarin native launcher
  # properly links against what the apple-sdk-15 omits
  preConfigure =
    let
      customLinkFlags =
        lib.concatMapStringsSep "\n"
          (library: ''<_CustomLinkFlags Include="-L${lib.getLib library}/lib" />'')
          [
            zlib
            libiconv
            darwin.ICU
          ];

      directoryBuildProps = writeText "Directory.Build.props" ''
        <Project>
          <PropertyGroup>
            <NetCoreRoot>${finalAttrs.passthru.sdkWithMacosWorkload}</NetCoreRoot>
          </PropertyGroup>
          <ItemGroup>
            ${customLinkFlags}
          </ItemGroup>
        </Project>
      '';
    in
    lib.optionalString isDarwin ''
      # The Xamarin linker derives the Xcode bundle from the classic MD_ env var.
      export MD_APPLE_SDK_ROOT=${finalAttrs.passthru.xcode}

      export DEVELOPER_DIR=$MD_APPLE_SDK_ROOT/Contents/Developer
      export PATH=$DEVELOPER_DIR/Toolchains/XcodeDefault.xctoolchain/usr/bin:$PATH

      for variable in DOTNET_ROOT DOTNETSDK_WORKLOAD_PACK_ROOTS DOTNETSDK_WORKLOAD_MANIFEST_ROOTS; do
        export "$variable"=${finalAttrs.passthru.sdkWithMacosWorkload}
      done

      cp ${directoryBuildProps} Directory.Build.props
    '';

  # On Darwin the build phase is ALREADY emitting a complete, self-contained
  # NAPS2.app; also The dotnet fixup hook only
  # knows the Linux publish layout ($out/lib/naps2), so skip THAT too.
  dontDotnetFixup = isDarwin;
  installPhase = lib.optionalString isDarwin ''
    runHook preInstall

    mkdir --parents $out/bin $out/Applications
    cp --recursive \
      NAPS2.App.Mac/bin/Release/net9-macos/${dotnetCorePackages.systemToDotnetRid stdenv.hostPlatform.system}/NAPS2.app \
      $out/Applications/
    makeBinaryWrapper $out/Applications/NAPS2.app/Contents/MacOS/NAPS2 $out/bin/naps2

    runHook postInstall
  '';

  postInstall =
    lib.optionalString (!isDarwin) ''
      install -Dm644 NAPS2.Setup/config/linux/com.naps2.Naps2.desktop -t $out/share/applications
      chmod a+x $out/lib/naps2/_linux${lib.optionalString stdenv.hostPlatform.isAarch64 "arm"}/tesseract
    ''
    + ''
      for icon in 16:scanner-16-rev0 32:scanner-32-rev2 48:scanner-48-rev2 \
        64:scanner-64-rev2 72:scanner-72-rev1 128:scanner-128; do
        size=''${icon%:*}
        install -Dm644 NAPS2.Lib/Icons/''${icon#*:}.png \
          $out/share/icons/hicolor/''${size}x$size/apps/com.naps2.Naps2.png
      done
    '';

  meta = {
    description = "Scan documents to PDF and more, as simply as possible";
    homepage = "https://www.naps2.com";
    changelog = "https://github.com/cyanfish/naps2/blob/master/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      eliandoran
      philocalyst
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "naps2";
  };
})

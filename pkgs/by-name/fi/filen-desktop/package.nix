{
  lib,
  pkgs,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,
  desktopToDarwinBundle,
}:
let
  packageName = "filen-desktop";
  packageVersion = "3.0.47";
  desktopName = "Filen Desktop";
  desktopItem = makeDesktopItem {
    name = packageName;
    exec = packageName;
    icon = packageName;
    startupWMClass = packageName;
    desktopName = desktopName;
    comment = "Encrypted Cloud Storage";
    categories = [
      "Network"
      "FileTransfer"
      "Utility"
    ];
    keywords = [
      "cloud"
      "storage"
      "encrypted"
    ];
  };

  iconPrefix = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
  iconSuffix = if stdenv.hostPlatform.isDarwin then "icns" else "png";
in
buildNpmPackage {
  pname = packageName;
  version = packageVersion;
  makeCacheWritable = true;

  src = fetchFromGitHub {
    owner = "FilenCloudDienste";
    repo = packageName;
    rev = "v${packageVersion}";
    hash = "sha256-WS9JqErfsRtt6zF+LrKkpiscJ25MRXmRxmIm3GH6xf0=";
  };

  npmDepsHash = "sha256-+Ul2z6faZvAeCHq35janVTUNoqTQ5JNDeLbCV220nFU=";
  npmBuildScript = "build";

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "1";

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.electron
    pkgs.makeWrapper
  ]
  ++ lib.optionals stdenv.isDarwin [
    desktopToDarwinBundle
  ];

  buildInputs = [
    pkgs.pixman
    pkgs.cairo
    pkgs.pango
  ];

  # Override package-lock.json electron version to use what's given by nixpkgs
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"electron": "^34.1.1"' '"electron": "*"'
  '';

  # Set up icon assets in path required by desktopItem
  preInstall = ''
    mkdir -p $out/share/pixmaps
    cp $src/assets/icons/app/${iconPrefix}.${iconSuffix} $out/share/pixmaps/${packageName}.${iconSuffix}
    cp $src/assets/icons/app/${iconPrefix}Notification.${iconSuffix} $out/share/pixmaps/${packageName}-notification.${iconSuffix}
  '';

  # Create binary wrapper and desktopItem
  # desktopItem auto-creates the .app bundle for Darwin
  postInstall = ''
    makeWrapper ${pkgs.electron}/bin/electron $out/bin/${packageName} \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags $out/lib/node_modules/@filen/desktop/dist/index.js \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}"

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/
  '';

  # Write correct darwin icons to .app contents
  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -rf $out/share/pixmaps/* "$out/Applications/${desktopName}.app/Contents/Resources"
  '';

  meta = {
    homepage = "https://filen.io/products";
    downloadPage = "https://filen.io/products/desktop";
    description = "Filen Desktop Client";
    longDescription = ''
      Encrypted Cloud Storage built for your Desktop.
      Sync your data, mount network drives, collaborate with others and access files natively powered by robust encryption and seamless integration.
    '';
    mainProgram = packageName;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      smissingham
      kashw2
    ];
  };
}

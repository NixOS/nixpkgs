{
  stdenvNoCC,
  fetchurl,
  unzip,
  pname,
  version,
  meta,
}:

let
  appName = "MongoDB Compass.app";

  dist =
    {
      aarch64-darwin = {
        arch = "arm64";
        sha256 = "sha256-m61owQaEgeagarz+lb6fSzXc0QTjN4Z04D+wuYBa53Y=";
      };

      x86_64-darwin = {
        arch = "x64";
        sha256 = "sha256-+If8rqdNT1vaO0Pi7/Dgf//p/IkqslRsWftdGtHjt00=";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

in
stdenvNoCC.mkDerivation {
  inherit pname version meta;

  src = fetchurl {
    url = "https://downloads.mongodb.com/compass/mongodb-compass-${version}-darwin-${dist.arch}.zip";
    inherit (dist) sha256;
    name = "${pname}-${version}.zip";
  };

  nativeBuildInputs = [ unzip ];

  # The archive will be automatically unzipped; tell Nix where the source root is.
  dontFixup = true;
  sourceRoot = appName;

  installPhase = ''
    runHook preInstall

    # Create directories for the application bundle and the launcher script.
    mkdir -p "$out/Applications/${appName}" "$out/bin"

    # Copy the unzipped app bundle into the Applications folder.
    cp -R . "$out/Applications/${appName}"

    # Create a launcher script that opens the app.
    cat > "$out/bin/${pname}" << EOF
    #!${stdenvNoCC.shell}
    open -na "$out/Applications/${appName}" --args "\$@"
    EOF
    chmod +x "$out/bin/${pname}"

    runHook postInstall
  '';
}

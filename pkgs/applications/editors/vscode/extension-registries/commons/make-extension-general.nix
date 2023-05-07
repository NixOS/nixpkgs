{ callPackage }:
{ registryRef, vsix, meta ? { } }:
callPackage
  (a@{ stdenv
   , unzip
   , vscode-registry-commons
   , registryRef
   , vsix
   , meta ? { }
   , configurePhase ? ":"
   , buildPhase ? ":"
   , dontPatchELF ? true
   , dontStrip ? true
   , nativeBuildInputs ? [ ]
   , ...
   }:
    stdenv.mkDerivation ((removeAttrs a [ "stdenv" "unzip" "vscode-registry-commons" "registryRef" "vsix" ]) // {
      pname = "vscode-extension-${registryRef.publisher}-${registryRef.name}";
      inherit (registryRef) version;

      inherit configurePhase buildPhase dontPatchELF dontStrip;

      passthru = {
        extensionPublisher = registryRef.publisher;
        extensionName = registryRef.name;
        inherit vsix;
      };

      src = vsix;

      nativeBuildInputs = [ unzip vscode-registry-commons.unpackVsixHook ];

      installPrefix = "share/vscode/extensions/${registryRef.publisher}.${registryRef.name}";

      installPhase = ''

    runHook preInstall

    mkdir -p "$out/$installPrefix"
    find . -mindepth 1 -maxdepth 1 | xargs -d'\n' mv -t "$out/$installPrefix/"

    runHook postInstall
    '';

    }))
{ inherit registryRef vsix meta; }

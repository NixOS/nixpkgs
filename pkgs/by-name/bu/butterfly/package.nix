{
  lib,
  fetchFromGitHub,
  flutter327,
  runCommand,
  butterfly,
  yq,
  _experimental-update-script-combinators,
  gitUpdater,
  pdfium-binaries,
  stdenv,
  replaceVars,
}:

flutter327.buildFlutterApplication rec {
  pname = "butterfly";
  version = "2.2.4";

  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    tag = "v${version}";
    hash = "sha256-lf1CCpLd7eM4iJvTsR2AI6xGCQ2NJ1mlYkR0hW03SRA=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

  customSourceBuilders = {
    # unofficial printing
    printing =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "printing";
        inherit version src;
        inherit (src) passthru;

        patches = [
          (replaceVars ./printing.patch {
            inherit pdfium-binaries;
          })
        ];

        dontBuild = true;

        installPhase = ''
          runHook preInstall

          cp -r . $out

          runHook postInstall
        '';
      };
  };

  gitHashes = {
    dart_leap = "sha256-eEyUqdVToybQoDwdmz47H0f3/5zRdJzmPv1d/5mTOgA=";
    lw_file_system = "sha256-0LLSADBWq19liQLtJIJEuTEqmeyIWP61zRRjjpdV6SM=";
    flutter_secure_storage_web = "sha256-ULYXcFjz9gKMjw1Q1KAmX2J7EcE8CbW0MN/EnwmaoQY=";
    networker = "sha256-1b8soPRbHOGAb2wpsfw/uETnAlaCJZyLmynVRDX9Y8s=";
    lw_file_system_api = "sha256-ctz9+HEWGV47XUWa+RInS2gHnkrJQqgafnrbI8m3Yfo=";
    lw_sysapi = "sha256-OYVHBiAshYKRH/6BEcY+BXm9VIfSAFnFBOBWlQIO5Tc=";
    material_leap = "sha256-MF0wN4JsmKVzwwWjBKqY0DaLLdUuY0abyLF1VilTslM=";
    networker_socket = "sha256-8LRyo5HzreUMGh5j39vL+Gqzxp4MN/jhHYpDxbFV0Ao=";
    perfect_freehand = "sha256-dMJ8CyhoQWbBRvUQyzPc7vdAhCzcAl1X7CcaT3u6dWo=";
    pdf = "sha256-cIBSgePv5LIFRbc7IIx1fSVJceGEmzdZzDkOiD1z92E=";
    pdf_widget_wrapper = "sha256-hXDFdgyu2DvIqwVBvk6TVDW+FdlMGAn5v5JZKQwp8fA=";
    reorderable_grid = "sha256-g30DSPL/gsk0r8c2ecoKU4f1P3BF15zLnBVO6RXvDGQ=";
    printing = "sha256-0JdMld1TN2EtJVQSuYdSIfi/q96roVUJEAY8dWK9xCM=";
  };

  postInstall = ''
    cp -r linux/debian/usr/share $out/share
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          buildInputs = [ yq ];
          inherit (butterfly) src;
        }
        ''
          cat $src/app/pubspec.lock | yq > $out
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater { rev-prefix = "v"; })
      (_experimental-update-script-combinators.copyAttrOutputToFile "butterfly.pubspecSource" ./pubspec.lock.json)
    ];
  };

  meta = {
    description = "Powerful, minimalistic, cross-platform, opensource note-taking app";
    homepage = "https://github.com/LinwoodDev/Butterfly";
    mainProgram = "butterfly";
    license = with lib.licenses; [
      agpl3Plus
      cc-by-sa-40
      asl20
    ];
    maintainers = with lib.maintainers; [ ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}

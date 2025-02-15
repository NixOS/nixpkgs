{
  lib,
  fetchFromGitHub,
  flutter327,
}:
flutter327.buildFlutterApplication rec {
  pname = "butterfly";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    tag = "v${version}";
    hash = "sha256-sAgCP31Qd9XKTOvVLTazx3fqKF/FAd9WEwfcmgVqD38=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

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
  };

  postInstall = ''
    cp -r linux/debian/usr/share $out/share
  '';

  passthru.updateScript = ./update.sh;

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

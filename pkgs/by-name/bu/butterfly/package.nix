{
  lib,
  fetchFromGitHub,
  flutter,
}:
let
  version = "2.2.2";
  src = fetchFromGitHub {
    owner = "LinwoodDev";
    repo = "Butterfly";
    rev = "refs/tags/v${version}";
    hash = "sha256-tq2pBvGHDdZoi2EMgBIgNgsg3Ovh2PLCvET98oB+7Sw=";
  };
in
flutter.buildFlutterApplication {
  pname = "butterfly";
  inherit version src;

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  sourceRoot = "${src.name}/app";

  gitHashes = {
    dart_leap = "sha256-eEyUqdVToybQoDwdmz47H0f3/5zRdJzmPv1d/5mTOgA=";
    lw_file_system = "sha256-qglyQu/Qu4F0z//hhVmCMHKuh9GclBKLC8G+qKFhd24=";
    flutter_secure_storage_web = "sha256-ULYXcFjz9gKMjw1Q1KAmX2J7EcE8CbW0MN/EnwmaoQY=";
    networker = "sha256-1b8soPRbHOGAb2wpsfw/uETnAlaCJZyLmynVRDX9Y8s=";
    lw_file_system_api = "sha256-OOLbqKLvgHUJf3LiiQoHJS6kngnWtHPhswM69sX5fwE=";
    lw_sysapi = "sha256-9hCAYB5tqYKQPHGa7+Zma6fE8Ei08RvyL9d65FMuI+I=";
    flex_color_scheme = "sha256-MYEiiltevfz0gDag3yS/ZjeVaJyl1JMS8zvgI0k4Y0k=";
    material_leap = "sha256-eEwyu7qn3oMQl5q7Mbunxwwhnk5EuM3mNqnZUcZIpFw=";
    networker_socket = "sha256-8LRyo5HzreUMGh5j39vL+Gqzxp4MN/jhHYpDxbFV0Ao=";
    perfect_freehand = "sha256-dMJ8CyhoQWbBRvUQyzPc7vdAhCzcAl1X7CcaT3u6dWo=";
  };

  postInstall = ''
    cp -r linux/debian/usr/share $out/share
  '';

  meta = {
    description = "Powerful, minimalistic, cross-platform, opensource note-taking app";
    homepage = "https://github.com/LinwoodDev/Butterfly";
    mainProgram = "butterfly";
    license = with lib.licenses; [
      agpl3Plus
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}

{
  lib,
  fetchFromGitea,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "pixivfe";
  version = "3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PixivFE";
    repo = "PixivFE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uxmhv6dTarocSGlVIWsQqqlZVrcmWdyVVTptJ72XnXM=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      echo "$(git show -s --format=%cd --date=format:"%Y.%m.%d")-$(git rev-parse --short HEAD)" > $out/COMMIT
      rm -rf .git
    '';
  };

  vendorHash = "sha256-CckbPZCpGyIgkHgf7XqWeYj7d9ujnNWPVyeYS3QRd3c=";

  subPackages = [ "." ];

  preBuild = ''
    ldflags+=" -X codeberg.org/pixivfe/pixivfe/config.revision=$(cat COMMIT)"
  '';

  # Tests are supposed to be run with an instance running
  doCheck = false;

  meta = {
    description = "Open source alternative frontend for Pixiv";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ vnpower ];
    platforms = with lib.platforms; unix;
    mainProgram = "pixivfe";
  };
})

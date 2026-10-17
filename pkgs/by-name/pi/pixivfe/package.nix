{
  lib,
  fetchFromGitea,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "pixivfe";
  version = "3.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "PixivFE";
    repo = "PixivFE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jqS/pkoPgg9QHD4m7NIN8XFRkWMLr1xkAUCn82FOr18=";
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
    homepage = "https://codeberg.org/PixivFE/PixivFE";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ vnpower ];
    platforms = with lib.platforms; unix;
    mainProgram = "pixivfe";
  };
})

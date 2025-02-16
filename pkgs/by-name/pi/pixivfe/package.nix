{
  lib,
  buildGoModule,
  fetchFromGitea,
  makeBinaryWrapper,
}:

buildGoModule rec {
  pname = "pixivfe";
  version = "2.11";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "VnPower";
    repo = "PixivFE";
    tag = "v${version}";
    hash = "sha256-i5w+LagVrBsG3d6MMIyG8rgeyd3hlPkLhhW6O3CwF7g=";
  };

  vendorHash = "sha256-5TmvRzdDAxvsWPBJMXYg0hCleMK1sT0aGg5rdSOMUbU=";

  ldflags = [
    "-s"
    "-w"
    "-X codeberg.org/vnpower/pixivfe/v2/config.revision=1970.01.01-00000000"
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postInstall = ''
    mkdir -p $out/share/pixivfe/i18n
    cp -r ./i18n/locale $out/share/pixivfe/i18n
    cp -r ./assets $out/share/pixivfe

    wrapProgram $out/bin/pixivfe \
      --chdir $out/share/pixivfe
  '';

  # FIXME: upstream has faulty tests
  doCheck = false;

  meta = {
    description = "Privacy respecting frontend for Pixiv";
    homepage = "https://codeberg.org/VnPower/PixivFE";
    license = lib.licenses.agpl3Only;
    mainProgram = "pixivfe";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.linux;
  };
}

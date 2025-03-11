{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchpatch,
  imagemagick,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pop-wallpapers";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "wallpapers";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-JST5Rt4Ec1lRu62PUt98S2G1vKthAyOSpyCpuCnkGmw=";
  };

  nativeBuildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Wallpapers for Pop!_OS";
    homepage = "https://pop.system76.com/";
    license = with lib.licenses; [
      #
      # Kate Hazen:
      #
      # kate-hazen-fractal-mountains.png
      # kate-hazen-mort1mer.png
      # kate-hazen-pop-m3lvin.png
      # kate-hazen-pop-retro1.png
      # kate-hazen-pop-retro2.png
      # kate-hazen-pop-space.png
      # kate-hazen-unleash-your-robot.png
      # kate-hazen-unleash-your-robot-blue.png
      # kate-hazen-COSMIC-desktop-wallpaper.png
      #
      # Nick Nazzaro:
      #
      # nick-nazzaro-bedroom.png
      # nick-nazzaro-desert.png
      # nick-nazzaro-ice-cave.png
      # nick-nazzaro-jungle-green.png
      # nick-nazzaro-jungle-red.png
      # nick-nazzaro-space-blue.png
      # nick-nazzaro-space-red.png
      # nick-nazzaro-underwater.png
      cc-by-sa-40

      # Unsplash:
      #
      # ahmadreza-sajadi-10140-edit.jpg
      # benjamin-voros-250200.jpg
      # ferdinand-stohr-149422.jpg
      # galen-crout-175291.jpg
      # jad-limcaco-183877.jpg
      # jake-hills-36605.jpg
      # jared-evans-119758.jpg
      # jasper-van-der-meij-97274-edit.jpg
      # kait-herzog-8242.jpg
      # nasa-45068.jpg
      # nasa-53884.jpg
      # nasa-89125.jpg
      # nasa-89127.jpg
      # ng-32703.jpg
      # ricardo-gomez-angel-180819-blue.jpg
      # samuel-zeller-337041.jpg
      # sean-afnan-244576.jpg
      # sebastien-gabriel-232361.jpg
      # spacex-81773.jpg
      # tim-mccartney-39907.jpg
      # tony-webster-97532.jpg
      publicDomain
    ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
})

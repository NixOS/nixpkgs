{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "opengfw";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "apernet";
    repo = "opengfw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6PFfsPfLzzeaImcteX9u/k5pwe3cvSQwT90TCizA3gI=";
  };

  vendorHash = "sha256-F8jTvgxOhOGVtl6B8u0xAIvjNwVjBtvAhApzjIgykpY=";

  env.CGO_ENABLED = 0;

  meta = {
    mainProgram = "OpenGFW";
    description = "Flexible, easy-to-use, open source implementation of GFW on Linux";
    longDescription = ''
      OpenGFW is your very own DIY Great Firewall of China, available as a flexible,
      easy-to-use open source program on Linux. Why let the powers that be have all the fun?
      It's time to give power to the people and democratize censorship.
      Bring the thrill of cyber-sovereignty right into your home router
      and start filtering like a pro - you too can play Big Brother.
    '';
    homepage = "https://gfw.dev/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eum3l ];
  };
})

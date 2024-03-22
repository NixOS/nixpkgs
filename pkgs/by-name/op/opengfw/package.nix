{ lib
, buildGoModule
, fetchFromGitHub
,
}:
buildGoModule rec {
  pname = "opengfw";
  version = "0.3.0";

  vendorHash = "sha256-x+ZFHk35KKtrZ0rN4Wnj7C2ioCmJynKM0O6+opp9X/k=";
  src = fetchFromGitHub {
    owner = "apernet";
    repo = "OpenGFW";
    rev = "v${version}";
    hash = "sha256-GALrJcLOV3YtVadhrREOqXzUXK6IuvCz2SW8xRkj0jQ=";
  };

  meta = with lib; {
    mainProgram = "OpenGFW";
    description = "A flexible, easy-to-use, open source implementation of GFW on Linux";
    longDescription = ''
      OpenGFW is your very own DIY Great Firewall of China, available as a flexible,
      easy-to-use open source program on Linux. Why let the powers that be have all the fun?
      It's time to give power to the people and democratize censorship.
      Bring the thrill of cyber-sovereignty right into your home router
      and start filtering like a pro - you too can play Big Brother.
    '';
    homepage = "https://github.com/apernet/OpenGFW";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ eum3l ];
  };
}

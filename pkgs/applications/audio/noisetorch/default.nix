{ lib, buildGoModule, fetchFromGitHub, copyDesktopItems }:

buildGoModule rec {
  pname = "NoiseTorch";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "lawl";
    repo = "NoiseTorch";
    rev = version;
    sha256 = "0rjs6hbi7dvd179lzjmvqy4rv4pbc9amgzb8jfky4yc0zh8xf5z5";
  };

  vendorSha256 = null;

  doCheck = false;

  ldflags = [ "-X main.version=${version}"  "-X main.distribution=nix" ];

  subPackages = [ "." ];

  nativeBuildInputs = [ copyDesktopItems ];

  preBuild = ''
    make -C c/ladspa/
    go generate
    rm  ./scripts/*
  '';

  postInstall = ''
    install -D ./assets/icon/noisetorch.png $out/share/icons/hicolor/256x256/apps/noisetorch.png
    copyDesktopItems assets/noisetorch.desktop $out/share/applications/
  '';

  meta = with lib; {
    description = "Virtual microphone device with noise supression for PulseAudio";
    homepage = "https://github.com/lawl/NoiseTorch";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ panaeon legendofmiracles ];
  };
}

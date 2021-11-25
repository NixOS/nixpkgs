{ lib, buildGoModule, fetchFromGitHub, copyDesktopItems }:

buildGoModule rec {
  pname = "NoiseTorch";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "lawl";
    repo = "NoiseTorch";
    rev = version;
    sha256 = "sha256-3+Yk7dqD7eyvd1I5CMmrg085ZtFxD2EnGqL5ttwx8eM=";
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

{ lib, buildGoModule, fetchFromGitHub, pkg-config, libsecret }:

buildGoModule rec {
  pname = "protonmail-bridge";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-bridge";
    rev = "br-${version}";
    sha256 = "sha256-+XeNhjwtH1T5p8iydMQk22nXztyamSn6yY56/qqvkmk=";
  };

  vendorSha256 = "sha256-YTGjiteYfuRkDC4M9c/JKqURq4WiC5n9pFRqRVYhyxU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsecret ];

  buildPhase = ''
    runHook preBuild

    patchShebangs ./utils/
    make BUILD_TIME= -j$NIX_BUILD_CORES build-nogui

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 proton-bridge $out/bin/protonmail-bridge

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ProtonMail/proton-bridge";
    changelog = "https://github.com/ProtonMail/proton-bridge/blob/master/Changelog.md";
    downloadPage = "https://github.com/ProtonMail/proton-bridge/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lightdiscord ];
    description = "Use your ProtonMail account with your local e-mail client";
    longDescription = ''
      An application that runs on your computer in the background and seamlessly encrypts
      and decrypts your mail as it enters and leaves your computer.

      To work, gnome-keyring service must be enabled.
    '';
  };
}

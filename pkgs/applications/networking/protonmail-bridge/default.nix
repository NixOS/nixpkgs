{ lib, buildGoModule, fetchFromGitHub, pkg-config, libsecret }:

buildGoModule rec {
  pname = "protonmail-bridge";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "ProtonMail";
    repo = "proton-bridge";
    rev = "v${version}";
    hash = "sha256-i+RD0f3WxdW0PgMNynsIXnOfEdh3vS3NufJyXpw0EU0=";
  };

  vendorHash = "sha256-lrK4L7oTR5qP34Df0UJnTJATmKUmHVZeGrD9kD+sZFw=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsecret ];

  preBuild = ''
    patchShebangs ./utils/
    (cd ./utils/ && ./credits.sh bridge)
  '';

  ldflags =
    let constants = "github.com/ProtonMail/proton-bridge/v3/internal/constants"; in
    [
      "-X ${constants}.Version=${version}"
      "-X ${constants}.Revision=${src.rev}"
      "-X ${constants}.buildTime=unknown"
      "-X ${constants}.FullAppName=ProtonMailBridge" # Should be "Proton Mail Bridge", but quoting doesn't seems to work in nix's ldflags
    ];

  subPackages = [
    "cmd/Desktop-Bridge"
  ];

  postInstall = ''
    mv $out/bin/Desktop-Bridge $out/bin/protonmail-bridge # The cli is named like that in other distro packages
  '';

  meta = with lib; {
    homepage = "https://github.com/ProtonMail/proton-bridge";
    changelog = "https://github.com/ProtonMail/proton-bridge/blob/${src.rev}/Changelog.md";
    downloadPage = "https://github.com/ProtonMail/proton-bridge/releases";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mrfreezeex ];
    description = "Use your ProtonMail account with your local e-mail client";
    longDescription = ''
      An application that runs on your computer in the background and seamlessly encrypts
      and decrypts your mail as it enters and leaves your computer.

      To work, use secret-service freedesktop.org API (e.g. Gnome keyring) or pass.
    '';
  };
}

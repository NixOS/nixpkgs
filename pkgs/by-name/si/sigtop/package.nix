{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule rec {
  name = "sigtop";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${version}";
    sha256 = "sha256-xW+fwyXNM11KoU3cCfPzAjBsz6yQlTHkmDWitoq1p1k=";
  };

  vendorHash = "sha256-V47Z96ZoIgDQbGocpAJ/4oiK6uJXY8XTndsAifETbCc=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libsecret ];

  makeFlags = [
    "PREFIX=\${out}"
  ];

  meta = with lib; {
    description = "Utility to export messages, attachments and other data from Signal Desktop";
    mainProgram = "sigtop";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = with maintainers; [ fricklerhandwerk ];
  };
}

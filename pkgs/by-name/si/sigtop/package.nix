{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:

buildGoModule rec {
  name = "sigtop";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "tbvdm";
    repo = "sigtop";
    rev = "v${version}";
    sha256 = "sha256-1ZZBsKkgBnkNtYdlarbi+6DtCWBRvgcsoH0v4VNjKh0=";
  };

  vendorHash = "sha256-EWppsnZ/Ch7JjltkejOYKepZUfKNZY9+F7VbzjNCYNU=";

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

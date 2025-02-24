{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sql-migrate";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "rubenv";
    repo = "sql-migrate";
    rev = "v${version}";
    hash = "sha256-l9HW8L9khr+UfxlhH9z2mrzjemlqRbnnM7rPsf9SCtg=";
  };

  vendorHash = "sha256-GDM2YAqLkkmfOJShBbPpxS0Zs3zOK4yCfTCjohSGNIM=";

  ldflags = [
    "-s"
    "-w"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/rubenv/sql-migrate";
    description = "SQL schema migration tool for Go programs";
    license = licenses.mit;
    maintainers = with maintainers; [
      valentin-ricard
    ];
  };
}

{
  rustPlatform,
  lib,
  fetchFromSourcehut,
  pam,
  scdoc,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "greetd";
  version = "0.10.3";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "sha256-jgvYnjt7j4uubpBxrYM3YiUfF1PWuHAN1kwnv6Y+bMg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-JwTLZawY9+M09IDbMPoNUcNrnW1C2OVlEVn1n7ol6dY=";

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  buildInputs = [
    pam
  ];

  postInstall = ''
    for f in man/*; do
      scdoc < "$f" > "$(sed 's/-\([0-9]\)\.scd$/.\1/' <<< "$f")"
      rm "$f"
    done
    installManPage man/*
  '';

  meta = with lib; {
    description = "Minimal and flexible login manager daemon";
    longDescription = ''
      greetd is a minimal and flexible login manager daemon
      that makes no assumptions about what you want to launch.
      Comes with agreety, a simple, text-based greeter.
    '';
    homepage = "https://sr.ht/~kennylevinsen/greetd/";
    mainProgram = "greetd";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

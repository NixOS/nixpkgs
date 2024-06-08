{ rustPlatform
, lib
, fetchFromSourcehut
, pam
, scdoc
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "greetd";
  version = "0.10.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = pname;
    rev = version;
    sha256 = "sha256-QFxE5c4XDOBa3rKpUFur6xOG+5m0NSCOWo7960ZWEow=";
  };

  cargoHash = "sha256-w7V5ZBFy5MIEQKOPPgsc7XnrXsF5rEDNzUKeLPPy4P4=";

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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}

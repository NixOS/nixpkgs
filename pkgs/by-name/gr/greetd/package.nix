{
  rustPlatform,
  lib,
  fetchFromSourcehut,
  pam,
  scdoc,
  installShellFiles,
  nixosTests,

  config,
  greetd,
  gtkgreet,
  regreet,
  tuigreet,
  wlgreet,
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

  passthru = {
    tests.no-shadow = nixosTests.greetd-no-shadow;
  };

  meta = {
    description = "Minimal and flexible login manager daemon";
    longDescription = ''
      greetd is a minimal and flexible login manager daemon
      that makes no assumptions about what you want to launch.
      Comes with agreety, a simple, text-based greeter.
    '';
    homepage = "https://sr.ht/~kennylevinsen/greetd/";
    mainProgram = "greetd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ehmry ];
    platforms = lib.platforms.linux;
  };
}
// lib.optionalAttrs config.allowAliases (
  lib.mapAttrs (name: pkg: lib.warn "pkgs.greetd.${name} moved to pkgs.${name}" pkg) {
    inherit
      greetd
      gtkgreet
      regreet
      tuigreet
      wlgreet
      ;
    dlm = throw "greetd.dlm has been removed as it is broken and abandoned upstream"; # Added 2024-07-15
  }
)

{
  rustPlatform,
  lib,
  config,
  fetchFromSourcehut,
  pam,
  scdoc,
  installShellFiles,
  nix-update-script,
  # legacy passthrus
  gtkgreet,
  qtgreet,
  regreet,
  tuigreet,
  wlgreet,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "greetd";
  version = "0.10.3";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "greetd";
    rev = finalAttrs.version;
    hash = "sha256-jgvYnjt7j4uubpBxrYM3YiUfF1PWuHAN1kwnv6Y+bMg=";
  };

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

  # Added 2025-07-23. To be deleted on 26.05
  passthru =
    let
      warnPassthru = name: lib.warnOnInstantiate "`greetd.${name}` was renamed to `${name}`";
    in
    lib.mapAttrs warnPassthru (
      lib.optionalAttrs config.allowAliases {
        inherit
          gtkgreet
          qtgreet
          regreet
          tuigreet
          wlgreet
          ;
        greetd = finalAttrs.finalPackage;
      }
    )
    // {
      updateScript = nix-update-script { };
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

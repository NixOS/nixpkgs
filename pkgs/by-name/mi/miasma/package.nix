{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,

  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miasma";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "austin-weeks";
    repo = "miasma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cLNNh+/91jeb10PxqTQQ+uujuA5MqyLeL8Dk02eVDd4=";
  };

  cargoHash = "sha256-2E23KbmKMBscyDBAaADv5TOWBuOOToxw8mduotufaJ8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Trap AI web scrapers in an endless poison pit";
    longDescription = ''
      AI companies continually scrape the internet at an enormous
      scale, swallowing up all of its contents to use as training data
      for their next models.  If you have a public website, they are
      already stealing your work.

      Miasma is here to help you fight back!  Spin up the server and
      point any malicious traffic towards it.  Miasma will send
      poisoned training data from the poison fountain alongside
      multiple self-referential links.  It's an endless buffet of slop
      for the slop machines.

      Miasma is very fast and has a minimal memory footprint - you
      should not have to waste compute resources fending off the
      internet's leeches.
    '';
    homepage = "https://github.com/austin-weeks/miasma";
    license = lib.licenses.gpl3Plus;
    mainProgram = "miasma";
    maintainers = with lib.maintainers; [ yiyu ];
  };
})

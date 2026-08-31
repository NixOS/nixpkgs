{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  versionCheckHook,

  cacert,
  openssl,
  pkg-config,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miasma";
  version = "0.4.1";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "austin-weeks";
    repo = "miasma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ng2/p/c22oNSySkemeq2Imd2s3fHtlP2cAX8XKyurjs=";
  };

  cargoHash = "sha256-BUUP8TSjk6YIbh7nGA+5PY4TG00Ua0bRQ705e1sMjZ0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    sqlite
  ];

  nativeCheckInputs = [ cacert ];
  preCheck = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

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
    maintainers = with lib.maintainers; [
      yiyu
      jackr
    ];
  };
})

{
  lib,
  cacert,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vandelay";
  version = "1.0.8";
  src = fetchFromGitHub {
    owner = "stalwartlabs";
    repo = "vandelay";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2KknqhkbdqEcdmJmfLaJZE6LVQ9C6S1F9aMz1OJB5Nc=";
  };
  cargoHash = "sha256-dHWnfKvwRsw8XVg+aJrBCTeLx7z/oAJuF75O00/Vg/c=";
  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;
  # called `Result::unwrap()` on an `Err` value: Tls("rustls platform verifier: unexpected error: No CA certificates were loaded from the system")
  nativeCheckInputs = [
    cacert
  ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "JMAP importer-exporter (and backup tool)";
    longDescription = ''
      One-shot account migration and backup across JMAP, IMAP, CalDAV, CardDAV, WebDAV, ManageSieve, Maildir, Google Takeout and Microsoft Exchange.
    '';
    homepage = "https://github.com/stalwartlabs/vandelay";
    changelog = "https://github.com/stalwartlabs/vandelay/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.apsl20
    ];
    mainProgram = "vandelay";
    maintainers = with lib.maintainers; [
      debtquity
    ];
  };
})

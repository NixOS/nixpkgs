{
  lib,
  fetchFromGitHub,
  python3Packages,
  jq,
  nix-update-script,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "linux-entra-sso";
  version = "1.10.2";

  strictDeps = true;
  __structuredAttrs = true;
  pyproject = false;

  dependencies = with python3Packages; [
    pygobject3
    pydbus
  ];

  src = fetchFromGitHub {
    owner = "siemens";
    repo = "linux-entra-sso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JOqJorjcgPJiFIwzQXBPhcotrJY7KBHRzL3W4qtBVW8=";
  };

  dontBuild = true;
  makeFlags = [
    "RELEASE_TAG=v${finalAttrs.version}"
    "prefix=$(out)"
    "python3_bin=${python3Packages.python.interpreter}"
    "firefox_nm_dir=$(out)/lib/mozilla/native-messaging-hosts"
    "chrome_nm_dir=$(out)/etc/opt/chrome/native-messaging-hosts"
    "chromium_nm_dir=$(out)/etc/chromium/native-messaging-hosts"
    "chrome_ext_dir=$(out)/share/google-chrome/extensions"
  ];

  postInstall = ''
    mkdir -p "$out/bin"
    mv "$out/libexec/linux-entra-sso/linux-entra-sso.py" "$out/bin/linux-entra-sso"
    rmdir "$out/libexec/linux-entra-sso" "$out/libexec"
    substituteInPlace \
      "$out/lib/mozilla/native-messaging-hosts/linux_entra_sso.json" \
      "$out/etc/opt/chrome/native-messaging-hosts/linux_entra_sso.json" \
      "$out/etc/chromium/native-messaging-hosts/linux_entra_sso.json" \
      --replace-fail "$out/libexec/linux-entra-sso/linux-entra-sso.py" "$out/bin/linux-entra-sso"
  '';

  nativeInstallCheckInputs = [ jq ];
  installCheckPhase = ''
    runHook preInstallCheck
    env -i "$out/bin/linux-entra-sso" --interactive --help > /dev/null
    for manifest in \
      "$out/lib/mozilla/native-messaging-hosts/linux_entra_sso.json" \
      "$out/etc/opt/chrome/native-messaging-hosts/linux_entra_sso.json" \
      "$out/etc/chromium/native-messaging-hosts/linux_entra_sso.json"; do
      host=$(jq -er '.path' "$manifest")
      test "$host" = "$out/bin/linux-entra-sso"
      env -i "$host" --interactive --help > /dev/null
      jq -e '.name == "linux_entra_sso" and .type == "stdio"' "$manifest" > /dev/null
    done
    jq -e '.allowed_extensions == ["linux-entra-sso@example.com", "@linux-entra-sso.tb"]' \
      "$out/lib/mozilla/native-messaging-hosts/linux_entra_sso.json" > /dev/null
    jq -e '.allowed_origins == ["chrome-extension://jlnfnnolkbjieggibinobhkjdfbpcohn/"]' \
      "$out/etc/opt/chrome/native-messaging-hosts/linux_entra_sso.json" > /dev/null
    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Browser native messaging host for Microsoft Entra ID SSO";
    homepage = "https://github.com/siemens/linux-entra-sso";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ kahlstrm ];
    platforms = lib.platforms.linux;
    mainProgram = "linux-entra-sso";
  };
})

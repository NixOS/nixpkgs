{
  lib,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  writableTmpDirAsHomeHook,
  jq,
  gnupg,
  gopass,
  versionCheckHook,
}:

let
  # https://github.com/gopasspw/gopass-jsonapi/blob/v1.16.0/internal/jsonapi/manifest/manifest_path_linux.go
  manifestPaths = {
    firefox = "$out/lib/mozilla/native-messaging-hosts/com.justwatch.gopass.json";
    chrome = "$out/etc/opt/chrome/native-messaging-hosts/com.justwatch.gopass.json";
    chromium = "$out/etc/chromium/native-messaging-hosts/com.justwatch.gopass.json";
    brave = "$out/etc/opt/chrome/native-messaging-hosts/com.justwatch.gopass.json";
    vivaldi = "$out/etc/opt/vivaldi/native-messaging-hosts/com.justwatch.gopass.json";
    iridium = "$out/etc/iridium-browser/native-messaging-hosts/com.justwatch.gopass.json";
    slimjet = "$out/etc/opt/slimjet/native-messaging-hosts/com.justwatch.gopass.json";
  };
in
buildGoModule (finalAttrs: {
  pname = "gopass-jsonapi";
  version = "1.16.1";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JN/SC7lvPVTONNbOUmgu//xK/GaR5Tljxn99Zb1J/kQ=";
  };

  vendorHash = "sha256-Ki0gzhDkoUvgTCN4bYrqvN0u3AgdG22MWxcVHIE9lUQ=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  postInstall = ''
    # Generate native messaging manifests for Chrome and Firefox.
    ${gnupg}/bin/gpg --batch --passphrase "" --quick-generate-key "user <user@localhost>"
    ${gopass}/bin/gopass setup --name "user" --email "user@localhost"

    ${lib.concatMapStrings (
      browser:
      let
        manifestPath = manifestPaths.${browser};
      in
      # The options after `--print=false` are of no effect, but if missing
      # `gopass-jsonapi configure` will ask for them. (`--libpath` and `--global`
      # are overridden by `--manifest-path`. `--libpath` is only used to
      # compute Firefox's global manifest path. See
      # https://github.com/gopasspw/gopass-jsonapi/blob/v1.16.0/setup_others.go#L33-L46)
      #
      # `gopass-jsonapi configure` ask for confirmation before writing any files,
      # `echo y` gives it.
      # Prepend $PATH so we can run gopass-jsonapi before wrapProgram in postFixup.
      ''
        echo y | PATH="${gopass.wrapperPath}:$PATH" $out/bin/gopass-jsonapi configure \
          --browser ${browser} \
          --path $out/lib/gopass \
          --manifest-path ${manifestPath} \
          --print=false \
          --global \
          --libpath /var/empty
        # replace gopass_wrapper.sh with ./browser-jsonapi-wrapper.sh
        rm $out/lib/gopass/gopass_wrapper.sh
        ${jq}/bin/jq --arg script $out/lib/gopass/browser-jsonapi-wrapper.sh \
          '.path = $script' ${manifestPath} > ${manifestPath}.tmp
        mv ${manifestPath}.tmp ${manifestPath}
      ''
    ) (builtins.attrNames manifestPaths)}
    substitute ${./browser-jsonapi-wrapper.sh} $out/lib/gopass/browser-jsonapi-wrapper.sh \
      --replace-fail "@OUT@" "$out"
    chmod +x $out/lib/gopass/browser-jsonapi-wrapper.sh
  '';

  postFixup = ''
    wrapProgram $out/bin/gopass-jsonapi \
      --prefix PATH : "${gopass.wrapperPath}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "Enables communication with gopass via JSON messages";
    homepage = "https://github.com/gopasspw/gopass-jsonapi";
    changelog = "https://github.com/gopasspw/gopass-jsonapi/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      maxhbr
      doronbehar
    ];
    mainProgram = "gopass-jsonapi";
  };
})

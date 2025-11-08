{
  lib,
  stdenv,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  jq,
  gnupg,
  gopass,
  apple-sdk_14,
}:

let

  # https://github.com/gopasspw/gopass-jsonapi/blob/v1.15.18/internal/jsonapi/manifest/manifest_path_linux.go
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
buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.15.18";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
    hash = "sha256-TN6GC+T2S3xdUGtQFbsSnFtdb+DsERLjLMCPCb8Q+2c=";
  };

  vendorHash = "sha256-PJOGnx0zSxK95bWbweF/VoSfyXkkmru8XYToSh48YOw=";

  subPackages = [ "." ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    # For ScreenCaptureKit.h, see https://github.com/NixOS/nixpkgs/pull/358760#discussion_r1858327365
    apple-sdk_14
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  postInstall = ''
    # Generate native messaging manifests for Chrome and Firefox.
    export HOME=$(mktemp -d)
    ${gnupg}/bin/gpg --batch --passphrase "" --quick-generate-key "user <user@localhost>"
    ${gopass}/bin/gopass setup --name "user" --email "user@localhost"

    ${lib.concatMapStrings (
      browser:
      let
        manifestPath = manifestPaths.${browser};
      in
      # The options after `--print=false` are of no effect, but if missing
      # `gopass-jsonapi configure` will ask for them. (`--libpath` and `--global`
      # are overriden by `--manifest-path`. `--libpath` is only used to
      # compute Firefox's global manifest path. See
      # https://github.com/gopasspw/gopass-jsonapi/blob/v1.15.18/setup_others.go#L33-L46)
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

  meta = {
    description = "Enables communication with gopass via JSON messages";
    homepage = "https://github.com/gopasspw/gopass-jsonapi";
    changelog = "https://github.com/gopasspw/gopass-jsonapi/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      maxhbr
      doronbehar
    ];
    mainProgram = "gopass-jsonapi";
  };
}

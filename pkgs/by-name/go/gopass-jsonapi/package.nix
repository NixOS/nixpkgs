{
  lib,
  stdenv,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  gnupg,
  gopass,
  apple-sdk_14,
}:

buildGoModule rec {
  pname = "gopass-jsonapi";
  version = "1.15.15";

  src = fetchFromGitHub {
    owner = "gopasspw";
    repo = "gopass-jsonapi";
    rev = "v${version}";
    hash = "sha256-nayg7NTJH6bAPiguyuN37JivfWkpOUX/xI/+PHDi3UI=";
  };

  vendorHash = "sha256-khX1CdzN+5T8q2hA3NyCxtz7uw9uDd9u61q3UslTtqs=";

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

  postFixup = ''
    wrapProgram $out/bin/gopass-jsonapi \
      --prefix PATH : "${gopass.wrapperPath}"

    # Generate native messaging manifests for Chrome and Firefox.
    # It would be nicer to not do that in the fixupPhase but `gopass-jsonapi configure`
    # is run which relies on on the wrapped `gopass-jsonapi`.
    export HOME=$(mktemp -d)
    ${gnupg}/bin/gpg --batch --passphrase "" --quick-generate-key "user <user@localhost>"
    ${gopass}/bin/gopass setup --name "user" --email "user@localhost"

    # The options after `--print=false` are of no effect, but if missing
    # `gopass-jsonapi configure` will ask for them. (`--global` is used to compute
    # the manifest path, but it is overridden by `--manifest-path` and `--libpath`
    # seems to only be used to compute Firefox' global manifest path, see
    # https://github.com/gopasspw/gopass-jsonapi/blob/v1.15.14/setup_others.go#L33-L46)
    #
    # Manifest paths were taken from
    # https://github.com/gopasspw/gopass-jsonapi/blob/v1.15.14/internal/jsonapi/manifest/manifest_path_linux.go
    #
    # Both calls will write `$out/lib/gopass_wrapper.sh` but they are identical.
    # https://github.com/gopasspw/gopass-jsonapi/blob/v1.15.14/internal/jsonapi/manifest/wrapper.go#L14-L36
    #
    # `gopass-jsonapi configure` ask for confirmation before writing any files,
    # `echo y` gives it.
    echo y | "$out"/bin/gopass-jsonapi configure \
      --browser chrome \
      --path "$out"/lib \
      --manifest-path "$out"/etc/chromium/native-messaging-hosts/com.justwatch.gopass.json \
      --print=false \
      --global \
      --libpath "$out"/lib
    echo y | "$out"/bin/gopass-jsonapi configure \
      --browser firefox \
      --path "$out"/lib \
      --manifest-path "$out"/lib/mozilla/native-messaging-hosts/com.justwatch.gopass.json \
      --print=false \
      --global \
      --libpath "$out"/lib
    # Set $PATH for the wrapper script manually. gopass-jsonapi's own `$PATH`
    # is already provided by `wrapProgram` above.
    sed -e '/^export PATH=/d' -i "$out"/lib/gopass_wrapper.sh
    wrapProgram "$out"/lib/gopass_wrapper.sh \
      --prefix PATH : ${lib.makeBinPath [ "\"$out\"" gnupg ]}
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

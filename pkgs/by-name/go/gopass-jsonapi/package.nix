{
  lib,
  stdenv,
  makeWrapper,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
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

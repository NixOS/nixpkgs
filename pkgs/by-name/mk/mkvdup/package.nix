{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "mkvdup";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "stuckj";
    repo = "mkvdup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BkzqzRZYlqRVwp4vqU/7hUMx6P5o73o40fLoZ6R9l6Q=";
  };

  vendorHash = "sha256-rp2M/Fe5P+ganzJ6/0c75PO9Kg38LL7+vwb6pwIOgSE=";

  __structuredAttrs = true;

  subPackages = [ "cmd/mkvdup" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # docs/mkvdup.1 is a template; upstream's release tooling expands these before
  # packaging. --replace-fail so a rename upstream breaks the build loudly
  # instead of silently shipping a man page full of placeholders.
  postPatch = ''
    substituteInPlace docs/mkvdup.1 \
      --replace-fail '@PACKAGE_NAME_UPPER@' 'MKVDUP' \
      --replace-fail '@PACKAGE_NAME@' 'mkvdup'
  '';

  postInstall = ''
    installManPage docs/mkvdup.1
    installShellCompletion --cmd mkvdup \
      --bash scripts/mkvdup-completion.bash \
      --zsh scripts/mkvdup-completion.zsh \
      --fish scripts/mkvdup.fish
    install -Dm755 scripts/mount.fuse.mkvdup $out/bin/mount.fuse.mkvdup
  '';

  meta = {
    description = "MKV deduplication tool using FUSE — stores MKV files as references to source media";
    homepage = "https://github.com/stuckj/mkvdup";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stuckj ];
    mainProgram = "mkvdup";
    # Left unset this defaults to every platform the Go compiler supports, which
    # includes FreeBSD and WASI. mkvdup is a FUSE filesystem shipping a bash
    # mount helper, and upstream builds and tests only Linux and macOS.
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

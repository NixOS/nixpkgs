{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  immich-go,
}:
buildGoModule rec {
  pname = "immich-go";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "simulot";
    repo = "immich-go";
    rev = "${version}";
    hash = "sha256-6bLjHKkEghbY+UQFrgbfeHwOjtks1HjXbDXEr7DuJbU=";

    # Inspired by: https://github.com/NixOS/nixpkgs/blob/f2d7a289c5a5ece8521dd082b81ac7e4a57c2c5c/pkgs/applications/graphics/pdfcpu/default.nix#L20-L32
    # The intention here is to write the information into files in the `src`'s
    # `$out`, and use them later in other phases (in this case `preBuild`).
    # In order to keep determinism, we also delete the `.git` directory
    # afterwards, imitating the default behavior of `leaveDotGit = false`.
    # More info about git log format can be found at `git-log(1)` manpage.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git log -1 --pretty=%H > "COMMIT"
      git log -1 --pretty=%cd --date=format:'%Y-%m-%dT%H:%M:%SZ' > "SOURCE_DATE"
      rm -rf ".git"
    '';
  };

  vendorHash = "sha256-jED1K2zHv60zxMY4P7Z739uzf7PtlsnvZyStOSLKi4M=";

  # options used by upstream:
  # https://github.com/simulot/immich-go/blob/0.13.2/.goreleaser.yaml
  ldflags = [
    "-s"
    "-w"
    "-extldflags=-static"
    "-X main.version=${version}"
  ];

  preBuild = ''
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE)"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.versionTest = testers.testVersion {
      package = immich-go;
      command = "immich-go -version";
      version = version;
    };
  };

  meta = {
    description = "Immich client tool for bulk-uploads";
    longDescription = ''
      Immich-Go is an open-source tool designed to streamline uploading
      large photo collections to your self-hosted Immich server.
    '';
    homepage = "https://github.com/simulot/immich-go";
    mainProgram = "immich-go";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ kai-tub ];
    changelog = "https://github.com/simulot/immich-go/releases/tag/${version}";
  };
}

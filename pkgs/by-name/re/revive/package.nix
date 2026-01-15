{
  buildGoModule,
  fetchFromGitHub,
  go,
  lib,
  makeWrapper,
  stdenvNoCC,
}:

buildGoModule rec {
  pname = "revive";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "mgechev";
    repo = "revive";
    tag = "v${version}";
    # The hash differs between darwin and linux.
    hash =
      if stdenvNoCC.hostPlatform.isDarwin then
        "sha256-BwiZSLg9amqFCK2W66WY3Xhn6cR2dW11d2YUfcwCYqk="
      else
        "sha256-ni/YDivXo9THcEsef5fAnoMrjVagSXOEvRmVVO1OO4w=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" "+%Y-%m-%d %H:%M UTC" > $out/DATE
      git -C $out rev-parse HEAD > $out/COMMIT
      rm -rf $out/.git
    '';
  };
  vendorHash = "sha256-cYvOOD+6ETmOwzbJwTTnODykGRhXlMWri1dWF4nDV6M=";

  postPatch = ''
    # Package `tools` is only a placeholder, which helps `renovate` discover
    # all indirect dependencies. It should not be imported in production code,
    # otherwise the build will fail with
    # `main module (github.com/mgechev/revive) does not contain package github.com/mgechev/revive/tools`.
    rm -rf tools
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mgechev/revive/cli.version=${version}"
    "-X github.com/mgechev/revive/cli.builtBy=nix"
  ];

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X github.com/mgechev/revive/cli.commit=$(cat COMMIT)"
    ldflags+=" -X 'github.com/mgechev/revive/cli.date=$(cat DATE)'"
  '';

  allowGoReference = true;

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    wrapProgram $out/bin/revive \
      --prefix PATH : ${lib.makeBinPath [ go ]}
  '';

  meta = {
    description = "Fast, configurable, extensible, flexible, and beautiful linter for Go";
    mainProgram = "revive";
    homepage = "https://revive.run";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maaslalani ];
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gomi";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "b4b4r07";
    repo = "gomi";
    tag = "v${version}";
    hash = "sha256-Sxf/x29uADkdILrWwdKZhTc1Y7zCJbpMNK6vV/SGF1Q=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd $out
      git show --format='%h' HEAD --quiet > ldflags_revision
      date --utc --date="@$(git show --format='%ct' HEAD --quiet)" +'%Y-%m-%dT%H:%M:%SZ' > ldflags_buildDate
      find . -type d -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-Lt2SA3IHD8wDxv5bScU37hqStnfxVYQQZS6ajr7PhJM=";

  subPackages = [ "." ];

  # Add version information fetched from the repository to ldflags.
  # https://github.com/babarot/gomi/blob/v1.6.1/.goreleaser.yaml#L20-L22
  ldflags = [
    "-X main.version=v${version}"
  ];
  preBuild = ''
    ldflags+=" -X main.revision=$(cat ldflags_revision)"
    ldflags+=" -X main.buildDate=$(cat ldflags_buildDate)"
  '';

  meta = {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/b4b4r07/gomi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mimame
      ozkutuk
    ];
    mainProgram = "gomi";
  };
}

{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gomi";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "babarot";
    repo = "gomi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0ihj3HDMNGi/4w3fwQbIzc4b41SUyZI/Qvnp5z8RqLY=";
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

  vendorHash = "sha256-H0OTcWW7xn5QU6dYXT3XpZMJelSAcSqMT/msRiwm2Us=";

  subPackages = [ "." ];

  # Add version information fetched from the repository to ldflags.
  # https://github.com/babarot/gomi/blob/v1.10.1/.goreleaser.yaml#L20-L22
  ldflags = [
    "-X main.version=v${finalAttrs.version}"
  ];
  preBuild = ''
    ldflags+=" -X main.revision=$(cat ldflags_revision)"
    ldflags+=" -X main.buildDate=$(cat ldflags_buildDate)"
  '';

  meta = {
    description = "Replacement for UNIX rm command";
    homepage = "https://github.com/babarot/gomi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mimame
      ozkutuk
    ];
    mainProgram = "gomi";
  };
})

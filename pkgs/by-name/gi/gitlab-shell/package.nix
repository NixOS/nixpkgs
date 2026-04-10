{
  lib,
  fetchFromGitLab,
  buildGoModule,
  ruby,
  libkrb5,
}:

buildGoModule (finalAttrs: {
  pname = "gitlab-shell";
  version = "14.47.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1FQH7Epa9mKxJMyN+NFDIir4shosmEbh6BHcXinuTyk=";
  };

  buildInputs = [
    ruby
    libkrb5
  ];

  patches = [
    ./remove-hardcoded-locations.patch
  ];

  vendorHash = "sha256-KkIDo/jhBBMwa/T6VzCgeuy9kXIncJglMjab70wqYug=";

  subPackages = [
    "cmd/gitlab-shell"
    "cmd/gitlab-sshd"
    "cmd/gitlab-shell-check"
    "cmd/gitlab-shell-authorized-principals-check"
    "cmd/gitlab-shell-authorized-keys-check"
  ];

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = lib.platforms.linux;
    teams = [ lib.teams.gitlab ];
    license = lib.licenses.mit;
  };
})

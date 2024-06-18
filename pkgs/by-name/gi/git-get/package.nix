{ lib, fetchFromGitHub, git, buildGoModule }:

let config-module = "git-get/pkg/cfg";
in
buildGoModule rec {
  pname = "git-get";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "grdl";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-v98Ff7io7j1LLzciHNWJBU3LcdSr+lhwYrvON7QjyCI=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse HEAD > $out/COMMIT
      # in format of 0000-00-00T00:00:00Z
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" "+%Y-%m-%dT%H:%M:%SZ" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-C+XOjMDMFneKJNeBh0KWPx8yM7XiiIpTlc2daSfhZhY=";

  doCheck = false;

  # ldflags based on metadata from git and source
  preBuild = ''
    ldflags+=" -X ${config-module}.commit=$(cat COMMIT)"
    ldflags+=" -X ${config-module}.date=$(cat SOURCE_DATE_EPOCH)"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X ${config-module}.version=v${version}"
  ];

  preInstall = ''
    mv "$GOPATH/bin/get" "$GOPATH/bin/git-get"
    mv "$GOPATH/bin/list" "$GOPATH/bin/git-list"
  '';

  meta = with lib; {
    description = "Better way to clone, organize and manage multiple git repositories";
    homepage = "https://github.com/grdl/git-get";
    license = licenses.mit;
    maintainers = with maintainers; [ sumnerevans ];
  };
}

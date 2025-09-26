{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

let
  config-module = "git-get/pkg/cfg";
in
buildGoModule rec {
  pname = "git-get";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "grdl";
    repo = "git-get";
    tag = "v${version}";
    hash = "sha256-xnmFqNIabiTyf9ZPKlm5S42rfFUXnTp/jLDDY51eoMw=";
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

  vendorHash = "sha256-8DLS1pSyh1OgnULMvAppl/+D2yfyi/dcZs08S1IMzaE=";

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
    mv "$GOPATH/bin/cmd" "$GOPATH/bin/git-get"
    ln -s ./git-get "$GOPATH/bin/git-list"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Better way to clone, organize and manage multiple git repositories";
    homepage = "https://github.com/grdl/git-get";
    license = licenses.mit;
    maintainers = with maintainers; [ sumnerevans ];
    mainProgram = "git-get";
  };
}

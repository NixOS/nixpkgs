{
  lib,
  callPackage,
  fetchFromGitLab,
  buildGoModule,
  pkg-config,
}:

let
  version = "18.3.2";
  package_version = "v${lib.versions.major version}";
  gitaly_package = "gitlab.com/gitlab-org/gitaly/${package_version}";

  git = callPackage ./git.nix { };

  commonOpts = {
    inherit version;

    # nixpkgs-update: no auto update
    src = fetchFromGitLab {
      owner = "gitlab-org";
      repo = "gitaly";
      rev = "v${version}";
      hash = "sha256-R/35xYOCq/dlwLQ/in6u+DLifxsGpqBx58flX+FrVCo=";
    };

    vendorHash = "sha256-JFGzGwYi4owq0oVLucm7UGuq8PE4FH9Gp8HyBRoE6cs=";

    ldflags = [
      "-X ${gitaly_package}/internal/version.version=${version}"
      "-X ${gitaly_package}/internal/version.moduleVersion=${version}"
    ];

    tags = [ "static" ];

    nativeBuildInputs = [ pkg-config ];

    doCheck = false;
  };

  auxBins = buildGoModule (
    {
      pname = "gitaly-aux";

      subPackages = [
        # Can be determined by looking at the `go:embed` calls in https://gitlab.com/gitlab-org/gitaly/-/blob/master/packed_binaries.go
        "cmd/gitaly-hooks"
        "cmd/gitaly-ssh"
        "cmd/gitaly-lfs-smudge"
        "cmd/gitaly-gpg"
      ];
    }
    // commonOpts
  );
in
buildGoModule (
  {
    pname = "gitaly";

    subPackages = [
      "cmd/gitaly"
      "cmd/gitaly-backup"
    ];

    dontStrip = true;

    preConfigure = ''
      rm -r tools

      mkdir -p _build/bin
      cp -r ${auxBins}/bin/* _build/bin

      # Add git that will be embedded
      echo 'print-%:;@echo $($*)' >> Makefile
      sed -i 's:/usr/bin/env ::g' Makefile
      for bin in $(make print-GIT_PACKED_EXECUTABLES); do
        from="$(basename "$bin")"
        from="''${from#gitaly-}"
        from="${git}/libexec/git-core/''${from%-*}"
        cp "$from" "$bin"
      done

    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      HOME=/build PAGER=cat ${git}/bin/git config -l
      runHook postInstallCheck
    '';

    outputs = [ "out" ];

    passthru = {
      inherit git;
    };

    meta = with lib; {
      homepage = "https://gitlab.com/gitlab-org/gitaly";
      description = "Git RPC service for handling all the git calls made by GitLab";
      platforms = platforms.linux ++ [ "x86_64-darwin" ];
      teams = [ teams.gitlab ];
      license = licenses.mit;
    };
  }
  // commonOpts
)

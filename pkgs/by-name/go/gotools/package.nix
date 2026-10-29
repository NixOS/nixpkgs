{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  go,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gotools";
  version = "0.44.0";

  # using GitHub instead of https://go.googlesource.com/tools because Gitiles UI is too basic to browse
  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-F9DyZAZdrKCrCIB6FZP0KrOwPNRLk0ZQoNMHGMHd0UY=";
  };

  vendorHash = "sha256-HpWkPsRJ0vCqJi9LoZcVbzeoPQ2B9ftZwuS1r47W7Sc=";

  nativeBuildInputs = [ makeWrapper ];

  allowGoReference = true;

  postPatch = ''
    # The gopls folder contains a Go submodule which causes a build failure
    # and lives in its own package named gopls.
    rm -r gopls
  '';

  # Keep toolchain references, but strip temporary paths from binaries.
  preBuild = ''
    export GOFLAGS="$GOFLAGS -trimpath"
  '';

  # Some tests start local HTTP servers which fails on macOS without this.
  __darwinAllowLocalNetworking = true;

  # Because GOFLAGS are passed through when running tests, the default of -mod=vendor breaks
  # a bunch of tests which use modules without vendor directories.
  preCheck = ''
    export GOFLAGS="''${GOFLAGS//-mod=vendor/}"
  '';

  # Disable TestToolsCopyright which checks for a specific header, as this also scans the vendor
  # directory created for the actual package and fails.
  checkFlags = [ "-skip=^TestToolsCopyright$" ];

  # Set GOTOOLDIR for derivations adding this to buildInputs
  postInstall = ''
    mkdir -p $out/nix-support
    substitute ${./setup-hook.sh} $out/nix-support/setup-hook \
      --subst-var-by bin $out
  '';

  postFixup = ''
    wrapProgram $out/bin/goimports \
      --suffix PATH : ${lib.makeBinPath [ go ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Additional tools for Go development";
    longDescription = ''
      This package contains tools like: godoc, goimports, callgraph, digraph, stringer or toolstash.
    '';
    homepage = "https://go.googlesource.com/tools";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      techknowlogick
    ];
  };
})

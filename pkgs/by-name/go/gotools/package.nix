{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  go,
}:

buildGoModule (finalAttrs: {
  pname = "gotools";
  version = "0.34.0";

  # using GitHub instead of https://go.googlesource.com/tools because Gitiles UI is too basic to browse
  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C+P2JoD4NzSAkAQuA20bVrfLZrMHXekvXn8KPOM5Nj4=";
  };

  allowGoReference = true;
  doCheck = false;

  vendorHash = "sha256-UZNYHx5y+kRp3AJq6s4Wy+k789GDG7FBTSzCTorVjgg=";

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # The gopls folder contains a Go submodule which causes a build failure
    # and lives in its own package named gopls.
    rm -r gopls
    # cmd/auth folder is similar and is scheduled to be removed https://github.com/golang/go/issues/70872
    rm -r cmd/auth
  '';

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

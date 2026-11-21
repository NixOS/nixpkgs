{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gomacro";
  version = "2.7-unstable-2024-01-07";

  src = fetchFromGitHub {
    owner = "cosmos72";
    repo = "gomacro";
    rev = "bf232d031933810d4a5382e17ce6c4b042a24304";
    hash = "sha256-16u3eByFmnY12M2CEhSJKLIT0KP9nbvTv+BnqWwNTcg=";
  };

  vendorHash = "sha256-/2wnzc56knUH/GE5h7oMLhnM+8vPCFICu1wfgUcJJEE=";

  overrideModAttrs = oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH=$TMPDIR/go
      go mod edit -replace golang.org/x/tools=golang.org/x/tools@v0.30.0
      go mod tidy
    '';
    postBuild = (oldAttrs.postBuild or "") + ''
      cp go.mod go.sum vendor/
    '';
  };

  preBuild = ''
    if [ -d vendor ]; then
      chmod -R u+w vendor
      cp vendor/go.mod vendor/go.sum .
    fi
  '';

  subPackages = [ "." ];

  meta = {
    description = "Interactive Go interpreter and debugger with generics and macros";
    mainProgram = "gomacro";
    homepage = "https://github.com/cosmos72/gomacro";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ shofius ];
  };
})

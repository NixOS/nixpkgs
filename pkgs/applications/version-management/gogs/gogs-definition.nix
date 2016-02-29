with import <nixpkgs> {};

let
  # My go2nix fork to be able to build in a pure environment,
  # with build tags support, fixed bugs that affected Gogs
  # and with latest nix-prefetch-git output style.
  my-go2nix = lib.overrideDerivation go2nix (oldAttrs: {
    src = fetchFromGitHub {
      rev = "336ac3d93272860c9d8f518f43ce6f70c3b11bf4";
      owner = "valeriangalliat";
      repo = "go2nix";
      sha256 = "0m9srjcl9lrphl4gsrscibf2c7yz2kmmja9qylbli4lwjw53g7p7";
    };

    buildInputs = [ makeWrapper ] ++ oldAttrs.buildInputs;

    preFixup = "";

    postInstall = ''
      wrapProgram $bin/bin/go2nix \
        --prefix PATH : ${nix-prefetch-git}/bin  \
        --prefix PATH : ${git}/bin  \
    '';

    disallowedReferences = [];
  });

  # Fetch a Go tree from a Go package repository and build tags.
  # All dependencies are fetched according to `go get` rules, so the
  # output of this derivation is not deterministic (but that's the
  # point since we use it to automatically update the package and its
  # dependencies).
  fetchgo =
    { goPackagePath, url, rev ? "HEAD", tags ? [] }:
    stdenv.mkDerivation {
      name = builtins.replaceStrings ["/"] ["_"] goPackagePath;
      buildInputs = [ go git ];
      phases = [ "installPhase" ];

      installPhase = ''
        export GOPATH=$out
        repo=$out/src/${goPackagePath}
        mkdir -p $repo
        git clone ${url} $repo
        cd $repo
        git reset --hard ${rev}
        go get -v -d -tags ${builtins.concatStringsSep "," tags}
      '';
    };

  goPackagePath = "github.com/gogits/gogs";
  url = "https://${goPackagePath}.git";
  rev = "d320915ad2a7b4bbab075b98890aa50f91f0ced5";
  tags = [ "sqlite" ];

in

stdenv.mkDerivation {
  name = "gogs-definition";

  src = fetchgo {
    inherit goPackagePath url rev tags;
   };

  buildInputs = [ nix my-go2nix.bin ];

  installPhase = ''
    export GOPATH=$PWD
    cd src/${goPackagePath}
    go2nix save --tags ${builtins.concatStringsSep "," tags}
    patch default.nix < ${./default.nix.patch}
    cat default.nix | awk -f ${./sqlite.awk} | sed '/# can be improved/d' > $out
  '';
}

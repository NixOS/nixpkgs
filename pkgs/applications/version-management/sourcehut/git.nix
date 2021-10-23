{ lib
, fetchFromSourcehut
, buildPythonPackage
, buildGoModule
, python
, srht
, pygit2
, scmsrht
, srht-keys
}:
let
  version = "0.73.4";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "git.sr.ht";
    rev = version;
    sha256 = "sha256-MxmMneK5RKA9EQMHGGUjmjQUybHV3xaxFetzlaLAf+E=";
  };

  gitsrht-shell = buildGoModule {
    inherit src version;
    sourceRoot = "source/gitsrht-shell";
    pname = "gitsrht-shell";
    vendorSha256 = "sha256-aqUFICp0C2reqb2p6JCPAUIRsxzSv0t9BHoNWrTYfqk=";
  };

  gitsrht-dispatch = buildGoModule {
    inherit src version;
    sourceRoot = "source/gitsrht-dispatch";
    pname = "gitsrht-dispatch";
    vendorSha256 = "sha256-qWXPHo86s6iuRBhRMtmD5jxnAWKdrWHtA/iSUkdw89M=";
    patches = [
      # Add support for supplementary groups
      patches/redis-socket/git/v3-0003-gitsrht-dispatch-add-support-for-supplementary-gr.patch
    ];
    patchFlags = ["-p2"];
  };

  gitsrht-keys = buildGoModule {
    inherit src version;
    sourceRoot = "source/gitsrht-keys";
    pname = "gitsrht-keys";
    vendorSha256 = "sha256-SOI7wimFthY+BwsDtMuyqKS1hCaEa3R90Q0qaA9boyE=";

    # What follows is only to update go-redis,
    # and thus also using a patched srht-keys.
    # go.{mod,sum} could be patched directly but that would be less resilient
    # to changes from upstream, and thus harder to maintain the patching
    # while it hasn't been merged upstream.

    overrideModAttrs = _: {
      preBuild = ''
        # This is a fixed-output derivation so it is not allowed to reference other derivations,
        # but here srht-keys will be copied to vendor/ by go mod vendor
        ln -s ${srht-keys} srht-keys
        go mod edit -replace git.sr.ht/~sircmpwn/scm.sr.ht/srht-keys=$PWD/srht-keys
        go get github.com/go-redis/redis/v8
        go get github.com/go-redis/redis@none
        go mod tidy
      '';
      # Pass updated go.{mod,sum} from go-modules to gitsrht-keys' vendor/go.{mod,sum}
      postInstall = ''
        cp --reflink=auto go.* $out/
      '';
    };

    patches = [
      # Update go-redis to support Unix sockets
      patches/redis-socket/git/v3-0001-gitsrht-keys-update-go-redis-to-support-Unix-sock.patch
    ];
    patchFlags = ["-p2"];
    postConfigure = ''
      cp -v vendor/go.{mod,sum} .
    '';
  };

  gitsrht-update-hook = buildGoModule {
    inherit src version;
    sourceRoot = "source/gitsrht-update-hook";
    pname = "gitsrht-update-hook";
    vendorSha256 = "sha256-QWd4i9qnnKbgO4qdFwZI3wlcsSurCh2ydhLYEyEZyK8=";

    # What follows is only to update go-redis
    # and thus also using a patched srht-keys.

    overrideModAttrs = old: {
      preBuild = ''
        # This is a fixed-output derivation so it is not allowed to reference other derivations,
        # but here srht-keys will be copied to vendor/ by go mod vendor
        ln -s ${srht-keys} srht-keys
        go mod edit -replace git.sr.ht/~sircmpwn/scm.sr.ht/srht-keys=$PWD/srht-keys
        go get github.com/go-redis/redis/v8
        go get github.com/go-redis/redis@none
        go mod tidy
      '';
      # Pass updated go.{mod,sum} from go-modules to gitsrht-keys' vendor/go.{mod,sum}
      postInstall = ''
        cp --reflink=auto go.* $out/
      '';
    };

    patches = [
      # Update go-redis to support Unix sockets
      patches/redis-socket/git/v3-0002-gitsrht-update-hook-update-go-redis-to-support-Un.patch
    ];
    patchFlags = ["-p2"];
    postConfigure = ''
      cp -v vendor/go.{mod,sum} .
    '';
  };

in
buildPythonPackage rec {
  inherit src version;
  pname = "gitsrht";

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    pygit2
    scmsrht
  ];

  preBuild = ''
    export PKGVER=${version}
    export SRHT_PATH=${srht}/${python.sitePackages}/srht
  '';

  postInstall = ''
    mkdir -p $out/bin
    cp ${gitsrht-shell}/bin/gitsrht-shell $out/bin/gitsrht-shell
    cp ${gitsrht-dispatch}/bin/gitsrht-dispatch $out/bin/gitsrht-dispatch
    cp ${gitsrht-keys}/bin/gitsrht-keys $out/bin/gitsrht-keys
    cp ${gitsrht-update-hook}/bin/gitsrht-update-hook $out/bin/gitsrht-update-hook
  '';
  passthru = {
    inherit gitsrht-shell gitsrht-dispatch gitsrht-keys gitsrht-update-hook;
  };

  pythonImportsCheck = [ "gitsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Git repository hosting service for the sr.ht network";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}

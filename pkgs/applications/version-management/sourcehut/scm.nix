{ lib
, fetchFromSourcehut
, buildGoModule
, buildPythonPackage
, srht
, redis
, pyyaml
, applyPatches
}:

buildPythonPackage rec {
  pname = "scmsrht";
  version = "0.22.13";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "scm.sr.ht";
    rev = version;
    sha256 = "sha256-9iRmQBt4Cxr5itTk34b8iDRyXYDHTDfZjV0SIDT/kkM=";
  };

  passthru = {
    srht-keys = buildGoModule {
      inherit src version;
      sourceRoot = "source/srht-keys";
      pname = "srht-keys";
      vendorSha256 = "sha256-lQk1dymMCefHMFJhO3yC/muBP/cxI//5Yz991D2YZY4=";

      # What follows is only to update go-redis
      # go.{mod,sum} could be patched directly but that would be less resilient
      # to changes from upstream, and thus harder to maintain the patching
      # while it hasn't been merged upstream.

      overrideModAttrs = old: {
        preBuild = ''
          go get github.com/go-redis/redis/v8
          go get github.com/go-redis/redis@none
          go mod tidy
        '';
        # Pass updated go.{mod,sum} from go-modules to srht-keys's vendor/go.{mod,sum}
        postInstall = ''
          cp --reflink=auto go.* $out
        '';
      };

      patches = [
        # Update go-redis to support Unix sockets
        patches/redis-socket/scm/v3-0001-srht-keys-update-go-redis-to-support-Unix-sockets.patch
      ];
      patchFlags = ["-p2"];
      postInstall = ''
        cp --reflink=auto *.go vendor/go.* $out
      '';
    };
  };

  nativeBuildInputs = srht.nativeBuildInputs;

  propagatedBuildInputs = [
    srht
    redis
    pyyaml
  ];

  preBuild = ''
    export PKGVER=${version}
  '';

  dontUseSetuptoolsCheck = true;
  pythonImportsCheck = [ "scmsrht" ];

  meta = with lib; {
    homepage = "https://git.sr.ht/~sircmpwn/git.sr.ht";
    description = "Shared support code for sr.ht source control services.";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ eadwu ];
  };
}

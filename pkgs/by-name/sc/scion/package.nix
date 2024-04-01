{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch2
, nixosTests
}:
let
  version = "0.10.0";

  # Injects a `t.Skip()` into a given test since there's apparently no other way to skip tests here.
  # ref: https://github.com/NixOS/nixpkgs/blob/047bc33866bf7004d0ce9ed0af78dab5ceddaab0/pkgs/by-name/vi/vikunja/package.nix#L96
  skipTest = lineOffset: testCase: file:
    let
      jumpAndAppend = lib.concatStringsSep ";" (lib.replicate (lineOffset - 1) "n" ++ [ "a" ]);
    in
    ''
      sed -i -e '/${testCase}/{
      ${jumpAndAppend} t.Skip();
      }' ${file}
    '';
in

buildGoModule {
  pname = "scion";

  inherit version;

  src = fetchFromGitHub {
    owner = "scionproto";
    repo = "scion";
    rev = "v${version}";
    hash = "sha256-8yXjEDo1k0+7O0gx2acAZMrG/r+iePfNCG+FolCSKwI=";
  };

  vendorHash = "sha256-4nTp6vOyS7qDn8HmNO0NGCNU7wCb8ww8a15Yv3MPEq8=";

  excludedPackages = [ "acceptance" "demo" "tools" "pkg/private/xtest/graphupdater" ];

  # This can be removed in the next release of scion since its fixed upstream
  # https://github.com/scionproto/scion/pull/4476
  postConfigure = ''
    # This test needs docker, so lets skip it
    ${skipTest 1 "TestOpensslCompatible" "scion-pki/trcs/sign_test.go"}
  '';

  postInstall = ''
    set +e
    mv $out/bin/gateway $out/bin/scion-ip-gateway
    mv $out/bin/dispatcher $out/bin/scion-dispatcher
    mv $out/bin/router $out/bin/scion-router
    mv $out/bin/control $out/bin/scion-control
    mv $out/bin/daemon $out/bin/scion-daemon
    set -e
  '';

  doCheck = true;

  patches = [
    (fetchpatch2 {
      url = "https://github.com/scionproto/scion/commit/cb7fa6d6aab55c9eb90556c2b996b87539f8aa02.patch";
      hash = "sha256-mMGJMPB6T7KeDXjEXffdrhzyKwaFmhuisK6PjHOJIdU=";
    })
  ];

  passthru.tests = {
    inherit (nixosTests) scion-freestanding-deployment;
  };

  meta = with lib; {
    description = "A future Internet architecture utilizing path-aware networking";
    homepage = "https://scion-architecture.net/";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = with maintainers; [ sarcasticadmin matthewcroughan ];
  };
}

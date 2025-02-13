{
  lib,
  callPackage,
  haskellPackages,
  fetchFromGitHub,
  buildNpmPackage,
  git,
  makeWrapper,
}:

let
  bootstrap = callPackage ./bootstrap { };

  backend = (haskellPackages.callPackage ./generated-package.nix { }).overrideScope (
    final: prev: {
      ansi-wl-pprint = final.ansi-wl-pprint_0_6_9;
    }
  );

  fetchGrenDep =
    {
      owner,
      repo,
      rev,
      hash,
    }:
    fetchFromGitHub {
      name = "${owner}-${repo}-${rev}";
      leaveDotGit = true; # required for kernel code checks
      inherit
        owner
        repo
        rev
        hash
        ;
    };

  deps = [
    (fetchGrenDep {
      owner = "gren-lang";
      repo = "core";
      rev = "5.1.1";
      hash = "sha256-vAHugCOS5icJ9l2ty18m7mwIRtGRG3G9QH4n/G+Wty4=";
    })
    (fetchGrenDep {
      owner = "gren-lang";
      repo = "node";
      rev = "4.2.1";
      hash = "sha256-Eevh5YJ4seRvmFM7sizAOAF7laQRCD7w5BNVKQmoSf4=";
    })
    (fetchGrenDep {
      owner = "gren-lang";
      repo = "compiler-node";
      rev = "1.0.2";
      hash = "sha256-55O88e4AWsaudwVettyoWBiwU/7vM+X5kl6556HFWJ8=";
    })
    (fetchGrenDep {
      owner = "gren-lang";
      repo = "url";
      rev = "4.0.0";
      hash = "sha256-y6taMjX/PJsUejs8QxdXcqZO0WxCMSwWaiQlRbtr6ik=";
    })
  ];

in

buildNpmPackage {
  pname = "gren";
  inherit (backend) version src;

  nativeBuildInputs = [
    bootstrap
    git
    makeWrapper
  ];

  postPatch = ''
    # use out own bootstrap binary instead of trying to download it here
    substituteInPlace package.json \
      --replace-fail 'npx --package=gren-lang@0.4.5 --yes -- gren ' 'gren '
  '';

  npmDepsHash = "sha256-KmJ1ImfPLbiXvAXQms3OhWMSuT9tNrFLf4ozUBfvY2U=";

  postConfigure = ''
    export HOME=$(mktemp -d)
    pkgsDir="$HOME"/.cache/gren/${bootstrap.version}/packages

    mkdir -p "$pkgsDir"

    ${lib.concatMapStringsSep "\n" (dep: ''
      mkdir -p "$pkgsDir"/${dep.owner}/${dep.repo}
      cp -r ${dep} "$pkgsDir"/${dep.owner}/${dep.repo}/${dep.rev}

      pushd "$pkgsDir"/${dep.owner}/${dep.repo}/${dep.rev}

      chmod -R u+w .
      git add . # why are things not added by default, wtf???

      popd

    '') deps}

  '';

  npmBuildScript = "prepublishOnly";

  postInstall = ''
    wrapProgram $out/bin/gren --set GREN_BIN ${lib.getExe backend}
  '';

  passthru = {
    inherit bootstrap backend deps;
    updateScript = ./update.sh;
  };

  meta = {
    inherit (backend.meta) description homepage license;
    mainProgram = "gren";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}

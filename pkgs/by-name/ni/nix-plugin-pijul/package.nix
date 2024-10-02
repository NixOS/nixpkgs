{
  lib,
  stdenv,
  fetchzip,
  cmake,
  pkg-config,
  boost,
  howard-hinnant-date,
  nix,

  # for tests
  runCommand,
  pijul,
  nixVersions,
  nix-plugin-pijul,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-plugin-pijul";
  version = "0.1.4";

  src = fetchzip {
    url = "https://dblsaiko.net/pub/nix-plugin-pijul/nix-plugin-pijul-${finalAttrs.version}.tar.gz";
    hash = "sha256-X25tFqcAgNWmkMxbfXGx8KJ25BV6sFWAQM9NvjQeSmQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    howard-hinnant-date
    nix
  ];

  passthru.tests = let
    localRepoCheck = nix:
      runCommand "localRepoCheck-${nix.name}"
      {
        nativeBuildInputs = [
          pijul
          nix
        ];
      }
      ''
        export HOME=$(mktemp -d)
        export EDITOR=true
        pijul identity new --no-link --no-prompt --display-name 'Test User' --email 'test@example.com'

        pijul init repo
        cd repo

        echo "it works" > foo
        pijul add foo
        pijul record --message 'Add foo'

        output=$(
          nix \
            --option plugin-files ${nix-plugin-pijul.override {inherit nix;}}/lib/nix/plugins/pijul.so \
            --extra-experimental-features 'nix-command flakes' \
            eval --impure --raw --expr "builtins.readFile ((builtins.fetchTree \"pijul+file://$PWD\") + \"/foo\")"
        )

        echo $output

        [[ "$output" = "it works" ]]

        mkdir $out
      '';
  in {
    stable = localRepoCheck nixVersions.stable;
    latest = localRepoCheck nixVersions.latest;
    git = localRepoCheck nixVersions.git;
    nix_2_18 = localRepoCheck nixVersions.nix_2_18;
    nix_2_19 = localRepoCheck nixVersions.nix_2_19;
    nix_2_20 = localRepoCheck nixVersions.nix_2_20;
    nix_2_21 = localRepoCheck nixVersions.nix_2_21;
    nix_2_22 = localRepoCheck nixVersions.nix_2_22;
    nix_2_23 = localRepoCheck nixVersions.nix_2_23;
  };

  meta = {
    description = "Plugin to add Pijul support to the Nix package manager";
    homepage = "https://nest.pijul.com/dblsaiko/nix-plugin-pijul";
    license = lib.licenses.lgpl3Plus;
    maintainers = [lib.maintainers.dblsaiko];
    platforms = lib.platforms.unix;
  };
})

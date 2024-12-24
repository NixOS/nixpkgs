{
  lib,
  stdenv,
  fetchzip,
  meson,
  ninja,
  pkg-config,
  boost,
  howard-hinnant-date,

  # for tests
  runCommand,
  pijul,
  nixVersions,
  nixOverride ? null,
  nix-plugin-pijul,
}:
let
  nix = if nixOverride != null then nixOverride else nixVersions.nix_2_24;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nix-plugin-pijul";
  version = "0.1.6";

  src = fetchzip {
    url = "https://dblsaiko.net/pub/nix-plugin-pijul/nix-plugin-pijul-${finalAttrs.version}.tar.gz";
    hash = "sha256-BOuBaFvejv1gffhBlAJADLtd5Df71oQbuCnniU07nF4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    howard-hinnant-date
    nix
  ];

  passthru.tests =
    let
      localRepoCheck =
        nixOverride:
        runCommand "localRepoCheck-${nixOverride.name}"
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
                --option plugin-files ${
                  nix-plugin-pijul.override { inherit nixOverride; }
                }/lib/nix/plugins/pijul.so \
                --extra-experimental-features 'nix-command flakes' \
                eval --impure --raw --expr "builtins.readFile ((builtins.fetchTree \"pijul+file://$PWD\") + \"/foo\")"
            )

            echo $output

            [[ "$output" = "it works" ]]

            mkdir $out
          '';
    in
    {
      stable = localRepoCheck nixVersions.stable;
      latest = localRepoCheck nixVersions.latest;
      git = localRepoCheck nixVersions.git;
      nix_2_24 = localRepoCheck nixVersions.nix_2_24;
    };

  meta = {
    description = "Plugin to add Pijul support to the Nix package manager";
    homepage = "https://nest.pijul.com/dblsaiko/nix-plugin-pijul";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.dblsaiko ];
    platforms = lib.platforms.unix;
  };
})

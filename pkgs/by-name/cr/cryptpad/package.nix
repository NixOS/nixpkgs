{
  bash,
  buildNpmPackage,
  coreutils,
  fetchFromGitHub,
  fetchpatch,
  fetchurl,
  lib,
  makeBinaryWrapper,
  nixosTests,
  nodejs,
  rdfind,
  unzip,
}:

let
  version = "2025.6.0";
  # nix version of install-onlyoffice.sh
  # a later version could rebuild from sdkjs/web-apps as per
  # https://github.com/cryptpad/onlyoffice-builds/blob/main/build.sh
  onlyoffice_fetch =
    {
      rev ? null,
      version ? null,
      hash,
      ...
    }:
    assert (
      lib.assertMsg (lib.xor (rev == null) (
        version == null
      )) "onlyoffice_fetch requires one of either `rev` or `version` to be provided (not both)."
    );
    if rev != null then
      fetchFromGitHub {
        inherit rev hash;
        owner = "cryptpad";
        repo = "onlyoffice-builds";
      }
    # New method for v7+ versions that use ZIP releases
    else
      fetchurl {
        url = "https://github.com/cryptpad/onlyoffice-editor/releases/download/${version}/onlyoffice-editor.zip";
        inherit hash;
      };

  onlyoffice_install = oo: ''
    oo_dir="$out_cryptpad/www/common/onlyoffice/dist/${oo.subdir}"
    ${
      if oo ? "version" then
        ''
          mkdir -p "$oo_dir"
          unzip ${onlyoffice_fetch oo} -d "$oo_dir"
          echo "${oo.version}" > "$oo_dir/.version"

          # Clean up help files and dictionaries as per upstream
          ${lib.optionalString (oo.subdir == "v7") ''
            rm -rf "$oo_dir"/web-apps/apps/*/main/resources/help
            rm -rf "$oo_dir"/dictionaries/
          ''}
        ''
      else
        ''
          cp -a "${onlyoffice_fetch oo}/." "$oo_dir"
          chmod -R +w "$oo_dir"
          echo "${oo.rev}" > "$oo_dir/.commit"

          # Clean up help files as per upstream
          rm -rf "$oo_dir"/web-apps/apps/*/main/resources/help
        ''
    }
  '';
  onlyoffice_versions = [
    {
      subdir = "v1";
      rev = "4f370beb";
      hash = "sha256-TE/99qOx4wT2s0op9wi+SHwqTPYq/H+a9Uus9Zj4iSY=";
    }
    {
      subdir = "v2b";
      rev = "d9da72fd";
      hash = "sha256-SiRDRc2vnLwCVnvtk+C8PKw7IeuSzHBaJmZHogRe3hQ=";
    }
    {
      subdir = "v4";
      rev = "6ebc6938";
      hash = "sha256-eto1+8Tk/s3kbUCpbUh8qCS8EOq700FYG1/KiHyynaA=";
    }
    {
      subdir = "v5";
      rev = "88a356f0";
      hash = "sha256-8j1rlAyHlKx6oAs2pIhjPKcGhJFj6ZzahOcgenyeOCc=";
    }
    {
      subdir = "v6";
      rev = "abd8a309";
      hash = "sha256-BZdExj2q/bqUD3k9uluOot2dlrWKA+vpad49EdgXKww=";
    }
    {
      subdir = "v7";
      version = "v7.3.3.60+11";
      hash = "sha256-He8RwsaJPBhaxFklA7vSxxNUpmcM41lW859gQUUJWbQ=";
    }
    {
      subdir = "v8";
      version = "v8.3.3.23+4";
      hash = "sha256-DeK84fa7Jc1L1+vF8LBKLXM5oWS0SV2qBnAWG3Xzu4U=";
    }
  ];

  x2t_version = "v7.3+1";
  x2t = fetchurl {
    url = "https://github.com/cryptpad/onlyoffice-x2t-wasm/releases/download/${x2t_version}/x2t.zip";
    hash = "sha256-hrbxrI8RC1pBatGZ76TAiVfUbZid7+eRuXk6lmz7OgQ=";
  };
  x2t_install = ''
    local X2T_DIR=$out_cryptpad/www/common/onlyoffice/dist/x2t
    unzip ${x2t} -d "$X2T_DIR"
    echo "${x2t_version}" > "$X2T_DIR"/.version
  '';

in
buildNpmPackage {
  inherit version;
  pname = "cryptpad";

  src = fetchFromGitHub {
    owner = "cryptpad";
    repo = "cryptpad";
    tag = version;
    hash = "sha256-R8Oonrnb1tqvl1zTkWv5Xv/f8bFtUljD6X/re72IvsU=";
  };

  npmDepsHash = "sha256-4Zr+8ANZJ9XX2umY/SY7BrEHPheVelFSeZipgOaW6bI==";

  nativeBuildInputs = [
    makeBinaryWrapper
    rdfind
    unzip
    bash
  ];

  patches = [
    # fix httpSafePort setting
    # https://github.com/cryptpad/cryptpad/pull/1571
    ./0001-env.js-fix-httpSafePort-handling.patch
  ];

  # cryptpad build tries to write in cache dir
  makeCacheWritable = true;

  # 'npm build run' (scripts/build.js) generates a customize directory, but:
  # - that is not installed by npm install
  # - it embeds values from config into the directory, so needs to be
  # run before starting the server (it's just a few quick replaces)
  # Skip it here.
  dontNpmBuild = true;

  postInstall = ''
    out_cryptpad="$out/lib/node_modules/cryptpad"

    # 'npm run install:components' (scripts/copy-component.js) copies
    # required node modules to www/component in the build tree...
    # Move to install directory manually.
    npm run install:components
    mv www/components "$out_cryptpad/www/"
    # optimization: replace copies with symlinks...
    for d in "$out_cryptpad/www/components/"*; do
      d="''${d##*/}"
      [ -e "$out_cryptpad/node_modules/$d" ] || continue
      rm -rf "$out_cryptpad/www/components/$d"
      ln -Tfs "../../node_modules/$d" "$out_cryptpad/www/components/$d"
    done

    # install OnlyOffice (install-onlyoffice.sh without network)
    mkdir -p "$out_cryptpad/www/common/onlyoffice/dist"
    ${lib.concatMapStringsSep "\n" onlyoffice_install onlyoffice_versions}
    ${x2t_install}
    # Run upstream's `install-onlyoffice.sh` script in `--check` mode to
    # verify that we've installed the correct versions of the various
    # OnlyOffice components.

    # TODO: Patch the new install method to only verify versions;
    # patchShebangs --build $out_cryptpad/install-onlyoffice.sh
    # $out_cryptpad/install-onlyoffice.sh --accept-license --check --rdfind

    # cryptpad assumes it runs in the source directory and also outputs
    # its state files there, which is not exactly great for us.
    # There are relative paths everywhere so just substituing source paths
    # is difficult and will likely break on a future update, instead we
    # make links to the required source directories before running.
    # The build.js step populates 'customize' from customize.dist and config;
    # one would normally want to re-run it after modifying config but since it
    # would overwrite user modifications only run it if there is no customize
    # directory.
    makeWrapper "${lib.getExe nodejs}" "$out/bin/cryptpad" \
      --add-flags "$out_cryptpad/server.js" \
      --run "for d in src customize.dist lib www scripts; do ${coreutils}/bin/ln -sf \"$out_cryptpad/\$d\" .; done" \
      --run "if ! [ -d customize ]; then \"${lib.getExe nodejs}\" \"$out_cryptpad/scripts/build.js\"; fi"
  '';

  passthru.tests.cryptpad = nixosTests.cryptpad;

  meta = {
    description = "Collaborative office suite, end-to-end encrypted and open-source";
    homepage = "https://cryptpad.org/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "cryptpad";
    maintainers = with lib.maintainers; [ martinetd ];
  };
}

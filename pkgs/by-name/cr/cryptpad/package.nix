{
  bash,
  buildNpmPackage,
  coreutils,
  fetchFromGitHub,
  fetchurl,
  lib,
  makeBinaryWrapper,
  nixosTests,
  nodejs,
  rdfind,
  unzip,
  # Cryptpad supports multiple versions of onlyoffice:
  # - the latest version is always used for new documents
  # - old versions are used whenever opening a file that was created with an
  # older version, at that point cryptpad coverts it to the latest version.
  #
  # The first version supported in nixpkgs came with v7 installed so no
  # document have been created with an older version and we don't need
  # anything earlier for nixos installs, but if someone wishes to migrate
  # from an older instance to nixos they might need to use an older version
  # so we still allow installing all the way back to v1.
  # Older versions are not tested and might be removed in the future.
  oldest_needed_version ? "v7",
  withSSO ? true,
}:

let
  version = "2026.10.0";
  # nix version of install-office.sh
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
      if lib.versionOlder oo.subdir oldest_needed_version then
        ''
          echo "Skipping onlyoffice ${oo.subdir} (< ${oldest_needed_version})"
        ''
      else if oo ? "version" then
        ''
          mkdir -p "$oo_dir"
          echo "Installing onlyoffice ${oo.subdir}"
          unzip -q ${onlyoffice_fetch oo} -d "$oo_dir"
          echo "${oo.version}" > "$oo_dir/.version"

          # Clean up help files and dictionaries as per upstream
          ${lib.optionalString
            (lib.elem oo.subdir [
              "v7"
              "v8"
            ])
            ''
              rm -rf "$oo_dir"/web-apps/apps/*/main/resources/help
            ''
          }
          ${lib.optionalString (oo.subdir == "v7") ''
            rm -rf "$oo_dir"/dictionaries/
          ''}
        ''
      else
        ''
          echo "Installing onlyoffice ${oo.subdir}"
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
      version = "v8.3.3.23+5";
      hash = "sha256-+53jzvmGltD1yjXAimLl8zL1V4YDc1qF1PUFSeyiUm8=";
    }
    {
      # Euro-Office (OnlyOffice fork) since 2026.10.0.
      # sha512 is the checksum from upstream's install-office.sh.
      subdir = "v9";
      version = "v9.3.2+3";
      hash = "sha512-GBl4F25EO5/5zOEn5qqWaKTujoFHPLDAxM8Ng96ptmNscw1A5wTr6P3zE0mKMQa6/lxAIa6TeyadBaB7e+a7tA==";
    }
  ];

  x2t_version = "v9.3.2+3";
  x2t = fetchurl {
    url = "https://github.com/cryptpad/onlyoffice-x2t-wasm/releases/download/${x2t_version}/x2t.zip";
    hash = "sha512-7QV5CXoCaYd9ZiKyix4nGOH59OismTAfXxP18FKz2yTbeJ3quMZUBE21iL4QPBOb50+DoMoGbe4XiVIiQcGvbg==";
  };
  x2t_install = ''
    echo "Installing x2t"
    local X2T_DIR=$out_cryptpad/www/common/onlyoffice/dist/x2t
    unzip -q ${x2t} -d "$X2T_DIR"
    echo "${x2t_version}" > "$X2T_DIR"/.version
  '';

  sso = buildNpmPackage (finalAttrs: {
    pname = "cryptpad-sso";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "cryptpad";
      repo = "sso";
      tag = finalAttrs.version;
      hash = "sha256-Tqzevoy+I7bSskQtgkIWoZBbd/cy4/tIJBwgNmmzAHM=";
    };

    npmDepsHash = "sha256-dsxMiK/yD5v+u930itDFGfm1XCpTYFm/Vljis6lM6Qk=";
    npmDepsFetcherVersion = 2;

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r ./. $out/
      runHook postInstall
    '';
  });

in
buildNpmPackage {
  inherit version;
  pname = "cryptpad";

  src = fetchFromGitHub {
    owner = "cryptpad";
    repo = "cryptpad";
    tag = version;
    hash = "sha256-wrF1Cyrqvq0OvrW7YUmrv3D3SEPYSkWG4APCZmin1PU=";
    # case-insensitive file results in different hash on darwin, delete to avoid collision
    postFetch = ''
      find $out -iname "funding.json" -delete
    '';
  };

  npmDepsHash = "sha256-QNI/nkF0Mkzh3I9inB2h1qoowyohPTy833WK7UgC+0A=";
  npmDepsFetcherVersion = 2;

  nativeBuildInputs = [
    makeBinaryWrapper
    rdfind
    unzip
    bash
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

    # install OnlyOffice (install-office.sh without network)
    mkdir -p "$out_cryptpad/www/common/onlyoffice/dist"
    ${lib.concatMapStringsSep "\n" onlyoffice_install onlyoffice_versions}
    ${x2t_install}
    # Run upstream's `install-office.sh` script in `--check` mode to
    # verify that we've installed the correct versions of the various
    # OnlyOffice components.

    patchShebangs --build $out_cryptpad/install-office.sh
    mkdir -p $out_cryptpad/onlyoffice-conf
    # Need to set this before running the check script
    echo oldest_needed_version=${oldest_needed_version} > $out_cryptpad/onlyoffice-conf/onlyoffice.properties
    $out_cryptpad/install-office.sh --accept-license --check --rdfind

    ${lib.optionalString withSSO ''
      echo "Installing SSO plugin ${sso.version}"
      mkdir -p "$out_cryptpad/lib/plugins/sso"
      cp -a "${sso}/." "$out_cryptpad/lib/plugins/sso"
      chmod -R +w "$out_cryptpad/lib/plugins/sso"
    ''}

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

  passthru = {
    inherit sso;
    tests.cryptpad = nixosTests.cryptpad;
  };

  meta = {
    description = "Collaborative office suite, end-to-end encrypted and open-source";
    homepage = "https://cryptpad.org/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "cryptpad";
    maintainers = with lib.maintainers; [ martinetd ];
  };
}

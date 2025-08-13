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
  version = "2025.3.0";
  # nix version of install-onlyoffice.sh
  # a later version could rebuild from sdkjs/web-apps as per
  # https://github.com/cryptpad/onlyoffice-builds/blob/main/build.sh
  onlyoffice_build =
    rev: hash:
    fetchFromGitHub {
      inherit rev hash;
      owner = "cryptpad";
      repo = "onlyoffice-builds";
    };
  onlyoffice_install = oo: ''
    oo_dir="$out_cryptpad/www/common/onlyoffice/dist/${oo.subdir}"
    cp -a "${onlyoffice_build oo.rev oo.hash}/." "$oo_dir"
    chmod -R +w "$oo_dir"
    echo "${oo.rev}" > "$oo_dir/.commit"
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
      rev = "e1267803";
      hash = "sha256-iIds0GnCHAyeIEdSD4aCCgDtnnwARh3NE470CywseS0=";
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
    rev = version;
    hash = "sha256-NxkVMsfLzdzifdn+f0C6mBJGd1oLwcMTAIXv+gBG7rI=";
  };

  npmDepsHash = "sha256-GWkyRlizPSA72WwoY+mRLwaMeD/SXdo6oUVwsd2gp7c=";

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
    # and fix absolute symlink to /build...
    ln -Tfs ../../src/tweetnacl "$out_cryptpad/www/components/tweetnacl"

    # install OnlyOffice (install-onlyoffice.sh without network)
    mkdir -p "$out_cryptpad/www/common/onlyoffice/dist"
    ${lib.concatMapStringsSep "\n" onlyoffice_install onlyoffice_versions}
    ${x2t_install}
    # Run upstream's `install-onlyoffice.sh` script in `--check` mode to
    # verify that we've installed the correct versions of the various
    # OnlyOffice components.
    patchShebangs --build $out_cryptpad/install-onlyoffice.sh
    $out_cryptpad/install-onlyoffice.sh --accept-license --check --rdfind

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
      --run "for d in customize.dist lib www scripts; do ${coreutils}/bin/ln -sf \"$out_cryptpad/\$d\" .; done" \
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

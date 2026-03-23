# Make sure that the "with-gce" flag is set when building `google-cloud-sdk`
# for GCE hosts. This flag prevents "google-compute-engine" from being a
# default dependency which is undesirable because this package is
#
#   1) available only on GNU/Linux (requires `systemd` in particular)
#   2) intended only for GCE guests (and is useless elsewhere)
#   3) used by `google-cloud-sdk` only on GCE guests
#

{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  python312,
  openssl,
  jq,
  callPackage,
  installShellFiles,
  with-gce ? false,
  # NumPy is an optional runtime dependency and only needed for IAP TCP forwarding
  # https://cloud.google.com/iap/docs/using-tcp-forwarding#increasing_the_tcp_upload_bandwidth
  with-numpy ? true,
}:

let
  python3 = python312;
  # include a compatible pyopenssl version: https://github.com/NixOS/nixpkgs/issues/379291
  # remove ASAP: https://github.com/googleapis/google-api-python-client/issues/2554
  pythonCustom = python3.override {
    self = pythonCustom;
    packageOverrides = _: super: {
      pyopenssl = super.pyopenssl.overridePythonAttrs (old: rec {
        version = "24.2.1";
        src = old.src.override {
          tag = version;
          hash = "sha256-/TQnDWdycN4hQ7ZGvBhMJEZVafmL+0wy9eJ8hC6rfio=";
        };
        # 36 failed tests
        doCheck = false;
      });
    };
  };

  pythonEnv = pythonCustom.withPackages (
    p:
    with p;
    [
      cffi
      cryptography
      pyopenssl
      crcmod
      grpcio
    ]
    ++ lib.optional with-gce google-compute-engine
    ++ lib.optional with-numpy numpy
  );

  data = import ./data.nix { };
  sources = system: data.googleCloudSdkPkgs.${system} or (throw "Unsupported system: ${system}");

  components = callPackage ./components.nix {
    snapshotPath = ./components.json;
  };

  withExtraComponents = callPackage ./withExtraComponents.nix { inherit components; };

in
stdenv.mkDerivation rec {
  pname = "google-cloud-sdk";
  inherit (data) version;

  src = fetchurl (sources stdenv.hostPlatform.system);

  buildInputs = [ python3 ];

  nativeBuildInputs = [
    jq
    makeWrapper
    installShellFiles
  ];

  patches = [
    # For kubectl configs, don't store the absolute path of the `gcloud` binary as it can be garbage-collected
    ./gcloud-path.patch
    # Disable checking for updates for the package
    ./gsutil-disable-updates.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/google-cloud-sdk
    if [ -d platform/bundledpythonunix ]; then
      rm -r platform/bundledpythonunix
    fi
    cp -R * .install $out/google-cloud-sdk/

    mkdir -p $out/google-cloud-sdk/lib/surface/{alpha,beta}
    cp ${./alpha__init__.py} $out/google-cloud-sdk/lib/surface/alpha/__init__.py
    cp ${./beta__init__.py} $out/google-cloud-sdk/lib/surface/beta/__init__.py

    # create wrappers with correct env
    for program in gcloud bq gsutil git-credential-gcloud.sh docker-credential-gcloud; do
        programPath="$out/google-cloud-sdk/bin/$program"
        binaryPath="$out/bin/$program"
        wrapProgram "$programPath" \
            --set CLOUDSDK_PYTHON "${pythonEnv}/bin/python" \
            --set CLOUDSDK_PYTHON_ARGS "-S -B -W ignore" \
            --prefix PYTHONPATH : "${pythonEnv}/${python3.sitePackages}" \
            --prefix PATH : "${openssl.bin}/bin"

        mkdir -p $out/bin
        ln -s $programPath $binaryPath
    done

    # disable component updater and update check
    substituteInPlace $out/google-cloud-sdk/lib/googlecloudsdk/core/config.json \
      --replace-fail "\"disable_updater\": false" "\"disable_updater\": true"
    echo "
    [component_manager]
    disable_update_check = true" >> $out/google-cloud-sdk/properties

    # setup bash completion
    mkdir -p $out/share/bash-completion/completions
    mv $out/google-cloud-sdk/completion.bash.inc $out/share/bash-completion/completions/gcloud
    ln -s $out/share/bash-completion/completions/gcloud $out/share/bash-completion/completions/gsutil

    # setup zsh completion
    mkdir -p $out/share/zsh/site-functions
    mv $out/google-cloud-sdk/completion.zsh.inc $out/share/zsh/site-functions/_gcloud
    ln -s $out/share/zsh/site-functions/_gcloud $out/share/zsh/site-functions/_gsutil
    # zsh doesn't load completions from $FPATH without #compdef as the first line
    sed -i '1 i #compdef gcloud' $out/share/zsh/site-functions/_gcloud

    # setup fish completion
    installShellCompletion --cmd gcloud \
      --fish <(echo "complete -c gcloud -f -a '(__fish_argcomplete_complete gcloud)'")
    installShellCompletion --cmd gsutil \
      --fish <(echo "complete -c gsutil -f -a '(__fish_argcomplete_complete gsutil)'")

    # This directory contains compiled mac binaries. We used crcmod from
    # nixpkgs instead.
    rm -r $out/google-cloud-sdk/platform/gsutil/third_party/crcmod \
          $out/google-cloud-sdk/platform/gsutil/third_party/crcmod_osx

    # remove tests and test data
    find $out -name tests -type d -exec rm -rf '{}' +
    rm $out/google-cloud-sdk/platform/gsutil/gslib/commands/test.py

    # compact all the JSON
    find $out -name \*.json | while read path; do
      jq -c . $path > $path.min
      mv $path.min $path
    done

    runHook postInstall
  '';

  postInstall = ''
    # create cached byte-code at build time, see https://docs.python.org/3/library/compileall.html
    # the excluded files contain python 2 syntax that fails to compile with python 3
    find $out/google-cloud-sdk -name "*.py" \
      -not -path "*/lib/third_party/yaml/scanner.py" \
      -not -path "*/lib/third_party/yaml/error.py" \
      -not -path "*/lib/third_party/yaml/constructor.py" \
      -not -path "*/lib/third_party/yaml/parser.py" \
      -not -path "*/lib/third_party/yaml/reader.py" \
      -not -path "*/lib/third_party/yaml/loader.py" \
      -not -path "*/lib/third_party/yaml/resolver.py" \
      -not -path "*/yaml/lib2/scanner.py" \
      -not -path "*/yaml/lib2/constructor.py" \
      -not -path "*/yaml/lib2/reader.py" \
      -not -path "*/yaml/lib2/resolver.py" \
      -not -path "*/gcloud_crcmod/python2/crcmod.py" \
      -not -path "*/gcloud_crcmod/python2/_crcfunpy.py" \
      -not -path "*/concurrent/python2/concurrent/futures/_base.py" \
      -not -path "*/third_party/gflags/__init__.py" \
      -not -path "*/third_party/gflags/setup.py" \
      -not -path "*/third_party/gflags/gflags2man.py" \
      -not -path "*/third_party/apitools/setup.py" \
      -not -path "*/third_party/apitools/ez_setup.py" \
      -not -path "*/lib/third_party/pytz/lazy.py" \
      -not -path "*/lib/third_party/fancy_urllib/__init__.py" \
      -not -path "*/oauth2client/_pkce.py" \
      -not -path "*/ext-runtime/nodejs/test/runtime_test.py" \
      -exec ${pythonEnv}/bin/python -OO -m compileall {} +
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # Avoid trying to write logs to homeless-shelter
    export HOME=$(mktemp -d)
    $out/bin/gcloud version --format json | jq '."Google Cloud SDK"' | grep "${version}"
    $out/bin/gsutil version | grep -w "$(cat platform/gsutil/VERSION)"
  '';

  passthru = {
    inherit components withExtraComponents;
    updateScript = ./update.sh;
  };

  meta = {
    description = "Tools for the google cloud platform";
    longDescription = "The Google Cloud SDK for GCE hosts. Used by `google-cloud-sdk` only on GCE guests.";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # anthoscli and possibly more
    ];
    # This package contains vendored dependencies. All have free licenses.
    license = lib.licenses.free;
    homepage = "https://cloud.google.com/sdk/";
    changelog = "https://cloud.google.com/sdk/docs/release-notes";
    maintainers = with lib.maintainers; [
      iammrinal0
      marcusramberg
      pradyuman
      stephenmw
      zimbatm
      ryan4yin
    ];
    platforms = builtins.attrNames data.googleCloudSdkPkgs;
    mainProgram = "gcloud";
  };
}

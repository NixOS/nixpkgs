{ lib
, pkgs
, stdenv
, writeScript
, writeShellScript
, nix
, gradle
, openssl
, mitm-cache
, jdk
, nsjail
, path
, python3
}:

# path to the derivation attr (usually the package name)
{ attrPath ? pname
# pname (attrPath synonym)
, pname ? ""
# the Nix code to get the derivation (this will be put in Bash double quotes)
# this is relevant for downstream (non-nixpkgs) users
, code ? "with import ./. { }; ($attrPath)"
# unlike gradleFlags in normal packages, these flags are escaped so they are allowed to contain spaces
# also, gradleFlags from configurePhase are used by default
, gradleFlags ? []
# attribute overrides for the "source" derivation
, attrOverrides ? {}
# run before fetching the dependencies (in sandbox)
, preBuild ? ""
# run before starting the sandbox for fetching dependencies
, preBuildNoSandbox ? ""
# the gradle commands for fetching the necessary dependencies
, gradleCommands ? "gradle nixDownloadDeps"
# run after fetching the dependencies (in sandbox)
, postBuild ? ""
# run after the sandbox for fetching dependencies has stopped
, postBuildNoSandbox ? ""
, mitmCachePort ? 1337
# deps path (relative to the package directory), or absolute
, depsPath ? "deps.json"
# extra packages to make available in the sandbox
, availablePackages ? [ ]
}:

let
  keep = [ "MITM_CACHE_PORT" "MITM_CACHE_KEYSTORE" "MITM_CACHE_KS_PWD" "MITM_CACHE_CA" ];
  availablePackages' = map (drv: ''(builtins.storePath "${drv}")'') availablePackages;
  gradleScript = writeScript "gradle-commands.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell --pure ${lib.concatMapStringsSep " " (x: "--keep ${x}") keep} -i bash -p coreutils ${lib.concatStringsSep " " availablePackages'}
    set -eo pipefail
    source="$1"
    gradleArgs=(
      ${lib.escapeShellArgs gradleFlags}
      --no-daemon
      --console plain
      --init-script ${./init-deps.gradle}
      -Dhttp.proxyHost="127.0.0.1"
      -Dhttps.proxyHost="127.0.0.1"
      -Dhttp.proxyPort="$MITM_CACHE_PORT"
      -Dhttps.proxyPort="$MITM_CACHE_PORT"
      -Djavax.net.ssl.trustStore="$MITM_CACHE_KEYSTORE"
      -Djavax.net.ssl.trustStorePassword="$MITM_CACHE_KS_PWD"
    )
    unset MITM_CACHE_KEYSTORE
    unset MITM_CACHE_KS_PWD
    function gradle() {
      ${gradle}/bin/gradle $gradleFlags "''${gradleFlagsArray[@]}" "''${gradleArgs[@]}" "$@"
    }
    export GRADLE_USER_HOME="$(mktemp -d)"
    export TERM=dumb
    trap "rm -rf '$GRADLE_USER_HOME'" EXIT
    export http_proxy="127.0.0.1:$MITM_CACHE_PORT"
    export https_proxy="127.0.0.1:$MITM_CACHE_PORT"
    export NIX_SSL_CERT_FILE="$MITM_CACHE_CA"
    export SSL_CERT_FILE="$MITM_CACHE_CA"
    SRC="$(mktemp -d)"
    trap "rm -rf '$SRC'" EXIT
    cp -r "$source/src" "$SRC/"
    chmod -R +w "$SRC/src"
    cd "$SRC/src"
    source "$source/script2"
    ${preBuild}
    ${gradleCommands}
    ${postBuild}
  '';
in
writeShellScript "fetch-deps.sh" ''
  set -eo pipefail
  ${lib.optionalString (lib.hasInfix "$attrPath" code) ''
    attrPath=${lib.escapeShellArg attrPath}
    [[ -n "$attrPath" ]] || attrPath="$1"
    [[ -n "$attrPath" ]] || attrPath="$UPDATE_NIX_ATTR_PATH"
    [[ -n "$attrPath" ]] || (echo "Set UPDATE_NIX_ATTR_PATH or pass attr path as the first argument!" && exit 1)
  ''}
  outPath="${
    # if this is an absolute path in nix store, use path relative to the output root
    if lib.hasPrefix "/nix/store/" (toString depsPath)
    then builtins.concatStringsSep "/" (lib.drop 4 (lib.splitString "/" (toString depsPath)))
    # if this is an absolute path, just use that path
    else if lib.hasPrefix "/" (toString depsPath)
    then depsPath
    # otherwise, use a path relative to the package
    else ''$(nix-instantiate --eval -E "dirOf (with (${code}); meta.position)" | tr -d '"')/${depsPath}''
  }"

  source="$(nix-build --no-out-link -E "import ${./patched-source.nix} ({ self = ${code}; } // builtins.fromJSON "${
    lib.escapeShellArg (builtins.toJSON (builtins.toJSON attrOverrides))
  }")")"

  source "$source/script1"
  pushd "$(mktemp -d)"
  MITM_CACHE_DIR="$PWD"
  trap "rm -rf '$MITM_CACHE_DIR'" EXIT
  ${openssl}/bin/openssl genrsa -out ca.key 2048
  ${openssl}/bin/openssl req -x509 -new -nodes -key ca.key -sha256 -days 1 -out ca.cer -subj "/C=AL/ST=a/L=a/O=a/OU=a/CN=example.org"
  export MITM_CACHE_PORT="''${mitmCachePort:-${toString mitmCachePort}}"
  ${mitm-cache}/bin/mitm-cache \
    -l"127.0.0.1:$MITM_CACHE_PORT" \
    record \
    --reject '\.(md5|sha(1|256|512:?):?)$' \
    --forget-redirects-from '://(download\.savannah\.gnu\.org|github\.com|packages\.jetbrains\.team|sourceforge\.net:?)/' \
    --forget-redirects-to '://(cdn\.jsdelivr\.net|plugins-artifacts\.gradle\.org:?)/' \
    --record-text '/maven-metadata\.xml$' >/dev/null 2>/dev/null &
  MITM_CACHE_PID="$!"
  trap "kill '$MITM_CACHE_PID'" EXIT
  sleep 0.5
  ps -p "$MITM_CACHE_PID" >/dev/null || (echo "Failed to launch mitm-cache! Port $MITM_CACHE_PORT may be already used. Try setting "'$mitmCachePort' && exit 1)
  export MITM_CACHE_CA="$PWD/ca.cer"
  export MITM_CACHE_KS_PWD="$(head -c10 /dev/random | base32)"
  echo y | ${jdk}/bin/keytool -importcert -file ca.cer -alias alias -keystore keystore -storepass "$MITM_CACHE_KS_PWD"
  export MITM_CACHE_KEYSTORE="$PWD/keystore"
  popd
  ${preBuildNoSandbox}
  # nsjail isn't necessary, it's only used to prevent messy build scripts from touching ~
  ${nsjail}/bin/nsjail \
    -N --keep_caps --chroot / --disable_rlimits \
    -T /home -T /root -R ${path} \
    ${lib.escapeShellArgs (map (x: "-E${x}") keep)} \
    -E NIX_PATH=nixpkgs=${path} \
    ${gradleScript} "$source"
  ${postBuildNoSandbox}
  kill -SIGINT "$MITM_CACHE_PID"
  for i in {0..20}; do
    if [ -f "$MITM_CACHE_DIR/out.json" ]; then
      sleep 1
      cp "$MITM_CACHE_DIR/out.json" _tmp_deps.json
      exec ${lib.getExe python3} ${./compress-deps-json.py} _tmp_deps.json "$outPath"
      rm _tmp_deps.json
    fi
    sleep 1
  done
  exit 1
''

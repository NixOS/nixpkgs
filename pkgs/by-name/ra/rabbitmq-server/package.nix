{
  lib,
  beamPackages,
  stdenv,
  fetchurl,
  python3,
  libxml2,
  libxslt,
  xmlto,
  docbook_xml_dtd_45,
  docbook_xsl,
  zip,
  unzip,
  rsync,
  getconf,
  socat,
  procps,
  coreutils,
  gnused,
  systemd,
  glibcLocales,
  nixosTests,
  which,
}:

let
  runtimePath = lib.makeBinPath (
    [
      beamPackages.erlang
      getconf # for getting memory limits
      socat
      gnused
      coreutils # used by helper scripts
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      procps # the built-in macOS version has extra entitlements to read rss
      systemd # for systemd unit activation check
    ]
  );
in

stdenv.mkDerivation rec {
  pname = "rabbitmq-server";
  version = "4.0.9";

  # when updating, consider bumping elixir version in all-packages.nix
  src = fetchurl {
    url = "https://github.com/rabbitmq/rabbitmq-server/releases/download/v${version}/${pname}-${version}.tar.xz";
    hash = "sha256-imBxBn8RQS0jBGfT5KLLLt+fKvyybzLzPZu9DpFOos8=";
  };

  nativeBuildInputs = [
    unzip
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    zip
    rsync
    python3
    which
  ];

  buildInputs = [
    beamPackages.erlang
    beamPackages.elixir
    libxml2
    libxslt
    glibcLocales
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "RMQ_ERLAPP_DIR=${placeholder "out"}"
  ];

  installTargets = [
    "install"
    "install-man"
  ];

  preBuild = ''
    export LANG=C.UTF-8 # fix elixir locale warning
    export PROJECT_VERSION="$version"
  '';

  postInstall = ''
    # rabbitmq-env calls to sed/coreutils, so provide everything early
    sed -i $out/sbin/rabbitmq-env -e '2s|^|PATH=${runtimePath}\''${PATH:+:}\$PATH/\n|'

    # We know exactly where rabbitmq is gonna be, so we patch that into the env-script.
    # By doing it early we make sure that auto-detection for this will
    # never be executed (somewhere below in the script).
    sed -i $out/sbin/rabbitmq-env -e "2s|^|RABBITMQ_SCRIPTS_DIR=$out/sbin\n|"

    # there’s a few stray files that belong into share
    mkdir -p $doc/share/doc/rabbitmq-server
    mv $out/LICENSE* $doc/share/doc/rabbitmq-server

    # and an unecessarily copied INSTALL file
    rm $out/INSTALL
  '';

  # Can not use versionCheckHook since that doesn't allow for setting environment variables
  # which is necessary since Erlang needs a $HOME for the Cookie.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    out="$(env - LANG=C.utf8 HOME=$TMPDIR ${placeholder "out"}/bin/rabbitmqctl version)"
    if [[ "$out" != "$version" ]]; then
      echo "Rabbitmq should report version $version, but thinks it's version $out" >&2
      exit 1
    fi
    runHook postInstallCheck
  '';

  # Needed for the check in installCheckPhase
  __darwinAllowLocalNetworking = true;

  passthru.tests = {
    vm-test = nixosTests.rabbitmq;
  };

  meta = {
    homepage = "https://www.rabbitmq.com/";
    description = "Implementation of the AMQP messaging protocol";
    changelog = "https://github.com/rabbitmq/rabbitmq-server/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ samueltardieu ];
  };
}

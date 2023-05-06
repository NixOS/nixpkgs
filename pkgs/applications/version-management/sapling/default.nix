{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, fetchurl
, sd
, curl
, pkg-config
, openssl
, rustPlatform
, fetchYarnDeps
, yarn
, nodejs
, fixup_yarn_lock
, glibcLocales
, libiconv
, CoreFoundation
, CoreServices
, Security

, enableMinimal ? false
}:

let
  inherit (lib.importJSON ./deps.json) links version versionHash;
  # Sapling sets a Cargo config containing lines like so:
  # [target.aarch64-apple-darwin]
  # rustflags = ["-C", "link-args=-Wl,-undefined,dynamic_lookup"]
  #
  # The default cargo config that's set by the build hook will set
  # unstable.host-config and unstable.target-applies-to-host which seems to
  # result in the link arguments above being ignored and thus link failures.
  # All it is there to do anyway is just to do stuff with musl and cross
  # compilation, which doesn't work on macOS anyway so we can just stub it
  # on macOS.
  #
  # See https://github.com/NixOS/nixpkgs/pull/198311#issuecomment-1326894295
  myCargoSetupHook = rustPlatform.cargoSetupHook.overrideAttrs (old: {
    cargoConfig = if stdenv.isDarwin then "" else old.cargoConfig;
  });

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "sapling";
    rev = version;
    hash = "sha256-r15qzyMoZDCkSnYp69bOR2wuweIcbDc7F3FibBVE/qM=";
  };

  addonsSrc = "${src}/addons";

  # Fetches the Yarn modules in Nix to to be used as an offline cache
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${addonsSrc}/yarn.lock";
    sha256 = "sha256-cEIij7hocCSPw1Q1ESI/t9IFmLM0Nbr/IjSz3HzBdzU=";
  };

  # Builds the NodeJS server that runs with `sl web`
  isl = stdenv.mkDerivation {
    pname = "sapling-isl";
    src = addonsSrc;
    inherit version;

    nativeBuildInputs = [
      fixup_yarn_lock
      nodejs
      yarn
    ];

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      fixup_yarn_lock yarn.lock
      yarn config --offline set yarn-offline-mirror ${yarnOfflineCache}
      yarn install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
      patchShebangs node_modules

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cd isl
      node release.js $out

      runHook postInstall
    '';
  };
in
# Builds the main `sl` binary and its Python extensions
python3Packages.buildPythonApplication {
  pname = "sapling";
  inherit src version;

  sourceRoot = "source/eden/scm";

  # Upstream does not commit Cargo.lock
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "abomonation-0.7.3+smallvec1" = "sha256-AxEXR6GC8gHjycIPOfoViP7KceM29p2ZISIt4iwJzvM=";
      "cloned-0.1.0" = "sha256-bgI2/Sb+jKylPt5OqhfzcWGh1N8S0zFk/yYOwv461Io=";
      "fb303_core-0.0.0" = "sha256-Rd42P2PPPgk9ohg45Lq067KcJBJ3Bw3IroYsH0YNh6s=";
      "fbthrift-0.0.1+unstable" = "sha256-/d8EJoPlSHRlkE7/d5OEy2/SEmPQyS6eUInbm/zYWH8=";
      "serde_bser-0.3.1" = "sha256-tfkIGQKi+eRnBUYEmoc3m+mb93tFdh/g5FPUAXYRMVM=";
    };
  };
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  # Since the derivation builder doesn't have network access to remain pure,
  # fetch the artifacts manually and link them. Then replace the hardcoded URLs
  # with filesystem paths for the curl calls.
  postUnpack = ''
    mkdir $sourceRoot/hack_pydeps
    ${lib.concatStrings (map (li: "ln -s ${fetchurl li} $sourceRoot/hack_pydeps/${baseNameOf li.url}\n") links)}
    sed -i "s|https://files.pythonhosted.org/packages/[[:alnum:]]*/[[:alnum:]]*/[[:alnum:]]*/|file://$NIX_BUILD_TOP/$sourceRoot/hack_pydeps/|g" $sourceRoot/setup.py
  '';

  # Now, copy the "sl web" (aka edenscm-isl) results into the output of this
  # package, so that the command can actually work. NOTES:
  #
  # 1) This applies on all systems (so no conditional a la postFixup)
  # 2) This doesn't require any kind of fixup itself, so we leave it out
  #    of postFixup for that reason, too
  # 3) If asked, we optionally patch in a hardcoded path to the 'nodejs' package,
  #    so that 'sl web' always works
  # 4) 'sl web' will still work if 'nodejs' is in $PATH, just not OOTB
  preFixup = ''
    sitepackages=$out/lib/${python3Packages.python.libPrefix}/site-packages
    chmod +w $sitepackages
    cp -r ${isl} $sitepackages/edenscm-isl
  '' + lib.optionalString (!enableMinimal) ''
    chmod +w $sitepackages/edenscm-isl/run-isl
    substituteInPlace $sitepackages/edenscm-isl/run-isl \
      --replace 'NODE=node' 'NODE=${nodejs}/bin/node'
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    wrapProgram $out/bin/sl \
      --set LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive"
  '';

  nativeBuildInputs = [
    curl
    pkg-config
  ] ++ (with rustPlatform; [
    myCargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    curl
    libiconv
    CoreFoundation
    CoreServices
    Security
  ];

  HGNAME = "sl";
  SAPLING_OSS_BUILD = "true";
  SAPLING_VERSION_HASH = versionHash;

  # Python setuptools version 66 and newer does not support upstream Sapling's
  # version numbers (e.g. "0.2.20230124-180750-hf8cd450a"). Change the version
  # number to something supported by setuptools (e.g. "0.2.20230124").
  # https://github.com/facebook/sapling/issues/571
  SAPLING_VERSION = builtins.elemAt (builtins.split "-" version) 0;

  # just a simple check phase, until we have a running test suite. this should
  # help catch issues like lack of a LOCALE_ARCHIVE setting (see GH PR #202760)
  doCheck = true;
  installCheckPhase = ''
    echo -n "testing sapling version; should be \"$SAPLING_VERSION\"... "
    $out/bin/sl version | grep -qw "$SAPLING_VERSION"
    echo "OK!"
  '';

  meta = with lib; {
    description = "A Scalable, User-Friendly Source Control System";
    homepage = "https://sapling-scm.com";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbar thoughtpolice ];
    platforms = platforms.unix;
    mainProgram = "sl";
  };
}
